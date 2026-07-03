global class ScheduleUpdaterecontacteddatePlacement implements Schedulable{
  global void execute(SchedulableContext SC) {
     
      UpdaterecontacteddatePlacement b = new UpdaterecontacteddatePlacement(); 
      database.executebatch(b,1);
      
   }
}