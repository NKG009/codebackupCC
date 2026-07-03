/*******************************************************************************************
* @Name         PropertiesDataUpsertTest
* @Author       Rajesh
@Description  This class contains all methods to provide code coverage for apex class 'PropertiesDataUpsert'.
*******************************************************************************************/
@isTest(seeAllData = false)
public class PropertyLotsDataUpsertTest {
    
    static Property_Me_API_Configuration__mdt ptCMD =  new Property_Me_API_Configuration__mdt();    
    
    @isTest
    static void testPMCustomMetaData() {
       CustomMetadataService cms = new  CustomMetadataService('PM_Lots','PM_Lots','PM Lots','Property Me');
       ptCMD = CustomMetadataService.getPMCustomMetadataRecord();
    }
    
     @isTest
    static void testPropUpsertSuccess() {	
        
        String propertyJson=		'['+
		'    {'+
		'        \"OwnerContactReference\": \"Victoria Cavallo & Joe Cavallo\",'+
		'        \"TenantContactReference\": \"Jane Bobly TENANT REFERENCE\",'+
		'        \"RentAmount\": 100.00,'+
		'        \"RentPeriod\": \"weekly\",'+
		'        \"TenancyStart\": \"2021-08-24\",'+
		'        \"TenancyEnd\": null,'+
		'        \"AgreementStart\": \"2021-08-24\",'+
		'        \"AgreementEnd\": null,'+
		'        \"OwnerContactId\": \"ad8e0075-6794-4888-9b3e-f4be421dbbf4\",'+
		'        \"TenantContactId\": \"ad8e0078-3deb-4c60-90fb-f07c588fe842\",'+
		'        \"Vacant\": false,'+
		'        \"ManagerName\": \"Tony Wagener\",'+
		'        \"EffectivePaidTo\": \"2021-08-23\",'+
		'        \"OwnershipUpdatedOn\": \"2021-08-24T02:08:26.0000000Z\",'+
		'        \"TenancyUpdatedOn\": \"2021-08-24T02:11:30.0000000Z\",'+
		'        \"SaleAgreementUpdatedOn\": \"0001-01-01\",'+
		'        \"Timestamp\": 637661858830000000,'+
		'        \"PropertyType\": \"House\",'+
		'        \"CommercialCategory\": \"Other\",'+
		'        \"Id\": \"ad8e0074-58b9-4270-8514-6c5ab4f94cee\",'+
		'        \"CustomerId\": \"abc300cb-1b5d-4cd9-9e88-8ee084e06869\",'+
		'        \"Reference\": \"KEDU54\",'+
		'        \"Address\": {'+
		'            \"Unit\": \"\",'+
		'            \"Number\": \"54\",'+
		'            \"Street\": \"Kedumba Cres\",'+
		'            \"Suburb\": \"North Turramurra\",'+
		'            \"PostalCode\": \"2074\",'+
		'            \"State\": \"NSW\",'+
		'            \"Country\": \"Australia\",'+
		'            \"BuildingName\": \"\",'+
		'            \"MailboxName\": \"\",'+
		'            \"Latitude\": -33.7111725,'+
		'            \"Longitude\": 151.1498323,'+
		'            \"Text\": \"54 Kedumba Cres\\nNorth Turramurra NSW 2074\",'+
		'            \"Reference\": \"Kedumba Cres, 54\"'+
		'        },'+
		'        \"AddressText\": \"54 Kedumba Cres, North Turramurra NSW 2074\",'+
		'        \"PrimaryType\": \"Residential\",'+
		'        \"PropertySubtype\": \"House\",'+
		'        \"Bedrooms\": 0,'+
		'        \"Bathrooms\": 0,'+
		'        \"CarSpaces\": 0,'+
		'        \"Area\": null,'+
		'        \"AreaUnit\": \"SquareMetres\",'+
		'        \"LandArea\": null,'+
		'        \"LandAreaUnit\": \"SquareMetres\",'+
		'        \"Description\": \"\",'+
		'        \"Notes\": \"\",'+
		'        \"NextInspectionOn\": null,'+
		'        \"KeyNumber\": \"\",'+
		'        \"ArchivedOn\": null,'+
		'        \"AdRentAmount\": null,'+
		'        \"AdRentPeriod\": null,'+
		'        \"ActiveOwnershipId\": \"ad8e0075-972c-4453-a38c-c943e27117b8\",'+
		'        \"ActiveSaleAgreementId\": null,'+
		'        \"ActiveTenancyId\": \"ad8e0066-4db7-ff78-a60b-73d526a01015\",'+
		'        \"Longitude\": 151.1498323,'+
		'        \"Latitude\": -33.7111725,'+
		'        \"InspectionFrequency\": null,'+
		'        \"InspectionFrequencyType\": \"weekly\",'+
		'        \"InitialInspectionFrequency\": null,'+
		'        \"InitialInspectionFrequencyType\": \"weekly\",'+
		'        \"MainPhotoDocumentId\": null,'+
		'        \"ActiveManagerMemberId\": \"abc300cb-2704-4480-aa5e-7251b1c2a36b\",'+
		'        \"Labels\": \"\",'+
		'        \"StrataManagerContactId\": null,'+
		'        \"RuralCategory\": \"Cropping\",'+
		'        \"IsRental\": true,'+
		'        \"IsArchived\": false,'+
		'        \"CreatedOn\": \"2021-08-24T02:07:05.0000000Z\",'+
		'        \"UpdatedOn\": \"2021-09-02T13:24:43.0000000Z\",'+
		'        \"ExternalListingId\": \"\",'+
		'        \"ActiveRentalListingId\": null,'+
		'        \"ActiveSaleListingId\": null'+
		'    }'+
		']';
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Me',propertyJson,true));
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        PropertyLotsDataUpsert.getLotsDataUpsert('PM_Lots','PMLots','Property Services 360'); 
        PropertyLotsDataUpsertduplicate.getLotsDataUpsert('Property Services 360');
        Test.stopTest();
    }
    
