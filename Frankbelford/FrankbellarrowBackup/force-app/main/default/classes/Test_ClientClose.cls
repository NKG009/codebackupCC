@isTest
private class Test_ClientClose{

static testMethod void testDoGet() 
    {        
      
      test.startTest();
        String query = 'Select id from sirenum__Site__c  limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassClientToTempest__c';
        String Field2 = 'IP_ClientLastPassedToTempest__c';
        Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'ClientClose', Limit__c = '40');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        Database.executeBatch(new ClientBatch(Query,Field1,Field2,GUID),limit1);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/standard/v1/close/client/1069/ABCD';  
        req.httpMethod = 'Post';
        RestContext.request = req;
        RestContext.response = res;
        ClientClose.ResponseClass results = ClientClose.doPost();       
        System.assertEquals('true', results.success);  
        System.assertEquals('Batch Process initiated', results.message);  
        test.stopTest();
    }
    static testMethod void testDoGet1() 
    {        
      
      test.startTest();
        String query = 'Select id from sirenum__Site__c  limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassClientToTempest__c';
        String Field2 = 'IP_ClientLastPassedToTempest__c';
        String Field3 = 'IP_EmergencyPullClient__c';
         Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'ClientEmergencyClose', Limit__c = '40');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        Database.executeBatch(new ClientEmergencyBatch(Query,Field1,Field2,Field3,GUID),limit1);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/close/client/1069/ABCD';  
        req.httpMethod = 'Post';
        RestContext.request = req;
        RestContext.response = res;
        ClientEmergencyClose.ResponseClass results = ClientEmergencyClose.doPost();       
        System.assertEquals('true', results.success);  
        System.assertEquals('Batch Process initiated', results.message);  
        test.stopTest();
    }
}