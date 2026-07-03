@isTest
private class TestTimesheetFilters {
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
      Username = System.now().millisecond() + 'test211@test.com',
      Alias = 'batman',
      Email = 'bruce.wayne@wayneenterprises.com',
      EmailEncodingKey = 'UTF-8',
      Firstname = 'Bruce',
      Lastname = 'Wayne',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      TimeZoneSidKey = 'America/Chicago',
      Brand__c = 'Blue Arrow'
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
      insert new User_Profile_Id__c(
        Name = 'User Portal',
        Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal']
        .Id
      );

      //Create account
      Account portalAccount1 = new Account(
        Name = 'TestAccount',
        OwnerId = portalAccountOwner1.Id
      );
      Database.insert(portalAccount1);

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
      //Create contact
      /*   contact2 = new Contact(
                FirstName = 'Test2',
                Lastname = 'McTesty2',
                AccountId = portalAccount1.Id,
                Email = 'test2'+System.now().millisecond() + 'test2@test.com'
            );
            Database.insert(contact2);
            //Create contact
            contact3 = new Contact(
                FirstName = 'Test3',
                Lastname = 'McTesty3',
                AccountId = portalAccount1.Id,
                Email = 'test3'+System.now().millisecond() + 'test3@test.com'
            );
            Database.insert(contact3);*/
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

