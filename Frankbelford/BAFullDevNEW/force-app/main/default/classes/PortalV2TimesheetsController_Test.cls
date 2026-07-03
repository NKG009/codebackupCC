@isTest
private class PortalV2TimesheetsController_Test {
  @testSetup
  static void createTestData() {
    insert new Payroll_Swtich__c(Name = 'Stoppayroll', Batch_check__c = true);
    Account candidateAccount = TestDataFactory.createCandidateAccount(1)[0];
    Account clientAccount = TestDataFactory.createAccounts(1)[0];
    insert new List<Account>{ candidateAccount, clientAccount };

     //create contact for portal user
     Contact clientContact = TestDataFactory.createContact(clientAccount.Id, 1)[0];
     clientContact.LastName = 'Client';
     insert clientContact;

     Profile clientPortalUserProfile = [SELECT Id FROM Profile WHERE Name = 'Client Portal User'];
     User clientPortalUser = new User(
     LastName = 'Test',
     FirstName = 'Client',
     Alias = 'tuser',
     Email = 'Test.Client@testuser.com',
     Username = 'Test.Client@testuser.com',
     ProfileId = clientPortalUserProfile.Id,
     TimeZoneSidKey = 'GMT',
     LanguageLocaleKey = 'en_US',
     EmailEncodingKey = 'UTF-8',
     LocaleSidKey = 'en_US',
     IP_TempestDepartment__c = '1107',
     IP_TempestDivision__c = 'NTS',
     Brand__c = 'Blue Arrow',
     Department = '1107',
     ContactId = clientContact.Id
   );
   insert clientPortalUser;
    TestDataFactory.setupCustomSettings(candidateAccount.Id);
    TestDataFactory.setupUserProfileCustomSettings();

    User consultantUser = TestDataFactory.createUsers(
      User_Profile_Id__c.getValues('System Administrator').Profile_Id__c,
      1
    )[0];
    consultantUser.IP_TempestDepartment__c = '1107';
    insert consultantUser;

    List<Contact> candidates = TestDataFactory.createCandidate(
      candidateAccount.Id,
      4
    );

    Contact candidateSat2Fri = candidates[0];
    candidateSat2Fri.FirstName = 'Saturday';
    candidateSat2Fri.LastName = 'Friday Candidate';

    Contact candidateSun2Sat = candidates[1];
    candidateSun2Sat.FirstName = 'Sunday';
    candidateSun2Sat.LastName = 'Saturday Candidate';

    Contact candidateMon2Sun = candidates[2];
    candidateMon2Sun.FirstName = 'Monday';
    candidateMon2Sun.LastName = 'Sunday Candidate';

    Contact candidateMixed = candidates[3];

    Contact invoiceContact = TestDataFactory.createContact(
      clientAccount.Id,
      1
    )[0];
    invoiceContact.IP_ContactType__c = 'Invoice Contact';
    insert new List<Contact>{
      candidateSat2Fri,
      candidateSun2Sat,
      candidateMon2Sun,
      candidateMixed,
      invoiceContact
    };

    IP_TopazGlobalClientInformation__c topzClientInfo = TestDataFactory.createTopaz(
      1
    )[0];
    topzClientInfo.Name = clientAccount.Name;
    topzClientInfo.IP_SalesLedgerNumber__c = '345432';
    insert topzClientInfo;

    sirenum__Rota__c sector = TestDataFactory.createSector(1)[0];
    insert sector;

    List<sirenum__Site__c> siteList = TestDataFactory.createSites(
      clientAccount.Id,
      topzClientInfo.Id,
      3
    );

    sirenum__Site__c siteSF = siteList[0];
    siteSF.Name = 'Test Site One - Saturday To Friday';
    siteSF.Process_TS_Line_Automatically__c = true;

    sirenum__Site__c siteSS = siteList[1];
    siteSS.Name = 'Test Site Two - Sunday To Saturday';
    siteSS.Process_TS_Line_Automatically__c = true;

    sirenum__Site__c siteMS = siteList[2];
    siteMS.Name = 'Test Site Three - Monday To Sunday';
    siteMS.Process_TS_Line_Automatically__c = true;

    insert new List<sirenum__Site__c>{ siteSF, siteSS, siteMS };

    Map<String, sirenum__Payroll_Cycle__c> payrollCycles = TestDataFactory.getPayrollCycles();
    insert payrollCycles.values();

    List<sirenum__ProActiveContract__c> contracts = TestDataFactory.sirenumProActiveContract(
      clientAccount.Id,
      invoiceContact.Id,
      3
    );

    sirenum__ProActiveContract__c contractSatFri = contracts[0];
    contractSatFri.sirenum__PayrollCycle__c = payrollCycles.get(
        'Saturday to Friday'
      )
      .Id;

    sirenum__ProActiveContract__c contractSunSat = contracts[1];
    contractSunSat.sirenum__PayrollCycle__c = payrollCycles.get(
        'Sunday to Saturday'
      )
      .Id;

    sirenum__ProActiveContract__c contractMonSun = contracts[2];
    contractMonSun.sirenum__PayrollCycle__c = payrollCycles.get(
        'Monday to Sunday'
      )
      .Id;

    insert contracts;

    sirenum__Job_Type__c jobType = TestDataFactory.createJobType(
      sector.Id,
      1
    )[0];
    insert jobType;

    sirenum__Team__c jobroleSF = TestDataFactory.createJobRole(
      contractSatFri.Id,
      jobType.Id,
      1
    )[0];
    jobroleSF.Name =
      clientAccount.Name +
      ' - ' +
      site.Name +
      ' - Saturday to Friday';
    jobroleSF.IP_OPWIPSRole__c = 'No';
    jobroleSF.sirenum__Rota__c = sector.Id;

    sirenum__Team__c jobroleSS = TestDataFactory.createJobRole(
      contractSunSat.Id,
      jobType.Id,
      1
    )[0];
    jobroleSS.Name =
      clientAccount.Name +
      ' - ' +
      site.Name +
      ' - Sundayd to Saturday';
    jobroleSS.IP_OPWIPSRole__c = 'No';
    jobroleSS.sirenum__Rota__c = sector.Id;

    sirenum__Team__c jobroleMS = TestDataFactory.createJobRole(
      contractMonSun.Id,
      jobType.Id,
      1
    )[0];
    jobroleMS.Name =
      clientAccount.Name +
      ' - ' +
      site.Name +
      ' - Monday to Sunday';
    jobroleMS.IP_OPWIPSRole__c = 'No';
    jobroleMS.sirenum__Rota__c = sector.Id;

    insert new List<sirenum__Team__c>{ jobroleSF, jobroleSS, jobroleMS };

    Contact_Site_link__c siteLinkSF = new Contact_Site_link__c(
      Account__c = clientAccount.Id,
      IP_Contact__c = invoiceContact.Id,
      IP_PortalType__c = 'Primary Hours Approver',
      IP_Site__c = siteSF.Id
    );
    Contact_Site_link__c siteLinkSS = new Contact_Site_link__c(
      Account__c = clientAccount.Id,
      IP_Contact__c = invoiceContact.Id,
      IP_PortalType__c = 'Primary Hours Approver',
      IP_Site__c = siteSS.Id
    );
    Contact_Site_link__c siteLinkMS = new Contact_Site_link__c(
      Account__c = clientAccount.Id,
      IP_Contact__c = invoiceContact.Id,
      IP_PortalType__c = 'Primary Hours Approver',
      IP_Site__c = siteMS.Id
    );
    insert new List<Contact_Site_link__c>{ siteLinkSF, siteLinkSS, siteLinkMS };

    sirenum__Placement__c satToFriPlacement = new sirenum__Placement__c(
      Name = 'Saturday to Sunday Placement',
      IP_Consultant1LookupSplitShare__c = consultantUser.Id,
      sirenum__Contact__c = candidateSat2Fri.Id,
      sirenum__Site__c = siteSF.Id,
      sirenum__Job_Role__c = jobroleSF.Id,
      sirenum__Contract__c = contractSatFri.Id,
      sirenum__Status__c = 'Active',
      sirenum__Start_Date__c = Datetime.now()
        .addDays(-60)
        .date()
        .toStartOfWeek(),
      IP_Consultant1PercentageSplit__c = 100
    );
    sirenum__Placement__c sunToSatPlacement = new sirenum__Placement__c(
      Name = 'Sunday to Saturday Placement',
      IP_Consultant1LookupSplitShare__c = consultantUser.Id,
      sirenum__Contact__c = candidateSun2Sat.Id,
      sirenum__Site__c = siteSS.Id,
      sirenum__Job_Role__c = jobroleSS.Id,
      sirenum__Contract__c = contractSunSat.Id,
      sirenum__Status__c = 'Active',
      sirenum__Start_Date__c = Datetime.now()
        .addDays(-60)
        .date()
        .toStartOfWeek(),
      IP_Consultant1PercentageSplit__c = 100
    );
    sirenum__Placement__c montoSunPlacement = new sirenum__Placement__c(
      Name = 'Monday to Sunday Placement',
      IP_Consultant1LookupSplitShare__c = consultantUser.Id,
      sirenum__Contact__c = candidateMon2Sun.Id,
      sirenum__Site__c = siteMS.Id,
      sirenum__Job_Role__c = jobroleMS.Id,
      sirenum__Contract__c = contractSunSat.Id,
      sirenum__Status__c = 'Active',
      sirenum__Start_Date__c = Datetime.now()
        .addDays(-60)
        .date()
        .toStartOfWeek(),
      IP_Consultant1PercentageSplit__c = 100
    );
    insert new List<sirenum__Placement__c>{
      satToFriPlacement,
      sunToSatPlacement,
      montoSunPlacement
    };

    Datetime wsSatFri = Datetime.now()
      .date()
      .toStartOfWeek()
      .addDays(-1)
      .toStartOfWeek()
      .addDays(-2);
    Datetime wsSunSat = Datetime.now()
      .date()
      .toStartOfWeek()
      .addDays(-1)
      .toStartOfWeek()
      .addDays(-1);
    Datetime wsMonSun = Datetime.now()
      .date()
      .toStartOfWeek()
      .addDays(-1)
      .toStartOfWeek();

    sirenum__Shift__c shiftSatFri = TestDataFactory.getAShift(
      satToFriPlacement.Id,
      sector.Id,
      jobroleSF.Id,
      siteSF.Id,
      candidateSat2Fri.Id,
      wsSatFri
    );
    shiftSatFri.IP_ClientApproved__c = false;
    shiftSatFri.IP_Account__c = clientAccount.Id;

    sirenum__Shift__c shiftSunSat = TestDataFactory.getAShift(
      sunToSatPlacement.Id,
      sector.Id,
      jobroleSS.Id,
      siteSS.Id,
      candidateSun2Sat.Id,
      wsSunSat
    );
    shiftSatFri.IP_ClientApproved__c = false;
    shiftSunSat.IP_Account__c = clientAccount.Id;
    sirenum__Shift__c shiftMonSun = TestDataFactory.getAShift(
      monToSunPlacement.Id,
      sector.Id,
      jobroleMS.Id,
      siteMS.Id,
      candidateMon2Sun.Id,
      wsMonSun
    );
    shiftSatFri.IP_ClientApproved__c = false;
    shiftMonSun.IP_Account__c = clientAccount.Id;
    sirenum__Shift__c shiftSatFriMx = TestDataFactory.getAShift(
      satToFriPlacement.Id,
      sector.Id,
      jobroleSF.Id,
      siteSF.Id,
      candidateMixed.Id,
      wsSatFri
    );
    shiftSatFri.IP_ClientApproved__c = false;
    shiftMonSun.IP_Account__c = clientAccount.Id;
    sirenum__Shift__c shiftSunSatMx = TestDataFactory.getAShift(
      sunToSatPlacement.Id,
      sector.Id,
      jobroleSS.Id,
      siteSS.Id,
      candidateMixed.Id,
      wsSunSat
    );
    shiftSatFri.IP_ClientApproved__c = false;
    shiftSunSatMx.IP_Account__c = clientAccount.Id;
    sirenum__Shift__c shiftMonSunMx = TestDataFactory.getAShift(
      monToSunPlacement.Id,
      sector.Id,
      jobroleMS.Id,
      siteMS.Id,
      candidateMixed.Id,
      wsMonSun
    );
    shiftSatFri.IP_ClientApproved__c = false;
    shiftMonSunMx.IP_Account__c = clientAccount.Id;
    insert new List<sirenum__Shift__c>{
      shiftSatFri,
      shiftSunSat,
      shiftMonSun,
      shiftSatFriMx,
      shiftSunSatMx,
      shiftMonSunMx
    };

    insert new IP_Shift_Template__c(
      name = '1107',
      Email__c = 'test.test@test.com'
    );
  }

