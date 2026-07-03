@RestResource(urlMapping='/standard/v1/close/placement/*/*')

global class PlacementClose

{
    @HttpPost
    
      global static ResponseClass doPost()
        {
            String[] uriKeys = RestContext.request.requestURI.split('/'); 
            String GUID = uriKeys.get(uriKeys.size()-1);
            String Query = 'Select id from ts2__Placement__c  where IP_PassToTempest__c = TRUE and GUID_Placement_js__c=:GUID';
            String Field1 = 'IP_PassToTempest__c';
            String Field2 = 'IP_LastPassedToTempest__c';
              Impellam_Settings__c set1 = Impellam_Settings__c.getValues('PlacementClose'); 
             Integer limit1 = Integer.Valueof(set1.Limit__c);
            try
            {
            Database.executeBatch(new PlacementBatch(Query,Field1,Field2,GUID),limit1);
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