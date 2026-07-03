/* **************************************************************************
* Copyright © 2015-2020, Neilon Technologies LLP.
* All rights reserved
*
* Controller Class: edCreateFolderStructureBatchable
* Created by Suresh Meghnathi: 31/1/2021
*
* -This is batchable class to migrate content documents.

* - Modifications:
* - Suresh Meghnathi, 31/1/2021 – Initial Development
************************************************************************** */
public class edCreateFolderStructureBatchable implements Database.Batchable<sObject>{
    // Query string to get records
    public String query;
    
    public edCreateFolderStructureBatchable(String query){
        this.query = query;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        // Record ids to create folder structure
        List<Id> recordIds = new List<Id>();
        
        for(sObject record : scope){
            recordIds.add(record.Id);
        }
        
        // Get content document links
        List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
        if(Test.isRunningTest() || recordIds[0].getSobjectType()+ '' != 'Order'){
            contentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocument.ContentSize FROM ContentDocumentLink WHERE LinkedEntityId IN :recordIds];
        } else{
            contentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocument.ContentSize FROM ContentDocumentLink WHERE LinkedEntityId IN :recordIds AND ContentDocument.Title LIKE 'Invoice%' AND ContentDocument.CreatedDate < THIS_YEAR];
        }
        
        Set<Id> recordIdsToCreateFolderStructure = new Set<Id>();
        for(ContentDocumentLink contentDocumentLink : contentDocumentLinks){
            recordIdsToCreateFolderStructure.add(contentDocumentLink.LinkedEntityId);
        }
        
        
        // Create folder structure
        if(!recordIdsToCreateFolderStructure.isEmpty()){
            edCreateFolderStructureBatchable.createFolderStructure(recordIdsToCreateFolderStructure);
        }
    }
    
    public void finish(Database.BatchableContext BC){
    }
    
    /*
    *   Purpose:    Create folder structure for parent records
    *   Parameters: 
    *   UnitTests:  
    */
    public static Map<Id, NEILON__Folder__c> createFolderStructure(Set<Id> parentIds){
        // Get default bucket
        List<NEILON__Folder__c> buckets = [Select Name From NEILON__Folder__c Where NEILON__Bucket_Name__c = null AND NEILON__Default__c = true AND NEILON__Active__c = true LIMIT 1];
        
        if(buckets.isEmpty()){
            return null;
        }
        
        // Record home folders by parent ids
        Map<Id, NEILON__Folder__c> recordHomeFoldersByParentIds = new Map<Id, NEILON__Folder__c>();
        
        // Get existing record home folder for orders
        List<NEILON__Folder__c> existingRecordHomeFolders = [Select Id, Name, NEILON__Parent_Id__c, NEILON__Bucket_Name__c, NEILON__Bucket_Region__c From NEILON__Folder__c Where NEILON__Record_Home__c = true AND NEILON__Parent_Id__c IN: parentIds];
        for(NEILON__Folder__c existingRecordHomeFolder : existingRecordHomeFolders){
            recordHomeFoldersByParentIds.put(existingRecordHomeFolder.NEILON__Parent_Id__c, existingRecordHomeFolder);
        }
        
        // Remove accounts with existing folders
        if(!recordHomeFoldersByParentIds.isEmpty()){
            parentIds.removeAll(recordHomeFoldersByParentIds.keySet());
        }
        
        // Create folder structure
        if(!parentIds.isEmpty()){
            // Create folder structure
            Map<Id, NEILON__Folder__c> updatedRecordHomeFoldersByAccountId = NEILON.apGlobalUtils.buildFolderArchitecture(parentIds);
            
            // Check new folders
            if(updatedRecordHomeFoldersByAccountId != null){
                recordHomeFoldersByParentIds.putAll(updatedRecordHomeFoldersByAccountId);
            }
        }
        return recordHomeFoldersByParentIds;
    }
}