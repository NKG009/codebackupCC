@isTest
private class Test_ClientAddressClose{

static testMethod void testDoGet() 
    {        
      
      test.startTest();
        String query = 'Select id from sirenum__Site__c  limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassClientAddressToTempest__c';
        String Field2 = 'IP_ClientAddressLastPassedToTempest__c';
        Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'ClientAddressClose', Limit__c = '40');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        Database.executeBatch(new ClientAddressBatch(Query,Field1,Field2,GUID),limit1);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/standard/v1/close/clientaddress/1069/ABCD';  
        req.httpMethod = 'Post';
        RestContext.request = req;
        RestContext.response = res;
        ClientAddressClose.ResponseClass results = ClientAddressClose.doPost();       
        System.assertEquals('true', results.success);  
        System.assertEquals('Batch Process initiated', results.message);  
        test.stopTest();
    }
    static testMethod void testDoGet1() 
    {        
      
      test.startTest();
        String query = 'Select id from sirenum__Site__c  limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassClientAddressToTempest__c';
        String Field2 = 'IP_ClientAddressLastPassedToTempest__c';
        String Field3 = 'IP_EmergencyPullClientAddress__c';
        Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'ClientAddressEmergencyClose', Limit__c = '40');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        Database.executeBatch(new ClientAddressEmergencyBatch(Query,Field1,Field2,Field3,GUID),limit1);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/close/clientaddress/1069/ABCD';  
        req.httpMethod = 'Post';
        RestContext.request = req;
        RestContext.response = res;
        ClientAddressEmergencyClose.ResponseClass results = ClientAddressEmergencyClose.doPost();       
        System.assertEquals('true', results.success);  
        System.assertEquals('Batch Process initiated', results.message);  
        test.stopTest();
    }
}