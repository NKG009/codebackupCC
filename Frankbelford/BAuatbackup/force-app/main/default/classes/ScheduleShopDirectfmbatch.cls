global class ScheduleShopDirectfmbatch implements Schedulable{
  global void execute(SchedulableContext SC) {
      ShopDirectFMbookclass shopdirect = new ShopDirectFMbookclass(); 
      database.executebatch(shopdirect,1);

   }
}