@isTest
public class CreateTaskOnCreation_Test {
    @testSetup static void generateTestData() {
        insert new User_Profile_Id__c(
            Name = 'User Portal',
            Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal'].Id
        );

        IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
        setting.IP_LastTransmissionDate__c = Date.newInstance(2019,07,01);
        setting.IP_OutboundErrorEmailAddress__c = 'test@test.com';
        insert setting;

        Profile p1 = [SELECT Name FROM Profile WHERE Name = 'Back Office'];
        User usr1 = new User(
            LastName = 'himanshu',
            FirstName = 'JASON',
            Alias = 'jliv1',
            Email = 'mm1.sf@outlook.com',
			Username = 'dummyEmail989@email.com',
            ProfileId = p1.Id,
            TimeZoneSidKey = 'GMT',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LocaleSidKey = 'en_US',
            IP_TempestDepartment__c = '1062',
            Brand__c = 'Blue Arrow',
        	IP_TempestDivision__c = 'NTS',
            Department = '1062',
            IP_PassToTempest__c = true
        );
        insert usr1;

        IP_BranchStatus__c b = new IP_BranchStatus__c();
        b.IP_BranchID__c = '1062';
        b.Name = 'Test';
        insert b;

        insert new Payroll_Swtich__c(Name = 'Stoppayroll', Batch_check__c = false);
        insert new IP_JSToFrostSwtich__c(Name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new IP_Parallel_Payroll_Check__c(Name = 'RunParallelCheck', Run_Parallel_Payroll__c = false);

        RecordType accountRec = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Candidate'];
        RecordType accountRec1 = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Account'];
        RecordType maincondRec = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName= 'Contact'];

        Account acc1 = new Account(Name = 'Candidates', RecordTypeId = accountRec.Id);
        Account acc = new Account(Name = 'Capita', RecordTypeId = accountRec1.Id);
        insert new List<Account> { acc1, acc };

        Contact maincon = new Contact(
            RecordTypeId = maincondRec.Id,
            FirstName = 'Test',
            LastName = 'Main COntact',
            AccountID = acc.Id,
            PPE_Type__c = 'Polo shirt'
        );

        RecordType condRec = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'Candidate'];
        Contact con = new Contact(
            AccountID = acc1.Id,
            RecordTypeId = condRec.id,
            FirstName = 'Manish',
            Salutation = 'Mr',
            MailingCity = 'ggn',
            MailingCountry = 'india',
            MailingPostalCode = '110092',
            MailingState = 'Haryana',
            LastName = 'candidate',  
            sirenum__National_Insurance__c = 'AA323232A', 
            IP_CandidateIDlegacy__c = 'dsdsdsdd', 
            MailingStreet = 'abc',
            P45_Requested__c = true,
            PayrollLeaver__c = null,
            Title = 'TestLastName',
            Initials__c = 'TestLastName',
            Birthdate = Date.valueOf('1990-02-20'),
            Phone = '9879879877',
            IP_WorkerStartDate__c = Date.valueOf('2017-02-20'),
            ts2__EEO_Gender__c = 'M',
            IP_CategoryOfWork__c = 'Catering;Office',
            IP_ThirdPartyID__c = 'testpay12',
            IP_IsInvoicecontact__c = true,
            PPE_Type__c = 'Polo shirt'
		);

        insert new List<Contact> { maincon, con };
        
        Id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
        
        IP_PayProfile__c payprofile = new IP_PayProfile__c();
        payprofile.RecordTypeId = payRTId;
        payprofile.IP_Candidate__c = con.id;
        payprofile.IP_CompanyName__c = 'sfdc';
        payprofile.IP_Status__c = 'Active'; 
        payprofile.IP_CompanyRegNo__c = 'ad123456';
        payprofile.IP_VATNumber__c = '123456789';
        payprofile.IP_PayrollID__c = 'testpay1';
        payprofile.IP_VATRegistered__c = true;
        payprofile.IP_OkToSupply__c = 1;
        payprofile.IP_BuildingSocietyNumber__c = '23123';
        payprofile.IP_BusinessAddressLine1__c = 'test address 1';
        payprofile.IP_BusinessAddressLine2__c = 'test address 2';
        payprofile.IP_BusinessAddressTown__c = 'town city';
        payprofile.IP_BusinessAddressPostcode__c = '12345678';
        payprofile.IP_PayFrequency__c = 'Weekly';
        payprofile.IP_PaymentType__c = 'BACS';
        payprofile.IP_BankAccountName__c = 'testname';
        payprofile.IP_AccountNumber__c = '98958987';
        payprofile.IP_SortCode__c = '887788';
        payprofile.IP_MissingPayrollDetail__c = '';
        insert payprofile;
        
        IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name = 'Test global topaz';
        globalclient.IP_StatusID__c = 2;
        globalclient.IP_SalesLedgerNumber__c = '123';
        insert globalclient;
        
        sirenum__Site__c site = new sirenum__Site__c();
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c = acc.id;
        site.IP_ClientIDLegacy__c = '123';
        site.GlobalClientName__c = globalclient.id;
        site.IP_ClientInvoiceName__c = 'Testclient';
        site.IP_InvoiceAddressStreet__c = '101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';
        site.IP_InvoiceContactText__c = 'test abc';
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;
        
        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
        contract.Name = 'test contract';
        contract.sirenum__Client__c = acc.id;
        contract.sirenum__Employee__c = con.id;
        insert contract;

        sirenum__Rota__c sector = new sirenum__Rota__c();
        sector.Name = 'new sector';
        insert sector;

        sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
        jobtype.name = 'testjobtype';
        jobtype.Impellam_Sector__c = sector.id;
        jobtype.Impellam_Core_Category__c = 'Administration -ADM';
        jobtype.Impellam_Job_Category__c = 'Data Entry -OA002';
        insert jobtype;
        
        sirenum__Team__c jobroll = new sirenum__Team__c();
        jobroll.name = 'testjobroll';
        jobroll.sirenum__Account__c = contract.id; 
        jobroll.sirenum__Job_Type__c = jobtype.id;
        jobroll.IP_OPWIPSRole__c = 'No';
        insert jobroll;

        sirenum__Placement__c spleacement = new sirenum__Placement__c();         
        spleacement.Name = 'testing placment';
        spleacement.sirenum__Contact__c = con.id;
        spleacement.sirenum__Start_Date__c = Date.newInstance(2017, 11, 01);
        spleacement.sirenum__End_Date__c= Date.newInstance(2017, 12, 20);
        spleacement.sirenum__Contract__c = contract.id;
        spleacement.sirenum__Job_Role__c = jobroll.id;
        spleacement.sirenum__Site__c = site.Id;
        spleacement.sirenum__Status__c = 'Active';
        spleacement.IP_PayMethod__c = payprofile.id;
        spleacement.IP_Consultant1PercentageSplit__c = 100;
        spleacement.IP_PassToTempest__c = false;
        spleacement.IP_LastPassedToTempest__c = DateTime.now();
        insert spleacement;

