@isTest
private class Test_ClientAddressNew {
    
    @testsetup
    static void createClient()
    {   
        
        Account account = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account; 
        system.debug('all account data in api class----'+account);
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact cont = TestDataFactory.createCandidate(account.id, 1)[0];
        insert cont;
        system.debug('all contact data in api class----'+cont);
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        insert tpz;
        system.debug('all tpz data in api class----'+tpz);
        sirenum__Site__c sites =  TestDataFactory.createSites(account.Id, tpz.id,1)[0];
        sites.name = 'ValidationSite1';
        sites.IP_EmergencyPullClientAddress__c=true;
        insert sites;
        system.debug('all sites data in api class----'+sites);
    
    }
     static testMethod void testDoGetModified() 
    {        
            Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'ClientAddressRest', Limit__c = '40');
            insert set1;
            Integer limit1 = Integer.Valueof(set1.Limit__c);    
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/standard/v1/collect/clientaddress/1069/ABCD';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            ClientAddressRest.ResponseClass results = ClientAddressRest.doGet();       
            System.assertEquals('false', results.success);  
            System.assertEquals('Error in querying records', results.message);  
      
    }  
    static testMethod void testDoGetModified1() 
    {        
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            Impellam_Settings__c set1 =  new Impellam_Settings__c(name = '  ClientAddressEmergencyRest', Limit__c = '40');
            insert set1;
            Integer limit1 = Integer.Valueof(set1.Limit__c);    
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/collect/clientaddress/1069/ABCD';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            ClientAddressEmergencyRest.ResponseClass results = ClientAddressEmergencyRest.doGet();       
            System.assertEquals('false', results.success);  
            System.assertEquals('Error in querying records', results.message);  
      
    }  
    }