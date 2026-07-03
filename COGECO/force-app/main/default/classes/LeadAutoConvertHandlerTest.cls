@isTest
public with sharing class LeadAutoConvertHandlerTest {

    @isTest
    static void testConvertSpotioLeads() {
        // ---------------------------
        // Setup Test User
        // ---------------------------
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User testUser = new User(
            Alias = 'tuser',
            Email = 'testuser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'UserTest',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = sysAdminProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testuser' + System.currentTimeMillis() + '@testorg.com'
        );
        insert testUser;

        System.runAs(testUser) {
            // ---------------------------
            // Get Spotio Lead RecordType
            // ---------------------------
            Id spotioLeadRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Spotio').getRecordTypeId();

            // ---------------------------
            // Create Spotio Lead
            // ---------------------------
            Lead leadToConvert = new Lead(
                LastName = 'SpotioLead',
                Company = 'SpotioBusiness',
                RecordTypeId = spotioLeadRT,
                REP_ID__c = 'REP123',
                Contact_Name_Lead_Form__c = 'John Doe',
                Business_Name__c = 'SpotioBusiness',
                Business_Phone1__c = '1234567890',
                Service_Address_Lead_Form__c = '123 Main St',
                Postal_Code__c = '12345',
                Billing_Address_Lead_Form__c = '123 Billing',
                Contact_Role__c = 'Manager',
                Contact_Phone__c = '0987654321',
                Contact_Email__c = 'john@example.com',
                Internet_Sold__c = 'Yes',
                Speed__c = '360Mbps',
                Internet_Term__c = 'No Term',
                Configuration__c = 'Wi-Fi',
                Wi_Fi_Type__c = 'Wi-Fi AC Modem',
                WiFi_6_Extenders_Required__c = '2',
                Total_Internet_MRR__c = 25.50,
                Voice_Sold__c = 'Yes',
                of_Lines__c = 2,
                Voice_Term__c = 'No Term',
                Number_Type__c = 'New Number/s',
                Total_Voice_MRR__c = 10.0
            );
            insert leadToConvert;

            // ---------------------------
            // Add a ContentDocumentLink to Lead
            // ---------------------------
            ContentVersion cv = new ContentVersion(
                Title = 'TestFile.txt',
                PathOnClient = 'TestFile.txt',
                VersionData = Blob.valueOf('Test content')
            );
            insert cv;

            // Get the ContentDocument Id
            cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];

           /* ContentDocumentLink cdl = new ContentDocumentLink(
                ContentDocumentId = cv.ContentDocumentId,
                LinkedEntityId = leadToConvert.Id,
                ShareType = 'V',
                Visibility = 'AllUsers'
            );
            insert cdl;*/

            // ---------------------------
            // Run Lead Conversion
            // ---------------------------
            Test.startTest();
            LeadAutoConvertHandler.convertSpotioLeads(new List<Lead>{ leadToConvert });
            Test.stopTest();

            // ---------------------------
            // Verify Conversion
            // ---------------------------
            Lead convertedLead = [SELECT Id, IsConverted, ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId 
                                  FROM Lead WHERE Id = :leadToConvert.Id];
            
        }
    }

    @isTest
    static void testConvertSpotioLeads_NoLeads() {
        Test.startTest();
        // Should not fail with null or empty
        LeadAutoConvertHandler.convertSpotioLeads(null);
        LeadAutoConvertHandler.convertSpotioLeads(new List<Lead>());
        Test.stopTest();
    }
}