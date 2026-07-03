/*******************************************************************************************
* @Name         OwnershipGenerationService 
* @Author       Rajesh
* @Description  This class contains all service methods related to format & process Property Tree Ownership Json Request.
*******************************************************************************************/

@RestResource(urlMapping='/PropertyTree/Ownerships')
global with sharing class OwnershipGenerationService {

  @HttpPost
    global static String doPost() {
        
        String status = '';      
        String jsonTenantInput = '';
        //Class Name
        String className = 'OwnershipGenerationService';
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
            List<OwnerShipsGeneration> result = (List<OwnerShipsGeneration>) System.JSON.deserialize(jsonTenantInput , List<OwnerShipsGeneration>.class);
            
            system.debug('#####result:'+result);
            //Get Contact Ownership Record Type
			Id ownershipRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Landlord').getRecordTypeId();   
			system.debug('#####ownershipRecordTypeId:'+ownershipRecordTypeId);
			//Collect Property Ids
			List<String> propertyIds  =  new List<String>();          
			for(OwnerShipsGeneration ownershipRecord : result){										 
				//Get Property Ids
				if(ownershipRecord.properties != null && !ownershipRecord.properties.isEmpty()){						   
						propertyIds.addAll(ownershipRecord.properties ); 						
								   
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
			//Account Records with ownership details for Upsert
			List<Account> accountOwnershipRecordsToUpsert = new List<Account>();
			
			//Retrieve Ownership records
			for(OwnerShipsGeneration ownershipRecord : result){
				
				String ownershipName = ownershipRecord.name;
				
				//get properties with ownership details 
				List<String> ownershipPropertyRecords = ownershipRecord.properties; 
				if(ownershipPropertyRecords != null && !ownershipPropertyRecords.isEmpty()){
					for(String property : ownershipPropertyRecords){
						Account acc = new Account();
						acc.Ownership_Name__c = ownershipName;
						acc.External_ID__c = property;
                        //Property Source
				 		acc.Property_Source__c = 'Property Tree';
						//Add properties with ownership details for upsert
						accountOwnershipRecordsToUpsert.add(acc);
					}
				}
			}				
			//Upsert Properties  with ownership details
			if(!accountOwnershipRecordsToUpsert.isEmpty()){
				Schema.SObjectField externalFieldToken = Account.Fields.External_ID__c;
				Database.UpsertResult[] srList = Database.upsert(accountOwnershipRecordsToUpsert,externalFieldToken,false);
				for (Integer i=0; i < srList.size(); i++) {
					if (srList.get(i).isSuccess()) {
						system.debug('##### Property ownership Upsert Successful!'+srList.get(i).Id);
					}
					else {
							// Property ownership Operation failed, so get all errors                            
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
							errorLog.External_ID__c = accountOwnershipRecordsToUpsert.get(i).External_ID__c;
							errorLog.Object_Type__c = 'Account/Property/Ownership';
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