        sirenum__Timesheet__c timesheet = new sirenum__Timesheet__c();
        timesheet.sirenum__Worker__c = con.id;
        timesheet.sirenum__Week_Ending__c = System.today();
        timesheet.sirenum__Non_Taxed_Expenses__c = 10.2;
        timesheet.sirenum__Taxed_Expenses__c = 20.1;
        timesheet.sirenum__Non_Taxed_Deductions__c = 10.5;
        timesheet.sirenum__Taxed_Deductions__c = 5.2;
        insert timesheet;
    }

	static testmethod void validateFunctionality_sendEmergencyData_Test_Case_1A() {
		sirenum__Placement__c thePlacement = [SELECT IP_Department__c FROM sirenum__Placement__c WHERE Name = 'testing placment' LIMIT 1];

        insert new IP_CompanyCode__c(Name = 'CompanyCode', IP_CompanyCodeValue__c = 'BAL');

        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
        ob.IP_OriginRecordID__c = thePlacement.Id;
        ob.IP_Passed__c = '';
        insert ob;
        
        Test.startTest();

		thePlacement.IP_PassToTempest__c = true;
        thePlacement.IP_FirstPass__c = false;
        thePlacement.IP_EmergencyPull__c = true;
        thePlacement.IP_Consultant1LookupSplitShare__c = [SELECT Id FROM User WHERE username = 'dummyEmail989@email.com'].Id;
        update thePlacement;
        
        Test.stopTest();
    }

	static testmethod void validateFunctionality_sendEmergencyData_Test_Case_1B() {
		sirenum__Placement__c thePlacement = [SELECT IP_Department__c FROM sirenum__Placement__c WHERE Name = 'testing placment' LIMIT 1];

        insert new IP_CompanyCode__c(Name = 'CompanyCode', IP_CompanyCodeValue__c = 'BAL');
        
        Test.startTest();

		thePlacement.IP_PassToTempest__c = true;
        thePlacement.IP_FirstPass__c = false;
        thePlacement.IP_EmergencyPull__c = true;
        thePlacement.IP_Consultant1LookupSplitShare__c = [SELECT Id FROM User WHERE username = 'dummyEmail989@email.com'].Id;
        update thePlacement;
        
        Test.stopTest();
    }

	static testmethod void validateFunctionality_sendEmergencyData_Test_Case_1C() {
		sirenum__Placement__c thePlacement = [SELECT IP_Department__c FROM sirenum__Placement__c WHERE Name = 'testing placment' LIMIT 1];

        insert new IP_CompanyCode__c(Name = 'CompanyCode', IP_CompanyCodeValue__c = 'CEL');

        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
        ob.IP_OriginRecordID__c = thePlacement.Id;
        ob.IP_Passed__c = '';
        insert ob;
        
        Test.startTest();

		thePlacement.IP_PassToTempest__c = true;
        thePlacement.IP_FirstPass__c = false;
        thePlacement.IP_EmergencyPull__c = true;
        thePlacement.IP_Consultant1LookupSplitShare__c = [SELECT Id FROM User WHERE username = 'dummyEmail989@email.com'].Id;
        update thePlacement;
        
        Test.stopTest();
    }

	static testmethod void validateFunctionality_sendEmergencyData_Test_Case_1D() {
		sirenum__Placement__c thePlacement = [SELECT IP_Department__c FROM sirenum__Placement__c WHERE Name = 'testing placment' LIMIT 1];

        insert new IP_CompanyCode__c(Name = 'CompanyCode', IP_CompanyCodeValue__c = 'CEL');
        
        Test.startTest();

		thePlacement.IP_PassToTempest__c = true;
        thePlacement.IP_FirstPass__c = false;
        thePlacement.IP_EmergencyPull__c = true;
        thePlacement.IP_Consultant1LookupSplitShare__c = [SELECT Id FROM User WHERE username = 'dummyEmail989@email.com'].Id;
        update thePlacement;
        
        Test.stopTest();
    }

    static testmethod void validateFunctionality_sendAssignDataFirstPass_Test_Case_1A() {
		sirenum__Placement__c thePlacement = [SELECT Id FROM sirenum__Placement__c LIMIT 1];
        sirenum__Timesheet__c theTimeSheet = [SELECT Id FROM sirenum__Timesheet__c LIMIT 1];

        insert new IP_CompanyCode__c(Name = 'CompanyCode', IP_CompanyCodeValue__c = 'BAL');
        
        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
        ob.IP_OriginRecordID__c = thePlacement.Id;
        ob.IP_Passed__c = '';
        ob.IP_TimesheetID__c = theTimeSheet.Id;
        insert ob;

        sirenum__Timesheet__c newTimesheet = new sirenum__Timesheet__c();
        newTimesheet.sirenum__Worker__c = [SELECT Id FROM Contact WHERE Phone = '9879879877'].Id;
        newTimesheet.sirenum__Week_Ending__c = System.today();
        newTimesheet.sirenum__Non_Taxed_Expenses__c = 10.2;
        newTimesheet.sirenum__Taxed_Expenses__c = 20.1;
        newTimesheet.sirenum__Non_Taxed_Deductions__c = 10.5;
        newTimesheet.sirenum__Taxed_Deductions__c = 5.2;
        insert newTimesheet;

        Test.startTest();

		thePlacement.IP_PassToTempest__c = true;
        thePlacement.IP_LastPassedToTempest__c = null;
        thePlacement.IP_FirstPass__c = true;
        thePlacement.IP_EmergencyPull__c = false;
        thePlacement.IP_Consultant1LookupSplitShare__c = [SELECT Id FROM User WHERE username = 'dummyEmail989@email.com'].Id;
        thePlacement.IP_TimesheetIDLink__c = newTimesheet.Id;
        update thePlacement;
        
        Test.stopTest();
    }

    static testmethod void validateFunctionality_sendAssignDataFirstPass_Test_Case_1B() {
		sirenum__Placement__c thePlacement = [SELECT Id FROM sirenum__Placement__c LIMIT 1];
        sirenum__Timesheet__c theTimeSheet = [SELECT Id FROM sirenum__Timesheet__c LIMIT 1];

        insert new IP_CompanyCode__c(Name = 'CompanyCode', IP_CompanyCodeValue__c = 'CEL');
        
        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
        ob.IP_OriginRecordID__c = thePlacement.Id;
        ob.IP_Passed__c = '';
        ob.IP_TimesheetID__c = theTimeSheet.Id;
        insert ob;

        sirenum__Timesheet__c newTimesheet = new sirenum__Timesheet__c();
        newTimesheet.sirenum__Worker__c = [SELECT Id FROM Contact WHERE Phone = '9879879877'].Id;
        newTimesheet.sirenum__Week_Ending__c = System.today();
        newTimesheet.sirenum__Non_Taxed_Expenses__c = 10.2;
        newTimesheet.sirenum__Taxed_Expenses__c = 20.1;
        newTimesheet.sirenum__Non_Taxed_Deductions__c = 10.5;
        newTimesheet.sirenum__Taxed_Deductions__c = 5.2;
        insert newTimesheet;

        Test.startTest();

		thePlacement.IP_PassToTempest__c = true;
        thePlacement.IP_LastPassedToTempest__c = null;
        thePlacement.IP_FirstPass__c = true;
        thePlacement.IP_EmergencyPull__c = false;
        thePlacement.IP_Consultant1LookupSplitShare__c = [SELECT Id FROM User WHERE username = 'dummyEmail989@email.com'].Id;
        thePlacement.IP_TimesheetIDLink__c = newTimesheet.Id;
        update thePlacement;
        
        Test.stopTest();
    }

    static testmethod void validateFunctionality_sendAssignDataFirstPass_Test_Case_1C() {
		sirenum__Placement__c thePlacement = [SELECT Id FROM sirenum__Placement__c LIMIT 1];

        insert new IP_CompanyCode__c(Name = 'CompanyCode', IP_CompanyCodeValue__c = 'BAL');

        Test.startTest();

		thePlacement.IP_PassToTempest__c = true;
        thePlacement.IP_LastPassedToTempest__c = null;
        thePlacement.IP_FirstPass__c = true;
        thePlacement.IP_EmergencyPull__c = false;
        thePlacement.IP_Consultant1LookupSplitShare__c = [SELECT Id FROM User WHERE username = 'dummyEmail989@email.com'].Id;
        update thePlacement;
        
        Test.stopTest();
    }

    static testmethod void validateFunctionality_sendAssignDataFirstPass_Test_Case_1D() {
		sirenum__Placement__c thePlacement = [SELECT Id FROM sirenum__Placement__c LIMIT 1];

        insert new IP_CompanyCode__c(Name = 'CompanyCode', IP_CompanyCodeValue__c = 'CEL');

        Test.startTest();

		thePlacement.IP_PassToTempest__c = true;
        thePlacement.IP_LastPassedToTempest__c = null;
        thePlacement.IP_FirstPass__c = true;
        thePlacement.IP_EmergencyPull__c = false;
        thePlacement.IP_Consultant1LookupSplitShare__c = [SELECT Id FROM User WHERE username = 'dummyEmail989@email.com'].Id;
        update thePlacement;
        
        Test.stopTest();
    }
    
	static testmethod void validateFunctionality_sendAssignDataSecondPass_Test_Case_1A() {
		sirenum__Placement__c thePlacement = [SELECT Id FROM sirenum__Placement__c LIMIT 1];

        insert new IP_CompanyCode__c(Name = 'CompanyCode', IP_CompanyCodeValue__c = 'BAL');
        
        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
        ob.IP_OriginRecordID__c = thePlacement.Id;
        ob.IP_Passed__c = '';
        insert ob;

        Test.startTest();

		thePlacement.IP_PassToTempest__c = true;
        thePlacement.IP_FirstPass__c = false;
        thePlacement.IP_EmergencyPull__c = false;
        thePlacement.IP_Consultant1LookupSplitShare__c = [SELECT Id FROM User WHERE username = 'dummyEmail989@email.com'].Id;
        update thePlacement;
        
        Test.stopTest();
    }

	static testmethod void validateFunctionality_sendAssignDataSecondPass_Test_Case_1B() {
		sirenum__Placement__c thePlacement = [SELECT Id FROM sirenum__Placement__c LIMIT 1];

        insert new IP_CompanyCode__c(Name = 'CompanyCode', IP_CompanyCodeValue__c = 'CEL');
        
        Test.startTest();

		thePlacement.IP_PassToTempest__c = true;
        thePlacement.IP_FirstPass__c = false;
        thePlacement.IP_EmergencyPull__c = false;
        thePlacement.IP_Consultant1LookupSplitShare__c = [SELECT Id FROM User WHERE username = 'dummyEmail989@email.com'].Id;
        update thePlacement;
        
        Test.stopTest();
    }
}