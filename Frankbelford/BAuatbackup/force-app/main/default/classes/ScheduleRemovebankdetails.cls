global class ScheduleRemovebankdetails implements Schedulable{
  global void execute(SchedulableContext SC) {
        
      Removebankdetails rs = new Removebankdetails(); 
      database.executebatch(rs,1);
      
   }
}