    @isTest
    static void testPropUnSuccessResponse() {
        
        String propertyJson=		'['+
		'    {'+
		'        \"OwnerContactReference\": \"Victoria Cavallo & Joe Cavallo\",'+
		'        \"TenantContactReference\": \"Jane Bobly TENANT REFERENCE\",'+
		'        \"RentAmount\": 100.00,'+
		'        \"RentPeriod\": \"weekly\",'+
		'        \"TenancyStart\": \"2021-08-24\",'+
		'        \"TenancyEnd\": null,'+		
		'        \"AgreementEnd\": null,'+
		'        \"OwnerContactId\": \"ad8e0075-6794-4888-9b3e-f4be421dbbf4\",'+
		'        \"TenantContactId\": \"ad8e0078-3deb-4c60-90fb-f07c588fe842\",'+
		'        \"Vacant\": false,'+
		'        \"ManagerName\": \"Tony Wagener\",'+
		'        \"EffectivePaidTo\": \"2021-08-23\",'+
		'        \"OwnershipUpdatedOn\": \"2021-08-24T02:08:26.0000000Z\",'+
		'        \"TenancyUpdatedOn\": \"2021-08-24T02:11:30.0000000Z\",'+
		'        \"SaleAgreementUpdatedOn\": \"0001-01-01\",'+
		'        \"Timestamp\": 637661858830000000,'+
		'        \"PropertyType\": \"House\",'+
		'        \"CommercialCategory\": \"Other\",'+
		'        \"Id\": \"ad8e0074-58b9-4270-8514-6c5ab4f94cee\",'+
		'        \"CustomerId\": \"abc300cb-1b5d-4cd9-9e88-8ee084e06869\",'+
		'        \"Reference\": \"KEDU54\",'+
		'        \"Address\": {'+
		'            \"Unit\": \"\",'+
		'            \"Number\": \"54\",'+
		'            \"Street\": \"Kedumba Cres\",'+
		'            \"Suburb\": \"North Turramurra\",'+
		'            \"PostalCode\": \"2074\",'+
		'            \"State\": \"NSW\",'+
		'            \"Country\": \"Australia\",'+
		'            \"BuildingName\": \"\",'+
		'            \"MailboxName\": \"\",'+
		'            \"Latitude\": -33.7111725,'+
		'            \"Longitude\": 151.1498323,'+
		'            \"Text\": \"54 Kedumba Cres\\nNorth Turramurra NSW 2074\",'+
		'            \"Reference\": \"Kedumba Cres, 54\"'+
		'        },'+
		'        \"AddressText\": \"54 Kedumba Cres, North Turramurra NSW 2074\",'+
		'        \"PrimaryType\": \"Residential\",'+
		'        \"PropertySubtype\": \"House\",'+
		'        \"Bedrooms\": 0,'+
		'        \"Bathrooms\": 0,'+
		'        \"CarSpaces\": 0,'+
		'        \"Area\": null,'+
		'        \"AreaUnit\": \"SquareMetres\",'+
		'        \"LandArea\": null,'+
		'        \"LandAreaUnit\": \"SquareMetres\",'+
		'        \"Description\": \"\",'+
		'        \"Notes\": \"\",'+
		'        \"NextInspectionOn\": null,'+
		'        \"KeyNumber\": \"\",'+
		'        \"ArchivedOn\": null,'+
		'        \"AdRentAmount\": null,'+
		'        \"AdRentPeriod\": null,'+
		'        \"ActiveOwnershipId\": \"ad8e0075-972c-4453-a38c-c943e27117b8\",'+
		'        \"ActiveSaleAgreementId\": null,'+
		'        \"ActiveTenancyId\": \"ad8e0066-4db7-ff78-a60b-73d526a01015\",'+
		'        \"Longitude\": 151.1498323,'+
		'        \"Latitude\": -33.7111725,'+
		'        \"InspectionFrequency\": null,'+
		'        \"InspectionFrequencyType\": \"weekly\",'+
		'        \"InitialInspectionFrequency\": null,'+
		'        \"InitialInspectionFrequencyType\": \"weekly\",'+
		'        \"MainPhotoDocumentId\": null,'+
		'        \"ActiveManagerMemberId\": \"abc300cb-2704-4480-aa5e-7251b1c2a36b\",'+
		'        \"Labels\": \"\",'+
		'        \"StrataManagerContactId\": null,'+
		'        \"RuralCategory\": \"Cropping\",'+
		'        \"IsRental\": true,'+
		'        \"IsArchived\": false,'+
		'        \"CreatedOn\": \"2021-08-24T02:07:05.0000000Z\",'+
		'        \"UpdatedOn\": \"2021-09-02T13:24:43.0000000Z\",'+
		'        \"ExternalListingId\": \"\",'+
		'        \"ActiveRentalListingId\": null,'+
		'        \"ActiveSaleListingId\": null'+
		'    }'+
		']';
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Me',propertyJson,false));
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        PropertyLotsDataUpsert.getLotsDataUpsert('PM_Lots','PMLots','Property Services 360'); 
         PropertyLotsDataUpsertduplicate.getLotsDataUpsert('Property Services 360');
        Test.stopTest();
    }
     @isTest
    static void testPropUpsertFailed() {
        
       String propertyJson=		'['+
		'    {'+
		'        \"OwnerContactReference\": \"Victoria Cavallo & Joe Cavallo\",'+
		'        \"TenantContactReference\": \"Jane Bobly TENANT REFERENCE\",'+
		'        \"RentAmount\": 100.00,'+
		'        \"RentPeriod\": \"weekly\",'+
		'        \"TenancyStart\": \"2021-08-24\",'+
		'        \"TenancyEnd\": null,'+
		'        \"AgreementStart\": \"2021-08-24\",'+
		'        \"AgreementEnd\": null,'+
		'        \"OwnerContactId\": \"ad8e0075-6794-4888-9b3e-f4be421dbbf4\",'+
		'        \"TenantContactId\": \"ad8e0078-3deb-4c60-90fb-f07c588fe842\",'+
		'        \"Vacant\": false,'+
		'        \"ManagerName\": \"Tony Wagener\",'+
		'        \"EffectivePaidTo\": \"2021-08-23\",'+
		'        \"OwnershipUpdatedOn\": \"2021-08-24T02:08:26.0000000Z\",'+
		'        \"TenancyUpdatedOn\": \"2021-08-24T02:11:30.0000000Z\",'+
		'        \"SaleAgreementUpdatedOn\": \"0001-01-01\",'+
		'        \"Timestamp\": 637661858830000000,'+
		'        \"PropertyType\": \"House\",'+
		'        \"CommercialCategory\": \"Other\",'+
		'        \"CustomerId\": \"abc300cb-1b5d-4cd9-9e88-8ee084e06869\",'+
		'        \"Reference\": \"KEDU54\",'+
		'        \"Address\": {'+
		'            \"Unit\": \"\",'+
		'            \"Number\": \"54\",'+
		'            \"Street\": \"Kedumba Cres\",'+
		'            \"Suburb\": \"North Turramurra\",'+
		'            \"PostalCode\": \"2074\",'+
		'            \"State\": \"NSW\",'+
		'            \"Country\": \"Australia\",'+
		'            \"BuildingName\": \"\",'+
		'            \"MailboxName\": \"\",'+
		'            \"Latitude\": -33.7111725,'+
		'            \"Longitude\": 151.1498323,'+
		'            \"Text\": \"54 Kedumba Cres\\nNorth Turramurra NSW 2074\",'+
		'            \"Reference\": \"Kedumba Cres, 54\"'+
		'        },'+
		'        \"AddressText\": \"54 Kedumba Cres, North Turramurra NSW 2074\",'+
		'        \"PrimaryType\": \"Residential\",'+
		'        \"PropertySubtype\": \"House\",'+
		'        \"Bedrooms\": 0,'+
		'        \"Bathrooms\": 0,'+
		'        \"CarSpaces\": 0,'+
		'        \"Area\": null,'+
		'        \"AreaUnit\": \"SquareMetres\",'+
		'        \"LandArea\": null,'+
		'        \"LandAreaUnit\": \"SquareMetres\",'+
		'        \"Description\": \"\",'+
		'        \"Notes\": \"\",'+
		'        \"NextInspectionOn\": null,'+
		'        \"KeyNumber\": \"\",'+
		'        \"ArchivedOn\": null,'+
		'        \"AdRentAmount\": null,'+
		'        \"AdRentPeriod\": null,'+
		'        \"ActiveOwnershipId\": \"ad8e0075-972c-4453-a38c-c943e27117b8\",'+
		'        \"ActiveSaleAgreementId\": null,'+
		'        \"ActiveTenancyId\": \"ad8e0066-4db7-ff78-a60b-73d526a01015\",'+
		'        \"Longitude\": 151.1498323,'+
		'        \"Latitude\": -33.7111725,'+
		'        \"InspectionFrequency\": null,'+
		'        \"InspectionFrequencyType\": \"weekly\",'+
		'        \"InitialInspectionFrequency\": null,'+
		'        \"InitialInspectionFrequencyType\": \"weekly\",'+
		'        \"MainPhotoDocumentId\": null,'+
		'        \"ActiveManagerMemberId\": \"abc300cb-2704-4480-aa5e-7251b1c2a36b\",'+
		'        \"Labels\": \"\",'+
		'        \"StrataManagerContactId\": null,'+
		'        \"RuralCategory\": \"Cropping\",'+
		'        \"IsRental\": true,'+
		'        \"IsArchived\": false,'+
		'        \"CreatedOn\": \"2021-08-24T02:07:05.0000000Z\",'+
		'        \"UpdatedOn\": \"2021-09-02T13:24:43.0000000Z\",'+
		'        \"ExternalListingId\": \"\",'+
		'        \"ActiveRentalListingId\": null,'+
		'        \"ActiveSaleListingId\": null'+
		'    }'+
		']';
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Me',propertyJson,true));
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        PropertyLotsDataUpsert.getLotsDataUpsert('PM_Lots','PMLots','Property Services 360');  
         PropertyLotsDataUpsertduplicate.getLotsDataUpsert('Property Services 360');
        Test.stopTest();
    }

}