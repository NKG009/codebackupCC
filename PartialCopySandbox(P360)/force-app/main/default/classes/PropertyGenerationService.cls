/*******************************************************************************************
* @Name         PropertyGenerationService 
* @Author       Rajesh
* @Description  This class contains all service methods related to format & process Property Tree Property Json Request.
*******************************************************************************************/
@RestResource(urlMapping='/PropertyTree/Properties')
global with sharing  class PropertyGenerationService {

	@HttpPost
    global static String doPost() {
		
		String status = '';      
        String jsonPropertyInput = '';
        //Class Name
        String className = 'PropertyGenerationService';
        //Method Name
        String methodName = 'doPost';
        
        //Property Records for Upsert
        List<Account> propertyRecordsToUpsert = new List<Account>();
        //Set Error details in Error Log
        List<Error_Log__c> errorLogsList = new List<Error_Log__c>();
        
		try{
			RestRequest restReq = RestContext.request;
            system.debug('#####INPUT REQUEST:'+restReq);  
            Map<String,String> inputData =  RestContext.request.params;
            system.debug('#####INPUT MAP REQUEST:'+restReq); 
            //system.debug('#####INPUT REQUEST BODY:'+restReq.requestBody.toString()); 
            
            jsonPropertyInput  = restReq.requestBody.toString();
            List<PropertiesGeneration> properties = (List<PropertiesGeneration>) System.JSON.deserialize(jsonPropertyInput , List<PropertiesGeneration>.class);
            
            system.debug('#####properties:'+properties);
            //Get Property Record Type
			Id propertyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Property').getRecordTypeId();   
			system.debug('#####propertyRecordTypeId:'+propertyRecordTypeId);
			for(PropertiesGeneration pgRecord : properties){
				 //Map property Json to Salesforce property fields                        
				 Account propAcc = new Account();
				 //Address fields
				 propAcc.address_line_1__c = pgRecord.address.address_line_1;
				 propAcc.address_line_2__c = pgRecord.address.address_line_2;
				 propAcc.address_country__c = pgRecord.address.country;
				 propAcc.address_post_code__c = pgRecord.address.post_code;
				 propAcc.address_state__c = pgRecord.address.state;
				 propAcc.address_street_number__c = pgRecord.address.street_number;
				 propAcc.address_suburb__c = pgRecord.address.suburb;
				 propAcc.address_unit__c = pgRecord.address.unit;
				 //Map Account/Property Name
				 String addressLine1 = (pgRecord.address.address_line_1 != null && pgRecord.address.address_line_1 != '')? pgRecord.address.address_line_1:'';
				 String addressLine2 = (pgRecord.address.address_line_2 != null && pgRecord.address.address_line_2 != '')? pgRecord.address.address_line_2:'';
				 String addressStreet = (pgRecord.address.street_number != null && pgRecord.address.street_number != '')? pgRecord.address.street_number:'';
				 String addressSuburb = (pgRecord.address.suburb != null && pgRecord.address.suburb != '')? pgRecord.address.suburb:'';
				 String addressUnit = (pgRecord.address.unit != null && pgRecord.address.unit != '')? pgRecord.address.unit+'/':'';
				 String addressState = (pgRecord.address.state != null && pgRecord.address.state != '')? pgRecord.address.state:'';
				 String addressPostCode = (pgRecord.address.post_code != null && pgRecord.address.post_code != '')? pgRecord.address.post_code:'';
				 String addressCountry = (pgRecord.address.country != null && pgRecord.address.country != '')? pgRecord.address.country:'';
				 // Property Name Format "Unit/Street Number + Address Line 1+ Suburb +Post Code"
				 propAcc.Name = addressUnit + addressStreet + ' ' + addressLine1 + ' ' + addressSuburb + ' ' + addressPostCode;
				 //Map Property External Id
				 propAcc.External_ID__c = pgRecord.id;
				//Advertised_rent fields
				Double propAdvertiseRentAmount;
				String propAdvertiseRentPeriod;
				if(pgRecord.advertised_rent != null){
					propAdvertiseRentAmount = (pgRecord.advertised_rent.amount != null)? Double.valueOf(pgRecord.advertised_rent.amount):null;
					propAdvertiseRentPeriod = pgRecord.advertised_rent.period;
				}
				 propAcc.advertised_rent_amount__c = propAdvertiseRentAmount;
				 propAcc.advertised_rent_period__c = propAdvertiseRentPeriod;
				 //Other fields
				 propAcc.Bathrooms__c = pgRecord.bathrooms;
				 propAcc.Bedrooms__c = pgRecord.bedrooms;
				 propAcc.Car_Spaces__c = pgRecord.car_spaces;
				 propAcc.Key_Description__c = pgRecord.key_description;
				 propAcc.Key_Number__c = pgRecord.key_number;
				 //Inspection dates / lease dates
				 if(pgRecord.smoke_alarm != null){
					propAcc.NextInspection_Date__c = (pgRecord.smoke_alarm.next_service_date != null && pgRecord.smoke_alarm.next_service_date != '')? Date.valueOf(pgRecord.smoke_alarm.next_service_date):null;
					propAcc.LastInspection_Date__c = (pgRecord.smoke_alarm.last_serviced_date != null && pgRecord.smoke_alarm.last_serviced_date != '')? Date.valueOf(pgRecord.smoke_alarm.last_serviced_date):null;
				 }
				 //Agents
				 /*if(pgRecord.agents != null & !pgRecord.agents.isEmpty()){
					  propAcc.Agents__c = pgRecord.agents.toString();
				 }*/                      
				 //Ownership Names
				 //propAcc.Ownership_Names__c = pgRecord.ownership;
				 //Tenancy Names
				 //propAcc.Tenancy_Names__c = pgRecord.tenancy;
				 //Map deleted & archived
				 propAcc.Deleted_in_PropertyTree__c = pgRecord.deleted;
				 propAcc.Archived_in_PropertyTree__c = pgRecord.archived;
				 //Property Source
				 propAcc.Property_Source__c = 'Property Tree';
				  //Property Company Source Id
				 propAcc.Property_Company_Source_Id__c = Label.PT_Company_Initial_Load;
				 //Property Record Type Id
				 propAcc.RecordTypeId = propertyRecordTypeId;
				//Add properties for upsert
				propertyRecordsToUpsert.add(propAcc);                       
			 }
            //Upsert Properties
			 if(!propertyRecordsToUpsert.isEmpty()){
				Schema.SObjectField externalFieldToken = Account.Fields.External_ID__c;
				Database.UpsertResult[] srList = Database.upsert(propertyRecordsToUpsert,externalFieldToken,false);
				for (Integer i=0; i < srList.size(); i++) {
					if (srList.get(i).isSuccess()) {
						system.debug('##### Property Upsert Successful!'+srList.get(i).Id);
					}
					else {
							// Property Operation failed, so get all errors                            
							Database.Error err = srList.get(i).getErrors().get(0);
							System.debug('##### Error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
							System.debug('##### Fields that affected this error: ' + err.getFields());
							
							//Capture Error Log Details
							Error_Log__c errorLog = new Error_Log__c();
							errorLog.Error_Type__c = 'ERROR';
							errorLog.Error_Status_Code__c = String.valueOf(err.getStatusCode());
							errorLog.Error_Message__c = err.getMessage();
							errorLog.Error_Description__c = 'Fields that affected this error:'+ err.getFields();
							errorLog.Class_Name__c = className;
							errorLog.Method_Name__c = methodName;
							errorLog.External_ID__c = propertyRecordsToUpsert.get(i).External_ID__c;
							errorLog.Object_Type__c = 'Account/Property';
							errorLog.Source__c = 'Property Tree';
							errorLogsList.add(errorLog);                
					}
				}
			}
			status =  'Success!! Please Check Error Log for more details.';
		}catch(Exception ex){
            system.debug('#####Error while processing the request:'+ex);
            
            //Capture Error Log Details
            Error_Log__c errorLog = new Error_Log__c();
            errorLog.Error_Type__c = 'ERROR';
            errorLog.Error_Status_Code__c = '';
            errorLog.Error_Message__c = ex.getMessage();
            errorLog.Error_Description__c = 'Error while processing the request:'+ ex;
            errorLog.Class_Name__c = className;
            errorLog.Method_Name__c = methodName;
            errorLog.Source__c = 'Property Tree';
            errorLogsList.add(errorLog);
            status = 'Fail!! Please Check Error Log for more details.';
        }
        
        //Log errors in to Error log
        insert errorLogsList;
        
       return status;
	}
	
}