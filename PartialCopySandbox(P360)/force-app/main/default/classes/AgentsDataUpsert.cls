/*******************************************************************************************
* @Name         AgentsDataUpsert 
* @Author       Rajesh & Badri
* @Description  This class Insert/Update Agents from Get Agents API (Property Tree).
*******************************************************************************************/
public class AgentsDataUpsert {

    @future(callout = true)
    public static void getAgentsDataUpsert(String AgentsCompanyId){
		
		//Class Name
        String className = 'AgentsDataUpsert';
        //Method Name
        String methodName = 'getAgentsDataUpsert';        
        //Set Error details in Error Log
        List<Error_Log__c> errorLogsList = new List<Error_Log__c>();
		
		/*//Get Yesterday Date
        DateTime  yesterdayDate = System.today().addDays(-1);
        String formattedYesterdayDate = yesterdayDate.format('yyyy-MM-dd');
		*/
        //Get Property Tree API setup
        Property_API_Configuration__mdt ptac =  Property_API_Configuration__mdt.getInstance(AgentsCompanyId);
		//Property Tree Get Agents Rest API URL         
        String AgentsRestAPIURL = ptac.Endpoint__c; 
        system.debug('##### AgentsRestAPIURL'+ AgentsRestAPIURL); 
		HttpRequest httpRequest = new HttpRequest();  
        httpRequest.setMethod('GET');  
        httpRequest.setHeader('company_id', ptac.Company_Id__c);
        httpRequest.setHeader('authorization', 'Bearer ' + ptac.Authorization__c); 
        httpRequest.setEndpoint(AgentsRestAPIURL); 
		try{
			Http http = new Http();   
			HttpResponse httpResponse = http.send(httpRequest);  
			if (httpResponse.getStatusCode() == 200 ) { 
				List<AgentGeneration> result = AgentGeneration.parse(httpResponse.getBody());                       
				System.debug('#####Agents Deserialize response: ' + result);				
				//Get Contact Agent Record Type
				Id agentRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Agent').getRecordTypeId();   
				system.debug('#####AgentRecordTypeId:'+agentRecordTypeId);
				//Collect Property Ids & Agent Ids
				//set<string> propertysetIds  =  new set<string>(); 

				List<string> propertyIds  =  new List<string>(); 
                
				List<String> agentIds  =  new List<String>();  
				for(AgentGeneration agentRecord : result){
							
						//Get agent Ids
						if(agentRecord.id != null && agentRecord.id != '' ){
							agentIds.add(agentRecord.id);
						}
						//Get Property Ids
						if(agentRecord.properties != null && !agentRecord.properties.isEmpty()){						   
								propertyIds.addAll(agentRecord.properties ); 						
				   						   
						}                    
				}
                /*system.debug('>>>propertyIds size1'+propertyIds.size());
                propertysetIds.addAll(propertyIds);
                system.debug('>>>propertysetIds size'+propertysetIds.size());
                propertyIds.clear();
                propertyIds.addAll(propertysetIds );
                system.debug('>>>propertyIds size2'+propertyIds.size());
				*/
                //system.debug('#####Before duplicates'+propertyIds.size());
                //propertyIds.addAll(propertysetIds);
                //system.debug('#####After Duplicate:'+propertyIds.size());
				system.debug('#####AgentIds:'+agentIds);	
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
				//Logic to set Map for Agent/Contact Ids  
				Map<String,String> agentsMap =  new Map<String,String>(); 
				if(!agentIds.isempty()){
					List<Contact>  agents = new List<Contact>();
					agents = [Select Id,External_ID__c From Contact Where External_ID__c =: agentIds];
					if(!agents.isempty()){
						for(Contact  cons : agents){
							if(cons.External_ID__c != null){
								agentsMap.put(cons.External_ID__c, cons.Id); 
							}                           
						}                    
					}
				}
				system.debug('#####agentsMap:'+agentsMap);
				
				//Agent Records for Upsert
				List<Contact> agentRecordsToUpsert = new List<Contact>();				
				//Retrieve Agent records
				for(AgentGeneration agentRecord : result){
					//Get Agent Details 
					Contact con = new Contact();
					con.Email = agentRecord.email_address;
					con.FirstName = agentRecord.first_name;
					con.External_ID__c = agentRecord.id;
					con.LastName = agentRecord.last_name;
					con.MobilePhone = agentRecord.mobile_phone_number;					
					con.Is_Deleted_in_Property_Tree__c = agentRecord.deleted;
                    //Map Record Type Id
                    con.RecordTypeId = agentRecordTypeId;
                    //Property Source
                    con.Property_Source__c = ptac.Source__c;
                    //Property Company Source Id
                    con.Property_Company_Source_Id__c = ptac.Company_Id__c;
					//agentRecord.properties; //Handle in Separate logic
					//agentRecord.roles; //Handle in Separate logic
					agentRecordsToUpsert.add(con);
				}
				//Upsert Agents
				Schema.SObjectField externalFieldToken = Contact.Fields.External_ID__c;
				Database.UpsertResult[] srList = Database.upsert(agentRecordsToUpsert,externalFieldToken,false);
				for (Integer i=0; i < srList.size(); i++) {
					if (srList.get(i).isSuccess()) {
						system.debug('##### Agent Upsert Successful!'+srList.get(i).Id);
					}
					else {
						// Agent Operation failed, so get all errors                
						
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
							errorLog.External_ID__c = agentRecordsToUpsert.get(i).External_ID__c;
							errorLog.Object_Type__c = 'Contact/Agent';
                        	errorLog.Source__c = ptac.Source__c;
							errorLogsList.add(errorLog);                
					}
				}
				//Logic to set Map for Agent/Contact Ids  
				Map<String,String> updatedAgentsMap =  new Map<String,String>(); 
				if(!agentIds.isempty()){
					List<Contact>  agents = new List<Contact>();
					agents = [Select Id,External_ID__c From Contact Where External_ID__c =: agentIds];
					if(!agents.isempty()){
						for(Contact  cons : agents){
							if(cons.External_ID__c != null){
								updatedAgentsMap.put(cons.External_ID__c, cons.Id); 
							}                           
						}                    
					}
				}
				system.debug('#####updatedAgentsMap:'+updatedAgentsMap);
                List<String> duplicatePropertyCheck = new List<String>();
				//Retrieve Address & Roles with updated list of Agent records
				List<AccountContactRelation__c> accContactRelRecords = new List<AccountContactRelation__c>(); 
				for(AgentGeneration agentRecord : result){
                    //Clear list of duplicate properties 
                    duplicatePropertyCheck.clear();
					List<String> agentPropertyRecords = agentRecord.properties; 
					if(agentPropertyRecords != null && !agentPropertyRecords.isEmpty()){
						for(String property : agentPropertyRecords){
                            if(!duplicatePropertyCheck.contains(property)){
                                duplicatePropertyCheck.add(property);
                                AccountContactRelation__c accContactRel = new AccountContactRelation__c();
                                accContactRel.AccountId__c = propertyIdsMap.get(property);
                                accContactRel.contactId__c = updatedAgentsMap.get(agentRecord.id);
                                //accContactRel.isActive = true;
                                //accContactRel.isDirect = true;
                                accContactRel.External_ID__c = agentRecord.id + '#' + property;
                                //Map Roles
                                if(agentRecord.roles != null && !agentRecord.roles.isEmpty()){
                                    accContactRel.Roles__c = format(agentRecord.roles); 
                                }	
                                //Property Source
                                accContactRel.Property_Source__c = ptac.Source__c;
                                accContactRelRecords.add(accContactRel);
                            }
						}		
					}
					
				}
				//Upsert Agent Property Map 
				Schema.SObjectField accConExternalFieldToken = AccountContactRelation__c.Fields.External_ID__c;
				Database.UpsertResult[] srListAccConRel = Database.upsert(accContactRelRecords,accConExternalFieldToken,false);
				for (Integer i=0; i < srListAccConRel.size(); i++) {
					if (srListAccConRel.get(i).isSuccess()) {
						system.debug('##### Agent Property Map Upsert Successful!'+srListAccConRel.get(i).Id);
					}
					else {
						// Agent Property Map Operation failed, so get all errors                
						
							Database.Error err = srListAccConRel.get(i).getErrors().get(0);
							System.debug('##### Error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
							System.debug('##### Fields that affected this error: ' + err.getFields());
							
							//Capture Error Log Details
							Error_Log__c errorLog = new Error_Log__c();
							errorLog.Error_Type__c = 'ERROR';
							errorLog.Error_Status_Code__c = String.valueOf(err.getStatusCode());
							errorLog.Error_Message__c = err.getMessage();
							errorLog.Error_Description__c = 'Fields that affected this error for Agent Property Map:'+ err.getFields();
							errorLog.Class_Name__c = className;
							errorLog.Method_Name__c = methodName;
							errorLog.External_ID__c = accContactRelRecords.get(i).External_ID__c;
							errorLog.Object_Type__c = 'Contact/Agent/Property';
                        	errorLog.Source__c = ptac.Source__c;
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
                     errorLog.Object_Type__c = 'Contact/Agent';
                	 errorLog.Source__c = ptac.Source__c;
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
            errorLog.Source__c = ptac.Source__c;
            errorLogsList.add(errorLog);            
        }
        
        //Log errors in to Error log
        if(!errorLogsList.isEmpty()){
        	insert errorLogsList;
    	}
	}
	
	public static String format(List<String> values) {
		if (values == null) return null;
		return String.join(values, ';');
	}
}