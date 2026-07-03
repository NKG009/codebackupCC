public class OwnershipNameUpdateByPropertyIdScheduler implements Schedulable {

    public static List<Error_Log__c> errorLogsList = new List<Error_Log__c>();
    
    public void execute(SchedulableContext sc) { 
        for(Property_Account_Id__c propertyAccRec : [Select Name FROM Property_Account_Id__c LIMIT 1]) {
        	updateOwnershipNameByPropertyId(propertyAccRec.Name);
            break;
        }
    }
    
    @future(callout=true)
    public static void updateOwnershipNameByPropertyId(String accountId) {
        try {
            for(Account accRec : [Select Id, Ownership_Name__c, Parent.Name, Parent.ExternalIdEncrypted__c, API_Ownership_External_ID__c, Property_Company_Source_Id__c FROM Account WHERE Id =: accountId]) {
                String ownershipName = getOwnershipsNameByPropertyRec(accRec);
                if(accRec.Ownership_Name__c != ownershipName) {
                    accRec.Ownership_Name__c = ownershipName;
                    update accRec;
                    delete [Select Id FROM Property_Account_Id__c WHERE Name =: accountId];
                }
            }
        } catch(Exception e) {
            errorLogsList.add(
                ErrorLogUtil.createSampleErrorLog(
                    null, e.getMessage(), 'Error while processing the request:'+ e, 'OwnershipNameUpdateByPropertyIdScheduler', 
                    'updateOwnershipNameByPropertyIds', 'Account/Ownership', 'Property Tree'
                )
            );
        }
        ErrorLogUtil.insertLogs(errorLogsList);
        scheduleJob(1);
    }
    
    public static void scheduleJob(Integer noOfMinutes) {
        String jobName = 'Update ownership name by property id';
        for(CronTrigger job : [select Id from CronTrigger where CronJobDetail.Name =: jobName]) { System.abortJob(job.Id); }
        system.schedule(jobName, getCRONExpressionInminutes(noOfMinutes), new OwnershipNameUpdateByPropertyIdScheduler());
    }
    
    private static String getCRONExpressionInminutes(Integer noOfMinutes) {
        noOfMinutes = noOfMinutes != null && noOfMinutes > 0 ? noOfMinutes : 1;
    	DateTime dtVal = system.now().addMinutes(noOfMinutes);
        return String.valueOf(dtVal.second()) + ' ' + String.valueOf(dtVal.minute()) + ' ' + String.valueOf(dtVal.hour()) + 
                                ' ' + String.valueOf(dtVal.day()) + ' ' + String.valueOf(dtVal.month()) + ' ?' + ' ' + String.valueOf(dtVal.year());
    }
    
    private static HTTPResponse makeCallout(String ownershipId, String companyId, String authKey) {
        String OwnershipsRestAPIURL = 'https://api.propertytree.io/residentialproperty/v1/Ownerships/'+ownershipId;

        system.debug('##### OwnershipsRestAPIURL:'+ OwnershipsRestAPIURL);
        system.debug('##### authKey:'+ authKey);
        system.debug('##### companyId:'+ companyId); 
        HttpRequest httpRequest = new HttpRequest();  
        httpRequest.setMethod('GET');  
        httpRequest.setHeader('company_id', companyId);
        httpRequest.setHeader('authorization', 'Bearer ' + authKey); 
        httpRequest.setEndpoint(OwnershipsRestAPIURL); 
        Http http = new Http();   
        return http.send(httpRequest);  
    }
    
    public static String getOwnershipsNameByPropertyRec(Account propertyRec) {
        String ownershipName = null;
        List<Error_Log__c> errorLogsList = new List<Error_Log__c>();
        
        String companyId, authKey;
        for(Property_360_Company__c companyRec : OwnershipNameUpdateService.getP360CompanyDetailByRealEstateAccount(propertyRec.Parent)) {
            companyId = companyRec.Company_Name__c;
            authKey = companyRec.Key__c;
        }
        if(String.isBlank(companyId) || String.isBlank(authKey)) {
            for(Property_360_Company__c companyRec : [Select Id, Company_Name__c, Key__c FROM Property_360_Company__c WHERE Company_Name__c =: propertyRec.Property_Company_Source_Id__c]) {
                companyId = companyRec.Company_Name__c;
                authKey = companyRec.Key__c;
            }
        }
        
        HttpResponse httpResponse = makeCallout(
            propertyRec.API_Ownership_External_ID__c,
            companyId, authKey
        );
        
        if (httpResponse.getStatusCode() == 200 ) {
            OwnershipWrapper result = (OwnershipWrapper) System.JSON.deserialize(httpResponse.getBody(), OwnershipWrapper.class);
            ownershipName = result.Name;
            
        }else {  
            errorLogsList.add(
                ErrorLogUtil.createSampleErrorLog(
                    String.valueOf(httpResponse.getStatusCode()), httpResponse.getBody(), httpResponse.getStatus(), 'OwnershipNameUpdateByPropertyIdScheduler', 
                    'getOwnershipsNameByPropertyRec', 'Account/Ownership', 'Property Tree'
                )
            );  
        }
        return ownershipName;
    }
}