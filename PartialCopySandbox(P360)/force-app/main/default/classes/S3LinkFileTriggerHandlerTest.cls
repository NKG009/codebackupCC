/* **************************************************************************
* Copyright © 2015-2022, Neilon Technologies LLP
* All rights reserved
*
* Controller Class: S3LinkFileTriggerHandlerTest
* Created by Suresh Meghnathi: 13/06/2022
*
* - Test class for S3LinkFileTriggerHandler.

* - Modifications:
* - Suresh Meghnathi, 13/06/2022 – Initial Development
************************************************************************** */
@isTest
public class S3LinkFileTriggerHandlerTest {
	@testsetup static void createTestData(){
        // Create buckets
        NEILON__Folder__c bucket = S3LinkTestUtils.createFoldersForBucket('Test_Bucket1');
    }
    
    static testMethod void testAfterInsert() {
        // Create contact
        Contact contact = new Contact();
        contact.FirstName = 'John';
        contact.LastName = 'Doe';
        insert contact;
        
        // Create folder strcuture
        edCreateFolderStructureBatchable.createFolderStructure(new Set<Id> {contact.Id});
        
        // Create content document link
        ContentDocumentLink contentDocumentLink = s3LinkTestUtils.createContentDocumentLink('TestTitle', contact.Id);
        
        // Get content document
        ContentVersion contentVersion = [Select Id, ContentDocumentId From ContentVersion LIMIT 1];
            
        // Get bucket
       	NEILON__Folder__c folder = [Select Id From NEILON__Folder__c Where NEILON__Contact__c = :contact.Id LIMIT 1];
        
        // Get content document links
        contentDocumentLink = [Select Id, LinkedEntityId, ContentDocument.Id, ContentDocument.FileType, ContentDocument.ContentSize, ContentDocument.Title, ContentDocument.FileExtension 
                                                             From ContentDocumentLink Where Id =: contentDocumentLink.Id];
        // Create report
        edSalesforceFilesMigrationBatchable.createAmazonS3FileMigrationReport(new List<ContentDocumentLink>{contentDocumentLink}, new Map<String, NEILON__File__c>(), 'Record home folder not found');
        
        // Create new file
        NEILON__File__c file1 = new NEILON__File__c(Name= 'TestFile.pdf');
        file1.NEILON__Folder__c = folder.Id;
        file1.NEILON__Bucket_Name__c = 'Test_Bucket1';
        file1.NEILON__Extension__c = '.pdf';
        file1.NEILON__Size__c = 5000;
        file1.NEILON__Content_Type__c = 'image/png';
        file1.NEILON__Track_Download_History__c = true;
        file1.NEILON__Parent_Id__c = contact.Id;
        file1.NEILON__Contact__c = contact.Id;
        file1.NEILON__Content_Document_Id__c = contentVersion.ContentDocumentId;
        file1.NEILON__Export_Attachment_Id__c = contentVersion.Id;
        insert file1;
        
        // Get reports
        List<Amazon_S3_File_Migration_Report__c> reports = [Select Id From Amazon_S3_File_Migration_Report__c Where Contact__c =: contact.Id And S3_File__c =: file1.Id];
        System.assertEquals(1, reports.size());
    }
}