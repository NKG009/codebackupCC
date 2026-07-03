@isTest
private class SiteManagementComponentControllerTest {
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
      Username = 'test_' + System.now().millisecond() + 'test221@test.com',
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
      //Create account
      Account portalAccount1 = TestDataFactory.createClients(1)[0];
      Account candidateAccount = TestDataFactory.createCandidateAccount(1)[0];

      insert new List<Account>{ portalAccount1, candidateAccount };
      TestDataFactory.setupUserProfileCustomSettings();
      TestDataFactory.setupCustomSettings(candidateAccount.Id);

      //Create contact
      List<Contact> contacts = TestDataFactory.createContact(
        portalAccount1.Id,
        3
      );
      contact1 = contacts[0];
      contact1.FirstName = 'Test1';
      contact1.Lastname = 'McTesty';
      contact1.Email = System.now().millisecond() + 'test@test.com';

      //Create contact
      contact2 = contacts[1];
      contact2.FirstName = 'Test2';
      contact2.Lastname = 'McTesty2';
      contact2.Email = 'test2' + System.now().millisecond() + 'test2@test.com';

      //Create contact
      contact3 = contacts[2];
      contact3.FirstName = 'Test3';
      contact3.Lastname = 'McTesty3';
      contact3.Email = 'test3' + System.now().millisecond() + 'test3@test.com';
      Database.insert(contacts);
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
    Account acct = [
      SELECT Id, Name
      FROM Account
      WHERE RecordType.Name = 'Candidate'
      LIMIT 1
    ];
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
    sites.Emergency_Contact__c = ConTID;
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

    System.runAs(u) {
      test.startTest();
      SiteManagementComponentController SiteCompCtrl = new SiteManagementComponentController();
      SiteManagementComponentController.getSitesOfLoggedInUser();
      SiteManagementComponentController.fetchUserInformation();
      SiteManagementComponentController.fetchSiteInformation(sites.id);
      SiteManagementComponentController.getUserInformation();
      SiteManagementComponentController.updateSitedetails(
        sites.id,
        'MyContactFName',
        'LastNameCont',
        'test@test.com',
        'Test A',
        'User Last Name',
        'Teest@test.com',
        'st peters',
        'TestCity',
        'TestState',
        'UK',
        'TR23 4AA'
      );
      test.stopTest();
    }

  }

  @isTest
  static void getSitesOfLoggedInUser() {
    // User u = [
    //   SELECT id, contactId, contact.AccountId
    //   FROM user
    //   WHERE lastname = 'McTesty'
    //   LIMIT 1
    // ];
    // ID ConTID = u.contactId;
    // ID accDID = u.Contact.AccountId;
    // Account acct1 = TestDataFactory.createAccounts(3)[2];
    // insert acct1;
    Account portalAccount1 = new Account(Name = 'TestAccount');
    Database.insert(portalAccount1);
    Contact contact1 = new Contact(
      FirstName = 'Test1',
      Lastname = 'McTesty',
      AccountId = portalAccount1.Id,
      Email = System.now().millisecond() + 'test@test.com'
    );
    insert contact1;
    Profile portalProfile = [
      SELECT Id
      FROM Profile
      WHERE Name LIKE '%Customer Community User%'
      LIMIT 1
    ];
    User u = new User(
      Username = System.now().millisecond() + 'test12345@test.com',
      ContactId = contact1.Id,
      ProfileId = portalProfile.Id,
      Alias = 'test123',
      Email = 'amit.kohli@espire.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'McTesty',
      CommunityNickname = System.now().millisecond() + 'nick',
      TimeZoneSidKey = 'America/Los_Angeles',
      LocaleSidKey = 'en_US',
      LanguageLocaleKey = 'en_US'
    );
    Database.insert(u);
    IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0];
    insert tgci;

    sirenum__Site__c sites = TestDataFactory.createSites(
      portalAccount1.Id,
      tgci.id,
      1
    )[0];
    sites.ownerId = u.id;
    sites.sirenum__Operating_Company__c = portalAccount1.Id;
    sites.IP_MainContact__c = contact1.Id;
    sites.Emergency_Contact__c = contact1.Id;
    sites.IP_PassClientToTempest__c = false;
    insert sites;
    Contact_Site_link__c stlink = new Contact_Site_link__c();
    stlink.IP_Site__c = sites.id;
    stlink.IP_Contact__c = contact1.Id;
    stlink.Account__c = portalAccount1.Id;
    stlink.IP_PortalType__c = 'Primary Hours Approver';
    insert stlink;

    System.runAs(u) {
      test.startTest();
      List<Contact_Site_Link__c> links = SiteManagementComponentController.getContactSiteLinksForUser();

      test.stopTest();

      System.assertNotEquals(0, links.size());
    }
  }
}