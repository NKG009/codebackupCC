/* **************************************************************************
*
* Controller Class: S3LinkFileTriggerHandler
* Created by Suresh Meghnathi: 31/1/2021
*
* - Trigger Handler class for S3-File Trigger
*
* - Modifications:
* - Suresh Meghnathi, 31/1/2021 – Initial Development
************************************************************************** */
public class S3LinkFileTriggerHandler {
    // Flag to skip trigger
    public static Boolean isSkipTrigger = false;
    
    /*
    *   Executed:   On after insert of S3-File
    *   Purpose:    Create amazon S3-File migration report
    *   Parameters: 
    *   UnitTests:  
    */
    public void onAfterInsert(List<NEILON__File__c> newFiles){
        if(!isSkipTrigger){
            // Map of files by content document id
            Map<String, NEILON__File__c> filesByContentDocumentId = new Map<String, NEILON__File__c>();
            
            // List of content document ids
            List<Id> contentDocumentIds = new List<Id>();
            
            // List of parent ids
            List<Id> parentIds = new List<Id>();
            
            for(NEILON__File__c newFile : newFiles){
                if(newFile.NEILON__Parent_Id__c != null && newFile.NEILON__Content_Document_Id__c != null){
                    parentIds.add(newFile.NEILON__Parent_Id__c);
                    contentDocumentIds.add(newFile.NEILON__Content_Document_Id__c);
                    filesByContentDocumentId.put(newFile.NEILON__Parent_Id__c + newFile.NEILON__Content_Document_Id__c, newFile);
                }
            }
            
            // Get content document links
            if(!contentDocumentIds.isEmpty() && !parentIds.isEmpty()){
                List<ContentDocumentLink> contentDocumentLinks = [Select Id, LinkedEntityId, ContentDocument.FileType, ContentDocument.Id, ContentDocument.ContentSize, ContentDocument.Title, ContentDocument.FileExtension From ContentDocumentLink Where LinkedEntityId IN : parentIds And ContentDocumentId IN : contentDocumentIds];
                
                // Create amazon S3-File migration report
                if(!contentDocumentLinks.isEmpty() && filesByContentDocumentId != null){
                    edSalesforceFilesMigrationBatchable.createAmazonS3FileMigrationReport(contentDocumentLinks, filesByContentDocumentId, null);
                }
            }
        }
    }
}