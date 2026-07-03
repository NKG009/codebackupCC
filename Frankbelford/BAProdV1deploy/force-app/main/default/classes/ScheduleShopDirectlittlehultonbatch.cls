global class ScheduleShopDirectlittlehultonbatch implements Schedulable{
  global void execute(SchedulableContext SC) {
      ShopDirectlittlehultonclass shopdirect = new ShopDirectlittlehultonclass (); 
      database.executebatch(shopdirect,1);

   }
}