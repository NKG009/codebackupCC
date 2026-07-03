@RestResource(urlMapping='/standard/v1/close/externalworker/*/*')

global class ExternalWorkerClose

{
    @HttpPost
    
      global static ResponseClass doPost()
        {
            String[] uriKeys = RestContext.request.requestURI.split('/'); 
            String GUID = uriKeys.get(uriKeys.size()-1);
            String Query = 'Select id from Contact where IP_Pass2ndTierToTempest__c = TRUE and GUID__c=:GUID';
            String Field1 = 'IP_Pass2ndTierToTempest__c';
            String Field2 = 'IP_LastPassedToTempest2ndTier__c';
             Impellam_Settings__c set1 = Impellam_Settings__c.getValues('ExternalWorkerClose'); 
             Integer limit1 = Integer.Valueof(set1.Limit__c);
            try
            {
            Database.executeBatch(new ExternalWorkerBatch(Query,Field1,Field2,GUID),limit1);
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