@isTest
private class Test_Clientready{

static testMethod void testDoGet() 
    {        
      
      test.startTest();
        String query = 'Select id from sirenum__Site__c limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassClientToTempest__c';
        String Field2 = 'IP_ClientLastPassedToTempest__c';
        Database.executeBatch(new ClientBatch(Query,Field1,Field2,GUID),100);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/standard/v1/ready/client/1069';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Clientready.ResponseClass results = Clientready.doGet();       
        System.assertEquals('false', results.success);  
        System.assertEquals('Not Ready', results.message);  
        test.stopTest();
    }
static testMethod void testDoGet1() 
    {        
      
      test.startTest();
        String query = 'Select id from sirenum__Site__c limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassClientToTempest__c';
        String Field2 = 'IP_ClientLastPassedToTempest__c';
        String Field3 = 'IP_EmergencyPullClient__c';
        Database.executeBatch(new ClientEmergencyBatch(Query,Field1,Field2,Field3,GUID),100);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/ready/client/1069';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        ClientEmergencyready.ResponseClass results = ClientEmergencyready.doGet();       
        System.assertEquals('false', results.success);  
        System.assertEquals('Not Ready', results.message);  
        test.stopTest();
    }
}