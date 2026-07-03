@isTest
public class AssetRollupBatchTest {
    @testSetup
    static void setup() {
		insert new Run_Rules__c(Run_Triggers__c = true);
        insert new System_Values__c(Name = ApexConstants.SYSTEM_VALUES_CUSTOM_PRICING_LOG_DATA_ENABLED, Value__c = ApexConstants.STRING_TRUE);
        
        Account customerAccountRecord = new Account(
            Name = 'Test SMB Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId()
        );
        
        Account billingAccountRecord = new Account(
            Name = 'Test Billing Account',
            Account_Status__c = 'Active',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Billing').getRecordTypeId(),
            ParentId = customerAccountRecord.Id
        );
        
        insert new List<Account>{ billingAccountRecord, customerAccountRecord }; 
        
        Product2 productRecord = new Product2(	
            Name = 'UltraFibre 1 Gig',
            Family = 'Internet'
        );
        insert productRecord;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPriceBookEntryRecord = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = productRecord.Id,
            UnitPrice = 10000, 
            IsActive = true);
        insert standardPriceBookEntryRecord;
        
        Pricebook2 customPriceBookRecord = new Pricebook2(
        	Name = 'Custom Pricebook'
        );
        insert customPriceBookRecord;
        
        PricebookEntry customPriceBookEntryRecord = new PricebookEntry(
        	Pricebook2Id = customPriceBookRecord.Id,
            UnitPrice = 20000,
            Product2Id = productRecord.Id,
            IsActive = true
        );
        insert customPriceBookEntryRecord;
        
        vlocity_cmt__PriceList__c priceList = new vlocity_cmt__PriceList__c(
			vlocity_cmt__Pricebook2Id__c = customPriceBookRecord.Id,
			Name = 'Test PriceList',
			vlocity_cmt__Code__c = 'Test'
		);
        insert priceList;
        
        Asset assetRecord = new Asset();
        assetRecord.name = 'Test Asset Record';
        assetRecord.TOP_BPI_ID__c = 'Test';
        assetRecord.AccountId = billingAccountRecord.Id;
        assetRecord.vlocity_cmt__ProvisioningStatus__c = 'Active';
        assetRecord.vlocity_cmt__RecurringTotal__c = 10;
        assetRecord.vlocity_cmt__RecurringCharge__c = 10;
        assetRecord.vlocity_cmt__PriceListId__c = priceList.Id;
		assetRecord.Product2Id = productRecord.Id;
        insert assetRecord;       
    }
	
	@IsTest
    static void testAssetRollupBatch() {
		Test.startTest();
        
        String batchJobId = Database.executeBatch(new AssetRollupBatch());
        
        Test.stopTest();
		
		Asset assetObj = [SELECT Id, MRR_Rollup_Job_Id__c FROM Asset LIMIT 1];
            
        System.assertEquals(batchJobId, assetObj.MRR_Rollup_Job_Id__c?.left(15));
	}

	@IsTest
    static void testAssetRollupSchedule() {
		
		Test.startTest();
			AssetRollupSchedule sh1 = new AssetRollupSchedule();
        	String schChron = '0 0 23 * * ?'; 
        	system.schedule('Test Asset Rollup', schChron, sh1); 
        Test.stopTest();
	}    
}