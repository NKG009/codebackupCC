/*******************************************************************************************
* @Name         PropertyLotsGenerationsTest
* @Author       Rajesh
* @Description  This class contains all methods to provide code coverage for apex class 'PropertyLotsGenerations'.
*******************************************************************************************/
@isTest
public class PropertyLotsGenerationsTest {
    @isTest
    static void testPropertyLotsParse() {
		
        String json = '['+
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
        PropertyLotsGenerations plg = new PropertyLotsGenerations();
        PropertyLotsGenerations.Address plga =  new PropertyLotsGenerations.Address();
        plg.PrimaryType = '';
        plg.AddressText = '';
        plg.PropertySubtype = '';
        plg.Bedrooms = 0;
        plg.Description = '';
        plg.LandAreaUnit = '';
        plg.Notes = '';
        plg.LandArea = '';
        plg.NextInspectionOn = '';
        plg.AreaUnit = '';
        plg.KeyNumber = '';
        plg.Area = '';
        plg.ArchivedOn = '';
        plg.CarSpaces = 0;
        plg.AdRentAmount = '';
        plg.Bathrooms = 0;
        plg.AdRentPeriod = '';
        plg.Reference = '';
        plg.ActiveOwnershipId = '';
        plg.CustomerId = '';
        plg.ActiveSaleAgreementId = '';
        plg.Id = '';
        plg.ActiveTenancyId = '';
        plg.CommercialCategory = '';
        plg.Longitude = 0;
        plg.PropertyType = '';
        plg.Latitude = 0;
        plg.Timestamp = 0;
        plg.InspectionFrequency = '';
        plg.SaleAgreementUpdatedOn = '';
        plg.InspectionFrequencyType = '';
        plg.TenancyUpdatedOn = '';
        plg.InitialInspectionFrequency = '';
        plg.OwnershipUpdatedOn = '';
        plg.InitialInspectionFrequencyType = '';
        plg.EffectivePaidTo = '';
        plg.MainPhotoDocumentId = '';
        plg.ManagerName = '';
        plg.ActiveManagerMemberId = '';
        plg.Vacant = false;
        plg.Labels = '';
        plg.TenantContactId = '';
        plg.StrataManagerContactId = '';
        plg.OwnerContactId = '';
        plg.RuralCategory = '';
        plg.AgreementEnd = '';
        plg.IsRental = false;
        plg.AgreementStart = '';
        plg.IsArchived = false;
        plg.TenancyEnd = '';
        plg.CreatedOn = '';
        plg.TenancyStart = '';
        plg.UpdatedOn = '';
        plg.RentPeriod = '';
        plg.ExternalListingId = '';
        plg.RentAmount = 0;
        plg.ActiveRentalListingId = '';
        plg.TenantContactReference = '';
        plg.ActiveSaleListingId = '';
        plg.OwnerContactReference = '';
        plga.Reference = '';
        plga.Country = '';
        plga.State = '';
        plga.BuildingName = '';
        plga.PostalCode = '';
        plga.MailboxName = '';
        plga.Suburb = '';
        plga.Latitude = 0;
        plga.Street = '';
        plga.Longitude = 0;
        plga.StreetNumber_X = '';
        plga.Text = '';
        plga.Unit = '';
		List<PropertyLotsGenerations> r = PropertyLotsGenerations.parse(json);
		System.assert(r != null);
	}
}