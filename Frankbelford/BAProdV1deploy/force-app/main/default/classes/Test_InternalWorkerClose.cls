@isTest
private class Test_InternalWorkerClose{

static testMethod void testDoGet() 
    {        
      
      test.startTest();
        String query = 'Select id from IP_PayProfile__c  limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';
        Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'Internalworkerclose', Limit__c = '20');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = true);
        Database.executeBatch(new InternalWorkerBatch(Query,Field1,Field2,GUID),limit1);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/standard/v1/close/internalworker/1069/ABCD';  
        req.httpMethod = 'Post';
        RestContext.request = req;
        RestContext.response = res;
        InternalWorkerClose.ResponseClass results = InternalWorkerClose.doPost();       
        System.assertEquals('true', results.success);  
        System.assertEquals('Batch Process initiated', results.message);  
        test.stopTest();
    }
    static testMethod void testDoGet1() 
    {        
      
      test.startTest();
        String query = 'Select id from IP_PayProfile__c  limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';
        String Field3 = 'IP_EmergencyPull__c';
        Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'Internalworkeremergencyclose', Limit__c = '20');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = true);
        
        Database.executeBatch(new InternalWorkerEmergencyBatch(Query,Field1,Field2,Field3,GUID),100);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/close/internalworker/1069/ABCD';  
        req.httpMethod = 'Post';
        RestContext.request = req;
        RestContext.response = res;
        InternalWorkerEmergencyClose.ResponseClass results = InternalWorkerEmergencyClose.doPost();       
        System.assertEquals('true', results.success);  
        System.assertEquals('Batch Process initiated', results.message);  
        test.stopTest();
    }
}