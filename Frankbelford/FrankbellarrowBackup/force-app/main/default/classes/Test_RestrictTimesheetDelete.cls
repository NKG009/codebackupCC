@isTest
public class Test_RestrictTimesheetDelete {
  static testMethod void Test1() {
    insert new IP_CompanyCode__c(
      name = 'CompanyCode',
      IP_CompanyCodeValue__c = 'BAL'
    );
    RecordType accountRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Candidate'
    ];
    Account acc1 = new Account(
      Name = 'Candidates',
      RecordTypeId = accountRec.id
    );
    insert acc1;

    TestDataFactory.setupUserProfileCustomSettings();
    insert new DefaultAccounts__c(Name = 'Candidates', Account_Id__c = acc1.Id);
    insert new IP_JSToFrostSwtich__c(
      name = 'JSToFrost',
      IP_RunJSToFrost__c = false
    );
    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

    RecordType accountRec1 = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Account'
    ];

    Account acc = new Account(Name = 'Capita', RecordTypeId = accountRec1.id);
    insert acc;
    RecordType maincondRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Contact'
    ];

    Contact maincon = new Contact(
      RecordTypeId = maincondRec.id,
      FirstName = 'Test',
      LastName = 'Main COntact',
      AccountID = acc.id
    );
    insert maincon;

    RecordType condRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Candidate'
    ];
    //insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
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
      IP_CategoryOfWork__c = 'Catering',
      IP_ThirdPartyID__c = 'testpay12'
    );
    insert con;

    id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName()
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
    //payprofile.IP_PassToTempest__c=true;
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
    site.sirenum__Street_Address__c = 'ABC';
    site.sirenum__City__c = 'ABC';
    site.IP_InvoiceContact__c = maincon.id;
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
    jobtype.Impellam_Job_Category__c = 'Administrator -OA001';

    insert jobtype;

    sirenum__Team__c jobroll = new sirenum__Team__c();

    jobroll.name = 'testjobroll';
    jobroll.sirenum__Account__c = contract.id;
    jobroll.sirenum__Job_Type__c = jobtype.id;
    jobroll.IP_OPWIPSRole__c = 'No';
    jobroll.sirenum__Rota__c = sector.id;
    insert jobroll;

    sirenum__Placement__c spleacement = new sirenum__Placement__c();

    spleacement.Name = 'testing placment';
    spleacement.sirenum__Contact__c = con.id;
    spleacement.sirenum__Start_Date__c = Date.newInstance(2017, 11, 1);
    spleacement.sirenum__End_Date__c = Date.newInstance(2017, 12, 20);
    spleacement.sirenum__Contract__c = contract.id;
    spleacement.sirenum__Job_Role__c = jobroll.id;
    spleacement.sirenum__Site__c = site.Id;
    spleacement.sirenum__Status__c = 'Active';
    spleacement.IP_PayMethod__c = payprofile.id;
    spleacement.IP_Consultant1PercentageSplit__c = 100;
    spleacement.sirenum__Rota__c = sector.id;
    // spleacement.IP_PassToTempest__c=true;
    insert spleacement;

    IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
    setting.IP_LastTransmissionDate__c = Date.newInstance(2019, 7, 1);
    setting.IP_OutboundErrorEmailAddress__c = 'ritu.hetawal@espire.com';
    insert setting;

    insert new IP_Parallel_Payroll_Check__c(
      name = 'RunParallelCheck',
      Run_Parallel_Payroll__c = false
    );
    IP_BranchStatus__c b = new IP_BranchStatus__c();
    b.IP_BranchID__c = '1062';
    b.Name = 'Test';
    insert b;

    sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
    newTimeSheet1.sirenum__Worker__c = con.id;
    newTimesheet1.sirenum__Client__c = acc.id;
    newTimesheet1.sirenum__Team__c = jobroll.id;
    newTimesheet1.sirenum__Site__c = site.Id;
    newTimesheet1.IP_DuplicateCheckPassOK__c = true;
    newTimesheet1.IP_FlaggingCheck__c = true;
    newTimesheet1.sirenum__Week_Ending__c = Date.newInstance(2017, 11, 24);
    insert newTimeSheet1;

    sirenum__Shift__c shift = new sirenum__Shift__c();
    shift.sirenum__Site__c = site.id;
    shift.sirenum__Placement__c = spleacement.Id;
    shift.sirenum__Team__c = jobroll.id;
    shift.sirenum__Contact__c = con.id;
    shift.sirenum__Rota__c = sector.id;
    shift.sirenum__Timesheet_summaries__c = newTimesheet1.Id;
    insert shift;
    sirenum__Timesheet_Line__c sheetline = TestDataFactory.createTimeSheetLine(
      newTimeSheet1.id,
      shift.id,
      1
    )[0];
    insert sheetline;

    IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
    ob.IP_OriginRecordID__c = spleacement.id;
    ob.IP_TransferType__c = 'Assignment';
    ob.IP_Passed__c = '';
    ob.IP_TimesheetID__c = newTimesheet1.id;
    insert ob;

    IP_OutboundDataTransfer__c ob1 = new IP_OutboundDataTransfer__c();
    ob1.IP_OriginRecordID__c = payprofile.id;
    ob1.IP_TransferType__c = 'Internal Worker';
    ob1.IP_Passed__c = '';
    ob1.IP_TimesheetID__c = newTimesheet1.id;
    insert ob1;

    IP_OutboundDataTransfer__c ob2 = new IP_OutboundDataTransfer__c();
    ob2.IP_OriginRecordID__c = con.id;
    ob2.IP_TransferType__c = 'External Worker';
    ob2.IP_Passed__c = '';
    ob2.IP_TimesheetID__c = newTimesheet1.id;
    insert ob2;

    /*IP_OutboundDataTransfer__c ob3 = new IP_OutboundDataTransfer__c();
        ob3.IP_OriginRecordID__c = sheetline.id;
        ob3.IP_TransferType__c = 'Timesheet';
        ob3.IP_Passed__c = 'ANC';
        ob3.IP_TimesheetID__c = newTimesheet1.id;
        insert ob3;*/

    Test.startTest();

    delete newTimesheet1;

    Test.StopTest();
  }

  static testMethod void Test2() {
    insert new IP_CompanyCode__c(
      name = 'CompanyCode',
      IP_CompanyCodeValue__c = 'BAL'
    );
    RecordType accountRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Candidate'
    ];
    Account acc1 = new Account(
      Name = 'Candidates',
      RecordTypeId = accountRec.id
    );
    insert acc1;

    TestDataFactory.setupUserProfileCustomSettings();
    insert new DefaultAccounts__c(Name = 'Candidates', Account_Id__c = acc1.Id);
    insert new IP_JSToFrostSwtich__c(
      name = 'JSToFrost',
      IP_RunJSToFrost__c = false
    );
    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

    RecordType accountRec1 = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Account'
    ];

    Account acc = new Account(Name = 'Capita', RecordTypeId = accountRec1.id);
    insert acc;
    RecordType maincondRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Contact'
    ];

    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
    Contact maincon = new Contact(
      RecordTypeId = maincondRec.id,
      FirstName = 'Test',
      LastName = 'Main COntact',
      AccountID = acc.id
    );
    insert maincon;

    RecordType condRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Candidate'
    ];
    //insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
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
      IP_CategoryOfWork__c = 'Catering',
      IP_ThirdPartyID__c = 'testpay12'
    );
    insert con;

    id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName()
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
    //payprofile.IP_PassToTempest__c=true;
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
    site.sirenum__Street_Address__c = 'ABC';
    site.sirenum__City__c = 'ABC';
    site.IP_InvoiceContact__c = maincon.id;
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
    jobtype.Impellam_Job_Category__c = 'Administrator -OA001';

    insert jobtype;

    sirenum__Team__c jobroll = new sirenum__Team__c();

    jobroll.name = 'testjobroll';
    jobroll.sirenum__Account__c = contract.id;
    jobroll.sirenum__Job_Type__c = jobtype.id;
    jobroll.IP_OPWIPSRole__c = 'No';
    jobroll.sirenum__Rota__c = sector.id;
    insert jobroll;

    sirenum__Placement__c spleacement = new sirenum__Placement__c();

    spleacement.Name = 'testing placment';
    spleacement.sirenum__Contact__c = con.id;
    spleacement.sirenum__Start_Date__c = Date.newInstance(2017, 11, 1);
    spleacement.sirenum__End_Date__c = Date.newInstance(2017, 12, 20);
    spleacement.sirenum__Contract__c = contract.id;
    spleacement.sirenum__Job_Role__c = jobroll.id;
    spleacement.sirenum__Site__c = site.Id;
    spleacement.sirenum__Status__c = 'Active';
    spleacement.IP_PayMethod__c = payprofile.id;
    spleacement.IP_Consultant1PercentageSplit__c = 100;
    spleacement.sirenum__Rota__c = sector.id;
    // spleacement.IP_PassToTempest__c=true;
    insert spleacement;

    IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
    setting.IP_LastTransmissionDate__c = Date.newInstance(2019, 7, 1);
    setting.IP_OutboundErrorEmailAddress__c = 'ritu.hetawal@espire.com';
    insert setting;

    insert new IP_Parallel_Payroll_Check__c(
      name = 'RunParallelCheck',
      Run_Parallel_Payroll__c = false
    );
    IP_BranchStatus__c b = new IP_BranchStatus__c();
    b.IP_BranchID__c = '1062';
    b.Name = 'Test';
    insert b;

    Test.startTest();
    sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
    newTimeSheet1.sirenum__Worker__c = con.id;
    newTimesheet1.sirenum__Client__c = acc.id;
    newTimesheet1.sirenum__Team__c = jobroll.id;
    newTimesheet1.sirenum__Site__c = site.Id;
    newTimesheet1.IP_DuplicateCheckPassOK__c = true;
    newTimesheet1.IP_FlaggingCheck__c = true;
    newTimesheet1.sirenum__Week_Ending__c = Date.newInstance(2017, 11, 24);
    insert newTimeSheet1;

    sirenum__Shift__c shift = new sirenum__Shift__c();
    shift.sirenum__Site__c = site.id;
    shift.sirenum__Placement__c = spleacement.Id;
    shift.sirenum__Team__c = jobroll.id;
    shift.sirenum__Contact__c = con.id;
    shift.sirenum__Rota__c = sector.id;
    shift.sirenum__Timesheet_summaries__c = newTimesheet1.Id;
    insert shift;

    IP_OutboundDataTransfer__c ob3 = new IP_OutboundDataTransfer__c();
    // ob3.IP_OriginRecordID__c = stsl.id;
    ob3.IP_TransferType__c = 'Timesheet';
    ob3.IP_Passed__c = '';
    ob3.IP_TimesheetID__c = newTimesheet1.id;
    insert ob3;

    sirenum__Timesheet_Line__c stsl = new sirenum__Timesheet_Line__c();
    stsl.sirenum__Timesheet__c = newTimeSheet1.id;
    stsl.sirenum__Shift__c = shift.id;
    stsl.sirenum__Rate__c = 12;
    stsl.sirenum__Charge__c = 10;
    stsl.sirenum__Hours__c = 1;
    stsl.IP_RateCodes__c = 'Standard Hours /P1';
    stsl.IP_TimesheetSplitCheck__c = true;
    stsl.IP_OutboundID__c = ob3.id;
    insert stsl;

    ob3.IP_OriginRecordID__c = stsl.id;
    update ob3;
    stsl.sirenum__Rate__c = 12;
    update stsl;

    Test.StopTest();
  }

  static testMethod void Test3() {
    insert new IP_CompanyCode__c(
      name = 'CompanyCode',
      IP_CompanyCodeValue__c = 'BAL'
    );
    RecordType accountRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Candidate'
    ];
    Account acc1 = new Account(
      Name = 'Candidates',
      RecordTypeId = accountRec.id
    );
    insert acc1;

    TestDataFactory.setupUserProfileCustomSettings();
    insert new DefaultAccounts__c(Name = 'Candidates', Account_Id__c = acc1.Id);
    insert new IP_JSToFrostSwtich__c(
      name = 'JSToFrost',
      IP_RunJSToFrost__c = false
    );
    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

    RecordType accountRec1 = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Account'
    ];

    Account acc = new Account(Name = 'Capita', RecordTypeId = accountRec1.id);
    insert acc;
    RecordType maincondRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Contact'
    ];

    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
    Contact maincon = new Contact(
      RecordTypeId = maincondRec.id,
      FirstName = 'Test',
      LastName = 'Main COntact',
      AccountID = acc.id
    );
    insert maincon;

    /*TestDataFactory.setupUserProfileCustomSettings();
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=acc1.Id);
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);*/
    //insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

    RecordType condRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Candidate'
    ];
    //insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
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
      IP_CategoryOfWork__c = 'Catering',
      IP_ThirdPartyID__c = 'testpay12'
    );
    insert con;

    id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName()
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
    //payprofile.IP_PassToTempest__c=true;
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
    site.sirenum__Street_Address__c = 'ABC';
    site.sirenum__City__c = 'ABC';
    site.IP_InvoiceContact__c = maincon.id;
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
    jobtype.Impellam_Job_Category__c = 'Administrator -OA001';

    insert jobtype;

    sirenum__Team__c jobroll = new sirenum__Team__c();

    jobroll.name = 'testjobroll';
    jobroll.sirenum__Account__c = contract.id;
    jobroll.sirenum__Job_Type__c = jobtype.id;
    jobroll.IP_OPWIPSRole__c = 'No';
    jobroll.sirenum__Rota__c = sector.id;
    insert jobroll;

    sirenum__Placement__c spleacement = new sirenum__Placement__c();

    spleacement.Name = 'testing placment';
    spleacement.sirenum__Contact__c = con.id;
    spleacement.sirenum__Start_Date__c = Date.newInstance(2017, 11, 1);
    spleacement.sirenum__End_Date__c = Date.newInstance(2017, 12, 20);
    spleacement.sirenum__Contract__c = contract.id;
    spleacement.sirenum__Job_Role__c = jobroll.id;
    spleacement.sirenum__Site__c = site.Id;
    spleacement.sirenum__Status__c = 'Active';
    spleacement.IP_PayMethod__c = payprofile.id;
    spleacement.IP_Consultant1PercentageSplit__c = 100;
    spleacement.sirenum__Rota__c = sector.id;
    // spleacement.IP_PassToTempest__c=true;
    insert spleacement;

    IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
    setting.IP_LastTransmissionDate__c = Date.newInstance(2019, 7, 1);
    setting.IP_OutboundErrorEmailAddress__c = 'ritu.hetawal@espire.com';
    insert setting;

    insert new IP_Parallel_Payroll_Check__c(
      name = 'RunParallelCheck',
      Run_Parallel_Payroll__c = false
    );
    IP_BranchStatus__c b = new IP_BranchStatus__c();
    b.IP_BranchID__c = '1062';
    b.Name = 'Test';
    insert b;

    Test.startTest();

    sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
    newTimeSheet1.sirenum__Worker__c = con.id;
    newTimesheet1.sirenum__Client__c = acc.id;
    newTimesheet1.sirenum__Team__c = jobroll.id;
    newTimesheet1.sirenum__Site__c = site.Id;
    newTimesheet1.IP_DuplicateCheckPassOK__c = true;
    newTimesheet1.IP_FlaggingCheck__c = true;
    newTimesheet1.sirenum__Week_Ending__c = Date.newInstance(2017, 11, 24);

    insert newTimeSheet1;

    sirenum__Shift__c shift = new sirenum__Shift__c();
    shift.sirenum__Site__c = site.id;
    shift.sirenum__Placement__c = spleacement.Id;
    shift.sirenum__Team__c = jobroll.id;
    shift.sirenum__Contact__c = con.id;
    shift.sirenum__Rota__c = sector.id;
    shift.sirenum__Timesheet_summaries__c = newTimesheet1.Id;
    insert shift;
    sirenum__Timesheet_Line__c stsl = new sirenum__Timesheet_Line__c();
    stsl.sirenum__Timesheet__c = newTimeSheet1.id;
    stsl.sirenum__Shift__c = shift.id;
    stsl.sirenum__Rate__c = 12;
    stsl.sirenum__Charge__c = 10;
    stsl.sirenum__Hours__c = 1;
    stsl.IP_RateCodes__c = 'Standard Hours /P1';

    insert stsl;
    newTimeSheet1.IP_EmergencyPull__c = true;
    update newTimeSheet1;
    stsl.IP_TimesheetSplitCheck__c = true;
    update stsl;
    Test.StopTest();
  }

  static testMethod void Test4() {
    insert new IP_CompanyCode__c(
      name = 'CompanyCode',
      IP_CompanyCodeValue__c = 'BAL'
    );
    RecordType accountRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Candidate'
    ];
    Account acc1 = new Account(
      Name = 'Candidates',
      RecordTypeId = accountRec.id
    );
    insert acc1;

    TestDataFactory.setupUserProfileCustomSettings();
    insert new DefaultAccounts__c(Name = 'Candidates', Account_Id__c = acc1.Id);
    insert new IP_JSToFrostSwtich__c(
      name = 'JSToFrost',
      IP_RunJSToFrost__c = false
    );
    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

    RecordType accountRec1 = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Account'
    ];

    Account acc = new Account(Name = 'Capita', RecordTypeId = accountRec1.id);
    insert acc;
    RecordType maincondRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Contact'
    ];

    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

    Contact maincon = new Contact(
      RecordTypeId = maincondRec.id,
      FirstName = 'Test',
      LastName = 'Main COntact',
      AccountID = acc.id
    );
    insert maincon;

    /*TestDataFactory.setupUserProfileCustomSettings();
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=acc1.Id);
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);*/

    RecordType condRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Candidate'
    ];
    //insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
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
      IP_CategoryOfWork__c = 'Catering',
      IP_ThirdPartyID__c = 'testpay12'
    );
    insert con;

    id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName()
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
    //payprofile.IP_PassToTempest__c=true;
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
    site.sirenum__Street_Address__c = 'ABC';
    site.sirenum__City__c = 'ABC';
    site.IP_InvoiceContact__c = maincon.id;
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
    jobtype.Impellam_Job_Category__c = 'Administrator -OA001';

    insert jobtype;

    sirenum__Team__c jobroll = new sirenum__Team__c();

    jobroll.name = 'testjobroll';
    jobroll.sirenum__Account__c = contract.id;
    jobroll.sirenum__Job_Type__c = jobtype.id;
    jobroll.IP_OPWIPSRole__c = 'No';
    jobroll.sirenum__Rota__c = sector.id;
    insert jobroll;

    sirenum__Placement__c spleacement = new sirenum__Placement__c();

    spleacement.Name = 'testing placment';
    spleacement.sirenum__Contact__c = con.id;
    spleacement.sirenum__Start_Date__c = Date.newInstance(2017, 11, 1);
    spleacement.sirenum__End_Date__c = Date.newInstance(2017, 12, 20);
    spleacement.sirenum__Contract__c = contract.id;
    spleacement.sirenum__Job_Role__c = jobroll.id;
    spleacement.sirenum__Site__c = site.Id;
    spleacement.sirenum__Status__c = 'Active';
    spleacement.IP_PayMethod__c = payprofile.id;
    spleacement.IP_Consultant1PercentageSplit__c = 100;
    spleacement.sirenum__Rota__c = sector.id;
    // spleacement.IP_PassToTempest__c=true;
    insert spleacement;

    IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
    setting.IP_LastTransmissionDate__c = Date.newInstance(2019, 7, 1);
    setting.IP_OutboundErrorEmailAddress__c = 'ritu.hetawal@espire.com';
    insert setting;

    insert new IP_Parallel_Payroll_Check__c(
      name = 'RunParallelCheck',
      Run_Parallel_Payroll__c = false
    );
    IP_BranchStatus__c b = new IP_BranchStatus__c();
    b.IP_BranchID__c = '1062';
    b.Name = 'Test';
    insert b;

    sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
    newTimeSheet1.sirenum__Worker__c = con.id;
    newTimesheet1.sirenum__Client__c = acc.id;
    newTimesheet1.sirenum__Team__c = jobroll.id;
    newTimesheet1.sirenum__Site__c = site.Id;
    newTimesheet1.IP_DuplicateCheckPassOK__c = true;
    newTimesheet1.IP_FlaggingCheck__c = true;
    newTimesheet1.sirenum__Week_Ending__c = Date.newInstance(2017, 11, 24);
    insert newTimeSheet1;

    sirenum__Shift__c shift = new sirenum__Shift__c();
    shift.sirenum__Site__c = site.id;
    shift.sirenum__Placement__c = spleacement.Id;
    shift.sirenum__Team__c = jobroll.id;
    shift.sirenum__Contact__c = con.id;
    shift.sirenum__Rota__c = sector.id;
    shift.sirenum__Timesheet_summaries__c = newTimesheet1.Id;
    insert shift;
    sirenum__Timesheet_Line__c sheetline = TestDataFactory.createTimeSheetLine(
      newTimeSheet1.id,
      shift.id,
      1
    )[0];
    insert sheetline;

    IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
    ob.IP_OriginRecordID__c = spleacement.id;
    ob.IP_TransferType__c = 'Assignment';
    ob.IP_Passed__c = '';
    ob.IP_TimesheetID__c = newTimesheet1.id;
    insert ob;

    IP_OutboundDataTransfer__c ob1 = new IP_OutboundDataTransfer__c();
    ob1.IP_OriginRecordID__c = payprofile.id;
    ob1.IP_TransferType__c = 'Internal Worker';
    ob1.IP_Passed__c = '';
    ob1.IP_TimesheetID__c = newTimesheet1.id;
    insert ob1;

    IP_OutboundDataTransfer__c ob2 = new IP_OutboundDataTransfer__c();
    ob2.IP_OriginRecordID__c = con.id;
    ob2.IP_TransferType__c = 'External Worker';
    ob2.IP_Passed__c = '';
    ob2.IP_TimesheetID__c = newTimesheet1.id;
    insert ob2;

    IP_OutboundDataTransfer__c ob3 = new IP_OutboundDataTransfer__c();
    ob3.IP_OriginRecordID__c = sheetline.id;
    ob3.IP_TransferType__c = 'Timesheet';
    ob3.IP_Passed__c = 'ANC';
    ob3.IP_TimesheetID__c = newTimesheet1.id;
    insert ob3;

    Test.startTest();
    delete newTimesheet1;

    Test.StopTest();
  }

  static testMethod void Test5() {
    insert new IP_CompanyCode__c(
      name = 'CompanyCode',
      IP_CompanyCodeValue__c = 'BAL'
    );
    RecordType accountRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Candidate'
    ];
    Profile Prof = [
      SELECT Id
      FROM Profile
      WHERE Name = 'JS Recruiter - Hybrid'
      LIMIT 1
    ];
    User user = new User();
    user.LastName = 'Data1';
    user.FirstName = 'TestUser';
    user.Alias = 'TstUrD';
    user.Email = 'abc.efg@GHI.com';
    user.Username = 'Emaasdil@js.com.uk';
    user.ProfileId = Prof.id;
    user.TimeZoneSidKey = 'GMT';
    user.LanguageLocaleKey = 'en_US';
    user.EmailEncodingKey = 'UTF-8';
    user.LocaleSidKey = 'en_US';
    user.IP_TempestDepartment__c = '2043';
    // user.IP_TempestID__c='1084675';
    user.IP_TempestDivision__c = 'NTS';
    user.Brand__c = 'Blue Arrow';
    user.Department = '1062';
    // user.IP_PassToTempest__c=true;
    insert user;

    Account acc1 = new Account(
      Name = 'Candidates',
      RecordTypeId = accountRec.id
    );
    insert acc1;

    TestDataFactory.setupUserProfileCustomSettings();
    insert new DefaultAccounts__c(Name = 'Candidates', Account_Id__c = acc1.Id);
    insert new IP_JSToFrostSwtich__c(
      name = 'JSToFrost',
      IP_RunJSToFrost__c = false
    );
    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

    RecordType accountRec1 = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Account'
    ];

    Account acc = new Account(Name = 'Capita', RecordTypeId = accountRec1.id);
    insert acc;
    RecordType maincondRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Contact'
    ];

    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

    Contact maincon = new Contact(
      RecordTypeId = maincondRec.id,
      FirstName = 'Test',
      LastName = 'Main COntact',
      AccountID = acc.id
    );
    insert maincon;

    /*TestDataFactory.setupUserProfileCustomSettings();
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=acc1.Id);
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);*/
    //insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

    RecordType condRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Candidate'
    ];
    //insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
    Contact con = new Contact(
      AccountID = acc1.Id,
      RecordTypeId = condRec.id,
      FirstName = 'Manish',
      Salutation = 'Mr',
      MailingCity = 'ggn',
      MailingCountry = 'india',
      Compliance_Status__c = 'Compliant',
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
      IP_CategoryOfWork__c = 'Catering',
      IP_ThirdPartyID__c = 'testpay12'
    );
    insert con;
    System.debug('compliance status' + con.Compliance_Status__c);
    id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName()
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
    //payprofile.IP_PassToTempest__c=true;
    insert payprofile;

    con.IP_LCC__c = true;
    con.Declaration_Completed__c = true;
    con.PORTW_Completed__c = true;
    con.Medical_Completed__c = true;
    update con;

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
    site.sirenum__Street_Address__c = 'ABC';
    site.sirenum__City__c = 'ABC';
    site.IP_InvoiceContact__c = maincon.id;
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
    jobtype.Impellam_Job_Category__c = 'Administrator -OA001';

    insert jobtype;

    sirenum__Team__c jobroll = new sirenum__Team__c();

    jobroll.name = 'testjobroll';
    jobroll.sirenum__Account__c = contract.id;
    jobroll.sirenum__Job_Type__c = jobtype.id;
    jobroll.IP_OPWIPSRole__c = 'No';
    jobroll.sirenum__Rota__c = sector.id;
    insert jobroll;

    sirenum__Placement__c spleacement = new sirenum__Placement__c();

    spleacement.Name = 'testing placment';
    spleacement.sirenum__Contact__c = con.id;
    spleacement.sirenum__Start_Date__c = Date.newInstance(2017, 11, 1);
    spleacement.sirenum__End_Date__c = Date.newInstance(2017, 12, 20);
    spleacement.sirenum__Contract__c = contract.id;
    spleacement.sirenum__Job_Role__c = jobroll.id;
    spleacement.sirenum__Site__c = site.Id;
    spleacement.sirenum__Status__c = 'Active';
    spleacement.IP_PayMethod__c = payprofile.id;
    spleacement.IP_Consultant1PercentageSplit__c = 100;
    spleacement.sirenum__Rota__c = sector.id;
    // spleacement.IP_PassToTempest__c=true;
    insert spleacement;

    IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
    setting.IP_LastTransmissionDate__c = Date.newInstance(2019, 7, 1);
    setting.IP_OutboundErrorEmailAddress__c = 'ritu.hetawal@espire.com';
    insert setting;

    insert new IP_Parallel_Payroll_Check__c(
      name = 'RunParallelCheck',
      Run_Parallel_Payroll__c = false
    );
    IP_BranchStatus__c b = new IP_BranchStatus__c();
    b.IP_BranchID__c = '1062';
    b.Name = 'Test';
    insert b;

    sirenum__Shift__c shift = new sirenum__Shift__c();
    shift.sirenum__Site__c = site.id;
    shift.sirenum__Placement__c = spleacement.Id;
    shift.sirenum__Team__c = jobroll.id;
    shift.sirenum__Contact__c = con.id;
    shift.sirenum__Rota__c = sector.id;
    insert shift;

    Test.startTest();
    List<sirenum__Timesheet__c> stlist = new List<sirenum__Timesheet__c>();
    //User u = [Select id from User where Profile.Name = 'Customer Portal Manager Custom' and IsActive=True limit 1];
    sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
    newTimeSheet1.sirenum__Worker__c = con.id;
    newTimeSheet1.sirenum__Client__c = acc.id;
    newTimeSheet1.sirenum__Team__c = jobroll.id;
    newTimeSheet1.sirenum__Site__c = site.Id;
    newTimeSheet1.IP_DuplicateCheckPassOK__c = true;
    newTimeSheet1.IP_FlaggingCheck__c = true;
    newTimeSheet1.sirenum__Week_Ending__c = Date.newInstance(2017, 11, 24);
    // stlist.add(newTimeSheet1);
    insert newTimeSheet1;
    /*    sirenum__Timesheet__c newTimeSheet2 = new sirenum__Timesheet__c();
        newTimeSheet2.sirenum__Worker__c = con.id;
        newTimesheet2.sirenum__Client__c=acc.id;
        newTimesheet2.sirenum__Team__c=jobroll.id;
        newTimesheet2.sirenum__Site__c=site.Id;
        newTimesheet2.IP_DuplicateCheckPassOK__c = TRUE;
        newTimesheet2.IP_FlaggingCheck__c = TRUE;
        newTimesheet2.sirenum__Week_Ending__c =Date.newInstance(2018,11,24);
        stlist.add(newTimeSheet2);*/
    // insert stlist;
    shift.sirenum__Timesheet_summaries__c = newTimeSheet1.Id;
    update shift;
    sirenum__Timesheet_Line__c sheetline = TestDataFactory.createTimeSheetLine(
      newTimeSheet1.id,
      shift.id,
      1
    )[0];

    insert sheetline;
    System.debug('check inserted Timesheet line-->' + sheetline);
    /*   sirenum__Timesheet_Line__c sheetline2 = TestDataFactory.createTimeSheetLine (newTimesheet2.id,shift.id,1)[0];
        sheetline2.IP_TimesheetSplitCheck__c = true;
        sheetline2.IP_OutboundID__c =null;
        insert sheetline2;*/
    IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
    ob.IP_OriginRecordID__c = spleacement.id;
    ob.IP_TransferType__c = 'Assignment';
    ob.IP_Passed__c = '';
    ob.IP_TimesheetID__c = newTimeSheet1.id;
    insert ob;

    IP_OutboundDataTransfer__c ob1 = new IP_OutboundDataTransfer__c();
    ob1.IP_OriginRecordID__c = payprofile.id;
    ob1.IP_TransferType__c = 'Internal Worker';
    ob1.IP_Passed__c = '';
    ob1.IP_TimesheetID__c = newTimeSheet1.id;
    insert ob1;

    IP_OutboundDataTransfer__c ob2 = new IP_OutboundDataTransfer__c();
    ob2.IP_OriginRecordID__c = con.id;
    ob2.IP_TransferType__c = 'External Worker';
    ob2.IP_Passed__c = '';
    ob2.IP_TimesheetID__c = newTimeSheet1.id;
    insert ob2;

    IP_OutboundDataTransfer__c ob3 = new IP_OutboundDataTransfer__c();
    ob3.IP_OriginRecordID__c = sheetline.id;
    ob3.IP_TransferType__c = 'Timesheet';
    ob3.IP_Passed__c = 'ANC';
    ob3.IP_TimesheetID__c = newTimeSheet1.id;
    insert ob3;
    sheetline.IP_TimesheetSplitCheck__c = true;
    update sheetline;
    newTimeSheet1.IP_EmergencyPull__c = true;
    update newTimeSheet1;
    //  TimesheetEmergencyxtract.createoutbounddata();
    TimesheetEmergencyextract.test123();
    Test.StopTest();
  }
  static testMethod void Test6() {
    insert new IP_CompanyCode__c(
      name = 'CompanyCode',
      IP_CompanyCodeValue__c = 'BAL'
    );
    RecordType accountRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Candidate'
    ];
    Account acc1 = new Account(
      Name = 'Candidates',
      RecordTypeId = accountRec.id
    );
    insert acc1;

    TestDataFactory.setupUserProfileCustomSettings();
    insert new DefaultAccounts__c(Name = 'Candidates', Account_Id__c = acc1.Id);
    insert new IP_JSToFrostSwtich__c(
      name = 'JSToFrost',
      IP_RunJSToFrost__c = false
    );
    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

    RecordType accountRec1 = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Account'
    ];

    Account acc = new Account(Name = 'Capita', RecordTypeId = accountRec1.id);
    insert acc;
    RecordType maincondRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Contact'
    ];

    //insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

    Contact maincon = new Contact(
      RecordTypeId = maincondRec.id,
      FirstName = 'Test',
      LastName = 'Main COntact',
      AccountID = acc.id
    );
    insert maincon;

    /*insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
     insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);*/

    RecordType condRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Candidate'
    ];
    //insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
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
      IP_CategoryOfWork__c = 'Catering',
      IP_ThirdPartyID__c = 'testpay12'
    );
    insert con;

    id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName()
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
    //payprofile.IP_PassToTempest__c=true;
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
    site.sirenum__Street_Address__c = 'ABC';
    site.sirenum__City__c = 'ABC';
    site.IP_InvoiceContact__c = maincon.id;
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
    jobtype.Impellam_Job_Category__c = 'Administrator -OA001';

    insert jobtype;

    sirenum__Team__c jobroll = new sirenum__Team__c();

    jobroll.name = 'testjobroll';
    jobroll.sirenum__Account__c = contract.id;
    jobroll.sirenum__Job_Type__c = jobtype.id;
    jobroll.IP_OPWIPSRole__c = 'No';
    jobroll.sirenum__Rota__c = sector.id;
    insert jobroll;

    sirenum__Placement__c spleacement = new sirenum__Placement__c();

    spleacement.Name = 'testing placment';
    spleacement.sirenum__Contact__c = con.id;
    spleacement.sirenum__Start_Date__c = Date.newInstance(2017, 11, 1);
    spleacement.sirenum__End_Date__c = Date.newInstance(2017, 12, 20);
    spleacement.sirenum__Contract__c = contract.id;
    spleacement.sirenum__Job_Role__c = jobroll.id;
    spleacement.sirenum__Site__c = site.Id;
    spleacement.sirenum__Status__c = 'Active';
    spleacement.IP_PayMethod__c = payprofile.id;
    spleacement.IP_Consultant1PercentageSplit__c = 100;
    spleacement.sirenum__Rota__c = sector.id;
    // spleacement.IP_PassToTempest__c=true;
    insert spleacement;

    IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
    setting.IP_LastTransmissionDate__c = Date.newInstance(2019, 7, 1);
    setting.IP_OutboundErrorEmailAddress__c = 'ritu.hetawal@espire.com';
    insert setting;

    insert new IP_Parallel_Payroll_Check__c(
      name = 'RunParallelCheck',
      Run_Parallel_Payroll__c = false
    );
    IP_BranchStatus__c b = new IP_BranchStatus__c();
    b.IP_BranchID__c = '1062';
    b.Name = 'Test';
    insert b;

    sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
    newTimeSheet1.sirenum__Worker__c = con.id;
    newTimesheet1.sirenum__Client__c = acc.id;
    newTimesheet1.sirenum__Team__c = jobroll.id;
    newTimesheet1.sirenum__Site__c = site.Id;
    newTimesheet1.IP_DuplicateCheckPassOK__c = true;
    newTimesheet1.IP_FlaggingCheck__c = true;
    newTimesheet1.sirenum__Week_Ending__c = Date.newInstance(2017, 11, 24);
    insert newTimeSheet1;

    sirenum__Shift__c shift = new sirenum__Shift__c();
    shift.sirenum__Site__c = site.id;
    shift.sirenum__Placement__c = spleacement.Id;
    shift.sirenum__Team__c = jobroll.id;
    shift.sirenum__Contact__c = con.id;
    shift.sirenum__Rota__c = sector.id;
    shift.sirenum__Timesheet_summaries__c = newTimesheet1.Id;
    insert shift;
    sirenum__Timesheet_Line__c sheetline = TestDataFactory.createTimeSheetLine(
      newTimeSheet1.id,
      shift.id,
      1
    )[0];
    insert sheetline;

    IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
    ob.IP_OriginRecordID__c = spleacement.id;
    ob.IP_TransferType__c = 'Assignment';
    ob.IP_Passed__c = '';
    ob.IP_TimesheetID__c = newTimesheet1.id;
    insert ob;

    IP_OutboundDataTransfer__c ob1 = new IP_OutboundDataTransfer__c();
    ob1.IP_OriginRecordID__c = payprofile.id;
    ob1.IP_TransferType__c = 'Internal Worker';
    ob1.IP_Passed__c = '';
    ob1.IP_TimesheetID__c = newTimesheet1.id;
    insert ob1;

    IP_OutboundDataTransfer__c ob2 = new IP_OutboundDataTransfer__c();
    ob2.IP_OriginRecordID__c = con.id;
    ob2.IP_TransferType__c = 'External Worker';
    ob2.IP_Passed__c = '';
    ob2.IP_TimesheetID__c = newTimesheet1.id;
    insert ob2;

    IP_OutboundDataTransfer__c ob3 = new IP_OutboundDataTransfer__c();
    ob3.IP_OriginRecordID__c = sheetline.id;
    ob3.IP_TransferType__c = 'Timesheet';
    ob3.IP_Passed__c = 'ANC';
    ob3.IP_TimesheetID__c = newTimesheet1.id;
    insert ob3;

    Test.startTest();
    sheetline.IP_TimesheetSplitCheck__c = true;
    update sheetline;
    sheetline.IP_OutboundID__c = null;
    update sheetline;
    newTimeSheet1.IP_EmergencyPull__c = true;
    update newTimeSheet1;
    sheetline.IP_OutboundID__c = null;
    update sheetline;
    Test.StopTest();
  }
  static testMethod void Test7() {
    insert new IP_CompanyCode__c(
      name = 'CompanyCode',
      IP_CompanyCodeValue__c = 'BAL'
    );
    RecordType accountRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Candidate'
    ];
    Account acc1 = new Account(
      Name = 'Candidates',
      RecordTypeId = accountRec.id
    );
    insert acc1;

    Profile backOfficeProfile = [
      SELECT Id
      FROM Profile
      WHERE Name = 'Back Office'
    ];
    User backOfficeUser = new User(
      Username = System.now().millisecond() + 'test12345@test.com',
      ProfileId = backOfficeProfile.Id,
      Alias = 'test123',
      Email = 'amit.kohli@espire.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'McTesty',
      CommunityNickname = 'test12345',
      TimeZoneSidKey = 'America/Los_Angeles',
      LocaleSidKey = 'en_US',
      LanguageLocaleKey = 'en_US'
    );

    TestDataFactory.setupUserProfileCustomSettings();
    insert new DefaultAccounts__c(Name = 'Candidates', Account_Id__c = acc1.Id);
    insert new IP_JSToFrostSwtich__c(
      name = 'JSToFrost',
      IP_RunJSToFrost__c = false
    );
    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

    RecordType accountRec1 = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Account'
    ];

    Account acc = new Account(Name = 'Capita', RecordTypeId = accountRec1.id);
    insert acc;
    RecordType maincondRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Contact'
    ];

    Contact maincon = new Contact(
      RecordTypeId = maincondRec.id,
      FirstName = 'Test',
      LastName = 'Main COntact',
      AccountID = acc.id
    );
    insert maincon;

    RecordType condRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Candidate'
    ];
    //insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
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
      IP_CategoryOfWork__c = 'Catering',
      IP_ThirdPartyID__c = 'testpay12'
    );
    insert con;

    id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName()
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
    //payprofile.IP_PassToTempest__c=true;
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
    site.sirenum__Street_Address__c = 'ABC';
    site.sirenum__City__c = 'ABC';
    site.IP_InvoiceContact__c = maincon.id;
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
    jobtype.Impellam_Job_Category__c = 'Administrator -OA001';

    insert jobtype;

    sirenum__Team__c jobroll = new sirenum__Team__c();

    jobroll.name = 'testjobroll';
    jobroll.sirenum__Account__c = contract.id;
    jobroll.sirenum__Job_Type__c = jobtype.id;
    jobroll.IP_OPWIPSRole__c = 'No';
    jobroll.sirenum__Rota__c = sector.id;
    insert jobroll;

    sirenum__Placement__c spleacement = new sirenum__Placement__c();

    spleacement.Name = 'testing placment';
    spleacement.sirenum__Contact__c = con.id;
    spleacement.sirenum__Start_Date__c = Date.newInstance(2017, 11, 1);
    spleacement.sirenum__End_Date__c = Date.newInstance(2017, 12, 20);
    spleacement.sirenum__Contract__c = contract.id;
    spleacement.sirenum__Job_Role__c = jobroll.id;
    spleacement.sirenum__Site__c = site.Id;
    spleacement.sirenum__Status__c = 'Active';
    spleacement.IP_PayMethod__c = payprofile.id;
    spleacement.IP_Consultant1PercentageSplit__c = 100;
    spleacement.sirenum__Rota__c = sector.id;
    // spleacement.IP_PassToTempest__c=true;
    insert spleacement;

    IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
    setting.IP_LastTransmissionDate__c = Date.newInstance(2019, 7, 1);
    setting.IP_OutboundErrorEmailAddress__c = 'ritu.hetawal@espire.com';
    insert setting;

    insert new IP_Parallel_Payroll_Check__c(
      name = 'RunParallelCheck',
      Run_Parallel_Payroll__c = false
    );
    IP_BranchStatus__c b = new IP_BranchStatus__c();
    b.IP_BranchID__c = '1062';
    b.Name = 'Test';
    insert b;

    sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
    newTimeSheet1.sirenum__Worker__c = con.id;
    newTimesheet1.sirenum__Client__c = acc.id;
    newTimesheet1.sirenum__Team__c = jobroll.id;
    newTimesheet1.sirenum__Site__c = site.Id;
    newTimesheet1.IP_DuplicateCheckPassOK__c = true;
    newTimesheet1.IP_FlaggingCheck__c = true;
    newTimesheet1.sirenum__Week_Ending__c = Date.newInstance(2017, 11, 24);
    insert newTimeSheet1;

    sirenum__Shift__c shift = new sirenum__Shift__c();
    shift.sirenum__Site__c = site.id;
    shift.sirenum__Placement__c = spleacement.Id;
    shift.sirenum__Team__c = jobroll.id;
    shift.sirenum__Contact__c = con.id;
    shift.sirenum__Rota__c = sector.id;
    shift.sirenum__Timesheet_summaries__c = newTimesheet1.Id;
    insert shift;
    sirenum__Timesheet_Line__c sheetline = TestDataFactory.createTimeSheetLine(
      newTimeSheet1.id,
      shift.id,
      1
    )[0];
    sheetline.IP_PassToTempest__c = true;
    insert sheetline;

    IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
    ob.IP_OriginRecordID__c = spleacement.id;
    ob.IP_TransferType__c = 'Assignment';
    ob.IP_Passed__c = '';
    ob.IP_TimesheetID__c = newTimesheet1.id;
    insert ob;

    IP_OutboundDataTransfer__c ob1 = new IP_OutboundDataTransfer__c();
    ob1.IP_OriginRecordID__c = payprofile.id;
    ob1.IP_TransferType__c = 'Internal Worker';
    ob1.IP_Passed__c = '';
    ob1.IP_TimesheetID__c = newTimesheet1.id;
    insert ob1;

    IP_OutboundDataTransfer__c ob2 = new IP_OutboundDataTransfer__c();
    ob2.IP_OriginRecordID__c = con.id;
    ob2.IP_TransferType__c = 'External Worker';
    ob2.IP_Passed__c = '';
    ob2.IP_TimesheetID__c = newTimesheet1.id;
    insert ob2;

    /*IP_OutboundDataTransfer__c ob3 = new IP_OutboundDataTransfer__c();
        ob3.IP_OriginRecordID__c = sheetline.id;
        ob3.IP_TransferType__c = 'Timesheet';
        ob3.IP_Passed__c = 'ANC';
        ob3.IP_TimesheetID__c = newTimesheet1.id;
        insert ob3;*/

    Test.startTest();
    System.runAs(backOfficeUser) {
      delete newTimesheet1;
    }
    Test.StopTest();
  }
  static testMethod void Test8() {
    insert new IP_CompanyCode__c(
      name = 'CompanyCode',
      IP_CompanyCodeValue__c = 'BAL'
    );
    RecordType accountRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Candidate'
    ];
    Account acc1 = new Account(
      Name = 'Candidates',
      RecordTypeId = accountRec.id
    );
    insert acc1;

    Profile backOfficeProfile = [
      SELECT Id
      FROM Profile
      WHERE Name = 'Back Office'
    ];
    User backOfficeUser = new User(
      Username = System.now().millisecond() + 'test12345@test.com',
      ProfileId = backOfficeProfile.Id,
      Alias = 'test123',
      Email = 'amit.kohli@espire.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'McTesty',
      CommunityNickname = 'test12345',
      TimeZoneSidKey = 'America/Los_Angeles',
      LocaleSidKey = 'en_US',
      LanguageLocaleKey = 'en_US'
    );

    TestDataFactory.setupUserProfileCustomSettings();
    insert new DefaultAccounts__c(Name = 'Candidates', Account_Id__c = acc1.Id);
    insert new IP_JSToFrostSwtich__c(
      name = 'JSToFrost',
      IP_RunJSToFrost__c = false
    );
    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

    RecordType accountRec1 = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Account'
    ];

    Account acc = new Account(Name = 'Capita', RecordTypeId = accountRec1.id);
    insert acc;
    RecordType maincondRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Contact'
    ];

    Contact maincon = new Contact(
      RecordTypeId = maincondRec.id,
      FirstName = 'Test',
      LastName = 'Main COntact',
      AccountID = acc.id
    );
    insert maincon;

    RecordType condRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Candidate'
    ];
    //insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
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
      IP_CategoryOfWork__c = 'Catering',
      IP_ThirdPartyID__c = 'testpay12'
    );
    insert con;

    id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName()
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
    //payprofile.IP_PassToTempest__c=true;
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
    site.sirenum__Street_Address__c = 'ABC';
    site.sirenum__City__c = 'ABC';
    site.IP_InvoiceContact__c = maincon.id;
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
    jobtype.Impellam_Job_Category__c = 'Administrator -OA001';

    insert jobtype;

    sirenum__Team__c jobroll = new sirenum__Team__c();

    jobroll.name = 'testjobroll';
    jobroll.sirenum__Account__c = contract.id;
    jobroll.sirenum__Job_Type__c = jobtype.id;
    jobroll.IP_OPWIPSRole__c = 'No';
    jobroll.sirenum__Rota__c = sector.id;
    insert jobroll;

    sirenum__Placement__c spleacement = new sirenum__Placement__c();

    spleacement.Name = 'testing placment';
    spleacement.sirenum__Contact__c = con.id;
    spleacement.sirenum__Start_Date__c = Date.newInstance(2017, 11, 1);
    spleacement.sirenum__End_Date__c = Date.newInstance(2017, 12, 20);
    spleacement.sirenum__Contract__c = contract.id;
    spleacement.sirenum__Job_Role__c = jobroll.id;
    spleacement.sirenum__Site__c = site.Id;
    spleacement.sirenum__Status__c = 'Active';
    spleacement.IP_PayMethod__c = payprofile.id;
    spleacement.IP_Consultant1PercentageSplit__c = 100;
    spleacement.sirenum__Rota__c = sector.id;
    // spleacement.IP_PassToTempest__c=true;
    insert spleacement;

    IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
    setting.IP_LastTransmissionDate__c = Date.newInstance(2019, 7, 1);
    setting.IP_OutboundErrorEmailAddress__c = 'ritu.hetawal@espire.com';
    insert setting;

    insert new IP_Parallel_Payroll_Check__c(
      name = 'RunParallelCheck',
      Run_Parallel_Payroll__c = false
    );
    IP_BranchStatus__c b = new IP_BranchStatus__c();
    b.IP_BranchID__c = '1062';
    b.Name = 'Test';
    insert b;

    sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
    newTimeSheet1.sirenum__Worker__c = con.id;
    newTimesheet1.sirenum__Client__c = acc.id;
    newTimesheet1.sirenum__Team__c = jobroll.id;
    newTimesheet1.sirenum__Site__c = site.Id;
    newTimesheet1.IP_DuplicateCheckPassOK__c = true;
    newTimesheet1.IP_FlaggingCheck__c = true;
    newTimesheet1.sirenum__Week_Ending__c = Date.newInstance(2017, 11, 24);
    insert newTimeSheet1;

    sirenum__Shift__c shift = new sirenum__Shift__c();
    shift.sirenum__Site__c = site.id;
    shift.sirenum__Placement__c = spleacement.Id;
    shift.sirenum__Team__c = jobroll.id;
    shift.sirenum__Contact__c = con.id;
    shift.sirenum__Rota__c = sector.id;
    shift.sirenum__Timesheet_summaries__c = newTimesheet1.Id;
    insert shift;
    sirenum__Timesheet_Line__c sheetline = TestDataFactory.createTimeSheetLine(
      newTimeSheet1.id,
      shift.id,
      1
    )[0];
    sheetline.IP_PassToTempest__c = false;
    insert sheetline;

    IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
    ob.IP_OriginRecordID__c = spleacement.id;
    ob.IP_TransferType__c = 'Timesheet';
    ob.IP_Passed__c = 'No';
    ob.IP_TimesheetID__c = newTimesheet1.id;
    insert ob;

    IP_OutboundDataTransfer__c ob1 = new IP_OutboundDataTransfer__c();
    ob1.IP_OriginRecordID__c = payprofile.id;
    ob1.IP_TransferType__c = 'Timesheet';
    ob1.IP_Passed__c = 'No';
    ob1.IP_TimesheetID__c = newTimesheet1.id;
    insert ob1;

    IP_OutboundDataTransfer__c ob2 = new IP_OutboundDataTransfer__c();
    ob2.IP_OriginRecordID__c = con.id;
    ob2.IP_TransferType__c = 'Timesheet';
    ob2.IP_Passed__c = 'No';
    ob2.IP_TimesheetID__c = newTimesheet1.id;
    insert ob2;

    /*IP_OutboundDataTransfer__c ob3 = new IP_OutboundDataTransfer__c();
        ob3.IP_OriginRecordID__c = sheetline.id;
        ob3.IP_TransferType__c = 'Timesheet';
        ob3.IP_Passed__c = 'ANC';
        ob3.IP_TimesheetID__c = newTimesheet1.id;
        insert ob3;*/

    try {
      Test.startTest();

      System.runAs(backOfficeUser) {
        update newTimesheet1;
      }
      Test.StopTest();
    } catch (Exception e) {
      System.Assert(
        e.getMessage()
          .Contains('Timesheet is locked, data is passed to Payroll')
      );
    }
  }
}