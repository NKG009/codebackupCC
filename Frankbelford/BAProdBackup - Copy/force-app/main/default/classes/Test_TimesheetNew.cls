@isTest
Private class Test_TimesheetNew {
    
    @future
    /*public  static void createTestUser(){
      Profile p = [SELECT Id FROM Profile where name='System Administrator'];  
    User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.IP_TempestDepartment__c = '1062';
        usr.username = 'TestAdminUser@gmail.com';
        usr.Brand__c = 'MGG';
        usr.IsActive = true;
        usr.IP_PassToTempest__c = true;
        usr.IP_LastPassedToTempest__c=system.today().addDays(-2);
        insert usr;
    }*/
    
    @testsetup
    static void createWorker()
    {      
        
        insert new Impellam_Settings__c (Name='DefaultNIPercentage',IP_DefaultNIPercentage__c=10) ;
        Profile clientProfile = [SELECT Id,Name FROM Profile WHERE Name='Client Portal User' limit 1];
        Profile userPortalProf = [SELECT Id,Name FROM Profile WHERE Name='User Portal' limit 1];
        insert new List<User_Profile_Id__c> {
            new User_Profile_Id__c(Name = 'Client Portal User', Profile_Id__c = userPortalProf.Id),
            new User_Profile_Id__c(Name = 'User Portal', Profile_Id__c = clientProfile.Id)
		};
        //createTestUser();
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];  
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.IP_TempestDepartment__c = '1062';
        usr.username = 'testdummyusertimesheetnew@yahoo.com';
        usr.Brand__c = 'MGG';
        usr.IsActive = true;
        usr.IP_PassToTempest__c = true;
        usr.IP_LastPassedToTempest__c=system.today().addDays(-2);
        Test.startTest();
        insert usr;
        
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Customer Community User%' Limit 1];
       System.runAs(usr){
            
           Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert client;
        
        Account act = TestDataFactory.createAccounts(1)[0]; 
        act.IP_InvoicingMethod__c = 'Hourly Percentage';
        act.IP_PostAWRWTRValue__c=10;
        act.IP_PreAWRWTRValue__c=12;
        insert act;
           
        
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
                  insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);

         Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        candidate.Firstname = 'RestCand1';
        candidate.GUID__c = 'XYZ';
           candidate.ownerid = usr.id;
    	Insert candidate;
           
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
        
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        insert tpz;    
        
        sirenum__Site__c ssite = TestDataFactory.createSites(act.id, tpz.id,1)[0];
        ssite.IP_PassClientToTempest__c = true;
        ssite.IP_PassClientAddressToTempest__c=true;
        ssite.IP_ClientLastPassedToTempest__c = System.today();
        ssite.IP_ClientAddressLastPassedToTempest__c=System.today();
        ssite.IP_PreAWRWTRValue__c=20;
        insert ssite;
        
        
        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id,null,jrole.Id,usr.Id, 1)[0];//pac.Id, jrole.Id,usr.Id, 1)[0]; 
        splace.sirenum__site__C = ssite.id;
        splace.IP_PassToTempest__c = true;
        splace.IP_EmergencyPull__c=true;
        splace.IP_LastPassedToTempest__c = System.today();
        Test.StopTest();
        
        Insert splace;
        
      
        
        sirenum__Shift__c shft = TestDataFactory.createShift(splace.id, ssite.id,1)[0]; 
            shft.sirenum__Contact__c = candidate.Id;
    insert shft;  
        
        
        /* sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        sts.IP_DuplicateCheckPassOK__c = TRUE;
        sts.sirenum__Week_Ending__c = System.today().addDays(-2);
        //Test.StopTest();
        Insert sts;
      
        sirenum__Timesheet_Line__c stsl = TestDataFactory.createTimeSheetLine(sts.Id,shft.id,1)[0]; 
        stsl.IP_POErrorLogField__c = 'TestValue';
        stsl.IP_PassToTempest__c =true;
        stsl.IP_RateCodes__c='Standard Hours /P1';
        stsl.sirenum__Code__c='P1';
        stsl.sirenum__Hours__c = 2;
        stsl.IP_SplitTimesheetLine__c=true;
        stsl.IP_InvokeTrigger__c = false;
        Insert stsl;*/
         
           
        }
    }
    static testMethod void testDoGet() 
    {        
        //test.startTest();
        Profile clientProfile = [SELECT Id,Name FROM Profile WHERE Name='Client Portal User' limit 1];
        Profile userPortalProf = [SELECT Id,Name FROM Profile WHERE Name='User Portal' limit 1];
        insert new User_Profile_Id__c(Name = 'User Portal', Profile_Id__c = userPortalProf.Id);
        insert new Impellam_Settings__c (Name='DefaultNIPercentage',IP_DefaultNIPercentage__c=10) ;
        User usr = [SELECT Id,Name FROM User WHERE Profile.name='System Administrator' and isactive=true limit 1];
        usr.Brand__c='MGG';
        usr.IP_TempestDepartment__c='1062';
        update usr;
        
        System.runAs(usr){
            
         sirenum__Shift__c shift = [SELECT sirenum__Contact__c,sirenum__Contact__r.AccountId FROM sirenum__Shift__c LIMIT 1];
         sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(shift.sirenum__Contact__r.AccountId, shift.sirenum__Contact__c,1)[0]; 
        sts.IP_DuplicateCheckPassOK__c = TRUE;
        sts.sirenum__Week_Ending__c = System.today().addDays(-2);
        Test.StartTest();
        Insert sts;
      
        sirenum__Timesheet_Line__c stsl = TestDataFactory.createTimeSheetLine(sts.Id,shift.id,1)[0]; 
        stsl.IP_POErrorLogField__c = 'TestValue';
        stsl.IP_PassToTempest__c =true;
        stsl.IP_RateCodes__c='Standard Hours /P1';
        stsl.sirenum__Code__c='P1';
        stsl.sirenum__Hours__c = 2;
        stsl.IP_SplitTimesheetLine__c=true;
        stsl.IP_InvokeTrigger__c = false;
        Insert stsl;
        
        sirenum__Timesheet__c ts = [SELECT Id FROM sirenum__Timesheet__c LIMIT 1];
        ts.IP_EmergencyPull__c=true;
        update ts;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'TimesheetRest', Limit__c = '20');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/collect/timesheet/'+usr.IP_TempestDepartment__c+'/XYZ';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        List<sirenum__Timesheet_Line__c> tsline = [select id,sirenum__Timesheet__c, name,IP_TempestDepartment__c,IP_PassToTempest__c,sirenum__shift__c,IP_SplitTimesheetLine__c,IP_HoldTimeSheetLine__c,IP_RateCodes__c,IP_PayrollPresentedRateCode__c
                                                   from sirenum__Timesheet_Line__c];
       System.debug('tsline :::'+tsline);
         sirenum__Timesheet__c tsdata=[SELECT Id,sirenum__Week_Ending__c,IP_CountSplitTimesheetLines__c,sirenum__Lines__c,IP_CountAdHocTSLinesExcluding5Line__c,IP_EmergencyPull__c,IP_DuplicateCheckPassOK__c
                                        FROM sirenum__Timesheet__c 
                                       WHERE Id = :tsline[0].sirenum__Timesheet__c];
         System.debug('tsdata:::'+tsdata);
        TimesheetRest.ResponseClass results = TimesheetRest.doGet();          
        test.stopTest();        
        }
    }   
    
    static testMethod void testErrorTSRest() 
    {        
        //test.startTest();
        Profile clientProfile = [SELECT Id,Name FROM Profile WHERE Name='Client Portal User' limit 1];
        Profile userPortalProf = [SELECT Id,Name FROM Profile WHERE Name='User Portal' limit 1];
        insert new User_Profile_Id__c(Name = 'User Portal', Profile_Id__c = userPortalProf.Id);
        insert new Impellam_Settings__c (Name='DefaultNIPercentage',IP_DefaultNIPercentage__c=10) ;
        User usr = [SELECT Id,Name FROM User WHERE Profile.name='System Administrator' and isactive=true limit 1];
        usr.Brand__c='MGG';
        usr.IP_TempestDepartment__c='1062';
        update usr;
        System.runAs(usr){
            
         sirenum__Shift__c shift = [SELECT sirenum__Contact__c,sirenum__Contact__r.AccountId FROM sirenum__Shift__c LIMIT 1];
         sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(shift.sirenum__Contact__r.AccountId, shift.sirenum__Contact__c,1)[0]; 
        sts.IP_DuplicateCheckPassOK__c = TRUE;
        sts.sirenum__Week_Ending__c = System.today().addDays(-2);
        Test.StartTest();
        Insert sts;
      
        sirenum__Timesheet_Line__c stsl = TestDataFactory.createTimeSheetLine(sts.Id,shift.id,1)[0]; 
        stsl.IP_POErrorLogField__c = 'TestValue';
        stsl.IP_PassToTempest__c =true;
        stsl.IP_RateCodes__c='Standard Hours /P1';
        stsl.sirenum__Code__c='P1';
        stsl.sirenum__Hours__c = 2;
        stsl.IP_SplitTimesheetLine__c=true;
        stsl.IP_InvokeTrigger__c = false;
        Insert stsl;
        
        sirenum__Timesheet__c ts = [SELECT Id FROM sirenum__Timesheet__c LIMIT 1];
        ts.IP_EmergencyPull__c=true;
        update ts;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'TimesheetRest', Limit__c = '20');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/collect/timesheet/'+usr.IP_TempestDepartment__c+'/Job Role,data value too large,Holiday Inn - Centre Island Development Company Ltd - Ellesmere Port - Chef de partie';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        List<sirenum__Timesheet_Line__c> tsline = [select id,sirenum__Timesheet__c, name,IP_TempestDepartment__c,IP_PassToTempest__c,sirenum__shift__c,IP_SplitTimesheetLine__c,IP_HoldTimeSheetLine__c,IP_RateCodes__c,IP_PayrollPresentedRateCode__c
                                                   from sirenum__Timesheet_Line__c];
       System.debug('tsline :::'+tsline);
         sirenum__Timesheet__c tsdata=[SELECT Id,sirenum__Week_Ending__c,IP_CountSplitTimesheetLines__c,sirenum__Lines__c,IP_CountAdHocTSLinesExcluding5Line__c,IP_EmergencyPull__c,IP_DuplicateCheckPassOK__c
                                        FROM sirenum__Timesheet__c 
                                       WHERE Id = :tsline[0].sirenum__Timesheet__c];
         System.debug('tsdata:::'+tsdata);
        TimesheetRest.ResponseClass results = TimesheetRest.doGet();          
        test.stopTest();        
        }
    } 
     static testMethod void testDoGet1() 
    {     
        //insert new Impellam_Settings__c (Name='DefaultNIPercentage',IP_DefaultNIPercentage__c=10) ;
        //test.startTest();
        User usr = [SELECT Id,Name FROM User WHERE Profile.name='System Administrator' and isactive=true limit 1];
        usr.Brand__c='MGG';
        usr.IP_TempestDepartment__c='1062';
        update usr;
        System.runAs(usr){
            
            sirenum__Shift__c shift = [SELECT sirenum__Contact__c,sirenum__Contact__r.AccountId FROM sirenum__Shift__c LIMIT 1];
         sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(shift.sirenum__Contact__r.AccountId, shift.sirenum__Contact__c,1)[0]; 
        sts.IP_DuplicateCheckPassOK__c = TRUE;
        sts.sirenum__Week_Ending__c = System.today().addDays(-2);
        Test.StartTest();
        Insert sts;
      
        sirenum__Timesheet_Line__c stsl = TestDataFactory.createTimeSheetLine(sts.Id,shift.id,1)[0]; 
        stsl.IP_POErrorLogField__c = 'TestValue';
        stsl.IP_PassToTempest__c =true;
        stsl.IP_RateCodes__c='Standard Hours /P1';
        stsl.sirenum__Code__c='P1';
        stsl.sirenum__Hours__c = 2;
        stsl.IP_SplitTimesheetLine__c=true;
        stsl.IP_InvokeTrigger__c = false;
        Insert stsl;
        
        sirenum__Timesheet__c ts = [SELECT Id FROM sirenum__Timesheet__c LIMIT 1];
        ts.IP_EmergencyPull__c=true;
        update ts;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'TimesheetEmergencyRest', Limit__c = '20');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/collect/timesheet/'+usr.IP_TempestDepartment__c+'/XYZ';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        List<sirenum__Timesheet_Line__c> tsline = [select id, name,IP_TempestDepartment__c,IP_PassToTempest__c,sirenum__shift__c,sirenum__Timesheet__r.sirenum__Week_Ending__c from sirenum__Timesheet_Line__c];
       System.debug('tsline :::'+tsline);
        TimesheetEmergencyRest.ResponseClass results = TimesheetEmergencyRest.doGet();          
        test.stopTest();  
    
  }
    }
    
    static testMethod void testErrorTSEmergencyRest() 
    {        
        //test.startTest();
        Profile clientProfile = [SELECT Id,Name FROM Profile WHERE Name='Client Portal User' limit 1];
        Profile userPortalProf = [SELECT Id,Name FROM Profile WHERE Name='User Portal' limit 1];
        insert new User_Profile_Id__c(Name = 'User Portal', Profile_Id__c = userPortalProf.Id);
        insert new Impellam_Settings__c (Name='DefaultNIPercentage',IP_DefaultNIPercentage__c=10) ;
        User usr = [SELECT Id,Name FROM User WHERE Profile.name='System Administrator' and isactive=true limit 1];
        usr.Brand__c='MGG';
        usr.IP_TempestDepartment__c='1062';
        update usr;
        System.runAs(usr){
            
            sirenum__Shift__c shift = [SELECT sirenum__Contact__c,sirenum__Contact__r.AccountId FROM sirenum__Shift__c LIMIT 1];
         sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(shift.sirenum__Contact__r.AccountId, shift.sirenum__Contact__c,1)[0]; 
        sts.IP_DuplicateCheckPassOK__c = TRUE;
        sts.sirenum__Week_Ending__c = System.today().addDays(-2);
        Test.StartTest();
        Insert sts;
      
        sirenum__Timesheet_Line__c stsl = TestDataFactory.createTimeSheetLine(sts.Id,shift.id,1)[0]; 
        stsl.IP_POErrorLogField__c = 'TestValue';
        stsl.IP_PassToTempest__c =true;
        stsl.IP_RateCodes__c='Standard Hours /P1';
        stsl.sirenum__Code__c='P1';
        stsl.sirenum__Hours__c = 2;
        stsl.IP_SplitTimesheetLine__c=true;
        stsl.IP_InvokeTrigger__c = false;
        Insert stsl;
        
        sirenum__Timesheet__c ts = [SELECT Id FROM sirenum__Timesheet__c LIMIT 1];
        ts.IP_EmergencyPull__c=true;
        update ts;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'TimesheetEmergencyRest', Limit__c = '20');
        insert set1;
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/emergency/v1/collect/timesheet/'+usr.IP_TempestDepartment__c+'/Job Role,data value too large,Holiday Inn - Centre Island Development Company Ltd - Ellesmere Port - Chef de partie';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        List<sirenum__Timesheet_Line__c> tsline = [select id,sirenum__Timesheet__c, name,IP_TempestDepartment__c,IP_PassToTempest__c,sirenum__shift__c,IP_SplitTimesheetLine__c,IP_HoldTimeSheetLine__c,IP_RateCodes__c,IP_PayrollPresentedRateCode__c
                                                   from sirenum__Timesheet_Line__c];
       System.debug('tsline :::'+tsline);
         sirenum__Timesheet__c tsdata=[SELECT Id,sirenum__Week_Ending__c,IP_CountSplitTimesheetLines__c,sirenum__Lines__c,IP_CountAdHocTSLinesExcluding5Line__c,IP_EmergencyPull__c,IP_DuplicateCheckPassOK__c
                                        FROM sirenum__Timesheet__c 
                                       WHERE Id = :tsline[0].sirenum__Timesheet__c];
         System.debug('tsdata:::'+tsdata);
        TimesheetEmergencyRest.ResponseClass results = TimesheetEmergencyRest.doGet();          
        test.stopTest();        
        }
    } 
}