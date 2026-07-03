@isTest
public class ShiftdetailsendingBatch_Test {
  public static testMethod void detailsbatch1() {
    TestDataFactory.setupUserProfileCustomSettings();
    Account acc1 = TestDataFactory.createCandidateAccount(1)[0];
    insert acc1;
    TestDataFactory.setupCustomSettings(acc1.Id);

    Profile p = [
      SELECT id
      FROM Profile
      WHERE Name = 'System Administrator'
      LIMIT 1
    ];
    User u = new User(
      LastName = 'LIVESTON',
      FirstName = 'JASON',
      Alias = 'jliv',
      Email = 'mm.sf@outlook123.com',
      Username = 'dummydcwecweEmail6786367@email.com',
      ProfileId = p.id,
      TimeZoneSidKey = 'GMT',
      LanguageLocaleKey = 'en_US',
      EmailEncodingKey = 'UTF-8',
      LocaleSidKey = 'en_US',
      IP_TempestDepartment__c = '1062',
      IP_TempestDivision__c = 'NTS',
      Department = '1062',
      IP_PassToTempest__c = true,
      Brand__c = 'Blue Arrow'
    );

    insert u;

    insert new IP_Shift_Template__c(
      name = '1062',
      IP_Branch_City__c = 'test1',
      IP_Branch_Country__c = 'count1',
      IP_Branch_County__c = 'count2',
      IP_Branch_Postal_Code__c = 'B12 3SS',
      Branch_Address__c = 'street1',
      Email__c = 'singh.taji26@gmail.com',
      Fax__c = '123456',
      Phone__c = '54735622',
      IP_Site_Name__c = 'Name1'
    );

    RecordType accountRec1 = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Account'
    ];
    Account acc = new Account(
      Name = 'Capita',
      RecordTypeId = accountRec1.id,
      OwnerId = u.Id
    );
    insert acc;

