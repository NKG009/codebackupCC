@isTest
private class Test_Externalworkerready{

static testMethod void testDoGet() 
    {        
      
      test.startTest();
        String query = 'Select id from Contact limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_Pass2ndTierToTempest__c';
        String Field2 = 'IP_LastPassedToTempest2ndTier__c';
        Database.executeBatch(new ExternalWorkerBatch(Query,Field1,Field2,GUID),100);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/standard/v1/ready/externalworker/1069';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Externalworkerready.ResponseClass results = Externalworkerready.doGet();       
        System.assertEquals('false', results.success);  
        System.assertEquals('Not Ready', results.message);  
        test.stopTest();
    }
    static testMethod void testDoGet1() 

     {        
      
      test.startTest();
        String query = 'Select id from Contact limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_Pass2ndTierToTempest__c';
        String Field2 = 'IP_LastPassedToTempest2ndTier__c';
        Database.executeBatch(new ExternalWorkerEmergencyBatch(Query,Field1,Field2,GUID),100);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/ready/externalworker/1069';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        ExternalworkerEmergencyready.ResponseClass results = ExternalworkerEmergencyready.doGet();       
        System.assertEquals('false', results.success);  
        System.assertEquals('Not Ready', results.message);  
        test.stopTest();
    }
    
}