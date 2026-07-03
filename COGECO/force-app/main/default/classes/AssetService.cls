public with sharing class AssetService {    
    public static void configurePricingLogData(Map<Id, Asset> assetsToProcess) {
        Map<String, List<Asset>> assetPricingKeyToPriceListEntry = new Map<String, List<Asset>>();
        
        for (Asset assetRecord : [SELECT Id, Account.Shipping_Province_Context_Rule__c, Product2Id, vlocity_cmt__PriceListId__c, Quantity, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c FROM Asset WHERE Id IN :assetsToProcess.keySet() AND vlocity_cmt__PriceListId__c != NULL]) {
            String key = assetRecord.Account.Shipping_Province_Context_Rule__c + ApexConstants.PIPE + assetRecord.Product2Id.to15() + ApexConstants.PIPE + assetRecord.vlocity_cmt__PriceListId__c.to15();
            
            if (!assetPricingKeyToPriceListEntry.containsKey(key)) {
                assetPricingKeyToPriceListEntry.put(key, new List<Asset>());
            }
            
            Asset assetRecordFromParam = assetsToProcess.get(assetRecord.Id);
            assetRecordFromParam.Account = assetRecord.Account;
            
            assetPricingKeyToPriceListEntry.get(key).add(assetRecordFromParam);
        }
        
        assetPricingKeyToPriceListEntry.remove(null);
        
        if (assetPricingKeyToPriceListEntry.isEmpty()) {
            return;
        }
        
        System_Value__mdt systemValue = [SELECT Value__c FROM System_Value__mdt WHERE DeveloperName = :ApexConstants.SYSTEM_VALUE_PRICING_LOG_DATA_DEFAULT];
        List<Asset> assetsToUpdate = new List<Asset>();
        
        for (vlocity_cmt__PriceListEntry__c priceListEntryRecord : [SELECT Id, Pricing_Log_Data_Key__c, vlocity_cmt__PricingElementId__r.vlocity_cmt__Amount__c FROM vlocity_cmt__PriceListEntry__c WHERE Pricing_Log_Data_Key__c IN :assetPricingKeyToPriceListEntry.keySet() AND vlocity_cmt__IsActive__c = TRUE]) {
            List<Asset> assetRecords = assetPricingKeyToPriceListEntry.get(priceListEntryRecord.Pricing_Log_Data_Key__c);
            
            if (assetRecords == null) {
                continue;
            }
            
            for (Asset assetRecord : assetRecords) {
                assetRecord.vlocity_cmt__PricingLogData__c = systemValue.Value__c;//set default value
                setPricingLogDataValues(assetRecord, priceListEntryRecord);
                
                assetsToUpdate.add(assetRecord);
            }
        }
        
        if (!assetsToUpdate.isEmpty()) {
            //update assetsToUpdate;
        }
    }
    
    public static void assignHierarchyIds(Set<Id> assetIds) {
        Set<String> topBpiIds = new Set<String>();
        Map<Id, Asset> assetsToUpdate = new Map<Id, Asset>();
        
        for (Asset asset : AssetSelector.getAssetsForBundling(assetIds)) {
            if (String.isBlank(asset.TOP_BPI_ID__c)) {
                asset.vlocity_cmt__LineNumber__c = String.isBlank(asset.vlocity_cmt__LineNumber__c) ? ApexConstants.PARENT_ASSET_LINE_NUMBER : asset.vlocity_cmt__LineNumber__c;
                asset.vlocity_cmt__RootItemId__c = asset.vlocity_cmt__AssetReferenceId__c;
                asset.vlocity_cmt__ProductHierarchyPath__c = asset.Product2Id;
            } else {                
                topBpiIds.add(asset.TOP_BPI_ID__c);
            }
            
            assetsToUpdate.put(asset.Id,  asset);
        }    
            
        if (topBpiIds.isEmpty()) {
            return;
        }
        
        Map<String, Asset> parentAssetsMap = new Map<String, Asset>();
        
        for (Asset parentAsset : AssetSelector.getParentAssets(topBpiIds)) {
            parentAssetsMap.put(parentAsset.External_Id__c, parentAsset);
        }
        
        for (Asset asset : assetsToUpdate.values()) {
            if (String.isNotBlank(asset.TOP_BPI_ID__c) && parentAssetsMap.containsKey(asset.TOP_BPI_ID__c)) {
                Asset parentAsset = parentAssetsMap.get(asset.TOP_BPI_ID__c);
                asset.vlocity_cmt__LineNumber__c = asset.vlocity_cmt__LineNumber__c?.contains(ApexConstants.DOT) ? asset.vlocity_cmt__LineNumber__c : parentAsset.vlocity_cmt__LineNumber__c + ApexConstants.DOT + asset.vlocity_cmt__LineNumber__c;
                asset.vlocity_cmt__RootItemId__c = parentAsset.vlocity_cmt__AssetReferenceId__c;
                asset.vlocity_cmt__ParentItemId__c = parentAsset.vlocity_cmt__AssetReferenceId__c;
                asset.vlocity_cmt__ProductHierarchyPath__c = asset.vlocity_cmt__ProductHierarchyPath__c?.contains(ApexConstants.LESS_THAN) ? asset.vlocity_cmt__ProductHierarchyPath__c : parentAsset?.Product2Id + ApexConstants.LESS_THAN + asset.Product2Id;
                
                assetsToUpdate.put(asset.Id, asset);
            }
        }
        
        if (!assetsToUpdate.isEmpty()) {
            update assetsToUpdate.values();
        }
    }
    
    @future
    public static void assignHierarchyIdsFuture(Set<Id> assetIds) {
        assignHierarchyIds(assetIds);
    }
    
    private static void setPricingLogDataValues(Asset assetRecord, vlocity_cmt__PriceListEntry__c priceListEntryRecord) {
        if (assetRecord == null) {
            return;
        }
        
        //overrides
        assetRecord.vlocity_cmt__PricingLogData__c = replaceString(assetRecord.vlocity_cmt__PricingLogData__c, '{{{AMOUNT}}}', assetRecord.vlocity_cmt__RecurringCharge__c);//asset
        assetRecord.vlocity_cmt__PricingLogData__c = replaceString(assetRecord.vlocity_cmt__PricingLogData__c, '{{{BASEVALUE}}}', priceListEntryRecord.vlocity_cmt__PricingElementId__r.vlocity_cmt__Amount__c);//pricing element
        assetRecord.vlocity_cmt__PricingLogData__c = replaceString(assetRecord.vlocity_cmt__PricingLogData__c, '{{{EFFECTIVE_QUANTITY}}}', assetRecord.Quantity);//asset
        assetRecord.vlocity_cmt__PricingLogData__c = replaceString(assetRecord.vlocity_cmt__PricingLogData__c, '{{{LINE_QUANTITY}}}', assetRecord.Quantity);//asset
        assetRecord.vlocity_cmt__PricingLogData__c = replaceString(assetRecord.vlocity_cmt__PricingLogData__c, '{{{EFF_REC_MNTH_STD_PRC_TOTAL}}}', assetRecord.vlocity_cmt__RecurringTotal__c);//asset
        assetRecord.vlocity_cmt__PricingLogData__c = replaceString(assetRecord.vlocity_cmt__PricingLogData__c, '{{{REC_MNTH_STD_PRC_TOTAL}}}', assetRecord.vlocity_cmt__RecurringTotal__c);//asset
        assetRecord.vlocity_cmt__PricingLogData__c = replaceString(assetRecord.vlocity_cmt__PricingLogData__c, '{{{REC_MNTH_STD_PRC_CALC}}}', assetRecord.vlocity_cmt__RecurringCalculatedPrice__c);//asset
        assetRecord.vlocity_cmt__PricingLogData__c = replaceString(assetRecord.vlocity_cmt__PricingLogData__c, '{{{REC_MNTH_STD_PRC}}}', assetRecord.vlocity_cmt__RecurringCharge__c);//asset
    }
    
    private static String replaceString(String fullString, String valueToFind, Object unknownValueToReplaceWith) {
        if (unknownValueToReplaceWith != null && String.isNotBlank(fullString)) {
            return fullString.replace(valueToFind, String.valueOf(unknownValueToReplaceWith));
        }
        
        return fullString;
    }
}