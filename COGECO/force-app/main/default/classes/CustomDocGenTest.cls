@isTest
public class CustomDocGenTest {
    
    @testSetup
    static void setup(){
        Account accountRecord = new Account(
            Name = 'Test Account',
            BillingCity = 'Ontario',
            BillingCountry = 'US',
            BillingPostalCode = 'M2M3Y1',
            BillingState = 'CA',
            BillingStreet = '57 Street',	
            ShippingCity = 'Ontario',
            ShippingCountry = 'US',
            ShippingPostalCode = 'M2M3Y1',
            ShippingState = 'CA',
            ShippingStreet = '57 Street',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Billing').getRecordTypeId()
        );
        insert accountRecord;
        
        Opportunity opportunityRecord = new Opportunity(
            Name = 'TestOpportunity',
            Billing_Account_Number__c = accountRecord.Id,
            CloseDate = System.today().addDays(30),
            StageName = 'Qualification',
            Amount = 6,
            Opp_Customer_Category__c = 'SMB', 
            Sale_Type_Details__c = 'Move'
            //Pricebook2Id = priceBookRecord.Id
        );
        insert opportunityRecord;
        
        Pricebook2 customPriceBookRecord = new Pricebook2(
            Name = 'Custom Pricebook'
        );
        insert customPriceBookRecord;
        
        Quote quoteRecord = new Quote(
            Name = 'Quote Test',
            Communication_Language__c = 'English',
            OpportunityId = opportunityRecord.Id,
            Pricebook2Id = customPriceBookRecord.Id
        );
        insert quoteRecord;
        
        Product2 productRecord = new Product2(	
            Name = 'UltraFibre 1 Gig',
            Family = 'Internet'
        );
        Product2 productRecord1 = new Product2(	
            Name = 'UltraFibre 100 Gig',
            Family = 'Internet'
        );
        Product2 productRecord2 = new Product2(	
            Name = 'Dedicatetd Internet Access',
            Family = 'TV'
        );
        
        insert new List<Product2>{
            productRecord, productRecord1, productRecord2
                };
                    
                    Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPriceBookEntryRecord = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = productRecord.Id,
            UnitPrice = 10000, 
            IsActive = true);
        insert standardPriceBookEntryRecord;
        
        PricebookEntry customPriceBookEntryRecord = new PricebookEntry(
            Pricebook2Id = customPriceBookRecord.Id,
            UnitPrice = 20000,
            Product2Id = productRecord.Id,
            IsActive = true
        );
        insert customPriceBookEntryRecord;
        
        vlocity_cmt__QuoteMember__c quoteMemberRecord = new vlocity_cmt__QuoteMember__c(
            vlocity_cmt__QuoteId__c = quoteRecord.Id ,
            vlocity_cmt__ServiceAccountId__c = accountRecord.Id
        );
        
        vlocity_cmt__QuoteMember__c quoteMemberRecord1 = new vlocity_cmt__QuoteMember__c(
            vlocity_cmt__QuoteId__c = quoteRecord.Id ,
            vlocity_cmt__ServiceAccountId__c = accountRecord.Id
        );
        
        insert new List<vlocity_cmt__QuoteMember__c>{
            quoteMemberRecord, quoteMemberRecord1
                };
                    
