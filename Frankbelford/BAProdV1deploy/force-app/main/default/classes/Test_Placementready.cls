@isTest
private class Test_Placementready{

static testMethod void testDoGet() 
    {        
      
      test.startTest();
        String query = 'Select id from ts2__Placement__c limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';
        Database.executeBatch(new PlacementBatch(Query,Field1,Field2,GUID),100);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/standard/v1/ready/placement/1069';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Placementready.ResponseClass results = Placementready.doGet();       
        System.assertEquals('false', results.success);  
        System.assertEquals('Not Ready', results.message);  
        test.stopTest();
    }
    static testMethod void testDoGet1() 
    {        
      
      test.startTest();
        String query = 'Select id from ts2__Placement__c limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';
        Database.executeBatch(new  PlacementEmergencyBatch(Query,Field1,Field2,GUID),100);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/ready/placement/1069';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Placementemergencyready.ResponseClass results = Placementemergencyready.doGet();       
        System.assertEquals('false', results.success);  
        System.assertEquals('Not Ready', results.message);  
        test.stopTest();
    }
}