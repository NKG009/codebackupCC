public inherited sharing class PricingApprovalRequestSelector {
    public static List<Pricing_Approval_Request__c> getPricingApprovalRequestsFromQuoteByStatus(Set<Id> quoteIds, String status) {
        return [SELECT Id, Quote_Approval_Key__c, Quote__c, Quote_Line_Item__c, Approval_Policy__c, Approval_Policy__r.Rules__c FROM Pricing_Approval_Request__c WHERE Quote__c IN :quoteIds AND Status__c = :status];
    }
    
    public static List<Pricing_Approval_Request__c> getPricingApprovalRequestsFromQuotesThatRequireApproval(Set<Id> quoteIds) {
        return [SELECT Id FROM Pricing_Approval_Request__c WHERE Quote__c IN :quoteIds AND Status__c = :ApexConstants.PRICING_APPROVAL_REQUEST_STATUS_APPROVAL_REQUIRED];
    }
    
    public static List<Pricing_Approval_Request__c> getPricingApprovalRequestsFromQuotesByStatus(Set<Id> quoteIds, String status) {
        return [SELECT Id, Quote_Approval_Key__c FROM Pricing_Approval_Request__c WHERE Quote__c IN :quoteIds AND Status__c = :status];
    }
}