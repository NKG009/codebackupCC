@isTest
public class AssetPricingLogDataQueueableTest {
    @testSetup
    public static void setup() {
        insert new Run_Rules__c(Run_Triggers__c = true);
        insert new System_Values__c(Name = ApexConstants.SYSTEM_VALUES_CUSTOM_PRICING_LOG_DATA_ENABLED, Value__c = ApexConstants.STRING_TRUE);
        
        vlocity_cmt__PriceList__c priceList = new vlocity_cmt__PriceList__c(
        	Name = 'Test Price List',
            vlocity_cmt__IsActive__c = true,
            vlocity_cmt__Code__c = '08832'
        );
        
        insert priceList;
        
        Default_Price_List_Setting__c setting = new Default_Price_List_Setting__c(
        	Name = 'SMB',
            Active__c = true,
            Price_List_Id__c = priceList.Id
        );
        
        insert setting;
        
        Account accountRecord = new Account(
            Name = 'Test Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId(),
            ShippingState = 'ON'
        );
        
        insert accountRecord;
        
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
    public static void testAssetPricingLogDataQueueableExecute() {
        Account accountRecord = [SELECT Id FROM Account LIMIT 1];
        Product2 productRecord = [SELECT Id FROM Product2 LIMIT 1];
        vlocity_cmt__PriceList__c priceList = [SELECT Id FROM vlocity_cmt__PriceList__c LIMIT 1];
        
        Asset assetRecord = new Asset(
        	Name = 'Test Asset',
            AccountId = accountRecord.Id,
            Product2Id = productRecord.Id,
            vlocity_cmt__PriceListId__c = priceList.Id,
            vlocity_cmt__RecurringCharge__c = 5,
            Quantity = 1,
            vlocity_cmt__RecurringTotal__c = 5,
            vlocity_cmt__RecurringCalculatedPrice__c = 5
        );
        
        insert assetRecord;
        
        Test.startTest();
        
        System.enqueueJob(new AssetPricingLogDataQueueable(new Map<Id, Asset>{assetRecord.Id => assetRecord}));
        
        Test.stopTest();
    }
}