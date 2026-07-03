@isTest
private class Test_InternalWorkernew {
    
     @future
    public static void createTestUser(){
      Profile p = [SELECT Id FROM Profile where name='System Administrator'];  
    User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.IP_TempestDepartment__c = '1062';
        usr.username = 'nbjudui453@mko.com';
        usr.Brand__c = 'MGG';
        usr.IsActive = true;
        //usr.ContactId= candidateId;
        insert usr;
    }
    
    @testsetup
    static void createWorker()
    {          
        //createTestUser();
         Test.startTest();
        User usr = [SELECT Id,Name FROM User WHERE Profile.name='System Administrator' and isactive=true limit 1];
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Customer Community User%' Limit 1];
       System.runAs(usr){
            
           Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert client;
        
        Account act = TestDataFactory.createAccounts(1)[0]; 
        insert act;
        
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
                  insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);

         Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        candidate.Firstname = 'RestCand1';
        candidate.GUID__c = 'XYZ';
           candidate.ownerid = usr.id;
    Insert candidate;
        //createTestUser(candidate.Id);
           
        //User user = TestDataFactory.createCommunityUser(candidate, portalProfile.Id);
         /*user.IP_TempestDepartment__c = '1062';
         insert user;
           candidate.OwnerId = user.id;
           update candidate;*/
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
               id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
       
       
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());      

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
        payprofile.IP_LastPassedToTempest__c = System.now();
        payprofile.IP_BankAccountName__c = 'Bank 1';
        payprofile.IP_AccountNumber__c = '89786756';
        payprofile.IP_SortCode__c = '998866';
        payprofile.IP_EmergencyPull__c = TRUE;
         
         insert payprofile; 
                sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(client.Id, candidate.Id, 1)[0];
        Insert pac;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0]; 
        Insert sector;
        
        sirenum__Job_Type__c jobType =TestDataFactory.createJobType(sector.id, 1)[0];
        Insert jobType;
        
        sirenum__Team__c jrole = TestDataFactory.createJobRole(pac.Id, jobType.Id, 1)[0]; 
        Insert jrole;
        
        
      /*User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.IP_TempestDepartment__c = '1062';
        usr.username = 'nbjudui453@mko.com';
        insert usr; */
          IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        insert tpz;    
        
        sirenum__Site__c ssite = TestDataFactory.createSites(act.id, tpz.id,1)[0];
        ssite.IP_PassClientToTempest__c = false;
    ssite.IP_PassClientAddressToTempest__c=false;
        insert ssite;
        
        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr.Id, 1)[0]; 
        splace.sirenum__site__C = ssite.id;
        splace.IP_PassToTempest__c = FALSE;
        Insert splace;
        
      
        Test.StopTest();
        sirenum__Shift__c shft = TestDataFactory.createShift(splace.id, ssite.id,1)[0]; 
            shft.sirenum__Contact__c = candidate.Id;
    insert shft;  
        
        
         sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        sts.IP_DuplicateCheckPassOK__c = TRUE;
        sts.sirenum__Week_Ending__c = Date.newInstance(2018, 02, 01);
        
        Insert sts;
      
        sirenum__Timesheet_Line__c stsl = TestDataFactory.createTimeSheetLine(sts.Id,shft.id,1)[0]; 
        stsl.IP_POErrorLogField__c = 'TestValue';
        Insert stsl;
         
           
        }
    }
    static testMethod void testDoGet() 
    {        
        test.startTest();
        User usr = [SELECT Id,Name,IP_TempestDepartment__c FROM User WHERE Profile.name='System Administrator' and isactive=true limit 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'InternalworkerRest', Limit__c = '20');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/standard/v1/collect/internalworker/'+usr.IP_TempestDepartment__c+'/XYZ';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        IP_PayProfile__c pp = [select id,IP_PassToTempest__c,IP_Candidate__r.IP_TempestDepartment__c,IP_Candidate__r.RecordType.DeveloperName,IP_GUID__c,IP_LastPassedToTempest__c from 
                              IP_PayProfile__c];
        System.debug('pp:::'+JSON.serialize(pp));
        InternalWorkerRest.ResponseClass results = InternalWorkerRest.doGet();       
        System.assertEquals('false', results.success);  
        System.assertEquals('Error in querying records', results.message);  
        test.stopTest();        
    }   
     static testMethod void testDoGet1() 
    {        
        test.startTest();
        User usr = [SELECT Id,Name,IP_TempestDepartment__c FROM User WHERE Profile.name='System Administrator' and isactive=true limit 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'InternalworkeremergencyRest', Limit__c = '20');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/collect/internalworker/'+usr.IP_TempestDepartment__c+'/XYABCZ';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        InternalWorkerEmergencyrest.ResponseClass results = InternalWorkerEmergencyrest.doGet();       
        System.assertEquals('false', results.success);  
        System.assertEquals('Error in querying records', results.message); 
        //System.assertEquals('Query executed successfully.', results.message);  
        test.stopTest();        
    } 
   /* static testMethod void testDoGetModifiedNegative() 
    {
        
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/StandardInternalWorker/branchCode/1066';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            StandardInternalWorkerRest.ResponseClass results = StandardInternalWorkerRest.doGet();       
            System.assertEquals('true', results.success);  
        
    }  */ 
 }