                    QuoteLineItem quoteLineItemRecord = new QuoteLineItem(
                        QuoteId = quoteRecord.Id,
                        Product2Id = productRecord.Id,
                        vlocity_cmt__QuoteMemberId__c = quoteMemberRecord.Id,
                        vlocity_cmt__OneTimeCharge__c = 100,
                        vlocity_cmt__OneTimeTotal__c = 0,
                        vlocity_cmt__RecurringTotal__c = 0,
                        vlocity_cmt__RecurringCharge__c = 0,
                        Quantity = 1,
                        Term__c = 3,
                        Download_Speed__c = '120 Mbps',
                        Customer_Facing_Comments__c = 'Test',
                        Initial_Recurring_Charge__c = 100,
                        UnitPrice = 20000,
                        PricebookEntryId = customPriceBookEntryRecord.Id
                    );
        QuoteLineItem quoteLineItemRecord1 = new QuoteLineItem(
            QuoteId = quoteRecord.Id,
            Product2Id = productRecord.Id,
            vlocity_cmt__QuoteMemberId__c = quoteMemberRecord1.Id,
            vlocity_cmt__OneTimeCharge__c = 100,
            vlocity_cmt__OneTimeTotal__c = 0,
            vlocity_cmt__RecurringTotal__c = 0,
            vlocity_cmt__RecurringCharge__c = 0,
            Quantity = 1,
            Term__c = 3,
            Download_Speed__c = '120 Mbps',
            Customer_Facing_Comments__c = 'Test',
            Initial_Recurring_Charge__c = 100,
            UnitPrice = 20000,
            PricebookEntryId = customPriceBookEntryRecord.Id
        );
        QuoteLineItem quoteLineItemRecord2 = new QuoteLineItem(
            QuoteId = quoteRecord.Id,
            Product2Id = productRecord1.Id,
            vlocity_cmt__QuoteMemberId__c = quoteMemberRecord.Id,
            vlocity_cmt__OneTimeCharge__c = 100,
            vlocity_cmt__OneTimeTotal__c = 0,
            vlocity_cmt__RecurringTotal__c = 0,
            vlocity_cmt__RecurringCharge__c = 0,
            Quantity = 1,
            Term__c = 3,
            Download_Speed__c = '120 Mbps',
            Customer_Facing_Comments__c = 'Test',
            Initial_Recurring_Charge__c = 100,
            UnitPrice = 20000,
            PricebookEntryId = customPriceBookEntryRecord.Id,
            vlocity_cmt__Action__c = 'Add'
        );
        
        QuoteLineItem quoteLineItemRecord3 = new QuoteLineItem(
            QuoteId = quoteRecord.Id,
            Product2Id = productRecord2.Id,
            vlocity_cmt__QuoteMemberId__c = quoteMemberRecord.Id,
            vlocity_cmt__OneTimeCharge__c = 100,
            vlocity_cmt__OneTimeTotal__c = 0,
            vlocity_cmt__RecurringTotal__c = 0,
            vlocity_cmt__RecurringCharge__c = 0,
            Quantity = 1,
            Term__c = 3,
            Download_Speed__c = '120 Mbps',
            Customer_Facing_Comments__c = 'Test',
            Initial_Recurring_Charge__c = 100,
            UnitPrice = 20000,
            PricebookEntryId = customPriceBookEntryRecord.Id,
            vlocity_cmt__Action__c = 'Add'
        );
        
        insert new List<QuoteLineItem>{
            quoteLineItemRecord, quoteLineItemRecord1, quoteLineItemRecord2, quoteLineItemRecord3
                };
                    
                    OpportunityLineItem opportunityLineItemRecord = new OpportunityLineItem(
                        OpportunityId = opportunityRecord.Id,
                        Quantity = 1,
                        TotalPrice = 1200,
                        PricebookEntryId = customPriceBookEntryRecord.Id,
                        Product2Id = productRecord.Id
                    );	
        insert opportunityLineItemRecord;
        
        vlocity_cmt__PricingVariable__c pv = new vlocity_cmt__PricingVariable__c();
        pv.vlocity_cmt__Aggregation__c = 'Unit';
        pv.vlocity_cmt__ChargeType__c = 'One-time';
        pv.vlocity_cmt__Code__c = 'OT_STD_PRC';
        pv.vlocity_cmt__CurrencyType__c = 'Currency';
        pv.vlocity_cmt__IsActive__c = true;
        pv.vlocity_cmt__RecurringFrequency__c = 'One-time';
        pv.vlocity_cmt__Scope__c = 'Line';
        pv.vlocity_cmt__SubType__c = 'Standard';
        pv.vlocity_cmt__Type__c = 'Price';
        pv.vlocity_cmt__ValueType__c = 'Pricing Element';
        
