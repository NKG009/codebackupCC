public class ArchivingPropertyWrapper {
    
    public String OwnerContactReference {get;set;} 
    public String TenantContactReference {get;set;} 
    public String ManagerName {get;set;} 
    public String ActiveManagerTeams {get;set;} 
    public Integer RentAmount {get;set;} 
    public String RentPeriod {get;set;} 
    public String EffectivePaidTo {get;set;} 
    public String TenancyStart {get;set;} 
    public String TenancyEnd {get;set;} 
    public String AgreementStart {get;set;} 
    public String AgreementEnd {get;set;} 
    public String OwnerContactId {get;set;} 
    public String TenantContactId {get;set;} 
    public String OwnerFolioCode {get;set;} 
    public String TenantFolioCode {get;set;} 
    public String SellerFolioCode {get;set;} 
    public String SearchText {get;set;} 
    public String Id {get;set;} 
    public String CustomerId {get;set;} 
    public String Reference {get;set;} 
    public Address_Z Address {get;set;} 
    public String AddressText {get;set;} 
    public String PrimaryType {get;set;} 
    public String PropertySubtype {get;set;} 
    public Integer Bedrooms {get;set;} 
    public Integer Bathrooms {get;set;} 
    public Integer CarSpaces {get;set;} 
    public String Area {get;set;} 
    public String AreaUnit {get;set;} 
    public String LandArea {get;set;} 
    public String LandAreaUnit {get;set;} 
    public String Description {get;set;} 
    public String Notes {get;set;} 
    public String NextInspectionOn {get;set;} 
    public String KeyNumber {get;set;} 
    public String ArchivedOn {get;set;} 
    public String AdRentAmount {get;set;} 
    public String AdRentPeriod {get;set;} 
    public String ActiveOwnershipId {get;set;} 
    public String ActiveSaleAgreementId {get;set;} 
    public String ActiveTenancyId {get;set;} 
    public String Longitude {get;set;} 
    public String Latitude {get;set;} 
    public Integer InspectionFrequency {get;set;} 
    public String InspectionFrequencyType {get;set;} 
    public Integer InitialInspectionFrequency {get;set;} 
    public String InitialInspectionFrequencyType {get;set;} 
    public String MainPhotoDocumentId {get;set;} 
    public String ActiveManagerMemberId {get;set;} 
    public String Labels {get;set;} 
    public String StrataManagerContactId {get;set;} 
    public String RuralCategory {get;set;} 
    public String DisplayAddress {get;set;} 
    public Boolean IsRental {get;set;} 
    public Boolean IsArchived {get;set;} 
    public String CreatedOn {get;set;} 
    public String UpdatedOn {get;set;} 
    public String ExternalListingId {get;set;} 
    public String ActiveRentalListingId {get;set;} 
    public String ActiveSaleListingId {get;set;} 
    
    
    
    	public ArchivingPropertyWrapper(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'OwnerContactReference') {
						OwnerContactReference =  parser.getText();
					} else if (text == 'TenantContactReference') {
						TenantContactReference =  parser.getText();
					} else if (text == 'ManagerName') {
						ManagerName =  parser.getText();
					} else if (text == 'ActiveManagerTeams') {
						ActiveManagerTeams =  parser.getText();
					} else if (text == 'RentAmount') {
						RentAmount = parser.getIntegerValue();
					} else if (text == 'RentPeriod') {
						RentPeriod = parser.getText();
					} else if (text == 'EffectivePaidTo') {
						EffectivePaidTo =  parser.getText();
					} else if (text == 'TenancyStart') {
						TenancyStart =  parser.getText();
					} else if (text == 'TenancyEnd') {
						TenancyEnd =  parser.getText();
					} else if (text == 'AgreementStart') {
						AgreementStart =  parser.getText();
					} else if (text == 'AgreementEnd') {
						AgreementEnd =  parser.getText();
					} else if (text == 'OwnerContactId') {
						OwnerContactId =  parser.getText();
					} else if (text == 'TenantContactId') {
						TenantContactId = parser.getText();
					} else if (text == 'OwnerFolioCode') {
						OwnerFolioCode =  parser.getText();
					} else if (text == 'TenantFolioCode') {
						TenantFolioCode =  parser.getText();
					} else if (text == 'SellerFolioCode') {
						SellerFolioCode =  parser.getText();
					} else if (text == 'SearchText') {
						SearchText = parser.getText();
					} else if (text == 'Id') {
						Id = parser.getText();
					} else if (text == 'CustomerId') {
						CustomerId = parser.getText();
					} else if (text == 'Reference') {
						Reference = parser.getText();
					} else if (text == 'Address') {
						Address = new Address_Z(parser);
					} else if (text == 'AddressText') {
						AddressText = parser.getText();
					} else if (text == 'PrimaryType') {
						PrimaryType = parser.getText();
					} else if (text == 'PropertySubtype') {
						PropertySubtype = parser.getText();
					} else if (text == 'Bedrooms') {
						Bedrooms = parser.getIntegerValue();
					} else if (text == 'Bathrooms') {
						Bathrooms = parser.getIntegerValue();
					} else if (text == 'CarSpaces') {
						CarSpaces = parser.getIntegerValue();
					} else if (text == 'Area') {
						Area =  parser.getText();
					} else if (text == 'AreaUnit') {
						AreaUnit = parser.getText();
					} else if (text == 'LandArea') {
						LandArea =  parser.getText();
					} else if (text == 'LandAreaUnit') {
						LandAreaUnit = parser.getText();
					} else if (text == 'Description') {
						Description = parser.getText();
					} else if (text == 'Notes') {
						Notes = parser.getText();
					} else if (text == 'NextInspectionOn') {
						NextInspectionOn = parser.getText();
					} else if (text == 'KeyNumber') {
						KeyNumber = parser.getText();
					} else if (text == 'ArchivedOn') {
						ArchivedOn = parser.getText();
					} else if (text == 'AdRentAmount') {
						AdRentAmount =  parser.getText();
					} else if (text == 'AdRentPeriod') {
						AdRentPeriod =  parser.getText();
					} else if (text == 'ActiveOwnershipId') {
						ActiveOwnershipId =  parser.getText();
					} else if (text == 'ActiveSaleAgreementId') {
						ActiveSaleAgreementId =  parser.getText();
					} else if (text == 'ActiveTenancyId') {
						ActiveTenancyId =  parser.getText();
					} else if (text == 'Longitude') {
						Longitude =  parser.getText();
					} else if (text == 'Latitude') {
						Latitude = parser.getText();
					} else if (text == 'InspectionFrequency') {
						InspectionFrequency = parser.getIntegerValue();
					} else if (text == 'InspectionFrequencyType') {
						InspectionFrequencyType = parser.getText();
					} else if (text == 'InitialInspectionFrequency') {
						InitialInspectionFrequency = parser.getIntegerValue();
					} else if (text == 'InitialInspectionFrequencyType') {
						InitialInspectionFrequencyType = parser.getText();
					} else if (text == 'MainPhotoDocumentId') {
						MainPhotoDocumentId =  parser.getText();
					} else if (text == 'ActiveManagerMemberId') {
						ActiveManagerMemberId =  parser.getText();
					} else if (text == 'Labels') {
						Labels =  parser.getText();
					} else if (text == 'StrataManagerContactId') {
						StrataManagerContactId =  parser.getText();
					} else if (text == 'RuralCategory') {
						RuralCategory = parser.getText();
					} else if (text == 'DisplayAddress') {
						DisplayAddress = parser.getText();
					} else if (text == 'IsRental') {
						IsRental = parser.getBooleanValue();
					} else if (text == 'IsArchived') {
						IsArchived = parser.getBooleanValue();
					} else if (text == 'CreatedOn') {
						CreatedOn = parser.getText();
					} else if (text == 'UpdatedOn') {
						UpdatedOn = parser.getText();
					} else if (text == 'ExternalListingId') {
						ExternalListingId =  parser.getText();
					} else if (text == 'ActiveRentalListingId') {
						ActiveRentalListingId =  parser.getText();
					} else if (text == 'ActiveSaleListingId') {
						ActiveSaleListingId =  parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						//consumeString(parser);
					}
				}
			}
		}
	}
  public class Address_Z {
		public String Unit {get;set;} 
		public String Number_Z {get;set;} // in json: Number
		public String Street {get;set;} 
		public String Suburb {get;set;} 
		public String Locality {get;set;} 
		public String PostalCode {get;set;} 
		public String State {get;set;} 
		public String Country {get;set;} 
		public String BuildingName {get;set;} 
		public String MailboxName {get;set;} 
		public Double Latitude {get;set;} 
		public Double Longitude {get;set;} 
		public String Text {get;set;} 
		public String Reference {get;set;}  
      
      public Address_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Unit') {
							Unit = parser.getText();
						} else if (text == 'Number') {
							Number_Z = parser.getText();
						} else if (text == 'Street') {
							Street = parser.getText();
						} else if (text == 'Suburb') {
							Suburb = parser.getText();
						} else if (text == 'Locality') {
							Locality = parser.getText();
						} else if (text == 'PostalCode') {
							PostalCode = parser.getText();
						} else if (text == 'State') {
							State = parser.getText();
						} else if (text == 'Country') {
							Country = parser.getText();
						} else if (text == 'BuildingName') {
							BuildingName = parser.getText();
						} else if (text == 'MailboxName') {
							MailboxName = parser.getText();
						} else if (text == 'Latitude') {
							Latitude = parser.getIntegerValue();
						} else if (text == 'Longitude') {
							Longitude = parser.getIntegerValue();
						} else if (text == 'Text') {
							Text = parser.getText();
						} else if (text == 'Reference') {
							Reference = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Address consuming unrecognized property: '+text);
							//consumeObject(parser);
						}
					}
				}
			}
      }
    
  }  
    
    public static ArchivingPropertyWrapper parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new ArchivingPropertyWrapper(parser);
	}
}