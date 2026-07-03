public without sharing class AssetPricingLogDataQueueable implements Queueable {
    private Map<Id, Asset> assetsToProcess;
    
    public AssetPricingLogDataQueueable(Map<Id, Asset> assetRecords) {
        this.assetsToProcess = assetRecords;
    }
    
	public void execute(QueueableContext context) {
        Boolean isCustomPricingLogDataEnabled = System_Values__c.getInstance(ApexConstants.SYSTEM_VALUES_CUSTOM_PRICING_LOG_DATA_ENABLED).Value__c == ApexConstants.STRING_TRUE;
        
        if (!assetsToProcess.isEmpty() && isCustomPricingLogDataEnabled) {
        	AssetService.configurePricingLogData(this.assetsToProcess);
        }
    }
}