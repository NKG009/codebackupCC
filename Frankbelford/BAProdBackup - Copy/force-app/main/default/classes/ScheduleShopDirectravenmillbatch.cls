global class ScheduleShopDirectravenmillbatch implements Schedulable{
  global void execute(SchedulableContext SC) {
      ShopDirectRavenMillclass shopdirect = new ShopDirectRavenMillclass(); 
      database.executebatch(shopdirect,1);

   }
}