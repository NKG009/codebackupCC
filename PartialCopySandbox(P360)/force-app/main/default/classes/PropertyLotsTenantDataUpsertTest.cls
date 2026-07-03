/*******************************************************************************************
* @Name         PropertyLotsTenantDataUpsertTest
* @Author       Rajesh
@Description  This class contains all methods to provide code coverage for apex class 'PropertyLotsTenantDataUpsert'.
*******************************************************************************************/
@isTest(seeAllData = false)
public class PropertyLotsTenantDataUpsertTest {
	
    static Property_Me_API_Configuration__mdt ptCMD =  new Property_Me_API_Configuration__mdt();    
    
    @isTest
    static void testPMCustomMetaData() {
       CustomMetadataService cms = new  CustomMetadataService('PM_Tenants','PM_Tenants','PM Tenants','Property Me');
       ptCMD = CustomMetadataService.getPMCustomMetadataRecord();
    }
    
     @isTest
    static void testPropUpsertSuccess() {	
        
        String propertyJson=		'[{'+
		'        \"Id\": \"ada4006a-0b1f-43b9-bdde-fab7aef4888e\",'+
		'        \"CustomerId\": \"abc300cb-1b5d-4cd9-9e88-8ee084e06869\",'+
		'        \"SpecialType\": \"None\",'+
		'        \"Roles\": ['+
		'            \"tenant\",'+
		'            \"tenant\"'+
		'        ],'+
		'        \"ArchivedOn\": null,'+
		'        \"AccountDetails\": [],'+
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
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Me',propertyJson,true));
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        PropertyLotsTenantDataUpsert.getPropertyLotsTenantDataUpsert('PM_Tenants','PMLotTenants','Property Services 360'); 
        PropertyLotsTenantDataUpsertDuplicate.getPropertyLotsTenantDataUpsert('Property_Me_NC');

        Test.stopTest();
    }
    
    @isTest
    static void testPropUnSuccessResponse() {	
        
        String propertyJson=	'[{'+
		'        \"Id\": \"ada4006a-0b1f-43b9-bdde-fab7aef4888e\",'+
		'        \"CustomerId\": \"abc300cb-1b5d-4cd9-9e88-8ee084e06869\",'+
		'        \"SpecialType\": \"None\",'+
		'        \"Roles\": ['+
		'            \"tenant\",'+
		'            \"tenant\"'+
		'        ],'+
		'        \"ArchivedOn\": null,'+
		'        \"AccountDetails\": [],'+
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
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Me',propertyJson,false));
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        PropertyLotsTenantDataUpsert.getPropertyLotsTenantDataUpsert('PM_Tenants','PMLotTenants','Property Services 360'); 
        PropertyLotsTenantDataUpsertDuplicate.getPropertyLotsTenantDataUpsert('Property_Me_NC');

        Test.stopTest();
    }
      @isTest
    static void testPropUpsertFailed() {
        String propertyJson=		'[{'+
		
		'        \"CustomerId\": \"abc300cb-1b5d-4cd9-9e88-8ee084e06869\",'+
		'        \"SpecialType\": \"None\",'+
		'        \"Roles\": ['+
		'            \"tenant\",'+
		'            \"tenant\"'+
		'        ],'+
		'        \"ArchivedOn\": null,'+
		'        \"AccountDetails\": [],'+
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
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Me',propertyJson,true));
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        PropertyLotsTenantDataUpsert.getPropertyLotsTenantDataUpsert('PM_Tenants','PMLotTenants','Property Services 360');  
        PropertyLotsTenantDataUpsertDuplicate.getPropertyLotsTenantDataUpsert('Property_Me_NC');

        Test.stopTest();
    }
}