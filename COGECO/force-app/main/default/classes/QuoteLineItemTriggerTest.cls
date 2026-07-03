@isTest
private class QuoteLineItemTriggerTest {
    @testsetup
    static void setup() {
                 System_Values__c customSetting = new System_Values__c(
            Name = 'Quote Communications Language Default',
            Value__c = 'English'
        );
        
        insert customSetting;
        insert new Run_Rules__c(Run_Triggers__c = true);
        
        Product2 product = new Product2(
            Name = 'TestProduct',
            IsActive = true
        );
        
        insert product;
		
        Id priceBookId = Test.getStandardPricebookId();
        
        PricebookEntry pricebookEntryRecord = new PricebookEntry(
            Pricebook2Id = priceBookId, 
            Product2Id = product.Id, 
            UnitPrice = 10000, 
            IsActive = true
        );
        
        insert pricebookEntryRecord;
        
        Account accountSMBRecord = new Account(
            Name = 'Test SMB Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId()
        );
        
        insert accountSMBRecord;
        
        Account accountBillingRecord = new Account(
            Name = 'Test Billing Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Billing').getRecordTypeId(),
            ParentId = accountSMBRecord.Id
        );
        
        insert accountBillingRecord;
        
        Account accountServiceRecord = new Account(
            Name = 'Test Service Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Service').getRecordTypeId(),
            ParentId = accountSMBRecord.Id
        );
        
        insert accountServiceRecord;
        
        accountSMBRecord.Primary_Service_Account__c = accountServiceRecord.Id;
        
        update accountSMBRecord;

        Opportunity opportuntyRecord = new Opportunity(
            Name = 'TestOpportunity',
            AccountId = accountSMBRecord.Id,
            CloseDate = System.today().addDays(30),
            StageName = 'Qualification',
            Amount = 6,
            Pricebook2Id = priceBookId,
            Opp_Customer_Category__c = 'SMB', 
            Sale_Type_Details__c = 'Move'
        );
        
        insert opportuntyRecord;
        
        Quote quoteRecord = new Quote(
            Pricebook2Id = priceBookId,
            Name = 'Quote Test',
            OpportunityId = opportuntyRecord.Id
        );
        
        insert quoteRecord;
        
        opportuntyRecord.SyncedQuoteId = quoteRecord.Id;
        
        update opportuntyRecord;
        
        QuoteLineItem quoteLineItemRecord = new QuoteLineItem(
            QuoteId = quoteRecord.Id, 
            vlocity_cmt__OneTimeCharge__c = 10,
            PricebookEntryId = pricebookEntryRecord.Id,
            Quantity = 1,
            UnitPrice = 10, 
            Product2Id = product.Id
        );
        
        insert quoteLineItemRecord;
    }
    
    @isTest 
    static void processLineItemSyncInsertTest() {
        Quote quoteRecord = [SELECT Id FROM Quote LIMIT 1];
        Product2 product = [SELECT Id FROM Product2 LIMIT 1];
        OpportunityLineItem OppLineItem = [SELECT Id FROM OpportunityLineItem LIMIT 1];
       	PricebookEntry pricebookEntryRecord = [SELECT Id FROM PricebookEntry LIMIT 1];
		
        QuoteLineItem quoteLineItemRecord = new QuoteLineItem(
            OpportunityLineItemId = OppLineItem.Id,
            QuoteId = quoteRecord.Id, 
            vlocity_cmt__OneTimeCharge__c = 10,
            PricebookEntryId = pricebookEntryRecord.Id,
            Quantity = 1,
            UnitPrice = 10, 
            Product2Id = product.Id
        );
        
        Test.startTest();
        
        insert quoteLineItemRecord;
        
        Test.stopTest();
        
        QuoteLineItem quoteLineItemResult = [SELECT Id, vlocity_cmt__OneTimeCharge__c, OpportunityLineItemId FROM QuoteLineItem WHERE Id = :quoteLineItemRecord.Id];
        OpportunityLineItem opportunityLineItemResult = [SELECT Id, vlocity_cmt__OneTimeCharge__c FROM OpportunityLineItem WHERE Id = :quoteLineItemResult.OpportunityLineItemId];
        
        System.assertEquals(quoteLineItemResult.vlocity_cmt__OneTimeCharge__c, opportunityLineItemResult.vlocity_cmt__OneTimeCharge__c);
    }
    
    @isTest
    static void processLineItemSyncUpdateTest() {
        QuoteLineItem quoteLineItemRecord = [SELECT Id, vlocity_cmt__OneTimeCharge__c, OpportunityLineItemId FROM QuoteLineItem LIMIT 1];
        quoteLineItemRecord.vlocity_cmt__OneTimeCharge__c = 20;
        
        Test.startTest();
        
        update quoteLineItemRecord;
        
        Test.stopTest();
        
        OpportunityLineItem opportunityLineItemResult = [SELECT Id, vlocity_cmt__OneTimeCharge__c FROM OpportunityLineItem WHERE Id = :quoteLineItemRecord.OpportunityLineItemId];
        
        System.assertEquals(20, opportunityLineItemResult.vlocity_cmt__OneTimeCharge__c);
    }
    
    @isTest
    static void testSetDefaultValues() {

        Quote quoteRecord = [SELECT Id FROM Quote LIMIT 1];
        Product2 productRecord = [SELECT Id FROM Product2 LIMIT 1];
        PricebookEntry pricebookEntryRecord = [SELECT Id FROM PricebookEntry LIMIT 1];
        
        QuoteLineItem quoteLineItemRecord = new QuoteLineItem(
            QuoteId = quoteRecord.Id, 
            vlocity_cmt__OneTimeCharge__c = 10,
            PricebookEntryId = pricebookEntryRecord.Id,
            Quantity = 1,
            UnitPrice = 10, 
            Product2Id = productRecord.Id
        );
        
        Test.startTest();
        
        insert quoteLineItemRecord;
        
        Test.stopTest();
        
        QuoteLineItem quoteLineItemResult = [SELECT Id, vlocity_cmt__ServiceAccountId__c FROM QuoteLineItem WHERE Id = :quoteLineItemRecord.Id];
        Account serviceAccountResult = [SELECT Id FROM Account WHERE RecordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Service').getRecordTypeId()];
        
        System.assertEquals(serviceAccountResult.Id, quoteLineItemResult.vlocity_cmt__ServiceAccountId__c);
    } 
}