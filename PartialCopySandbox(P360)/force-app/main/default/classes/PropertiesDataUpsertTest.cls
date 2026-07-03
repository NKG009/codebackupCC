/*******************************************************************************************
* @Name         PropertiesDataUpsertTest
* @Author       Rajesh
@Description  This class contains all methods to provide code coverage for apex class 'PropertiesDataUpsert'.
*******************************************************************************************/
@isTest(seeAllData = false)
public class PropertiesDataUpsertTest {
    
	static Property_API_Configuration__mdt ptCMD =  new Property_API_Configuration__mdt();    
    
    @isTest
    static void testPTCustomMetaData() {
       CustomMetadataService cms = new  CustomMetadataService('DiJONES_Real_Estate','DiJONES_Real_Estate','DiJONES Real Estate','Property Tree');
       ptCMD = CustomMetadataService.getCustomMetadataRecord();
    }
    
     @isTest
    static void testPropUpsertSuccess() {	
        
        String propertyJson=		'[{'+
		'  "address": {'+
		'    "address_line_1": "Ascot Avenue",'+
		'    "address_line_2": "",'+
		'    "country": null,'+
		'    "post_code": "2076",'+
		'    "state": "NSW",'+
		'    "street_number": "11",'+
		'    "suburb": "WAHROONGA",'+
		'    "unit": null'+
		'  },'+
		'  "advertised_rent": {'+
		'    "amount": 1150.0000,'+
		'    "period": "Fortnightly"'+
		'  },'+
		'  "agents": ["1d986a9c-5dc6-4835-ab38-5f2b6266f2f3", "67a40457-3d6d-46ef-ba86-f81300e80e63"],'+
		'  "property_type": "House",'+
		'  "bathrooms": 1,'+
		'  "bedrooms": 3,'+
		'  "car_spaces": 1,'+
		'  "id": "1118e352-b8b4-4017-86eb-d4cfb828b6d1",'+
		'  "key_description": null,'+
		'  "key_number": null,'+
		'  "ownership": "cf06998e-80fb-e911-b5e9-281878b47bfb",'+
		'  "tenancy": "bfa2baf8-82fb-e911-b5e9-281878b47bfb",'+
		'  "deleted": false,'+
		'  "archived": false,'+
		'  "smoke_alarm": {'+
		'    "last_serviced_date": "2020-07-17T00:00:00",'+
		'    "next_service_date": "2021-07-17T00:00:00"'+
		'  },'+
		'  "management_type": "Residential",'+
		'  "area": null,'+
		'  "expenditure_limit": 0.00,'+
		'  "maintenance_note": null,'+
		'  "strata": ""'+
		'}]';
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Tree',propertyJson,true));
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        PropertiesDataUpsert.getPropertiesDataUpsert('DiJONES_Real_Estate');        
        Test.stopTest();
    }
    
    @isTest
    static void testPropUnSuccessResponse() {
        
        String propertyJson=		'[{'+
		'  "address": {'+
		'    "address_line_1": "Ascot Avenue",'+
		'    "address_line_2": "",'+
		'    "country": null,'+
		'    "post_code": "2076",'+
		'    "state": "NSW",'+
		'    "street_number": "11",'+
		'    "suburb": "WAHROONGA",'+
		'    "unit": null'+
		'  },'+
		'  "advertised_rent": {'+
		'    "amount": 1150.0000,'+
		'    "period": "Fortnightly"'+
		'  },'+
		'  "agents": ["1d986a9c-5dc6-4835-ab38-5f2b6266f2f3", "67a40457-3d6d-46ef-ba86-f81300e80e63"],'+
		'  "property_type": "House",'+
		'  "bathrooms": 1,'+
		'  "bedrooms": 3,'+
		'  "car_spaces": 1,'+
		'  "id": "1118e352-b8b4-4017-86eb-d4cfb828b6d1",'+
		'  "key_description": null,'+
		'  "key_number": null,'+
		'  "ownership": "cf06998e-80fb-e911-b5e9-281878b47bfb",'+
		'  "tenancy": "bfa2baf8-82fb-e911-b5e9-281878b47bfb",'+
		'  "deleted": false,'+
		'  "archived": false,'+
		'  "smoke_alarm": {'+
		'    "last_serviced_date": "2020-07-17T00:00:00",'+
		'    "next_service_date": "2021-07-17T00:00:00"'+
		'  },'+		
		'  "area": null,'+
		'  "expenditure_limit": 0.00,'+
		'  "maintenance_note": null,'+
		'  "strata": ""'+
		'}]';
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Tree',propertyJson,false)); 
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        PropertiesDataUpsert.getPropertiesDataUpsert('DiJONES_Real_Estate');        
        Test.stopTest();
    }
     @isTest
    static void testPropUpsertFailed() {
        
        String propertyJson=		'[{'+
		'  "address": {'+
		'    "address_line_1": "Ascot Avenue",'+
		'    "address_line_2": "",'+
		'    "country": null,'+
		'    "post_code": "2076",'+
		'    "state": "NSW",'+
		'    "street_number": "11",'+
		'    "suburb": "WAHROONGA",'+
		'    "unit": null'+
		'  },'+
		'  "advertised_rent": {'+
		'    "amount": 1150.0000,'+
		'    "period": "Fortnightly"'+
		'  },'+
		'  "agents": ["1d986a9c-5dc6-4835-ab38-5f2b6266f2f3", "67a40457-3d6d-46ef-ba86-f81300e80e63"],'+
		'  "property_type": "House",'+
		'  "bathrooms": 1,'+
		'  "bedrooms": 3,'+
		'  "car_spaces": 1,'+		
		'  "key_description": null,'+
		'  "key_number": null,'+
		'  "ownership": "cf06998e-80fb-e911-b5e9-281878b47bfb",'+
		'  "tenancy": "bfa2baf8-82fb-e911-b5e9-281878b47bfb",'+
		'  "deleted": false,'+
		'  "archived": false,'+
		'  "smoke_alarm": {'+
		'    "last_serviced_date": "2020-07-17T00:00:00",'+
		'    "next_service_date": "2021-07-17T00:00:00"'+
		'  },'+		
        '  "management_type": "Residential",'+
		'  "area": null,'+
		'  "expenditure_limit": 0.00,'+
		'  "maintenance_note": null,'+
		'  "strata": ""'+
		'}]';
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Tree',propertyJson,true)); 
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        PropertiesDataUpsert.getPropertiesDataUpsert('DiJONES_Real_Estate');        
        Test.stopTest();
    }
}