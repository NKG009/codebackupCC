global class ScheduleShopDirectbatchflex implements Schedulable{
  global void execute(SchedulableContext SC) {
      ShopDirectBatchHeaderclassFlex shopdirect = new ShopDirectBatchHeaderclassFlex(); 
      database.executebatch(shopdirect,1);

   }
}