  @isTest
  static void fetchAdjustableColumnsTest() {
    List<Portal_V2_SM_Adjust_Columns__mdt> theCustomMetadata = PortalV2TimesheetsController.fetchAdjustableColumns();
    System.assert(
      theCustomMetadata.size() > 0,
      'Portal V2 Shift Management - No custom metadata configurations found.'
    );
  }

  @isTest
  static void getAllShiftRecordsTest() {
    Map<Id, sirenum__Site__c> theSites = new Map<Id, sirenum__Site__c>(
      [SELECT Id FROM sirenum__Site__c]
    );
    
    //Test execution
    User runningUser = [SELECT Id, ContactId FROM User WHERE Email='Test.Client@testuser.com' LIMIT 1];
    System.assertNotEquals(null, runningUser.ContactId, runningUser);
    List<sirenum__Shift__c> output = new List<sirenum__Shift__c>();
    System.runAs(runningUser){
    List<sirenum__Shift__c> theShiftRecords = PortalV2TimesheetsController.getAllShiftRecords(
      new List<Id>(theSites.keySet())
    );
    
    System.assert(
      theShiftRecords.size() > 0,
      'Portal V2 Shift Management - No shift records found.'
    );
    }
  }

  @isTest
  static void approveRejectShiftsTest() {
    Map<Id, sirenum__Shift__c> theShiftRecords = new Map<Id, sirenum__Shift__c>(
      [SELECT Id FROM sirenum__Shift__c]
    );

    String theResult = PortalV2TimesheetsController.approveRejectShifts(
      new List<Id>(theShiftRecords.keySet()),
      'approve',
      null
    );
    System.assert(
      theResult == 'success',
      'Portal V2 Shift Management - Not able to approve the selected shift records.'
    );

    theResult = PortalV2TimesheetsController.approveRejectShifts(
      new List<Id>(theShiftRecords.keySet()),
      'reject',
      'Shift Rejected.'
    );
    System.assert(
      theResult == 'success',
      'Portal V2 Shift Management - Not able to reject the selected shift records.'
    );
  }

