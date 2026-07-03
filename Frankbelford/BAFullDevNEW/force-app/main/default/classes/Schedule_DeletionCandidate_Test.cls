@isTest
public class Schedule_DeletionCandidate_Test {
  @TestSetup
  static void setupData() {
    IP_ImpellamGDPRSettings__c obj = new IP_ImpellamGDPRSettings__c(
      Name = 'Impellam GDPR settings',
      IP_UnworkedCandidateDataRetentionPeriod__c = 360,
      IP_Scheduledeletionsize__c = 500
    );
    insert obj;
    insert new Payroll_Swtich__c(Name = 'Stoppayroll', Batch_check__c = false);
  }
  public static testMethod void testschedule() {
    Test.StartTest();
    Schedule_DeletionCandidate sh1 = new Schedule_DeletionCandidate();
    String sch = '0 23 22 29 * ?';
    system.schedule('Test Deletion Candidate', sch, sh1);
    Test.stopTest();
  }

  @IsTest
  public static void ExecuteBatch() {
    Profile Prof = [
      SELECT Id
      FROM Profile
      WHERE Name = 'System Administrator'
      LIMIT 1
    ];
    Profile portalUserProfile = [
      SELECT Id
      FROM Profile
      WHERE Name = 'User Portal'
    ];
    User_Profile_Id__c UserPortalSetting = new User_Profile_Id__c(
      Name = 'User Portal',
      Profile_Id__c = portalUserProfile.Id
    );
    insert UserPortalSetting;

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
    acc1.BillingPostalCode = 'NW13JT';
    //acc1.BillingState = 'State1';
    //acc1.BillingCountry = 'Country1';
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
    acc.BillingPostalCode = 'NW13JT';
   // acc.BillingState = 'State2';
    //acc.BillingCountry = 'Country2';

    insert acc;

    system.debug('Account Inserted');

    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

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
        IP_MarkedForDeletion__c = true,
        RecordTypeId = contRec.Id
      );

      testContacts.add(contact);
    }
    insert testContacts;

    Test.startTest();

    Schedule_DeletionCandidate batch = new Schedule_DeletionCandidate();
    Database.executeBatch(batch, 600);

    Test.stopTest();

    List<Contact> output = [SELECT Id FROM Contact WHERE Id IN :testContacts];

    System.assertEquals(0, output.size());
  }

  @IsTest
  public static void ExecuteBatchWithException() {
    Profile Prof = [
      SELECT Id
      FROM Profile
      WHERE Name = 'System Administrator'
      LIMIT 1
    ];
    Profile portalUserProfile = [
      SELECT Id
      FROM Profile
      WHERE Name = 'User Portal'
    ];
    User_Profile_Id__c UserPortalSetting = new User_Profile_Id__c(
      Name = 'User Portal',
      Profile_Id__c = portalUserProfile.Id
    );
    insert UserPortalSetting;

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
    acc1.BillingPostalCode = 'NW13JT';
    //acc1.BillingState = 'State1';
   // acc1.BillingCountry = 'Country1';
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
    acc.BillingPostalCode = 'NW13JT';
    //acc.BillingState = 'State2';
    //acc.BillingCountry = 'Country2';

    insert acc;

    system.debug('Account Inserted');

    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

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
        IP_MarkedForDeletion__c = true,
        RecordTypeId = contRec.Id
      );

      testContacts.add(contact);
    }
    insert testContacts;

    try {
      Test.startTest();
      Schedule_DeletionCandidate batch = new Schedule_DeletionCandidate(true);
      Database.executeBatch(batch, 600);
      Test.stopTest();
    } catch (Schedule_DeletionCandidate.DeletionException e) {
      System.assertEquals('Test exception', e.getMessage());
    }
  }
}