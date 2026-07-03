global class ScheduleShopDirectbatch implements Schedulable{
  global void execute(SchedulableContext SC) {
      ShopDirectBatchHeaderclass shopdirect = new ShopDirectBatchHeaderclass(); 
      database.executebatch(shopdirect,1);

   }
}