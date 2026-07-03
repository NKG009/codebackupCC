/*******************************************************************************************
* @Name         TenanciesDataUpsertTest
* @Author       Rajesh
@Description  This class contains all methods to provide code coverage for apex class 'TenanciesDataUpsert'.
*******************************************************************************************/
@isTest(seeAllData = false)
public class TenanciesDataUpsertTest {

    static Property_API_Configuration__mdt ptCMD =  new Property_API_Configuration__mdt();    
    
    @isTest
    static void testPTCustomMetaData() {
        CustomMetadataService cms = new  CustomMetadataService('DiJONES_Real_Estate_Tenancies','DiJONES_Real_Estate_Tenancies','DiJONES Real Estate','Property Tree');
       ptCMD = CustomMetadataService.getCustomMetadataRecord();
    }
    
     @isTest
    static void testTenantUpsertSuccess() {	
        
        String propertyJson=		'[{'+
		'  "contacts": [{'+
		'    "id": "44a9a69e-82fb-e911-b5e9-281878b47bfb",'+
		'    "address": {'+
		'      "address_line_1": "Streatfield Road",'+
		'      "address_line_2": "",'+
		'      "country": null,'+
		'      "post_code": "2023",'+
		'      "state": "NSW",'+
		'      "street_number": "54",'+
		'      "suburb": "BELLEVUE HILL",'+
		'      "unit": "8"'+
		'    },'+
		'    "email_address": "leeannwalsh@hotmail.com",'+
		'    "preferred_email_address": "leeannwalsh@hotmail.com",'+
		'    "first_name": "Leeann",'+
		'    "is_primary": true,'+
		'    "last_name": "Walsh",'+
		'    "mobile_phone_number": "+61425222660",'+
		'    "phone_number": "9363 4887",'+
		'    "preferred_phone_number": "+61425222660",'+
		'    "title": "",'+
		'    "contact_types": ["Other: Lease, Arrears, Repairs", "Tenant"],'+
		'    "no_marketing": false'+
		'  }],'+
		'  "id": "46a9a69e-82fb-e911-b5e9-281878b47bfb",'+
		'  "name": "Leeann Walsh",'+
		'  "lease_end_date": "2003-08-11T00:00:00",'+
		'  "lease_start_date": "2002-08-11T00:00:00",'+
		'  "original_lease_start_date": "2002-08-11T00:00:00",'+
		'  "vacate_date": "2021-03-12T00:00:00",'+
		'  "property": "51b09b0a-629f-4f75-b8b6-a4ecea4c4bfd",'+
		'  "rent": {'+
		'    "amount": 2389.8800,'+
		'    "period": "Monthly"'+
		'  },'+
		'  "prospect": false,'+
		'  "deleted": false,'+
		'  "archived": true'+
		'}]';
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Tree',propertyJson,true));
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        TenanciesDataUpsert.getTenanciesDataUpsert('DiJONES_Real_Estate');        
        Test.stopTest();
    }
    
    @isTest
    static void testTenantUnSuccessResponse() {
        
        String propertyJson=		'[{'+
		'  "contacts": [{'+
		'    "id": "44a9a69e-82fb-e911-b5e9-281878b47bfb",'+
		'    "address": {'+
		'      "address_line_1": "Streatfield Road",'+
		'      "address_line_2": "",'+
		'      "country": null,'+
		'      "post_code": "2023",'+
		'      "state": "NSW",'+
		'      "street_number": "54",'+
		'      "suburb": "BELLEVUE HILL",'+
		'      "unit": "8"'+
		'    },'+
		'    "email_address": "leeannwalsh@hotmail.com",'+
		'    "preferred_email_address": "leeannwalsh@hotmail.com",'+
		'    "first_name": "Leeann",'+
		'    "is_primary": true,'+
		'    "last_name": "Walsh",'+
		'    "mobile_phone_number": "+61425222660",'+
		'    "phone_number": "9363 4887",'+
		'    "preferred_phone_number": "+61425222660",'+
		'    "title": "",'+
		'    "contact_types": ["Other: Lease, Arrears, Repairs", "Tenant"],'+
		'    "no_marketing": false'+
		'  }],'+
		'  "id": "46a9a69e-82fb-e911-b5e9-281878b47bfb",'+
		'  "lease_end_date": "2003-08-11T00:00:00",'+
		'  "lease_start_date": "2002-08-11T00:00:00",'+
		'  "original_lease_start_date": "2002-08-11T00:00:00",'+
		'  "vacate_date": "2021-03-12T00:00:00",'+
		'  "property": "51b09b0a-629f-4f75-b8b6-a4ecea4c4bfd",'+
		'  "rent": {'+
		'    "amount": 2389.8800,'+
		'    "period": "Monthly"'+
		'  },'+
		'  "prospect": false,'+
		'  "deleted": false,'+
		'  "archived": true'+
		'}]';
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Tree',propertyJson,false)); 
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        TenanciesDataUpsert.getTenanciesDataUpsert('DiJONES_Real_Estate');    
        Test.stopTest();
    }
     @isTest
    static void testTenantUpsertFailed() {
        
        String propertyJson=		'[{'+
		'  "contacts": [{'+
		'    "id": "44a9a69e-82fb-e911-b5e9-281878b47bfb",'+
		'    "address": {'+
		'      "address_line_1": "Streatfield Road",'+
		'      "address_line_2": "",'+
		'      "country": null,'+
		'      "post_code": "2023",'+
		'      "state": "NSW",'+
		'      "street_number": "54",'+
		'      "suburb": "BELLEVUE HILL",'+
		'      "unit": "8"'+
		'    },'+
		'    "email_address": "leeannwalsh@hotmail.com",'+
		'    "preferred_email_address": "leeannwalsh@hotmail.com",'+
		'    "first_name": "Leeann",'+
		'    "is_primary": true,'+
		'    "last_name": "Walsh",'+
		'    "mobile_phone_number": "+61425222660",'+
		'    "phone_number": "9363 4887",'+
		'    "preferred_phone_number": "+61425222660",'+
		'    "title": "",'+
		'    "contact_types": ["Other: Lease, Arrears, Repairs", "Tenant"],'+
		'    "no_marketing": false'+
		'  }],'+
		'  "name": "Leeann Walsh",'+
		'  "lease_end_date": "2003-08-11T00:00:00",'+
		'  "lease_start_date": "2002-08-11T00:00:00",'+
		'  "original_lease_start_date": "2002-08-11T00:00:00",'+
		'  "vacate_date": "2021-03-12T00:00:00",'+
		'  "property": "51b09b0a-629f-4f75-b8b6-a4ecea4c4bfd",'+
		'  "rent": {'+
		'    "amount": 2389.8800,'+
		'    "period": "Monthly"'+
		'  },'+
		'  "prospect": false,'+
		'  "deleted": false,'+
		'  "archived": true'+
		'}]';
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Tree',propertyJson,true)); 
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
       TenanciesDataUpsert.getTenanciesDataUpsert('DiJONES_Real_Estate');        
       Test.stopTest();
    }
}