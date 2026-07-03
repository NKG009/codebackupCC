global class ScheduleTopazB2Fbatch implements Schedulable{
  global void execute(SchedulableContext SC) {
          List<AsyncApexJob> job = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'TopazGlobalB2FUpdate' and status not in ('Completed','Aborted','Failed')];
      if(job.isEmpty())
      {
      TopazGlobalB2FUpdate topazB2F = new TopazGlobalB2FUpdate(); 
      database.executebatch(topazB2F,1000);
      }
   }
}