        vlocity_cmt__PricingVariable__c pv1 = new vlocity_cmt__PricingVariable__c();
        pv1.vlocity_cmt__Aggregation__c = 'Unit';
        pv1.vlocity_cmt__ChargeType__c = 'Recurring';
        pv1.vlocity_cmt__Code__c = 'REC_STD_PRC';
        pv1.vlocity_cmt__CurrencyType__c = 'Currency';
        pv1.vlocity_cmt__IsActive__c = true;
        pv1.vlocity_cmt__RecurringFrequency__c = 'Monthly';
        pv1.vlocity_cmt__Scope__c = 'Line';
        pv1.vlocity_cmt__SubType__c = 'Standard';
        pv1.vlocity_cmt__Type__c = 'Price';
        pv1.vlocity_cmt__ValueType__c = 'Pricing Element';
        
        insert new List<vlocity_cmt__PricingVariable__c>{
            pv, pv1
                };
                    
                    vlocity_cmt__Promotion__c quotePromotionRecord = new vlocity_cmt__Promotion__c(
                        Name= '50% off',
                        vlocity_cmt__Code__c  = '9148839650865442308'
                        
                    );
        insert quotePromotionRecord;
        
        vlocity_cmt__QuoteDiscount__c quoteDiscount = new vlocity_cmt__QuoteDiscount__c(
            
            Name ='100% Off on Installation - Special Discount',
            vlocity_cmt__DiscountTemplateId__c = quotePromotionRecord.Id,
            vlocity_cmt__QuoteId__c = quoteRecord.Id 
        );
        insert quoteDiscount;
        vlocity_cmt__QuoteAppliedPromotion__c quoteAppliedPromotion = new vlocity_cmt__QuoteAppliedPromotion__c(
            
            vlocity_cmt__QuoteDiscountId__c = quoteDiscount.Id,
            vlocity_cmt__QuoteId__c = quoteRecord.Id
            
        );
        insert quoteAppliedPromotion;
        
        
        vlocity_cmt__QuotePricingAdjustment__c quotePricingAdjustmentRecord =
            new vlocity_cmt__QuotePricingAdjustment__c(
                vlocity_cmt__QuoteItemId__c = quoteLineItemRecord.Id,
                vlocity_cmt__QuoteId__c = quoteRecord.Id,
                vlocity_cmt__Source__c = 'Agent',
                vlocity_cmt__Amount__c = 10,
                vlocity_cmt__Sequence__c = 1,
                vlocity_cmt__PricingVariableId__c = pv1.Id
                
            );
        vlocity_cmt__QuotePricingAdjustment__c quotePricingAdjustmentRecord1 =
            new vlocity_cmt__QuotePricingAdjustment__c(
                vlocity_cmt__QuoteItemId__c = quoteLineItemRecord.Id,
                vlocity_cmt__QuoteId__c = quoteRecord.Id,
                vlocity_cmt__Source__c = 'Agent',
                vlocity_cmt__Amount__c = 101,
                vlocity_cmt__Sequence__c = 2
            );
        vlocity_cmt__QuotePricingAdjustment__c quotePricingAdjustmentRecord2 =
            new vlocity_cmt__QuotePricingAdjustment__c(
                vlocity_cmt__QuoteItemId__c = quoteLineItemRecord3.Id,
                vlocity_cmt__QuoteId__c = quoteRecord.Id,
                vlocity_cmt__Source__c = 'Discount',
                vlocity_cmt__AdjustmentValue__c = -5,
                vlocity_cmt__quoteAppliedPromotionId__c = quoteAppliedPromotion.Id,
                vlocity_cmt__PricingVariableId__c = pv1.Id
            );
        
