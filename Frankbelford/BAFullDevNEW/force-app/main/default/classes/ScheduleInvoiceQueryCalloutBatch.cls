global class ScheduleInvoiceQueryCalloutBatch implements Schedulable, Database.AllowsCallouts{
  global void execute(SchedulableContext SC) {
         
      InvoiceQueryCalloutBatch ib = new InvoiceQueryCalloutBatch(); 
      database.executebatch(ib,200);
      }
   }