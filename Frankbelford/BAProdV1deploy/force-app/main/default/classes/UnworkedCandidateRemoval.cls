/** GDPR Data Retention Policy Part 1 **/
/** Unworked Candidate Removal **/
/** Date - 5-12-2018 **/
global class UnworkedCandidateRemoval extends batchjobsch.BatchJobBase implements Database.Batchable<sObject> {
  Date datetoday = system.today();
  IP_ImpellamGDPRSettings__c unworCanRetPd = IP_ImpellamGDPRSettings__c.getInstance(
    'Impellam GDPR settings'
  );
  Integer retPeriod = Integer.valueOf(
    UnworCanRetPd.IP_UnworkedCandidateDataRetentionPeriod__c
  );
  Date dateFilter = datetoday.addDays(-retPeriod);

  //
  /** Start Method **/
  //
  global Database.QueryLocator start(Database.BatchableContext BC) {
    Id candidateRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
      .get('Candidate')
      .getRecordTypeId();
    String Query =
      ' SELECT id , recordtype.name ,IP_GDPRWorkedCandidate__c,IP_LastContactedGDPR__c, ' +
      ' IP_MarkedForDeletion__c ,IP_GDPRContactedCandidate__c,CreatedDate , IP_Consent_from_Data_Store__c  FROM contact ' +
      ' WHERE CreatedDate < :dateFilter' +
      ' AND (IP_LastContactedGDPR__c = Null OR IP_LastContactedGDPR__c < :dateFilter) ' +
      ' AND recordTypeId=:candidateRecordTypeId AND IP_MarkedForDeletion__c = false ';

    system.debug('Query-->' + Query);
    return Database.getQueryLocator(Query);
  }
  //
  /** Execute Method **/
  //
  global void execute(Database.BatchableContext BC, List<Contact> Candidate) {
    system.debug('Candidate-->' + Candidate);
    Map<Id, Contact> updateCandidate = new Map<Id, Contact>();
    Map<Id, Contact> existingDataCandidate = new Map<Id, Contact>();
    set<Id> conIdSet = new Set<Id>();
    set<Id> conIdSetAfterShift = new Set<Id>();
    for (Contact con : Candidate) {
      conIdSet.add(con.Id);
      conIdSetAfterShift.add(con.Id);
      existingDataCandidate.put(con.Id, con);
    }

    try {
      /*
       * Condition for client records
       */
      for (sirenum__Placement__c splacement : [
        SELECT Id, sirenum__Contact__c, sirenum__Site__r.IP_Timesheet_Method__c
        FROM sirenum__Placement__c
        WHERE sirenum__Contact__c IN :ConIdSet AND sirenum__Status__c = 'Active'
      ]) {
        if (splacement.sirenum__Site__r.IP_Timesheet_Method__c == 'Client') {
          Contact con = new Contact(
            Id = splacement.sirenum__Contact__c,
            IP_GDPRWorkedCandidate__c = true
          );
          updateCandidate.put(splacement.sirenum__Contact__c, con);
          conIdSet.remove(con.Id);
          conIdSetAfterShift.remove(con.Id);
        }
      }
      //
      /** First Condition **/
      //
      for (sirenum__Shift__c linkedShift : [
        SELECT id, sirenum__Contact__c, sirenum__Timesheet_summaries__c
        FROM sirenum__Shift__c
        WHERE sirenum__Contact__c IN :ConIdSet
      ]) {
        if (linkedShift.sirenum__Timesheet_summaries__c != null) {
          Contact con = new Contact(
            Id = linkedShift.sirenum__Contact__c,
            IP_GDPRWorkedCandidate__c = true
          );
          updateCandidate.put(linkedShift.sirenum__Contact__c, con);
          conIdSet.remove(con.Id);
          conIdSetAfterShift.remove(con.Id);
        }
      }
      for (ts2__Placement__c Placement : [
        SELECT id, ts2__Employee__c
        FROM ts2__Placement__c
        WHERE ts2__Employee__c IN :ConIdSet
      ]) {
        Contact con = new Contact(
          Id = Placement.ts2__Employee__c,
          IP_GDPRWorkedCandidate__c = true
        );
        updateCandidate.put(Placement.ts2__Employee__c, con);
        conIdSet.remove(con.Id);
        conIdSetAfterShift.remove(con.Id);
      }
      //system.debug('Update Candidate' +updateCandidate);
      //
      /** Second Condition **/
      /*
Date dateFilter=system.today();
Integer retPeriod;
unworCanRetPd = IP_ImpellamGDPRSettings__c.getInstance('Impellam GDPR settings');
if(UnworCanRetPd!=null){
if(UnworCanRetPd.IP_UnworkedCandidateDataRetentionPeriod__c!=null){
retPeriod = Integer.valueOf(UnworCanRetPd.IP_UnworkedCandidateDataRetentionPeriod__c);
dateFilter=dateFilter.addDays(-retPeriod);
}
}       
*/
      //Date filter similar to start
      Set<String> activityType = new Set<String>();
      for (
        String activity : UnworCanRetPd.IP_ActivityTypesThatQualifyAsContact__c.split(
          ','
        )
      ) {
        activityType.add(activity);
      }
      system.debug('Activity Type' + activityType);
      Map<Id, List<Task>> CandidateActivity = new Map<Id, List<Task>>();
      if (Test.isRunningTest()) {
        Date tempDate = system.today();
        dateFilter = tempDate.addDays(-10);
      }
      for (Task linkedActivity : [
        SELECT id, IP_ActivityType__c, WhoId, createdDate
        FROM Task
        WHERE
          createdDate > :dateFilter
          AND IP_ActivityType__c IN :activityType
          AND WhoId IN :ConIdSet
        ORDER BY createdDate DESC
        ALL ROWS
      ]) {
        if (CandidateActivity.containsKey(linkedActivity.WhoId)) {
          List<Task> tempActivity = CandidateActivity.get(linkedActivity.WhoId);
          tempActivity.add(linkedActivity);
          CandidateActivity.put(linkedActivity.WhoId, tempActivity);
        } else {
          List<Task> Temp = new List<Task>();
          Temp.add(linkedActivity);
          CandidateActivity.put(linkedActivity.WhoId, Temp);
        }
      }
      system.debug('Activity Candidate ----->' + CandidateActivity);
      set<Id> candidateSecondConditionSet = new Set<Id>();
      for (Id candId : CandidateActivity.keyset()) {
        for (Task act : CandidateActivity.get(candId)) {
          system.debug('We are inside Map wala for loop');
          system.debug('Which activity value populated' + act);
          Contact con = new Contact(
            Id = candId,
            IP_LastContactedGDPR__c = Date.valueof(act.createdDate)
          );
          updateCandidate.put(candId, con);
          candidateSecondConditionSet.add(candId);
          conIdSet.remove(candId);
          break;
        }
      }
      system.debug('Updated Contact' + updateCandidate);
      //
      /** Third Condition **/
      //
      //LATEST SHIFT TAKEN AS PER CREATED DATE
      //
      Map<Id, List<sirenum__Shift__c>> candidateShift = new Map<Id, List<sirenum__Shift__c>>();
      for (sirenum__Shift__c linkedShift : [
        SELECT
          id,
          sirenum__Contact__c,
          sirenum__Timesheet_summaries__c,
          createdDate
        FROM sirenum__Shift__c
        WHERE
          sirenum__Contact__c IN :conIdSetAfterShift
          AND sirenum__Published_Ever__c = TRUE
          AND createdDate > :dateFilter
        ORDER BY createdDate DESC
      ]) {
        if (candidateShift.containsKey(linkedShift.sirenum__Contact__c)) {
          List<sirenum__Shift__c> tempShift = candidateShift.get(
            linkedShift.sirenum__Contact__c
          );
          tempShift.add(linkedShift);
          candidateShift.put(linkedShift.sirenum__Contact__c, tempShift);
        } else {
          List<sirenum__Shift__c> Temp = new List<sirenum__Shift__c>();
          Temp.add(linkedShift);
          candidateShift.put(linkedShift.sirenum__Contact__c, Temp);
        }
      }
      system.debug('Shift Published are ----->' + candidateShift);
      for (Id candId : candidateShift.keyset()) {
        for (sirenum__Shift__c Shift : candidateShift.get(candId)) {
          system.debug('we are inside Shift wala map');
          if (updateCandidate.containsKey(candId)) {
            if (
              Shift.createdDate >
              updateCandidate.get(candId).IP_LastContactedGDPR__c
            ) {
              system.debug('Shift created date is greater');
              updateCandidate.get(candId)
                .IP_LastContactedGDPR__c = Date.valueof(Shift.createdDate);
              candidateSecondConditionSet.add(candId);
              conIdSet.remove(candId);
            }
          } else {
            Contact con1 = new Contact(
              Id = candId,
              IP_LastContactedGDPR__c = Date.valueof(Shift.createdDate)
            );
            updateCandidate.put(candId, con1);
            candidateSecondConditionSet.add(candId);
            conIdSet.remove(candId);
          }
          break;
        }
      }
      /** All candidates which didnot satisfy activity or shift condition condition **/
      for (Id CanId : conIdSet) {
        if (
          ((existingDataCandidate.get(canId).IP_LastContactedGDPR__c == null) ||
          (existingDataCandidate.get(CanId).IP_LastContactedGDPR__c <
          dateFilter)) &&
          existingDataCandidate.get(canID).IP_GDPRContactedCandidate__c == false
        ) {
          system.debug('Marking for deletion');
          Contact con = new Contact(Id = CanId, IP_MarkedForDeletion__c = true);
          updateCandidate.put(CanId, con);
        }
      }
      /** Candidates used in activity condition **/
      for (Id secondCandId : candidateSecondConditionSet) {
        if (
          updateCandidate.get(secondCandId).IP_LastContactedGDPR__c <
          dateFilter &&
          updateCandidate.get(secondCandId).IP_GDPRContactedCandidate__c ==
          false
        ) {
          system.debug('Marking for deletion');
          updateCandidate.get(secondCandId).IP_MarkedForDeletion__c = true;
        }
      }

      system.debug('Updated candidate after shift published' + updateCandidate);
      Database.update(updateCandidate.values(), false);
    } catch (Exception e) {
      smagicinteract__Error_Log__c errorLog = new smagicinteract__Error_Log__c();
      errorLog.smagicinteract__Error_Message__c = e.getMessage();
      errorLog.smagicinteract__Line_number__c = e.getLineNumber();
      errorLog.smagicinteract__Error_Type__c = 'Generic';
      insert errorLog;
    }
  }
  //
  /** Finish Method **/
  //
  global void finish(Database.BatchableContext BC) {
    super.finishBatch(BC);
  }
}