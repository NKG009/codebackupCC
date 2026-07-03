global class ScheduleShopDirectfmamendbatch implements Schedulable{
  global void execute(SchedulableContext SC) {
      ShopDirectFMbookamendclass shopdirect = new ShopDirectFMbookamendclass(); 
      database.executebatch(shopdirect,1);

   }
}