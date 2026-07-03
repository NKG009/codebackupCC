@isTest 
private class Test_PlacementApiNew
{
    
    
    @testsetup
    static void createWorker()
    {   
        Account client = TestDataFactory.createClients(1)[0]; 
        Insert client;
        
        Account account = TestDataFactory.createAccounts(1)[0];
        Insert account;
        
        Account accountcan = TestDataFactory.createCandidateAccount(1)[0];
        Insert accountcan;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact cont = TestDataFactory.createContact(client.id, 1)[0];
        Insert cont;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        Insert candidate;
        
        
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        Insert tpz;
        
        sirenum__Site__c sites = TestDataFactory.createSites(account.id, tpz.id, 1)[0];
        Insert sites;
        
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'pokygj123@yts.com';
        insert usr; 
        
        ts2__Job__c jb = TestDataFactory.createT2Job(usr.id, 1)[0];
        jb.ts2__Account__c = accountcan.id;
     	jb.ts2__Contact__c = candidate.id;
     	jb.sirenum_js__Site__c = sites.id;
     	jb.IP_Fixed_Fee__c = 100;  
        Insert jb;
        
        ts2__Placement__c ts2p = TestDataFactory.createTs2Placement(client.Id, candidate.Id, cont.Id, jb.Id, sites.id,'Perm', 1)[0]; 
        ts2p.Item__c='Testabc';       
        Insert ts2p;
        
    }
    static testMethod void testDoGet() 
    {
        Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'PlacementRest', Limit__c = '100');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/standard/v1/collect/placement/1069/ABCD';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        PlacementRest.ResponseClass results = PlacementRest.doGet();         
        System.assertEquals('false', results.success);  
        System.assertEquals('Error in querying records', results.message);  
    }
     static testMethod void testDoGet1() 
    {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
         Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'PlacementEmergencyRest', Limit__c = '100');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/collect/placement/1069/ABCD';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        PlacementEmergencyRest.ResponseClass results = PlacementEmergencyRest.doGet();         
        System.assertEquals('false', results.success);  
        System.assertEquals('Error in querying records', results.message);  
    }
    }