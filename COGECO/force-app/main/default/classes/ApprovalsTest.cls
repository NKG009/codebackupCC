@isTest
private class ApprovalsTest {
    @TestSetup
    static void makeData(){
        System_Values__c customSetting = new System_Values__c(
            Name = 'Quote Communications Language Default',
            Value__c = 'English'
        );
        insert customSetting;
        insert new Run_Rules__c(Run_Triggers__c = true);
        
        Product2 testProduct1 = new Product2(
            Name = 'TestProduct1',
            IsActive = true
        );
        Product2 testProduct2  = new Product2(
            Name = 'TestProduct2',
            IsActive = true
        );
        Product2 testProduct3 = new Product2(
            Name = 'TestProduct3',
            IsActive = true
        );
        Product2 testProduct4 = new Product2(
            Name = 'TestProduct4',
            IsActive = true
        );
        insert testProduct1;
        insert testProduct2;
        insert testProduct3;
        insert testProduct4;
        
        Id priceBookId = Test.getStandardPricebookId();
        PricebookEntry pricebookEntryRecord1 = new PricebookEntry(
            Pricebook2Id = priceBookId, 
            Product2Id = testProduct1.Id, 
            UnitPrice = 10000, 
            IsActive = true
        );
        insert pricebookEntryRecord1;
        PricebookEntry pricebookEntryRecord2 = new PricebookEntry(
            Pricebook2Id = priceBookId, 
            Product2Id = testProduct2.Id, 
            UnitPrice = 5000, 
            IsActive = true
        );
        insert pricebookEntryRecord2;
        PricebookEntry pricebookEntryRecord3 = new PricebookEntry(
            Pricebook2Id = priceBookId, 
            Product2Id = testProduct3.Id, 
            UnitPrice = 20000, 
            IsActive = true
        );
        insert pricebookEntryRecord3;
        PricebookEntry pricebookEntryRecord4 = new PricebookEntry(
            Pricebook2Id = priceBookId, 
            Product2Id = testProduct4.Id, 
            UnitPrice = 50000, 
            IsActive = true
        );
        insert pricebookEntryRecord4;
        
        Territory__c testTerritoryRecord = new Territory__c(
            Name = 'T-E-S-T',
            TerritoryOwnerRole_RPT__c = 'Sales Strategy',
            Province__c = 'ON',
            Sales_Rep__c = userinfo.getUserId()
        );
        insert testTerritoryRecord;
        
        Account accountSMBRecord = new Account(
            Name = 'Test SMB Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId(),
            Territory__c = testTerritoryRecord.Id
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
        
        vlocity_cmt__PriceList__c testPriceList = new vlocity_cmt__PriceList__c(
            Name = 'TestPriceList',
            vlocity_cmt__IsActive__c = true,
            vlocity_cmt__Code__c = '1234567890',
            External_Id__c = '1234567890',
            vlocity_cmt__CurrencyCode__c = 'CAD',
            vlocity_cmt__Pricebook2Id__c = priceBookId
        );
        insert testPriceList;
        
        Quote quoteRecord = new Quote(
            Pricebook2Id = priceBookId,
            Name = 'Quote Test',
            OpportunityId = opportuntyRecord.Id,
            vlocity_cmt__PriceListId__c = testPriceList.Id
        );
        insert quoteRecord;
        
        
        
        Approval_Policy__c approvalPolicyRecord1 = new Approval_Policy__c(
            Name = 'TestProduct1Policy',
            Rules__c = 'Always Require Approval',
            Product__c = testProduct1.Id,
            Applicable_Province__c = 'ON',
            Type__c = 'Amount',
            Threshold__c = 50,
            Effective_Start__c = Date.today() - 1,
            Price_List__c = testPriceList.Id
        );
        Approval_Policy__c approvalPolicyRecord2 = new Approval_Policy__c(
            Name = 'TestProduct2Policy',
            Rules__c = 'Threshold',
            Product__c = testProduct2.Id,
            Applicable_Province__c = 'ON',
            Type__c = 'Amount',
            Threshold__c = 3000,
            Effective_Start__c = Date.today() - 1,
            Price_List__c = testPriceList.Id
        );
        Approval_Policy__c approvalPolicyRecord3 = new Approval_Policy__c(
            Name = 'TestProduct3Policy',
            Rules__c = 'Always Require Approval;Business Case',
            Product__c = testProduct3.Id,
            Applicable_Province__c = 'ON',
            Type__c = 'Amount',
            Threshold__c = 50,
            Effective_Start__c = Date.today() - 1,
            Price_List__c = testPriceList.Id
        );
        Approval_Policy__c approvalPolicyRecord4 = new Approval_Policy__c(
            Name = 'TestProduct4Policy',
            Rules__c = 'Threshold',
            Product__c = testProduct4.Id,
            Applicable_Province__c = 'ON',
            Type__c = 'Percent',
            Threshold__c = 50,
            Effective_Start__c = Date.today() - 1,
            Price_List__c = testPriceList.Id
        );
        insert approvalPolicyRecord1;
        insert approvalPolicyRecord2;
        insert approvalPolicyRecord3;
        insert approvalPolicyRecord4;
        
        
    }
    
    @isTest
    static void alwaysRequireApproval(){
        
        Quote quoteRecord = [SELECT Id FROM Quote LIMIT 1];
        Product2 product = [SELECT Id FROM Product2 WHERE Name='TestProduct1' LIMIT 1];
        PricebookEntry pricebookEntryRecord = [SELECT Id FROM PricebookEntry WHERE Product2Id=:product.Id  LIMIT 1];
        vlocity_cmt__PriceList__c pricelist = [Select Id, Name from vlocity_cmt__PriceList__c LIMIT 1 ];
        QuoteLineItem quoteLineItemRecord = new QuoteLineItem(
            QuoteId = quoteRecord.Id, 
            PricebookEntryId = pricebookEntryRecord.Id,
            Quantity = 1,
            Product2Id = product.Id,
            vlocity_cmt__RecurringCharge__c = 50
        );
        Test.startTest();
        
        insert quoteLineItemRecord;
        
        Test.stopTest();
        List<Pricing_Approval_Request__c> listOfPricingApprovalRequest = [Select Id from Pricing_Approval_Request__c];
        System.assertEquals(listOfPricingApprovalRequest.size(),1);
    }
    @isTest
    static void threshold(){
        
        Quote quoteRecord = [SELECT Id FROM Quote LIMIT 1];
        Product2 product = [SELECT Id FROM Product2 WHERE Name='TestProduct2' LIMIT 1];
        PricebookEntry pricebookEntryRecord = [SELECT Id FROM PricebookEntry WHERE Product2Id=:product.Id  LIMIT 1];
        vlocity_cmt__PriceList__c pricelist = [Select Id, Name from vlocity_cmt__PriceList__c LIMIT 1 ];
        
        QuoteLineItem quoteLineItemRecord = new QuoteLineItem(
            QuoteId = quoteRecord.Id, 
            PricebookEntryId = pricebookEntryRecord.Id,
            Quantity = 1,
            Product2Id = product.Id
        );
        insert quoteLineItemRecord;
        Test.startTest();
        
        quoteLineItemRecord.vlocity_cmt__RecurringCharge__c = 2500;
        update quoteLineItemRecord;
        
        Test.stopTest();
        List<Pricing_Approval_Request__c> listOfPricingApprovalRequest = [Select Id from Pricing_Approval_Request__c];
        System.assertEquals(listOfPricingApprovalRequest.size(),1);
    }
    
    @isTest
    static void thresholdPercent(){
        
        Quote quoteRecord = [SELECT Id FROM Quote LIMIT 1];
        Product2 product = [SELECT Id FROM Product2 WHERE Name='TestProduct4' LIMIT 1];
        PricebookEntry pricebookEntryRecord = [SELECT Id FROM PricebookEntry WHERE Product2Id=:product.Id  LIMIT 1];
        vlocity_cmt__PriceList__c pricelist = [Select Id, Name from vlocity_cmt__PriceList__c LIMIT 1 ];
        
        QuoteLineItem quoteLineItemRecord = new QuoteLineItem(
            QuoteId = quoteRecord.Id, 
            PricebookEntryId = pricebookEntryRecord.Id,
            Quantity = 1,
            Product2Id = product.Id,
            vlocity_cmt__RecurringCharge__c = 50000.00
        );
        insert quoteLineItemRecord;
        Test.startTest();
        
        quoteLineItemRecord.vlocity_cmt__RecurringCharge__c = 20000;
        update quoteLineItemRecord;
        
        Test.stopTest();
        List<Pricing_Approval_Request__c> listOfPricingApprovalRequest = [Select Id from Pricing_Approval_Request__c];
        System.assertEquals(listOfPricingApprovalRequest.size(),1);
    }
    
    @isTest
    static void businessCase(){
        Quote quoteRecord = [SELECT Id FROM Quote LIMIT 1];
        Product2 product = [SELECT Id FROM Product2 WHERE Name='TestProduct3' LIMIT 1];
        PricebookEntry pricebookEntryRecord = [SELECT Id FROM PricebookEntry WHERE Product2Id=:product.Id  LIMIT 1];
        vlocity_cmt__PriceList__c pricelist = [Select Id, Name from vlocity_cmt__PriceList__c LIMIT 1 ];
        QuoteLineItem quoteLineItemRecord = new QuoteLineItem(
            QuoteId = quoteRecord.Id, 
            PricebookEntryId = pricebookEntryRecord.Id,
            Quantity = 1,
            Product2Id = product.Id,
            vlocity_cmt__RecurringCharge__c = 50
        );
        Test.startTest();
        
        insert quoteLineItemRecord;
        
        Test.stopTest();
        List<Pricing_Approval_Request__c> listOfPricingApprovalRequest = [Select Id from Pricing_Approval_Request__c];
        System.assertEquals(listOfPricingApprovalRequest.size(),1);
    }
    @isTest
    static void deleteScenario(){
        
        Quote quoteRecord = [SELECT Id FROM Quote LIMIT 1];
        Product2 product = [SELECT Id FROM Product2 WHERE Name='TestProduct1' LIMIT 1];
        PricebookEntry pricebookEntryRecord = [SELECT Id FROM PricebookEntry WHERE Product2Id=:product.Id  LIMIT 1];
        vlocity_cmt__PriceList__c pricelist = [Select Id, Name from vlocity_cmt__PriceList__c LIMIT 1 ];
        QuoteLineItem quoteLineItemRecord = new QuoteLineItem(
            QuoteId = quoteRecord.Id, 
            PricebookEntryId = pricebookEntryRecord.Id,
            Quantity = 1,
            Product2Id = product.Id,
            vlocity_cmt__RecurringCharge__c = 50
        );
        insert quoteLineItemRecord;
        List<Pricing_Approval_Request__c> listOfPricingApprovalRequestbefore = [Select Id from Pricing_Approval_Request__c];
        System.assertEquals(listOfPricingApprovalRequestbefore.size(),1);
        Test.startTest();
        
        delete quoteLineItemRecord;
        
        Test.stopTest();
        List<Pricing_Approval_Request__c> listOfPricingApprovalRequestafter = [Select Id from Pricing_Approval_Request__c];
        System.assertEquals(listOfPricingApprovalRequestafter.size(),0);
    }
    
    
}