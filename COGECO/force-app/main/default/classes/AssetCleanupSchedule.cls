public class AssetCleanupSchedule implements Schedulable {
  public void execute(SchedulableContext context) {
        Integer batchSize = System_Values__c.getInstance(ApexConstants.SYSTEM_VALUES_ASSET_ROLLUP_BATCH_SIZE)?.Value__c == null ? 200 : Integer.valueOf(System_Values__c.getInstance(ApexConstants.SYSTEM_VALUES_ASSET_ROLLUP_BATCH_SIZE).Value__c);
        
        Database.executeBatch(new AssetCleanupBatch(), batchSize);
    }
}