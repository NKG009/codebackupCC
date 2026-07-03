@isTest
public class Test_TimesheetEmergencyextract {
    @testSetup static void setupTestData() {
        insert new User_Profile_Id__c(
            Name = 'User Portal',
            Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal'].Id
        );
        insert new Payroll_Swtich__c(Name = 'Stoppayroll', Batch_check__c = false);
        insert new IP_CompanyCode__c(Name = 'CompanyCode', IP_CompanyCodeValue__c = 'BAL');
        insert new IP_Parallel_Payroll_Check__c(Name = 'RunParallelCheck', Run_Parallel_Payroll__c = false);

        User backOfficeUser = new User(
            LastName = 'User',
            FirstName = 'Back Office',
            Alias = 'boffuser',
            Email = 'boffuser.sf@outlook.com',
            Username = 'boffuser@email.com',
            ProfileId = [SELECT Name FROM Profile WHERE Name = 'Back Office'].Id,
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
        insert backOfficeUser;

        IP_BranchStatus__c theBranchStatus = new IP_BranchStatus__c();
        theBranchStatus.IP_BranchID__c = '1062';
        theBranchStatus.Name = 'Test';
        insert theBranchStatus;

        Account theAccount = new Account();
        theAccount.Name = 'Test Account';
        theAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Account').getRecordTypeId();

        Account theCandidateAccount = new Account();
        theCandidateAccount.Name = 'Candidates';
        theCandidateAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('IP_2ndTierSupplier').getRecordTypeId();

        insert new List<Account> {
            theAccount,
            theCandidateAccount
        };

        Contact theContact = new Contact();
        theContact.FirstName = 'Test';
        theContact.LastName = 'Contact';
        theContact.IP_CategoryOfWork__c = 'Catering';
        theContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();
        theContact.AccountId = theAccount.Id;
        theContact.MailingCity = 'UP';
        theContact.OwnerId = backOfficeUser.Id;
        theContact.sirenum__National_Insurance__c = 'AA323232A';
        theContact.Birthdate = Date.newInstance(1989, 10, 10);
        theContact.ts2__EEO_Gender__c = 'Female';
        theContact.PPE_Type__c = 'Polo shirt';

        Contact theCandidateContact = new Contact();
        theCandidateContact.FirstName = 'Candidate';
        theCandidateContact.LastName = 'Contact';
        theCandidateContact.IP_CategoryOfWork__c = 'Catering';
        theCandidateContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('IP_2ndTierCandidate').getRecordTypeId();
        theCandidateContact.AccountId = theCandidateAccount.Id;
        theCandidateContact.sirenum__National_Insurance__c = 'TN013054M';
        theCandidateContact.IP_FirstPassExternalWorker__c = false;
        theCandidateContact.IP_EmergencyPull__c = false;
        theCandidateContact.PPE_Type__c = 'Polo shirt';
        theCandidateContact.OwnerId = backOfficeUser.Id;

        insert new List<Contact> {
            theContact,
            theCandidateContact
        };

        sirenum__Site__c theSite = new sirenum__Site__c();
        theSite.Name = 'Test Site';
        theSite.sirenum__Operating_Company__c= theAccount.Id;
        theSite.IP_ClientIDLegacy__c = '123';
        theSite.IP_ClientInvoiceName__c = 'Test ABC';
        theSite.IP_PublicSector__c = 'No';
        theSite.IP_InvoiceContactText__c = 'Contact One';
        insert theSite;

        sirenum__ProActiveContract__c thePAC = TestDataFactory.sirenumProActiveContract(theCandidateAccount.Id, theCandidateContact.Id, 1)[0];
        insert thePAC;

        sirenum__Rota__c theSector = TestDataFactory.createSector(1)[0];
        insert theSector;

        sirenum__Job_Type__c theJobType = TestDataFactory.createJobType(theSector.Id, 1)[0];
        insert theJobType;

        sirenum__Team__c theJobRole = TestDataFactory.createJobRole(thePAC.Id, theJobType.Id, 1)[0];
        insert theJobRole;

        sirenum__Placement__c thePlacement = TestDataFactory.createSPlacement1(theCandidateContact.Id, thePAC.Id, theJobRole.Id, backOfficeUser.Id, 1)[0];
        thePlacement.sirenum__Site__c = theSite.Id;
        insert thePlacement;

        sirenum__Shift__c theShift = TestDataFactory.createShift(thePlacement.Id, theSite.Id, 1)[0];
        theShift.sirenum__Scheduled_Start_Time__c = System.now();
        theShift.sirenum__Scheduled_End_Time__c = System.now().addHours(2);
        theShift.sirenum__Contact__c = theCandidateContact.Id;
        insert theShift;

        sirenum__Timesheet__c theTimesheet = new sirenum__Timesheet__c();
        theTimesheet.sirenum__Worker__c = theCandidateContact.Id;
        theTimesheet.sirenum__Week_Ending__c = System.today();
        theTimesheet.sirenum__Non_Taxed_Expenses__c = 10.2;
        theTimesheet.sirenum__Taxed_Expenses__c = 20.1;
        theTimesheet.sirenum__Non_Taxed_Deductions__c = 10.5;
        theTimesheet.sirenum__Taxed_Deductions__c = 5.2;
        insert theTimesheet;

        sirenum__Timesheet_Line__c theTimesheetLine = TestDataFactory.createTimeSheetLine(theTimesheet.Id, theShift.Id, 1)[0];
        theTimesheetLine.IP_RateCodes__c = 'Night Overtime /NG';
        theTimesheetLine.sirenum__Code__c = 'ABC';
        insert theTimesheetLine;
    }

    static testmethod void validateFunctionality_createOutboundData_TestCase_One() {
        TimesheetEmergencyextract.test123();

        sirenum__Placement__c thePlacement = [SELECT Id FROM sirenum__Placement__c LIMIT 1];
        thePlacement.IP_Consultant1LookupSplitShare__c = [SELECT Id FROM User WHERE Username = 'boffuser@email.com'].Id;
        update thePlacement;

        sirenum__Timesheet_Line__c theTimesheetLine = [SELECT Id FROM sirenum__Timesheet_Line__c LIMIT 1];
        theTimesheetLine.IP_TimesheetSplitCheck__c = true;
        update theTimesheetLine;

        Test.startTest();

        sirenum__Timesheet__c theTimesheet = [SELECT Id FROM sirenum__Timesheet__c LIMIT 1];
        theTimesheet.IP_EmergencyPull__c = true;
        theTimesheet.IP_FlaggingCheck__c = true;
        theTimesheet.IP_Error__c = false;
        update theTimesheet;

        Test.stopTest();

        System.assert([SELECT Id FROM IP_OutboundDataTransfer__c].size() > 0);
    }

    static testmethod void validateFunctionality_createOutboundData_TestCase_Two() {
        sirenum__Placement__c thePlacement = [SELECT Id FROM sirenum__Placement__c LIMIT 1];
        thePlacement.IP_Consultant1LookupSplitShare__c = [SELECT Id FROM User WHERE Username = 'boffuser@email.com'].Id;
        update thePlacement;

        sirenum__Timesheet__c theTimesheet = [SELECT Id FROM sirenum__Timesheet__c LIMIT 1];

        IP_OutboundDataTransfer__c theOBDT = new IP_OutboundDataTransfer__c();
        theOBDT.IP_OriginRecordID__c = theTimesheet.Id;
        theOBDT.IP_Passed__c = '';
        insert theOBDT;

        sirenum__Timesheet_Line__c theTimesheetLine = [SELECT Id FROM sirenum__Timesheet_Line__c LIMIT 1];
        theTimesheetLine.IP_TimesheetSplitCheck__c = true;
        theTimesheetLine.IP_OutboundID__c = theOBDT.Id;
        update theTimesheetLine;

        Test.startTest();

        theTimesheet.IP_EmergencyPull__c = true;
        theTimesheet.IP_FlaggingCheck__c = true;
        theTimesheet.IP_Error__c = false;
        update theTimesheet;

        Test.stopTest();

        System.assert([SELECT IP_TransferType__c FROM IP_OutboundDataTransfer__c WHERE Id = :theOBDT.Id].IP_TransferType__c == 'Timesheet');
    }
}