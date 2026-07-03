@RestResource(urlMapping='/emergency/v1/close/internalworker/*/*')

global class InternalWorkerEmergencyClose

{
    @HttpPost    
      global static ResponseClass doPost()
        {
            String[] uriKeys = RestContext.request.requestURI.split('/'); 
            String GUID = uriKeys.get(uriKeys.size()-1);
            String Query = 'Select id from IP_PayProfile__c  where IP_EmergencyPull__c=TRUE and IP_GUID__c=:GUID';
            String Field1 = 'IP_PassToTempest__c';
            String Field2 = 'IP_LastPassedToTempest__c';
            String Field3 = 'IP_EmergencyPull__c';
               Impellam_Settings__c set1 = Impellam_Settings__c.getValues('Internalworkeremergencyclose'); 
             Integer limit1 = Integer.Valueof(set1.Limit__c);
            try
            {
            Database.executeBatch(new InternalWorkerEmergencyBatch (Query,Field1,Field2,Field3,GUID),limit1);
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