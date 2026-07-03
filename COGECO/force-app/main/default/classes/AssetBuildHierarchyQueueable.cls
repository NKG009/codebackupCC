public without sharing class AssetBuildHierarchyQueueable implements Queueable {
    private Map<Id, Asset> assetsToProcess;
    private Boolean chainNextJob = false;
    
    public AssetBuildHierarchyQueueable(Map<Id, Asset> assetsToProcess) {
        this.assetsToProcess = assetsToProcess;
    }
    
    public AssetBuildHierarchyQueueable(Map<Id, Asset> assetsToProcess, Boolean chainNextJob) {
        this.assetsToProcess = assetsToProcess;
        this.chainNextJob = chainNextJob;
    }
    
	public void execute(QueueableContext context) {
        AssetService.assignHierarchyIds(assetsToProcess.keySet());
        
        if (this.chainNextJob && !Test.isRunningTest()) {
            System.enqueueJob(new AssetPricingLogDataQueueable(assetsToProcess));
        }
    }
}