@isTest
private class Test_ExternalWorker {
    
    @testsetup
    static void createWorker()
    {   
       Account clnt = TestDataFactory.create2ndTierSupplierAccount(1)[0];
       insert clnt; 
      
       Contact tier2nd = TestDataFactory.createCandidate2ndTier(clnt.Id,1)[0];
       insert tier2nd;
       
    }
    
    
    static testMethod void testDoGetModified() 
    {
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/StandardExternalWorker/branchCode/1069';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            StandardExternalWorkerRest.ResponseClass results = StandardExternalWorkerRest.doGet();       
            System.assertEquals('true', results.success);  
            System.assertEquals('Query executed successfully.', results.message);  
    }  
    
    static testMethod void testDoGetModifiedNegative() 
    {
      
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/StandardExternalWorker/branchCode/1066';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            StandardExternalWorkerRest.ResponseClass results = StandardExternalWorkerRest.doGet();       
            System.assertEquals('true', results.success);  
            System.assertEquals('Query executed successfully.', results.message);  
        
    } 
    
  	static testMethod void testDoGet() 
    {
  		
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/DateSetExternalWorkers/branchCode/1069/date/2017-05-21T00d00d00';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            DateSetExternalWorkersRest.ResponseClass results = DateSetExternalWorkersRest.doGet();       
            System.assertEquals('true', results.success);  
            System.assertEquals('Query executed successfully.', results.message);  
        
   }
    
    static testMethod void testDoGetNegative() 
    {
  		
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/DateSetExternalWorkers/branchCode/1066/date/2217-05-21T00d00d00';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            DateSetExternalWorkersRest.ResponseClass results = DateSetExternalWorkersRest.doGet();       
            System.assertEquals('true', results.success);  
            System.assertEquals('Query executed successfully.', results.message);  
        
   }
    
}