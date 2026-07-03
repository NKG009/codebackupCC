@isTest
private class Test_Consultantready{

static testMethod void testDoGet() 
    {        
      
      test.startTest();
        String query = 'Select id from User limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';
        Database.executeBatch(new ConsultantBatch(Query,Field1,Field2,GUID),100);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/standard/v1/ready/consultant/1069';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Consultantready.ResponseClass results = Consultantready.doGet();       
        System.assertEquals('false', results.success);  
        System.assertEquals('Not Ready', results.message);  
        test.stopTest();
    }
    static testMethod void testDoGet1() 
    {        
      
      test.startTest();
        String query = 'Select id from User limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';
        Database.executeBatch(new ConsultantEmergencyBatch(Query,Field1,Field2,GUID),100);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/ready/consultant/1069';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        ConsultantEmergencyready.ResponseClass results = ConsultantEmergencyready.doGet();       
        System.assertEquals('false', results.success);  
        System.assertEquals('Not Ready', results.message);  
        test.stopTest();
    }
}