global class ScheduleLTDB2Fbatch implements Schedulable{
  global void execute(SchedulableContext SC) {
          List<AsyncApexJob> job = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'LTDpayprofileB2FUpdate' and status not in ('Completed','Aborted','Failed')];
      if(job.isEmpty())
      {
      LTDpayprofileB2FUpdate ltdB2F = new LTDpayprofileB2FUpdate(); 
      database.executebatch(ltdB2F,1);
      }
   }
}