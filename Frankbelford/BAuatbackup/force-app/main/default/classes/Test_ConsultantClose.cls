@isTest
private class Test_ConsultantClose{

static testMethod void testDoGet() 
    {        
      
      test.startTest();
        String query = 'Select id from User limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';
        Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'ConsultantClose', Limit__c = '10');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        Database.executeBatch(new ConsultantBatch(Query,Field1,Field2,GUID),limit1);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/standard/v1/close/consultant/1069/ABCD';  
        req.httpMethod = 'Post';
        RestContext.request = req;
        RestContext.response = res;
        ConsultantClose.ResponseClass results = ConsultantClose.doPost();       
        System.assertEquals('true', results.success);  
        System.assertEquals('Batch Process initiated', results.message);  
        test.stopTest();
    }
    static testMethod void testDoGet1() 
    {        
      
      test.startTest();
        String query = 'Select id from User limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';
         Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'ConsultantEmergencyClose', Limit__c = '10');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        Database.executeBatch(new ConsultantEmergencyBatch(Query,Field1,Field2,GUID),limit1);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergemcy/v1/close/consultant/1069/ABCD';  
        req.httpMethod = 'Post';
        RestContext.request = req;
        RestContext.response = res;
        ConsultantEmergencyClose.ResponseClass results = ConsultantEmergencyClose.doPost();       
        System.assertEquals('true', results.success);  
        System.assertEquals('Batch Process initiated', results.message);  
        test.stopTest();
    }
}