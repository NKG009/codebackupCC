@isTest
Private class TestQueableTimeSheetLine {
    
    /*@future
    public  static void createTestUser(){
      Profile p = [SELECT Id FROM Profile where name='System Administrator'];  
    User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.IP_TempestDepartment__c = '1062';
        usr.username = 'TestAdminUser@gmail.com';
        usr.Brand__c = 'MGG';
        usr.IsActive = true;
        usr.IP_PassToTempest__c = true;
        usr.IP_LastPassedToTempest__c=system.today().addDays(-2);
        //usr.ContactId= candidateId;
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
        Test.startTest();
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.IP_TempestDepartment__c = '1062';
        usr.username = 'dummyuserqueuetimesheet@yahoo.com';
        usr.Brand__c = 'MGG';
        usr.IsActive = true;
        usr.IP_PassToTempest__c = true;
        usr.IP_LastPassedToTempest__c=system.today().addDays(-2);
        insert usr;
         
        
        //User usr = [SELECT Id,Name FROM User WHERE Profile.name='System Administrator' and isactive=true limit 1];
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Customer Community User%' Limit 1];
       System.runAs(usr){
            
           Account client = TestDataFactory.createCandidateAccount(1)[0];
           client.IP_InvoicingMethod__c = 'Hourly Percentage';
           client.IP_PostAWRWTRValue__c=10;
        client.IP_PreAWRWTRValue__c=12;
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
        //jrole.IP_Fixed__c=20;
        jrole.IP_PercentageCharge__c=20;
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
        
        /*sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr.Id, 1)[0]; 
        splace.sirenum__site__C = ssite.id;
        splace.IP_PassToTempest__c = true;
        splace.IP_EmergencyPull__c=true;
        splace.IP_LastPassedToTempest__c = System.today();
        Test.StopTest();
        Insert splace;*/
        
        insert new sirenum__AWR_Settings__c (SetupOwnerId= usr.id,sirenum__Weeks_Required__c=12,sirenum__Holiday_Allowance__c=6);
        sirenum__AWR__c awr= new sirenum__AWR__c(); 
        awr.Name='AWR1';
        awr.sirenum__Contact__c=candidate.id;
        awr.sirenum__Client__c=client.id;
        awr.sirenum__Weeks_Worked__c=15;
        awr.sirenum__End_Date__c=system.today().addDays(-2);
        awr.sirenum__Valid_Until__c=system.today()+2;
        awr.sirenum__AWR_Group__c='Group 2';
        awr.sirenum__Last_Shift_Date__c = System.today().addDays(-2);
        awr.sirenum__Start_Date__c = System.today().addDays(-2);
        
        insert awr;
        
        sirenum__Shift__c shft = TestDataFactory.createShift(null, ssite.id,1)[0]; 
            shft.sirenum__Contact__c = candidate.Id;
    insert shft;  
        
        
         sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        sts.IP_DuplicateCheckPassOK__c = TRUE;
        //sts.IP_EmergencyPull__c = true;
        sts.sirenum__Week_Ending__c = System.today().addDays(-2);
        //sts.sirenum__Worker__c=
        Insert sts;
      
        sirenum__Timesheet_Line__c stsl = TestDataFactory.createTimeSheetLine(sts.Id,shft.id,1)[0]; 
        stsl.IP_POErrorLogField__c = 'TestValue';
        stsl.IP_PassToTempest__c =true;
        stsl.IP_RateCodes__c='Standard Hours /P1';
        stsl.sirenum__Code__c='P1';
        stsl.sirenum__Hours__c = 2;
        stsl.IP_SplitTimesheetLine__c=false;
        stsl.Adhoc__c='N';
        stsl.IP_InvokeTrigger__c = false;
        //stsl.IP_HoldTimeSheetLine__c = false;
        Insert stsl;
         
           
        }
    }
    static testMethod void testDoGet() 
    {   Test.startTest();
        sirenum__Timesheet_Line__c tsl=[SELECT Id,sirenum__Timesheet__r.sirenum__Worker__c,sirenum__Timesheet__r.sirenum__Team__c from sirenum__Timesheet_Line__c limit 1];
        Test.stopTest();
        System.enqueueJob(new QueableSplitTimesheetLine(new Set<Id>{tsl.Id}));
        //Test.stopTest();
    }  
    static testMethod void testErrorBlock(){
        //sirenum__Timesheet_Line__c tsl=[SELECT Id,sirenum__Timesheet__r.sirenum__Worker__c,sirenum__Timesheet__r.sirenum__Team__c from sirenum__Timesheet_Line__c limit 1];
        User usr=[select id from user where profile.name='System Administrator' and username='dummyuserqueuetimesheet@yahoo.com' limit 1];
        system.runas(usr){
        
        sirenum__Timesheet__c ts = [SELECT Id,sirenum__Site__c,sirenum__Team__c,sirenum__Worker__c FROM sirenum__Timesheet__c LIMIT 1];
        sirenum__Shift__c shft = [SELECT Id FROM sirenum__Shift__c LIMIT 1];
        sirenum__PayrollCostMatrixFrame__c payrollCost = new sirenum__PayrollCostMatrixFrame__c (Name='Cost Matrix Frame 1',
                                                                     sirenum__Job_Role__c= ts.sirenum__Team__c,
                                                                     sirenum__Daily_Overtime_Threshold__c  = 8.0, 
                                                                     sirenum__Weekly_Overtime_Threshold__c = 37.5);
        Test.startTest();
        insert payrollCost;
        sirenum__PayrollCostMatrix__c costMatrix = new sirenum__PayrollCostMatrix__c(sirenum__Income_per_Hour__c=20,sirenum__Cost_per_Shift__c=20,sirenum__Cost_per_Hour__c=30,
                                                                                     sirenum__Contact__c=ts.sirenum__Worker__c,sirenum__Day_Type__c='ONE_TIME',
                                                                                    sirenum__Taxed_deduction__c=10,sirenum__Taxed_expenses__c=20,sirenum__Non_taxed_deduction__c=12,
                                                                                     sirenum__Non_taxed_expenses__c=15,sirenum__Bonus__c=12,sirenum__costMatrixFrame__c=payrollCost.id);
        insert costMatrix;
        
        //Test.startTest();
        sirenum__Timesheet_Line__c tsl1 = TestDataFactory.createTimeSheetLine(ts.Id,shft.id,1)[0]; 
        tsl1.IP_PassToTempest__c =true;
        //stsl.IP_RateCodes__c='Standard Hours /P1';
        tsl1.sirenum__Hours__c = 2;
        tsl1.IP_SplitTimesheetLine__c=false;
        tsl1.sirenum__Cost_Matrix__c=costMatrix.id;
        tsl1.For_BatchClass__c=false;
        tsl1.Adhoc__c='N';
        insert tsl1;    
            Test.stopTest();
        System.enqueueJob(new QueableSplitTimesheetLine(new Set<Id>{tsl1.Id}));
         //Test.stopTest();
        }
    }
    
     static testMethod void testErrorBlock1(){
        //sirenum__Timesheet_Line__c tsl=[SELECT Id,sirenum__Timesheet__r.sirenum__Worker__c,sirenum__Timesheet__r.sirenum__Team__c from sirenum__Timesheet_Line__c limit 1];
        User usr=[select id from user where profile.name='System Administrator' and username='dummyuserqueuetimesheet@yahoo.com' limit 1];
        system.runas(usr){
        sirenum__Timesheet__c ts = [SELECT Id,sirenum__Site__c,sirenum__Team__c,sirenum__Worker__c FROM sirenum__Timesheet__c LIMIT 1];
        sirenum__Shift__c shft = [SELECT Id FROM sirenum__Shift__c LIMIT 1];
        sirenum__PayrollCostMatrixFrame__c payrollCost = new sirenum__PayrollCostMatrixFrame__c (Name='Cost Matrix Frame 1',
                                                                     sirenum__Job_Role__c= ts.sirenum__Team__c,
                                                                     sirenum__Daily_Overtime_Threshold__c  = 8.0, 
                                                                     sirenum__Weekly_Overtime_Threshold__c = 37.5);
        insert payrollCost;
        sirenum__PayrollCostMatrix__c costMatrix = new sirenum__PayrollCostMatrix__c(sirenum__Income_per_Hour__c=20,sirenum__Cost_per_Shift__c=20,sirenum__Cost_per_Hour__c=30,
                                                                                     sirenum__Contact__c=ts.sirenum__Worker__c,sirenum__Day_Type__c='ONE_TIME',
                                                                                    sirenum__Taxed_deduction__c=10,sirenum__Taxed_expenses__c=20,sirenum__Non_taxed_deduction__c=12,
                                                                                     sirenum__Non_taxed_expenses__c=15,sirenum__Bonus__c=12,sirenum__costMatrixFrame__c=payrollCost.id);
        insert costMatrix;
        Test.startTest();
        sirenum__Timesheet_Line__c tsl1 = TestDataFactory.createTimeSheetLine(ts.Id,shft.id,1)[0]; 
        tsl1.IP_PassToTempest__c =true;
        //stsl.IP_RateCodes__c='Standard Hours /P1';
        tsl1.sirenum__Hours__c = 2;
        tsl1.IP_SplitTimesheetLine__c=false;
        tsl1.sirenum__Cost_Matrix__c=costMatrix.id;
        tsl1.For_BatchClass__c=false;
        tsl1.Adhoc__c='N';
        insert tsl1;
        ts.IP_EmergencyPull__c=true;
         update ts;
       
        System.enqueueJob(new QueableSplitTimesheetLine(new Set<Id>{tsl1.Id}));
         Test.stopTest();
        }
    }
}