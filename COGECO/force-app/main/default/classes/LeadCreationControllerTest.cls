@isTest
public with sharing class LeadCreationControllerTest {

    // -------------------------------
    // Test creating a Lead successfully
    // -------------------------------
    @isTest
    static void testCreateLeadSuccess() {
        // Query System Administrator Profile Id
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        // Create new user with System Administrator profile
        User sysAdminUser = new User(
            Alias = 'sysadm',
            Email = 'sysadmin@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'AdminTest',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = sysAdminProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'sysadminuser@testorg.com' + System.currentTimeMillis() // Ensure unique username
        );
        insert sysAdminUser;
        
        Map<String, Object> formData = new Map<String, Object>{
            'Contact_Name_Lead_Form__c' => 'TestLastName',
            'REP_ID__c' => 'REP123',
            'Business_Name__c' => 'TestBusiness',
            'Business_Phone1__c' => '1234567890',
            'Service_Address_Lead_Form__c' => '123 Main St',
            'Postal_Code__c' => '12345',
            'Billing_Address_Lead_Form__c' => '123 Billing',
            'Contact_Role__c' => 'Manager',
            'Contact_Phone__c' => '0987654321',
            'Contact_Email__c' => 'test@example.com',
            'Internet_Sold__c' => 'Yes',
            'Speed__c' => '360Mbps',
            'Internet_Term__c' => 'No Term',
            'Configuration__c' => 'Wi-Fi',
            'Wi_Fi_Type__c' => 'Wi-Fi AC Modem',
            'WiFi_6_Extenders_Required__c' => '2',
            'Total_Internet_MRR__c' => '25.50',
            'Voice_Sold__c' => 'Yes',
            'of_Lines__c' => '2',
            'Voice_Term__c' => 'No Term',
            'Number_Type__c' => 'New Number/s',
            'Total_Voice_MRR__c' => '10.00',
            'Video_Sold__c' => 'Yes',
            'Package__c' => 'Standard',
            'Video_Term__c' => 'No Term',
            'Number_of_Boxes_Required__c' => '3',
            'List_any_additional_channels_packages_to__c' => 'ESPN, HBO',
            'Total_Video_MRC__c' => '50.00',
            'Professional_Install_Fee__c' => '150',
            'Additional_Comments__c' => 'Some comments',
            'Rep_Email__c' => 'rep@example.com',
            'Rep_Name__c' => 'Rep Name',
            'OwnerId' => sysAdminUser.Id
        };

        Test.startTest();
        Id leadId = LeadCreationController.createLead(formData);
        Test.stopTest();

        System.assertNotEquals(null, leadId, 'Lead Id must not be null');
        Lead created = [SELECT LastName, Company, Total_Internet_MRR__c, of_Lines__c
                        FROM Lead WHERE Id = :leadId];
        System.assertEquals('TestLastName', created.LastName);
        System.assertEquals('TestBusiness', created.Company);
        System.assertEquals(25.50, created.Total_Internet_MRR__c);
        System.assertEquals(2, created.of_Lines__c);
    }

    // -------------------------------
    // Test creating a Lead with missing decimals
    // -------------------------------
    @isTest
    static void testCreateLeadWithMissingDecimals() {
        Map<String, Object> formData = new Map<String, Object>{
            'Contact_Name_Lead_Form__c' => 'NoDecimalsLastName',
            'Business_Name__c' => 'NDTestBiz'
        };
        Test.startTest();
        Id leadId = LeadCreationController.createLead(formData);
        Lead created = [SELECT LastName, Total_Internet_MRR__c FROM Lead WHERE Id = :leadId];
        Test.stopTest();
        System.assertEquals('NoDecimalsLastName', created.LastName);
        System.assertEquals(null, created.Total_Internet_MRR__c);
    }

    // -------------------------------
    // Test uploading files (valid & invalid) for a Lead
    // -------------------------------
    @isTest
    static void testUploadFilesValidAndInvalidFiles() {
        // Query System Administrator Profile Id
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

        // Create new user
        User sysAdminUser = new User(
            Alias = 'sysadm',
            Email = 'sysadmin@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'AdminTest',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = sysAdminProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'sysadminuser@testorg.com' + System.currentTimeMillis()
        );
        insert sysAdminUser;

        System.runAs(sysAdminUser) {
            // Create Lead using createLead method
            Map<String, Object> formData = new Map<String, Object>{
                'Contact_Name_Lead_Form__c' => 'FileLead',
                'Business_Name__c' => 'TestBiz'
            };
            Id leadId = LeadCreationController.createLead(formData);

            // Valid file (base64)
            String base64Data = EncodingUtil.base64Encode(Blob.valueOf('Hello World'));
            Map<String, String> validFile = new Map<String, String>{
                'fileName' => 'Hello.txt',
                'base64Data' => base64Data,
                'contentType' => 'text/plain'
            };

            // Invalid file (missing data)
            Map<String, String> invalidFile = new Map<String, String>{
                'fileName' => '',
                'base64Data' => '',
                'contentType' => 'text/plain'
            };

            List<Map<String, String>> files = new List<Map<String, String>>{ validFile, invalidFile };

            Test.startTest();
            LeadCreationController.uploadFiles(leadId, files);
            Test.stopTest();

            // Verify at least one ContentDocumentLink created
            List<ContentDocumentLink> links = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :leadId];
            System.assert(!links.isEmpty(), 'At least one ContentDocumentLink should be created');
        }
    }

    // -------------------------------
    // Test uploading files with null inputs
    // -------------------------------
    @isTest
    static void testUploadFilesWithNullInput() {
        Test.startTest();
        try {
            LeadCreationController.uploadFiles(null, null);
            System.assert(false, 'Should have thrown AuraHandledException');
        } catch (AuraHandledException e) {
            // Expected exception
        }
        Test.stopTest();
    }
}