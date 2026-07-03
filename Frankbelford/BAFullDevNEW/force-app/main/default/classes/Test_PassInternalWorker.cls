@isTest
public class Test_PassInternalWorker {
    @testSetup static void setupTestData() {
        insert new User_Profile_Id__c(
            Name = 'User Portal',
            Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal'].Id
        );

        insert new IP_CompanyCode__c(name = 'CompanyCode', IP_CompanyCodeValue__c = 'BAL');

        insert new IP_Shift_Template__c(name = '1181', Email__c = 'test@test.com');
        
        insert new IP_Parallel_Payroll_Check__c(name = 'RunParallelCheck', Run_Parallel_Payroll__c = false); 
        IP_BranchStatus__c b  = new IP_BranchStatus__c();
        b.IP_BranchID__c = '1181';
        b.Name = 'Test';
        insert b;

        RecordType rtacc = [Select id from RecordType where developername='Candidate' and SobjectType='Account'];
        RecordType rtcon = [Select id from RecordType where developername='Candidate' and SobjectType='Contact'];
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc1;
        
        Account a = new Account();
        a.name='Candidates';
        a.RecordTypeId=rtacc.Id;
        insert a;
        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
        
        Profile p1 = [SELECT Id,name FROM Profile where name='User Portal'];
        User usr1 = new User(LastName = 'himanshu',FirstName='JASON',Alias = 'jliv1',Email = 'mm1.sf@outlook.com',
                             Username = 'dummyEmail989'+'@email.com', ProfileId = p1.Id, TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',IP_TempestDepartment__c='1181',
                             Brand__c = 'Blue Arrow',IP_TempestDivision__c='NTS',Department='1181',IP_PassToTempest__c=true);
        insert usr1;
        
        Contact c = new Contact();
        c.LastName='contacttest';
        c.IP_CategoryOfWork__c='Catering';
        c.RecordTypeId=rtcon.id;
        c.FirstName='test';
        c.AccountId=a.Id;
        c.MailingCity = 'UP';
        c.P45_Suppression_Reason__c = 'Not Suppressed';
        c.OwnerId = usr1.Id;
        c.sirenum__National_Insurance__c = 'AA323232A';
        c.Birthdate = Date.newInstance(1989, 10, 10);
        c.EEO_Gender__c = 'Female';
        c.PPE_Type__c = 'Polo shirt';
        insert c;
        
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];        
        Contact maincon = new Contact(
            RecordTypeId = maincondRec.id,
            FirstName = 'Test',
            LastName = 'Main COntact',
            PPE_Type__c = 'Polo shirt',
            AccountID = acc1.id
        );
        insert maincon;
        
