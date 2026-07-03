global class ScheduleShopDirectcroalmillamendbatch implements Schedulable{
  global void execute(SchedulableContext SC) {
      ShopDirectCroalMillAmendmentsclass shopdirect = new ShopDirectCroalMillAmendmentsclass(); 
      database.executebatch(shopdirect,1);

   }
}