//This class is for initial data load for Agents(propertyMe)
public class PropertyLotsAgentMembersduplicate {


   @future(callout = true)
    public static void getPropertyLotsAgentMembersDataUpsert(String NCPortfolio){
    
        	//Class Name
            String className = 'PropertyLotsAgentMembersDataUpsert';
            //Method Name
            String methodName = 'getPropertyLotsAgentMembersDataUpsert';        
            //Set Error details in Error Log
            List<Error_Log__c> errorLogsList = new List<Error_Log__c>();
        
        	//Get Yesterday Date
           // DateTime yesterdayDate = system.today().addDays(-1);
            //Long yesterdayDateTicks = ((yesterdayDate.getTime()) * 10000) + 621355968000000000L;
            Long yesterdayDateTicks =0;
            system.debug('####yesterday Date ticks:'+ yesterdayDateTicks);
            
            //Get Property Me API setup
            Property_Me_API_Configuration__mdt pmac =  Property_Me_API_Configuration__mdt.getInstance('PM_Members');
            /*String propertyMeAccessToken =Tempclass.Acctoken;*/
            
            /*String membersRestAPIURL = pmac.Endpoint__c + '?Timestamp=0&format=json';
            system.debug('##### membersRestAPIURL'+ membersRestAPIURL);*/ 
            HttpRequest httpRequest = new HttpRequest();  
            httpRequest.setMethod('GET');
        	//Property Me Get Agent Members Rest API URL  
       		/*httpRequest.setEndpoint('callout:Property_Me_NC'+pmac.Endpoint__c   + yesterdayDateTicks);*/
        	httpRequest.setEndpoint('callout:'+NCPortfolio+pmac.Endpoint__c   + yesterdayDateTicks);
        	String membersRestAPIURL = httpRequest.getEndpoint();
            system.debug('##### membersRestAPIURL'+ membersRestAPIURL);
            /*httpRequest.setHeader('Authorization', 'Bearer ' + propertyMeAccessToken);*/        
            try{
                Http http = new Http();   
				HttpResponse httpResponse = http.send(httpRequest);  
                if (httpResponse.getStatusCode() == 200 ) {
                    List<PropertyLotsAgentMembersGenerations> result = PropertyLotsAgentMembersGenerations.parse(httpResponse.getBody());                       
                    System.debug('#####Agents Deserialize response: ' + result);				
                    //Get Contact Agent Record Type
                    Id agentRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Agent').getRecordTypeId();   
                    system.debug('#####AgentRecordTypeId:'+agentRecordTypeId);
                    
                    //Upsert Agents
                    Schema.SObjectField externalFieldToken = Contact.Fields.External_ID__c;
                    //Agent Records for Upsert
                    List<Contact> agentRecordsToUpsert = new List<Contact>();				
                    //Retrieve Agent records
                    for(PropertyLotsAgentMembersGenerations agentRecord : result){
                        //Get Agent Details 
                        Contact con = new Contact();
                        con.Email = agentRecord.RegisteredEmail;
                        con.FirstName = agentRecord.FirstName;
                        con.External_ID__c = agentRecord.Id;
                        con.LastName = agentRecord.LastName;
                        con.MobilePhone = agentRecord.MobilePhone;					
                        /*con.Is_Deleted_in_Property_Tree__c = agentRecord.deleted;*/
                        //Map Record Type Id
                        con.RecordTypeId = agentRecordTypeId;
                        //Property Source
                        con.Property_Source__c = pmac.Source__c;
                        //con.Property_Me_Portfolio_Name__c = portfolioName;
                        //Property Company Source Id
                        /*con.Property_Company_Source_Id__c = ptac.Company_Id__c;
                        //agentRecord.properties; //Handle in Separate logic
                        //agentRecord.roles; //Handle in Separate logic */
                        agentRecordsToUpsert.add(con);
                    }
                    
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
                                errorLog.Source__c = pmac.Source__c;
                                errorLogsList.add(errorLog);                
                        }
                    }
                    //Collect Agent Ids
					List<String> agentIds  =  new List<String>(); 
                    for(PropertyLotsAgentMembersGenerations agentRecord : result){			
                            //Get agent Ids
                            if(agentRecord.Id != null && agentRecord.Id != '' ){
                                agentIds.add(agentRecord.Id);
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
                    //Logic to set Map for Agent Member/Property Ids  
                    Map<String,List<String>> agentLotsMap =  new Map<String,List<String>>(); 
                    Map<String,String> agentlotsExternalIdMap =  new Map<String,String>();
                    if(!agentIds.isempty()){
                        List<Account>  properties = new List<Account>();
                        properties = [Select Id,External_ID__c,ActiveManagerMemberId__c From Account Where ActiveManagerMemberId__c =: agentIds];
                        if(!properties.isempty()){
                            for(Account  props : properties){
                                if(props.ActiveManagerMemberId__c != null){
                                    if(!agentLotsMap.containsKey(props.ActiveManagerMemberId__c)){
                                        agentLotsMap.put(props.ActiveManagerMemberId__c, new List<String>()); 
                                    }
                                    agentLotsMap.get(props.ActiveManagerMemberId__c).add(props.Id);
                                }
                                if(props.External_ID__c != null){
                                    agentlotsExternalIdMap.put(props.Id,props.External_ID__c);
                                }
                            }                    
                        }
                    }
                    system.debug('#####agentLotsMap:'+agentLotsMap);
                    system.debug('#####agentlotsExternalIdMap:'+agentlotsExternalIdMap);
                    //Retrieve Roles with updated list of Agent records
                    List<AccountContactRelation__c> accContactRelRecords = new List<AccountContactRelation__c>(); 
                    for(PropertyLotsAgentMembersGenerations agentRecord : result){
                    
                        if(!agentLotsMap.isEmpty()){
                            List<string> agentLotIds = agentLotsMap.get(agentRecord.Id);
                                for(String agentLotId : agentLotIds){
									if(agentlotsExternalIdMap.get(agentLotId) != null && agentlotsExternalIdMap.get(agentLotId) != ''){
										AccountContactRelation__c accContactRel = new AccountContactRelation__c();
										accContactRel.AccountId__c = agentLotId; 
										accContactRel.contactId__c = updatedAgentsMap.get(agentRecord.Id);
										accContactRel.External_ID__c = agentRecord.Id + '#' + agentlotsExternalIdMap.get(agentLotId);
										//Map Role
										if(agentRecord.Role != null && agentRecord.Role != '' ){
											//accContactRel.Roles__c = agentRecord.Role; 
                                            accContactRel.Roles__c = 'Property Manager'; 
										}
										//Lot/Property Source
										accContactRel.Property_Source__c = pmac.Source__c;
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
                                errorLog.Object_Type__c = 'Contact/Agent/Lot';
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
                     errorLog.Object_Type__c = 'Contact/Agent';
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