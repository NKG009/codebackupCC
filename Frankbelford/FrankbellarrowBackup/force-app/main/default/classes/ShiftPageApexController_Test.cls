@isTest
public class ShiftPageApexController_Test {
  @testSetup
  static void shiftSetup() {
    //Create portal account owner
    UserRole portalRole = [
      SELECT Id
      FROM UserRole
      WHERE PortalType = 'None'
      LIMIT 1
    ];
    Profile profile1 = [
      SELECT Id
      FROM Profile
      WHERE name = 'System Administrator'
    ];

    User portalAccountOwner1 = new User(
      UserRoleId = portalRole.Id,
      ProfileId = profile1.Id,
      Username = System.now().millisecond() + 2 + 'test2@test.com',
      Alias = 'batman',
      Email = 'bruce.wayne@wayneenterprises.com',
      EmailEncodingKey = 'UTF-8',
      Firstname = 'Bruce',
      Lastname = 'Wayne',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      TimeZoneSidKey = 'America/Chicago',
      IP_TempestDepartment__c = '1233'
    );
    insert portalAccountOwner1;
    System.debug(
      [
        SELECT UserType
        FROM User
        WHERE Email = 'bruce.wayne@wayneenterprises.com'
      ]
    );
    Contact contact1;
    Contact contact2;
    Contact contact3;
    System.runAs(portalAccountOwner1) {
      //Create account
      Account portalAccount1 = new Account(
        Name = 'TestAccount',
        OwnerId = portalAccountOwner1.Id
      );
      Database.insert(portalAccount1);
      insert new Payroll_Swtich__c(Name = 'Stoppayroll', Batch_check__c = true);

      //Create contact
      contact1 = new Contact(
        FirstName = 'Test1',
        Lastname = 'McTesty',
        AccountId = portalAccount1.Id,
        Email = System.now().millisecond() + 'test@test.com'
      );
      Database.insert(contact1);
      //Create contact
      contact2 = new Contact(
        FirstName = 'Test2',
        Lastname = 'McTesty2',
        AccountId = portalAccount1.Id,
        Email = 'test2' + System.now().millisecond() + 'test2@test.com'
      );
      Database.insert(contact2);
      //Create contact
      contact3 = new Contact(
        FirstName = 'Test3',
        Lastname = 'McTesty3',
        AccountId = portalAccount1.Id,
        Email = 'test3' + System.now().millisecond() + 'test3@test.com'
      );
      Database.insert(contact3);
    }
    //Create user
    Profile portalProfile = [
      SELECT Id
      FROM Profile
      WHERE Name LIKE '%Customer Community User%'
      LIMIT 1
    ];
    User user1 = new User(
      Username = System.now().millisecond() + 'test12345@test.com',
      ContactId = contact1.Id,
      ProfileId = portalProfile.Id,
      Alias = 'test123',
      Email = 'amit.kohli@espire.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'McTesty',
      CommunityNickname = 'test12345',
      TimeZoneSidKey = 'America/Los_Angeles',
      LocaleSidKey = 'en_US',
      LanguageLocaleKey = 'en_US'
    );
    Database.insert(user1);
  }

