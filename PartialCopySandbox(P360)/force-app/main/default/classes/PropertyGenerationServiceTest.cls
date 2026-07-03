/*******************************************************************************************
* @Name         PropertyGenerationServiceTest
* @Author       Rajesh
* @Description  This class contains all methods to provide code coverage for apex class 'PropertyGenerationService'
*******************************************************************************************/
@isTest(seeAllData = false)
public class PropertyGenerationServiceTest {
	
    @isTest
    static void testPostSuccess() {
        String jsonBody = '[{'+
		'  "address": {'+
		'    "address_line_1": "Abbotsford Parade",'+
		'    "address_line_2": "",'+
		'    "country": null,'+
		'    "post_code": "2046",'+
		'    "state": "NSW",'+
		'    "street_number": "11-13",'+
		'    "suburb": "ABBOTSFORD",'+
		'    "unit": "8"'+
		'  },'+
		'  "advertised_rent": {'+
		'    "amount": 800.0000,'+
		'    "period": "Fortnightly"'+
		'  },'+
		'  "agents": ["e92d52f2-3f92-4720-a74d-05a04c6fdaae", "a32c5c45-724f-4d83-8267-644855489fb7"],'+
		'  "property_type": null,'+
		'  "bathrooms": 1,'+
		'  "bedrooms": 2,'+
		'  "car_spaces": null,'+
		'  "id": "ca7308aa-1766-4cc8-9bcc-956e5874a7d5",'+
		'  "key_description": null,'+
		'  "key_number": null,'+
		'  "ownership": "315238ec-6199-e911-810f-000d3aa138f9",'+
		'  "tenancy": "a3c472d2-6299-e911-810f-000d3aa138f9",'+
		'  "deleted": false,'+
		'  "archived": true,'+
		'  "smoke_alarm": {'+
		'    "last_serviced_date": "2020-07-13T00:00:00",'+
		'    "next_service_date": "2021-07-13T00:00:00"'+
		'  },'+
		'  "management_type": "Residential",'+
		'  "area": null,'+
		'  "expenditure_limit": 300.00,'+
		'  "maintenance_note": null,'+
		'  "strata": ""'+
		'}]';
         
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/PropertyTree/Properties';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonBody);
        RestContext.request = req;
        RestContext.response= res;        
        String status = PropertyGenerationService.doPost();
        system.debug('#####status :'+status);
        system.assertEquals('Success!! Please Check Error Log for more details.', status);            
    } 
    @isTest
    static void testPostFailed() {
        String jsonBody =  '[{'+
		'  "address": {'+
		'    "address_line_1": "Abbotsford Parade",'+
		'    "address_line_2": "",'+
		'    "country": null,'+
		'    "post_code": "2046",'+
		'    "state": "NSW",'+
		'    "street_number": "11-13",'+
		'    "suburb": "ABBOTSFORD",'+
		'    "unit": "8"'+
		'  },'+
		'  "advertised_rent": {'+
		'    "amount": 800.0000,'+
		'    "period": "Fortnightly"'+
		'  },'+
		'  "agents": ["e92d52f2-3f92-4720-a74d-05a04c6fdaae", "a32c5c45-724f-4d83-8267-644855489fb7"],'+
		'  "property_type": null,'+
		'  "bathrooms": 1,'+
		'  "bedrooms": 2,'+
		'  "car_spaces": null,'+
		
		'  "key_description": null,'+
		'  "key_number": null,'+
		'  "ownership": "315238ec-6199-e911-810f-000d3aa138f9",'+
		'  "tenancy": "a3c472d2-6299-e911-810f-000d3aa138f9",'+
		'  "deleted": false,'+
		'  "archived": true,'+
		'  "smoke_alarm": {'+
		'    "last_serviced_date": "2020-07-13T00:00:00",'+
		'    "next_service_date": "2021-07-13T00:00:00"'+
		
		'  "management_type": "Residential",'+
		'  "area": null,'+
		'  "expenditure_limit": 300.00,'+
		'  "maintenance_note": null,'+
		'  "strata": ""'+
		'}]';
          
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/PropertyTree/Properties';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonBody);
        RestContext.request = req;
        RestContext.response= res;        
        String status = PropertyGenerationService.doPost();
        system.debug('#####status :'+status);
        system.assertEquals('Fail!! Please Check Error Log for more details.', status);           
    }  
}