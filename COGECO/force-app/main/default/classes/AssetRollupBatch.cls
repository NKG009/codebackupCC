public class AssetRollupBatch implements Database.Batchable<SObject> {
    private String accountId;
    
    public AssetRollupBatch() { }
    
    public AssetRollupBatch(String accountId) {
        this.accountId = accountId;
    }
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        String activeStatus = ApexConstants.ASSET_PROVISIONING_STATUS_ACTIVE;
        String accountFilter = '';
        
        if (String.isNotBlank(this.accountId)) {
            String accountId = this.accountId;
            accountFilter = ' AND AccountId = :accountId ';
        }
        
        String query = 'SELECT Id FROM Asset WHERE vlocity_cmt__RecurringCharge__c != NULL AND vlocity_cmt__ProvisioningStatus__c = :activeStatus' + accountFilter + ' AND vlocity_cmt__RecurringTotal__c != NULL AND AccountId != NULL AND Account.Account_Status__c = :activeStatus ORDER BY Name';
        
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<SObject> scope) {
        String jobId = context.getJobId();
        
        List<Asset> identifiedAssets = identifyAssetsForAggregation((List<Asset>)scope, jobId);
        
        if (!identifiedAssets.isEmpty()) {
            TriggerHelper.isAssetRollupBatchJob = true;
            List<Database.SaveResult> saveResults = Database.update(identifiedAssets, false);
        }
    }
    
    public void finish(Database.BatchableContext context) {
        if (String.isBlank(this.accountId)) {
            Database.executeBatch(new OrderBatch(), 200);
        } else {
            Database.executeBatch(new OrderBatch(this.accountId), 200);
        }
    }
    
    private static List<Asset> identifyAssetsForAggregation(List<Asset> assetRecords, String jobId) {
        Set<Asset> identifiedAssets = new Set<Asset>();
        
        if (assetRecords != null) {
            for (Asset assetRecord : assetRecords) {
                identifiedAssets.add(new Asset(Id = assetRecord.Id, MRR_Rollup_Job_Id__c = jobId));
            }
        }
        
        return new List<Asset>( identifiedAssets );
    }
}