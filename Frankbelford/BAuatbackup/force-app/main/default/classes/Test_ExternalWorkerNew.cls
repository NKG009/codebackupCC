@isTest
private class Test_ExternalWorkerNew {
    
    @testsetup
    static void createWorker()
    {   
       Account clnt = TestDataFactory.create2ndTierSupplierAccount(1)[0];
       insert clnt; 
       
       insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);     
       Contact tier2nd = TestDataFactory.createCandidate2ndTier(clnt.Id,1)[0];
        tier2nd.FirstName = 'TestManishabcd';
       insert tier2nd;
       
    }
    
    
    static testMethod void testDoGetModified() 
    {
            Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'ExternalWorkerRest', Limit__c = '40');
            insert set1;
            Integer limit1 = Integer.Valueof(set1.Limit__c);    
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/standard/v1/collect/externalworker/1069/ABCD';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            ExternalWorkerRest.ResponseClass results = ExternalWorkerRest.doGet();       
            System.assertEquals('false', results.success);  
            System.assertEquals('Error in querying records', results.message);  
    }  
     static testMethod void testDoGetModified1() 
    {
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
             Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'ExternalWorkerEmergencyRest', Limit__c = '40');
            insert set1;
            Integer limit1 = Integer.Valueof(set1.Limit__c);    
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/collect/externalworker/1069/ABCD';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            ExternalWorkerEmergencyRest.ResponseClass results = ExternalWorkerEmergencyRest.doGet();       
            System.assertEquals('false', results.success);  
            System.assertEquals('Error in querying records', results.message);  
    } 
    
    }