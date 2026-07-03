public inherited sharing class OrderSelector {
    public static Order getOrderRecord(String recordId) {
        return [SELECT Id, OpportunityId, vlocity_cmt__OriginatingContactId__c, Opportunity.Owner.LanguageLocaleKey, vlocity_cmt__OpportunityId__r.Owner.LanguageLocaleKey FROM Order WHERE Id = :recordId];
    }
}