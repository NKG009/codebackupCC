/*******************************************************************************************
* @Name         PropertyLotsAgentMembersGenerationsTest
* @Author       Rajesh
* @Description  This class contains all methods to provide code coverage for apex class 'PropertyLotsAgentMembersGenerations'.
*******************************************************************************************/
@isTest
public class PropertyLotsAgentMembersGenerationsTest {
    
    @isTest
    static void testLotsAgentsParse() {
		
            String json = '['+
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
        /*PropertyLotsAgentMembersGenerations plag = new PropertyLotsAgentMembersGenerations();
        plag.Id = '';
        plag.CustomerId = '';
        plag.UserId = 12345;
        plag.Role = '';
        plag.ExpireOn = '';
        plag.FirstName = '';
        plag.LastName = '';
        plag.CompanyName = '';
        plag.RegisteredEmail = '';
        plag.RegisteredOn = '';
        plag.WorkPhone = '';
        plag.MobilePhone = '';
        plag.IsActivated = false;
        plag.AgreeConditionsOn = '';
        plag.RegionCode = '';
        plag.Permissions = '';
        plag.CurrentMemberAccessId = '';
        plag.JobTitle = '';
        plag.Teams = '';
        plag.IsSupport = false;
        plag.IsBillingRecipient = false;
        plag.IsTwoFactorAuthenticationEnabled = false;
        plag.Name = '';*/
        List<PropertyLotsAgentMembersGenerations> obj =  PropertyLotsAgentMembersGenerations.parse(json);
		System.assert(obj != null);
    }

}