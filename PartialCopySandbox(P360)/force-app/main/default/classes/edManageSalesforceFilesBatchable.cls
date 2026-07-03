/* **************************************************************************
* Copyright © 2015-2020, Neilon Technologies LLP.
* All rights reserved
*
* Controller Class: edManageSalesforceFilesBatchable
* Created by Suresh Meghnathi: 01/02/2021
*
* -This is batchable class to manage Salesforce files.

* - Modifications:
* - Suresh Meghnathi, 01/02/2021 – Initial Development
************************************************************************** */
public without sharing class edManageSalesforceFilesBatchable implements Database.Batchable<sObject>, Database.AllowsCallouts{
    // Query string to get files
    public String query;
    
    public edManageSalesforceFilesBatchable(String query){
        this.query = query;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        // Record ids to delete attachments
    	List<Id> recordIds = new List<Id>();
        
        for(sObject record : scope){
            recordIds.add(record.Id);
        }
        
        // Get content document links
        List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
        if(!recordIds.isEmpty()){
            contentDocumentLinks = [Select Id, LinkedEntityId, ContentDocumentId From ContentDocumentLink Where ContentDocument.FileType != 'SNOTE' AND LinkedEntityId IN : recordIds];
        }
        
        Set<Id> contentDocumentIds = new Set<Id>();
        for(ContentDocumentLink contentDocumentLink : contentDocumentLinks){
            contentDocumentIds.add(contentDocumentLink.ContentDocumentId);
        }
        
        Set<String> contentDocumentIdsToDelete = new Set<String>();
        for(NEILON__File__c file : [Select Id, NEILON__Content_Document_Id__c From NEILON__File__c Where NEILON__Content_Document_Id__c IN: contentDocumentIds]){
            contentDocumentIdsToDelete.add(file.NEILON__Content_Document_Id__c);
        }
        
        // Delete content documents
        if(!contentDocumentIdsToDelete.isEmpty()){
            List<ContentDocument> documents = [Select Id From ContentDocument Where Id In : contentDocumentIdsToDelete];
            Database.delete(documents, false);
        }
    }
    
    public void finish(Database.BatchableContext BC){
    }
}