@isTest
public class UnworkedCandidateRemovalTest {
  static testMethod void AllConditionsHit() {
    Profile Prof = [
      SELECT Id
      FROM Profile
      WHERE Name = 'JS Recruiter - Hybrid'
      LIMIT 1
    ];

    Id profileId = [SELECT Id FROM Profile WHERE Name = 'User Portal' LIMIT 1]
    .Id;
    insert new User_Profile_Id__c(
      Name = 'User Portal',
      Profile_Id__c = profileId
    );
    System.debug(User_Profile_Id__c.getValues('User Portal'));

    insert new IP_ImpellamGDPRSettings__c(
      Name = 'Impellam GDPR settings',
      IP_ActivityTypesThatQualifyAsContact__c = 'Visit,Registration,General Call ,Send Email ,Send Contract',
      IP_UnworkedCandidateDataRetentionPeriod__c = -10
    );

    Account acc1 = new Account();

    RecordType accountRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Client'
    ];

    acc1.name = 'TestAccount1';
    acc1.Phone = '012034563433';
    acc1.BillingStreet = 'Street1';
    acc1.IP_Business_Type__c = 'catering';
    acc1.BillingCity = 'City1';
    acc1.BillingPostalCode = 'GU8 6LN';
    acc1.BillingState = 'State1';
    acc1.BillingCountry = 'Country1';
    acc1.RecordTypeId = accountRec.id;
    insert acc1;

    system.debug('Account Inserted');

    Account acc = new Account();