  @isTest
  static void updateIndividualPOTest() {
    List<sirenum__Shift__c> toBeupdatedPONumbers = [
      SELECT Invoice_PO_Optional__c
      FROM sirenum__Shift__c
    ];
    for (sirenum__Shift__c theShift : toBeupdatedPONumbers) {
      theShift.Invoice_PO_Optional__c = '12345';
    }

    String theResult = PortalV2TimesheetsController.updateIndividualPO(
      toBeupdatedPONumbers
    );
    System.assert(
      theResult == 'success',
      'Portal V2 Shift Management - Not able to update individual PO numbers on the selected shift records.'
    );
  }

  @isTest
  static void updateBulkPOTest() {
    Map<Id, sirenum__Shift__c> theShiftRecords = new Map<Id, sirenum__Shift__c>(
      [SELECT Id FROM sirenum__Shift__c]
    );
    String theResult = PortalV2TimesheetsController.updateBulkPO(
      new List<Id>(theShiftRecords.keySet()),
      '54321'
    );
    System.assert(
      theResult == 'success',
      'Portal V2 Shift Management - Not able to update bulk PO numbers on the selected shift records.'
    );
  }

  @isTest
  static void amendOneBreakToAllShiftsTest() {
    Map<Id, sirenum__Shift__c> theShiftRecords = new Map<Id, sirenum__Shift__c>(
      [SELECT Id FROM sirenum__Shift__c]
    );
    String theResult = PortalV2TimesheetsController.amendOneBreakToAllShifts(
      new List<Id>(theShiftRecords.keySet()),
      '00:30:00.000'
    );
    System.assert(
      theResult == 'success',
      'Portal V2 Shift Management - Not able to amend one break on the selected shift records.'
    );
  }

