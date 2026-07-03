@isTest
private class Test_AssignmentRest {
    
    @testsetup
    static void createAssignment()
    {   
        Account client = TestDataFactory.createClients(1)[0]; 
        Insert client;
        
                insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);

        Contact cont = TestDataFactory.createContact(client.id, 1)[0];
        Insert cont;
        
        Account clientacc = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert clientacc;
                insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);

        Contact candidate = TestDataFactory.createCandidate(clientacc.id, 1)[0];
        Insert candidate;
        
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
               id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
                IP_PayProfile__c payprofile = new IP_PayProfile__c();
         payprofile.RecordTypeId = payRTId;
          
         payprofile.IP_Candidate__c = candidate.id;
         payprofile.IP_CompanyName__c='sfdc';
         payprofile.IP_Status__c = 'Active'; 
         payprofile.IP_CompanyRegNo__c  = 'ad123456';
         payprofile.IP_VATNumber__c     = '123456789';
         payprofile.IP_PayrollID__c  = 'testpaynew';
         payprofile.IP_VATRegistered__c=true;
         payprofile.IP_OkToSupply__c=1;
         payprofile.IP_BusinessAddressLine1__c='test address 1';
         payprofile.IP_BusinessAddressLine2__c='test address 2';
         payprofile.IP_BusinessAddressTown__c='town city';
         payprofile.IP_BusinessAddressPostcode__c='12345678';
         payprofile.IP_PayFrequency__c='Weekly';
         payprofile.IP_PaymentType__c='BACS';
         payprofile.IP_PassToTempest__c=true;
         payprofile.IP_BankAccountName__c = 'Test name1';
         payprofile.IP_AccountNumber__c = '98567497';
         payprofile.IP_SortCode__c = '645362';
         
         insert payprofile; 
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(client.Id, candidate.Id, 1)[0];
        Insert pac;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0]; 
        Insert sector;
        
        sirenum__Job_Type__c jobType =TestDataFactory.createJobType(sector.id, 1)[0];
        Insert jobType;
        
        sirenum__Team__c jrole = TestDataFactory.createJobRole(pac.Id, jobType.Id, 1)[0]; 
        Insert jrole;
        
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
      User usr = TestDataFactory.createUsers(p.Id,1)[0];
      usr.username = 'nbsnkh.loi@bvc.com';
        insert usr; 
        
                IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        insert tpz;    
        
        sirenum__Site__c ssite = TestDataFactory.createSites(client.id,tpz.id,1)[0];
        insert ssite;
        
        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr.Id, 1)[0];
         splace.IP_PayMethod__c = payprofile.id;
        splace.sirenum__Site__c  = ssite.id;
        Insert splace;
        
         
        sirenum__Shift__c shft = TestDataFactory.createShift(splace.id, ssite.id,1)[0]; 
       insert shft;  
        
        
         sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        sts.sirenum__Week_Ending__c = date.newInstance(2017, 12, 31);
        Insert sts;
      
        sirenum__Timesheet_Line__c stsl = TestDataFactory.createTimeSheetLine(sts.Id,shft.id,1)[0]; 
      //  stsl.IP_RateCodes__c = 'DB';
        Insert stsl;
    }
    
    static testMethod void testDoGetModified() 
    {        
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/StandardAssignment/branchCode/1069';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        StandardAssignmentRest.ResponseClass results = StandardAssignmentRest.doGet();       
        System.assertEquals('true', results.success);  
        System.assertEquals('Query executed successfully.', results.message);  
        test.stopTest();
        
    }   
    
    static testMethod void testDoGet() 
    {
        test.startTest(); 
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/DateSetAssignment/branchCode/1069/date/2017-05-21T00d00d00';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        DateSetAssignmentRest.ResponseClass results = DateSetAssignmentRest.doGet();       
        System.assertEquals('true', results.success);  
        System.assertEquals('Query executed successfully.', results.message);  
        test.stopTest();
    }
    
}