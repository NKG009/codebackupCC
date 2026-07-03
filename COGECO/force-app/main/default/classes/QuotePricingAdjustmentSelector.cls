public inherited sharing class QuotePricingAdjustmentSelector {
    public static List<vlocity_cmt__QuotePricingAdjustment__c> getQuotePricingAdjustmentsFromQuoteLineItems(Set<String> quoteLineItemIds) {
        return [SELECT Id,
                vlocity_cmt__PricingVariableCode__c, 
                vlocity_cmt__QuoteItemId__c,
                vlocity_cmt__QuoteItemId__r.Product2.Family,
                vlocity_cmt__QuoteItemId__r.Quantity,
                vlocity_cmt__QuoteItemId__r.vlocity_cmt__QuoteMemberId__c,
                vlocity_cmt__QuoteItemId__r.vlocity_cmt__QuoteMemberId__r.vlocity_cmt__ServiceAccountId__c,
                vlocity_cmt__QuoteItemId__r.vlocity_cmt__ServiceAccountId__c,
                vlocity_cmt__QuoteItemId__r.Term__c,
                vlocity_cmt__QuoteItemId__r.Total__c,
                vlocity_cmt__QuoteItemId__r.Initial_Subtotal__c,
                vlocity_cmt__QuoteAppliedPromotionId__c,
                vlocity_cmt__AdjustmentValue__c,
                vlocity_cmt__Amount__c,
                vlocity_cmt__Source__c,
                vlocity_cmt__Sequence__c,
                vlocity_cmt__PricingVariableId__r.vlocity_cmt__RecurringFrequency__c,
                vlocity_cmt__QuoteAppliedPromotionId__r.vlocity_cmt__QuoteDiscountId__r.Name 
                FROM vlocity_cmt__QuotePricingAdjustment__c WHERE vlocity_cmt__QuoteItemId__c IN :quoteLineItemIds
                ORDER BY vlocity_cmt__QuoteItemId__c, vlocity_cmt__Sequence__c];
    }
}