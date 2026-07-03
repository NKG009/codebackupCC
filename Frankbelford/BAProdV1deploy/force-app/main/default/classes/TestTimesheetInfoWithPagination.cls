@isTest
private class TestTimesheetInfoWithPagination {
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
      Username = System.now().millisecond() + 'test2@test.js.com',
      Alias = 'batman',
      Email = 'bruce.wayne@wayneenterprises.com',
      EmailEncodingKey = 'UTF-8',
      Firstname = 'Bruce',
      Lastname = 'Wayne',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      TimeZoneSidKey = 'America/Chicago'
    );
      Test.startTest();
    Database.insert(portalAccountOwner1);
    Contact contact1;
    System.runAs(portalAccountOwner1) {
      //Create account
      Account portalAccount1 = new Account(
        Name = 'TestAccount',
        OwnerId = portalAccountOwner1.Id
      );
      Account candidateAccount = TestDataFactory.createCandidateAccount(1)[0];
      insert new List<Account>{ portalAccount1, candidateAccount };
      //custom setting data
      TestDataFactory.setupCustomSettings(candidateAccount.Id);
      TestDataFactory.setupUserProfileCustomSettings();

        //Inserting Payroll records
        insert new Payroll_Swtich__c(Name='Stoppayroll',Batch_check__c=false);
      //Create contact
      contact1 = new Contact(
        FirstName = 'Test1',
        Lastname = 'McTesty',
        AccountId = portalAccount1.Id,
        IP_IsInvoicecontact__c = true,
        IP_ContactType__c = 'Invoice Contact',
        Email = System.now().millisecond() + 'test@test.com'
      );
      Database.insert(contact1);
    }
      Test.stopTest();
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

    Profile financeProfile = [
      SELECT Id
      FROM Profile
      WHERE Name = 'JS Recruiter - Hybrid'
      LIMIT 1
    ];
    User user2 = new User(
      Username = System.now().millisecond() + 'test128888345@test.com',
      ProfileId = financeProfile.Id,
      Alias = 'test123',
      Email = 'amit.kohli@espire.com',
      EmailEncodingKey = 'UTF-8',
      FirstName = 'Finance',
      LastName = 'Team',
      isactive = true,
      TimeZoneSidKey = 'America/Los_Angeles',
      LocaleSidKey = 'en_US',
      LanguageLocaleKey = 'en_US'
    );
    Database.insert(user2);
  }

  @isTest
  static void testTimeSheetInfoWithPagination() {
    User u = [
      SELECT id, contactId, contact.AccountId
      FROM user
      WHERE email = 'bruce.wayne@wayneenterprises.com'
      LIMIT 1
    ];

    User portalUser = [
      SELECT id, contactId, contact.AccountId
      FROM user
      WHERE lastName = 'McTesty'
      LIMIT 1
    ];

    Account acct1 = TestDataFactory.createAccounts(3)[2];
    acct1.Top_Prospect__c = false;
    insert acct1;
    Account acct = [
      SELECT Id, Name
      FROM Account
      WHERE RecordType.Name = 'Candidate'
      LIMIT 1
    ];
    Account acct2 = TestDataFactory.createCandidateAccount(1)[0];
    insert acct2;

    Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];
    insert cond;
    ID ConTID = portalUser.contactId;
    ID accDID = portalUser.Contact.AccountId;
    IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0];
    insert tgci;

    sirenum__Site__c sites = TestDataFactory.createSites(
      acct2.id,
      tgci.id,
      1
    )[0];
    sites.ownerId = u.id;
    sites.sirenum__Operating_Company__c = accDID;
    sites.IP_PassClientToTempest__c = false;
    sites.IP_MainContact__c = ConTID;
    sites.IP_InvoiceContact__c = ConTID;
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

    sirenum__Placement__c splacement = TestDataFactory.createSPlacement1(
      cond.id,
      pac.id,
      tm.id,
      portalUser.id,
      1
    )[0];
      
   
    splacement.sirenum__Site__c = sites.id;
    splacement.IP_Consultant1LookupSplitShare__c = u.id;
    insert splacement;

    List<id> stslist = new List<id>();
	
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
     Test.startTest();
    insert sts;
      
    stslist.add(sts.id);

    List<sirenum__Shift__c> shftList = TestDataFactory.createShift(
      splacement.id,
      sites.id,
      5
    );
    List<contact> conId = [
      SELECT id, name
      FROM contact
      WHERE lastname LIKE 'McTesty%'
      LIMIT 5
    ];
    shftList[0].sirenum__Contact__c = cond.id;
    shftList[0].sirenum__Scheduled_Start_Time__c = System.now() - 10;
    shftList[0].sirenum__Scheduled_End_Time__c = System.now() - 1;
    shftList[0].sirenum__Placement__c = splacement.id;
    shftList[0].IP_CandidateApproved__c = true;
    shftList[0].StartTime__c = '10:30';
    shftList[0].EndTime__c = '18:30';
    shftList[0].sirenum__Timesheet_summaries__c = sts.Id;
    insert shftList;

    sirenum__Timesheet_Line__c tsLine = TestDataFactory.createTimeSheetLine(
      sts.Id,
      shftList[0].Id,
      1
    )[0];
    insert tsLine;

    System.runAs(portalUser) {
      //Test.startTest();
      TimeSheetInfoWithPagination.fetchTimeSheets();
      TimeSheetInfoWithPagination.fetchTimeSheetLines(sts.id);
      TimeSheetInfoWithPagination.getUserInformation();
      TimeSheetInfoWithPagination.getSites();
      TimeSheetInfoWithPagination.fetchTimeSheetsByFilter(sts.id);
      TimeSheetInfoWithPagination.getContactList();
      TimeSheetInfoWithPagination.fetchUser();
      TimeSheetInfoWithPagination.UpdateInvoicePO(sts.Id, '1234');
      TimeSheetInfoWithPagination.UpdateBulkPO('52625', stslist);
      List<sirenum__Timesheet__c> tsList = TimeSheetInfoWithPagination.getTimesheetsToDownload(
        sites.Id
      );
      try {
        TimeSheetInfoWithPagination.getTimesheetsToDownload('');
      } catch (Exception e) {
        System.debug('Exception expected');
      }
      System.assert(tsList.size() == 0, 'Expected Timesheets count is 0');
     
    }
    User u1 = [
      SELECT id, contactId, contact.AccountId
      FROM user
      WHERE name = 'Finance Team' AND isactive = TRUE
      LIMIT 1
    ];
    System.runAs(u1) {
      TimeSheetInfoWithPagination.UpdateInvoicePO(sts.Id, '1234');
         Test.stopTest();
      TimeSheetInfoWithPagination.approveRejectTimesheetsWithRejectReason(
        new List<Id>{ shftList[0].Id },
        'approve',
        ''
      );
      // TimeSheetInfoWithPagination.approveRejectTimesheetsWithRejectReason(
      //   new List<Id>{ shftList[0].Id },
      //   'success',
      //   'Test'
      // );
    }
  }
}