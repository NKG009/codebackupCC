@isTest
private class Test_Timesheetready{

static testMethod void testDoGet() 
    {        
      
      test.startTest();
        String query = 'Select id from sirenum__Timesheet_Line__c limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';
        Database.executeBatch(new TimesheetLineBatch(Query,Field1,Field2,GUID),100);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/standard/v1/ready/timesheet/1069';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Timesheetready.ResponseClass results = Timesheetready.doGet();       
        System.assertEquals('false', results.success);  
        System.assertEquals('Not Ready', results.message);  
        test.stopTest();
    }
    static testMethod void testDoGet1() 
    {        
      
      test.startTest();
        String query = 'Select id from sirenum__Timesheet_Line__c limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';
        String Field3 = 'IP_EmergencyPull__c';
        Database.executeBatch(new  TimesheetEmergencyBatch(Query,Field1,Field2,Field3,GUID),100);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/ready/timesheet/1069';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        TimesheetEmergencyready.ResponseClass results = TimesheetEmergencyready.doGet();       
        System.assertEquals('false', results.success);  
        System.assertEquals('Not Ready', results.message);  
        test.stopTest();
    }
}