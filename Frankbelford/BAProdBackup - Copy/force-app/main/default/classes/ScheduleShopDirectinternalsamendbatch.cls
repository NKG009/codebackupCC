global class ScheduleShopDirectinternalsamendbatch implements Schedulable{
  global void execute(SchedulableContext SC) {
      ShopDirectinternalsamendclass shopdirect = new ShopDirectinternalsamendclass(); 
      database.executebatch(shopdirect,1);

   }
}