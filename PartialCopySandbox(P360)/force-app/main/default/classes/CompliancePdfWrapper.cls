public class CompliancePdfWrapper {

	public String LotReference {get;set;} 
	public String TenantReference {get;set;} 
	public String OwnerReference {get;set;} 
	public String ContactReference {get;set;} 
	public String ManagerName {get;set;} 
	public Boolean IsLetterStatement {get;set;} 
	public String StatementId {get;set;} 
	public String TaskType {get;set;} 
	public string Timestamp {get;set;} 
	public Boolean OwnerAttending {get;set;} 
	public Boolean TenantAttending {get;set;} 
	public String SupplierReference {get;set;} 
	public String DisplayNumber {get;set;} 
	public Integer Number_Z {get;set;} // in json: Number
	public String Status {get;set;} 
	public String ReportedContactType {get;set;} 
	public String Access {get;set;} 
	public String MainPhotoDocumentId {get;set;} 
	public String DocumentLinkTextName {get;set;} 
	public String QuoteId {get;set;} 
	public String SupplierInstructions {get;set;} 
	public String Id {get;set;} 
	public String CustomerId {get;set;} 
	public String DueDate {get;set;} 
	public String CreatedOn {get;set;} 
	public String ClosedOn {get;set;} 
	public String Summary {get;set;} 
	public String Description {get;set;} 
	public String LotId {get;set;} 
	public String TenantContactId {get;set;} 
	public String OwnerContactId {get;set;} 
	public String ContactId {get;set;} 
	public String ManagerMemberId {get;set;} 
	public String Labels {get;set;} 
	public String UpdatedOn {get;set;} 
    
    public CompliancePdfWrapper(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'LotReference') {
						LotReference = parser.getText();
					} else if (text == 'TenantReference') {
						TenantReference = parser.getText();
					} else if (text == 'OwnerReference') {
						OwnerReference = parser.getText();
					} else if (text == 'ContactReference') {
						ContactReference = parser.getText();
					} else if (text == 'ManagerName') {
						ManagerName = parser.getText();
					} else if (text == 'IsLetterStatement') {
						IsLetterStatement = parser.getBooleanValue();
					} else if (text == 'StatementId') {
						StatementId = parser.getText();
					} else if (text == 'TaskType') {
						TaskType = parser.getText();
					} else if (text == 'Timestamp') {
						Timestamp = parser.getText();
					} else if (text == 'OwnerAttending') {
						OwnerAttending = parser.getBooleanValue();
					} else if (text == 'TenantAttending') {
						TenantAttending = parser.getBooleanValue();
					} else if (text == 'SupplierReference') {
						SupplierReference = parser.getText();
					} else if (text == 'DisplayNumber') {
						DisplayNumber = parser.getText();
					} else if (text == 'Number') {
						Number_Z = parser.getIntegerValue();
					} else if (text == 'Status') {
						Status = parser.getText();
					} else if (text == 'ReportedContactType') {
						ReportedContactType = parser.getText();
					} else if (text == 'Access') {
						Access = parser.getText();
					} else if (text == 'MainPhotoDocumentId') {
						MainPhotoDocumentId = parser.getText();
					} else if (text == 'DocumentLinkTextName') {
						DocumentLinkTextName = parser.getText();
					} else if (text == 'QuoteId') {
						QuoteId = parser.getText();
					} else if (text == 'SupplierInstructions') {
						SupplierInstructions = parser.getText();
					} else if (text == 'Id') {
						Id = parser.getText();
					} else if (text == 'CustomerId') {
						CustomerId = parser.getText();
					} else if (text == 'DueDate') {
						DueDate = parser.getText();
					} else if (text == 'CreatedOn') {
						CreatedOn = parser.getText();
					} else if (text == 'ClosedOn') {
						ClosedOn = parser.getText();
					} else if (text == 'Summary') {
						Summary = parser.getText();
					} else if (text == 'Description') {
						Description = parser.getText();
					} else if (text == 'LotId') {
						LotId = parser.getText();
					} else if (text == 'TenantContactId') {
						TenantContactId = parser.getText();
					} else if (text == 'OwnerContactId') {
						OwnerContactId = parser.getText();
					} else if (text == 'ContactId') {
						ContactId = parser.getText();
					} else if (text == 'ManagerMemberId') {
						ManagerMemberId = parser.getText();
					} else if (text == 'Labels') {
						Labels = parser.getText();
					} else if (text == 'UpdatedOn') {
						UpdatedOn = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						//consumeObject(parser);
					}
				}
			}
		}
	}
	

public static CompliancePdfWrapper parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new CompliancePdfWrapper(parser);
	}

}