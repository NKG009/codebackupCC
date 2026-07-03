/* **************************************************************************
* Copyright © 2015-2022, Neilon Technologies LLP
* All rights reserved
*
* Controller Class: edSalesforceFilesMigrationBatchableTest
* Created by Suresh Meghnathi: 14/11/2022
*
* - Test class for edSalesforceFilesMigrationBatchable.

* - Modifications:
* - Suresh Meghnathi, 14/11/2020 – Initial Development
************************************************************************** */
@isTest
public class edSalesforceFilesMigrationBatchableTest {
	@testsetup static void createTestData(){
        // Create buckets
        NEILON__Folder__c bucket = s3LinkTestUtils.createFoldersForBucket('Test_Bucket1');
    }
    
    static testMethod void testMigrateSalesforceFiles() {
        // Create contact
        Contact contact = new Contact();
        contact.FirstName = 'John';
        contact.LastName = 'Doe';
        insert contact;
        
        contact = [SELECT Id, Name FROM Contact WHERE Id = :contact.Id];
        
        // Create content document link
        ContentDocumentLink contentDocumentLink = s3LinkTestUtils.createContentDocumentLink('TestTitle', contact.Id);
        
        // Create folder strcuture
        edCreateFolderStructureBatchable.createFolderStructure(new Set<Id> {contact.Id});
        
        Test.startTest();
        
        // Start job to migrate files
        edSalesforceFilesMigrationBatchable batch = new edSalesforceFilesMigrationBatchable('Select Id, Name From Contact');
		Database.executeBatch(batch, 1);
        
        Test.stopTest();
        
        // Get migrated files
        List<NEILON__File__c> migratedFiles = [Select Id From NEILON__File__c Where NEILON__Contact__c =: contact.Id And NEILON__Folder__r.Name =: contact.Name];
        System.assertEquals(1, migratedFiles.size());
        
        // Get reports
        List<Amazon_S3_File_Migration_Report__c> reports = [Select Id, S3_File__c, Salesforce_File_Id__c From Amazon_S3_File_Migration_Report__c Where Contact__c =: contact.Id And S3_File__c =: migratedFiles[0].Id];
        System.assertEquals(0, reports.size());
    }
}