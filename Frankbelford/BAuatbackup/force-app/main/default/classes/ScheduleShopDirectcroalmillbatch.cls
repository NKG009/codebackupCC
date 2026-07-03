global class ScheduleShopDirectcroalmillbatch implements Schedulable{
  global void execute(SchedulableContext SC) {
      ShopDirectCroalMillclass shopdirect = new ShopDirectCroalMillclass (); 
      database.executebatch(shopdirect,1);

   }
}