  @isTest
  static void applyAmendedBreakToAllShiftsTest() {
    List<sirenum__Shift__c> toBeUpdatedShifts = [
      SELECT Invoice_PO_Optional__c
      FROM sirenum__Shift__c
    ];
    for (sirenum__Shift__c theShift : toBeUpdatedShifts) {
      theShift.Invoice_PO_Optional__c = '00:30:00.000';
    }

    String theResult = PortalV2TimesheetsController.applyAmendedBreakToAllShifts(
      toBeUpdatedShifts
    );
    System.assert(
      theResult == 'success',
      'Portal V2 Shift Management - Not able to apply amended breaks on the selected shift records.'
    );
  }

  @isTest
  static void applyAmendedShiftHoursToAllShiftsTest() {
    List<sirenum__Shift__c> toBeUpdatedShifts = [
      SELECT Starttime__c, EndTime__c
      FROM sirenum__Shift__c
    ];
    for (sirenum__Shift__c theShift : toBeUpdatedShifts) {
      theShift.Starttime__c = '09:30:00.000';
      theShift.EndTime__c = '17:00:00.000';
    }

    String theResult = PortalV2TimesheetsController.applyAmendedShiftHoursToAllShifts(
      toBeUpdatedShifts
    );
    System.assert(
      theResult == 'success',
      'Portal V2 Shift Management - Not able to amend actual start and actual end times on the selected shift records.'
    );
  }

