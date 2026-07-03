@isTest
private class Test_ClientAddressready{

static testMethod void testDoGet() 
    {        
      
      test.startTest();
        String query = 'Select id from sirenum__Site__c limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassClientAddressToTempest__c';
        String Field2 = 'IP_ClientAddressLastPassedToTempest__c';
        Database.executeBatch(new ClientAddressBatch(Query,Field1,Field2,GUID),100);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/standard/v1/ready/clientAddress/1069';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        ClientAddressready.ResponseClass results = ClientAddressready.doGet();       
        System.assertEquals('false', results.success);  
        System.assertEquals('Not Ready', results.message);  
        test.stopTest();
    }
static testMethod void testDoGet1() 
    {        
      
      test.startTest();
        String query = 'Select id from sirenum__Site__c limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassClientAddressToTempest__c';
        String Field2 = 'IP_ClientAddressLastPassedToTempest__c';
        String Field3 = 'IP_EmergencyPullClientAddress__c';
        Database.executeBatch(new ClientAddressEmergencyBatch(Query,Field1,Field2,Field3,GUID),100);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/ready/clientaddress/1069';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        ClientAddressEmergencyready.ResponseClass results = ClientAddressEmergencyready.doGet();       
        System.assertEquals('false', results.success);  
        System.assertEquals('Not Ready', results.message);  
        test.stopTest();
    }
}