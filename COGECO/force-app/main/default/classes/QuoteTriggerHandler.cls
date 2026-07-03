public without sharing class QuoteTriggerHandler {
    static final System_Values__c SYSTEM_VALUES = System_Values__c.getInstance();
    
    public static void setDefaultValues(List<Quote> quoteRecords, Map<Id, Quote> oldMap) {
        if (quoteRecords == null || quoteRecords.isEmpty()) {
            return;
        }
        
        if (TriggerHelper.stopQuote) { return; }
        TriggerHelper.stopQuote = true;
        
        for (Quote quoteRecord : quoteRecords) {
            Quote oldQuote = oldMap?.get(quoteRecord.Id) == null ? new Quote() : oldMap.get(quoteRecord.Id);
            
            if (String.isBlank(quoteRecord.Communication_Language__c) && Trigger.isInsert) {
                quoteRecord.Communication_Language__c = System_Values__c.getInstance(ApexConstants.SYSTEM_VALUES_QUOTE_COMMUNICATIONS_LANGUAGE_DEFAULT).Value__c;
            }
            
            if (quoteRecord.Approved_By__c == null && quoteRecord.Approval_Date__c != null && oldQuote.Approval_Date__c == null) {
                quoteRecord.Approved_By__c = UserInfo.getUserId();
            }
        }
    }
    
    public static void resetClonedQuotes(List<Quote> quoteRecords) {
        if (quoteRecords == null || quoteRecords.isEmpty()) {
            return;
        }
        
        for (Quote quoteRecord : quoteRecords) {
            if (quoteRecord.isClone()) {
                quoteRecord.Approval_Date__c = null;
                quoteRecord.Approved_By__c = null;
                
                quoteRecord.getCloneSourceId();
            }
        }
    }
    
    public static void handleApprovedQuotes(List<Quote> quoteRecords, Map<Id, Quote> oldMap) {
        if (quoteRecords == null || quoteRecords.isEmpty()) {
            return;
        }
        
        Set<Id> quoteIds = new Set<Id>();
		
        for (Quote quoteRecord : quoteRecords) {
            Quote oldQuote = oldMap?.get(quoteRecord.Id) == null ? new Quote() : oldMap.get(quoteRecord.Id);
            
            if (quoteRecord.Status == ApexConstants.QUOTE_STATUS_APPROVED && oldQuote.Status != ApexConstants.QUOTE_STATUS_APPROVED) {
                quoteIds.add(quoteRecord.Id);
            }
        }
        
        quoteIds.remove(null);
        
        if (!quoteIds.isEmpty()) {
            List<Pricing_Approval_Request__c> approvalRequests = new List<Pricing_Approval_Request__c>();
            
            for (Pricing_Approval_Request__c pricingApprovalRequestRecord : PricingApprovalRequestSelector.getPricingApprovalRequestsFromQuotesThatRequireApproval(quoteIds)) {
                approvalRequests.add(new Pricing_Approval_Request__c(
                	Id = pricingApprovalRequestRecord.Id,
                    Status__c = ApexConstants.PRICING_APPROVAL_REQUEST_STATUS_APPROVED
                ));
            }
            
            if (!approvalRequests.isEmpty()) {
                update approvalRequests;
            }
        }
    }
    
    public static void handleBuildCost(List<Quote> quoteRecords, Map<Id, Quote> oldMap) {
        if (quoteRecords == null || quoteRecords.isEmpty()) {
            return;
        }
        
        Map<Id, Quote> quotesWithChangedBuildCost = new Map<Id, Quote>();
        
        for (Quote quoteRecord : quoteRecords) {
            Quote oldQuote = oldMap?.get(quoteRecord.Id) == null ? new Quote() : oldMap.get(quoteRecord.Id);
            
            if (quoteRecord.Build_Cost__c == oldQuote.Build_Cost__c) {
                continue;
            }
            
            //default the details
            quoteRecord.Business_Case_Required__c = false;
            quoteRecord.Approval_Required__c = false;
            quoteRecord.Status = quoteRecord.Status == ApexConstants.QUOTE_STATUS_NEEDS_REVIEW ? ApexConstants.QUOTE_STATUS_DRAFT : quoteRecord.Status;
            
            if (quoteRecord.Build_Cost__c != null) {
                setQuoteForApproval(quoteRecord, true);
            } else if (quoteRecord.Build_Cost__c == null && oldQuote.Build_Cost__c != null) {
                quotesWithChangedBuildCost.put(quoteRecord.Id, quoteRecord);
            }
        }
        
        quotesWithChangedBuildCost.remove(null);
        
        if (quotesWithChangedBuildCost.isEmpty()) {
            return;
        }
        
        for (Pricing_Approval_Request__c pricingApprovalRequestRecord : [SELECT Id, Quote__c, Approval_Policy__r.Rules__c FROM Pricing_Approval_Request__c WHERE Quote__c = :quotesWithChangedBuildCost.keySet() AND Status__c = :ApexConstants.PRICING_APPROVAL_REQUEST_STATUS_APPROVAL_REQUIRED]) {
            if (String.isNotBlank(pricingApprovalRequestRecord.Approval_Policy__r.Rules__c)) {
                Quote quoteRecord = quotesWithChangedBuildCost.get(pricingApprovalRequestRecord.Quote__c);
                
                if (quoteRecord == null) {
                    continue;
                }
                
                setQuoteForApproval(quoteRecord, pricingApprovalRequestRecord.Approval_Policy__r.Rules__c?.contains(ApprovalRequestProcessor.APPROVAL_POLICY_RULE_BUSINESS_CASE));
            }
        }
    }
    
    private static void setQuoteForApproval(Quote quoteRecord, Boolean businessCaseRequired) {
        quoteRecord.Business_Case_Required__c = businessCaseRequired;
        quoteRecord.Approval_Required__c = true;
        quoteRecord.Status = ApexConstants.QUOTE_STATUS_NEEDS_REVIEW;
        quoteRecord.Approval_Date__c = null;
        quoteRecord.Approved_By__c = null;
    }
}