global class ScheduleShopDirectinternalsbatch implements Schedulable{
  global void execute(SchedulableContext SC) {
      ShopDirectinternalsclass shopdirect = new ShopDirectinternalsclass(); 
      database.executebatch(shopdirect,1);

   }
}