public class icDTOShippingRequest {
	public String ApplicationID {get; set;}
	// Application Key (provided by Cogeco) to identify Caller (e.g. SALESFORCE current case) (Mandatory),
	
	public String OrderID {get; set;}
	// Shipping Request Identifier (Mandatory),
	
	public String ClientID {get; set;}
	// Recipient's Internal Identifier (Mandatory),
	
	public String FirstName {get; set;}
	// Recipient's First Name,
	
	public String LastName {get; set;}
	// Recipient's Last Name,
	
	public String TitleOrDept {get; set;}
	// Recipient's Title or Department,
	
	public String CompanyName {get; set;}
	// Recipient's Company Name (if applicable),
	
	public String AdditionalAddressInformation {get; set;}
	// Recipient's Additional Address info (e.g. c/o XXX, etc),
	
	public String AddressLine1 {get; set;}
	// Recipient's Street Address (unit, street number, street name)(Mandatory),
	
	public String City {get; set;}
	// Recipient's Municipality (Mandatory),
	
	public String ProvinceOrState {get; set;}
	// Recipient's Province - 2 character province code required (e.g. ON, QC)(Mandatory),
	
	public String PostalCode {get; set;}
	// Recipient's Postal Code (Mandatory),
	
	public String CountryCode {get; set;}
	// Recipient's Country - 2 character country code required (e.g. CA) (Mandatory),
	
	public String ClientVoicePhone {get; set;}
	// Recipient's Phone Number,
	
	public String ClientEmail {get; set;}
	// Recipient's Email Addresss - to provide customer email notifications,
	
	public String Email2 {get; set;}
	// Recipient's Secondary Email (if applicable) - to provide customer email notifications,
	
	public String Weight {get; set;}
	// Scale weight of the shipment. Default to 'nil' - unit is in grams,
	
	public String Length {get; set;}
	// Measured Length of the shipping package. Default to 'nil' - unit is in millimeters,
	
	public String Width {get; set;}
	// Measured Width of the shipping package. Default to 'nil' - unit is in millimeters,
	
	public String Height {get; set;}
	// Measured Height of the shipping package. Default to 'nil' - unit is in millimeters,
	
	public String EmailNotification {get; set;}
	// default to 'false', true indicates only final delivery notification will be sent, false means all notifications will be sent to recipient email address(es),
	
	public String ShippingReturnRequired {get; set;}
	// default to 'false'. true indicates that a return shipping label is required,
	
	public String IsEquipmentSwap {get; set;}
	//N,
	
	public String CpeResourceCategoryCode {get; set;}
	// default to 'nil', Equipment cateogry identifier for HTD equipment (in AMS tracking),
	
	public String ResourceCustomerRelationship {get; set;}
	//N,
	
	public String AccessoryCode {get; set;}
	// default to 'nil'. Shipping Item Code descriptor - for 'accessory' devices (not in AMS tracking),
	
	public String SpecialInstructions {get; set;}
	// Special Shipping Instructions,
	
	public String BusinessUnit {get; set;}
	// Cogeco business unit responsible for processing the order (ON/QC) (Mandatory)
	
}