        vlocity_cmt__QuotePricingAdjustment__c quotePricingAdjustmentRecord3 =
            new vlocity_cmt__QuotePricingAdjustment__c(
                vlocity_cmt__QuoteItemId__c = quoteLineItemRecord2.Id,
                vlocity_cmt__QuoteId__c = quoteRecord.Id,
                vlocity_cmt__Source__c = 'Discount',
                vlocity_cmt__AdjustmentValue__c	 = -100.0,
                vlocity_cmt__PricingVariableId__c = pv.Id
            );
        
        insert new List<vlocity_cmt__QuotePricingAdjustment__c>{
            quotePricingAdjustmentRecord, quotePricingAdjustmentRecord1, quotePricingAdjustmentRecord2, quotePricingAdjustmentRecord3
        };
    }
    
    @isTest
    static void testCustomDocGenOutput() {
        List<Quote> quoteRecordList = [SELECT Id FROM Quote LIMIT 1];
        List<ID> idList= new List<ID> ();
        for(Quote quote: quoteRecordList) {
            idList.add(quote.ID);
        }
        
        Map<String, Map<String,Object>> args = new Map<String, Map<String,Object>>();
        args.put('input', new Map<String, Object>{'arguments' => idList});
        args.put('output', new Map<String, Object>());
        args.put('options', new Map<String, Object>());
        
        
        CustomDataRaptorOutput dataRaptor = new CustomDataRaptorOutput();
        Object result =  dataRaptor.call('CustomDocGenOutput', args);     
        
        System.assertEquals(true, result);
    }
    
    @isTest
    static void testGetFormattedDate() {
        // Test with English format
        Date inputDate = Date.today();
        String formattedDate = DateAndTime.getFormattedDate(inputDate, 'English');
        String inputDay = inputDate.day()<10?'0'+String.valueOf(inputDate.day()):String.valueOf(inputDate.day());
        String inputMonth = inputDate.month()<10?'0'+String.valueOf(inputDate.month()):String.valueOf(inputDate.month());
        String inputYear = String.valueOf(inputDate.year());
        
        //System.assertEquals(String.valueOf(inputDate.day()) + '/' + String.valueOf(inputDate.month()) + '/' + String.valueOf(inputDate.year()), formattedDate);
        System.assertEquals(inputDay + '/' + inputMonth + '/' + inputYear, formattedDate);
        
        // Test with French format
        formattedDate = DateAndTime.getFormattedDate(inputDate, 'French');
        System.assertEquals(inputYear + '-' + inputMonth + '-' + inputDay, formattedDate);
    }
    
    @isTest
    static void testGetFormattedCurrency() {
        // Test with English format
        Decimal inputValue = 1234567.89;
        String formattedCurrency = DateAndTime.getFormattedCurrency(inputValue, 'English');
        System.assertEquals('$1,234,567.89', formattedCurrency);
        
        Decimal inputValue1 = 1;
        String formattedCurrency1 = DateAndTime.getFormattedCurrency(inputValue1, 'English');
        System.assertEquals('$1.00', formattedCurrency1);
        
        Decimal inputValue2 = -1;
        String formattedCurrency2 = DateAndTime.getFormattedCurrency(inputValue2, 'English');
        System.assertEquals('-$1.00', formattedCurrency2);
        
        // Test with French format
        formattedCurrency = DateAndTime.getFormattedCurrency(inputValue, 'French');
        System.assertEquals('1.234.567,89$', formattedCurrency);
        
        formattedCurrency1 = DateAndTime.getFormattedCurrency(inputValue1, 'French');
        //System.assertEquals('$1.00', formattedCurrency1);
        System.assertEquals('1,00$', formattedCurrency1);
        
        formattedCurrency2 = DateAndTime.getFormattedCurrency(inputValue2, 'French');
        //System.assertEquals('-$1.00', formattedCurrency2);
        System.assertEquals('-1,00$', formattedCurrency2);
        //-1,00$
        
    } 
    @isTest
    static void testContractServiceNullQuote() {
        String quoteId;
        Test.startTest();
        Object result = ContractService.process(quoteId);
        Test.stopTest();
        System.assertEquals(null, result); 
    }
}