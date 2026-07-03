@isTest
private class Test_ClientRestNew {
    
    @testsetup
    static void createClient()
    {   
        
        Account account = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account; 
        system.debug('all account data in api class----'+account.id);
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact cont = TestDataFactory.createCandidate(account.id, 1)[0];
        insert cont;
        system.debug('all contact data in api class----'+cont.id);
    IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
    insert tpz;
        system.debug('all tpz data in api class----'+tpz);
        
        Payroll_Swtich__c pay = new Payroll_Swtich__c();
        pay.Name = 'Stoppayroll'; // Match the name expected by the trigger
        pay.Batch_check__c = true;
        insert pay;
    sirenum__Site__c sites =  TestDataFactory.createSites(account.Id, tpz.id,1)[0];
        sites.name = 'ValidationSite';
        sites.IP_EmergencyPullClient__c=True;
        sites.IP_PassClientToTempest__c = true;
        sites.GUID_Site__c = '';
    insert sites;
        sites.GUID_Site__c = '';
        update sites;
    system.debug('all sites data in api class----'+sites);    
    }
     static testMethod void testDoGetModified() 
    {        
            Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'ClientRest', Limit__c = '40');
            insert set1;
            Integer limit1 = Integer.Valueof(set1.Limit__c);        
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/standard/v1/collect/client/0000/ABCD';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            ClientRest.ResponseClass results = ClientRest.doGet();       
            System.assertEquals('true', results.success);  
            System.assertEquals('Query executed successfully.', results.message);  
       
    }
    static testMethod void testDoGetModified1() 
    {               
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
             Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'ClientEmergencyRest', Limit__c = '40');
            insert set1;
            Integer limit1 = Integer.Valueof(set1.Limit__c);   
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/collect/client/0000/ABCD';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            ClientEmergencyRest.ResponseClass results = ClientEmergencyRest.doGet();       
            System.assertEquals('true', results.success);  
            System.assertEquals('Query executed successfully.', results.message);  
       
    }
    }