@IsTest
public class TestDataFactory {
  //Client-Account creation
  public static List<Account> createClients(Integer numberOfClients) {
    RecordType accountRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Account'
    ];
    List<Account> accounts = new List<Account>();
    for (Integer i = 0; i < numberOfClients; i++) {
      Account account = new Account(
        IP_Business_Type__c = 'Catering',
        Name = 'Client Name' + i,
        RecordTypeId = accountRec.id
      );
      accounts.add(account);
    }
    system.debug('test data factory Clients--' + accounts);
    return accounts;
  }

  //2ndTierSupplier-Account creation
  public static List<Account> create2ndTierSupplierAccount(
    Integer numberOfClients
  ) {
    RecordType accountRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'IP_2ndTierSupplier'
    ];
    List<Account> accounts = new List<Account>();
    for (Integer i = 0; i < numberOfClients; i++) {
      Account account = new Account(
        IP_Business_Type__c = 'Catering',
        Name = 'Client Name' + i,
        RecordTypeId = accountRec.id
      );
      accounts.add(account);
    }
    system.debug('test data factory Clients--' + accounts);
    return accounts;
  }

  //Candidate-Account creation
  public static List<Account> createCandidateAccount(Integer numberOfClients) {
    //RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate'];
    Id accountRecId = Schema.SObjectType.Account.getRecordTypeInfosByName()
      .get('Candidate')
      .getRecordTypeId();
    List<Account> accounts = new List<Account>();
    for (Integer i = 0; i < numberOfClients; i++) {
      Account account = new Account(
        Name = 'Candidates',
        RecordTypeId = accountRecId
      );
      accounts.add(account);
    }
    system.debug('test data factory Clients--' + accounts);
    return accounts;
  }

  //Account creation
  public static List<Account> createAccounts(Integer numberOfAccounts) {
    //RecordType accRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account'];
    Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName()
      .get('Account')
      .getRecordTypeId();
    List<Account> accounts = new List<Account>();
    for (Integer i = 0; i < numberOfAccounts; i++) {
      Account account = new Account(
        IP_Business_Type__c = 'Catering',
        Name = 'Account Name' + i,
        RecordTypeId = accRecId,
        IP_BusinessIncorporationNumber__c = '12345678'
      );
      accounts.add(account);
    }
    system.debug('test data factory  Accounts--' + accounts);
    return accounts;
  }

  //Contact creation
  public static List<Contact> createContact(
    Id AccountID,
    Integer numberOfContact
  ) {
    /*  Id AccountID=account id and account record type=Client */

    RecordType contRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Contact'
    ];
    List<Contact> Contacts = new List<Contact>();

    for (Integer k = 0; k < numberOfContact; k++) {
      Contact contact = new Contact(
        FirstName = 'cFirstName',
        LastName = 'cLastName',
        AccountID = AccountID,
        RecordTypeId = contRec.Id,
        MailingStreet = 'Mailing Street details',
        Salutation = 'Mr',
        MailingPostalCode = 'H1 2AA',
        sirenum__National_Insurance__c = 'AA123456A',
        ts2__EEO_Gender__c = 'M',
        Birthdate = Date.newInstance(2000, 12, 9),
        Email = 'test_cont' +
          (Math.random() * 1000).intValue() +
          '_' +
          k +
          '@testingmail.com'
      );
      Contacts.add(contact);
    }
    system.debug('test data factory Contact--' + Contacts);
    return Contacts;
  }

  //Candidate creation
  public static List<Contact> createCandidate(
    ID AccountID,
    Integer numberOfContact
  ) {
    /* AccountID = Account id, account RecordType=Account  */

    RecordType condRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Candidate'
    ];
    List<Contact> Contacts = new List<Contact>();
    for (Integer k = 0; k < numberOfContact; k++) {
      Contact contact = new Contact(
        AccountID = AccountID,
        RecordTypeId = condRec.id,
        FirstName = 'Test' + k,
        Salutation = 'Mr',
        MailingCity = 'TestCity' + k,
        MailingCountry = 'india',
        MailingPostalCode = 'A1 1BB' + k,
        MailingState = 'Haryana',
        LastName = 'candidate' + k,
        sirenum__National_Insurance__c = 'AA' + (323230 + k) + 'B',
        //IP_CandidateIDlegacy__c='dsdsdsdd',
        MailingStreet = k + ' Test',
        P45_Requested__c = false,
        PayrollLeaver__c = null,
        Email = 'testemail' +
          (Math.random() * 1000).intValue() +
          '_' +
          k +
          '@some.com',
        //Title = 'TestLastName',
        //Initials__c = 'TestLastName',
        Birthdate = Date.valueOf('1990-02-' + (1 + k)),
        Phone = '9879879877' + k,
        ts2__EEO_Gender__c = 'M',
        IP_CategoryOfWork__c = 'Catering'
      );

      Contacts.add(contact);
    }
    system.debug('test data factory  Candidate--' + Contacts);
    return Contacts;
  }

  //create Candidate 2ndTier creation

  //create Topaz Global
  public static List<Contact> createCandidate2ndTier(
    ID Clnt,
    Integer numberOfContact
  ) {
    //RecordType contRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'IP_2ndTierCandidate'];
    Id contRdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName()
      .get('2nd Tier Candidate')
      .getRecordTypeId();
    //Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('2nd Tier Candidate').getRecordTypeId();
    List<Contact> Contacts = new List<Contact>();
    for (Integer k = 0; k < numberOfContact; k++) {
      Contact contact = new Contact(
        Birthdate = Date.valueOf('1990-02-' + (1 + k)),
        Email = 'secondTierCandidate' +
          (Math.random() * 1000).intValue() +
          '_' +
          k +
          '@gmail.com',
        FirstName = 'SecondTier' + k,
        LastName = 'Candidate' + k,
        IP_MailingAddressLine1__c = 'c260' + k,
        IP_MailingAddressLine2__c = 'c2' + k,
        IP_MailingAddressLine3__c = 'c3' + k,
        IP_CandidateIDlegacy__c = 'd6tf233' + k,
        IP_WorkerStartDate__c = system.today(),
        WTR_Completed__c = true,
        MailingCity = 'ballia' + k,
        MailingCountry = 'india' + k,
        MailingState = 'up' + k,
        MailingPostalCode = 'A2 1BV' + k,
        Phone = '6776676776' + k,
        Salutation = 'Mr',
        Sirenum__National_Insurance__c = 'AA12345' + k + 'A',
        IP_PayFrequency__c = 342 + k,
        RecordTypeId = contRdTypeId, //contRec.Id,
        AccountID = Clnt,
        IP_Pass2ndTierToTempest__c = true,
        MailingStreet = 'Mailing Street details' + k
      );
      Contacts.add(contact);
    }
    system.debug('test data factory  Candidate 2nd Tier--' + Contacts);
    return Contacts;
  }

  public static ts2__Certification__c createCertificate(
    Id workerId,
    String rTName
  ) {
    id rTId = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName()
      .get(rTName)
      .getRecordTypeId();
    ts2__Certification__c cert = new ts2__Certification__c();
    cert.ts2__Contact__c = workerId;
    cert.RecordTypeId = rTId;
    cert.Valid_From__c = System.today();
    cert.Valid_To__c = System.today().addDays(10);
    cert.Verfied__c = true;
    return cert;
  }

  public static List<IP_TopazGlobalClientInformation__c> createTopaz(
    Integer numberOfRec
  ) {
    List<IP_TopazGlobalClientInformation__c> tpz = new List<IP_TopazGlobalClientInformation__c>();

    for (Integer j = 0; j < numberOfRec; j++) {
      IP_TopazGlobalClientInformation__c topazClient = new IP_TopazGlobalClientInformation__c(
        name = 'MyClient',
        IP_StatusID__c = 1
      );
      tpz.add(topazClient);
    }
    system.debug('test data factory  Topaz--' + tpz);
    return tpz;
  }
  //create createSites
  public static List<sirenum__Site__c> createSites(
    Id AccountId,
    Id topazClientId,
    Integer numberOfRec
  ) {
    /* AccountId=account id, topazClientId = IP_TopazGlobalClientInformation__c id */

    List<sirenum__Site__c> sites = new List<sirenum__Site__c>();
    for (Integer j = 0; j < numberOfRec; j++) {
      sirenum__Site__c ssite = new sirenum__Site__c(
        Name = 'my site',
        IP_InvoiceAddressCity__c = 'ballia',
        IP_InvoiceAddressStreet__c = 'street1',
        sirenum__Operating_Company__c = AccountId,
        GlobalClientName__c = topazClientId,
        IP_ClientIDLegacy__c = 'eww3' + j,
        IP_Clientinvoicename__c = 'invoice name',
        IP_InvoiceAddressCountry__c = 'ind',
        IP_InvoiceAddressCounty__c = 'cnt',
        IP_InvoiceAddressPostcode__c = 'E12 3DD',
        IP_PublicSector__c = 'No', //public sector should be NO
        IP_PassClientToTempest__c = true,
        IP_ClientLastPassedToTempest__c = null,
        Credit_Status__c = 'Credit Approved',
        //sirenum__Postal_Code__c = 'TE12 3AA',
        IP_PassClientAddressToTempest__c = true
      );
      sites.add(ssite);
    }
    system.debug('test data factory  Sites--' + sites);
    return sites;
  }

  //create site link
  public static List<Contact_Site_link__c> createSiteLinks(
    Id clientId,
    Id siteId,
    List<Id> clientContactIds
  ) {
    List<Contact_Site_link__c> siteLinks = new List<Contact_Site_link__c>();
    for (Id ccId : clientContactIds) {
      siteLinks.add(
        new Contact_Site_link__c(
          Account__c = clientId,
          IP_Site__c = siteId,
          IP_Contact__c = ccId,
          IP_PortalType__c = 'Primary Hours Approver'
        )
      );
    }
    return siteLinks;
  }

  //create User
  public static List<User> createUsers(Id profileId, Integer numberOfRec) {
    /* profileId=profile Id*/

    List<User> usrs = new List<User>();
    for (Integer j = 0; j < numberOfRec; j++) {
      String emailStr =
        'mm.sf' +
        (Math.random() * 1000).intValue() +
        '_' +
        j +
        '@outlook.com';
      DateTime dt = DateTime.newInstance(2007, 6, 23, 3, 3, 3);
      Long gettime = dt.getTime();
      User usr = new User(
        LastName = 'LIVESTON',
        FirstName = 'JASON',
        Alias = 'jliv',
        Email = emailStr,
        Username = emailStr,
        ProfileId = profileId,
        TimeZoneSidKey = 'GMT',
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LocaleSidKey = 'en_US',
        IP_TempestDepartment__c = '1107',
        IP_TempestDivision__c = 'NTS',
        Brand__c = 'Blue Arrow',
        Department = '1107',
        IP_PassToTempest__c = true
      );
      usrs.add(usr);
    }
    system.debug('test data factory  Users--' + usrs);
    return usrs;
  }

  /**
   * CALL TO CREATE CLIENT OR CANDIDATE COMMUNITY USER
   *
   * @param CONTACT
   * @param profileId
   *
   * @return User record
   */
  public static User createCommunityUser(Contact con, Id profileId) {
    return new User(
      LastName = con.LastName,
      FirstName = con.FirstName,
      Alias = con.FirstName.substring(1, 3) +
        con.LastName.substring(1, 3) +
        (Math.random() * 100).intValue(),
      Email = con.Email,
      Username = con.Email,
      ProfileId = profileId,
      TimeZoneSidKey = 'GMT',
      LanguageLocaleKey = 'en_US',
      EmailEncodingKey = 'UTF-8',
      LocaleSidKey = 'en_US',
      IP_TempestDivision__c = 'NTS',
      ContactId = con.Id
    );
  }

  /**
   * CALL THIS METHOD AS FOLLOWS
   *
   * TestDataFactory.insertUser(JSON.serialize(clientUser));
   * clientUser IS A USER RECORD WHICH WILL BE INSERTED
   *
   * @param userDetailsJSON
   */
  @future
  public static void insertUser(List<String> userDetailsJSONList) {
    System.debug('In future method - userDetailsJSON: ' + userDetailsJSONList);
    List<User> userList = new List<User>();
    for (String userDetailsJSON : userDetailsJSONList) {
      User userRecord = (User) JSON.deserialize(userDetailsJSON, User.class);
      userList.add(userRecord);
    }
    if (userList.size() > 0) {
      insert userList;
    }
    System.debug('userList size>>>> ' + userList.size());
  }
  /*Create pay profile*/
  public static List<IP_PayProfile__c> createPayProfilePaye(
    Id candidateId,
    Integer numberOfRec
  ) {
    // String RecType - PAYE
    insert new IP_JSToFrostSwtich__c(
      name = 'JSToFrost',
      IP_RunJSToFrost__c = false
    );
    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
    Id rtPayeId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName()
      .get('PAYE')
      .getRecordTypeId();
    //RecordType condRec = [Select Id  From RecordType Where sObjectType = 'IP_PayProfile__c' And DeveloperName='PAYE'];

    List<IP_PayProfile__c> pps = new List<IP_PayProfile__c>();
    for (Integer j = 0; j < numberOfRec; j++) {
      IP_PayProfile__c pp = new IP_PayProfile__c(
        IP_Candidate__c = candidateId,
        //IP_PayrollStatus__c
        IP_PrimaryPayMethod__c = true,
        IP_NewStarterTaxStatus__c = 'B',
        IP_StudentLoan__c = 'N',
        //IP_Candidate_Branch__c = '2364',
        //IP_Branch_Code__c = '7777',
        IP_PaymentType__c = 'BACS',
        IP_Status__c = 'Active',
        RecordTypeId = rtPayeId,
        IP_PassToTempest__c = false,
        IP_LastPassedToTempest__c = system.today(),
        IP_CompanyRegNo__c = 'AS123456'
      );
      pps.add(pp);
    }
    system.debug('test data factory Pay Profile Paye--' + pps);
    return pps;
  }

  /*Create contract*/
  public static List<sirenum__ProActiveContract__c> sirenumProActiveContract(
    Id accountId,
    Id ContactId,
    Integer numberOfRec
  ) {
    List<sirenum__ProActiveContract__c> pac = new List<sirenum__ProActiveContract__c>();
    for (Integer j = 0; j < numberOfRec; j++) {
      sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c(
        Name = 'contact name',
        sirenum__Client__c = accountId,
        sirenum__Employee__c = ContactId,
        sirenum__AWR_Eligable__c = true
      );
      pac.add(contract);
    }
    system.debug('test data factory sirenum ProActive Contract--' + pac);
    return pac;
  }

  /*Create Sector*/
  public static List<sirenum__Rota__c> createSector(Integer numberOfRec) {
    List<sirenum__Rota__c> rotaAdd = new List<sirenum__Rota__c>();
    for (Integer j = 0; j < numberOfRec; j++) {
      sirenum__Rota__c sector = new sirenum__Rota__c(Name = 'Imapellam');
      rotaAdd.add(sector);
    }
    system.debug('test data factory Sector--' + rotaAdd);
    return rotaAdd;
  }

  /*Create job type*/
  public static List<sirenum__Job_Type__c> createJobType(
    Id sectorId,
    Integer numberOfRec
  ) {
    List<sirenum__Job_Type__c> jobAdd = new List<sirenum__Job_Type__c>();
    for (Integer j = 0; j < numberOfRec; j++) {
      sirenum__Job_Type__c jobCategory = new sirenum__Job_Type__c(
        Impellam_Sector__c = sectorId,
        Impellam_Core_Category__c = 'Administration -ADM',
        Impellam_Job_Category__c = 'Administrator -OA001'
      );
      jobAdd.add(jobCategory);
    }
    system.debug('test data factory JobType--' + jobAdd);
    return jobAdd;
  }

  /*Create job role*/
  public static List<sirenum__Team__c> createJobRole(
    Id contractId,
    Id jobCategoryId,
    Integer numberOfRec
  ) {
    List<sirenum__Team__c> jobRoleAdd = new List<sirenum__Team__c>();
    for (Integer j = 0; j < numberOfRec; j++) {
      sirenum__Team__c jobrole = new sirenum__Team__c(
        Name = 'job role',
        sirenum__Account__c = contractId,
        sirenum__Job_Type__c = jobCategoryId,
        IP_OPWIPSRole__c = 'No'
        // OPWIPS Populate value should be No
      );
      jobRoleAdd.add(jobrole);
    }
    system.debug('test data factory JobRole--' + jobRoleAdd);
    return jobRoleAdd;
  }

  /*Create s-Placement*/
  public static List<sirenum__Placement__c> createSPlacement(
    Id candidateId,
    Id contractID,
    Id jobroleId,
    Id UserId,
    Integer numberOfRec
  ) {
    List<sirenum__Placement__c> placementAdd = new List<sirenum__Placement__c>();
    for (Integer j = 0; j < numberOfRec; j++) {
      sirenum__Placement__c placement = new sirenum__Placement__c(
        IP_Consultant1LookupSplitShare__c = UserId,
        sirenum__Contact__c = candidateId,
        sirenum__Contract__c = contractID,
        sirenum__Start_Date__c = system.today(),
        sirenum__Job_Role__c = jobroleId,
        Name = 's-placement',
        IP_PassToTempest__c = true,
        IP_PurchaseOrderNumber__c = 'dd',
        sirenum__End_Date__c = system.today(),
        OPWIPS__c = 'Y', // should be N
        IP_LastPassedToTempest__c = system.today()
      );
      placementAdd.add(placement);
    }
    system.debug('test data factory s-placement--' + placementAdd);
    return placementAdd;
  }

  public static List<sirenum__Placement__c> createSPlacement1(
    Id candidateId,
    Id contractID,
    Id jobroleId,
    Id UserId,
    Integer numberOfRec
  ) {
    List<sirenum__Placement__c> placementAdd = new List<sirenum__Placement__c>();
    for (Integer j = 0; j < numberOfRec; j++) {
      sirenum__Placement__c placement = new sirenum__Placement__c(
        IP_Consultant1LookupSplitShare__c = UserId,
        sirenum__Contact__c = candidateId,
        sirenum__Contract__c = contractID,
        sirenum__Start_Date__c = system.today(),
        sirenum__Job_Role__c = jobroleId,
        Name = 's-placement',
        IP_PassToTempest__c = true,
        IP_PurchaseOrderNumber__c = 'dd',
        sirenum__End_Date__c = system.today(),
        OPWIPS__c = 'N' // should be N
        // IP_LastPassedToTempest__c=system.today()
      );
      placementAdd.add(placement);
    }
    system.debug('test data factory s-placement--' + placementAdd);
    return placementAdd;
  }

  /*Create shift*/
  public static List<sirenum__Shift__c> createShift(
    Id placementId,
    Id siteId,
    Integer numberOfRec
  ) {
    List<sirenum__Shift__c> sftAdd = new List<sirenum__Shift__c>();
    for (Integer j = 0; j < numberOfRec; j++) {
      sirenum__Shift__c sft = new sirenum__Shift__c(
        sirenum__Invalid_shift__c = true,
        sirenum__Placement__c = placementId,
        sirenum__Site__c = siteId
      );
      sftAdd.add(sft);
    }
    system.debug('shift data at test data factory--' + sftAdd);
    return sftAdd;
  }

  /**
   * USE THIS METHOD IF A SINGLE SHIFT FOR A CANDIDATE IS REQUIRED
   *
   * @param placementId
   * @param sectorId
   * @param jobroleId
   * @param siteId
   * @param clientContactId
   * @param startDate
   *
   * @return sirenum__Shift__c
   */
  public static sirenum__Shift__c getAShift(
    Id placementId,
    Id sectorId,
    Id jobroleId,
    Id siteId,
    Id workerId,
    Datetime startDate
  ) {
    sirenum__Shift__c shift = new sirenum__Shift__c();
    shift.sirenum__Invalid_shift__c = true;
    shift.sirenum__Site__c = siteId;
    //shift.sirenum__Invalid_shift__c = false;
    shift.sirenum__Placement__c = placementId;
    shift.sirenum__Rota__c = sectorId;
    shift.sirenum__Team__c = jobroleId;
    //shift.sirenum__Timesheet_summaries__c = timesheet.id;
    shift.sirenum__Site__c = siteId;
    shift.sirenum__Published__c = true;
    shift.sirenum__Contact__c = workerId;
    shift.sirenum__Cancelled__c = false;
    shift.sirenum__Published_Ever__c = true;
    shift.sirenum__Scheduled_Start_Time__c = startDate;
    shift.sirenum__Scheduled_End_Time__c = startDate.addHours(8);
    shift.sirenum__Actual_Start_Time__c = startDate;
    shift.sirenum__Actual_End_Time__c = startDate.addHours(8);
    shift.IP_CandidateApproved__c = true;
    shift.IP_ClientRejected__c = false;
    shift.sirenum__Allow_pay__c = true;
    shift.sirenum__Allow_charge__c = true;
    shift.sirenum__Cancelled__c = false;
    return shift;
  }

  /*Create time sheet*/
  public static List<sirenum__Timesheet__c> createTimeSheet(
    Id clientId,
    Id candidateId,
    Integer numberOfRec
  ) {
    List<sirenum__Timesheet__c> tsAdd = new List<sirenum__Timesheet__c>();
    for (Integer j = 0; j < numberOfRec; j++) {
      sirenum__Timesheet__c sts = new sirenum__Timesheet__c(
        sirenum__Client__c = clientId,
        sirenum__Worker__c = candidateId,
        sirenum__Week_Ending__c = system.today(),
        sirenum__Non_Taxed_Expenses__c = 34.2,
        sirenum__Taxed_Expenses__c = 22.2,
        sirenum__Non_Taxed_Deductions__c = 22.0,
        sirenum__Taxed_Deductions__c = 22.1,
        IP_DuplicateCheckPassOK__c = true
      );

      tsAdd.add(sts);
    }
    return tsAdd;
  }

  /*Create time sheet line*/
  public static List<sirenum__Timesheet_Line__c> createTimeSheetLine(
    Id TimeSheetID,
    Id ShiftId,
    Integer numberOfRec
  ) {
    List<sirenum__Timesheet_Line__c> tslAdd = new List<sirenum__Timesheet_Line__c>();
    for (Integer j = 0; j < numberOfRec; j++) {
      sirenum__Timesheet_Line__c stl = new sirenum__Timesheet_Line__c(
        sirenum__Timesheet__c = TimeSheetID,
        sirenum__Rate__c = 22.0,
        sirenum__Hours__c = 1,
        IP_PassToTempest__c = true,
        //IP_RateCodes__c='Taxable Expenses /TX',
        For_BatchClass__c = true,
        sirenum__Shift__c = ShiftId
      );
      tslAdd.add(stl);
    }
    return tslAdd;
  }

  /*Create ts2 Job */
  public static List<ts2__Job__c> createT2Job(Id UserId, Integer numberOfRec) {
    List<ts2__Job__c> AddJob = new List<ts2__Job__c>();
    for (Integer j = 0; j < numberOfRec; j++) {
      ts2__Job__c jb = new ts2__Job__c(
        Name = 'job name',
        ts2__Recruiter__c = UserId,
        Expected_Close_Date__c = system.today()
      );
      AddJob.add(jb);
    }
    system.debug('test data factory ts2__Job__c--' + AddJob);
    return AddJob;
  }

  /*Create ts2 Placement */
  public static List<ts2__Placement__c> createTs2Placement(
    Id clientId,
    Id candidateId,
    Id contactId,
    Id jobroleId,
    Id siteId,
    String RecordTypeName,
    Integer numberOfRec
  ) {
    RecordType perms = [
      SELECT Id
      FROM RecordType
      WHERE
        DeveloperName = :RecordTypeName
        AND sObjectType = 'ts2__Placement__c'
    ];
    //Id permsId = Schema.SObjectType.ts2__Placement__c.getRecordTypeInfosByDeveloperName().get('').getRecordTypeId();
    List<ts2__Placement__c> tplacementAdd = new List<ts2__Placement__c>();
    for (Integer j = 0; j < numberOfRec; j++) {
      ts2__Placement__c placement2 = new ts2__Placement__c(
        ts2__Job__c = jobroleId,
        sirenum_js__Site__c = siteId,
        ts2__Employee__c = candidateId,
        ts2__Hiring_Manager__c = contactId,
        ts2__Client__c = clientId,
        ts2__Sales_Rep_Pct__c = 100,
        ts2__Sales_Rep_Pct_2__c = 100,
        ts2__Start_Date__c = system.today(),
        ts2__Salary__c = 23.4,
        ts2__Fee_Pct__c = 23.4,
        ts2__Filled_Pct__c = 23.4,
        ts2__Filled_Pct_2__c = 23.4,
        IP_LastPassedToTempest__c = null,
        IP_PassToTempest__c = true,
        RecordTypeId = perms.Id
      );
      tplacementAdd.add(placement2);
    }
    system.debug('test data factory ts2__Placement__c--' + tplacementAdd);
    return tplacementAdd;
  }

  /*Create ts2 Placement */
  public static List<sirenum__AWR__c> createAWR(
    Id candidateId,
    Id accountId,
    Integer numberOfRec
  ) {
    List<sirenum__AWR__c> listAWR = new List<sirenum__AWR__c>();
    for (Integer j = 0; j < numberOfRec; j++) {
      sirenum__AWR__c awr = new sirenum__AWR__c(
        sirenum__Contact__c = candidateId,
        sirenum__Client__c = accountId,
        sirenum__Valid_Until__c = system.today() + 2,
        sirenum__AWR_Group__c = 'ABC'
      );
      listAWR.add(awr);
    }
    system.debug('test data factory AWR-->' + listAWR);
    return listAWR;
  }

  /*Create Umbrella list */
  public static List<IP_Umbrellalist__c> createUmbrellaList(
    Integer numberOfRec
  ) {
    List<IP_Umbrellalist__c> listUmbrella = new List<IP_Umbrellalist__c>();
    for (Integer j = 0; j < numberOfRec; j++) {
      IP_Umbrellalist__c umbr = new IP_Umbrellalist__c(
        Name = 'UmbrellaName',
        IP_AddressLine1__c = 'Address1',
        IP_AddressLine2__c = 'address2',
        IP_AddressLine3__c = 'address3',
        IP_BankAccountName__c = 'bankactname',
        IP_BankAccountNumber__c = '132132',
        IP_BankSortCode__c = '432345',
        IP_BuildingSocietyNo__c = '4ewe',
        IP_CompanyRegNo__c = '13213212',
        IP_OkToSupply__c = 1,
        IP_PaymentType__c = 'c',
        IP_Postcode__c = 'CV12 4AA',
        IP_SupplierReference__c = 'Suppl',
        VAT_Number__c = '123132132',
        IP_VATRegistered__c = 1
      );
      listUmbrella.add(umbr);
    }
    system.debug('test data factory Umbrella list-->' + listUmbrella);
    return listUmbrella;
  }

  public static List<IP_PayProfile__c> createPayProfileLtd(
    Id candidateId,
    Integer numberOfRec
  ) {
    // String RecType - LTD

    RecordType condRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'IP_PayProfile__c' AND DeveloperName = 'LTD'
    ];
    insert new IP_JSToFrostSwtich__c(
      name = 'JSToFrost',
      IP_RunJSToFrost__c = true
    );

    List<IP_PayProfile__c> pps = new List<IP_PayProfile__c>();
    for (Integer j = 0; j < numberOfRec; j++) {
      IP_PayProfile__c pp = new IP_PayProfile__c(
        IP_Candidate__c = candidateId,
        IP_PaymentType__c = 'BACS',
        IP_Status__c = 'Active',
        RecordTypeId = condRec.id,
        IP_PassToTempest__c = false,
        IP_LastPassedToTempest__c = system.today(),
        IP_CompanyRegNo__c = 'AS123456',
        IP_OkToSupply__c = 1.0
      );
      pps.add(pp);
    }
    system.debug('test data factory Pay Profile Paye--' + pps);
    return pps;
  }

  /**
     * @return - a list of 3 payroll cycles
        Saturday to Friday
        Sunday to Saturday
        Monday to Sunday
     */
  public static Map<String, sirenum__Payroll_Cycle__c> getPayrollCycles() {
    Map<String, sirenum__Payroll_Cycle__c> pcMap = new Map<String, sirenum__Payroll_Cycle__c>();
    Datetime dt = Datetime.now().addMonths(-1);

    for (Integer cyNo = -2; cyNo < 2; cyNo++) {
      String pcName =
        ((Datetime) dt.date().toStartOfWeek().addDays(cyNo)).format('EEEE') +
        ' to ' +
        ((Datetime) dt.date().toStartOfWeek().addDays(cyNo - 1)).format('EEEE');
      pcMap.put(
        pcName,
        new sirenum__Payroll_Cycle__c(
          Name = pcName,
          sirenum__StartingDate__c = dt.date().toStartOfWeek().addDays(cyNo),
          sirenum__periodLength__c = 1,
          sirenum__CyclePeriodUnits__c = 'Weeks'
        )
      );
    }

    System.debug('>>> TestDataFactory:: Payroll Cycle:: ' + pcMap);
    return pcMap;
  }

  public static List<sirenum__WorkSchedule__c> createWorkSchedules(
    Id clientId,
    Integer numberOfRec
  ) {
    List<sirenum__WorkSchedule__c> wsList = new List<sirenum__WorkSchedule__c>();
    for (Integer i = 0; i < numberOfRec; i++) {
      wsList.add(
        new sirenum__WorkSchedule__c(
          Name = 'Test week' + i,
          sirenum__Account__c = clientId,
          sirenum__Length__c = 7
        )
      );
    }
    return wsList;
  }

  public static List<sirenum__JobOrder__c> createJobOrders(
    Id clientId,
    Id contractId,
    Id jobTypeId,
    Id siteId,
    Id jobRoleId,
    Id workSchedulelId,
    Integer numberOfRec
  ) {
    List<sirenum__JobOrder__c> jobOrders = new List<sirenum__JobOrder__c>();
    for (Integer i = 0; i < numberOfRec; i++) {
      jobOrders.add(
        new sirenum__JobOrder__c(
          Name = 'Test Job Order' + i,
          sirenum__Account__c = clientId,
          sirenum__Contract__c = contractId,
          sirenum__JobType__c = jobTypeId,
          sirenum__JobRole__c = jobRoleId,
          sirenum__Site__c = siteId,
          sirenum__StartDate__c = Datetime.now()
            .addDays(-30)
            .date()
            .toStartOfWeek(),
          sirenum__EndDate__c = Datetime.now()
            .addMonths(2)
            .date()
            .toStartOfWeek(),
          sirenum__WorkSchedule__c = workSchedulelId,
          sirenum__Status__c = 'Ongoing',
          Minimum_Wage__c = 10.50,
          Job_Order_SLA__c = 24.00,
          Date_Confirmed__c = Datetime.now().addDays(-1)
        )
      );
    }
    return jobOrders;
  }

  /**
   * THIS IS FOR VMS INTEGRATION. Staging Job order
   *
   * @param numOfRec
   *
   * @return
   */
  public static List<StagingJobOrder__c> createStagingJobOrders(
    Integer numOfRec
  ) {
    List<StagingJobOrder__c> sjobs = new List<StagingJobOrder__c>();
    for (Integer i = 0; i < numOfRec; i++) {
      sjobs.add(
        new StagingJobOrder__c(
          StgClient_Id__c = 'EVO',
          StgClientName__c = 'EVO - Test Client',
          StgCreatedDate__c = String.valueOf(Datetime.now().Date()),
          StgEndDate__c = String.valueOf(Datetime.now().addDays(60).Date()),
          StgEndTime__c = Datetime.now().addHours(10).format('hh:mm'),
          StgFrontOfficeIntegrationSystem__c = 'Blue Arrow',
          StgHasShifts__c = 'true',
          StgJobTitle__c = 'EVO - Test Job title',
          StgLocationId__c = 'EVO-LOCATION-ID-' +
            (Math.random() * 10).intValue(),
          StgLocationName__c = 'EVO-LOCATION-NAME-' +
            (Math.random() * 10).intValue(),
          StgQuantity__c = '1',
          StgRequiredStaff__c = '1',
          StgRoleId__c = 'EVO-ROLE-ID-' + (Math.random() * 10).intValue(),
          StgRoleRequirement__c = 'No Requirement yet',
          StgStartDate__c = String.valueOf(Datetime.now().addDays(1).Date()),
          StgStartTime__c = Datetime.now().addHours(1).format('hh:mm'),
          StgUpdatedDate__c = String.valueOf(Datetime.now().Date()),
          StgSourceSystem__c = 'EVO-SNAPLOGIC'
        )
      );
    }
    return sjobs;
  }
  /**
   * THIS IS FOR VMS INTEGRATION. Staging Shifts related to Staging Job Order
   *
   * @param sJobOrdId Staging Job Order Salesforce record Id
   * @param numOfRec
   *
   * @return
   */
  public static List<StagingShift__c> createStagingShifts(
    StagingJobOrder__c sJobOrd,
    Integer numOfRec
  ) {
    List<StagingShift__c> sShifts = new List<StagingShift__c>();
    for (Integer i = 0; i < numOfRec; i++) {
      sShifts.add(
        new StagingShift__c(
          Staging_Job_Order__c = sJobOrd.Id,
          StgClientID__c = sJobOrd.StgClient_Id__c,
          StgClientName__c = sJobOrd.StgClientName__c,
          StgCreatedDate__c = sJobOrd.StgCreatedDate__c,
          StgFrontOfficeIntegrationSystem__c = sJobOrd.StgFrontOfficeIntegrationSystem__c,
          StgFrontOfficeIntegrationSystemEntity__c = 'BA',
          StgJobTitle__c = sJobOrd.StgJobTitle__c,
          StgLocationId__c = sJobOrd.StgLocationId__c,
          StgLocationName__c = sJobOrd.StgLocationName__c,
          StgPlacement__c = 'EVO-PLACEMENT-ID-' +
            (Math.random() * 10).intValue(),
          StgQuantity__c = sJobOrd.StgQuantity__c,
          StgRoleEndDate__c = sJobOrd.StgStartDate__c,
          StgRoleId__c = sJobOrd.StgRoleId__c,
          StgRoleStartDate__c = sJobOrd.StgStartDate__c,
          StgSector__c = 'TEST-SECTOR',
          StgShiftEndTime__c = sJobOrd.StgEndTime__c,
          StgShiftId__c = 'EVO-SHIFT-ID-' + (Math.random() * 10).intValue(),
          StgShiftStartTime__c = sJobOrd.StgStartTime__c,
          StgShiftStatus__c = 'Booked',
          StgUpdatedDate__c = sJobOrd.StgUpdatedDate__c,
          StgSourceSystem__c = sJobOrd.StgSourceSystem__c
        )
      );
    }
    return sShifts;
  }

  /**
   * THIS IS FOR VMS Integration. Job application for inbound call to update the application status
   *
   * @param numberOfRec
   *
   * @return
   */
  public static List<StagingJobApplication__c> createStagingJobApplications(
    String workerId,
    String payProfileId,
    String stgVmsRoleId,
    String stgVmsClientId,
    Integer numberOfRec
  ) {
    List<StagingJobApplication__c> jobApls = new List<StagingJobApplication__c>();
    for (Integer i = 0; i < numberOfRec; i++) {
      jobApls.add(
        new StagingJobApplication__c(
          stgAtsCandidateIntegrationRef__c = workerId,
          stgFrontOfficeIntegrationSystem__c = 'BA',
          stgPayProfile__c = payProfileId,
          stgSubmissionDatetime__c = Datetime.now(),
          stgVmsClientId__c = stgVmsClientId,
          stgVmsRoleId__c = stgVmsRoleId
        )
      );
    }
    return jobApls;
  }

  public static List<Subscriptions__c> createJobOrderSubscription(
    Id clientAccId,
    Id jobOrderId,
    List<Id> supplierUserIds
  ) {
    List<Subscriptions__c> subscriptions = new List<Subscriptions__c>();
    for (Id userId : supplierUserIds) {
      subscriptions.add(
        new Subscriptions__c(
          Account__c = clientAccId,
          Supplier_Email_Sent__c = false,
          Supplier_Job_Order_Notification__c = true,
          //,Supplier_SLA_Email_Date__c = Datetime.now().addMinutes(-5)
          Job_Order__c = jobOrderId,
          User__c = userId
        )
      );
    }
    return subscriptions;
  }

  public static List<JSForms__Form__c> createJSForms(String brand) {
    List<JSForms__Form__c> forms = new List<JSForms__Form__c>();
    forms.add(
      new JSForms__Form__c(
        JSForms__Title__c = brand + ' Reference Survey - Professional',
        JSForms__Encrypted_Id__c = 'as3453tfedfdste4tfdsf17'
      )
    );
    forms.add(
      new JSForms__Form__c(
        JSForms__Title__c = brand + ' Reference Survey - Personal',
        JSForms__Encrypted_Id__c = 'as3453tfedfdste4tfdsf18'
      )
    );
    forms.add(
      new JSForms__Form__c(
        JSForms__Title__c = brand + ' Reference Survey - Academic',
        JSForms__Encrypted_Id__c = 'as3453tfedfdste4tfdsf19'
      )
    );
    return forms;
  }

  public static void setupUserProfileCustomSettings() {
    List<User_Profile_Id__c> userProfiles = new List<User_Profile_Id__c>();
    for (Profile p : [SELECT Id, Name FROM Profile]) {
      userProfiles.add(
        new User_Profile_Id__c(
          Name = p.Name.length() > 35 ? p.Name.left(35) : p.Name,
          Profile_Id__c = p.Id
        )
      );
    }
    insert userProfiles;
    System.debug('userProfiles >>> ' + userProfiles);
  }

  public static EmailTemplate getEmailTemplate() {
    EmailTemplate testEmailTemplate = new EmailTemplate();
    testEmailTemplate.isActive = true;
    testEmailTemplate.Name = 'TestEmailTemplate';
    testEmailTemplate.DeveloperName = 'TestEmailTemplate';
    testEmailTemplate.TemplateType = 'text';
    testEmailTemplate.FolderId = UserInfo.getUserId();
    insert testEmailTemplate;
    return testEmailTemplate;
  }

  public static void setupCustomSettings(Id candidateAccId) {
    insert new DefaultAccounts__c(
      Name = 'Candidates',
      Account_Id__c = candidateAccId
    );
    System.debug('DefaultAccounts__c setup completed');
    insert new Payroll_Swtich__c(Name = 'Stoppayroll', Batch_check__c = false);
    insert new IP_JSToFrostSwtich__c(
      name = 'JSToFrost',
      IP_RunJSToFrost__c = true
    );
    insert new Impellam_Settings__c(
      Name = 'AutoTimesheetInterval',
      Limit__c = '1'
    );
    insert new Impellam_Settings__c(
      Name = 'AutoTimesheetNotificationEmail',
      Email__c = 'test_mail@testmail.com'
    );
    insert new IP_Shift_Template__c(
      Name = '1010',
      Email__c = 'test_mail@testmail.com',
      IP_Site_Name__c = 'Test Site',
      IP_Branch_Country__c = 'Test Country',
      IP_Branch_County__c = 'Test Country'
    );
  }

  /**
     * CREATE SHIFT FOR EACH PAY CYCLE INCLUDING ALL DEPENDENT RECORDS IN VARIOUS OBJECTS
     * CALL THIS METHOD FROM THE TEST CLASS AND USE SELECT STATEMENTS TO GET ALL TEST DATA
     * FOR EXAMPLE FOLLOWING QUERY RETURNS ALL RELATED OBJECT IDS TO BE USED IN THE TEST -
     *  User clientUser = [SELECT id , contactId
                            FROM User
                            WHERE ContactId IN (SELECT Id FROM Contact) LIMIT 1];
        Contact clientContact = [SELECT Id, Name, AccountId FROM Contact WHERE Id =: clientUser.ContactId];
        sirenum__Shift__c shift = [SELECT Id, Name
                                            ,sirenum__Site__r.Id
                                            ,sirenum__Team__r.Id
                                            ,sirenum__Contact__r.Id
                                            ,sirenum__Scheduled_Start_Time__c
                                            ,sirenum__Scheduled_End_Time__c
                                     FROM sirenum__Shift__c
                                    WHERE sirenum__Site__r.sirenum__Operating_Company__r.Id =: clientContact.AccountId
                                    LIMIT 1];
     */
  public static void setupShifts() {
    //USER RECORD - RECRUITER PROFILE Name='JS Recruiter - Hybrid'
    setupUserProfileCustomSettings();

    //CANIDDATE ACCOUNT
    Account candiAcc = createCandidateAccount(1)[0];
    //CLIENT ACCOUTN
    Account clientAcc = createAccounts(1)[0];
    insert new List<Account>{ candiAcc, clientAcc };
    setupCustomSettings(candiAcc.Id);

    //CANDIDATE - Contact
    List<Contact> candidates = createCandidate(candiAcc.Id, 4);
    Contact candiSat2Fri = candidates[0];
    candiSat2Fri.FirstName = 'Saturday';
    candiSat2Fri.LastName = 'Friday Candidate';
    Contact candiSun2Sat = candidates[1];
    candiSun2Sat.FirstName = 'Sunday';
    candiSun2Sat.LastName = 'Saturday Candidate';
    Contact candiMon2Sun = candidates[2];
    candiMon2Sun.FirstName = 'Monday';
    candiMon2Sun.LastName = 'Sunday Candidate';
    Contact candiMixed = candidates[3];
    System.debug('candidates>>>> ' + candidates);

    //CLIENT CONTACT - Contact
    Contact invoiceContact = createContact(clientAcc.Id, 1)[0];
    invoiceContact.IP_ContactType__c = 'Invoice Contact';
    insert new List<Contact>{
      candiSat2Fri,
      candiSun2Sat,
      candiMon2Sun,
      candiMixed,
      invoiceContact
    };

    //ADD PAY PROFILE
    List<IP_PayProfile__c> pplist = new List<IP_PayProfile__c>();
    for (Contact c : candidates) {
      IP_PayProfile__c pp = createPayProfilePaye(c.Id, 1)[0];
      //pp.IP_Candidate__c = c.Id;
      pp.IP_CompanyRegNo__c = '';
      pplist.add(pp);
    }
    //System.debug('ppList >>> ' + pplist);
    insert pplist;

    //CONTSULTANT
    String consProfileId = User_Profile_Id__c.getValues('JS Recruiter - Hybrid')
      .Profile_Id__c;
    //User consultantUser = createUsers(consProfileId,1)[0];
    User currentUser = [
      SELECT Id, Brand__c, IP_TempestDepartment__c
      FROM User
      WHERE Id = :UserInfo.getUserId()
    ];
    User consultantUser = [
      SELECT Id, Name, Username, IP_TempestDepartment__c
      FROM User
      WHERE
        IsActive = TRUE
        AND Profile.Id = :consProfileId
        AND IP_TempestDepartment__c = :currentUser.IP_TempestDepartment__c
      LIMIT 1
    ];

    //TOPAZ - IP_TopazGlobalClientInformation__c
    IP_TopazGlobalClientInformation__c topzClientInfo = createTopaz(1)[0];
    topzClientInfo.Name = clientAcc.Name;
    topzClientInfo.IP_SalesLedgerNumber__c = '345432';
    topzClientInfo.IP_DivisionCode__c = consultantUser.IP_TempestDepartment__c;
    insert topzClientInfo;

    //SECTOR - sirenum__Rota__c
    sirenum__Rota__c sector = createSector(1)[0];
    insert sector;

    //SITE - sirenum__Site__c
    List<sirenum__Site__c> siteList = createSites(
      clientAcc.Id,
      topzClientInfo.Id,
      3
    );
    sirenum__Site__c siteSF = siteList[0];
    siteSF.Name = 'Test site one - Saturday to Friday';
    siteSF.Process_TS_Line_Automatically__c = true;
    sirenum__Site__c siteSS = siteList[1];
    siteSS.Name = 'Test site two - Sunday to Saturday';
    siteSS.Process_TS_Line_Automatically__c = true;
    sirenum__Site__c siteMS = siteList[2];
    siteMS.Name = 'Test site three - Monday to Sunday';
    siteMS.Process_TS_Line_Automatically__c = true;
    insert new List<sirenum__Site__c>{ siteSF, siteSS, siteMS };

    //PAYROLL CYCLES - sirenum__Payroll_Cycle__c
    Map<String, sirenum__Payroll_Cycle__c> payrollCycles = getPayrollCycles();
    insert payrollCycles.values();
    for (sirenum__Payroll_Cycle__c pc : [
      SELECT
        Id,
        Name,
        sirenum__StartingDate__c,
        sirenum__periodLength__c,
        sirenum__CyclePeriodUnits__c
      FROM sirenum__Payroll_Cycle__c
    ]) {
      payrollCycles.put(pc.Name, pc);
      System.debug('Pay cybles >>> ' + pc);
    }
    //Saturday to Friday
    //Sunday to Saturday
    //Monday to Sunday

    //CONTRACT - sirenum__ProActiveContract__c
    List<sirenum__ProActiveContract__c> contracts = sirenumProActiveContract(
      clientAcc.Id,
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

    //JOB TYPE - sirenum__Job_Type__c
    sirenum__Job_Type__c jobType = createJobType(sector.Id, 1)[0];
    insert jobType;

    //JOB ROLL - sirenum__Team__c
    sirenum__Team__c jobroleSF = createJobRole(
      contractSatFri.Id,
      jobType.Id,
      1
    )[0];
    jobroleSF.Name =
      clientAcc.Name +
      ' - ' +
      site.Name +
      ' - Saturday to Friday';
    jobroleSF.IP_OPWIPSRole__c = 'No';
    jobroleSF.sirenum__Rota__c = sector.Id;

    sirenum__Team__c jobroleSS = createJobRole(
      contractSunSat.Id,
      jobType.Id,
      1
    )[0];
    jobroleSS.Name =
      clientAcc.Name +
      ' - ' +
      site.Name +
      ' - Sundayd to Saturday';
    jobroleSS.IP_OPWIPSRole__c = 'No';
    jobroleSS.sirenum__Rota__c = sector.Id;

    sirenum__Team__c jobroleMS = createJobRole(
      contractMonSun.Id,
      jobType.Id,
      1
    )[0];
    jobroleMS.Name = clientAcc.Name + ' - ' + site.Name + ' - Monday to Sunday';
    jobroleMS.IP_OPWIPSRole__c = 'No';
    jobroleMS.sirenum__Rota__c = sector.Id;

    insert new List<sirenum__Team__c>{ jobroleSF, jobroleSS, jobroleMS };

    //CONTACT SITE LINK - Contact_Site_link__c   (IP_PortalType__c = 'Primary Hours Approver')
    Contact_Site_link__c siteLinkSF = new Contact_Site_link__c(
      Account__c = clientAcc.Id,
      IP_Contact__c = invoiceContact.Id,
      IP_PortalType__c = 'Primary Hours Approver',
      IP_Site__c = siteSF.Id
    );
    Contact_Site_link__c siteLinkSS = new Contact_Site_link__c(
      Account__c = clientAcc.Id,
      IP_Contact__c = invoiceContact.Id,
      IP_PortalType__c = 'Primary Hours Approver',
      IP_Site__c = siteSS.Id
    );
    Contact_Site_link__c siteLinkMS = new Contact_Site_link__c(
      Account__c = clientAcc.Id,
      IP_Contact__c = invoiceContact.Id,
      IP_PortalType__c = 'Primary Hours Approver',
      IP_Site__c = siteMS.Id
    );
    insert new List<Contact_Site_link__c>{ siteLinkSF, siteLinkSS, siteLinkMS };

    //S-PLACEMENT - sirenum__Placement__c
    sirenum__Placement__c satToFriPlacement = new sirenum__Placement__c();
    satToFriPlacement.Name = 'Saturday to Friday Placement';
    satToFriPlacement.IP_Consultant1LookupSplitShare__c = consultantUser.Id;
    satToFriPlacement.sirenum__Contact__c = candiSat2Fri.Id;
    satToFriPlacement.sirenum__Site__c = siteSF.Id;
    satToFriPlacement.sirenum__Job_Role__c = jobroleSF.Id;
    satToFriPlacement.sirenum__Contract__c = contractSatFri.Id;
    satToFriPlacement.sirenum__Status__c = 'Active';
    satToFriPlacement.sirenum__Start_Date__c = Datetime.now()
      .addDays(-60)
      .date()
      .toStartOfWeek();
    satToFriPlacement.IP_Consultant1PercentageSplit__c = 100;

    sirenum__Placement__c sunToSatPlacement = new sirenum__Placement__c(
      Name = 'Sunday to Saturday Placement',
      IP_Consultant1LookupSplitShare__c = consultantUser.Id,
      sirenum__Contact__c = candiSun2Sat.Id,
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
    sirenum__Placement__c MontoSunPlacement = new sirenum__Placement__c(
      Name = 'Monday to Sunday Placement',
      IP_Consultant1LookupSplitShare__c = consultantUser.Id,
      sirenum__Contact__c = candiMon2Sun.Id,
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
      MontoSunPlacement
    };

    //SHIFT - sirenum__Shift__c
    Datetime wsSatFri = Datetime.now()
      .addMonths(-1)
      .date()
      .toStartOfWeek()
      .addDays(-2);
    Datetime wsSunSat = Datetime.now()
      .addMonths(-1)
      .date()
      .toStartOfWeek()
      .addDays(-1);
    Datetime wsMonSun = Datetime.now().addMonths(-1).date().toStartOfWeek();
    sirenum__Shift__c shiftSatFri = TestDataFactory.getAShift(
      satToFriPlacement.Id,
      sector.Id,
      jobroleSF.Id,
      siteSF.Id,
      candiSat2Fri.Id,
      wsSatFri
    );
    sirenum__Shift__c shiftSunSat = TestDataFactory.getAShift(
      sunToSatPlacement.Id,
      sector.Id,
      jobroleSS.Id,
      siteSS.Id,
      candiSun2Sat.Id,
      wsSunSat
    );
    sirenum__Shift__c shiftMonSun = TestDataFactory.getAShift(
      monToSunPlacement.Id,
      sector.Id,
      jobroleMS.Id,
      siteMS.Id,
      candiMon2Sun.Id,
      wsMonSun
    );

    sirenum__Shift__c shiftSatFriMx = TestDataFactory.getAShift(
      satToFriPlacement.Id,
      sector.Id,
      jobroleSF.Id,
      siteSF.Id,
      candiMixed.Id,
      wsSatFri
    );
    sirenum__Shift__c shiftSunSatMx = TestDataFactory.getAShift(
      sunToSatPlacement.Id,
      sector.Id,
      jobroleSS.Id,
      siteSS.Id,
      candiMixed.Id,
      wsSunSat
    );
    sirenum__Shift__c shiftMonSunMx = TestDataFactory.getAShift(
      monToSunPlacement.Id,
      sector.Id,
      jobroleMS.Id,
      siteMS.Id,
      candiMixed.Id,
      wsMonSun
    );

    insert new List<sirenum__Shift__c>{
      shiftSatFri,
      shiftSunSat,
      shiftMonSun,
      shiftSatFriMx,
      shiftSunSatMx,
      shiftMonSunMx
    };

    System.debug('shiftSatFri:: ' + shiftSatFri);
    System.debug('shiftSunSat:: ' + shiftSunSat);
    System.debug('shiftMonSun:: ' + shiftMonSun);
  }
}