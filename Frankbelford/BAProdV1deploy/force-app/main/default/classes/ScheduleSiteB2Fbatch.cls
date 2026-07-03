global class ScheduleSiteB2Fbatch implements Schedulable{
  global void execute(SchedulableContext SC) {
          List<AsyncApexJob> job = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'SiteB2FUpdate' and status not in ('Completed','Aborted','Failed')];
      if(job.isEmpty())
      {
      SiteB2FUpdate siteB2F = new SiteB2FUpdate(); 
      database.executebatch(siteB2F,500);
      }
   }
}