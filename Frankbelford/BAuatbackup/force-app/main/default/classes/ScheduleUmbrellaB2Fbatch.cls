global class ScheduleUmbrellaB2Fbatch implements Schedulable{
  global void execute(SchedulableContext SC) {
          List<AsyncApexJob> job = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'UmbrellaListB2FUpdate' and status not in ('Completed','Aborted','Failed')];
      if(job.isEmpty())
      {
      UmbrellaListB2FUpdate umbB2F = new UmbrellaListB2FUpdate(); 
      database.executebatch(umbB2F,1);
      }
   }
}