//This class is for initial data load for Tenants(propertyMe)

public class PropertyLotsTenantDataUpsertDuplicate 
 {

	  @future(callout = true)
    public static void getPropertyLotsTenantDataUpsert(String NCPortfolio){
		
		//Class Name
        String className = 'PropertyLotsTenantDataUpsert';
        //Method Name
        String methodName = 'getPropertyLotsTenantDataUpsert';        
        //Set Error details in Error Log
        List<Error_Log__c> errorLogsList = new List<Error_Log__c>();
        
         //Get Yesterday Date
       // DateTime yesterdayDate = system.today().addDays(-1);
        //Long yesterdayDateTicks = ((yesterdayDate.getTime()) * 10000) + 621355968000000000L;
        Long yesterdayDateTicks=0;
        system.debug('####yesterday Date ticks:'+ yesterdayDateTicks);
        
        
		//Get Property Me API setup
        Property_Me_API_Configuration__mdt pmac =  Property_Me_API_Configuration__mdt.getInstance('PM_Tenants');
		/*String propertyMeAccessToken =Tempclass.Acctoken;*/
        
        /*String propertiesRestAPIURL = pmac.Endpoint__c + '?Timestamp=0&format=json';
        system.debug('##### propertiesRestAPIURL'+ propertiesRestAPIURL); */
        HttpRequest httpRequest = new HttpRequest();  
        httpRequest.setMethod('GET');  
        /*httpRequest.setHeader('Authorization', 'Bearer ' + propertyMeAccessToken*/
        /*httpRequest.setEndpoint('callout:Property_Me_NC'+pmac.Endpoint__c   + yesterdayDateTicks);*/
        httpRequest.setEndpoint('callout:'+NCPortfolio+pmac.Endpoint__c   + yesterdayDateTicks); 
        //Property Me Get Tenants API URL  
        String lotsTenantsRestAPIURL = httpRequest.getEndpoint();
        system.debug('##### lotsTenantsRestAPIURL:'+ lotsTenantsRestAPIURL);
        try{
            Http http = new Http();   
            HttpResponse httpResponse = http.send(httpRequest);  
            if(httpResponse.getStatusCode() == 200 ) {
                system.debug('#####Json Response:'+httpResponse.getBody());
                List<PropertyLotsTenantGenerations> result = PropertyLotsTenantGenerations.parse(httpResponse.getBody());                       
                System.debug('#####Tenancies Deserialize response: ' + result);				
                //Get Contact Tenant Record Type
                Id tenantRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Tenant').getRecordTypeId();   
                system.debug('#####tenantRecordTypeId:'+tenantRecordTypeId);
                //Collect Tenant Ids
                List<String> tenantIds  =  new List<String>();          
                for(PropertyLotsTenantGenerations tenantRecord : result){
                                         
                        if( tenantRecord.Id != null && tenantRecord.Id != ''){
                           tenantIds.add(tenantRecord.Id); 
                        }                    
                }
                system.debug('#####tenantIds:'+tenantIds);
                //Logic to set Map for Account/Property Ids w.r.t Tenant Id
                 Map<String,String> propertyIdsMap =  new Map<String,String>();
                //Map for Rent Amount
                Map<String,Decimal> rentAmountMap =  new Map<String,Decimal>();
                //Map for Rent Period
                Map<String,String> rentPeriodMap =  new Map<String,String>();
                //Map for Tenancy Start
                Map<String,Date> tenancyStartMap =  new Map<String,Date>();
                //Map for Tenancy End
                Map<String,Date> tenancyEndMap =  new Map<String,Date>();
                //Map for Agreement Start
                Map<String,Date> agreementStartMap =  new Map<String,Date>();
                //Map for Agreement End
                Map<String,Date> agreementEndMap =  new Map<String,Date>();
                //Map for NextInspection Date
				Map<String,Date> nextInspectionDateMap =  new Map<String,Date>();               
                
                 if(!tenantIds.isempty()){
                    List<Account>  properties = new List<Account>();
                    properties = [Select Id,External_ID__c,Property_Me_Tenant_Contact_ID__c,advertised_rent_amount__c,advertised_rent_period__c,Property_Me_Tenancy_Start__c,Property_Me_Tenancy_End__c,Property_Me_Agreement_Start__c,Property_Me_Agreement_End__c,NextInspection_Date__c From Account Where Property_Me_Tenant_Contact_ID__c =: tenantIds];
                    if(!properties.isempty()){
                        for(Account  props : properties){
                            if(props.Property_Me_Tenant_Contact_ID__c != null){
                                propertyIdsMap.put(props.Property_Me_Tenant_Contact_ID__c, props.Id);
                                rentAmountMap.put(props.Property_Me_Tenant_Contact_ID__c, props.advertised_rent_amount__c);
                                rentPeriodMap.put(props.Property_Me_Tenant_Contact_ID__c, props.advertised_rent_period__c);
                                tenancyStartMap.put(props.Property_Me_Tenant_Contact_ID__c, props.Property_Me_Tenancy_Start__c);
                                tenancyEndMap.put(props.Property_Me_Tenant_Contact_ID__c, props.Property_Me_Tenancy_End__c);
                                agreementStartMap.put(props.Property_Me_Tenant_Contact_ID__c, props.Property_Me_Agreement_Start__c);
                                agreementEndMap.put(props.Property_Me_Tenant_Contact_ID__c, props.Property_Me_Agreement_End__c);
                                nextInspectionDateMap.put(props.Property_Me_Tenant_Contact_ID__c, props.NextInspection_Date__c);
                                
                            }                           
                        }                    
                    }
                 }
                 system.debug('#####propertyIdsMap:'+propertyIdsMap);
                //Tenant Records for Upsert
                List<Contact> tenantRecordsToUpsert = new List<Contact>();
                for(PropertyLotsTenantGenerations tenantRecord : result){
                    if(tenantRecord.IsTenant){
						for(PropertyLotsTenantGenerations.ContactPersons tenantcontacrPersonRecord : tenantRecord.ContactPersons){
                            Contact con = new Contact();
                            //get Tenant Id and map it to contact Tenant field External_ID__c
                            con.External_ID__c  =  tenantcontacrPersonRecord.Id;
                            //Map Account/Property Id
                            con.AccountId = propertyIdsMap.get(tenantcontacrPersonRecord.ContactId);
                            // Rent Amount & Period
                            con.rent_amount__c = rentAmountMap.get(tenantcontacrPersonRecord.ContactId);
                            con.rent_period__c = rentPeriodMap.get(tenantcontacrPersonRecord.ContactId);
                            //Tenancy Start Date & End Date
                            con.original_lease_start_date__c = tenancyStartMap.get(tenantcontacrPersonRecord.ContactId);
                            con.vacate_date__c = tenancyEndMap.get(tenantcontacrPersonRecord.ContactId);
                            con.lease_start_date__c = agreementStartMap.get(tenantcontacrPersonRecord.ContactId);
                            con.lease_end_date__c = agreementEndMap.get(tenantcontacrPersonRecord.ContactId);
                            // Next Inspection Date
                            con.Routine_Inspection_date__c = nextInspectionDateMap.get(tenantcontacrPersonRecord.ContactId);
                            //Map Record Type Id
							con.RecordTypeId = tenantRecordTypeId;
                            //Map Phone & Mobile
                            con.MobilePhone = tenantcontacrPersonRecord.CellPhone;
                            con.Phone = tenantcontacrPersonRecord.HomePhone;
                            con.Is_Primary__c = tenantcontacrPersonRecord.IsPrimary;
                            con.FirstName = tenantcontacrPersonRecord.FirstName;
                            con.LastName = tenantcontacrPersonRecord.LastName;
                            con.Email = tenantcontacrPersonRecord.Email;
                            
                            //Tenancy Name
                            con.Tenancy_Name__c = tenantRecord.Reference;
                            //Role
                            con.Property_Me_Role__c = tenantRecord.RolesString;
                            //Property Source
                            con.Property_Source__c = pmac.Source__c;
                           // con.Property_Me_Portfolio_Name__c = portfolioName;
                            //Tenant Records for Upsert
                            tenantRecordsToUpsert.add(con);
                        }
                    }
                }
                //Upsert Tenants
                Schema.SObjectField externalFieldToken = Contact.Fields.External_ID__c;
                Database.UpsertResult[] srList = Database.upsert(tenantRecordsToUpsert,externalFieldToken,false);
                for (Integer i=0; i < srList.size(); i++) {
                    if (srList.get(i).isSuccess()) {
                        system.debug('##### Tenant Upsert Successful!'+srList.get(i).Id);
                    }
                    else {
                        // Tenant Operation failed, so get all errors                
                        
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
                            errorLog.External_ID__c = tenantRecordsToUpsert.get(i).External_ID__c;
                            errorLog.Object_Type__c = 'Contact/Tenant';
                            errorLog.Source__c = pmac.Source__c;
                            errorLogsList.add(errorLog);                
                    }
                }
                
            }else {  
                 //Capture Un successful Response
                 //Capture Error Log Details
                 Error_Log__c errorLog = new Error_Log__c();
                 errorLog.Error_Type__c = 'ERROR';
                 errorLog.Error_Status_Code__c = String.valueOf(httpResponse.getStatusCode());
                 errorLog.Error_Message__c = httpResponse.getStatus();
                 errorLog.Error_Description__c = httpResponse.getStatus();
                 errorLog.Class_Name__c = className;
                 errorLog.Method_Name__c = methodName;                     
                 errorLog.Object_Type__c = 'Contact/Tenant';
                 errorLog.Source__c = pmac.Source__c;
                 errorLogsList.add(errorLog);  
             }
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
            errorLog.Source__c = pmac.Source__c;
            errorLogsList.add(errorLog);            
        }
        
        //Log errors in to Error log
        if(!errorLogsList.isEmpty()){
            insert errorLogsList;
        }

		
	}

}