        IP_PayProfile__c payprofile = new IP_PayProfile__c();
        payprofile.RecordTypeId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();        
        payprofile.IP_Candidate__c = c.id;
        payprofile.IP_CompanyName__c='sfdc';
        payprofile.IP_Status__c = 'Active'; 
        payprofile.IP_CompanyRegNo__c  = 'ad123456';
        payprofile.IP_VATNumber__c     = '123456789';
        payprofile.IP_PayrollID__c  = 'testpay1';
        payprofile.IP_VATRegistered__c=true;
        payprofile.IP_OkToSupply__c=1;
        payprofile.IP_BuildingSocietyNumber__c='23123';
        payprofile.IP_BusinessAddressLine1__c='test address 1';
        payprofile.IP_BusinessAddressLine2__c='test address 2';
        payprofile.IP_BusinessAddressTown__c='town city';
        payprofile.IP_BusinessAddressPostcode__c='12345678';
        payprofile.IP_PayFrequency__c='Weekly';
        payprofile.IP_PaymentType__c='BACS';
        payprofile.IP_BankAccountName__c = 'testname';
        payprofile.IP_AccountNumber__c = '98958987';
        payprofile.IP_SortCode__c = '887788';
        payprofile.P45_Requested__c = true;
        payprofile.IP_Payroll_Leaver__c = null;
        payprofile.IP_NewStarterTaxStatus__c = 'A';
        insert payprofile;
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(a.Id, c.Id, 1)[0];
        insert pac;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0]; 
        insert sector;
        
        sirenum__Job_Type__c jobType =TestDataFactory.createJobType(sector.id, 1)[0];
        jobtype.Impellam_Core_Category__c = 'Administration -ADM';
        jobtype.Impellam_Job_Category__c ='Data Entry -OA002';
        insert jobType;
        
        sirenum__Team__c jrole = TestDataFactory.createJobRole(pac.Id, jobType.Id, 1)[0]; 
        insert jrole;
        
        IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
        topaz.IP_PaymentTerms__c = 123456789123456.0;
        insert topaz;
        
        sirenum__Site__c site = new sirenum__Site__c();         
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc1.id;
        site.IP_ClientIDLegacy__c='123';
        site.IP_ClientInvoiceName__c = 'test abc';
        site.IP_PublicSector__c = 'No';
        site.IP_InvoiceContactText__c = 'Contact 1';
        site.IP_PassClientToTempest__c = true;
        site.IP_PassClientAddressToTempest__c = true;
        insert site;

        sirenum__Placement__c splace1 = TestDataFactory.createSPlacement1(c.Id, pac.Id,jrole.Id,usr1.Id, 1)[0]; 
        splace1.sirenum__Site__c = site.id;
        insert splace1;
        
        Test.startTest();
        sirenum__Shift__c shft1 = TestDataFactory.createShift(splace1.Id,site.id,1)[0]; 
        shft1.sirenum__Contact__c = c.id;
        shft1.sirenum__Scheduled_Start_Time__c = System.now();
        shft1.sirenum__Scheduled_End_Time__c = System.now().addHours(2);
        insert shft1;
        
        sirenum__Timesheet__c timesheet = new sirenum__Timesheet__c();
        timesheet.sirenum__Worker__c=c.id;
        timesheet.sirenum__Week_Ending__c=system.today();
        timesheet.sirenum__Non_Taxed_Expenses__c=10.2;
        timesheet.sirenum__Taxed_Expenses__c=20.1;
        timesheet.sirenum__Non_Taxed_Deductions__c=10.5;
        timesheet.sirenum__Taxed_Deductions__c=5.2;
        insert timesheet;
        
        
        List<sirenum__Timesheet_Line__c> tsl =  TestDataFactory.createTimeSheetLine(timesheet.Id, shft1.id, 1) ;
        insert tsl;
        Test.stopTest();
        
        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
        ob.IP_OriginRecordID__c = payprofile.Id;
        ob.IP_TimesheetID__c = timesheet.Id;
        ob.IP_Passed__c = null;
        insert ob;
    }

    static testmethod void validatePassPayrollFunctionality_TestCase_One() {
        Test.startTest();

        IP_PayProfile__c thePayProfile = [SELECT IP_TimesheetIDLink__c, IP_PassToTempest__c, IP_FirstPass__c, IP_LastPassedToTempest__c FROM IP_PayProfile__c LIMIT 1];
        thePayProfile.IP_TimesheetIDLink__c = [SELECT Id FROM sirenum__Timesheet__c LIMIT 1].Id;
        thePayProfile.IP_PassToTempest__c = true;
        thePayProfile.IP_LastPassedToTempest__c = null;
        thePayProfile.IP_FirstPass__c = true;
        thePayProfile.IP_EmergencyPull__c = false;
        update thePayProfile;

        Test.stopTest();
    }

    static testmethod void validatePassPayrollFunctionality_TestCase_Two() {
        Test.startTest();

        IP_PayProfile__c thePayProfile = [SELECT IP_TimesheetIDLink__c, IP_PassToTempest__c, IP_FirstPass__c, IP_LastPassedToTempest__c FROM IP_PayProfile__c LIMIT 1];
        thePayProfile.IP_TimesheetIDLink__c = null;
        thePayProfile.IP_PassToTempest__c = true;
        thePayProfile.IP_LastPassedToTempest__c = DateTime.now();
        thePayProfile.IP_FirstPass__c = false;
        thePayProfile.IP_EmergencyPull__c = false;
        update thePayProfile;

        Test.stopTest();
    }

    static testmethod void validatePassEmergencyFunctionality_TestCase_One() {
        insert new IP_Parallel_Payroll_Check__c(Name = 'RunParallelCheck', Run_Parallel_Payroll__c = true);

        Test.startTest();

        IP_PayProfile__c thePayProfile = [SELECT IP_TimesheetIDLink__c, IP_PassToTempest__c, IP_LastPassedToTempest__c, IP_FirstPass__c, IP_EmergencyPull__c
                                          FROM IP_PayProfile__c LIMIT 1];
        thePayProfile.IP_TimesheetIDLink__c = [SELECT Id FROM sirenum__Timesheet__c LIMIT 1].Id;
        thePayProfile.IP_PassToTempest__c = true;
        thePayProfile.IP_LastPassedToTempest__c = DateTime.now();
        thePayProfile.IP_FirstPass__c = false;
        thePayProfile.IP_EmergencyPull__c = true;
        thePayProfile.IP_PaymentType__c = 'BACS';
        thePayProfile.IP_BankAccountName__c = '1234567890';
        update thePayProfile;

        Test.stopTest();
    }


    static testmethod void validatePassEmergencyFunctionality_TestCase_Two() {
        Test.startTest();

        delete [SELECT Id FROM IP_OutboundDataTransfer__c];

        insert new IP_Parallel_Payroll_Check__c(Name = 'RunParallelCheck', Run_Parallel_Payroll__c = true);

        IP_PayProfile__c thePayProfile = [SELECT IP_TimesheetIDLink__c, IP_PassToTempest__c, IP_LastPassedToTempest__c, IP_FirstPass__c, IP_EmergencyPull__c
                                          FROM IP_PayProfile__c LIMIT 1];        
        thePayProfile.IP_TimesheetIDLink__c = [SELECT Id FROM sirenum__Timesheet__c LIMIT 1].Id;
        thePayProfile.IP_PassToTempest__c = true;
        thePayProfile.IP_LastPassedToTempest__c = DateTime.now();
        thePayProfile.IP_FirstPass__c = false;
        thePayProfile.IP_EmergencyPull__c = true;
        thePayProfile.IP_PaymentType__c = 'BACS';
        thePayProfile.IP_BankAccountName__c = '1234567890';
        update thePayProfile;

        Test.stopTest();
    }
}