  @istest
  static void shifthistory1() {
    insert new IP_Shift_Template__c(
      name = '1233',
      Email__c = 'singh.taji26@gmail.com'
    );
    User u = [
      SELECT id, contactId
      FROM user
      WHERE email = 'bruce.wayne@wayneenterprises.com'
      LIMIT 1
    ];

    Account acct1 = TestDataFactory.createAccounts(3)[2];
    insert acct1;
    Account acct = TestDataFactory.createCandidateAccount(1)[0];
    insert acct;
    insert new Payroll_Swtich__c(Name = 'Stoppayroll', Batch_check__c = true);
    RecordType accRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Account'
    ];
    Account acct11 = new Account(
      IP_Business_Type__c = 'Catering',
      Name = 'Account Name',
      RecordTypeId = accRec.id,
      IP_BusinessIncorporationNumber__c = '12345678'
    );
    Database.insert(acct11);
    Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];
    insert cond;
    Recordtype recType = [
      SELECT id
      FROM Recordtype
      WHERE sobjecttype = 'contact' AND Name = 'Contact'
    ];
    contact con2 = new contact();
    con2.RecordTypeId = recType.id;
    con2.AccountId = acct11.id;
    con2.FirstName = 'Test';
    con2.LastName = 'Data';
    con2.IP_ContactType__c = 'Invoice Contact';
    insert con2;

    IP_TopazGlobalClientInformation__c tgci = new IP_TopazGlobalClientInformation__c(
      name = 'MyClient',
      IP_StatusID__c = 1,
      IP_SalesLedgerNumber__c = '1234567890'
    );
    Database.insert(tgci);

    //IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0];

    // Insert tgci;

    //sirenum__Site__c sites =  TestDataFactory.createSites(acct.id, tgci.id, 1)[0];
    // sites.ownerId = u.id;
    sirenum__Site__c sites = new sirenum__Site__c(
      Name = 'my site',
      IP_InvoiceAddressCity__c = 'ballia',
      IP_InvoiceAddressStreet__c = 'street1',
      sirenum__Operating_Company__c = acct.Id,
      GlobalClientName__c = tgci.Id,
      IP_ClientIDLegacy__c = 'eww3',
      IP_Clientinvoicename__c = 'invoice name',
      IP_InvoiceAddressCountry__c = 'ind',
      IP_InvoiceAddressCounty__c = 'cnt',
      IP_InvoiceAddressPostcode__c = '23d fdd',
      IP_PublicSector__c = 'No',
      IP_PassClientToTempest__c = false,
      IP_ClientLastPassedToTempest__c = date.today(),
      Credit_Status__c = 'Credit Approved',
      IP_PassClientAddressToTempest__c = true,
      IP_ClientAddressLastPassedToTempest__c = date.today()
    );
    Database.insert(sites);

    //sites.sirenum__Operating_Company__c = [select id,name from Account where name = 'TestAccount' limit 1][0].id;
    //Insert sites;

    sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(
      acct.id,
      cond.id,
      1
    )[0];
    insert pac;

    sirenum__Rota__c rota = TestDataFactory.createSector(1)[0];
    insert rota;

    sirenum__Job_Type__c job = TestDataFactory.createJobType(rota.id, 1)[0];
    insert job;

    sirenum__Team__c tm = TestDataFactory.createJobRole(pac.id, job.id, 1)[0];
    insert tm;

    sirenum__Placement__c splacement = TestDataFactory.createSPlacement1(
      cond.id,
      pac.id,
      tm.id,
      u.id,
      1
    )[0];
    splacement.sirenum__Site__c = sites.id;
    splacement.IP_Consultant1LookupSplitShare__c = u.id;
    insert splacement;

    List<sirenum__Shift__c> shftListhistory = TestDataFactory.createShift(
      splacement.id,
      sites.id,
      7
    );
    List<contact> conId1 = [
      SELECT id, name
      FROM contact
      WHERE lastname LIKE 'McTesty%'
      LIMIT 5
    ];
    shftListhistory[0].sirenum__Contact__c = conId1[0].id;
    shftListhistory[0].sirenum__Scheduled_Start_Time__c = System.now() - 10;
    shftListhistory[0].sirenum__Scheduled_End_Time__c = System.now() - 1;
    shftListhistory[0].sirenum__Placement__c = splacement.id;
    shftListhistory[0].IP_CandidateApproved__c = true;
    shftListhistory[0].StartTime__c = '10:30';
    shftListhistory[0].EndTime__c = '18:30';
    shftListhistory[1].sirenum__Contact__c = conId1[1].id;
    shftListhistory[1].sirenum__Scheduled_Start_Time__c = System.now() - 1;
    shftListhistory[1].sirenum__Scheduled_End_Time__c = System.now();
    shftListhistory[1].sirenum__Actual_Start_Time__c = System.now() - 1;
    shftListhistory[1].sirenum__Actual_End_Time__c = System.now();
    shftListhistory[1].sirenum__Placement__c = splacement.id;
    shftListhistory[1].IP_CandidateApproved__c = true;
    shftListhistory[1].StartTime__c = '10:30';
    shftListhistory[1].EndTime__c = '18:30';
    shftListhistory[2].sirenum__Contact__c = conId1[0].id;
    shftListhistory[2].sirenum__Scheduled_Start_Time__c = System.now() - 2;
    shftListhistory[2].sirenum__Scheduled_End_Time__c = System.now() - 1;
    shftListhistory[2].sirenum__Actual_Start_Time__c = System.now() - 2;
    shftListhistory[2].sirenum__Actual_End_Time__c = System.now() - 1;
    shftListhistory[2].sirenum__Placement__c = splacement.id;
    shftListhistory[2].IP_CandidateApproved__c = true;
    shftListhistory[2].sirenum__Cancelled__c = false;
    shftListhistory[3].sirenum__Contact__c = conId1[0].id;
    shftListhistory[3].sirenum__Scheduled_Start_Time__c = System.now() - 4;
    shftListhistory[3].sirenum__Scheduled_End_Time__c = System.now() - 3;
    shftListhistory[3].sirenum__Actual_Start_Time__c = System.now() - 4;
    shftListhistory[3].sirenum__Actual_End_Time__c = System.now() - 3;
    shftListhistory[3].sirenum__Placement__c = splacement.id;
    shftListhistory[3].IP_CandidateApproved__c = true;
    shftListhistory[3].sirenum__Cancelled__c = false;
    shftListhistory[4].sirenum__Contact__c = conId1[0].id;
    shftListhistory[4].sirenum__Scheduled_Start_Time__c = System.now() - 21;
    shftListhistory[4].sirenum__Scheduled_End_Time__c = System.now() - 20;
    shftListhistory[4].sirenum__Actual_Start_Time__c = System.now() - 21;
    shftListhistory[4].sirenum__Actual_End_Time__c = System.now() - 20;
    shftListhistory[4].sirenum__Placement__c = splacement.id;
    shftListhistory[4].IP_CandidateApproved__c = true;
    shftListhistory[4].sirenum__Cancelled__c = false;
    shftListhistory[5].sirenum__Contact__c = null;
    shftListhistory[5].sirenum__Scheduled_Start_Time__c = System.now() - 21;
    shftListhistory[5].sirenum__Scheduled_End_Time__c = System.now() - 20;
    shftListhistory[5].sirenum__Actual_Start_Time__c = System.now() - 21;
    shftListhistory[5].sirenum__Actual_End_Time__c = System.now() - 20;
    shftListhistory[5].sirenum__Placement__c = splacement.id;
    shftListhistory[5].IP_CandidateApproved__c = true;
    shftListhistory[5].sirenum__Cancelled__c = false;
    shftListhistory[5].sirenum__Broadcasts__c = 2;
    shftListhistory[6].sirenum__Contact__c = null;
    shftListhistory[6].sirenum__Scheduled_Start_Time__c = System.now() - 21;
    shftListhistory[6].sirenum__Scheduled_End_Time__c = System.now() - 20;
    shftListhistory[6].sirenum__Actual_Start_Time__c = System.now() - 21;
    shftListhistory[6].sirenum__Actual_End_Time__c = System.now() - 20;
    shftListhistory[6].sirenum__Placement__c = splacement.id;
    shftListhistory[6].IP_CandidateApproved__c = true;
    shftListhistory[6].sirenum__Cancelled__c = false;
    insert shftListhistory;

    sirenum__shift__c shftrec = TestDataFactory.createShift(
      splacement.id,
      sites.id,
      1
    )[0];
    shftrec.sirenum__Placement__c = splacement.id;
    shftrec.sirenum__Contact__c = conId1[1].id;
    shftrec.sirenum__Actual_Start_Time__c = System.now();
    shftrec.sirenum__Actual_End_Time__c = System.now() + 1;
    insert shftrec;
    System.debug('Check shift list' + shftrec);

    test.startTest();

    ShiftPageApexController.sendEmail(shftrec.id, 'testquerydata');
    ShiftPageApexController.getdetailShifts(shftrec.id);
    ShiftPageApexController.getShifts();
    ShiftPageApexController.updateshifts(shftrec, '10:30', '12:30', '1');
    ShiftPageApexController.getbreaks(shftrec.id);

    test.stopTest();
  }

  @isTest
  static void RetrievePastShifts() {
    User u = [
      SELECT id, contactId, accountId
      FROM user
      WHERE email = 'bruce.wayne@wayneenterprises.com'
      LIMIT 1
    ];
    List<contact> conId1 = [
      SELECT id, name
      FROM contact
      WHERE lastname LIKE 'McTesty%'
      LIMIT 5
    ];

    Account acct1 = TestDataFactory.createAccounts(3)[2];
    insert acct1;

    Account acct = TestDataFactory.createCandidateAccount(1)[0];
    insert acct;
    insert new Payroll_Swtich__c(Name = 'Stoppayroll', Batch_check__c = true);
    RecordType accRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Account'
    ];
    Account acct11 = new Account(
      IP_Business_Type__c = 'Catering',
      Name = 'Account Name',
      RecordTypeId = accRec.id,
      IP_BusinessIncorporationNumber__c = '12345678'
    );
    Database.insert(acct11);
    Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];
    insert cond;
    Recordtype recType = [
      SELECT id
      FROM Recordtype
      WHERE sobjecttype = 'contact' AND Name = 'Contact'
    ];
    contact con2 = new contact();
    con2.RecordTypeId = recType.id;
    con2.AccountId = acct11.id;
    con2.FirstName = 'Test';
    con2.LastName = 'Data';
    con2.IP_ContactType__c = 'Invoice Contact';
    insert con2;

    IP_TopazGlobalClientInformation__c tgci = new IP_TopazGlobalClientInformation__c(
      name = 'MyClient',
      IP_StatusID__c = 1,
      IP_SalesLedgerNumber__c = '1234567890'
    );
    Database.insert(tgci);

    sirenum__Site__c sites = new sirenum__Site__c(
      Name = 'my site',
      IP_InvoiceAddressCity__c = 'ballia',
      IP_InvoiceAddressStreet__c = 'street1',
      sirenum__Operating_Company__c = acct.Id,
      GlobalClientName__c = tgci.Id,
      IP_ClientIDLegacy__c = 'eww3',
      IP_Clientinvoicename__c = 'invoice name',
      IP_InvoiceAddressCountry__c = 'ind',
      IP_InvoiceAddressCounty__c = 'cnt',
      IP_InvoiceAddressPostcode__c = '23d fdd',
      IP_PublicSector__c = 'No',
      IP_PassClientToTempest__c = false,
      IP_ClientLastPassedToTempest__c = date.today(),
      Credit_Status__c = 'Credit Approved',
      IP_PassClientAddressToTempest__c = true,
      IP_ClientAddressLastPassedToTempest__c = date.today()
    );
    Database.insert(sites);

    sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(
      acct.id,
      cond.id,
      1
    )[0];
    insert pac;

    sirenum__Rota__c rota = TestDataFactory.createSector(1)[0];
    insert rota;

    sirenum__Job_Type__c job = TestDataFactory.createJobType(rota.id, 1)[0];
    insert job;

    sirenum__Team__c tm = TestDataFactory.createJobRole(pac.id, job.id, 1)[0];
    insert tm;

    sirenum__Placement__c splacement = TestDataFactory.createSPlacement1(
      cond.id,
      pac.id,
      tm.id,
      u.id,
      1
    )[0];
    splacement.sirenum__Site__c = sites.id;
    splacement.IP_Consultant1LookupSplitShare__c = u.id;
    insert splacement;

    sirenum__shift__c shftrec = TestDataFactory.createShift(
      splacement.id,
      sites.id,
      1
    )[0];
    shftrec.sirenum__Placement__c = splacement.id;
    shftrec.sirenum__Contact__c = conId1[1].id;
    shftrec.sirenum__Scheduled_Start_Time__c = System.now().addDays(-2);
    shftrec.sirenum__Scheduled_End_Time__c = System.now().addDays(-1);
    shftrec.sirenum__Published__c = true;
    shftrec.sirenum__Cancelled__c = false;
    shftrec.sirenum__Team__c = tm.Id;
    // shftrec.IP_Status__c =
    insert shftrec;

    System.debug('Sirenum team ' + shftrec.sirenum__Team__c);
    System.debug('Client matches acct: ' + pac.sirenum__Client__c);
    System.runAs(u) {
      test.startTest();
      List<sirenum__Shift__c> output = ShiftPageApexController.getPastShiftsByUserAccount(
        cond.Id,
        new List<Id>{ sites.Id },
        '1'
      );
      test.stopTest();

      System.assert(!output.isEmpty());
      System.assertEquals(1, output.size());
    }
  }

  @isTest
  static void RetrieveShifts() {
    User u = [
      SELECT id, contactId, accountId
      FROM user
      WHERE email = 'bruce.wayne@wayneenterprises.com'
      LIMIT 1
    ];
    List<contact> conId1 = [
      SELECT id, name
      FROM contact
      WHERE lastname LIKE 'McTesty%'
      LIMIT 5
    ];

    Account acct1 = TestDataFactory.createAccounts(3)[2];
    insert acct1;

    Account acct = TestDataFactory.createCandidateAccount(1)[0];
    insert acct;
    insert new Payroll_Swtich__c(Name = 'Stoppayroll', Batch_check__c = true);
    RecordType accRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Account'
    ];
    Account acct11 = new Account(
      IP_Business_Type__c = 'Catering',
      Name = 'Account Name',
      RecordTypeId = accRec.id,
      IP_BusinessIncorporationNumber__c = '12345678'
    );
    Database.insert(acct11);
    Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];
    insert cond;
    Recordtype recType = [
      SELECT id
      FROM Recordtype
      WHERE sobjecttype = 'contact' AND Name = 'Contact'
    ];
    contact con2 = new contact();
    con2.RecordTypeId = recType.id;
    con2.AccountId = acct11.id;
    con2.FirstName = 'Test';
    con2.LastName = 'Data';
    con2.IP_ContactType__c = 'Invoice Contact';
    insert con2;

    IP_TopazGlobalClientInformation__c tgci = new IP_TopazGlobalClientInformation__c(
      name = 'MyClient',
      IP_StatusID__c = 1,
      IP_SalesLedgerNumber__c = '1234567890'
    );
    Database.insert(tgci);

    sirenum__Site__c sites = new sirenum__Site__c(
      Name = 'my site',
      IP_InvoiceAddressCity__c = 'ballia',
      IP_InvoiceAddressStreet__c = 'street1',
      sirenum__Operating_Company__c = acct.Id,
      GlobalClientName__c = tgci.Id,
      IP_ClientIDLegacy__c = 'eww3',
      IP_Clientinvoicename__c = 'invoice name',
      IP_InvoiceAddressCountry__c = 'ind',
      IP_InvoiceAddressCounty__c = 'cnt',
      IP_InvoiceAddressPostcode__c = '23d fdd',
      IP_PublicSector__c = 'No',
      IP_PassClientToTempest__c = false,
      IP_ClientLastPassedToTempest__c = date.today(),
      Credit_Status__c = 'Credit Approved',
      IP_PassClientAddressToTempest__c = true,
      IP_ClientAddressLastPassedToTempest__c = date.today()
    );
    Database.insert(sites);

    sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(
      acct.id,
      cond.id,
      1
    )[0];
    insert pac;

    sirenum__Rota__c rota = TestDataFactory.createSector(1)[0];
    insert rota;

    sirenum__Job_Type__c job = TestDataFactory.createJobType(rota.id, 1)[0];
    insert job;

    sirenum__Team__c tm = TestDataFactory.createJobRole(pac.id, job.id, 1)[0];
    insert tm;

    sirenum__Placement__c splacement = TestDataFactory.createSPlacement1(
      cond.id,
      pac.id,
      tm.id,
      u.id,
      1
    )[0];
    splacement.sirenum__Site__c = sites.id;
    splacement.IP_Consultant1LookupSplitShare__c = u.id;
    insert splacement;

    sirenum__shift__c shftrec = TestDataFactory.createShift(
      splacement.id,
      sites.id,
      1
    )[0];
    shftrec.sirenum__Placement__c = splacement.id;
    shftrec.sirenum__Contact__c = conId1[1].id;
    shftrec.sirenum__Scheduled_Start_Time__c = System.now().addDays(1);
    shftrec.sirenum__Scheduled_End_Time__c = System.now().addDays(2);
    shftrec.sirenum__Published__c = true;
    shftrec.sirenum__Cancelled__c = false;
    shftrec.sirenum__Team__c = tm.Id;
    // shftrec.IP_Status__c =
    insert shftrec;

    System.debug('Sirenum team ' + shftrec.sirenum__Team__c);
    System.debug('Client matches acct: ' + pac.sirenum__Client__c);
    System.runAs(u) {
      test.startTest();
      List<sirenum__Shift__c> output = ShiftPageApexController.getShiftsByUserAccount(
        cond.Id,
        new List<Id>{ sites.Id }
      );
      test.stopTest();

      System.assert(!output.isEmpty());
      System.assertEquals(1, output.size());
    }
  }

  @isTest
  static void RetrieveRatings() {
    User u = [
      SELECT id, contactId, accountId
      FROM user
      WHERE email = 'bruce.wayne@wayneenterprises.com'
      LIMIT 1
    ];
    List<contact> conId1 = [
      SELECT id, name
      FROM contact
      WHERE lastname LIKE 'McTesty%'
      LIMIT 5
    ];

    Account acct1 = TestDataFactory.createAccounts(3)[2];
    insert acct1;

    Account acct = TestDataFactory.createCandidateAccount(1)[0];
    insert acct;
    insert new Payroll_Swtich__c(Name = 'Stoppayroll', Batch_check__c = true);
    RecordType accRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Account'
    ];
    Account acct11 = new Account(
      IP_Business_Type__c = 'Catering',
      Name = 'Account Name',
      RecordTypeId = accRec.id,
      IP_BusinessIncorporationNumber__c = '12345678'
    );
    Database.insert(acct11);
    Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];
    insert cond;
    Recordtype recType = [
      SELECT id
      FROM Recordtype
      WHERE sobjecttype = 'contact' AND Name = 'Contact'
    ];
    contact con2 = new contact();
    con2.RecordTypeId = recType.id;
    con2.AccountId = acct11.id;
    con2.FirstName = 'Test';
    con2.LastName = 'Data';
    con2.IP_ContactType__c = 'Invoice Contact';
    insert con2;

    IP_TopazGlobalClientInformation__c tgci = new IP_TopazGlobalClientInformation__c(
      name = 'MyClient',
      IP_StatusID__c = 1,
      IP_SalesLedgerNumber__c = '1234567890'
    );
    Database.insert(tgci);

    sirenum__Site__c sites = new sirenum__Site__c(
      Name = 'my site',
      IP_InvoiceAddressCity__c = 'ballia',
      IP_InvoiceAddressStreet__c = 'street1',
      sirenum__Operating_Company__c = acct.Id,
      GlobalClientName__c = tgci.Id,
      IP_ClientIDLegacy__c = 'eww3',
      IP_Clientinvoicename__c = 'invoice name',
      IP_InvoiceAddressCountry__c = 'ind',
      IP_InvoiceAddressCounty__c = 'cnt',
      IP_InvoiceAddressPostcode__c = '23d fdd',
      IP_PublicSector__c = 'No',
      IP_PassClientToTempest__c = false,
      IP_ClientLastPassedToTempest__c = date.today(),
      Credit_Status__c = 'Credit Approved',
      IP_PassClientAddressToTempest__c = true,
      IP_ClientAddressLastPassedToTempest__c = date.today()
    );
    Database.insert(sites);

    sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(
      acct.id,
      cond.id,
      1
    )[0];
    insert pac;

    sirenum__Rota__c rota = TestDataFactory.createSector(1)[0];
    insert rota;

    sirenum__Job_Type__c job = TestDataFactory.createJobType(rota.id, 1)[0];
    insert job;

    sirenum__Team__c tm = TestDataFactory.createJobRole(pac.id, job.id, 1)[0];
    insert tm;

    sirenum__Placement__c splacement = TestDataFactory.createSPlacement1(
      cond.id,
      pac.id,
      tm.id,
      u.id,
      1
    )[0];
    splacement.sirenum__Site__c = sites.id;
    splacement.IP_Consultant1LookupSplitShare__c = u.id;
    insert splacement;

    sirenum__shift__c shftrec = TestDataFactory.createShift(
      splacement.id,
      sites.id,
      1
    )[0];
    shftrec.sirenum__Placement__c = splacement.id;
    shftrec.sirenum__Contact__c = conId1[1].id;
    shftrec.sirenum__Scheduled_Start_Time__c = System.now().addDays(1);
    shftrec.sirenum__Scheduled_End_Time__c = System.now().addDays(2);
    shftrec.sirenum__Published__c = true;
    shftrec.sirenum__Cancelled__c = false;
    shftrec.sirenum__Team__c = tm.Id;
    // shftrec.IP_Status__c =
    insert shftrec;

    sirenum__Ranking__c condRanking = new sirenum__Ranking__c(
      sirenum__Rank__c = 'Excellent',
      sirenum__Contact__c = cond.Id,
      sirenum__Account__c = acct.Id,
      sirenum__Site__c = sites.id,
      sirenum__Job_Type__c = job.Id,
      sirenum__Rota__c = rota.id
    );
    insert condRanking;
    System.debug('Sirenum team ' + shftrec.sirenum__Team__c);
    System.debug('Client matches acct: ' + pac.sirenum__Client__c);
    System.runAs(u) {
      test.startTest();
      Map<Id, List<sirenum__Ranking__c>> output = ShiftPageApexController.getRatings(
        new List<Id>{ cond.Id }
      );
      test.stopTest();

      System.assert(!output.isEmpty());
      // System.assertEquals(1, output.size());
    }
  }
}