/* **************************************************************************
* Copyright © 2015-2020, Neilon Technologies LLP
* All rights reserved
*
* Controller Class: edCreateFolderStructureBatchableTest
* Created by Anil Meghnathi: 31/01/2021
*
* - Test class for edCreateFolderStructureBatchable.

* - Modifications:
* - Anil Meghnathi, 31/01/2021 – Initial Development
************************************************************************** */
@isTest
public class edCreateFolderStructureBatchableTest {
	@testsetup static void createTestData(){
        // Create buckets
        NEILON__Folder__c bucket = s3LinkTestUtils.createFoldersForBucket('Test_Bucket1');
		
		// Create generic configuration
        S3LinkTestUtils.createGenericConfiguration();
    }
    
    static testMethod void testCreateFolderStructure() {
        // Create contact
        Contact contact = new Contact();
        contact.FirstName = 'John';
        contact.LastName = 'Doe';
        insert contact;
        
        // Create content document link
        ContentDocumentLink contentDocumentLink = s3LinkTestUtils.createContentDocumentLink('TestTitle', contact.Id);
        
        Test.startTest();
        
        // Start job to create folder strcuture
        edCreateFolderStructureBatchable batch = new edCreateFolderStructureBatchable('Select Id, Name From Contact');
		Database.executeBatch(batch, 1);
        
        Test.stopTest();
        
        List<NEILON__Folder__c> recordHomeFolders = [Select Id, Name, NEILON__Parent_Id__c, NEILON__Parent__c From NEILON__Folder__c 
                                                     Where NEILON__Record_Home__c = true AND NEILON__Parent_Id__c =: contact.Id];
        
        system.assertEquals(1, recordHomeFolders.size());
    }
}