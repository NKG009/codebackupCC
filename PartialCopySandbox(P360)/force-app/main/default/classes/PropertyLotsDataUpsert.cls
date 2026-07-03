/*******************************************************************************************
* @Name         PropertyLotsDataUpsert 
* @Author       Rajesh & Badri
* @Description  This class Insert/Update properties/Lots from Lots API (Property Me).
*******************************************************************************************/
public class PropertyLotsDataUpsert {

    @future(callout = true)
    public static void getLotsDataUpsert(String lotCompanyId,String NCPortfolio,String portfolioName){
        
        //Property Records for Upsert
        List<Account> propertyRecordsToUpsert = new List<Account>();
        //Set Error details in Error Log
        List<Error_Log__c> errorLogsList = new List<Error_Log__c>();
        //Class Name
        String className = 'PropertyLotsDataUpsert';
        //Method Name
        String methodName = 'getLotsDataUpsert';
        
         //Get Yesterday Date
        DateTime yesterdayDate = system.today().addDays(-1);
        Long yesterdayDateTicks = ((yesterdayDate.getTime()) * 10000) + 621355968000000000L;
        system.debug('####yesterday Date ticks:'+ yesterdayDateTicks);
        
        //Get Property Me API setup
        Property_Me_API_Configuration__mdt pmac =  Property_Me_API_Configuration__mdt.getInstance(lotCompanyId);
        
        //Property Me Get Properties Rest API URL  
		/*String propertiesRestAPIURL = pmac.Endpoint__c + '?format=json&timestamp=0';
        system.debug('##### propertiesRestAPIURL'+ propertiesRestAPIURL);*/ 
        HttpRequest httpRequest = new HttpRequest();  
        httpRequest.setMethod('GET');  
        /*httpRequest.setHeader('company_id', ptac.Company_Id__c);
        httpRequest.setHeader('authorization', 'Bearer ' + ptac.Authorization__c); */
		/*httpRequest.setHeader('Authorization', 'Bearer ' + propertyMeAccessToken);*/
        /*httpRequest.setEndpoint('callout:Property_Me_NC'+pmac.Endpoint__c   + yesterdayDateTicks);*/
        httpRequest.setEndpoint('callout:'+NCPortfolio+pmac.Endpoint__c   + yesterdayDateTicks);
        String propertiesRestAPIURL = httpRequest.getEndpoint();
        system.debug('##### propertiesRestAPIURL:'+ propertiesRestAPIURL);
        try {  
                 Http http = new Http();   
                 HttpResponse httpResponse = http.send(httpRequest);  
                 if (httpResponse.getStatusCode() == 200 ) {  
                     System.debug('#####inside HttpResponse status code:');
                     List<PropertyLotsGenerations> properties = PropertyLotsGenerations.parse(httpResponse.getBody());                       
                     System.debug('#####Deserialize response: ' + properties);
                     for(PropertyLotsGenerations pgRecord : properties){ 
                         //Map property Json to Salesforce property fields                        
                         Account propAcc = new Account();
                         //Address fields
                         propAcc.address_line_1__c = pgRecord.address.Street;
                        /* propAcc.address_line_2__c = pgRecord.address.address_line_2;*/
                         propAcc.address_country__c = pgRecord.address.Country;
                         propAcc.address_post_code__c = pgRecord.address.PostalCode;
                         propAcc.address_state__c = pgRecord.address.State;
                         propAcc.address_street_number__c = pgRecord.address.StreetNumber_X;
                         propAcc.address_suburb__c = pgRecord.address.Suburb;
                         propAcc.address_unit__c = pgRecord.address.Unit;
                         //Map Account/Property Name
                         String addressLine1 = (pgRecord.address.Street != null && pgRecord.address.Street != '')? pgRecord.address.Street:'';
                         /*String addressLine2 = (pgRecord.address.address_line_2 != null && pgRecord.address.address_line_2 != '')? pgRecord.address.address_line_2:'';*/
                         String addressStreet = (pgRecord.address.StreetNumber_X != null && pgRecord.address.StreetNumber_X != '')? pgRecord.address.StreetNumber_X:'';
                         String addressSuburb = (pgRecord.address.Suburb != null && pgRecord.address.Suburb != '')? pgRecord.address.Suburb:'';
                         String addressUnit = (pgRecord.address.Unit != null && pgRecord.address.Unit != '')? pgRecord.address.Unit+'/':'';
                         String addressState = (pgRecord.address.State != null && pgRecord.address.State != '')? pgRecord.address.State:'';
                         String addressPostCode = (pgRecord.address.PostalCode != null && pgRecord.address.PostalCode != '')? pgRecord.address.PostalCode:'';
                         String addressCountry = (pgRecord.address.Country != null && pgRecord.address.Country != '')? pgRecord.address.Country:'';
                         // Property Name Format "Unit/Street Number + Address Line 1+ Suburb +Post Code"
                         propAcc.Name = addressUnit + addressStreet + ' ' + addressLine1 + ' ' + addressSuburb + ' ' + addressPostCode;
                          //Map Property External Id
                         propAcc.External_ID__c = pgRecord.Id;
                         //Rent fields
                         Double propRentAmount = (pgRecord.AdRentAmount != null)? Double.valueOf(pgRecord.AdRentAmount):null;
                         String propRentPeriod = pgRecord.AdRentPeriod;                        
                         propAcc.advertised_rent_amount__c = propRentAmount;
                         propAcc.advertised_rent_period__c = propRentPeriod;
                         //Tenancy Start Date & End Date
                         propAcc.Property_Me_Tenancy_Start__c = (pgRecord.TenancyStart != null && pgRecord.TenancyStart != '')? Date.valueOf(pgRecord.TenancyStart):null;
                         propAcc.Property_Me_Tenancy_End__c = (pgRecord.TenancyEnd != null && pgRecord.TenancyEnd != '')? Date.valueOf(pgRecord.TenancyEnd):null;
                         
                         //Agreement Start Date & End Date
                         propAcc.Property_Me_Agreement_Start__c = (pgRecord.AgreementStart != null && pgRecord.AgreementStart != '')? Date.valueOf(pgRecord.AgreementStart):null;
                         propAcc.Property_Me_Agreement_End__c = (pgRecord.AgreementEnd != null && pgRecord.AgreementEnd != '')? Date.valueOf(pgRecord.AgreementEnd):null;
						
                         //Other fields
                         propAcc.Bathrooms__c = pgRecord.Bathrooms;
                         propAcc.Bedrooms__c = pgRecord.Bedrooms;
                         propAcc.Car_Spaces__c = pgRecord.CarSpaces;
                         propAcc.Key_Description__c = pgRecord.Description;
                         propAcc.Key_Number__c = pgRecord.KeyNumber;
                         //Inspection dates / lease dates
                         propAcc.NextInspection_Date__c = (pgRecord.NextInspectionOn != null && pgRecord.NextInspectionOn != '')? Date.valueOf(pgRecord.NextInspectionOn):null;
                         /*
							propAcc.LastInspection_Date__c = (pgRecord.smoke_alarm.last_serviced_date != null && pgRecord.smoke_alarm.last_serviced_date != '')? Date.valueOf(pgRecord.smoke_alarm.last_serviced_date):null;
						*/
                         //Map OwnerContactId & TenantContactId
                         propAcc.ProperIdty_Me_Owner_Contact_ID__c =  pgRecord.OwnerContactId;
                         propAcc.Property_Me_Tenant_Contact_ID__c = pgRecord.TenantContactId;
                         //Map Agent/ActiveManagerMemberId
                         propAcc.ActiveManagerMemberId__c  = pgRecord.ActiveManagerMemberId;
                         //Map Property Manager
                         propAcc.Property_Manager__c = pgRecord.ManagerName;
                         //Ownership Name / Ownership Entity
                         propAcc.Ownership_Name__c = pgRecord.OwnerContactReference;
                         //Map deleted & archived
                         /*propAcc.Deleted_in_PropertyMe__c = pgRecord.deleted;*/
                         propAcc.Archived_in_PropertyMe__c = pgRecord.IsArchived;
                         //Property Source
                         propAcc.Property_Source__c = pmac.Source__c;
                         propAcc.Property_Me_Portfolio_Name__c = portfolioName;
                         //Property Company Source Id
                         /*propAcc.Property_Company_Source_Id__c = ptac.Company_Id__c;*/
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
                                	errorLog.Source__c = pmac.Source__c;
                                    errorLog.External_ID__c = propertyRecordsToUpsert.get(i).External_ID__c;
                                    errorLog.Object_Type__c = 'Account/Lot';
                                    errorLogsList.add(errorLog);                
                            }
                        }
                   	}
                 } else {  
                     //Capture Un successful Response
                     //Capture Error Log Details
                     Error_Log__c errorLog = new Error_Log__c();
                     errorLog.Error_Type__c = 'ERROR';
                     errorLog.Error_Status_Code__c = String.valueOf(httpResponse.getStatusCode());
                     errorLog.Error_Message__c = httpResponse.getStatus();
                     errorLog.Error_Description__c = httpResponse.getStatus();
                     errorLog.Class_Name__c = className;
                     errorLog.Method_Name__c = methodName;   
                     errorLog.Source__c = pmac.Source__c;
                     errorLog.Object_Type__c = 'Account/Lot';
                     errorLogsList.add(errorLog);  
                 }   
        } catch( CalloutException ex) {  
                 System.debug('#####ERROR: '+ ex);  
                //Error Logs  
                system.debug('#####Error while processing the request in CalloutException block:'+ex);            
                //Capture Error Log Details
                Error_Log__c errorLog = new Error_Log__c();
                errorLog.Error_Type__c = 'ERROR';
                errorLog.Error_Status_Code__c = '';
                errorLog.Error_Message__c = ex.getMessage();
                errorLog.Error_Description__c = 'Error while processing the request:'+ ex;
                errorLog.Class_Name__c = className;
                errorLog.Method_Name__c = methodName;
            	errorLog.Source__c = pmac.Source__c;
                errorLogsList.add(errorLog);
        }
        catch( Exception ex) {  
                 System.debug('#####ERROR: '+ ex);  
                //Error Logs  
                system.debug('#####Error while processing the request in Exception blcok:'+ex);            
                //Capture Error Log Details
                Error_Log__c errorLog = new Error_Log__c();
                errorLog.Error_Type__c = 'ERROR';
                errorLog.Error_Status_Code__c = '';
                errorLog.Error_Message__c = ex.getMessage();
                errorLog.Error_Description__c = 'Error while processing the request:'+ ex;
                errorLog.Class_Name__c = className;
                errorLog.Method_Name__c = methodName;
            	errorLog.Source__c = pmac.Source__c;
                errorLogsList.add(errorLog);
        } 
        //Log errors in to Error log
        if(!errorLogsList.isEmpty()){
        	insert errorLogsList;
    	}
        
    }
	
}