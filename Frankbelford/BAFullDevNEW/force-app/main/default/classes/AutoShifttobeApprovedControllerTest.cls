@isTest
public class AutoShifttobeApprovedControllerTest {
  static testMethod void testMethod1() {
    insert new List<User_Profile_Id__c>{
      new User_Profile_Id__c(
        Name = 'Client Portal User',
        Profile_Id__c = '00e3H000000DkrQQAS'
      ),
      new User_Profile_Id__c(
        Name = 'User Portal',
        Profile_Id__c = '00e0Y000000QNyxQAG'
      )
    };
    //USER RECORD - RECRUITER PROFILE Name='JS Recruiter - Hybrid'
    User_Profile_Id__c recProfile = new User_Profile_Id__c();
    recProfile.Name = 'JS Recruiter - Hybrid';
    recProfile.Profile_Id__c = '00e0Y000000viGlQAI';

    User_Profile_Id__c sysAdminProfile = new User_Profile_Id__c();
    sysAdminProfile.Name = 'System Administrator';
    sysAdminProfile.Profile_Id__c = '00e0Y000000viGiQAI';
    insert new List<User_Profile_Id__c>{ recProfile, sysAdminProfile };

    User consultantUser = TestDataFactory.createUsers(
      (Id) recProfile.Profile_Id__c,
      1
    )[0];
    consultantUser.IP_TempestDepartment__c = '1000';
    insert consultantUser;

    Account acc = new Account();
    //RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate'];
    Id accountRec1Id = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Candidate')
      .recordTypeId;
    acc.Name = 'Candidates';
    acc.RecordTypeId = accountRec1Id;
    acc.Phone = '012034563436';
    acc.BillingStreet = 'Street2';
    acc.BillingCity = 'City2';
    acc.BillingPostalCode = 'NR18 2TF';
    acc.BillingState = 'State2';
    acc.BillingCountry = 'Country2';
    //insert acc;
    system.debug('Account Inserted');

    insert new IP_JSToFrostSwtich__c(
      name = 'JSToFrost',
      IP_RunJSToFrost__c = true
    );
    insert new Payroll_Swtich__c(Name = 'Stoppayroll', Batch_check__c = false);
    insert new IP_ImpellamGDPRSettings__c(
      Name = 'Impellam GDPR settings',
      IP_ActivityTypesThatQualifyAsContact__c = 'Visit,Registration,General Call ,Send Email ,Send Contract',
      IP_UnworkedCandidateDataRetentionPeriod__c = -10
    );

    Date dateToday = system.today();
    Account acc1 = new Account();
    //RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client'];
    Id accountRecId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Client')
      .recordTypeId;
    acc1.name = 'TestAccount1';
    acc1.Phone = '012034563433';
    acc1.BillingStreet = 'Street1';
    acc1.IP_Business_Type__c = 'catering';
    acc1.BillingCity = 'City1';
    acc1.BillingPostalCode = 'NR18 2TF';
    acc1.BillingState = 'State1';
    acc1.BillingCountry = 'Country1';
    acc1.RecordTypeId = accountRecId;
    //insert acc1;

    insert new List<Account>{ acc, acc1 };
    system.debug('Account Inserted');
    insert new DefaultAccounts__c(Name = 'Candidates', Account_Id__c = acc.Id);

    //Recordtype recType = [Select id from Recordtype where sobjecttype = 'contact' and Name = 'Contact'];
    Id recTypeId = Schema.SObjecttype.Contact.getRecordTypeInfosByDeveloperName()
      .get('Contact')
      .recordTypeId;
    contact con2 = new contact();
    con2.RecordTypeId = recTypeId;
    con2.AccountId = acc1.id;
    con2.FirstName = 'Test';
    con2.LastName = 'Data';
    con2.IP_ContactType__c = 'Invoice Contact';
    con2.Email = 'test' + System.now().millisecond() + 'test123@test.com'; //System.now().millisecond() + 'test@test.com';
    //insert con2;

    List<Contact> testContacts = new List<Contact>{ con2 };
    //RecordType contRec = [Select Id From RecordType Where sObjectType = 'Contact' And DeveloperName = 'Candidate'];
    Id contRecId = Schema.sObjectType.Contact.getRecordTypeInfosByDeveloperName()
      .get('Candidate')
      .recordTypeId;
    for (Integer i = 0; i < 6; i++) {
      Contact contact = new Contact(
        Firstname = 'Test' + i,
        Lastname = 'Candidate' + i,
        accountId = acc.Id,
        Person_Status__c = 'Active',
        IP_CategoryOfWork__c = 'Catering',
        IP_GDPRWorkedCandidate__c = false,
        IP_LastContactedGDPR__c = null,
        RecordTypeId = contRecId
      );
      testContacts.add(contact);
    }
    insert testContacts;
    system.debug('test data factory  Candidate--' + testContacts);

    IP_TopazGlobalClientInformation__c createtopaz = new IP_TopazGlobalClientInformation__c();
    createtopaz.name = 'TestClient2';
    createtopaz.IP_StatusID__c = 1;
    createtopaz.IP_SalesLedgerNumber__c = '123456';
    insert createtopaz;

    sirenum__Rota__c sector = new sirenum__Rota__c();
    sector.Name = 'new sector';
    insert sector;

    sirenum__Site__c site = new sirenum__Site__c();
    site.Name = 'testsite';
    site.sirenum__Operating_Company__c = acc1.id;
    site.IP_ClientIDLegacy__c = '123';
    site.IP_ClientInvoiceName__c = 'Test Invoice';
    site.IP_InvoiceAddressStreet__c = 'Test Street';
    site.IP_PublicSector__c = 'No';
    site.GlobalClientName__c = createtopaz.Id;
    site.sirenum__Postal_Code__c = 'NR18 2TF';
    site.sirenum__City__c = 'New Delhi';
    site.IP_PublicSector__c = 'NO';
    site.IP_MainContact__c = con2.id;
    site.IP_InvoiceContact__c = con2.id;
    site.OwnerId = consultantUser.id;
    site.IP_InvoiceAddressCity__c = 'Delhi';
    site.IP_Timesheet_Method__c = 'eTimesheet';
    site.IP_ScheduledAutoApproval__c = true;
    insert site;
    system.debug('Value in site' + site);

    sirenum__Payroll_Cycle__c payrolcycle = new sirenum__Payroll_Cycle__c();
    payrolcycle.Name = 'Monday to Sunday';
    payrolcycle.sirenum__StartingDate__c = dateToday.addDays(-7);
    payrolcycle.sirenum__periodLength__c = 7;
    payrolcycle.sirenum__CyclePeriodUnits__c = 'Weeks';
    insert payrolcycle;

    sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
    contract.Name = 'test contract';
    contract.sirenum__Client__c = acc1.id;
    contract.sirenum__Employee__c = testContacts[0].id;
    contract.sirenum__PayrollCycle__c = payrolcycle.id;
    insert contract;

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
    jobroll.sirenum__Rota__c = sector.id;
    jobroll.sirenum__AWR_Group__c = 'Group 2';
    jobroll.IP_OPWIPSRole__c = 'No';
    insert jobroll;

    TR1__Job__c assignJob = new TR1__Job__c();
    //RecordType perms = [Select Id From RecordType Where DeveloperName = 'Perm' and sObjectType = 'TR1__Job__c'];
    Id permsId = Schema.SObjectType.TR1__Job__c.getRecordTypeInfosByDeveloperName()
      .get('Perm')
      .recordTypeId;
    assignJob.Name = 'Test Assignment for Job';
    assignJob.TR1__Account__c = acc1.Id;
    assignJob.IP_Fixed_Fee__c = 120;
    assignJob.s5m__Site__c = site.Id;
    assignJob.TR1__Contact__c = testContacts[0].Id;
    assignJob.RecordTypeId = permsId;
    assignJob.TR1__Sourcing_Recruiter__c = consultantUser.Id;
    insert assignJob;

    sirenum__Placement__c splacement = new sirenum__Placement__c();
    splacement.Name = 'test placement ';
    splacement.sirenum__Contact__c = testContacts[0].id;
    splacement.sirenum__Start_Date__c = system.today();
    splacement.sirenum__Site__c = site.Id;
    splacement.IP_Consultant1LookupSplitShare__c = consultantUser.Id;
    splacement.IP_Consultant1PercentageSplit__c = 100;
    splacement.sirenum__Contract__c = contract.id;
    splacement.sirenum__Job_Role__c = jobroll.id;
    insert splacement;
    System.debug(
      'Value in Consultantidno1' +
      splacement.IP_Consultant1IDnumberSplitShare__c
    );
    System.debug(
      'Value in Consultantidno1' + splacement.IP_Consultant1LookupSplitShare__c
    );
    System.debug(
      'Value in Consultantidno1' +
      splacement.IP_Consultant1LookupSplitShare__r.IP_TempestID__c
    );

    sirenum__Placement__c plcs = [
      SELECT
        id,
        IP_Consultant1IDnumberSplitShare__c,
        IP_Consultant1LookupSplitShare__c
      FROM sirenum__Placement__c
      WHERE id = :splacement.id
    ];
    System.debug('Value in Consultantidno1swati' + plcs);

    sirenum__Timesheet__c createtimeshsheet = new sirenum__Timesheet__c();
    createtimeshsheet.sirenum__Client__c = acc1.id;
    createtimeshsheet.sirenum__Worker__c = testContacts[1].id;
    createtimeshsheet.sirenum__Team__c = jobroll.id;
    createtimeshsheet.sirenum__Site__c = site.id;
    createtimeshsheet.sirenum__Week_Ending__c = system.today();
    createtimeshsheet.sirenum__Non_Taxed_Expenses__c = 34.2;
    createtimeshsheet.sirenum__Taxed_Expenses__c = 22.2;
    createtimeshsheet.sirenum__Non_Taxed_Deductions__c = 22.0;
    createtimeshsheet.sirenum__Taxed_Deductions__c = 22.1;
    insert createtimeshsheet;
    system.debug('Value in createtimeshsheet' + createtimeshsheet);

    //Monday Shift
    sirenum__Shift__c sshift = new sirenum__Shift__c();
    sshift.sirenum__Placement__c = plcs.id;
    sshift.sirenum__Rota__c = sector.Id;
    sshift.sirenum__Team__c = jobroll.id;
    sshift.sirenum__Timesheet_summaries__c = createtimeshsheet.id;
    sshift.sirenum__Site__c = site.id;
    sshift.sirenum__Published__c = true;
    sshift.sirenum__Contact__c = testContacts[2].id;
    sshift.sirenum__Cancelled__c = false;
    sshift.sirenum__Published_Ever__c = true;
    sshift.sirenum__Scheduled_Start_Time__c = dateToday.addDays(-7);
    sshift.sirenum__Scheduled_End_Time__c = dateToday.addDays(-7);
    sshift.sirenum__Actual_Start_Time__c = dateToday.addDays(-7);
    sshift.sirenum__Actual_End_Time__c = dateToday.addDays(-7);
    sshift.IP_CandidateApproved__c = true;
    sshift.IP_ClientRejected__c = false;
    sshift.sirenum__Allow_pay__c = false;
    sshift.sirenum__Allow_charge__c = false;
    //insert sshift;

    sirenum__Shift__c sshift2 = new sirenum__Shift__c();
    sshift2.sirenum__Placement__c = plcs.id;
    sshift2.sirenum__Rota__c = sector.Id;
    sshift2.sirenum__Team__c = jobroll.id;
    sshift2.sirenum__Timesheet_summaries__c = createtimeshsheet.id;
    sshift2.sirenum__Site__c = site.id;
    sshift2.sirenum__Published__c = true;
    sshift2.sirenum__Contact__c = testContacts[2].id;
    sshift2.sirenum__Cancelled__c = false;
    sshift2.sirenum__Published_Ever__c = true;
    sshift2.sirenum__Scheduled_Start_Time__c = dateToday.addDays(-7);
    sshift2.sirenum__Scheduled_End_Time__c = dateToday.addDays(-7);
    sshift2.sirenum__Actual_Start_Time__c = dateToday.addDays(-7);
    sshift2.sirenum__Actual_End_Time__c = dateToday.addDays(-7);
    sshift2.sirenum__Billable_Start_Time__c = dateToday.addDays(-7);
    sshift2.sirenum__Billable_End_Time__c = dateToday.addDays(-7);
    sshift2.IP_CandidateApproved__c = true;
    sshift2.IP_ClientApproved__c = true;
    sshift2.IP_ClientRejected__c = false;
    sshift2.sirenum__Allow_pay__c = false;
    sshift2.sirenum__Allow_charge__c = false;
    //insert sshift2;

    sirenum__Shift__c sshift3 = new sirenum__Shift__c();
    sshift3.sirenum__Placement__c = plcs.id;
    sshift3.sirenum__Rota__c = sector.Id;
    sshift3.sirenum__Team__c = jobroll.id;
    sshift3.sirenum__Timesheet_summaries__c = createtimeshsheet.id;
    sshift3.sirenum__Site__c = site.id;
    sshift3.sirenum__Published__c = true;
    sshift3.sirenum__Contact__c = testContacts[2].id;
    sshift3.sirenum__Cancelled__c = false;
    sshift3.sirenum__Published_Ever__c = true;
    sshift3.sirenum__Scheduled_Start_Time__c = dateToday.addDays(-9);
    sshift3.sirenum__Scheduled_End_Time__c = dateToday.addDays(-9);
    sshift3.sirenum__Actual_Start_Time__c = dateToday.addDays(-9);
    sshift3.sirenum__Actual_End_Time__c = dateToday.addDays(-9);
    sshift3.IP_CandidateApproved__c = true;
    sshift3.IP_ClientRejected__c = false;
    sshift3.sirenum__Allow_pay__c = false;
    sshift3.sirenum__Allow_charge__c = false;
    //insert sshift3;

    sirenum__Shift__c sshift4 = new sirenum__Shift__c();
    sshift4.sirenum__Placement__c = plcs.id;
    sshift4.sirenum__Rota__c = sector.Id;
    sshift4.sirenum__Team__c = jobroll.id;
    sshift4.sirenum__Timesheet_summaries__c = createtimeshsheet.id;
    sshift4.sirenum__Site__c = site.id;
    sshift4.sirenum__Published__c = true;
    sshift4.sirenum__Contact__c = testContacts[2].id;
    sshift4.sirenum__Cancelled__c = false;
    sshift4.sirenum__Published_Ever__c = true;
    sshift4.sirenum__Scheduled_Start_Time__c = dateToday.addDays(-9);
    sshift4.sirenum__Scheduled_End_Time__c = dateToday.addDays(-9);
    sshift4.sirenum__Actual_Start_Time__c = dateToday.addDays(-9);
    sshift4.sirenum__Actual_End_Time__c = dateToday.addDays(-9);
    sshift4.sirenum__Billable_Start_Time__c = dateToday.addDays(-9);
    sshift4.sirenum__Billable_End_Time__c = dateToday.addDays(-9);
    sshift4.IP_CandidateApproved__c = true;
    sshift4.IP_ClientApproved__c = true;
    sshift4.IP_ClientRejected__c = false;
    sshift4.sirenum__Allow_pay__c = false;
    sshift4.sirenum__Allow_charge__c = false;
    //insert sshift4;

    insert new List<sirenum__Shift__c>{ sshift, sshift2, sshift3, sshift4 };

    Contact_Site_link__c csl = new Contact_Site_link__c();
    csl.Account__c = acc1.id;
    csl.IP_Contact__c = con2.id;
    csl.IP_PortalType__c = 'Primary Hours Approver';
    csl.IP_Site__c = site.id;
    insert csl;

    Test.startTest();
    String clientPortalUserProfile = System.Label.Client_Portal_User_Profile;
    Profile portalProfile = [
      SELECT Id
      FROM Profile
      WHERE Name = :clientPortalUserProfile
      LIMIT 1
    ];
    User user1 = new User(
      Username = con2.Email,
      ContactId = con2.Id,
      ProfileId = (Id) portalProfile.Id,
      Alias = 'test123',
      Email = con2.Email, // 'amit.kohli@espire_test.com',
      EmailEncodingKey = 'UTF-8',
      LastName = con2.LastName,
      CommunityNickname = 'test12345' + System.now().millisecond(),
      TimeZoneSidKey = 'America/Los_Angeles',
      LocaleSidKey = 'en_US',
      LanguageLocaleKey = 'en_US'
    );
    Database.insert(user1);

    System.runAs(user1) {
      AutoShifttobeApprovedController objController = new AutoShifttobeApprovedController();
      objController.recipient_Id = user1.id;
      objController.NoOfShifts = 5;
      objController.Name = 'test';
      objController.Shiftdetails = null;
      objController.user1 = null;
      objController.getuserDetails();
      objController.getusercount();
    }
    Test.stopTest();
  }
}