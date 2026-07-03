global class ScheduleShopDirectravenmillamendbatch implements Schedulable{
  global void execute(SchedulableContext SC) {
      ShopDirectRavenMillAmendmentsclass shopdirect = new ShopDirectRavenMillAmendmentsclass(); 
      database.executebatch(shopdirect,1);

   }
}