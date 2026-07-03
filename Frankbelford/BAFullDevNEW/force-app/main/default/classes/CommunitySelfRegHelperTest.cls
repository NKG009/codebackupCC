/**
 * Created by mrahman on 2021-02-08.
 */

@IsTest(SeeAllData=true)
private class CommunitySelfRegHelperTest {
    @IsTest
    static void testSelfRegCandidateNew() {
        Contact worker = new Contact(FirstName = 'Test', LastName = 'Candidate12', Email='test_candidate01@mailinator.com');
        String nickName = 'tc1234';
        String password = 'Password123';
        System.assertEquals(null, CommunitySelfRegHelper.selfRegCandidate( worker.Firstname , worker.Lastname, worker.Email, password, nickName));
    }

    @IsTest
    static void testSelfRegCandidateExisting() {
        Account testAccount = [SELECT Id, Name, RecordType.Name FROM Account WHERE Name like 'Test%' LIMIT 1];
        Id candidateRtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();
        Contact worker = new Contact(FirstName = 'Test', LastName = 'Candidate12', Email='test_candidate01@mailinator.com', AccountId=testAccount.Id);
        insert worker;
        String nickName = 'tc1234';
        String password = 'Password123';
        Test.startTest();
            System.assertEquals(null, CommunitySelfRegHelper.selfRegCandidate( worker.Firstname , worker.Lastname, worker.Email, password, nickName));
        Test.stopTest();
    }

    @IsTest
static void testSelfRegCandidateWithTS() {
    List<sirenum__Timesheet__c> timesheets = [
        SELECT Id, Name, sirenum__Worker__c, sirenum__Worker__r.Name,
               sirenum__Worker__r.FirstName, sirenum__Worker__r.LastName,
               sirenum__Worker__r.Email
        FROM sirenum__Timesheet__c
        WHERE sirenum__Worker__c IN (
            SELECT ContactId FROM User WHERE Contact.RecordType.Name = 'Candidate'
        )
        LIMIT 1
    ];

    if (!timesheets.isEmpty()) {
        sirenum__Timesheet__c timesheet = timesheets[0];
        Account testAccount = [SELECT Id, Name, RecordType.Name FROM Account WHERE Name like 'Test%' LIMIT 1];

        Contact dupWorker = new Contact(
            FirstName = timesheet.sirenum__Worker__r.FirstName,
            LastName = timesheet.sirenum__Worker__r.LastName,
            Email = timesheet.sirenum__Worker__r.Email,
            AccountId = testAccount.Id
        );
        insert dupWorker;

        String nickName = 'tc1234';
        String password = 'Password123';
        Test.startTest();
        System.assertNotEquals(null, CommunitySelfRegHelper.selfRegCandidate(
            dupWorker.Firstname, dupWorker.Lastname, dupWorker.Email, password, nickName
        ));
        Test.stopTest();
    } else {
        
    }
}
    @IsTest
static void testSelfRegCandidateWithUser() {
    List<sirenum__Timesheet__c> timesheets = [
        SELECT Id, Name, sirenum__Worker__c, sirenum__Worker__r.Name,
               sirenum__Worker__r.FirstName, sirenum__Worker__r.LastName,
               sirenum__Worker__r.Email
        FROM sirenum__Timesheet__c
        WHERE sirenum__Worker__c IN (
            SELECT ContactId FROM User WHERE Contact.RecordType.Name = 'Candidate'
        )
        LIMIT 1
    ];

    if (!timesheets.isEmpty()) {
        sirenum__Timesheet__c timesheet = timesheets[0];

        String nickName = 'tc1234';
        String password = 'Password123';
        Test.startTest();
        System.assertNotEquals(null, CommunitySelfRegHelper.selfRegCandidate(
            timesheet.sirenum__Worker__r.FirstName,
            timesheet.sirenum__Worker__r.LastName,
            timesheet.sirenum__Worker__r.Email,
            password, nickName
        ));
        Test.stopTest();
    } else {
      
    }
}

   @IsTest
static void testMarkCandidateToDelete() {
   
    Id candidateRtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();

    
    Account candidateAccount = new Account(
        Name = 'Candidates',
        RecordTypeId = candidateRtId
    );
    insert candidateAccount;

    
    List<Contact> workers = TestDataFactory.createCandidate(candidateAccount.Id, 2);
    insert workers;

    Test.startTest();
        CommunitySelfRegHelper.markCandidateToDelete(workers);
    Test.stopTest();

    
    List<Contact> workersPost = [
        SELECT Id, Name, Email, IP_MarkedForDeletion__c, IP_GDPRDeleConsentPortalStatus__c
        FROM Contact
        WHERE Id = :workers[0].Id
    ];

    
    System.assertEquals(true, workersPost[0].IP_MarkedForDeletion__c);
    System.assertEquals(false, workersPost[0].IP_GDPRDeleConsentPortalStatus__c);
}

}