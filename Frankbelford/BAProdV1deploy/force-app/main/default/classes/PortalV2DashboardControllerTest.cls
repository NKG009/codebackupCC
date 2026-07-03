@IsTest
public with sharing class PortalV2DashboardControllerTest {
  @testSetup
  static void generateTestData() {
    insert new User_Profile_Id__c(
      Name = 'User Portal',
      Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal']
      .Id
    );

    IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
    setting.IP_LastTransmissionDate__c = Date.today();
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
      IP_TempestDivision__c = 'NTS',
      Brand__c = 'Blue Arrow',
      Department = '1062',
      IP_PassToTempest__c = true
    );
    insert usr1;

    IP_BranchStatus__c b = new IP_BranchStatus__c();
    b.IP_BranchID__c = '1062';
    b.Name = 'Test';
    insert b;

    insert new Payroll_Swtich__c(Name = 'Stoppayroll', Batch_check__c = false);
    insert new IP_JSToFrostSwtich__c(
      Name = 'JSToFrost',
      IP_RunJSToFrost__c = true
    );
    insert new IP_Parallel_Payroll_Check__c(
      Name = 'RunParallelCheck',
      Run_Parallel_Payroll__c = false
    );

    RecordType accountRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Candidate'
    ];
    RecordType accountRec1 = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Account'
    ];
    RecordType maincondRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Contact'
    ];

    Account acc1 = new Account(
      Name = 'Candidates',
      RecordTypeId = accountRec.Id
    );
    Account acc = new Account(Name = 'Capita', RecordTypeId = accountRec1.Id);
    insert new List<Account>{ acc1, acc };

    Contact maincon = new Contact(
      RecordTypeId = maincondRec.Id,
      FirstName = 'Test',
      LastName = 'Main COntact',
      AccountID = acc.Id,
      PPE_Type__c = 'Polo shirt'
    );

    RecordType condRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Candidate'
    ];
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

    insert new List<Contact>{ maincon, con };

    Id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName()
      .get('PAYE')
      .getRecordTypeId();

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

    sirenum__Timesheet__c timesheet = new sirenum__Timesheet__c();
    timesheet.sirenum__Worker__c = con.id;
    timesheet.sirenum__Week_Ending__c = System.today();
    timesheet.sirenum__Non_Taxed_Expenses__c = 10.2;
    timesheet.sirenum__Taxed_Expenses__c = 20.1;
    timesheet.sirenum__Non_Taxed_Deductions__c = 10.5;
    timesheet.sirenum__Taxed_Deductions__c = 5.2;
    insert timesheet;
  }

  @isTest
  static void GetShiftBreaks() {
    /*
            Setup
        */
    // User u = [select id , contactId, accountId from user where email='bruce.wayne@wayneenterprises.com' limit 1];
    Contact contact = [
      SELECT id, name
      FROM contact
      WHERE lastname = 'candidate'
      LIMIT 1
    ];
    sirenum__Site__c site = [SELECT id, name FROM sirenum__Site__c LIMIT 1];

    List<IP_BatchLine__c> listBatchLine = [
      SELECT id, IP_TextField1__c
      FROM IP_BatchLine__c
      WHERE IP_Status__c = 'open'
      LIMIT 1
    ];
    sirenum__Team__c jobRole = [SELECT id FROM sirenum__Team__c LIMIT 1];
    sirenum__Rota__c sector = [SELECT id FROM sirenum__Rota__c LIMIT 1];
    IP_PayProfile__c payProfile = [SELECT id FROM IP_PayProfile__c LIMIT 1];

    sirenum__Shift__c shift1 = TestDataFactory.createShift(null, site.id, 1)[0];
    shift1.sirenum__Team__c = jobRole.id;
    shift1.sirenum__Contact__c = contact.id;
    shift1.sirenum__Rota__c = sector.id;
    shift1.sirenum__Scheduled_Start_Time__c = System.now().addDays(-3);
    shift1.sirenum__Scheduled_End_Time__c = System.now()
      .addDays(-1)
      .addHours(8);
    insert shift1;

    sirenum__Shift_Break__c break1 = new sirenum__Shift_Break__c(
      sirenum__Start_Time__c = System.now().addDays(-3),
      sirenum__End_Time__c = System.now().addDays(-3).addHours(1),
      sirenum__Shift__c = shift1.Id
    );
    insert break1;
    /*
            Execution
        */
    Test.startTest();

    List<sirenum__Shift_Break__c> output = PortalV2DashboardController.getShiftBreaks(
      shift1.Id
    );
    Test.stopTest();

    /*
            Assertions
        */
    System.assertEquals(false, output.isEmpty());
    System.assertEquals(1, output.size());
  }

  @isTest
  static void UpdateShiftBreak() {
    /*
            Setup
        */
    // User u = [select id , contactId, accountId from user where email='bruce.wayne@wayneenterprises.com' limit 1];
    Contact contact = [
      SELECT id, name
      FROM contact
      WHERE lastname = 'candidate'
      LIMIT 1
    ];
    sirenum__Site__c site = [SELECT id, name FROM sirenum__Site__c LIMIT 1];

    List<IP_BatchLine__c> listBatchLine = [
      SELECT id, IP_TextField1__c
      FROM IP_BatchLine__c
      WHERE IP_Status__c = 'open'
      LIMIT 1
    ];
    sirenum__Team__c jobRole = [SELECT id FROM sirenum__Team__c LIMIT 1];
    sirenum__Rota__c sector = [SELECT id FROM sirenum__Rota__c LIMIT 1];
    IP_PayProfile__c payProfile = [SELECT id FROM IP_PayProfile__c LIMIT 1];

    sirenum__Shift__c shift1 = TestDataFactory.createShift(null, site.id, 1)[0];
    shift1.sirenum__Team__c = jobRole.id;
    shift1.sirenum__Contact__c = contact.id;
    shift1.sirenum__Rota__c = sector.id;
    shift1.sirenum__Scheduled_Start_Time__c = System.now().addDays(-3);
    shift1.sirenum__Scheduled_End_Time__c = System.now()
      .addDays(-1)
      .addHours(8);
    insert shift1;

    sirenum__Shift_Break__c break1 = new sirenum__Shift_Break__c(
      sirenum__Start_Time__c = System.now().addDays(-3),
      sirenum__End_Time__c = System.now().addDays(-3).addHours(1),
      sirenum__Shift__c = shift1.Id
    );
    insert break1;
    /*
            Execution
        */
    Test.startTest();

    DateTime newDate = System.now().addDays(-3).addHours(2);
    PortalV2DashboardController.updateShiftBreak(break1.Id, newDate);
    Test.stopTest();

    sirenum__Shift_Break__c updatedBreak = [
      SELECT Id, sirenum__End_Time__c
      FROM sirenum__Shift_Break__c
      WHERE Id = :break1.Id
    ];
    /*
            Assertions
        */
    System.assertEquals(newDate, updatedBreak.sirenum__End_Time__c);
  }

  @isTest
  static void GetShiftBreakStartTime() {
    /*
            Setup
        */
    // User u = [select id , contactId, accountId from user where email='bruce.wayne@wayneenterprises.com' limit 1];
    Contact contact = [
      SELECT id, name
      FROM contact
      WHERE lastname = 'candidate'
      LIMIT 1
    ];
    sirenum__Site__c site = [SELECT id, name FROM sirenum__Site__c LIMIT 1];

    List<IP_BatchLine__c> listBatchLine = [
      SELECT id, IP_TextField1__c
      FROM IP_BatchLine__c
      WHERE IP_Status__c = 'open'
      LIMIT 1
    ];
    sirenum__Team__c jobRole = [SELECT id FROM sirenum__Team__c LIMIT 1];
    sirenum__Rota__c sector = [SELECT id FROM sirenum__Rota__c LIMIT 1];
    IP_PayProfile__c payProfile = [SELECT id FROM IP_PayProfile__c LIMIT 1];

    sirenum__Shift__c shift1 = TestDataFactory.createShift(null, site.id, 1)[0];
    shift1.sirenum__Team__c = jobRole.id;
    shift1.sirenum__Contact__c = contact.id;
    shift1.sirenum__Rota__c = sector.id;
    shift1.sirenum__Scheduled_Start_Time__c = System.now().addDays(-3);
    shift1.sirenum__Scheduled_End_Time__c = System.now()
      .addDays(-1)
      .addHours(8);
    insert shift1;

    // sirenum__Shift_Break__c break1 = new sirenum__Shift_Break__c(
    //   sirenum__Start_Time__c = System.now().addDays(-3),
    //   sirenum__End_Time__c = System.now().addDays(-3).addHours(1),
    //   sirenum__Shift__c = shift1.Id
    // );
    // insert break1;
    /*
            Execution
        */
    Test.startTest();

    DateTime output = PortalV2DashboardController.getShiftBreakStartTime(
      shift1.Id
    );

    Test.stopTest();

    /*
            Assertions
        */
    System.assertEquals(shift1.sirenum__Scheduled_Start_Time__c, output);
  }

  @isTest
  static void GetLast3MonthShifts() {
    /*
            Setup
        */
    // User u = [select id , contactId, accountId from user where email='bruce.wayne@wayneenterprises.com' limit 1];
    Contact contact = [
      SELECT id, name
      FROM contact
      WHERE lastname = 'candidate'
      LIMIT 1
    ];
    sirenum__Site__c site = [SELECT id, name FROM sirenum__Site__c LIMIT 1];

    List<IP_BatchLine__c> listBatchLine = [
      SELECT id, IP_TextField1__c
      FROM IP_BatchLine__c
      WHERE IP_Status__c = 'open'
      LIMIT 1
    ];
    sirenum__Team__c jobRole = [SELECT id FROM sirenum__Team__c LIMIT 1];
    sirenum__Rota__c sector = [SELECT id FROM sirenum__Rota__c LIMIT 1];
    IP_PayProfile__c payProfile = [SELECT id FROM IP_PayProfile__c LIMIT 1];
    //Create timesheets and lines
    sirenum__Timesheet__c timesheet1 = new sirenum__Timesheet__c();
    timesheet1.sirenum__Worker__c = contact.id;
    timesheet1.sirenum__Week_Ending__c = System.today().addDays(-20);
    timesheet1.sirenum__Non_Taxed_Expenses__c = 10.2;
    timesheet1.sirenum__Taxed_Expenses__c = 20.1;
    timesheet1.sirenum__Non_Taxed_Deductions__c = 10.5;
    timesheet1.sirenum__Taxed_Deductions__c = 5.2;
    timesheet1.sirenum__Site__c = site.Id;
    insert timesheet1;

    IP_OutboundDataTransfer__c OBDT1 = new IP_OutboundDataTransfer__c();
    OBDT1.IP_OriginRecordID__c = timesheet1.Id;
    OBDT1.IP_Passed__c = '';
    insert OBDT1;

    sirenum__Shift__c shift1 = TestDataFactory.createShift(null, site.id, 1)[0];
    shift1.sirenum__Timesheet_summaries__c = timesheet1.id;
    shift1.sirenum__Team__c = jobRole.id;
    shift1.sirenum__Contact__c = contact.id;
    shift1.sirenum__Rota__c = sector.id;
    shift1.sirenum__Scheduled_Start_Time__c = System.now();
    shift1.sirenum__Scheduled_End_Time__c = System.now() + 1;
    insert shift1;

    // sirenum__Timesheet_Line__c timesheetLine1 = new sirenum__Timesheet_Line__c();
    // timesheetLine1.sirenum__Timesheet__c = timesheet1.id;
    // timesheetLine1.sirenum__Rate__c = 22.0;
    // timesheetLine1.sirenum__Hours__c = 1;
    // timesheetLine1.IP_PassToTempest__c = false;
    // timesheetLine1.IP_RateCodes__c = 'Taxable Expenses /TX';
    // timesheetLine1.sirenum__Shift__c = shift1.id;
    // timesheetLine1.IP_TimesheetSplitCheck__c = true;
    // timesheetLine1.IP_POErrorLogField__c = 'TestValue';
    // timesheetLine1.IP_OutboundID__c = OBDT1.Id;
    // timesheetLine1.IP_Outbounddatawrite__c = Date.today().addDays(-1);
    // insert timesheetLine1;

    // sirenum__Timesheet__c timesheet2 = new sirenum__Timesheet__c();
    // timesheet2.sirenum__Worker__c = contact.id;
    // timesheet2.sirenum__Week_Ending__c = System.today().addDays(-27);
    // timesheet2.sirenum__Non_Taxed_Expenses__c = 10.2;
    // timesheet2.sirenum__Taxed_Expenses__c = 20.1;
    // timesheet2.sirenum__Non_Taxed_Deductions__c = 10.5;
    // timesheet2.sirenum__Taxed_Deductions__c = 5.2;
    // timesheet2.sirenum__Site__c = site.Id;
    // insert timesheet2;

    sirenum__Shift__c shift2 = TestDataFactory.createShift(null, site.id, 1)[0];
    // shift2.sirenum__Timesheet_summaries__c = timesheet2.id;
    shift2.sirenum__Team__c = jobRole.id;
    shift2.sirenum__Contact__c = contact.id;
    shift2.sirenum__Rota__c = sector.id;
    shift2.sirenum__Scheduled_Start_Time__c = System.now();
    shift2.sirenum__Scheduled_End_Time__c = System.now() + 1;
    insert shift2;

    // sirenum__Timesheet_Line__c timesheetLine2 = new sirenum__Timesheet_Line__c();
    // timesheetLine2.sirenum__Timesheet__c = timesheet2.id;
    // timesheetLine2.sirenum__Rate__c = 22.0;
    // timesheetLine2.sirenum__Hours__c = 1;
    // timesheetLine2.IP_PassToTempest__c = false;
    // timesheetLine2.IP_RateCodes__c = 'Taxable Expenses /TX';
    // timesheetLine2.sirenum__Shift__c = shift2.id;
    // timesheetLine2.IP_TimesheetSplitCheck__c = true;
    // timesheetLine2.IP_POErrorLogField__c = 'TestValue';
    // timesheetLine2.IP_OutboundID__c = OBDT1.Id;
    // timesheetLine2.IP_Outbounddatawrite__c = Date.today().addDays(-1);

    // insert timesheetLine2;

    /*
            Execution
        */
    Test.startTest();

    List<sirenum__Timesheet__c> retrievedShifts = PortalV2DashboardController.getTotalCostPerWeek(
      new List<Id>{ site.Id }
    );
    system.debug(
      [SELECT Id, IP_LockTimesheet__c FROM sirenum__Timesheet_Line__c]
    );
    Test.stopTest();

    /*
            Assertions
        */
    System.assertEquals(false, retrievedShifts.isEmpty());
  }
  @isTest
  static void testGetEnableWorkerEndorsement() {
		Boolean isEnableWorkerEndorsement = PortalV2DashboardController.getEnableWorkerEndorsement();		
		System.assertEquals(false, isEnableWorkerEndorsement);
  }
  
}