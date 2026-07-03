/*******************************************************************************************
* @Name         PropertyLotsGenerations 
* @Author       Rajesh & Badri
* @Description  This class Convert JSON to Apex for Lots API (Property Me).
*******************************************************************************************/
public class PropertyLotsGenerations{
		public String PrimaryType{get;set;}
		public String AddressText{get;set;}
		public String PropertySubtype{get;set;}
		public Address Address{get;set;}
		public Integer Bedrooms{get;set;}
		public String Description{get;set;}
		public String LandAreaUnit{get;set;}
		public String Notes{get;set;}
		public String LandArea{get;set;}
		public String NextInspectionOn{get;set;}
		public String AreaUnit{get;set;}
		public String KeyNumber{get;set;}
		public String Area{get;set;}
		public String ArchivedOn{get;set;}
		public Integer CarSpaces{get;set;}
		public String AdRentAmount{get;set;}
		public Integer Bathrooms{get;set;}
		public String AdRentPeriod{get;set;}
		public String Reference{get;set;}
		public String ActiveOwnershipId{get;set;}
		public String CustomerId{get;set;}
		public String ActiveSaleAgreementId{get;set;}
		public String Id{get;set;}
		public String ActiveTenancyId{get;set;}
		public String CommercialCategory{get;set;}
		public Decimal Longitude{get;set;}
		public String PropertyType{get;set;}
		public Decimal Latitude{get;set;}
		public Decimal Timestamp{get;set;}
		public String InspectionFrequency{get;set;}
		public String SaleAgreementUpdatedOn{get;set;}
		public String InspectionFrequencyType{get;set;}
		public String TenancyUpdatedOn{get;set;}
		public String InitialInspectionFrequency{get;set;}
		public String OwnershipUpdatedOn{get;set;}
		public String InitialInspectionFrequencyType{get;set;}
		public String EffectivePaidTo{get;set;}
		public String MainPhotoDocumentId{get;set;}
		public String ManagerName{get;set;}
		public String ActiveManagerMemberId{get;set;}
		public Boolean Vacant{get;set;}
		public String Labels{get;set;}
		public String TenantContactId{get;set;}
		public String StrataManagerContactId{get;set;}
		public String OwnerContactId{get;set;}
		public String RuralCategory{get;set;}
		public String AgreementEnd{get;set;}
		public Boolean IsRental{get;set;}
		public String AgreementStart{get;set;}
		public Boolean IsArchived{get;set;}
		public String TenancyEnd{get;set;}
		public String CreatedOn{get;set;}
		public String TenancyStart{get;set;}
		public String UpdatedOn{get;set;}
		public String RentPeriod{get;set;}
		public String ExternalListingId{get;set;}
		public Decimal RentAmount{get;set;}
		public String ActiveRentalListingId{get;set;}
		public String TenantContactReference{get;set;}
		public String ActiveSaleListingId{get;set;}
		public String OwnerContactReference{get;set;}
	public class Address{
		public String Reference{get;set;}
		public String Country{get;set;}
		public String State{get;set;}
		public String BuildingName{get;set;}
		public String PostalCode{get;set;}
		public String MailboxName{get;set;}
		public String Suburb{get;set;}
		public Decimal Latitude{get;set;}
		public String Street{get;set;}
		public Decimal Longitude{get;set;}
		public String StreetNumber_X{get;set;}
		public String Text{get;set;}
		public String Unit{get;set;}
	}
	
	public static List<PropertyLotsGenerations> parse(String json) {
        
        json = json.replace('"Number":', '"StreetNumber_X":');
		return (List<PropertyLotsGenerations>) System.JSON.deserialize(json, List<PropertyLotsGenerations>.class);
	}	
}