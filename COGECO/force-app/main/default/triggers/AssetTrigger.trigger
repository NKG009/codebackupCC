trigger AssetTrigger on Asset(before insert, before update, after insert, after update) {
    if (CurrentUserPolicy.runTriggers()) {
        if (Trigger.isBefore && !System.isQueueable() && !System.isFuture()) {
            AssetTriggerHandler.setDefaults(Trigger.new);
            AssetTriggerHandler.processAccountRollups(Trigger.new, Trigger.oldMap);
            //CPQC-372
            AssetTriggerHandler.handleAssetBundling(Trigger.new);
            AssetTriggerHandler.processAssetPricingData(Trigger.newMap);
        }
        
        if (Trigger.isAfter && !System.isQueueable() && !System.isFuture() && !System.isBatch()) {
            AssetTriggerHandler.buildAssetHierarchyAfter(Trigger.newMap);
        }
    }
}