public without sharing class GDPRCandidateMarking_ScheduledBatch implements Database.Batchable<sObject>, Schedulable {
  private Integer retentionPeriodDays;
  private Date todayMinusRetentionPeriod;
  private IP_ImpellamGDPRSettings__c gdprSettings;

  public Boolean triggerException = false;

  public GDPRCandidateMarking_ScheduledBatch() {
    this.gdprSettings = IP_ImpellamGDPRSettings__c.getInstance(
      'Impellam GDPR settings'
    );
    this.retentionPeriodDays = Integer.valueOf(
      gdprSettings.IP_UnworkedCandidateDataRetentionPeriod__c
    );
    this.todayMinusRetentionPeriod = System.Today()
      .addDays(-retentionPeriodDays);
  }

  //Batch job execute
  public Database.QueryLocator start(Database.BatchableContext BC) {
    Id candidateRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
      .get('Candidate')
      .getRecordTypeId();

    //Any records returned from this query can be assumed to be ready for deletion
    String Query =
      ' SELECT id , recordtype.name ,IP_GDPRWorkedCandidate__c, IP_GDPRContactedCandidate__c ' +
      'FROM contact ' +
      'WHERE CreatedDate < :todayMinusRetentionPeriod ' +
      'AND (IP_LastContactedGDPR__c = Null OR IP_LastContactedGDPR__c < :todayMinusRetentionPeriod) ' +
      'AND recordTypeId=:candidateRecordTypeId AND IP_MarkedForDeletion__c = false AND IP_GDPRWorkedCandidate__c = false';

    system.debug('Query-->' + Query);
    return Database.getQueryLocator(Query);
  }
  public void execute(Database.BatchableContext BC, List<Contact> Candidates) {
    System.debug(BC);
    System.debug('Candidates-->' + Candidates);
    for (Contact candidate : Candidates) {
      candidate.IP_MarkedForDeletion__c = true;
    }

    try {
      if (Test.isRunningTest() && triggerException) {
        System.debug('DeletionException reached');
        throw new DeletionException('Test exception');
      }

      update Candidates;
    } catch (Exception e) {
      smagicinteract__Error_Log__c errorLog = new smagicinteract__Error_Log__c();
      errorLog.smagicinteract__Error_Message__c = e.getMessage();
      errorLog.smagicinteract__Line_number__c = e.getLineNumber();
      errorLog.smagicinteract__Error_Type__c = 'Generic';
      errorLog.smagicinteract__Class_name__c = 'GDPRCandidateMarking_ScheduledBatch';
      insert errorLog;
    }
  }
  public void finish(Database.BatchableContext BC) {
  }
  //Scheduled job execute
  public void execute(SchedulableContext sc) {
    Database.executeBatch(this, 10);
  }

  public class DeletionException extends Exception {
  }
}