@isTest
private class OwnershipNameUpdateByPropertyIdTest {
    
    @testSetup
    static void testPTCustomMetaData() {
        Manage_Triggers__c cs1 = new Manage_Triggers__c();
        cs1.Name = 'AccountTrigger';
        cs1.isActive__c = true;
        insert cs1;
        
        CustomMetadataService cms = new  CustomMetadataService('DiJONES_Real_Estate','DiJONES_Real_Estate','DiJONES Real Estate','Property Tree');
        
        String companyName = 'Clarks Test';
        insert new Property_360_Company__c(Name = 'X1', Company_Name__c = companyName, Key__c = '726349-32423-234-2324');
        
        String propertyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Property').getRecordTypeId();
        Account acc = new Account(Name = 'Test', RecordTypeId = propertyRecordTypeId, Property_Company_Source_Id__c = companyName);
        insert acc;
        acc.API_Ownership_External_ID__c = 'b8bfa088-80fb-e911-b5e9-281878b47bfb';
        update acc;
    }
    
    @isTest
    static void testPropUpsertSuccess() {	
        
        String ownershipJson=		'{'+
            '  "abn": null,'+
            '  "contacts": [{'+
            '    "id": "b9bfa088-80fb-e911-b5e9-281878b47bfb",'+
            '    "address": {'+
            '      "address_line_1": "PO Box 484",'+
            '      "address_line_2": null,'+
            '      "country": "AUSTRALIA",'+
            '      "post_code": "2107",'+
            '      "state": "NSW",'+
            '      "street_number": null,'+
            '      "suburb": "AVALON BEACH",'+
            '      "unit": null'+
            '    },'+
            '    "email_address": "karen.atf@optusnet.com.au",'+
            '    "preferred_email_address": "karen.atf@optusnet.com.au",'+
            '    "first_name": "Kevin Leo",'+
            '    "is_primary": true,'+
            '    "last_name": "Young",'+
            '    "mobile_phone_number": "+61411443835",'+
            '    "phone_number": null,'+
            '    "preferred_phone_number": "+61411443835",'+
            '    "title": "",'+
            '    "contact_types": ["Owner"],'+
            '    "no_marketing": false'+
            '  }, {'+
            '    "id": "bbbfa088-80fb-e911-b5e9-281878b47bfb",'+
            '    "address": {'+
            '      "address_line_1": ".",'+
            '      "address_line_2": null,'+
            '      "country": "AUSTRALIA",'+
            '      "post_code": null,'+
            '      "state": null,'+
            '      "street_number": null,'+
            '      "suburb": null,'+
            '      "unit": null'+
            '    },'+
            '    "email_address": "karen.atf@optusnet.com.au",'+
            '    "preferred_email_address": "karen.atf@optusnet.com.au",'+
            '    "first_name": "Karen",'+
            '    "is_primary": false,'+
            '    "last_name": "Young",'+
            '    "mobile_phone_number": null,'+
            '    "phone_number": null,'+
            '    "preferred_phone_number": null,'+
            '    "title": "",'+
            '    "contact_types": ["Owner"],'+
            '    "no_marketing": false'+
            '  }],'+
            '  "id": "b8bfa088-80fb-e911-b5e9-281878b47bfb",'+
            '  "properties": ["7b029168-e591-48b0-aaed-72fec08ed37e"],'+
            '  "deleted": false,'+
            '  "archived": false,'+
            '  "name": "Kevin Leo Young & Karen Jane Young"'+
            '}';
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Tree',ownershipJson,true));
        system.schedule('OwnershipNameUpdateByPropertyIdSchedulerTest', '0 0 22 ? * * *', new OwnershipNameUpdateByPropertyIdScheduler());   
        Test.stopTest();
    }
    
}