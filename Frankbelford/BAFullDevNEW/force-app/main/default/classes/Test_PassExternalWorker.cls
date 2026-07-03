@isTest
public class Test_PassExternalWorker {
    @testSetup static void generateTestData() {
        insert new User_Profile_Id__c(
            Name = 'User Portal',
            Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal'].Id
        );

        IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
        setting.IP_LastTransmissionDate__c = Date.newInstance(2019,07,01);
        setting.IP_OutboundErrorEmailAddress__c = 'test@test.com';
        insert setting;

        Profile p1 = [SELECT Name FROM Profile WHERE Name = 'User Portal'];
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

        insert new IP_CompanyCode__c(Name = 'CompanyCode', IP_CompanyCodeValue__c = 'BAL');
        insert new IP_Parallel_Payroll_Check__c(Name = 'RunParallelCheck', Run_Parallel_Payroll__c = false);

        IP_BranchStatus__c b = new IP_BranchStatus__c();
        b.IP_BranchID__c = '1062';
        b.Name = 'Test';
        insert b;

        insert new IP_JSToFrostSwtich__c(Name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(Name = 'Stoppayroll', Batch_check__c = false);

        RecordType maincondRec = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' And DeveloperName = 'Contact'];
        RecordType rtacc = [SELECT Id FROM RecordType WHERE SobjectType='Account' AND DeveloperName = 'IP_2ndTierSupplier'];
        RecordType rtcon = [SELECT Id FROM RecordType WHERE SobjectType='Contact' AND DeveloperName = 'IP_2ndTierCandidate'];
        RecordType accountRec1 = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' And DeveloperName = 'Account'];

        Account acc1 = new Account(Name = 'Capita', RecordTypeId = accountRec1.Id);
        Account a = new Account(Name = 'Candidates', RecordTypeId = rtacc.Id);
        insert new List<Account> { acc1, a };

        Contact maincon = new Contact(
            RecordTypeId = maincondRec.id,
            FirstName = 'Test',
            LastName = 'Main Contact',
            PPE_Type__c = 'Polo shirt',
            AccountID = acc1.id
        );

        Contact c = new Contact();
        c.LastName = 'contacttest';
        c.IP_CategoryOfWork__c = 'Catering';
        c.RecordTypeId = rtcon.id;
        c.FirstName = 'test';
        c.AccountId = a.Id;
        c.sirenum__National_Insurance__c = 'TN013054M';
        c.IP_FirstPassExternalWorker__c = false;
        c.IP_EmergencyPull__c = false;
        c.PPE_Type__c = 'Polo shirt';
        c.OwnerId = usr1.Id;

        insert new List<Contact> { maincon, c };

        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(a.Id, c.Id, 1)[0];
        insert pac;

        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0];
        insert sector;

        sirenum__Job_Type__c jobType = TestDataFactory.createJobType(sector.id, 1)[0];
        insert jobType;

        sirenum__Team__c jrole = TestDataFactory.createJobRole(pac.Id, jobType.Id, 1)[0];
        insert jrole;

        IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
        insert topaz;

        sirenum__Site__c site = new sirenum__Site__c();
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc1.id;
        site.IP_ClientIDLegacy__c = '123';
        site.IP_ClientInvoiceName__c = 'test abc';
        site.IP_PublicSector__c = 'No';
        site.IP_InvoiceContactText__c = 'Contact 1';
        insert site;

        sirenum__Placement__c splace1 = TestDataFactory.createSPlacement1(c.Id, pac.Id, jrole.Id, usr1.Id, 1)[0];
        splace1.sirenum__Site__c = site.id;
        insert splace1;

        sirenum__Shift__c shft1 = TestDataFactory.createShift(splace1.Id,site.id,1)[0]; 
        shft1.sirenum__Scheduled_Start_Time__c = System.now();
        shft1.sirenum__Scheduled_End_Time__c = System.now().addHours(2);
        shft1.sirenum__Contact__c = c.id;
        insert shft1;

        sirenum__Timesheet__c timesheet = new sirenum__Timesheet__c();
        timesheet.sirenum__Worker__c = c.id;
        timesheet.sirenum__Week_Ending__c = System.today();
        timesheet.sirenum__Non_Taxed_Expenses__c = 10.2;
        timesheet.sirenum__Taxed_Expenses__c = 20.1;
        timesheet.sirenum__Non_Taxed_Deductions__c = 10.5;
        timesheet.sirenum__Taxed_Deductions__c = 5.2;
        insert timesheet;

        List<sirenum__Timesheet_Line__c> tsl = TestDataFactory.createTimeSheetLine(timesheet.Id, shft1.id, 1);
        insert tsl;
    }

