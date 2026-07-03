@isTest 
private class Test_PlacementApi 
{
    
    
    @testsetup
    static void createWorker()
    {   
        Account client = TestDataFactory.createClients(1)[0]; 
        Insert client;
        
        Account account = TestDataFactory.createAccounts(1)[0];
         account.IP_PublicSectorSupplierOrClient__c = true;
        Insert account;
        
        Account accountcan = TestDataFactory.createCandidateAccount(1)[0];
        Insert accountcan;
        
        Contact cont = TestDataFactory.createContact(client.id, 1)[0];
        Insert cont;
        
        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        Insert candidate;
        
        
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        Insert tpz;
        
        sirenum__Site__c sites = TestDataFactory.createSites(account.id, tpz.id, 1)[0];
        Insert sites;
        
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        insert usr; 
        
        ts2__Job__c jb = TestDataFactory.createT2Job(usr.id, 1)[0];
        Insert jb;
        
        ts2__Placement__c ts2p = TestDataFactory.createTs2Placement(client.Id, candidate.Id, cont.Id, jb.Id, sites.id,'Perm', 1)[0]; 
        Insert ts2p;
        
    }
    
    static testMethod void testDoGetModified() 
    {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/DateSetPlacement/branchCode/1069/date/2017-05-21T00d00d00';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        DateSetPlacementRest.ResponseClass results = DateSetPlacementRest.doGet();       
        System.assertEquals('true', results.success);  
        System.assertEquals('Query executed successfully.', results.message);  
        
    }  
    
    static testMethod void testDoGet() 
    {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/StandardPlacement/branchCode/1069';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        StandardPlacementRest.ResponseClass results = StandardPlacementRest.doGet();         
        System.assertEquals('true', results.success);  
        System.assertEquals('Query executed successfully.', results.message);  
    }
    
    
    
}