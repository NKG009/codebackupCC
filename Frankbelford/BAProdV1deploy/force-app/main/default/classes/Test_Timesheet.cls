@isTest
Private class Test_Timesheet {
    
    @testsetup
    Static void createTimesheetData()
    {
        Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert client;
        
        Account act = TestDataFactory.createAccounts(1)[0]; 
        insert act;
        //Contact cont = TestDataFactory.createCandidate(client.id, 1)[0];
        //Insert cont;
                insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);

        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
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
         payprofile.IP_PayrollID__c  = 'testpay1';
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
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(act.Id, candidate.Id, 1)[0];
        Insert pac;
        system.debug('@@@@ContractRecord'+pac);
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0]; 
        Insert sector;
        
        sirenum__Job_Type__c jobType =TestDataFactory.createJobType(sector.id, 1)[0];
        Insert jobType;
        
        sirenum__Team__c jrole = TestDataFactory.createJobRole(pac.Id, jobType.Id, 1)[0]; 
        Insert jrole;
        
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'acfgd.test@test.com';
        insert usr; 
                IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        insert tpz;    
        
        sirenum__Site__c ssite = TestDataFactory.createSites(act.id, tpz.id,1)[0];
        insert ssite;
         system.debug('@@@@SiteRecord'+ssite);
        
        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr.Id, 1)[0];
         splace.IP_PayMethod__c = payprofile.id;
        splace.sirenum__site__c = ssite.id ;
        Insert splace;      

        
        sirenum__Shift__c shft = TestDataFactory.createShift(splace.id, ssite.id,1)[0]; 
        shft.sirenum__Team__c = jrole.id;
        insert shft;  
        
        
        sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
         sts.sirenum__Week_Ending__c = date.newInstance(2017, 12, 31);
        Insert sts;
            
        sirenum__Timesheet_Line__c stsl = TestDataFactory.createTimeSheetLine(sts.Id,shft.id,1)[0]; 
    //    stsl.IP_RateCodes__c = 'AB';
        Insert stsl;
                
    }
    
    Static testmethod void  method1(){
        System.runAs(new user(ID = UserInfo.getUserID())) 
        {
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/StandardTimesheet/branchCode/1069';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            StandardTimesheetRest.ResponseClass results = StandardTimesheetRest.doGet();       
            System.assertEquals('true', results.success);  
            System.assertEquals('Query executed successfully.', results.message);  
        }
    }
    Static testmethod void  method2(){
        System.runAs(new user(ID = UserInfo.getUserID()))
        {
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/DateSetTimesheet/branchCode/1069/date/2017-05-21T00d00d00';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            DateSetTimesheetRest.ResponseClass results = DateSetTimesheetRest.doGet();       
            System.assertEquals('true', results.success);  
            System.assertEquals('Query executed successfully.', results.message); 
            //delete stsl;
        }
    }
}