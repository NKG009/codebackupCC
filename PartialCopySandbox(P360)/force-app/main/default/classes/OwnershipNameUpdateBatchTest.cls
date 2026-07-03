@isTest(seeAllData = false)
public class OwnershipNameUpdateBatchTest {
    
    @testSetup
    static void testPTCustomMetaData() {
       insert new Manage_Triggers__c(Name = 'AccountTrigger');
       insert new Property_360_Company__c(Name = 'X1', Company_Name__c = 'Kevin Leo Young & Karen Jane Young', Key__c = 'b8bfa088-80fb-e911-b5e9-281878b47bfb');
       CustomMetadataService cms = new  CustomMetadataService('DiJONES_Real_Estate','DiJONES_Real_Estate','DiJONES Real Estate','Property Tree');
       insert new Account(Name = 'Test', API_Ownership_External_ID__c = 'b8bfa088-80fb-e911-b5e9-281878b47bfb');
    }
    
    @isTest
    static void testPropUpsertSuccess() {	
        
        String propertyJson=		'[{'+
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
		'}]';
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Tree',propertyJson,true));
        system.schedule('OwnershipNameUpdateBatchTest', '0 0 22 ? * * *', new OwnershipNameUpdateBatch(true));   
        //system.assertEquals('Kevin Leo Young & Karen Jane Young', [Select Ownership_Name__c FROM Account WHERE External_Id__c = '7b029168-e591-48b0-aaed-72fec08ed37e'].Ownership_Name__c);
        Test.stopTest();
    }
    
    @isTest
    static void testPropUpsertFailure() {	
        
        String propertyJson=		'[{'+
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
		'}]';
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Tree',propertyJson,false));
        system.schedule('OwnershipNameUpdateBatchTest', '0 0 22 ? * * *', new OwnershipNameUpdateBatch(true));   
        //system.assertEquals('Kevin Leo Young & Karen Jane Young', [Select Ownership_Name__c FROM Account WHERE External_Id__c = '7b029168-e591-48b0-aaed-72fec08ed37e'].Ownership_Name__c);
        Test.stopTest();
    }
}