global class SchedulePermB2Fbatch implements Schedulable{
  global void execute(SchedulableContext SC) {
          List<AsyncApexJob> job = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'permplacementB2FUpdate' and status not in ('Completed','Aborted','Failed')];
      if(job.isEmpty())
      {
      permplacementB2FUpdate siteB2F = new permplacementB2FUpdate(); 
      database.executebatch(siteB2F,1);
      }
   }
}