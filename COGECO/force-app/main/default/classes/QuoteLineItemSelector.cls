public inherited sharing class QuoteLineItemSelector {
    public static List<QuoteLineItem> getQuoteLineItemsForSyncByQueryString(Set<String> fieldApiNames, Set<Id> filterIds) {
        String query = 'SELECT Id, OpportunityLineItemId, QuoteId, ' + 
            String.join(new List<String>(fieldApiNames), ApexConstants.COMMA) + ' FROM QuoteLineItem' + 
            ' WHERE OpportunityLineItemId IN :filterIds AND Quote.IsSyncing = TRUE';
        
        return Database.query(query);
    }
    
    public static List<QuoteLineItem> getQuoteLineItemsForContractGeneration(Id quoteId) {
        return [SELECT Id,
                Product2Id,
                Product2.Family,
                ListPrice,
                vlocity_cmt__QuoteMemberId__c,
                vlocity_cmt__OneTimeCharge__c,
                Quantity,
                Term__c, 
                Download_Speed__c,
                Customer_Facing_Comments__c,
                Product2.Name,
                Product2.Product_Name_C__c,
                Product2.Product_Name_French__c,
                Product2.Product_Name_FR_C__c ,
                Subtotal__c,
                Initial_Subtotal__c,
                Initial_Recurring_Charge__c,
                vlocity_cmt__RecurringCharge__c,
                vlocity_cmt__ServiceAccountId__c,
                vlocity_cmt__ServiceAccountId__r.ShippingStreet,
                vlocity_cmt__ServiceAccountId__r.ShippingCountry,
                vlocity_cmt__ServiceAccountId__r.ShippingCity,
                vlocity_cmt__ServiceAccountId__r.ShippingState,
                vlocity_cmt__ServiceAccountId__r.ShippingPostalCode,
                vlocity_cmt__QuoteMemberId__r.vlocity_cmt__ServiceAccountId__r.ShippingStreet,
                vlocity_cmt__QuoteMemberId__r.vlocity_cmt__ServiceAccountId__r.ShippingCountry,
                vlocity_cmt__QuoteMemberId__r.vlocity_cmt__ServiceAccountId__r.ShippingCity,
                vlocity_cmt__QuoteMemberId__r.vlocity_cmt__ServiceAccountId__r.ShippingState,
                vlocity_cmt__QuoteMemberId__r.vlocity_cmt__ServiceAccountId__r.ShippingPostalCode,
                vlocity_cmt__QuoteMemberId__r.vlocity_cmt__City__c,
                vlocity_cmt__QuoteMemberId__r.vlocity_cmt__Country__c,
                vlocity_cmt__QuoteMemberId__r.vlocity_cmt__StreetAddress__c,
                vlocity_cmt__QuoteMemberId__r.vlocity_cmt__Address1__c,
                vlocity_cmt__QuoteMemberId__r.vlocity_cmt__State__c,
                vlocity_cmt__QuoteMemberId__r.vlocity_cmt__PostalCode__c,
                vlocity_cmt__Action__c
                FROM QuoteLineItem 
                WHERE vlocity_cmt__Action__c != NULL AND QuoteId = :quoteId 
                ORDER BY vlocity_cmt__LineNumber__c, vlocity_cmt__SequenceNumber__c];
    }
}