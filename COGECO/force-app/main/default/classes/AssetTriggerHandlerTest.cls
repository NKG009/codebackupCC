@isTest
public class AssetTriggerHandlerTest {
    @testSetup
    static void setup() {
        insert new Run_Rules__c(Run_Triggers__c = true);
        insert new System_Values__c(Name = ApexConstants.SYSTEM_VALUES_CUSTOM_PRICING_LOG_DATA_ENABLED, Value__c = ApexConstants.STRING_TRUE);
        
        Account accountRecord = new Account(
            Name = 'Test Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId(),
            ShippingState = 'ON'
        );
        
        insert accountRecord;
        
        vlocity_cmt__PriceList__c priceList = new vlocity_cmt__PriceList__c(
        	Name = 'Test Price List',
            vlocity_cmt__IsActive__c = true,
            vlocity_cmt__Code__c = '08832'
        );
        
        insert priceList;
        
        Product2 productRecord = new Product2(Name = 'Test Product');
        insert productRecord;
        
        vlocity_cmt__PricingVariable__c pricingVariable = new vlocity_cmt__PricingVariable__c(
        	Name = 'REC_MNTH_STD_PRC',
            vlocity_cmt__Type__c = 'Price',
            vlocity_cmt__ValueType__c = 'Pricing Element',
            vlocity_cmt__ChargeType__c = 'Recurring',
            vlocity_cmt__Code__c = 'uniqueidentifier'
        );
        insert pricingVariable;
        
        vlocity_cmt__PricingElement__c pricingElement = new vlocity_cmt__PricingElement__c(
            vlocity_cmt__Amount__c = 5,
            Name = 'Test Pricing Element',
            vlocity_cmt__PricingVariableId__c = pricingVariable.Id
        );
        insert pricingElement;
        
        vlocity_cmt__PriceListEntry__c priceListEntry = new vlocity_cmt__PriceListEntry__c(
        	Market__c = 'ON',
            vlocity_cmt__PriceListId__c = priceList.Id,
            vlocity_cmt__ProductId__c = productRecord.Id,
            vlocity_cmt__PricingElementId__c = pricingElement.Id,
            Name = 'Test Price'
        );
        insert priceListEntry;
    }
    
    @isTest
    static void testHandleAssetsInsert() {
        // Create test data for insert operation
        List<Asset> parentAssets = new List<Asset>();
        Map<String, Asset> parentAssetsMap = new Map<String, Asset>();
        
        Account accountRecord = [SELECT Id FROM Account LIMIT 1];
        Product2 productRecord = [SELECT Id FROM Product2 LIMIT 1];
        vlocity_cmt__PriceList__c priceList = [SELECT Id FROM vlocity_cmt__PriceList__c LIMIT 1];
        
        for (Integer i = 0; i < 200; i++) {
            Asset parentAsset = new Asset(
                Name = 'Parent_' + i, 
                External_Id__c = 'Parent_' + i, 
                vlocity_cmt__LineNumber__c = ApexConstants.PARENT_ASSET_LINE_NUMBER,
                AccountId = accountRecord.Id,
                Product2Id = productRecord.Id,
                vlocity_cmt__PriceListId__c = priceList.Id,
                vlocity_cmt__RecurringCharge__c = 5,
                Quantity = 1,
                vlocity_cmt__RecurringTotal__c = 5,
                vlocity_cmt__RecurringCalculatedPrice__c = 5
            );
            parentAssets.add(parentAsset);
            parentAssetsMap.put(parentAsset.External_Id__c, parentAsset);
        }
        
        insert parentAssets;
        
        List<Asset> assetsToInsert = new List<Asset>();
        for (Integer i = 0; i < 200; i++) {
            Asset newAsset = new Asset(
                Name = 'Child_' + i,
                TOP_BPI_ID__c = parentAssets[i].External_Id__c,
                vlocity_cmt__LineNumber__c = ApexConstants.PARENT_ASSET_LINE_NUMBER,
                vlocity_cmt__ProductHierarchyPath__c = 'a<b',
                AccountId = accountRecord.Id,
                Product2Id = productRecord.Id,
                vlocity_cmt__PriceListId__c = priceList.Id,
                vlocity_cmt__RecurringCharge__c = 5,
                Quantity = 1,
                vlocity_cmt__RecurringTotal__c = 5,
                vlocity_cmt__RecurringCalculatedPrice__c = 5
            );
            assetsToInsert.add(newAsset);
        }
        
        // Call the trigger handler method for insert
        Test.startTest();
        insert assetsToInsert;
        Test.stopTest();
        
        // Verify the changes made by the trigger handler
        List<Asset> insertedAssets = [SELECT Id, vlocity_cmt__LineNumber__c, vlocity_cmt__RootItemId__c, vlocity_cmt__ParentItemId__c,TOP_BPI_ID__c FROM Asset WHERE Id IN :assetsToInsert];
        List<Asset> insertedParentAssets = [SELECT Id, vlocity_cmt__LineNumber__c, vlocity_cmt__RootItemId__c, vlocity_cmt__ParentItemId__c,TOP_BPI_ID__c FROM Asset WHERE Id IN :parentAssets];
        for(Asset asset : insertedparentAssets)
        {
            System.assertEquals('0001', asset.vlocity_cmt__LineNumber__c, 'Parent LineNumber__c should be updated');
        }
        for (Asset asset : insertedAssets) {
            if (parentAssetsMap.containsKey(asset.TOP_BPI_ID__c)) {
                Asset parentAsset = parentAssetsMap.get(asset.TOP_BPI_ID__c);
                System.assertEquals(parentAsset.vlocity_cmt__AssetReferenceId__c, asset.vlocity_cmt__RootItemId__c, 'Child RootItemId__c should be updated');
                System.assertEquals(parentAsset.vlocity_cmt__AssetReferenceId__c, asset.vlocity_cmt__ParentItemId__c, 'Child ParentItemId__c should be updated');
            }
        }
    }
    