    RecordType accountRec1 = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Candidate'
    ];

    acc.Name = 'Candidates';
    acc.RecordTypeId = accountRec1.id;
    acc.Phone = '012034563436';
    acc.BillingStreet = 'Street2';
    acc.BillingCity = 'City2';
    acc.BillingPostalCode = 'GU8 6LN';
    acc.BillingState = 'State2';
    acc.BillingCountry = 'Country2';

    insert acc;

    system.debug('Account Inserted');

    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
    Recordtype recType = [
      SELECT id
      FROM Recordtype
      WHERE sobjecttype = 'contact' AND Name = 'Contact'
    ];

    contact con2 = new contact();
    con2.RecordTypeId = recType.id;
    con2.AccountId = acc1.id;
    con2.FirstName = 'Test';
    con2.LastName = 'Data';

    //  con2.IP_ContactType__c='Invoice Contact';

    insert con2;

    RecordType contRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Candidate'
    ];

    List<Contact> testContacts = new List<Contact>();
    for (Integer i = 0; i < 6; i++) {
      Contact contact = new Contact(
        Firstname = 'Test' + i,
        Lastname = 'Candidate' + i,
        accountId = acc.Id,
        Person_Status__c = 'Active',
        IP_CategoryOfWork__c = 'Catering',
        IP_GDPRWorkedCandidate__c = false,
        IP_LastContactedGDPR__c = null,
        RecordTypeId = contRec.Id
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

    DateTime dt2 = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
    Long gettime = dt2.getTime();

    User user = new User();
    user.LastName = 'Data1';
    user.FirstName = 'TestUser';
    user.Alias = 'TstUrD';
    user.Email = 'abc.efg@GHI.com';
    user.Username = 'Email' + gettime + '@js.com.uk';
    user.ProfileId = Prof.id;
    user.TimeZoneSidKey = 'GMT';
    user.LanguageLocaleKey = 'en_US';
    user.EmailEncodingKey = 'UTF-8';
    user.LocaleSidKey = 'en_US';
    user.IP_TempestDepartment__c = '2043';
    user.IP_TempestID__c = '1084675';
    user.Department = '1069';

    insert user;

    system.debug('Value in user' + user);
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
    site.sirenum__Postal_Code__c = 'GU8 6LN';
    site.sirenum__City__c = 'New Delhi';
    site.IP_PublicSector__c = 'NO';
    site.IP_MainContact__c = con2.id;
    site.IP_InvoiceContact__c = con2.id;
    site.OwnerId = user.id;
    site.IP_InvoiceAddressCity__c = 'Delhi';

    insert site;

    system.debug('Value in site' + site);

    sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
    contract.Name = 'test contract';
    contract.sirenum__Client__c = acc1.id;
    contract.sirenum__Employee__c = testContacts[0].id;

    insert contract;

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
    jobroll.sirenum__Rota__c = sector.id;
    jobroll.sirenum__AWR_Group__c = 'Group 2';
    jobroll.IP_OPWIPSRole__c = 'No';

    insert jobroll;

    RecordType perms = [
      SELECT Id
      FROM RecordType
      WHERE DeveloperName = 'Perm' AND sObjectType = 'ts2__Job__c'
    ];

    ts2__Job__c assignJob = new ts2__Job__c();
    assignJob.Name = 'Test Assignment for Job';
    assignJob.ts2__Account__c = acc1.Id;
    assignJob.IP_Fixed_Fee__c = 120;
    assignJob.sirenum_js__Site__c = site.Id;
    assignJob.ts2__Recruiter__c = user.Id;
    assignJob.ts2__Contact__c = testContacts[0].Id;
    assignJob.RecordTypeId = perms.Id;

    insert assignJob;

    sirenum__Placement__c splacement = new sirenum__Placement__c();
    splacement.Name = 'test placement ';
    splacement.sirenum__Contact__c = testContacts[0].id;
    splacement.sirenum__Start_Date__c = system.today();
    splacement.sirenum__Site__c = site.Id;
    splacement.IP_Consultant1LookupSplitShare__c = user.Id;
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

    //     sirenum__Timesheet__c time = new sirenum__Timesheet__c();

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

    sirenum__Shift__c sshift = new sirenum__Shift__c();
    sshift.sirenum__Placement__c = plcs.id;
    sshift.sirenum__Rota__c = sector.Id;
    sshift.sirenum__Team__c = jobroll.id;
    sshift.sirenum__Timesheet_summaries__c = createtimeshsheet.id;
    sshift.sirenum__Site__c = site.id;
    sshift.sirenum__Contact__c = testContacts[1].id;
    sshift.sirenum__Cancelled__c = false;
    sshift.sirenum__Published_Ever__c = true;

    insert sshift;

    system.debug('value in shift' + sshift);

    system.debug('value in Placement on shift' + sshift.sirenum__Placement__c);

    sirenum__Shift__c sshift1 = new sirenum__Shift__c();
    sshift1.sirenum__Placement__c = plcs.id;
    sshift1.sirenum__Rota__c = sector.Id;
    sshift1.sirenum__Team__c = jobroll.id;
    sshift1.sirenum__Site__c = site.id;
    sshift1.sirenum__Contact__c = testContacts[3].id;
    sshift1.sirenum__Cancelled__c = false;
    sshift1.sirenum__Published_Ever__c = true;

    insert sshift1;

    RecordType Placement = [
      SELECT Id
      FROM RecordType
      WHERE DeveloperName = 'Perm' AND sObjectType = 'ts2__Placement__c'
    ];

    ts2__Placement__c JPlacement = new ts2__Placement__c();
    JPlacement.ts2__Employee__c = testContacts[4].id;
    JPlacement.ts2extams__Substatus__c = 'Hired';
    JPlacement.ts2__Job__c = assignJob.id;
    JPlacement.sirenum_js__Site__c = site.id;
    // JPlacement.ts2__Employee__c = testContacts[4].id;
    JPlacement.ts2__Hiring_Manager__c = con2.id;
    JPlacement.ts2__Salary__c = 100;
    JPlacement.IP_FixedFeeValue__c = 120;
    JPlacement.ts2__Filled_By__c = user.id;
    JPlacement.RecordTypeId = Placement.id;
    JPlacement.ts2__Start_Date__c = system.today();

    insert JPlacement;

    //insert new IP_ImpellamGDPRSettings__c (Name='Impellam GDPR settings',IP_ActivityTypesThatQualifyAsContact__c='Visit,Registration,General Call ,Send Email ,Send Contract',IP_UnworkedCandidateDataRetentionPeriod__c=10);

    Task linkedActivity = new Task();
    linkedActivity.IP_ActivityType__c = 'Visit';
    linkedActivity.subject = 'Call';
    linkedActivity.WhoId = testContacts[3].id;

    insert linkedActivity;

    Test.startTest();
    UnworkedCandidateRemoval BC = new UnworkedCandidateRemoval();

    DataBase.executeBatch(BC);

    Test.stopTest();

    List<Contact> output = [
      SELECT Id, IP_MarkedForDeletion__c, FirstName
      FROM Contact
      WHERE IP_MarkedForDeletion__c = TRUE
    ];

    System.assertEquals(3, output.size());
  }

  static testMethod void AllConditionsHitBulk() {
    Profile Prof = [
      SELECT Id
      FROM Profile
      WHERE Name = 'JS Recruiter - Hybrid'
      LIMIT 1
    ];

    Id profileId = [SELECT Id FROM Profile WHERE Name = 'User Portal' LIMIT 1]
    .Id;
    insert new User_Profile_Id__c(
      Name = 'User Portal',
      Profile_Id__c = profileId
    );
    System.debug(User_Profile_Id__c.getValues('User Portal'));

    insert new IP_ImpellamGDPRSettings__c(
      Name = 'Impellam GDPR settings',
      IP_ActivityTypesThatQualifyAsContact__c = 'Visit,Registration,General Call ,Send Email ,Send Contract',
      IP_UnworkedCandidateDataRetentionPeriod__c = -10
    );

    Account acc1 = new Account();

    RecordType accountRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Client'
    ];

    acc1.name = 'TestAccount1';
    acc1.Phone = '012034563433';
    acc1.BillingStreet = 'Street1';
    acc1.IP_Business_Type__c = 'catering';
    acc1.BillingCity = 'City1';
    acc1.BillingPostalCode = 'GU8 6LN';
    acc1.BillingState = 'State1';
    acc1.BillingCountry = 'Country1';
    acc1.RecordTypeId = accountRec.id;
    insert acc1;

    system.debug('Account Inserted');

    Account acc = new Account();

    RecordType accountRec1 = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Candidate'
    ];

    acc.Name = 'Candidates';
    acc.RecordTypeId = accountRec1.id;
    acc.Phone = '012034563436';
    acc.BillingStreet = 'Street2';
    acc.BillingCity = 'City2';
    acc.BillingPostalCode = 'GU8 6LN';
    acc.BillingState = 'State2';
    acc.BillingCountry = 'Country2';

    insert acc;

    system.debug('Account Inserted');

    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
    Recordtype recType = [
      SELECT id
      FROM Recordtype
      WHERE sobjecttype = 'contact' AND Name = 'Contact'
    ];

    contact con2 = new contact();
    con2.RecordTypeId = recType.id;
    con2.AccountId = acc1.id;
    con2.FirstName = 'Test';
    con2.LastName = 'Data';

    //  con2.IP_ContactType__c='Invoice Contact';

    insert con2;

    RecordType contRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Candidate'
    ];

    List<Contact> testContacts = new List<Contact>();
    for (Integer i = 0; i < 15; i++) {
      Contact contact = new Contact(
        Firstname = 'Test' + i,
        Lastname = 'Candidate' + i,
        accountId = acc.Id,
        Person_Status__c = 'Active',
        IP_CategoryOfWork__c = 'Catering',
        IP_GDPRWorkedCandidate__c = false,
        IP_LastContactedGDPR__c = null,
        RecordTypeId = contRec.Id
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

    DateTime dt2 = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
    Long gettime = dt2.getTime();

    User user = new User();
    user.LastName = 'Data1';
    user.FirstName = 'TestUser';
    user.Alias = 'TstUrD';
    user.Email = 'abc.efg@GHI.com';
    user.Username = 'Email' + gettime + '@js.com.uk';
    user.ProfileId = Prof.id;
    user.TimeZoneSidKey = 'GMT';
    user.LanguageLocaleKey = 'en_US';
    user.EmailEncodingKey = 'UTF-8';
    user.LocaleSidKey = 'en_US';
    user.IP_TempestDepartment__c = '2043';
    user.IP_TempestID__c = '1084675';
    user.Department = '1069';

    insert user;

    system.debug('Value in user' + user);
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
    site.sirenum__Postal_Code__c = 'GU8 6LN';
    site.sirenum__City__c = 'New Delhi';
    site.IP_PublicSector__c = 'NO';
    site.IP_MainContact__c = con2.id;
    site.IP_InvoiceContact__c = con2.id;
    site.OwnerId = user.id;
    site.IP_InvoiceAddressCity__c = 'Delhi';

    insert site;

    system.debug('Value in site' + site);

    sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
    contract.Name = 'test contract';
    contract.sirenum__Client__c = acc1.id;
    contract.sirenum__Employee__c = testContacts[0].id;

    insert contract;

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
    jobroll.sirenum__Rota__c = sector.id;
    jobroll.sirenum__AWR_Group__c = 'Group 2';
    jobroll.IP_OPWIPSRole__c = 'No';

    insert jobroll;

    RecordType perms = [
      SELECT Id
      FROM RecordType
      WHERE DeveloperName = 'Perm' AND sObjectType = 'ts2__Job__c'
    ];

    ts2__Job__c assignJob = new ts2__Job__c();
    assignJob.Name = 'Test Assignment for Job';
    assignJob.ts2__Account__c = acc1.Id;
    assignJob.IP_Fixed_Fee__c = 120;
    assignJob.sirenum_js__Site__c = site.Id;
    assignJob.ts2__Recruiter__c = user.Id;
    assignJob.ts2__Contact__c = testContacts[0].Id;
    assignJob.RecordTypeId = perms.Id;

    insert assignJob;

    sirenum__Placement__c splacement = new sirenum__Placement__c();
    splacement.Name = 'test placement ';
    splacement.sirenum__Contact__c = testContacts[0].id;
    splacement.sirenum__Start_Date__c = system.today();
    splacement.sirenum__Site__c = site.Id;
    splacement.IP_Consultant1LookupSplitShare__c = user.Id;
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

    //     sirenum__Timesheet__c time = new sirenum__Timesheet__c();

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

    sirenum__Shift__c sshift = new sirenum__Shift__c();
    sshift.sirenum__Placement__c = plcs.id;
    sshift.sirenum__Rota__c = sector.Id;
    sshift.sirenum__Team__c = jobroll.id;
    sshift.sirenum__Timesheet_summaries__c = createtimeshsheet.id;
    sshift.sirenum__Site__c = site.id;
    sshift.sirenum__Contact__c = testContacts[1].id;
    sshift.sirenum__Cancelled__c = false;
    sshift.sirenum__Published_Ever__c = true;

    insert sshift;

    system.debug('value in shift' + sshift);

    system.debug('value in Placement on shift' + sshift.sirenum__Placement__c);

    List<sirenum__Shift__c> shiftList = new List<sirenum__Shift__c>();

    //Add a bulk of shifts with assigned contacts
    for (integer i = 0; i < 5; i++) {
      sirenum__Shift__c sshift1 = new sirenum__Shift__c();
      sshift1.sirenum__Placement__c = plcs.id;
      sshift1.sirenum__Rota__c = sector.Id;
      sshift1.sirenum__Team__c = jobroll.id;
      sshift1.sirenum__Site__c = site.id;
      sshift1.sirenum__Contact__c = testContacts[i + 5].id;
      sshift1.sirenum__Cancelled__c = false;
      sshift1.sirenum__Published_Ever__c = true;

      shiftList.add(sshift1);
    }

    insert shiftList;

    RecordType Placement = [
      SELECT Id
      FROM RecordType
      WHERE DeveloperName = 'Perm' AND sObjectType = 'ts2__Placement__c'
    ];

    ts2__Placement__c JPlacement = new ts2__Placement__c();
    JPlacement.ts2__Employee__c = testContacts[4].id;
    JPlacement.ts2extams__Substatus__c = 'Hired';
    JPlacement.ts2__Job__c = assignJob.id;
    JPlacement.sirenum_js__Site__c = site.id;
    // JPlacement.ts2__Employee__c = testContacts[4].id;
    JPlacement.ts2__Hiring_Manager__c = con2.id;
    JPlacement.ts2__Salary__c = 100;
    JPlacement.IP_FixedFeeValue__c = 120;
    JPlacement.ts2__Filled_By__c = user.id;
    JPlacement.RecordTypeId = Placement.id;
    JPlacement.ts2__Start_Date__c = system.today();

    insert JPlacement;

    //insert new IP_ImpellamGDPRSettings__c (Name='Impellam GDPR settings',IP_ActivityTypesThatQualifyAsContact__c='Visit,Registration,General Call ,Send Email ,Send Contract',IP_UnworkedCandidateDataRetentionPeriod__c=10);

    Task linkedActivity = new Task();
    linkedActivity.IP_ActivityType__c = 'Visit';
    linkedActivity.subject = 'Call';
    linkedActivity.WhoId = testContacts[3].id;

    insert linkedActivity;

    Test.startTest();
    UnworkedCandidateRemoval BC = new UnworkedCandidateRemoval();

    DataBase.executeBatch(BC);

    Test.stopTest();

    List<Contact> output = [
      SELECT Id, IP_MarkedForDeletion__c, FirstName
      FROM Contact
      WHERE IP_MarkedForDeletion__c = TRUE
    ];

    System.assertEquals(7, output.size());
  }

  /*
    Input: contact with linked s-placement that has a site with a timesheeting method of 'Client'
    Expected Output: the record should not be marked for deletion
  */
  @IsTest
  static void sPlacementClientShouldNotBeDeleted() {
    Profile Prof = [
      SELECT Id
      FROM Profile
      WHERE Name = 'JS Recruiter - Hybrid'
      LIMIT 1
    ];

    Id profileId = [SELECT Id FROM Profile WHERE Name = 'User Portal' LIMIT 1]
    .Id;
    insert new User_Profile_Id__c(
      Name = 'User Portal',
      Profile_Id__c = profileId
    );
    System.debug(User_Profile_Id__c.getValues('User Portal'));

    insert new IP_ImpellamGDPRSettings__c(
      Name = 'Impellam GDPR settings',
      IP_ActivityTypesThatQualifyAsContact__c = 'Visit,Registration,General Call ,Send Email ,Send Contract',
      IP_UnworkedCandidateDataRetentionPeriod__c = -10
    );

    Account acc1 = new Account();

    RecordType accountRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Client'
    ];

    acc1.name = 'TestAccount1';
    acc1.Phone = '012034563433';
    acc1.BillingStreet = 'Street1';
    acc1.IP_Business_Type__c = 'catering';
    acc1.BillingCity = 'City1';
    acc1.BillingPostalCode = 'GU8 6LN';
    acc1.BillingState = 'State1';
    acc1.BillingCountry = 'Country1';
    acc1.RecordTypeId = accountRec.id;
    insert acc1;

    system.debug('Account Inserted');

    Account acc = new Account();

    RecordType accountRec1 = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Candidate'
    ];

    acc.Name = 'Candidates';
    acc.RecordTypeId = accountRec1.id;
    acc.Phone = '012034563436';
    acc.BillingStreet = 'Street2';
    acc.BillingCity = 'City2';
    acc.BillingPostalCode = 'GU8 6LN';
    acc.BillingState = 'State2';
    acc.BillingCountry = 'Country2';

    insert acc;

    system.debug('Account Inserted');

    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
    Recordtype recType = [
      SELECT id
      FROM Recordtype
      WHERE sobjecttype = 'contact' AND Name = 'Contact'
    ];

    contact con2 = new contact();
    con2.RecordTypeId = recType.id;
    con2.AccountId = acc1.id;
    con2.FirstName = 'Test';
    con2.LastName = 'Data';

    //  con2.IP_ContactType__c='Invoice Contact';

    insert con2;

    RecordType contRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Candidate'
    ];

    Contact contact = new Contact(
      Firstname = 'Test',
      Lastname = 'Candidate',
      accountId = acc.Id,
      Person_Status__c = 'Active',
      IP_CategoryOfWork__c = 'Catering',
      IP_GDPRWorkedCandidate__c = false,
      IP_LastContactedGDPR__c = System.Today().addDays(-400),
      RecordTypeId = contRec.Id
    );
    insert contact;

    IP_TopazGlobalClientInformation__c createtopaz = new IP_TopazGlobalClientInformation__c();
    createtopaz.name = 'TestClient2';
    createtopaz.IP_StatusID__c = 1;
    createtopaz.IP_SalesLedgerNumber__c = '123456';

    insert createtopaz;

    DateTime dt2 = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
    Long gettime = dt2.getTime();

    User user = new User();
    user.LastName = 'Data1';
    user.FirstName = 'TestUser';
    user.Alias = 'TstUrD';
    user.Email = 'abc.efg@GHI.com';
    user.Username = 'Email' + gettime + '@js.com.uk';
    user.ProfileId = Prof.id;
    user.TimeZoneSidKey = 'GMT';
    user.LanguageLocaleKey = 'en_US';
    user.EmailEncodingKey = 'UTF-8';
    user.LocaleSidKey = 'en_US';
    user.IP_TempestDepartment__c = '2043';
    user.IP_TempestID__c = '1084675';
    user.Department = '1069';

    insert user;

    system.debug('Value in user' + user);
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
    site.sirenum__Postal_Code__c = 'GU8 6LN';
    site.sirenum__City__c = 'New Delhi';
    site.IP_PublicSector__c = 'NO';
    site.IP_MainContact__c = con2.id;
    site.IP_InvoiceContact__c = con2.id;
    site.OwnerId = user.id;
    site.IP_InvoiceAddressCity__c = 'Delhi';
    site.IP_Timesheet_Method__c = 'Client';

    insert site;

    system.debug('Value in site' + site);

    sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
    contract.Name = 'test contract';
    contract.sirenum__Client__c = acc1.id;
    contract.sirenum__Employee__c = contact.id;

    insert contract;

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
    jobroll.sirenum__Rota__c = sector.id;
    jobroll.sirenum__AWR_Group__c = 'Group 2';
    jobroll.IP_OPWIPSRole__c = 'No';

    insert jobroll;

    sirenum__Placement__c splacement = new sirenum__Placement__c();
    splacement.Name = 'test placement ';
    splacement.sirenum__Contact__c = contact.id;
    splacement.sirenum__Start_Date__c = system.today();
    splacement.sirenum__Site__c = site.Id;
    splacement.IP_Consultant1LookupSplitShare__c = user.Id;
    splacement.IP_Consultant1PercentageSplit__c = 100;
    splacement.sirenum__Contract__c = contract.id;
    splacement.sirenum__Job_Role__c = jobroll.id;
    splacement.sirenum__Status__c = 'Active';

    insert splacement;

    Test.startTest();
    UnworkedCandidateRemoval BC = new UnworkedCandidateRemoval();
    DataBase.executeBatch(BC);
    Test.stopTest();

    List<Contact> output = [
      SELECT Id, IP_MarkedForDeletion__c, FirstName
      FROM Contact
      WHERE IP_MarkedForDeletion__c = TRUE
    ];

    System.assertEquals(0, output.size());
  }
}