    RecordType maincondRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Contact'
    ];
    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = true);
    Contact maincon = new Contact(
      RecordTypeId = maincondRec.id,
      FirstName = 'Test',
      LastName = 'Main COntact',
      AccountID = acc.id,
      IP_ContactType__c = 'Booking Contact'
    );
    insert maincon;
    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

    Contact con = TestDataFactory.createCandidate(acc1.id, 1)[0];
    con.email = 'test@abc.com';
    con.OwnerId = u.Id;
    insert con;

    sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(
      acc.id,
      con.id,
      1
    )[0];
    insert ct;

    sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
    insert sec;

    sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id, 1)[0];
    insert jobcate;

    sirenum__Team__c job = TestDataFactory.createJobRole(
      ct.id,
      jobcate.id,
      1
    )[0];
    insert job;

    IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
    insert tpz;

    sirenum__Site__c site = new sirenum__Site__c();
    site.Name = 'testsite';
    site.sirenum__Operating_Company__c = acc.id;
    site.IP_ClientIDLegacy__c = '123';
    site.GlobalClientName__c = tpz.id;
    site.IP_ClientInvoiceName__c = 'Testclient';
    site.IP_InvoiceAddressStreet__c = '101';
    site.IP_InvoiceAddressCity__c = 'Delhi';
    site.IP_InvoiceAddressPostcode__c = 'A11 0FF';
    site.IP_InvoiceContact__c = maincon.id;
    site.IP_MainContact__c = maincon.id;
    site.IP_PublicSector__c = 'No';
    site.OwnerId = u.Id;
    insert site;

    sirenum__Placement__c ps = TestDataFactory.createSPlacement1(
      con.id,
      ct.id,
      job.id,
      u.id,
      1
    )[0];
    ps.sirenum__site__c = site.id;
    ps.sirenum__Status__c = 'Active';
    ps.IP_Consultant1LookupSplitShare__c = u.Id;
    insert ps;
    system.debug('$$Placement created' + ps);

    sirenum__Shift__c shft = TestDataFactory.createShift(ps.id, site.id, 1)[0];
    shft.sirenum__Rota__c = sec.id;
    insert shft;
      
     

    test.startTest();
    System.runAs(u) {
      ScheduleShiftsending sh1 = new ScheduleShiftsending();
      String sch = '0 30 * * * ?';
      system.schedule('Test Shift batch', sch, sh1);
    }
    test.stopTest();
  }

  public static testMethod void detailsbatch2() {
    Account acc1 = TestDataFactory.createCandidateAccount(1)[0];
    insert acc1;
    TestDataFactory.setupCustomSettings(acc1.Id);
    TestDataFactory.setupUserProfileCustomSettings();

    insert new IP_Shift_Template__c(
      name = '1062',
      IP_Branch_City__c = 'test1',
      IP_Branch_Country__c = 'count1',
      IP_Branch_County__c = 'count2',
      IP_Branch_Postal_Code__c = 'G12 3CC',
      Branch_Address__c = 'street1',
      Email__c = 'singh.taji26@gmail.com',
      Fax__c = '123456',
      Phone__c = '54735622',
      IP_Site_Name__c = 'Name1'
    );
    RecordType accountRec1 = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Account'
    ];

    Account acc = new Account(Name = 'Capita', RecordTypeId = accountRec1.id);
    insert acc;
    RecordType maincondRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Contact'
    ];
    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = true);
    Contact maincon = new Contact(
      RecordTypeId = maincondRec.id,
      FirstName = 'Test',
      LastName = 'Main COntact',
      AccountID = acc.id,
      IP_ContactType__c = 'Booking Contact'
    );
    insert maincon;

    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
    Contact con = TestDataFactory.createCandidate(acc1.id, 1)[0];
    con.email = 'test@abc.com';
    insert con;

    sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(
      acc.id,
      con.id,
      1
    )[0];
    insert ct;

    sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
    insert sec;

    sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id, 1)[0];
    insert jobcate;

    sirenum__Team__c job = TestDataFactory.createJobRole(
      ct.id,
      jobcate.id,
      1
    )[0];
    insert job;

    Profile p = [
      SELECT id
      FROM Profile
      WHERE Name = 'System Administrator'
      LIMIT 1
    ];
    User u = TestDataFactory.createUsers(p.id, 1)[0];
    u.IP_TempestDepartment__c = '1062';
    u.username = 'jhy@123.com';
    insert u;

    IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
    insert tpz;

    sirenum__Site__c site = new sirenum__Site__c();

    site.Name = 'testsite';
    site.sirenum__Operating_Company__c = acc.id;
    site.IP_ClientIDLegacy__c = '123';
    site.GlobalClientName__c = tpz.id;
    site.IP_ClientInvoiceName__c = 'Testclient';
    site.IP_InvoiceAddressStreet__c = '101';
    site.IP_InvoiceAddressCity__c = 'Delhi';
    site.IP_InvoiceAddressPostcode__c = 'D11 5HH';

    site.IP_InvoiceContact__c = maincon.id;
    site.IP_MainContact__c = maincon.id;
    site.IP_PublicSector__c = 'No';
    insert site;

    sirenum__Placement__c ps = TestDataFactory.createSPlacement1(
      con.id,
      ct.id,
      job.id,
      u.id,
      1
    )[0];
    ps.sirenum__site__c = site.id;
    ps.sirenum__Status__c = 'Active';
    insert ps;
    system.debug('$$Placement created' + ps);

    sirenum__Shift__c shft = TestDataFactory.createShift(ps.id, site.id, 1)[0];
    shft.sirenum__Rota__c = sec.id;
    insert shft;

    test.startTest();
    ShiftdetailsendingBatch sbatch = new ShiftdetailsendingBatch();
    sbatch.sendMail = true;
    database.executeBatch(sbatch, 1);
    test.stopTest();
  }

  public static testMethod void detailsbatchThrowError() {
    Account acc1 = TestDataFactory.createCandidateAccount(1)[0];
    insert acc1;
    TestDataFactory.setupCustomSettings(acc1.Id);
    TestDataFactory.setupUserProfileCustomSettings();

    insert new IP_Shift_Template__c(
      name = '1062',
      IP_Branch_City__c = 'test1',
      IP_Branch_Country__c = 'count1',
      IP_Branch_County__c = 'count2',
      IP_Branch_Postal_Code__c = 'G12 3CC',
      Branch_Address__c = 'street1',
      Email__c = 'singh.taji26@gmail.com',
      Fax__c = '123456',
      Phone__c = '54735622',
      IP_Site_Name__c = 'Name1'
    );
    RecordType accountRec1 = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Account' AND DeveloperName = 'Account'
    ];

    Account acc = new Account(Name = 'Capita', RecordTypeId = accountRec1.id);
    insert acc;
    RecordType maincondRec = [
      SELECT Id
      FROM RecordType
      WHERE sObjectType = 'Contact' AND DeveloperName = 'Contact'
    ];
    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = true);
    Contact maincon = new Contact(
      RecordTypeId = maincondRec.id,
      FirstName = 'Test',
      LastName = 'Main COntact',
      AccountID = acc.id,
      IP_ContactType__c = 'Booking Contact'
    );
    insert maincon;

    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
    Contact con = TestDataFactory.createCandidate(acc1.id, 1)[0];
    con.email = 'test@abc.com';
    insert con;

    sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(
      acc.id,
      con.id,
      1
    )[0];
    insert ct;

    sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
    insert sec;

    sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id, 1)[0];
    insert jobcate;

    sirenum__Team__c job = TestDataFactory.createJobRole(
      ct.id,
      jobcate.id,
      1
    )[0];
    insert job;

    Profile p = [
      SELECT id
      FROM Profile
      WHERE Name = 'System Administrator'
      LIMIT 1
    ];
    User u = TestDataFactory.createUsers(p.id, 1)[0];
    u.IP_TempestDepartment__c = '1062';
    u.username = 'jhy@123.com';
    insert u;

    IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
    insert tpz;

    sirenum__Site__c site = new sirenum__Site__c();

    site.Name = 'testsite';
    site.sirenum__Operating_Company__c = acc.id;
    site.IP_ClientIDLegacy__c = '123';
    site.GlobalClientName__c = tpz.id;
    site.IP_ClientInvoiceName__c = 'Testclient';
    site.IP_InvoiceAddressStreet__c = '101';
    site.IP_InvoiceAddressCity__c = 'Delhi';
    site.IP_InvoiceAddressPostcode__c = 'D11 5HH';

    site.IP_InvoiceContact__c = maincon.id;
    site.IP_MainContact__c = maincon.id;
    site.IP_PublicSector__c = 'No';
    insert site;

    sirenum__Placement__c ps = TestDataFactory.createSPlacement1(
      con.id,
      ct.id,
      job.id,
      u.id,
      1
    )[0];
    ps.sirenum__site__c = site.id;
    ps.sirenum__Status__c = 'Active';
    insert ps;
    system.debug('$$Placement created' + ps);

    sirenum__Shift__c shft = TestDataFactory.createShift(ps.id, site.id, 1)[0];
    shft.sirenum__Rota__c = sec.id;
    insert shft;

    test.startTest();
    ShiftdetailsendingBatch sbatch = new ShiftdetailsendingBatch();
    sbatch.throwError = true;
    sbatch.sendMail = true;
    database.executeBatch(sbatch, 1);
    test.stopTest();
    List<sirenum__Placement__c> output = [
      SELECT Id, Error_Message__c
      FROM sirenum__Placement__c
    ];

    for (sirenum__Placement__c placement : output) {
      System.assertEquals('Test Thrown Error', placement.Error_Message__c);
    }
  }
}