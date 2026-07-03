global class ScheduleConsentReceivedate implements Schedulable,Database.AllowsCallouts{
  global void execute(SchedulableContext SC) {
      //  CandidateConsentRecieve.recievecall();
      Database.executebatch(new ConsentDateSynchBatch1(),1);
   }
}