	static testmethod void validateFunctionality_Test_Case_One() {
        Contact theContact = [SELECT Id FROM Contact WHERE LastName = 'contacttest' LIMIT 1];
        sirenum__Timesheet__c theTimesheet = [SELECT Id FROM sirenum__Timesheet__c];

        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
        ob.IP_OriginRecordID__c = theContact.Id;
        ob.IP_TimesheetID__c = theTimesheet.Id;
        ob.IP_Passed__c = null;
        ob.TestValidation__c = 'test';
        insert ob;

        Test.startTest();

        theContact.IP_TimesheetIDLink__c = theTimesheet.Id;
        theContact.IP_LastPassedToTempest2ndTier__c = null;
        theContact.IP_Pass2ndTierToTempest__c = true;
        theContact.IP_FirstPassExternalWorker__c = true;
        theContact.IP_EmergencyPull__c = true;
        update theContact;

        Test.stopTest();
    }

	static testmethod void validateFunctionality_Test_Case_Two() {
		Contact theContact = [SELECT Id FROM Contact WHERE LastName = 'contacttest' LIMIT 1];

        Test.startTest();

        theContact.IP_TimesheetIDLink__c = [SELECT Id FROM sirenum__Timesheet__c].Id;
        theContact.IP_LastPassedToTempest2ndTier__c = null;
        theContact.IP_Pass2ndTierToTempest__c = true;
        theContact.IP_FirstPassExternalWorker__c = true;
        theContact.IP_EmergencyPull__c = true;
        update theContact;

        Test.stopTest();
    }

	static testmethod void validateFunctionality_Test_Case_Three() {
        Contact theContact = [SELECT Id FROM Contact WHERE LastName = 'contacttest' LIMIT 1];
        sirenum__Timesheet__c theTimesheet = [SELECT Id FROM sirenum__Timesheet__c];

        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
        ob.IP_OriginRecordID__c = theContact.Id;
        ob.IP_TimesheetID__c = theTimesheet.Id;
        ob.IP_Passed__c = null;
        ob.TestValidation__c = 'test';
        insert ob;

        Test.startTest();

        theContact.IP_TimesheetIDLink__c = theTimesheet.Id;
        theContact.IP_LastPassedToTempest2ndTier__c = null;
        theContact.IP_Pass2ndTierToTempest__c = true;
        theContact.IP_FirstPassExternalWorker__c = false;
        theContact.IP_EmergencyPull__c = true;
        update theContact;

        Test.stopTest();
    }

	static testmethod void validateFunctionality_Test_Case_Four() {
        Contact theContact = [SELECT Id FROM Contact WHERE LastName = 'contacttest' LIMIT 1];
        sirenum__Timesheet__c theTimesheet = [SELECT Id FROM sirenum__Timesheet__c];

        Test.startTest();

        theContact.IP_TimesheetIDLink__c = theTimesheet.Id;
        theContact.IP_LastPassedToTempest2ndTier__c = null;
        theContact.IP_Pass2ndTierToTempest__c = true;
        theContact.IP_FirstPassExternalWorker__c = false;
        theContact.IP_EmergencyPull__c = true;
        update theContact;

        Test.stopTest();
    }
}