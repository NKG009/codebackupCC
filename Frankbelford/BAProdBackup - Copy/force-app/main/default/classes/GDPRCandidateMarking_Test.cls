@IsTest
public class GDPRCandidateMarking_Test {
  @TestSetup
  static void makeData() {
    IP_ImpellamGDPRSettings__c gdprSettings = new IP_ImpellamGDPRSettings__c(
      name = 'Impellam GDPR settings',
      IP_UnworkedCandidateDataRetentionPeriod__c = 360
    );
    insert gdprSettings;
    insert new Payroll_Swtich__c(Name = 'Stoppayroll', Batch_check__c = true);
    insert new User_Profile_Id__c(
      Name = 'User Portal',
      Profile_Id__c = '00e0Y000000QNyxQAG'
    );

    //Account
    Account candidateAccount = TestDataFactory.createCandidateAccount(1)[0];
    insert candidateAccount;
    //Contact
    Contact candidate = TestDataFactory.createCandidate(
      candidateAccount.Id,
      1
    )[0];

    insert candidate;
    Test.setCreatedDate(candidate.Id, System.now().addDays(-1000));
  }

  @IsTest
  static void UnworkedCandidateToBeDeleted() {
    //!Setup
    Contact candidate = [
      SELECT Id, IP_GDPRWorkedCandidate__c, IP_LastContactedGDPR__c
      FROM Contact
    ];
    candidate.IP_GDPRWorkedCandidate__c = false;
    candidate.IP_LastContactedGDPR__c = null; //System.Today().addDays(-600);
    update candidate;

    Test.startTest();
    //!Execution
    Database.executeBatch(new GDPRCandidateMarking_ScheduledBatch());
    Test.stopTest();
    //!Assertion
    List<Contact> toBeDeleted = [
      SELECT Id, IP_MarkedForDeletion__c
      FROM Contact
    ];

    for (Contact con : toBeDeleted) {
      System.debug(con);
      System.assertEquals(true, con.IP_MarkedForDeletion__c);
    }
  }

  @IsTest
  static void UnworkedCandidateToBeDeletedLastContactedSet() {
    //!Setup
    Contact candidate = [
      SELECT Id, IP_GDPRWorkedCandidate__c, IP_LastContactedGDPR__c
      FROM Contact
    ];
    candidate.IP_GDPRWorkedCandidate__c = false;
    candidate.IP_LastContactedGDPR__c = System.Today().addDays(-600);
    update candidate;

    Test.startTest();
    //!Execution
    Database.executeBatch(new GDPRCandidateMarking_ScheduledBatch());
    Test.stopTest();
    //!Assertion
    List<Contact> toBeDeleted = [
      SELECT Id, IP_MarkedForDeletion__c
      FROM Contact
    ];

    for (Contact con : toBeDeleted) {
      System.debug(con);
      System.assertEquals(true, con.IP_MarkedForDeletion__c);
    }
  }

  @IsTest
  static void UnworkedCandidateToNotBeDeletedLastContactedRecent() {
    //!Setup
    Contact candidate = [
      SELECT Id, IP_GDPRWorkedCandidate__c, IP_LastContactedGDPR__c
      FROM Contact
    ];
    candidate.IP_GDPRWorkedCandidate__c = false;
    candidate.IP_LastContactedGDPR__c = System.Today().addDays(-30);
    update candidate;

    Test.startTest();
    //!Execution
    Database.executeBatch(new GDPRCandidateMarking_ScheduledBatch());
    Test.stopTest();
    //!Assertion
    List<Contact> toBeDeleted = [
      SELECT Id, IP_MarkedForDeletion__c
      FROM Contact
    ];

    for (Contact con : toBeDeleted) {
      System.debug(con);
      System.assertEquals(false, con.IP_MarkedForDeletion__c);
    }
  }

  @IsTest
  static void WorkedCandidateToNotBeDeleted() {
    //!Setup
    Contact candidate = [
      SELECT Id, IP_GDPRWorkedCandidate__c, IP_LastContactedGDPR__c
      FROM Contact
    ];
    candidate.IP_GDPRWorkedCandidate__c = true;
    candidate.IP_LastContactedGDPR__c = null;
    update candidate;

    Test.startTest();
    //!Execution
    Database.executeBatch(new GDPRCandidateMarking_ScheduledBatch());
    Test.stopTest();
    //!Assertion
    List<Contact> toBeDeleted = [
      SELECT Id, IP_MarkedForDeletion__c
      FROM Contact
    ];

    for (Contact con : toBeDeleted) {
      System.debug(con);
      System.assertEquals(false, con.IP_MarkedForDeletion__c);
    }
  }

  @IsTest
  static void TriggerException() {
    //!Setup
    Contact candidate = [
      SELECT Id, IP_GDPRWorkedCandidate__c, IP_LastContactedGDPR__c
      FROM Contact
    ];
    candidate.IP_GDPRWorkedCandidate__c = false;
    candidate.IP_LastContactedGDPR__c = null; //System.Today().addDays(-600);
    update candidate;

    try {
      Test.startTest();
      //!Execution
      GDPRCandidateMarking_ScheduledBatch batch = new GDPRCandidateMarking_ScheduledBatch();
      batch.triggerException = true;
      Database.executeBatch(batch);
      Test.stopTest();
    } catch (Exception e) {
      //!Assertion
      System.assertEquals(e.getMessage(), 'Test exception');
    }
  }
}