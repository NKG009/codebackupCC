/*******************************************************************************************
* @Name         TenentGenerationService 
* @Author       Rajesh
* @Description  This class contains all service methods related to format & process Property Tree Tenant Json Request.
*******************************************************************************************/

@RestResource(urlMapping='/PropertyTree/Tenants')
global with sharing class TenentGenerationService {

  @HttpPost
    global static String doPost() {
        
        String status = '';      
        String jsonTenantInput = '';
        //Class Name
        String className = 'TenentGenerationService';
        //Method Name
        String methodName = 'doPost';
        
        //Set Error details in Error Log
        List<Error_Log__c> errorLogsList = new List<Error_Log__c>();
        try{
            RestRequest restReq = RestContext.request;
            system.debug('#####INPUT REQUEST:'+restReq);  
            Map<String,String> inputData =  RestContext.request.params;
            system.debug('#####INPUT MAP REQUEST:'+restReq); 
            //system.debug('#####INPUT REQUEST BODY:'+restReq.requestBody.toString()); 
            
            jsonTenantInput  = restReq.requestBody.toString();
            List<TenentGeneration> result = (List<TenentGeneration>) System.JSON.deserialize(jsonTenantInput , List<TenentGeneration>.class);
            
            system.debug('#####result:'+result);
            
            //Get Contact Tenant Record Type
            Id tenantRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Tenant').getRecordTypeId();   
            system.debug('#####tenantRecordTypeId:'+tenantRecordTypeId);
            
             //Collect Property Ids
            List<String> propertyIds  =  new List<String>();          
            for(TenentGeneration tenantRecord : result){
                                     
                    if(tenantRecord.property != null && tenantRecord.property != ''){
                       propertyIds.add(tenantRecord.property); 
                    }                    
             }
             system.debug('#####propertyIds:'+propertyIds);
             
             //Logic to set Map for Account/Property Ids  
             Map<String,String> propertyIdsMap =  new Map<String,String>();              
             if(!propertyIds.isempty()){
                List<Account>  properties = new List<Account>();
                properties = [Select Id,External_ID__c From Account Where External_ID__c =: propertyIds];
                if(!properties.isempty()){
                    for(Account  props : properties){
                        if(props.External_ID__c != null){
                            propertyIdsMap.put(props.External_ID__c, props.Id); 
                        }                           
                    }                    
                }
             }
             system.debug('#####propertyIdsMap:'+propertyIdsMap);
             
            //Tenant Records for Upsert
            List<Contact> tenantRecordsToUpsert = new List<Contact>();
            
            //Retrieve Tenant records
            for(TenentGeneration tenantRecord : result){
                
                //Get Tenancy Details                
                String tenancyId = tenantRecord.id;
                String tenancyName = tenantRecord.name;
                Date tenancyLEDate = (tenantRecord.lease_end_date != null && tenantRecord.lease_end_date != '')? Date.valueOf(tenantRecord.lease_end_date):null;
                Date tenancyLSDate = (tenantRecord.lease_start_date != null && tenantRecord.lease_start_date != '')? Date.valueOf(tenantRecord.lease_start_date):null;
                Date tenancyOLSDate =  (tenantRecord.original_lease_start_date != null && tenantRecord.original_lease_start_date != '')? Date.valueOf(tenantRecord.original_lease_start_date):null;
                Date tenancyVDate = (tenantRecord.vacate_date != null && tenantRecord.vacate_date != '')? Date.valueOf(tenantRecord.vacate_date):null;
                String tenancyPropExtId = tenantRecord.property;
                system.debug('#####tenantRecord.rent.amount:'+tenantRecord.rent);
                Double tenancyRentAmt;
                String tenancyRentPer;
                if(tenantRecord.rent != null){
                    tenancyRentAmt = (tenantRecord.rent.amount != null)? Double.valueOf(tenantRecord.rent.amount):null;
                    tenancyRentPer = tenantRecord.rent.period;
                }
                
                
                //Tenant attributes                
                Boolean tenantProspect = tenantRecord.prospect;
                Boolean tenantDeleted =tenantRecord.deleted;
                Boolean tenantArchived =tenantRecord.archived;
                  
                List<TenentGeneration.Contacts> tenantContacts = tenantRecord.contacts;
                for(TenentGeneration.Contacts tenantContRecord : tenantContacts){
                    Contact con = new Contact();
                    //get Contact Id and map it to contact Tenant field External_ID__c
                    con.External_ID__c  =  tenantContRecord.id;
                    
                    //Tenant Contact Address Fields
                    con.address_line_1__c = tenantContRecord.address.address_line_1;
                    con.address_line_2__c = tenantContRecord.address.address_line_2;
                    con.address_country__c = tenantContRecord.address.country;
                    con.address_post_code__c = tenantContRecord.address.post_code;
                    con.address_state__c = tenantContRecord.address.state;
                    con.address_street_number__c = tenantContRecord.address.street_number;
                    con.address_suburb__c = tenantContRecord.address.suburb;
                    con.address_unit__c = tenantContRecord.address.unit;
                    
                    //Tenant Contact Fields
                    con.Email = tenantContRecord.email_address;
                    con.preferred_email__c = tenantContRecord.preferred_email_address;
                    con.FirstName = tenantContRecord.first_name;
                    con.Is_Primary__c = tenantContRecord.is_primary;
                    con.LastName = tenantContRecord.last_name;
                    con.MobilePhone = tenantContRecord.mobile_phone_number;
                    con.Phone = tenantContRecord.phone_number;
                    con.preferred_phone__c = tenantContRecord.preferred_phone_number;
                    con.Title = tenantContRecord.title;  
                    con.no_marketing__c = tenantContRecord.no_marketing;
                    
                    //Map Tenancy details to Tenant Contact                    
                    con.Tenancy_ID__c = tenancyId; 
                    con.Tenancy_Name__c = tenancyName; 
                    con.lease_end_date__c = tenancyLEDate; 
                    con.lease_start_date__c = tenancyLSDate ;
                    con.original_lease_start_date__c = tenancyOLSDate;
                    con.vacate_date__c = tenancyVDate;                  
                    con.rent_amount__c = tenancyRentAmt;
                    con.rent_period__c = tenancyRentPer;
                    con.Is_Prospect_in_Property_Tree__c  = tenantProspect;
                    con.Is_Deleted_in_Property_Tree__c = tenantDeleted;
                    con.Is_Archived_in_Property_Tree__c = tenantArchived;
                    
                    //Map Account/Property Id
                     con.AccountId = propertyIdsMap.get(tenancyPropExtId);
                     
                     //Map Record Type Id
                     con.RecordTypeId = tenantRecordTypeId;
                    //Tenant Company Source Id
				 	con.Property_Company_Source_Id__c = Label.PT_Company_Initial_Load;
                     //Property Source
				 	con.Property_Source__c = 'Property Tree';
                     
                     //Tenant Records for Upsert
                     tenantRecordsToUpsert.add(con);
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
                    	errorLog.Source__c = 'Property Tree';
                        errorLogsList.add(errorLog);                
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