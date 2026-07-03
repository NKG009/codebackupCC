public class OwnershipNameUpdateBatch implements Database.Batchable<Property_360_Company__c>, Database.AllowsCallouts, Schedulable {
	
    public Boolean runFullUpdate = false;
    private static String endpointURL = 'https://api.propertytree.io/residentialproperty/v1/Ownerships';
    
    public OwnershipNameUpdateBatch(Boolean runFullUpdateInput) {
        this.runFullUpdate = runFullUpdateInput;
    }
    
    public void execute(SchedulableContext sc) { 
    	Database.executeBatch(new OwnershipNameUpdateBatch(false), 1);
    }
    
    public Iterable<Property_360_Company__c> start(Database.BatchableContext BC) {
        return Property_360_Company__c.getAll().values();
    }
    
    public void execute(Database.BatchableContext bc, List<Property_360_Company__c> propertyAPIConfigs) {
        for(Property_360_Company__c companyObj : propertyAPIConfigs) {
            updateOwnershipsNameOnProperties(companyObj.Company_Name__c, companyObj.Key__c, this.runFullUpdate);
            break;	//To run only one callout per execute 
        }
    }
    
    public void finish(Database.BatchableContext bc) {}
    
    public static Boolean updateOwnershipsNameOnProperties(String companyId, String authKey, Boolean runFullUpdate) {
        List<Error_Log__c> errorLogsList = new List<Error_Log__c>();
        if(String.isNotBlank(companyId) && String.isNotBlank(authKey)) {
            system.debug('Company Id::'+companyId);
            String className = 'OwnershipNameUpdateBatch';
            String methodName = 'getOwnershipsDataUpsert';        
            
            String OwnershipsRestAPIURL = endpointURL;
            system.debug('runFullUpdate::'+runFullUpdate);
            if(runFullUpdate == null || !runFullUpdate) {
                DateTime yesterdayDate = System.today().addDays(-1);
                String formattedYesterdayDate = yesterdayDate.format('yyyy-MM-dd');
                OwnershipsRestAPIURL += '?lastModifiedOnOrAfter='+formattedYesterdayDate; 
            }
            system.debug('##### OwnershipsRestAPIURL:'+ OwnershipsRestAPIURL); 
            HttpRequest httpRequest = new HttpRequest();  
            httpRequest.setMethod('GET');  
            httpRequest.setHeader('company_id', companyId);
            httpRequest.setHeader('authorization', 'Bearer ' + authKey); 
            httpRequest.setEndpoint(OwnershipsRestAPIURL); 
            try{
                Http http = new Http();   
                HttpResponse httpResponse = http.send(httpRequest);  
                if (httpResponse.getStatusCode() == 200 ) { 
                    List<OwnershipWrapper> result = (List<OwnershipWrapper>) System.JSON.deserialize(httpResponse.getBody(), List<OwnershipWrapper>.class);
                    httpResponse = null;
                    Set<String> ownershipIdSet = new Set<String>();      
                    for(OwnershipWrapper ownershipRecord : result) {	
                        ownershipIdSet.add(ownershipRecord.id); 						
                    }
                    system.debug('#####ownershipIdSet:'+ownershipIdSet);
                    Map<String,List<Account>> ownershipIdToAccountListMap =  new Map<String,List<Account>>();              
                    if(!ownershipIdSet.isempty()){
                        for(Account props : [Select Id, Ownership_Name__c, External_ID__c, API_Ownership_External_ID__c From Account Where API_Ownership_External_ID__c IN: ownershipIdSet AND API_Ownership_External_ID__c != null]) {
                            if(!ownershipIdToAccountListMap.containsKey(props.API_Ownership_External_ID__c)) {
                                ownershipIdToAccountListMap.put(props.API_Ownership_External_ID__c, new List<Account>());
                            }
                            ownershipIdToAccountListMap.get(props.API_Ownership_External_ID__c).add(props); 
                        }  
                    }
                    system.debug('#####ownershipIdToAccountListMap:'+ownershipIdToAccountListMap);
                    List<Account> accountOwnershipRecordsToUpdate = new List<Account>();
    
                    //Retrieve Ownership records
                    for(OwnershipWrapper ownershipRecord : result) {
                        String ownershipName = ownershipRecord.name;
                        //get properties with ownership details 
                        if(ownershipIdToAccountListMap.containsKey(ownershipRecord.id)){
                            for(Account prop : ownershipIdToAccountListMap.get(ownershipRecord.id)) {
                                if(prop.Ownership_Name__c != ownershipName) {
                                    prop.Ownership_Name__c = ownershipName;
                                    accountOwnershipRecordsToUpdate.add(prop);
                                }
                            }
                        }
                    }
                    result = null;
                    ownershipIdToAccountListMap = null;
                    //Upsert Properties  with ownership details
                    if(!accountOwnershipRecordsToUpdate.isEmpty()){
                        Database.SaveResult[] srList = Database.update(accountOwnershipRecordsToUpdate, false);
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
                                Error_Log__c errorLog = ErrorLogUtil.createSampleErrorLog(
                                    String.valueOf(err.getStatusCode()), err.getMessage(), 'Fields that affected this error:'+ err.getFields(), className, methodName, 'Account/Property/Ownership', 'Property Tree'
                                );
                                errorLog.External_ID__c = accountOwnershipRecordsToUpdate.get(i).External_ID__c;
                                errorLogsList.add(errorLog);                
                            }
                        }
                    }				
                    
                }else {  
                    errorLogsList.add(
                        ErrorLogUtil.createSampleErrorLog(
                            String.valueOf(httpResponse.getStatusCode()), httpResponse.getStatus(), httpResponse.getStatus(), className, methodName, 'Account/Property/Ownership', 'Property Tree'
                        )
                    );  
                }
            }catch(Exception ex){
                system.debug('#####Error while processing the request:'+ex);
                errorLogsList.add(
                    ErrorLogUtil.createSampleErrorLog(
                        null, ex.getMessage(), 'Error while processing the request:'+ ex, className, methodName, 'Account/Property/Ownership', 'Property Tree'
                    )
                );            
            }
            
            //Log errors in to Error log
            if(!errorLogsList.isEmpty()){
                insert errorLogsList;
            }
        } else {
            return false;
        }
        return errorLogsList.isEmpty();
    }
}