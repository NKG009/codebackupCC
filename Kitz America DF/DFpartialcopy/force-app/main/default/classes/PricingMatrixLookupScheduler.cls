global class PricingMatrixLookupScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {

        Database.executeBatch(new PricingMatrixLookupBatch(), 200);
    }
}