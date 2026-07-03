global class ScheduleShopDirectspekebatch implements Schedulable{
  global void execute(SchedulableContext SC) {
      ShopDirectSpekeclass shopdirect = new ShopDirectSpekeclass(); 
      database.executebatch(shopdirect,1);

   }
}