@RestResource(urlMapping='/standard/v1/close/clientaddress/*/*')

global class ClientAddressClose

{
    @HttpPost
    
      global static ResponseClass doPost()
        {
            String[] uriKeys = RestContext.request.requestURI.split('/'); 
            String GUID = uriKeys.get(uriKeys.size()-1);
            String Query = 'Select id from sirenum__Site__c where IP_PassClientAddressToTempest__c = TRUE and GUID_Site_Address__c=:GUID';
            String Field1 = 'IP_PassClientAddressToTempest__c';
            String Field2 = 'IP_ClientAddressLastPassedToTempest__c';
            Impellam_Settings__c set1 = Impellam_Settings__c.getValues('ClientAddressClose'); 
            Integer limit1 = Integer.Valueof(set1.Limit__c);
            try
            {
            Database.executeBatch(new ClientAddressBatch(Query,Field1,Field2,GUID),limit1);
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