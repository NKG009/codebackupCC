global class ScheduleNetivebatch implements Schedulable{
  global void execute(SchedulableContext SC) {
      NetiveBatchHeaderclass netive = new NetiveBatchHeaderclass(); 
      database.executebatch(netive,1);
   }
}