    @isTest
    static void testHandleAssetsUpdate() {
        // Create test data for update operation
        List<Asset> childAssets = new List<Asset>();
        Map<String, Asset> childAssetsMap = new Map<String, Asset>();
        
        Account accountRecord = [SELECT Id FROM Account LIMIT 1];
        Product2 productRecord = [SELECT Id FROM Product2 LIMIT 1];
        vlocity_cmt__PriceList__c priceList = [SELECT Id FROM vlocity_cmt__PriceList__c LIMIT 1];
        
        for (Integer i = 0; i < 200; i++) {
            Asset childAsset = new Asset(
                Name = 'Child_' + i, 
                External_Id__c = 'Child' + i, 
                vlocity_cmt__LineNumber__c = ApexConstants.PARENT_ASSET_LINE_NUMBER,
                vlocity_cmt__ProductHierarchyPath__c = 'a<b',
                AccountId = accountRecord.Id,
                Product2Id = productRecord.Id,
                vlocity_cmt__PriceListId__c = priceList.Id,
                vlocity_cmt__RecurringCharge__c = 5,
                Quantity = 1,
                vlocity_cmt__RecurringTotal__c = 5,
                vlocity_cmt__RecurringCalculatedPrice__c = 5
            );
            childAssets.add(childAsset);
            childAssetsMap.put(childAsset.External_Id__c, childAsset);
        }
        
        insert childAssets;
        
        List<Asset> existingAssetsToUpdate = new List<Asset>();
        for (Integer i = 0; i < 200; i++) {
            Asset existingAsset = new Asset(Id = childAssets[i].Id, Name = 'Parent_' + i, TOP_BPI_ID__c = childAssets[i].External_Id__c, vlocity_cmt__LineNumber__c = ApexConstants.PARENT_ASSET_LINE_NUMBER,
                                      vlocity_cmt__ProductHierarchyPath__c = 'a<b');
            existingAssetsToUpdate.add(existingAsset);
        }
        
        // Call the trigger handler method for update
        Test.startTest();
        update existingAssetsToUpdate;
        Test.stopTest();
        
        // Verify the changes made by the trigger handler
        for (Asset asset : [SELECT Id, vlocity_cmt__LineNumber__c, vlocity_cmt__RootItemId__c, vlocity_cmt__ParentItemId__c,TOP_BPI_ID__c, vlocity_cmt__AssetReferenceId__c FROM Asset WHERE Id IN :existingAssetsToUpdate]) {
            if (childAssetsMap.containsKey(asset.TOP_BPI_ID__c)) {
                Asset childAsset = childAssetsMap.get(asset.TOP_BPI_ID__c);
                System.assertEquals(childAsset.vlocity_cmt__AssetReferenceId__c, asset.vlocity_cmt__RootItemId__c, 'RootItemId__c should be updated');
                System.assertEquals(childAsset.vlocity_cmt__AssetReferenceId__c, asset.vlocity_cmt__ParentItemId__c, 'ParentItemId__c should be updated');
            }
        }
    }
}