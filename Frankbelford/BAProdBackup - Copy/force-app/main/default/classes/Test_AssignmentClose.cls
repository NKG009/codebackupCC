@isTest
private class Test_AssignmentClose{

static testMethod void testDoGet() 
    {        
        
        test.startTest();
        String query = 'Select id from sirenum__Placement__c limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';
        Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'AssignmentClose', Limit__c = '100');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        Database.executeBatch(new AssignmentBatch(Query,Field1,Field2,GUID),limit1);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/standard/v1/close/assignment/1069/ABCD';  
        req.httpMethod = 'Post';
        RestContext.request = req;
        RestContext.response = res;
        AssignmentClose.ResponseClass results = AssignmentClose.doPost();       
        System.assertEquals('true', results.success);  
        System.assertEquals('Batch Process initiated', results.message);  
        test.stopTest();
    }
    static testMethod void testDoGet1() 
    {        
      
      test.startTest();
        String query = 'Select id from sirenum__Placement__c limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';
        String Field3 = 'IP_EmergencyPull__c';
         Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'AssignmentEmergencyClose', Limit__c = '100');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        Database.executeBatch(new AssignmentEmergencyBatch(Query,Field1,Field2,Field3,GUID),limit1);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/close/assignment/1069/ABCD';  
        req.httpMethod = 'Post';
        RestContext.request = req;
        RestContext.response = res;
        AssignmentEmergencyClose.ResponseClass results = AssignmentEmergencyClose.doPost();       
        System.assertEquals('true', results.success);  
        System.assertEquals('Batch Process initiated', results.message);  
        test.stopTest();
    }
}