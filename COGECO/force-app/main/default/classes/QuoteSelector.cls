public inherited sharing class QuoteSelector {
    public static List<Quote> getSyncedQuotes(Set<Id> quoteIds) {
        return [SELECT Id, IsSyncing FROM Quote WHERE Id IN :quoteIds AND IsSyncing = TRUE];
    }
    
    public static List<Quote> getQuotesForApprovals(Set<Id> quoteIds) {
        return [SELECT Id, vlocity_cmt__PriceListId__c, Approval_Required__c, Business_Case_Required__c, Build_Cost__c, Account.Territory__r.Province__c FROM Quote WHERE Id IN :quoteIds];
    }
    
    public static List<Quote> getPrimaryServiceAccountFromQuotes(Set<Id> quoteIds) {
        return [SELECT Id, AccountId, Account.Primary_Service_Account__c FROM Quote WHERE Id IN :quoteIds];
    }
    
    public static List<Quote> getQuotesToSendEmailToCustomer(Set<Id> quoteIds) {
        return [SELECT Id, Customer_Document_Template_Id__c FROM Quote WHERE Id IN :quoteIds AND Customer_Document_Template_Id__c != NULL];
    }
    
    public static Quote getQuoteForDocumentGeneration(Id quoteId) {
        return [SELECT Id, TodayDate__c, vlocity_cmt__RecurringTotal__c, Recurring_Total__c, vlocity_cmt__OneTimeTotal__c, Account.Name, Account.Territory__r.Province__c, Communication_Language__c, Terms_Conditions__c, Account.ShippingStreet, Account.ShippingCity, Account.ShippingCountry, Account.ShippingState, Account.ShippingPostalCode,Control_Document_Lines__c  FROM Quote WHERE Id = :quoteId LIMIT 1];
    }

    public static Quote getSingleQuoteCommunicationLanguage(Id quoteId) {
        return [SELECT Id, Communication_Language__c FROM Quote WHERE Id = :quoteId];
    }
}