global class ScheduleUpdaterecontacteddateCanddate implements Schedulable{
  global void execute(SchedulableContext SC) {
     
      UpdaterecontacteddateCanddate b = new UpdaterecontacteddateCanddate(); 
      database.executebatch(b,1);
      
   }
}