  @isTest
  static void getEndorsements() {
    /*
            Setup
        */
    Account clientAcc = TestDataFactory.createClients(1)[0];
    insert clientAcc;

    Contact clientContact = TestDataFactory.createContact(clientAcc.Id, 1)[0];
    insert clientContact;

    Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
    insert candidateAcc;

    Contact candidateContact = TestDataFactory.createCandidate(
      candidateAcc.Id,
      1
    )[0];
    insert candidateContact;

    IP_TopazGlobalClientInformation__c topazClientInfo = TestDataFactory.createTopaz(
      1
    )[0];
    insert topazClientInfo;

    sirenum__Site__c site = [SELECT Id FROM sirenum__Site__c LIMIT 1];

    sirenum__Rota__c sector = TestDataFactory.createSector(1)[0];
    insert sector;

    sirenum__Job_Type__c jobType = TestDataFactory.createJobType(
      sector.Id,
      1
    )[0];
    insert jobType;

    Endorsement__c endorsement = new Endorsement__c(
      Account__c = clientAcc.Id,
      Candidate__c = candidateContact.Id,
      Job_Category__c = jobType.Id,
      Site__c = site.Id
    );
    insert endorsement;

    /*
            Execution
        */
    List<Endorsement__c> output = PortalV2TimesheetsController.getEndorsements(
      new List<String>{ jobType.Id + '' + candidateContact.Id + '' + site.Id }
    );

    /*
            Assertion
     
        */
    System.assertEquals(
      1,
      output.Size(),
      [SELECT Composite_Id__c FROM Endorsement__c]
      .Composite_Id__c +
      '' +
      'Error: ' +
      jobType.Id +
      '' +
      candidateContact.Id +
      '' +
      site.Id
    );
  }

  @IsTest
  public static void sendRejectionEmail() {
    // EmailTemplate validEmailTemplate = new EmailTemplate();
    // validEmailTemplate.isActive = true;
    // validEmailTemplate.Name = 'Send Rejection Email';
    // validEmailTemplate.DeveloperName = 'Client_Reject_Shift_on_Portal';
    // validEmailTemplate.TemplateType = 'text';
    // validEmailTemplate.FolderId = UserInfo.getUserId();
    // insert validEmailTemplate;
    List<sirenum__Shift__c> shiftList = [SELECT Id FROM sirenum__Shift__c];

    test.startTest();
    PortalV2TimesheetsController.SendRejectionToOwner(
      shiftList[0].Id,
      'abc',
      'String combinedComment'
    );
    test.stoptest();

    List<Task> taskList = [SELECT Id FROM Task];

    System.assert(!taskList.isEmpty());
  }
}