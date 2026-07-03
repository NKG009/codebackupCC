@isTest
private class Test_ConsultantNew {
    
    @testsetup
    static void createuser()
    {   
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username= 'mko.vfr@njh.com';
        usr.IP_TempestDepartment__c='1062';
        insert usr; 
    }
    
    
    static testMethod void testDoGetModified() 
    {
           
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'ConsultantRest', Limit__c = '10');
            insert set1;
            Integer limit1 = Integer.Valueof(set1.Limit__c);
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/standard/v1/collect/consultant/1062/ABCD';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            ConsultantRest.ResponseClass results = ConsultantRest.doGet();       
            System.assertEquals('false', results.success);  
            System.assertEquals('Error in querying records', results.message);  
            //System.assertEquals('Query executed successfully.', results.message);
    }  
   static testMethod void testDoGetModified1() 
    {
                    
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
             Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'ConsultantEmergencyRest', Limit__c = '10');
            insert set1;
            Integer limit1 = Integer.Valueof(set1.Limit__c);
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/collect/consultant/1062/ABCD';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            ConsultantEmergencyRest.ResponseClass results = ConsultantEmergencyRest.doGet();       
            System.assertEquals('false', results.success);  
        	System.assertEquals('Error in querying records', results.message);  
            //System.assertEquals('Query executed successfully.', results.message);  
            

        }
    
}