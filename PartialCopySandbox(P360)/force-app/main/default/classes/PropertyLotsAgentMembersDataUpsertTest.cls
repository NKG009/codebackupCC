/*******************************************************************************************
* @Name         PropertyLotsAgentMembersDataUpsertTest
* @Author       Rajesh
* @Description  This class contains all methods to provide code coverage for apex class 'PropertyLotsAgentMembersDataUpsert'.
*******************************************************************************************/
@isTest
public class PropertyLotsAgentMembersDataUpsertTest {
	
    static Property_Me_API_Configuration__mdt ptCMD =  new Property_Me_API_Configuration__mdt();    
    
    @isTest
    static void testPMCustomMetaData() {
       CustomMetadataService cms = new  CustomMetadataService('PM_Members','PM_Members','PM Members','Property Me');
       ptCMD = CustomMetadataService.getPMCustomMetadataRecord();
    }
    @testSetup static void setup() {
        // Create common test accounts
        Account acc = new Account();
        acc.Name = 'Test Acc890';
        acc.External_ID__c = '123450987' ;
        acc.ActiveManagerMemberId__c = 'abc300cb-2704-4480-aa5e-7251b1c2a36b';
        Insert acc;      
    }
    
     @isTest
    static void testAgentUpsertSuccess() {	
        
        String propertyJson=		'['+
                '    {'+
                '        \"Id\": \"abc300cb-2704-4480-aa5e-7251b1c2a36b\",'+
                '        \"CustomerId\": \"abc300cb-1b5d-4cd9-9e88-8ee084e06869\",'+
                '        \"UserId\": 422161,'+
                '        \"Role\": \"Admin\",'+
                '        \"ExpireOn\": null,'+
                '        \"FirstName\": \"Tony\",'+
                '        \"LastName\": \"Wagener\",'+
                '        \"CompanyName\": \"Property Services 360\",'+
                '        \"RegisteredEmail\": \"tony@propertyservices360.com.au\",'+
                '        \"RegisteredOn\": \"2020-05-22T03:41:54.0000000Z\",'+
                '        \"WorkPhone\": \"1300685322\",'+
                '        \"MobilePhone\": \"0466776515\",'+
                '        \"IsActivated\": true,'+
                '        \"AgreeConditionsOn\": \"2020-05-22T03:41:54.0000000Z\",'+
                '        \"RegionCode\": \"ALL\",'+
                '        \"Permissions\": null,'+
                '        \"CurrentMemberAccessId\": \"abc300cb-2707-47f5-8218-8026e6359e9d\",'+
                '        \"JobTitle\": null,'+
                '        \"Teams\": null,'+
                '        \"IsSupport\": false,'+
                '        \"IsBillingRecipient\": true,'+
                '        \"IsTwoFactorAuthenticationEnabled\": false,'+
                '        \"Name\": \"Tony Wagener\"'+
                '    }'+
                ']';
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Me',propertyJson,true));
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        PropertyLotsAgentMembersDataUpsert.getPropertyLotsAgentMembersDataUpsert('PM_Members','PMLotMembers','Property Services 360');        
        PropertyLotsAgentMembersduplicate.getPropertyLotsAgentMembersDataUpsert('Property_Me_NC');
        Test.stopTest();
    }
     @isTest
    static void testAgentUnSuccessResponse() {	
        
       String propertyJson=		'['+
                '    {'+
                '        \"Id\": \"abc300cb-2704-4480-aa5e-7251b1c2a36b\",'+
                '        \"CustomerId\": \"abc300cb-1b5d-4cd9-9e88-8ee084e06869\",'+
                '        \"UserId\": 422161,'+
                '        \"Role\": \"Admin\",'+
                '        \"ExpireOn\": null,'+
                '        \"FirstName\": \"Tony\",'+
                '        \"LastName\": \"Wagener\",'+
                '        \"CompanyName\": \"Property Services 360\",'+
                '        \"RegisteredEmail\": \"tony@propertyservices360.com.au\",'+
                '        \"RegisteredOn\": \"2020-05-22T03:41:54.0000000Z\",'+
                '        \"WorkPhone\": \"1300685322\",'+
                '        \"MobilePhone\": \"0466776515\",'+
                '        \"IsActivated\": true,'+
                '        \"AgreeConditionsOn\": \"2020-05-22T03:41:54.0000000Z\",'+
                '        \"RegionCode\": \"ALL\",'+
                '        \"Permissions\": null,'+
                '        \"CurrentMemberAccessId\": \"abc300cb-2707-47f5-8218-8026e6359e9d\",'+
                '        \"JobTitle\": null,'+
                '        \"Teams\": null,'+
                '        \"IsSupport\": false,'+
                '        \"IsBillingRecipient\": true,'+
                '        \"IsTwoFactorAuthenticationEnabled\": false,'+
                '        \"Name\": \"Tony Wagener\"'+
                '    }'+
                ']';
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Me',propertyJson,false));
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        PropertyLotsAgentMembersduplicate.getPropertyLotsAgentMembersDataUpsert('Property_Me_NC');
        PropertyLotsAgentMembersDataUpsert.getPropertyLotsAgentMembersDataUpsert('PM_Members','PMLotMembers','Property Services 360');        
        Test.stopTest();
    }
      @isTest
    static void testAgentUpsertFailed() {
        
       String propertyJson=		'['+
                '    {'+
               
                '        \"CustomerId\": \"abc300cb-1b5d-4cd9-9e88-8ee084e06869\",'+
                '        \"UserId\": 422161,'+
                '        \"Role\": \"Admin\",'+
                '        \"ExpireOn\": null,'+
                '        \"FirstName\": \"Tony\",'+
                '        \"LastName\": \"Wagener\",'+
                '        \"CompanyName\": \"Property Services 360\",'+
                '        \"RegisteredEmail\": \"tony@propertyservices360.com.au\",'+
                '        \"RegisteredOn\": \"2020-05-22T03:41:54.0000000Z\",'+
                '        \"WorkPhone\": \"1300685322\",'+
                '        \"MobilePhone\": \"0466776515\",'+
                '        \"IsActivated\": true,'+
                '        \"AgreeConditionsOn\": \"2020-05-22T03:41:54.0000000Z\",'+
                '        \"RegionCode\": \"ALL\",'+
                '        \"Permissions\": null,'+
                '        \"CurrentMemberAccessId\": \"abc300cb-2707-47f5-8218-8026e6359e9d\",'+
                '        \"JobTitle\": null,'+
                '        \"Teams\": null,'+
                '        \"IsSupport\": false,'+
                '        \"IsBillingRecipient\": true,'+
                '        \"IsTwoFactorAuthenticationEnabled\": false,'+
                '        \"Name\": \"Tony Wagener\"'+
                '    }'+
                ']';
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Me',propertyJson,true));
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        PropertyLotsAgentMembersduplicate.getPropertyLotsAgentMembersDataUpsert('Property_Me_NC');
        PropertyLotsAgentMembersDataUpsert.getPropertyLotsAgentMembersDataUpsert('PM_Members','PMLotMembers','Property Services 360');        
        Test.stopTest();
    }
   
}