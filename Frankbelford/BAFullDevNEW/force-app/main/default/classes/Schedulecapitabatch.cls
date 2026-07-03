global class Schedulecapitabatch implements Schedulable{
  global void execute(SchedulableContext SC) {
          List<AsyncApexJob> job = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'CapitaBatchHeaderclass' and status not in ('Completed','Aborted','Failed')];
      if(job.isEmpty())
      {
      CapitaBatchHeaderclass capita = new CapitaBatchHeaderclass(); 
      database.executebatch(capita,1);
      }
   }
}