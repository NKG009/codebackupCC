/*******************************************************************************************
* @Name         AgentsDataUpsertTest
* @Author       Rajesh
@Description  This class contains all methods to provide code coverage for apex class 'AgentsDataUpsert'.
*******************************************************************************************/
@isTest(seeAllData = false)
public class AgentsDataUpsertTest {
    
    static Property_API_Configuration__mdt ptCMD =  new Property_API_Configuration__mdt();    
    
    @isTest
    static void testPTCustomMetaData() {
       CustomMetadataService cms = new  CustomMetadataService('DiJONES_Real_Estate_Agents','DiJONES_Real_Estate_Agents','DiJONES Real Estate','Property Tree');
       ptCMD = CustomMetadataService.getCustomMetadataRecord();
    }
    
     @isTest
    static void testAgentUpsertSuccess() {	
        
        String propertyJson=		'[{'+
		'  "email_address": "support@propertytree.com",'+
		'  "first_name": "PropertyTree",'+
		'  "id": "5830446f-fb1f-479a-be01-4afdd1385150",'+
		'  "last_name": "Support",'+
		'  "mobile_phone_number": "+61466978733",'+
		'  "properties": ["367f1de5-a417-49a8-88f5-02c13c163617", "367f1de5-a417-49a8-88f5-02c13c163617", "f9e70d57-5b85-4fb4-a98f-02d22c38543e", "f9e70d57-5b85-4fb4-a98f-02d22c38543e", "f055d065-64ec-4731-ac42-06da4a5a2f0f", "f055d065-64ec-4731-ac42-06da4a5a2f0f", "9b43b75a-1a06-4abe-983b-072b3d9f5f86"],'+
		'  "roles": ["BDM", "Investment Manager"],'+
		'  "deleted": true'+
		'}]';
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Tree',propertyJson,true));
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        AgentsDataUpsert.getAgentsDataUpsert('DiJONES_Real_Estate');        
        Test.stopTest();
    }
    
    @isTest
    static void testAgentUnSuccessResponse() {
        
        String propertyJson=		'[{'+
		'  "email_address": "support@propertytree.com",'+
		'  "first_name": "PropertyTree",'+
		'  "id": "5830446f-fb1f-479a-be01-4afdd1385150",'+		
		'  "mobile_phone_number": "+61466978733",'+
		'  "properties": ["367f1de5-a417-49a8-88f5-02c13c163617", "367f1de5-a417-49a8-88f5-02c13c163617", "f9e70d57-5b85-4fb4-a98f-02d22c38543e", "f9e70d57-5b85-4fb4-a98f-02d22c38543e", "f055d065-64ec-4731-ac42-06da4a5a2f0f", "f055d065-64ec-4731-ac42-06da4a5a2f0f", "9b43b75a-1a06-4abe-983b-072b3d9f5f86"],'+
		'  "roles": ["BDM", "Investment Manager"],'+
		'  "deleted": true'+
		'}]';
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Tree',propertyJson,false)); 
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        AgentsDataUpsert.getAgentsDataUpsert('DiJONES_Real_Estate');    
        Test.stopTest();
    }
     @isTest
    static void testAgentUpsertFailed() {
        
        String propertyJson=		'[{'+
		'  "email_address": "support@propertytree.com",'+
		'  "first_name": "PropertyTree",'+
		'  "last_name": "Support",'+
		'  "mobile_phone_number": "+61466978733",'+
		'  "properties": ["367f1de5-a417-49a8-88f5-02c13c163617", "367f1de5-a417-49a8-88f5-02c13c163617", "f9e70d57-5b85-4fb4-a98f-02d22c38543e", "f9e70d57-5b85-4fb4-a98f-02d22c38543e", "f055d065-64ec-4731-ac42-06da4a5a2f0f", "f055d065-64ec-4731-ac42-06da4a5a2f0f", "9b43b75a-1a06-4abe-983b-072b3d9f5f86"],'+
		'  "roles": ["BDM", "Investment Manager"],'+
		'  "deleted": true'+
		'}]';

        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Tree',propertyJson,true)); 
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
       AgentsDataUpsert.getAgentsDataUpsert('DiJONES_Real_Estate');       
       Test.stopTest();
    }

}