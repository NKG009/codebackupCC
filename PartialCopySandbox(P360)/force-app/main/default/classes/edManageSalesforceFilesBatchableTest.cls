/* **************************************************************************
* Copyright © 2015-2020, Neilon Technologies LLP
* All rights reserved
*
* Controller Class: edManageSalesforceFilesBatchableTest
* Created by Suresh Meghnathi: 01/02/2021
*
* - Test class for edManageSalesforceFilesBatchable.

* - Modifications:
* - Suresh Meghnathi, 01/02/2021 – Initial Development
************************************************************************** */
@isTest
public class edManageSalesforceFilesBatchableTest {
	@testsetup static void createTestData(){
        // Create buckets
        NEILON__Folder__c bucket = s3LinkTestUtils.createFoldersForBucket('Test_Bucket1');
    }
    
    static testMethod void testDeleteMigragedFiles() {
        // Create contact
        Contact contact = new Contact();
        contact.FirstName = 'John';
        contact.LastName = 'Doe';
        insert contact;
        
        // Create content document link
        ContentDocumentLink contentDocumentLink = s3LinkTestUtils.createContentDocumentLink('TestTitle', contact.Id);
        
        // Create folder strcuture
        edCreateFolderStructureBatchable.createFolderStructure(new Set<Id> {contact.Id});
        
        // Migrate files
        edSalesforceFilesMigrationBatchable.migrateSalesforceFiles(contact.Id);
    	
        // Get content document 
        ContentDocument contentDocument = [SELECT Id FROM ContentDocument Limit 1];
        
    	// Delete files
        Test.startTest();
        edManageSalesforceFilesBatchable batchable = new edManageSalesforceFilesBatchable('Select Id From Contact Where Id = \'' + contact.Id + '\'');
        Database.executeBatch(batchable, 1);
        Test.stopTest();
        
        // Check documents
        List<ContentDocument> contentDocuments = [Select Id From contentDocument Where Id = :contentDocument.Id];
        System.assertEquals(0, contentDocuments.size());
    }
}