@isTest
private class Test_Consultant {
    
    @testsetup
    static void createClient()
    {   
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
    	User usr = TestDataFactory.createUsers(p.Id,1)[0];
        insert usr; 
    }
    
    
    static testMethod void testDoGetModified() 
    {
        System.runAs(new user(ID = UserInfo.getUserID()))
        {
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/StandardConsultant/branchCode/1069';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            StandardConsultantRest.ResponseClass results = StandardConsultantRest.doGet();       
            System.assertEquals('true', results.success);  
            System.assertEquals('Query executed successfully.', results.message);  
        }
    }  
    
  	static testMethod void testDoGet() 
    {
  		System.runAs(new user(ID = UserInfo.getUserID()))
        {
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/DateSetConsultant/branchCode/1069/date/2017-05-21T00d00d00';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            DateSetConsultantRest.ResponseClass results = DateSetConsultantRest.doGet();       
            System.assertEquals('true', results.success);  
            System.assertEquals('Query executed successfully.', results.message);  
        }
   }
    
}