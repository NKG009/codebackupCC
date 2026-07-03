/*******************************************************************************************
* @Name         PropertyLotsTenantGenerationsTest
* @Author       Rajesh
* @Description  This class contains all methods to provide code coverage for apex class 'PropertyLotsTenantGenerations'.
*******************************************************************************************/
 @isTest
public class PropertyLotsTenantGenerationsTest {
    
    @isTest
    static void testProprtyTenantsParse() {
		String json=		'[{'+
		'        \"Id\": \"ada4006a-0b1f-43b9-bdde-fab7aef4888e\",'+
		'        \"CustomerId\": \"abc300cb-1b5d-4cd9-9e88-8ee084e06869\",'+
		'        \"SpecialType\": \"None\",'+
		'        \"Roles\": ['+
		'            \"tenant\",'+
		'            \"tenant\"'+
		'        ],'+
		'        \"ArchivedOn\": null,'+
		/*'        \"AccountDetails\": [],'+*/
		'        \"Reference\": \"test test\",'+
		'        \"Website\": null,'+
		'        \"ABN\": null,'+
		'        \"PersonMigrated\": false,'+
		'        \"Labels\": null,'+
		'        \"Notes\": null,'+
		'        \"NameText\": \"test test\",'+
		'        \"PostalAddressText\": \"\",'+
		'        \"PhysicalAddressText\": \"10 Smith St\\nChatswood NSW 2067\",'+
		'        \"CreatedOn\": \"2021-09-15T01:55:50.0000000Z\",'+
		'        \"UpdatedOn\": \"2021-09-15T01:55:56.0000000Z\",'+
		'        \"TradeName\": null,'+
		'        \"HomePhone\": \"\",'+
		'        \"WorkPhone\": \"\",'+
		'        \"CellPhone\": \"\",'+
		'        \"Email\": \"\",'+
		'        \"SupplierChartAccountId\": null,'+
		'        \"IsArchived\": false,'+
		'        \"IsSupplier\": false,'+
		'        \"IsTenant\": true,'+
		'        \"IsOwner\": false,'+
		'        \"IsSeller\": false,'+
		'        \"PhoneText\": \"\",'+
		'        \"WorkPhoneText\": \"\",'+
		'        \"ContactPhone\": \"\",'+
		'        \"ContactPersons\": ['+
		'            {'+
		'                \"Id\": \"ada4006a-0b23-4a55-a895-c71a76eec222\",'+
		'                \"CustomerId\": \"abc300cb-1b5d-4cd9-9e88-8ee084e06869\",'+
		'                \"ContactId\": \"ada4006a-0b1f-43b9-bdde-fab7aef4888e\",'+
		'                \"Salutation\": \"\",'+
		'                \"FirstName\": \"test\",'+
		'                \"LastName\": \"test\",'+
		'                \"CompanyName\": \"\",'+
		'                \"Email\": \"\",'+
		'                \"SecondaryEmailAddresses\": [],'+
		'                \"HomePhone\": \"\",'+
		'                \"WorkPhone\": \"\",'+
		'                \"CellPhone\": \"\",'+
		'                \"NormalisedMobilePhone\": null,'+
		'                \"CommunicationPreferences\": [],'+
		'                \"PhysicalAddress\": {'+
		'                    \"Unit\": \"\",'+
		'                    \"Number\": \"10\",'+
		'                    \"Street\": \"Smith St\",'+
		'                    \"Suburb\": \"Chatswood\",'+
		'                    \"PostalCode\": \"2067\",'+
		'                    \"State\": \"NSW\",'+
		'                    \"Country\": \"Australia\",'+
		'                    \"BuildingName\": \"\",'+
		'                    \"MailboxName\": \"\",'+
		'                    \"Latitude\": -33.7869359,'+
		'                    \"Longitude\": 151.1980571,'+
		'                    \"Text\": \"10 Smith St\\nChatswood NSW 2067\",'+
		'                    \"Reference\": \"Smith St, 10\"'+
		'                },'+
		'                \"PostalAddress\": {'+
		'                    \"Unit\": \"\",'+
		'                    \"Number\": \"\",'+
		'                    \"Street\": \"\",'+
		'                    \"Suburb\": \"\",'+
		'                    \"PostalCode\": \"\",'+
		'                    \"State\": \"\",'+
		'                    \"Country\": \"\",'+
		'                    \"BuildingName\": \"\",'+
		'                    \"MailboxName\": \"\",'+
		'                    \"Latitude\": -999,'+
		'                    \"Longitude\": -999,'+
		'                    \"Text\": \"\",'+
		'                    \"Reference\": \"\"'+
		'                },'+
		'                \"IsPrimary\": true,'+
		'                \"SortOrder\": 0,'+
		'                \"FullName\": \"test test\",'+
		'                \"CombinedPhones\": \"\"'+
		'            }'+
		'        ],'+
		'        \"PrimaryContactPerson\": {'+
		'            \"Id\": \"ada4006a-0b23-4a55-a895-c71a76eec222\",'+
		'            \"CustomerId\": \"abc300cb-1b5d-4cd9-9e88-8ee084e06869\",'+
		'            \"ContactId\": \"ada4006a-0b1f-43b9-bdde-fab7aef4888e\",'+
		'            \"Salutation\": \"\",'+
		'            \"FirstName\": \"test\",'+
		'            \"LastName\": \"test\",'+
		'            \"CompanyName\": \"\",'+
		'            \"Email\": \"\",'+
		'            \"SecondaryEmailAddresses\": [],'+
		'            \"HomePhone\": \"\",'+
		'            \"WorkPhone\": \"\",'+
		'            \"CellPhone\": \"\",'+
		'            \"NormalisedMobilePhone\": null,'+
		'            \"CommunicationPreferences\": [],'+
		'            \"PhysicalAddress\": {'+
		'                \"Unit\": \"\",'+
		'                \"Number\": \"10\",'+
		'                \"Street\": \"Smith St\",'+
		'                \"Suburb\": \"Chatswood\",'+
		'                \"PostalCode\": \"2067\",'+
		'                \"State\": \"NSW\",'+
		'                \"Country\": \"Australia\",'+
		'                \"BuildingName\": \"\",'+
		'                \"MailboxName\": \"\",'+
		'                \"Latitude\": -33.7869359,'+
		'                \"Longitude\": 151.1980571,'+
		'                \"Text\": \"10 Smith St\\nChatswood NSW 2067\",'+
		'                \"Reference\": \"Smith St, 10\"'+
		'            },'+
		'            \"PostalAddress\": {'+
		'                \"Unit\": \"\",'+
		'                \"Number\": \"\",'+
		'                \"Street\": \"\",'+
		'                \"Suburb\": \"\",'+
		'                \"PostalCode\": \"\",'+
		'                \"State\": \"\",'+
		'                \"Country\": \"\",'+
		'                \"BuildingName\": \"\",'+
		'                \"MailboxName\": \"\",'+
		'                \"Latitude\": -999,'+
		'                \"Longitude\": -999,'+
		'                \"Text\": \"\",'+
		'                \"Reference\": \"\"'+
		'            },'+
		'            \"IsPrimary\": true,'+
		'            \"SortOrder\": 0,'+
		'            \"FullName\": \"test test\",'+
		'            \"CombinedPhones\": \"\"'+
		'        },'+
		'        \"Timestamp\": 637672677560000000,'+
		'        \"PrimaryPerson\": \"test test\",'+
		'        \"Phone\": \"\",'+
		'        \"PrimaryPostalAddress\": \"\",'+
		'        \"PrimaryPhysicalAddress\": \"10 Smith St\\nChatswood NSW 2067\",'+
		'        \"RolesString\": \"Tenant\"'+
		'    }]';
        
        PropertyLotsTenantGenerations plg = new PropertyLotsTenantGenerations();
        PropertyLotsTenantGenerations.ContactPersons plgCP = new PropertyLotsTenantGenerations.ContactPersons();
        PropertyLotsTenantGenerations.PrimaryContactPerson plgPCP =  new PropertyLotsTenantGenerations.PrimaryContactPerson();
        PropertyLotsTenantGenerations.PhysicalAddress plgPHA = new PropertyLotsTenantGenerations.PhysicalAddress();
        PropertyLotsTenantGenerations.PostalAddress plgPOA = new PropertyLotsTenantGenerations.PostalAddress();
        
        plg.Id  = '';
        plg.CustomerId = '';
        plg.SpecialType = '';
        plg.Roles =  new List<String>{'Tenant','Tenant'};
        plg.ArchivedOn = '2021-09-22';
        /* plg.AccountDetails = new List<String>{'Tenant','Tenant'}; */
        plg.Reference = '';
        plg.Website = '';
        plg.ABN = '';
        plg.PersonMigrated = false;
        plg.Labels = '';
        plg.Notes = '';
        plg.NameText = '';
        plg.PostalAddressText = '';
        plg.PhysicalAddressText = '';
        plg.CreatedOn = '2021-09-22';
        plg.UpdatedOn = '2021-09-22';
        plg.TradeName = '';
        plg.HomePhone = '';
        plg.WorkPhone = '';
        plg.CellPhone = '';
        plg.Email = '';
        plg.SupplierChartAccountId = '';
        plg.IsArchived = false;   
        plg.IsSupplier = false;
        plg.IsTenant = true;    
        plg.IsOwner = false;    
        plg.IsSeller  = false;   
        plg.PhoneText = '';   
        plg.WorkPhoneText = '';
        plg.ContactPhone = '';
        plg.Timestamp   = 12345; 
        plg.PrimaryPerson   = ''; 
        plg.Phone  = '';
        plg.PrimaryPostalAddress  = '';  
        plg.PrimaryPhysicalAddress   = '';
        plg.RolesString= '';
        
        	
        plgCP.Id = '';
        plgCP.CustomerId = '';
        plgCP.ContactId = '';
        plgCP.Salutation = '';
        plgCP.FirstName = '';
        plgCP.LastName = '';
        plgCP.CompanyName = '';
        plgCP.Email = '';
        plgCP.SecondaryEmailAddresses = new List<String>{'test@test.com','test@test.com'};
        plgCP.HomePhone = '';
        plgCP.WorkPhone = '';
        plgCP.CellPhone   = '';      
        plgCP.NormalisedMobilePhone  = '';       
        plgCP.CommunicationPreferences = new List<String>{'C1','C2'};       
        plgCP.IsPrimary   = false;      
        plgCP.SortOrder   = 1;     
        plgCP.FullName  = '';       
        plgCP.CombinedPhones  = '';  
        
        plgPCP.Id = '';
        plgPCP.CustomerId = '';
        plgPCP.ContactId = '';
        plgPCP.Salutation = '';
        plgPCP.FirstName = '';
        plgPCP.LastName = '';
        plgPCP.CompanyName = '';
        plgPCP.Email = '';
        plgPCP.SecondaryEmailAddresses = new List<String>{'test@test.com','test@test.com'};
        plgPCP.HomePhone = '';
        plgPCP.WorkPhone = '';
        plgPCP.CellPhone   = '';      
        plgPCP.NormalisedMobilePhone  = '';       
        plgPCP.CommunicationPreferences = new List<String>{'C1','C2'};       
        plgPCP.IsPrimary   = false;      
        plgPCP.SortOrder   = 1;     
        plgPCP.FullName  = '';       
        plgPCP.CombinedPhones  = ''; 
               
        plgPHA.Unit = '';
        plgPHA.StreetNumber_X = '';
        plgPHA.Street = '';
        plgPHA.Suburb = '';
        plgPHA.PostalCode = '';
        plgPHA.State = '';
        plgPHA.Country = '';
        plgPHA.BuildingName = '';
        plgPHA.MailboxName = '';
        plgPHA.Latitude = 0;
        plgPHA.Longitude = 0;
        plgPHA.Text = '';
        plgPHA.Reference = '';	
               
        plgPOA.Unit = '';
        plgPOA.StreetNumber_X = '';
        plgPOA.Street = '';
        plgPOA.Suburb = '';
        plgPOA.PostalCode = '';
        plgPOA.State = '';
        plgPOA.Country = '';
        plgPOA.BuildingName = '';
        plgPOA.MailboxName = '';
        plgPOA.Latitude = 0;
        plgPOA.Longitude = 0;
        plgPOA.Text = '';
        plgPOA.Reference = '';	
        
		List<PropertyLotsTenantGenerations> obj =  PropertyLotsTenantGenerations.parse(json);
		System.assert(obj != null);
	}

}