  @isTest
  static void testTimeSheetFilters() {
    User u = [
      SELECT id, contactId
      FROM user
      WHERE Email = 'bruce.wayne@wayneenterprises.com'
      LIMIT 1
    ];

    User portalUser = [
      SELECT id, contactId
      FROM user
      WHERE LastName = 'McTesty'
      LIMIT 1
    ];

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
    sites.sirenum__Operating_Company__c = [
      SELECT id, name
      FROM Account
      WHERE name LIKE 'TestAccount%'
      LIMIT 1
    ][0]
    .id;
    sites.IP_MainContact__c = [
      SELECT contactId
      FROM user
      WHERE lastname = 'McTesty'
      LIMIT 1
    ][0]
    .contactId;
    sites.IP_PassClientToTempest__c = false;
    sites.IP_InvoiceContact__c = [
      SELECT contactId
      FROM user
      WHERE lastname = 'McTesty'
      LIMIT 1
    ][0]
    .contactId;
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

    sirenum__Placement__c splacement = TestDataFactory.createSPlacement1(
      cond.id,
      pac.id,
      tm.id,
      u.id,
      1
    )[0];
    splacement.sirenum__Site__c = sites.id;
    splacement.IP_Consultant1LookupSplitShare__c = u.id;
    //splacement.IP_Consultant1IDnumberSplitShare__c
    insert splacement;

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
    shftList[0].sirenum__Contact__c = conId[0].id;
    shftList[0].sirenum__Scheduled_Start_Time__c = System.now() - 10;
    shftList[0].sirenum__Scheduled_End_Time__c = System.now() - 1;
    shftList[0].sirenum__Placement__c = splacement.id;
    shftList[0].IP_CandidateApproved__c = true;
    shftList[0].StartTime__c = '10:30';
    shftList[0].EndTime__c = '18:30';
    insert shftList;

    sirenum__Timesheet__c sts = new sirenum__Timesheet__c(
      sirenum__Client__c = [
        SELECT id, name
        FROM Account
        WHERE name LIKE 'TestAccount%'
        LIMIT 1
      ][0]
      .id, //acct.id,
      sirenum__Worker__c = [
        SELECT id, name
        FROM contact
        WHERE lastname LIKE 'McTesty%'
        LIMIT 1
      ][0]
      .id, //cond.id,
      sirenum__Week_Ending__c = system.today(),
      sirenum__Non_Taxed_Expenses__c = 34.2,
      sirenum__Taxed_Expenses__c = 22.2,
      sirenum__Non_Taxed_Deductions__c = 22.0,
      sirenum__Taxed_Deductions__c = 22.1,
      sirenum__Site__c = sites.id
    );
    insert sts;

    //List<sirenum__Timesheet_Line__c> timesheetLines = TestDataFactory.createTimeSheetLine(sts.id, shftList[0].id,2);
    //timesheetLines[0].IP_PassToTempest__c=false;
    //timesheetLines[1].IP_PassToTempest__c=false;)
    sirenum__Timesheet_Line__c timesheetline = new sirenum__Timesheet_Line__c(
      sirenum__Timesheet__c = sts.id,
      sirenum__Rate__c = 22.0,
      sirenum__Hours__c = 1,
      IP_RateCodes__c = 'Taxable Expenses /TX',
      sirenum__Shift__c = shftList[0].id
    );
    //insert timesheetline;

    Impellam_Settings__c objCustLimit = new Impellam_Settings__c();
    objCustLimit.Name = 'TimesheetApproval';
    objCustLimit.Limit__c = '10';
    insert objCustLimit;

    Impellam_Settings__c objCustLimit1 = new Impellam_Settings__c();
    objCustLimit1.Name = 'TimesheetApproval_ComMap';
    objCustLimit1.Limit__c = '10';
    insert objCustLimit1;

    System.runAs(portalUser) {
      Test.startTest();
      TimeSheetFilters.getsitesList();
      TimeSheetFilters.getContactList();
      TimeSheetFilters.getsiteContactMap(sites.id);
      TimeSheetFilters.getsiteconmap(sites.id);
      TimeSheetFilters.getsearchResult(
        new List<String>{ String.ValueOf(sites.id) },
        String.ValueOf(cond.id),
        String.ValueOf(sts.Name),
        'Mon, 6 May 15 - Thu, 6 Jun 19'
      );
      TimeSheetFilters.getsearchResult(
        String.ValueOf(sites.id),
        String.ValueOf(cond.id),
        String.ValueOf(sts.Name),
        'Mon, 6 May 15 - Thu, 6 Jun 19'
      );
      TimeSheetFilters.getTimeSheets(sites.id);
      TimeSheetFilters.getContactTimeSheetMap();
      TimeSheetFilters.getsearchResult(
        new List<String>{ String.ValueOf(sites.id) },
        String.ValueOf(cond.id),
        String.ValueOf(sts.Name),
        'Mon, 6 Jan 15 - Thu, 6 Feb 19'
      );
      TimeSheetFilters.getsearchResult(
        String.ValueOf(sites.id),
        String.ValueOf(cond.id),
        String.ValueOf(sts.Name),
        'Mon, 6 Jan 15 - Thu, 6 Feb 19'
      );
      TimeSheetFilters.getsearchResult(
        new List<String>{ String.ValueOf(sites.id) },
        String.ValueOf(cond.id),
        String.ValueOf(sts.Name),
        'Mon, 6 Mar 15 - Thu, 6 Apr 19'
      );
      TimeSheetFilters.getsearchResult(
        String.ValueOf(sites.id),
        String.ValueOf(cond.id),
        String.ValueOf(sts.Name),
        'Mon, 6 Mar 15 - Thu, 6 Apr 19'
      );
      TimeSheetFilters.getsearchResult(
        new List<String>{ String.ValueOf(sites.id) },
        String.ValueOf(cond.id),
        String.ValueOf(sts.Name),
        'Mon, 6 Jul 15 - Thu, 6 Aug 19'
      );
      TimeSheetFilters.getsearchResult(
        new List<String>{ String.ValueOf(sites.id) },
        String.ValueOf(cond.id),
        String.ValueOf(sts.Name),
        'Mon, 6 Sept 15 - Thu, 6 Oct 19'
      );
      TimeSheetFilters.getsearchResult(
        new List<String>{ String.ValueOf(sites.id) },
        String.ValueOf(cond.id),
        String.ValueOf(sts.Name),
        'Mon, 6 Nov 15 - Thu, 6 Dec 19'
      );
      TimeSheetFilters.getsearchResult(
        new List<String>{ String.ValueOf(sites.id) },
        String.ValueOf(cond.id),
        String.ValueOf(sts.Name),
        null
      );
      TimeSheetFilters.getsearchResultFromSiteList(
        new List<String>{ String.ValueOf(sites.id) },
        String.ValueOf(cond.id),
        String.ValueOf(sts.Name),
        null
      );

      TimeSheetFilters.getsearchResult(
        String.ValueOf(sites.id),
        String.ValueOf(cond.id),
        String.ValueOf(sts.Name),
        'Mon, 6 Jul 15 - Thu, 6 Aug 19'
      );
      TimeSheetFilters.getsearchResult(
        String.ValueOf(sites.id),
        String.ValueOf(cond.id),
        String.ValueOf(sts.Name),
        'Mon, 6 Sept 15 - Thu, 6 Oct 19'
      );
      TimeSheetFilters.getsearchResult(
        String.ValueOf(sites.id),
        String.ValueOf(cond.id),
        String.ValueOf(sts.Name),
        'Mon, 6 Nov 15 - Thu, 6 Dec 19'
      );
      TimeSheetFilters.getsearchResult(
        String.ValueOf(sites.id),
        String.ValueOf(cond.id),
        String.ValueOf(sts.Name),
        null
      );
      TimeSheetFilters.getsearchResultFromSiteList(
        new List<String>{ String.ValueOf(sites.id) },
        String.ValueOf(cond.id),
        String.ValueOf(sts.Name),
        null
      );
      Test.stopTest();
    }
  }
}