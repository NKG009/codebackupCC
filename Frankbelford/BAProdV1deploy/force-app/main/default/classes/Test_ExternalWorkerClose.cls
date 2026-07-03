@isTest
private class Test_ExternalWorkerClose{

static testMethod void testDoGet() 
    {        
      
      test.startTest();
        String query = 'Select id from Contact limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_Pass2ndTierToTempest__c';
        String Field2 = 'IP_LastPassedToTempest2ndTier__c';
         Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'ExternalWorkerEmergencyClose', Limit__c = '20');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        Database.executeBatch(new ExternalWorkerEmergencyBatch(Query,Field1,Field2,GUID),limit1);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/close/externalworker/1069/ABCD';  
        req.httpMethod = 'Post';
        RestContext.request = req;
        RestContext.response = res;
        ExternalWorkerEmergencyClose.ResponseClass results = ExternalWorkerEmergencyClose.doPost();       
        System.assertEquals('true', results.success);  
        System.assertEquals('Batch Process initiated', results.message);  
        test.stopTest();
    }
    
static testMethod void testDoGet1() 
    {        
      
      test.startTest();
        String query = 'Select id from Contact limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_Pass2ndTierToTempest__c';
        String Field2 = 'IP_LastPassedToTempest2ndTier__c';
        Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'ExternalWorkerClose', Limit__c = '20');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        Database.executeBatch(new ExternalWorkerBatch(Query,Field1,Field2,GUID),limit1);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/standard/v1/close/externalworker/1069/ABCD';  
        req.httpMethod = 'Post';
        RestContext.request = req;
        RestContext.response = res;
        ExternalWorkerClose.ResponseClass results = ExternalWorkerClose.doPost();       
        System.assertEquals('true', results.success);  
        System.assertEquals('Batch Process initiated', results.message);  
        test.stopTest();
    }
}