public inherited sharing class AssetSelector {
    public static List<Asset> getAssetsFromAccountForRollupProcessing(Set<Id> accountIds) {
        return [SELECT Id, vlocity_cmt__RecurringTotal__c, vlocity_cmt__OrderId__r.Renewal_Date__c, AccountId, InstallDate FROM Asset WHERE AccountId IN :accountIds];
    }
    
    public static List<Asset> getAssetsForBundling(Set<Id> assetIds) {
        return [SELECT Id, TOP_BPI_ID__c, vlocity_cmt__LineNumber__c, vlocity_cmt__RootItemId__c, vlocity_cmt__ParentItemId__c, vlocity_cmt__AssetReferenceId__c, Product2Id, vlocity_cmt__ProductHierarchyPath__c FROM Asset WHERE Id IN :assetIds];
    }
    
    public static List<Asset> getParentAssets(Set<String> topBpiExternalIds) {
        return [SELECT Id, External_Id__c, vlocity_cmt__AssetReferenceId__c, vlocity_cmt__LineNumber__c, Product2Id FROM Asset WHERE External_Id__c IN :topBpiExternalIds];
    }
}