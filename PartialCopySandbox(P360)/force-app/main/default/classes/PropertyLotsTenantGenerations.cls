/*******************************************************************************************
* @Name         PropertyLotsTenantGenerations 
* @Author       Rajesh & Badri
* @Description  This class Convert JSON to Apex for Tenant API (Property Me).
*******************************************************************************************/
public class PropertyLotsTenantGenerations {
	
	public String Id{get;set;}
	public String CustomerId{get;set;}
	public String SpecialType{get;set;}
	public list<String> Roles{get;set;}
	public String ArchivedOn{get;set;}
	//public list<String> AccountDetails{get;set;}
	public String Reference{get;set;}
	public String Website{get;set;}
	public String ABN{get;set;}
	public Boolean PersonMigrated{get;set;}
	public String Labels{get;set;}
	public String Notes{get;set;}
	public String NameText{get;set;}
	public String PostalAddressText{get;set;}
	public String PhysicalAddressText{get;set;}
	public String CreatedOn{get;set;}
	public String UpdatedOn{get;set;}
	public String TradeName{get;set;}
	public String HomePhone{get;set;}
	public String WorkPhone{get;set;}
	public String CellPhone{get;set;}
	public String Email{get;set;}
	public String SupplierChartAccountId{get;set;}
	public Boolean IsArchived{get;set;}    
    public Boolean IsSupplier{get;set;}  
    public Boolean IsTenant{get;set;}    
    public Boolean IsOwner{get;set;}    
    public Boolean IsSeller{get;set;}    
    public String PhoneText{get;set;}    
    public String WorkPhoneText{get;set;}
    public String ContactPhone{get;set;}
    public list<ContactPersons> ContactPersons{get;set;}
	public PrimaryContactPerson PrimaryContactPerson{get;set;}
	public Decimal Timestamp{get;set;}    
    public String PrimaryPerson{get;set;}    
    public String Phone{get;set;}  
    public String PrimaryPostalAddress{get;set;}    
    public String PrimaryPhysicalAddress{get;set;}   
    public String RolesString{get;set;}
	
	public class ContactPersons{	
		public String Id{get;set;}
		public String CustomerId{get;set;}
		public String ContactId{get;set;}
		public String Salutation{get;set;}
		public String FirstName{get;set;}
		public String LastName{get;set;}
		public String CompanyName{get;set;}
		public String Email{get;set;}
		public list<String> SecondaryEmailAddresses{get;set;}
		public String HomePhone{get;set;}
		public String WorkPhone{get;set;}
        public String CellPhone{get;set;}        
        public String NormalisedMobilePhone{get;set;}        
        public list<String> CommunicationPreferences{get;set;}       
        public PhysicalAddress PhysicalAddress{get;set;}        
        public PostalAddress PostalAddress{get;set;}        
        public Boolean IsPrimary{get;set;}        
        public Integer SortOrder{get;set;}        
        public String FullName{get;set;}        
        public String CombinedPhones{get;set;}        
    }
    public class PrimaryContactPerson{
        public String Id{get;set;}
		public String CustomerId{get;set;}
		public String ContactId{get;set;}
		public String Salutation{get;set;}
		public String FirstName{get;set;}
		public String LastName{get;set;}
		public String CompanyName{get;set;}
		public String Email{get;set;}
		public list<String> SecondaryEmailAddresses{get;set;}
		public String HomePhone{get;set;}
		public String WorkPhone{get;set;}
        public String CellPhone{get;set;}        
        public String NormalisedMobilePhone{get;set;}        
        public list<String> CommunicationPreferences{get;set;}       
        public PhysicalAddress PhysicalAddress{get;set;}        
        public PostalAddress PostalAddress{get;set;}        
        public Boolean IsPrimary{get;set;}        
        public Integer SortOrder{get;set;}        
        public String FullName{get;set;}        
        public String CombinedPhones{get;set;}        
    }
    public class PhysicalAddress{        
		public String Unit{get;set;}
        public String StreetNumber_X{get;set;}
		public String Street{get;set;}
        public String Suburb{get;set;}
		public String PostalCode{get;set;}
		public String State{get;set;}
        public String Country{get;set;}
        public String BuildingName{get;set;}
		public String MailboxName{get;set;}
		public Decimal Latitude{get;set;}
		public Decimal Longitude{get;set;}
		public String Text{get;set;}
        public String Reference{get;set;}		
    }
	public class PostalAddress{
        public String Unit{get;set;}
        public String StreetNumber_X{get;set;}
		public String Street{get;set;}
        public String Suburb{get;set;}
		public String PostalCode{get;set;}
		public String State{get;set;}
        public String Country{get;set;}
        public String BuildingName{get;set;}
		public String MailboxName{get;set;}
		public Decimal Latitude{get;set;}
		public Decimal Longitude{get;set;}
		public String Text{get;set;}
        public String Reference{get;set;}
    }
	
	  
	public static List<PropertyLotsTenantGenerations> parse(String json) {
        json = json.replace('"Number":', '"StreetNumber_X":');
		return (List<PropertyLotsTenantGenerations>) System.JSON.deserialize(json, List<PropertyLotsTenantGenerations>.class);
	}
}