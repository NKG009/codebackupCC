@isTest
private class Test_ClientRestApi {
    
    @testsetup
    static void createClient()
    {   
        
        Account account = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account; 
        system.debug('all account data in api class----'+account.id);
        Contact cont = TestDataFactory.createCandidate(account.id, 1)[0];
        insert cont;
        system.debug('all contact data in api class----'+cont.id);
		IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
		insert tpz;
        system.debug('all tpz data in api class----'+tpz);
		sirenum__Site__c sites =	TestDataFactory.createSites(account.Id, tpz.id,1)[0];
		insert sites;
		system.debug('all sites data in api class----'+sites);		
    }
    
    
    static testMethod void testDoGetModified() 
    {        
        /*System.runAs(new user(ID = UserInfo.getUserID()))*/
        
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/StandardClient/branchCode/1069';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            StandardClientRest.ResponseClass results = StandardClientRest.doGet();       
            System.assertEquals('true', results.success);  
            System.assertEquals('Query executed successfully.', results.message);  
        /*}*/
    }  
    
    static testMethod void testDoGetModifiedNegative() 
    {        
        /*System.runAs(new user(ID = UserInfo.getUserID())){*/
        
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/StandardClient/branchCode/0';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            StandardClientRest.ResponseClass results = StandardClientRest.doGet();       
            System.assertEquals('true', results.success);  
            System.assertEquals('Query executed successfully.', results.message);  
        /*}*/
    }  
    
    static testMethod void testDoGet() 
    {
        /*System.runAs(new user(ID = UserInfo.getUserID())) {*/
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/DateSetClient/branchCode/1069/date/2017-05-21T00d00d00';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        DateSetClientRest.ResponseClass results = DateSetClientRest.doGet();       
        System.assertEquals('true', results.success);  
        System.assertEquals('Query executed successfully.', results.message);  
        /*}*/
   }
    
    static testMethod void testDoGetNegative() 
    {
        /*System.runAs(new user(ID = UserInfo.getUserID())) {*/
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/DateSetClient/branchCode/1/date/2217-05-21T00d00d00';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        DateSetClientRest.ResponseClass results = DateSetClientRest.doGet();       
        System.assertEquals('true', results.success);  
        System.assertEquals('Query executed successfully.', results.message);  
        /*}*/
   }
    
}