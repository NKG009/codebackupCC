public without sharing class AssetTriggerHandler {
    private static General_Settings__c generalSettings = General_Settings__c.getInstance();
    
    public static void processAccountRollups(List<Asset> assetRecords, Map<Id, Asset> oldAssetRecords) {
        if (assetRecords == null || assetRecords.isEmpty() || !TriggerHelper.isAssetRollupBatchJob) {
            return;
        }
        
        Map<Id, Account> customerAccounts = new Map<Id, Account>();
        Map<Id, Asset> concentratedSetOfAssets = new Map<Id, Asset>();
        String jobId = null;
        
        for (Asset assetRecord : assetRecords) {
            Asset oldAssetRecord = oldAssetRecords?.get(assetRecord.Id) == null ? new Asset() : oldAssetRecords.get(assetRecord.Id);
            
            if (assetRecord.MRR_Rollup_Job_Id__c != oldAssetRecord.MRR_Rollup_Job_Id__c) {
                customerAccounts.put(assetRecord.AccountId, new Account(Id = assetRecord.AccountId));
                concentratedSetOfAssets.put(assetRecord.Id, assetRecord);
                jobId = assetRecord.MRR_Rollup_Job_Id__c;
            }
        }
        
        customerAccounts.remove(null);
        concentratedSetOfAssets.remove(null);
        
        if (!customerAccounts.isEmpty()) {
            for (Account accountRecord : AccountSelector.getAccountsForRollupProcessing(customerAccounts.keySet())) {
                if (accountRecord.MRR_Rollup_Job_Id__c != jobId) {
                    accountRecord.Recurring_Total__c = 0;
                    accountRecord.MRR_Rollup_Job_Id__c = jobId;
                    
                    customerAccounts.put(accountRecord.Id, accountRecord);
                }
            }
        }
        
        if (!concentratedSetOfAssets.isEmpty()) {
            for (Asset assetRecord : concentratedSetOfAssets.values()) {
                Account accountRecord = customerAccounts.get(assetRecord.AccountId);
                
                if (accountRecord == null) {
                    continue;
                }
                
                accountRecord.Recurring_Total__c = accountRecord.Recurring_Total__c == null ? 0 : accountRecord.Recurring_Total__c;
                accountRecord.Recurring_Total__c += assetRecord.vlocity_cmt__RecurringTotal__c == null ? 0 : assetRecord.vlocity_cmt__RecurringTotal__c;
                
                customerAccounts.put(assetRecord.AccountId, accountRecord);
            }
            
            if (!customerAccounts.isEmpty()) {
                update customerAccounts.values();
            }
        }
    }
    
    public static void setDefaults(List<Asset> assetRecords) {
        if (assetRecords == null || assetRecords.isEmpty()) {
            return;
        }
        
        for (Asset assetRecord : assetRecords) {
            if (String.isBlank(assetRecord.vlocity_cmt__BillingAccountId__c)) {
                assetRecord.vlocity_cmt__BillingAccountId__c = assetRecord.AccountId;
            }
            
            if (String.isBlank(assetRecord.vlocity_cmt__ServiceAccountId__c)) {
                assetRecord.vlocity_cmt__ServiceAccountId__c = assetRecord.AccountId;
            }
            
            if (String.isBlank(assetRecord.RecordTypeId)) {
                assetRecord.RecordTypeId = generalSettings.Default_Asset_Record_Type_Id__c;
            }
            
            if (assetRecord.Quantity == null || assetRecord.Quantity < 1) {
                assetRecord.Quantity = 1;
            }
        }
        
        assignPricebookEntry(assetRecords);
    }
    
    private static void assignPricebookEntry(List<Asset> assetRecords) {
        if (assetRecords == null || assetRecords.isEmpty()) {
            return;
        }
        
        Map<Id, Id> pricebookMap = new Map<Id, Id>();
        Set<Id> productIds = new Set<Id>();
        List<Asset> assetsToProcess = new List<Asset>();
        
        for (Asset assetRecord : assetRecords) {
            assetsToProcess.add(assetRecord);
            pricebookMap.put(assetRecord.vlocity_cmt__PriceListId__c, null);
            productIds.add(assetRecord.Product2Id);
        }
        
        pricebookMap.remove(null);
        productIds.remove(null);
        
        if (pricebookMap.isEmpty()) {
            return;
        }
        
        for (vlocity_cmt__PriceList__c priceListRecord : [SELECT Id, vlocity_cmt__Pricebook2Id__c FROM vlocity_cmt__PriceList__c WHERE Id IN :pricebookMap.keySet()]) {
            pricebookMap.put(priceListRecord.Id, priceListRecord.vlocity_cmt__Pricebook2Id__c);
        }
        
        Map<String, PricebookEntry> pricebookEntryMap = new Map<String, PricebookEntry>();
        
        if (!pricebookMap.isEmpty()) {
            for (PricebookEntry pricebookEntryRecord : [SELECT Id, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Pricebook2Id IN :pricebookMap.values() AND Product2Id IN :productIds AND IsActive = TRUE]) {
                String key = pricebookEntryRecord.Product2Id + ApexConstants.PIPE + pricebookEntryRecord.Pricebook2Id;
                pricebookEntryMap.put(key, pricebookEntryRecord);
            }            
        }
        
        pricebookEntryMap.remove(null);
        
        if (pricebookEntryMap.isEmpty()) {
            return;
        }
        
        for (Asset assetRecord : assetsToProcess) {
            Id pricebookId = pricebookMap.get(assetRecord.vlocity_cmt__PriceListId__c);
            
            if (pricebookId == null) {
                continue;
            }
            
            String key = assetRecord.Product2Id + ApexConstants.PIPE + pricebookId;
            PricebookEntry pricebookEntryRecord = pricebookEntryMap.get(key);
            
            if (pricebookEntryRecord == null) {
                continue;
            }
            
            assetRecord.vlocity_cmt__PricebookEntryId__c = pricebookEntryRecord?.Id;
        }
    }
    
    public static void handleAssetBundling(List<Asset> newAssets) {
        Set<String> topBpiIds = new Set<String>();
        
        for (Asset asset : newAssets) {
            if (String.isBlank(asset.TOP_BPI_ID__c)) {
                asset.vlocity_cmt__LineNumber__c = String.isBlank(asset.vlocity_cmt__LineNumber__c) ? ApexConstants.PARENT_ASSET_LINE_NUMBER : asset.vlocity_cmt__LineNumber__c;
                asset.vlocity_cmt__RootItemId__c = asset.vlocity_cmt__AssetReferenceId__c;
                asset.vlocity_cmt__ProductHierarchyPath__c = asset.Product2Id;
            } else {
                topBpiIds.add(asset.TOP_BPI_ID__c);
            }
        }    
            
        if (topBpiIds.isEmpty()) {
            return;
        }
        
        Map<String, Asset> parentAssetsMap = new Map<String, Asset>();
        
        for (Asset parentAsset : AssetSelector.getParentAssets(topBpiIds)) {
            parentAssetsMap.put(parentAsset.External_Id__c, parentAsset);
        }
        
        for (Asset asset : newAssets) {
            if (String.isNotBlank(asset.TOP_BPI_ID__c) && parentAssetsMap.containsKey(asset.TOP_BPI_ID__c)) {
                Asset parentAsset = parentAssetsMap.get(asset.TOP_BPI_ID__c);     
  
                asset.vlocity_cmt__LineNumber__c = asset.vlocity_cmt__LineNumber__c?.contains(ApexConstants.DOT) ? asset.vlocity_cmt__LineNumber__c : parentAsset.vlocity_cmt__LineNumber__c + ApexConstants.DOT + asset.vlocity_cmt__LineNumber__c;
                asset.vlocity_cmt__RootItemId__c = parentAsset.vlocity_cmt__AssetReferenceId__c;
                asset.vlocity_cmt__ParentItemId__c = parentAsset.vlocity_cmt__AssetReferenceId__c;
                
                if (asset.vlocity_cmt__ProductHierarchyPath__c != null && asset.vlocity_cmt__ProductHierarchyPath__c.contains(ApexConstants.LESS_THAN)) {
                    asset.vlocity_cmt__ProductHierarchyPath__c = asset.vlocity_cmt__ProductHierarchyPath__c;
                } else if (parentAsset.Product2Id != null && asset.Product2Id != null) {
                    asset.vlocity_cmt__ProductHierarchyPath__c = parentAsset.Product2Id + ApexConstants.LESS_THAN + asset.Product2Id;
                }
            }
        }
    }
    
    public static void processQueueableJobs(Map<Id, Asset> newAssets, Boolean isInsert) {
        if (isInsert) {
    		System.enqueueJob(new AssetBuildHierarchyQueueable(newAssets, isInsert));
            return;
        }
        
        System.enqueueJob(new AssetPricingLogDataQueueable(newAssets));
    }
    
    public static void processAssetPricingData(Map<Id, Asset> newAssets) {
        if (newAssets != null && !newAssets.isEmpty()) {
        	AssetService.configurePricingLogData(newAssets);
        }
    }
    
    public static void buildAssetHierarchyAfter(Map<Id, Asset> newAssets) {
        if (newAssets != null && !newAssets.isEmpty()) {
        	AssetService.assignHierarchyIdsFuture(newAssets.keySet());
        }
    }
}