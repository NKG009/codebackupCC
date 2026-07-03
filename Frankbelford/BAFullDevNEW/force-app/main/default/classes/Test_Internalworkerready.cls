@isTest
private class Test_Internalworkerready{

static testMethod void testDoGet() 
    {        
      
      test.startTest();
        String query = 'Select id from IP_PayProfile__c limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';
           insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = true);
        Database.executeBatch(new InternalWorkerBatch(Query,Field1,Field2,GUID),100);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = URL.getCurrentRequestUrl()+'/services/apexrest/standard/v1/ready/internalworker/1069';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Internalworkerready.ResponseClass results = Internalworkerready.doGet();       
        System.assertEquals('false', results.success);  
        System.assertEquals('Not Ready', results.message);  
        test.stopTest();
    }
    static testMethod void testDoGet1() 
    {        
      
      test.startTest();
        String query = 'Select id from IP_PayProfile__c limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';
        String Field3 = 'IP_EmergencyPull__c';
        Database.executeBatch(new InternalWorkerEmergencyBatch(Query,Field1,Field2,Field3,GUID),100);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = URL.getCurrentRequestUrl()+'/services/apexrest/emergency/v1/ready/internalworker/1069';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        InternalworkerEmergencyready.ResponseClass results = InternalworkerEmergencyready.doGet();       
        System.assertEquals('false', results.success);  
        System.assertEquals('Not Ready', results.message);  
        test.stopTest();
    }
}