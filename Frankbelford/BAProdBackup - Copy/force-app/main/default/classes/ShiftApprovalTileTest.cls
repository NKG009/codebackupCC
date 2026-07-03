@isTest
private class ShiftApprovalTileTest {
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
    Contact contact2;
    Contact contact3;
    System.runAs(portalAccountOwner1) {
      //custom setting data
      Payroll_Swtich__c objCustomPayrol = new Payroll_Swtich__c();
      objCustomPayrol.Batch_check__c = false;
      objCustomPayrol.Name = 'Stoppayroll';
      insert objCustomPayrol;

      //Create account
      Account portalAccount1 = new Account(
        Name = 'TestAccount',
        OwnerId = portalAccountOwner1.Id
      );
      Database.insert(portalAccount1);
      insert new User_Profile_Id__c(
        Name = 'User Portal',
        Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal']
        .Id
      );
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
  static void testMethodOne() {
    User u = [
      SELECT id, contactId, contact.AccountId
      FROM user
      WHERE lastname = 'McTesty'
      LIMIT 1
    ];
    ID ConTID = u.contactId;
    ID accDID = u.Contact.AccountId;

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
    sites.ownerId = u.id;
    sites.sirenum__Operating_Company__c = accDID;
    sites.IP_MainContact__c = ConTID;
    sites.IP_PassClientToTempest__c = false;
    insert sites;

    Contact_Site_link__c stlink = new Contact_Site_link__c();
    stlink.IP_Site__c = sites.id;
    stlink.IP_Contact__c = ConTID;
    stlink.Account__c = accDID;
    stlink.IP_PortalType__c = 'Primary Hours Approver';
    insert stlink;

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

    DateTime dt = System.Today();
    System.runAs(u) {
      Test.startTest();
      ShiftApprovalTile.getAllShifts(sites.id, cond.id, dt, dt);
      ShiftApprovalTile.getChartMap(2);
      ShiftApprovalTile.getAllShiftsFromSiteList(
        new List<String>{ sites.id },
        cond.id,
        dt,
        dt
      );

      Test.stopTest();
    }
  }
}