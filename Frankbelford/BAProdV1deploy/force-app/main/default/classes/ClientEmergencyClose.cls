@RestResource(urlMapping='/emergency/v1/close/client/*/*')

global class ClientEmergencyClose


{
    @HttpPost
    
      global static ResponseClass doPost()
        {
            String[] uriKeys = RestContext.request.requestURI.split('/'); 
            String GUID = uriKeys.get(uriKeys.size()-1);
            String Query = 'Select id from sirenum__Site__c where IP_EmergencyPullClient__c= TRUE and GUID_Site__c=:GUID';
            String Field1 = 'IP_PassClientToTempest__c';
            String Field2 = 'IP_ClientLastPassedToTempest__c';
            String Field3 = 'IP_EmergencyPullClient__c';
            Impellam_Settings__c set1 = Impellam_Settings__c.getValues('ClientEmergencyClose'); 
            Integer limit1 = Integer.Valueof(set1.Limit__c);
            try{
            Database.executeBatch(new ClientEmergencyBatch(Query,Field1,Field2,Field3,GUID),limit1);
           return new ResponseClass('true','Batch Process initiated');
         }
           catch(DMLException e){return new ResponseClass('false', e.getMessage());
            }
        }
     global class ResponseClass 
    {        
        global String success;
        global String message;        
       
        global ResponseClass(String success, String message) 
        {
            this.success = success;
            this.message = message;
        }
    }
}