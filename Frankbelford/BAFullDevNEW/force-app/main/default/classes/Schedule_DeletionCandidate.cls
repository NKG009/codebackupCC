global class Schedule_DeletionCandidate implements Schedulable, Database.Batchable<sObject> {
  private boolean triggerException = false;

  global Schedule_DeletionCandidate() {
  }

  global Schedule_DeletionCandidate(boolean triggerException) {
    this.triggerException = triggerException;
  }

  /*
  Batchable
*/
  public Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(
      'SELECT id FROM Contact WHERE IP_MarkedForDeletion__c = TRUE'
    );
  }

  public void execute(Database.BatchableContext BC, List<sObject> con) {
    List<sirenum__Ranking__c> rank = [
      SELECT id
      FROM sirenum__Ranking__c
      WHERE sirenum__Contact__c IN :con OR sirenum__Ranked_by__c IN :con
    ];
    List<sirenum__Placement__c> placement = [
      SELECT id
      FROM sirenum__Placement__c
      WHERE sirenum__Contact__c IN :con
    ];
    List<sirenum__Assignment__c> assignment = [
      SELECT id
      FROM sirenum__Assignment__c
      WHERE sirenum__Placement__c IN :placement
    ];
    List<Certificate__c> cert = [
      SELECT id
      FROM Certificate__c
      WHERE Pay_Profile__r.IP_Candidate__c IN :con
    ];
    List<TR1__Reference__c> ref = [
      SELECT id
      FROM TR1__Reference__c
      WHERE TR1__Person_Placed__c IN :con
    ];
    List<sirenum__Sirenum_Client_Session__c> sessionclient = [
      SELECT id
      FROM sirenum__Sirenum_Client_Session__c
      WHERE sirenum__Contact__c IN :con
    ];
    List<StagingJobApplication__c> thirdPartyApplication = [
      SELECT Id
      FROM StagingJobApplication__c
      WHERE stgAtsCandidateIntegrationRef__c IN :con
    ];
    List<Case> Caselist = [SELECT id FROM Case WHERE Contactid IN :con];
    System.debug('rank ' + rank.size());
    System.debug('placement ' + placement.size());
    System.debug('placement ' + assignment.size());
    System.debug('cert ' + cert.size());
    System.debug('CON ' + con.size());

    try {
      Database.delete(Caselist, false);
      Database.delete(sessionclient, false);
      if (rank.size() > 0) {
        Database.delete(rank, false);
      }
      if (assignment.size() > 0) {
        Database.delete(assignment, false);
      }
      if (placement.size() > 0) {
        Database.delete(placement, false);
      }
      if (cert.size() > 0) {
        Database.delete(cert, false);
      }
      if (ref.size() > 0) {
        Database.delete(ref, false);
      }
      if (!thirdPartyApplication.isEmpty()) {
        Database.delete(thirdPartyApplication, false);
      }
      System.debug('Contacts==> ' + con);
      Database.delete(con, false);

      if (Test.isRunningTest() && triggerException) {
        System.debug('DeletionException reached');
        throw new DeletionException('Test exception');
      }
    } catch (DeletionException e) {
      smagicinteract__Error_Log__c errorLog = new smagicinteract__Error_Log__c();
      errorLog.smagicinteract__Error_Message__c = e.getMessage();
      errorLog.smagicinteract__Line_number__c = e.getLineNumber();
      errorLog.smagicinteract__Error_Type__c = 'Generic';
      insert errorLog;

      Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll');
      Payroll.Batch_check__c = false;
      update Payroll;
    }
  }

  public void finish(Database.BatchableContext BC) {
    Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll');
    Payroll.Batch_check__c = false;
    update Payroll;
  }

  /*
  Schedule
*/
  global void execute(SchedulableContext SC) {
    Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll');
    Payroll.Batch_check__c = true;
    update Payroll;

    IP_ImpellamGDPRSettings__c unworCanRetPd = IP_ImpellamGDPRSettings__c.getInstance(
      'Impellam GDPR settings'
    );
    Integer DeletionSize = Integer.valueOf(
      unworCanRetPd.IP_Scheduledeletionsize__c
    );

    Database.executeBatch(this, DeletionSize);
  }

  public class DeletionException extends Exception {
  }
}