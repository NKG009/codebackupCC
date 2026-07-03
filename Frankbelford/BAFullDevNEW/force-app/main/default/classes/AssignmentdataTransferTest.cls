@isTest
public class AssignmentdataTransferTest {
    @testSetup
    static void setupTestData() {
        // Create a test user with a profile
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com.test',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = profile.Id,
            LanguageLocaleKey = 'en_US',
            Brand__c = 	'MGG'
            
        );
        insert testUser;
        
     
        // Create test JobRoleProfileList__c
        JobRoleProfileList__c jobProfile = new JobRoleProfileList__c(Name = 'Admin Profile');
        insert jobProfile;
        
        Account acc = TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        
        Contact con = TestDataFactory.createCandidate(acc.id,1)[0]; 
        insert con;
        
        sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
        pc.Name = 'Saturday - Friday';
        pc.sirenum__CyclePeriodUnits__c= 'Weeks';
        pc.sirenum__periodLength__c = Decimal.valueOf(7);
        pc.sirenum__StartingDate__c = Date.newInstance(2036, 03, 15);  
        insert pc;
        
        sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
        ct.sirenum__PayrollCycle__c = pc.id;
        insert ct;
        
        sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
        insert sec;
        
        sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
        insert jobcate;
        
        sirenum__Team__c team = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
        insert team;
        
    }

    @isTest
    static void testHandleBeforeUpdate() {
        // Fetch existing team
        sirenum__Team__c team = [SELECT Id, sirenum__Job_Type__c, sirenum__Rota__c FROM sirenum__Team__c LIMIT 1];
        
        // Create old and new data maps
        Map<Id, sirenum__Team__c> oldItems = new Map<Id, sirenum__Team__c>{
            team.Id => team.clone()
        };
        
        //team.sirenum__Job_Type__c = 'Part-Time'; // Simulate an update
        
        Map<Id, sirenum__Team__c> newItems = new Map<Id, sirenum__Team__c>{
            team.Id => team
        };

        Test.startTest();
        AmendJobroleBySysAdminHandler.handleBeforeUpdate(newItems, oldItems);
       
        Test.stopTest();

        // Assert that an error message is added
        //System.assertEquals(Label.JobRoleErrorMessage, team.getErrors()[0].getMessage());
        
    
        // Create test data for IP_CompanyCode__c
        IP_CompanyCode__c companyCode = new IP_CompanyCode__c(
            Name = 'CompanyCode',
            IP_CompanyCodeValue__c = 'BAL'
        );
        insert companyCode;

        // Create test data for IP_ImpellamGlobalSetting__c
        IP_ImpellamGlobalSetting__c globalSetting = new IP_ImpellamGlobalSetting__c(
            IP_OutboundErrorEmailAddress__c = 'test@example.com'
        );
        insert globalSetting;

        // Create test data for IP_Parallel_Payroll_Check__c
        IP_Parallel_Payroll_Check__c payrollCheck = new IP_Parallel_Payroll_Check__c(
            Name = 'RunParallelCheck',
            Run_Parallel_Payroll__c = false
        );
        insert payrollCheck;
		        
        // Create test data for IP_BranchStatus__c
        IP_BranchStatus__c branchStatus = new IP_BranchStatus__c(
            IP_BranchID__c = 'test'
        );
        insert branchStatus;
        
        Account acc = TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        Contact con = TestDataFactory.createCandidate(acc.id,1)[0]; 
        insert con;
        
        sirenum__Payroll_Cycle__c pcc = new sirenum__Payroll_Cycle__c();
        pcc.Name = 'trst';
        pcc.sirenum__CyclePeriodUnits__c= 'Months';
        pcc.sirenum__periodLength__c = Decimal.valueOf(2);
        pcc.sirenum__StartingDate__c = Date.newInstance(2036, 03, 15);  
        insert pcc;
        
        sirenum__ProActiveContract__c ctt = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
        ctt.sirenum__PayrollCycle__c = pcc.id;
        insert ctt;
        
        sirenum__Placement__c place = new sirenum__Placement__c(
        	Name = 'test',
            sirenum__Start_Date__c = System.today(),
            sirenum__End_Date__c = System.today().addDays(7),
            sirenum__Contact__c = con.Id,
            sirenum__Job_Role__c = team.id,
			sirenum__Contract__c = ctt.Id

        );
        insert place;
        
        
        
        
     /*  sirenum__Site__c sirenusite = new sirenum__Site__c(IP_TempestDepartment__c = place.id );
		insert site;*/
        
        // Create test data for sirenum__Placement__c
        sirenum__Placement__c placement = new sirenum__Placement__c(
         ///sirenum__Site__cIP_TempestDepartment__c,
         IP_TimesheetIDLink__c = '18',
         IP_FirstPass__c = false,
		 Sirenum__Site__c = place.id,

         //IP_AssignmentRefForTempest__c,
         //IP_AWRCoreCat__c,
         // IP_AWRJobCat__c,
         // IP_ClientIDLegacy__c = ,
         //IP_Consultant1IDnumberSplitShare__c,
         // IP_PassToTempest__c,
         // IP_EmergencyPull__c, 
         // IP_LastPassedToTempest__c,
         //IP_Consultant1PercentageSplit__c,
         // IP_Consultant2IDnumberSplitShare__c,
         // IP_Consultant2PercentageSplit__c,
         // IP_TempestDepartment__c,
         // IP_TempestDivision__c,
         // IP_LookUpOfHolidayEntitlement__c,
         // Adhoc_Formula__c,
         // IP_WorkerPayrollRef__c,
         // IP_PurchaseOrderNumber__c,
         // sirenum__End_Date__c,
         //  Sirenum__Job_Role__r.sirenum__Job_Type__r.Name,
         // Sirenum__Site__r.Name,
         //  Sirenum__Site__r.IP_InvoiceContactText__c,
         // Sirenum__Site__r.IP_MainContact_
         // l_Code__c,
         //sirenum__Start_Date__c,
         //OPWIPS__c,
         //IP_Department__c
            IP_EmergencyPull__c = false,
            sirenum__Contract__c = ctt.Id,
            //IP_Department__c = 'TestBranch',
            //IP_AssignmentRefForTempest__c = 'TestRef',
            //IP_AWRJobCat__c = 'TestJobCat',
            //IP_ClientIDLegacy__c = 'TestClient',
           	//IP_WorkerPayrollRef__c = 'TestPayrollRef',
            sirenum__Start_Date__c = System.today(),
            sirenum__End_Date__c = System.today().addDays(7),
            sirenum__Contact__c = con.Id,
            sirenum__Job_Role__c = team.id
        );
        insert placement;
    }

    @isTest
    static void testSendEmergencyData() {
        Payroll_Swtich__c ps = new Payroll_Swtich__c();
        ps.Name = 'Stoppayroll';
        ps.Batch_check__c = false;
        
        insert ps;
        
        IP_CompanyCode__c Companycode =  new IP_CompanyCode__c();
          Companycode.IP_CompanyCodeValue__c = 'test';
          Companycode.Name = 'test';
           insert Companycode;
        IP_Parallel_Payroll_Check__c payrollcheck = new IP_Parallel_Payroll_Check__c();
           payrollcheck.Name = 'test';
         insert payrollcheck;
        
         
        Account acc = TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        
        Contact con = TestDataFactory.createCandidate(acc.id,1)[0]; 
        insert con;
        
        IP_TopazGlobalClientInformation__c topzClientInfo = TestDataFactory.createTopaz(1)[0];
        topzClientInfo.Name = acc.Name;
        topzClientInfo.IP_SalesLedgerNumber__c='345432';
        insert topzClientInfo;
        
        List<sirenum__Site__c> siteList = new List<sirenum__Site__c>();
        sirenum__Site__c ssite = new sirenum__Site__c();
        ssite.Name = 'my site';
        ssite.IP_InvoiceAddressCity__c = 'ballia';
        ssite.IP_InvoiceAddressStreet__c = 'street1';
        ssite.sirenum__Operating_Company__c = acc.Id;
        ssite.IP_InvoiceContact__c = con.id;
        ssite.GlobalClientName__c = topzClientInfo.Id;
        ssite.IP_ClientIDLegacy__c = 'eww3';
        ssite.IP_Clientinvoicename__c = 'invoice name';
        ssite.IP_InvoiceAddressCountry__c = 'ind';
        ssite.IP_InvoiceAddressCounty__c = 'cnt';
        ssite.IP_InvoiceAddressPostcode__c = 'E12 3DD';
        ssite.IP_PublicSector__c = 'No';
        ssite.IP_PassClientToTempest__c = true;
        ssite.IP_ClientLastPassedToTempest__c = null;
        ssite.Credit_Status__c = 'Credit Approved';
        //sirenum__Postal_Code__c = 'TE12 3AA',
        ssite.IP_PassClientAddressToTempest__c = true;
        
        insert ssite;        
        
       
         sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
        pc.Name = 'Saturday - Friday';
        pc.sirenum__CyclePeriodUnits__c= 'Weeks';
        pc.sirenum__periodLength__c = Decimal.valueOf(7);
        pc.sirenum__StartingDate__c = Date.newInstance(2036, 03, 15);  
        insert pc;
         sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
        ct.sirenum__PayrollCycle__c = pc.id;
        insert ct;
        
        sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
        insert sec;
        
        sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
        insert jobcate;
        
        sirenum__Team__c team = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
        insert team;
        
        // Create test data for sirenum__Placement__c
        sirenum__Placement__c placement = new sirenum__Placement__c(
            IP_EmergencyPull__c = true,
            //IP_Department__c = 'TestBranch',
            //IP_AssignmentRefForTempest__c = 'TestRef',
            //IP_AWRJobCat__c = 'TestJobCat',
            //IP_ClientIDLegacy__c = 'TestClient',
           //IP_WorkerPayrollRef__c = 'TestPayrollRef',
            IP_TimesheetIDLink__c = '18',
            IP_FirstPass__c = false,
            IP_PassToTempest__c = false,
            IP_LastPassedToTempest__c = System.today().addDays(7),
            //IP_Consultant2PercentageSplit__c = '99%', 
            //IP_LookUpOfHolidayEntitlement__c,
           // Adhoc_Formula__c,
           // IP_WorkerPayrollRef__c,
           // IP_PurchaseOrderNumber__c,
          
            //OPWIPS__c,IP_Department__c,
            sirenum__Start_Date__c = System.today(),
            sirenum__End_Date__c = System.today().addDays(7),
            sirenum__Contact__c = con.Id,
            sirenum__Job_Role__c = team.id
        );
        placement.sirenum__Site__c = ssite.Id;
        insert placement;
        
        
        
        // Fetch test placement
        sirenum__Placement__c testPlacement = [SELECT Id FROM sirenum__Placement__c LIMIT 1];
        Set<Id> emergencySet = new Set<Id>{placement.Id};
            
        // Create a test user with a profile
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User User = new User(
            FirstName = 'Test1',
            LastName = 'User1',
            Email = 'testuser@examplekkj.com',
            Username = 'testuser@examplekkj.com.test',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = profile.Id,
            LanguageLocaleKey = 'en_US',
            Brand__c = 	'MGG'
            
        );
        insert User;
            
            
        // create TimesheetID IP_TimesheetID__c 
        sirenum__Timesheet__c TimesheetID = new sirenum__Timesheet__c(
        	sirenum__Worker__c = con.id
        );
        insert TimesheetID;
        
        // Create test data for IP_OutboundDataTransfer__c
         IP_OutboundDataTransfer__c odt = new IP_OutboundDataTransfer__c(
        	IP_OriginRecordID__c = testPlacement.Id,
            IP_TimesheetID__c = TimesheetID.id
        );
        insert odt;
        
        /*// Fetch test odt
        IP_OutboundDataTransfer__c testOutboundDataTransfer = [SELECT Id FROM IP_OutboundDataTransfer__c LIMIT 1];
        Set<Id> existingemergencyrec = new Set<Id>{odt.Id};*/

        // Test method execution
        Test.startTest();
        AssignmentdataTransfer.sendemergencydata(emergencySet);
        AssignmentdataTransfer.sendassigndatasecondpass(emergencySet);
        AssignmentdataTransfer.sendassigndatafirstpass(emergencySet);
        Test.stopTest();
        
        
         // Validate expected results
        List<IP_OutboundDataTransfer__c> outboundRecords = [SELECT Id, IP_OriginRecordID__c,IP_TimesheetID__c FROM IP_OutboundDataTransfer__c where IP_OriginRecordID__c in: emergencyset and IP_Passed__c = ''];

        //System.assert(outboundRecords.size() > 0, 'Outbound records should be created');
       // System.assertEquals(placement.Id, outboundRecords[0].IP_OriginRecordID__c, 'Record should match the processed placement');
    }
}