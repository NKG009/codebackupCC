global class ScheduleShopDirectspekeamendbatch implements Schedulable{
  global void execute(SchedulableContext SC) {
      ShopDirectSpekeAmendmentsclass shopdirect = new ShopDirectSpekeAmendmentsclass(); 
      database.executebatch(shopdirect,1);

   }
}