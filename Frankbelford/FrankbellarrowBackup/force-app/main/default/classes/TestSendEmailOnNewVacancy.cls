@isTest
private class TestSendEmailOnNewVacancy {
  @testsetup
  public static void setUp() {
    String randstr = String.valueOf(Math.abs(Crypto.getRandomInteger()));
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
      Username = System.now().millisecond() + 'test2@test.com',
      Alias = 'batman',
      Email = 'bruce.wayne@wayneenterprises.com',
      EmailEncodingKey = 'UTF-8',
      Firstname = 'Bruce',
      Lastname = 'Wayne',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      TimeZoneSidKey = 'America/Chicago'
    );
    Database.insert(portalAccountOwner1);
    Contact contact1;
    System.runAs(portalAccountOwner1) {
      insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = true);
      //Create account
      Account portalAccount1 = new Account(
        Name = 'TestAccount' + randstr,
        OwnerId = portalAccountOwner1.Id
      );
      Database.insert(portalAccount1);

      //Create contact
      contact1 = new Contact(
        FirstName = 'Test1',
        Lastname = 'McTesty',
        AccountId = portalAccount1.Id,
        Email = System.now().millisecond() + 'test@test.com'
      );
      Database.insert(contact1);
    }
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
      CommunityNickname = 'test12345' + randstr,
      TimeZoneSidKey = 'America/Los_Angeles',
      LocaleSidKey = 'en_US',
      LanguageLocaleKey = 'en_US'
    );
    Database.insert(user1);
  }

  @isTest
  static void testSendEmailOnNewVacancy() {
    User u = [
      SELECT id, contactId
      FROM user
      WHERE lastname = 'McTesty'
      LIMIT 1
    ];

    User consultant = [
      SELECT id, contactId
      FROM user
      WHERE lastname = 'Wayne'
      LIMIT 1
    ];

    Account acct1 = TestDataFactory.createAccounts(3)[2];
    insert acct1;
    Account acct = TestDataFactory.createCandidateAccount(1)[0];
    insert acct;
    Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];
    insert cond;

    IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0];
    insert tgci;

    sirenum__Site__c sites = TestDataFactory.createSites(
      acct.id,
      tgci.id,
      1
    )[0];
    sites.ownerId = consultant.id;
    sites.sirenum__Operating_Company__c = [
      SELECT id, name
      FROM Account
      WHERE name LIKE 'TestAccount%'
      LIMIT 1
    ][0]
    .id;
    insert sites;

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

    // sirenum__Placement__c splacement = TestDataFactory.createSPlacement1(
    //   cond.id,
    //   pac.id,
    //   tm.id,
    //   consultant.id,
    //   1
    // )[0];
    // splacement.sirenum__Site__c = sites.id;
    // splacement.IP_Consultant1LookupSplitShare__c = consultant.id;
    // //splacement.IP_Consultant1IDnumberSplitShare__c
    // insert splacement;

    List<sirenum__Shift__c> shftList = TestDataFactory.createShift(
      null, //splacement.id,
      sites.id,
      5
    );
    List<contact> conId = [
      SELECT id, name
      FROM contact
      WHERE lastname LIKE 'McTesty%'
      LIMIT 5
    ];
    shftList[0].sirenum__Contact__c = conId[0].id;
    shftList[0].sirenum__Scheduled_Start_Time__c = System.now() - 10;
    shftList[0].sirenum__Scheduled_End_Time__c = System.now() - 1;
    // shftList[0].sirenum__Placement__c = splacement.id;
    shftList[0].IP_CandidateApproved__c = true;
    shftList[0].StartTime__c = '10:30';
    shftList[0].EndTime__c = '18:30';
    insert shftList;

    sirenum__Timesheet__c sts = new sirenum__Timesheet__c(
      sirenum__Client__c = acct1.id,
      sirenum__Worker__c = cond.id,
      sirenum__Week_Ending__c = system.today(),
      sirenum__Non_Taxed_Expenses__c = 34.2,
      sirenum__Taxed_Expenses__c = 22.2,
      sirenum__Non_Taxed_Deductions__c = 22.0,
      sirenum__Taxed_Deductions__c = 22.1,
      sirenum__Site__c = sites.id
    );
    insert sts;

    List<sirenum__Rota__c> sectors = TestDataFactory.createSector(1);
    insert sectors;
    List<sirenum__Job_Type__c> jobcats = TestDataFactory.createJobType(
      sectors[0].id,
      1
    );
    insert jobcats;
    List<sirenum__ProActiveContract__c> contracts = TestDataFactory.sirenumProActiveContract(
      acct.id,
      cond.id,
      1
    );
    insert contracts;
    List<sirenum__Team__c> jobroles = TestDataFactory.createJobRole(
      contracts[0].id,
      jobcats[0].id,
      1
    );
    insert jobroles;
    System.runAs(u) {
      Test.startTest();
      SendEmailOnNewVacancy.fetchUserInformation();
      SendEmailOnNewVacancy.getsitesList();
      SendEmailOnNewVacancy.getJobRoleList();
      SendEmailOnNewVacancy.SendEmail(
        String.ValueOf(sites.id),
        '11:04',
        '11:05',
        System.today().day() +
        '/' +
        System.today().month() +
        '/' +
        System.today().year(),
        (System.today() + 1).day() +
        '/' +
        (System.today() + 1).month() +
        '/' +
        (System.today() + 1).year(),
        '8'
      );
      SendEmailOnNewVacancy.SendEmailWithPO(
        String.ValueOf(sites.id),
        '11:04',
        '11:05',
        System.today().day() +
        '/' +
        System.today().month() +
        '/' +
        System.today().year(),
        (System.today() + 1).day() +
        '/' +
        (System.today() + 1).month() +
        '/' +
        (System.today() + 1).year(),
        '8',
        '123456'
      );
      Test.stopTest();
    }
  }
}