public without sharing class PolicyPercent extends ApprovalFactory implements ApprovalCriteria {
    public PolicyPercent(QuoteLineItem quoteLineItemRecord, Approval_Policy__c approvalPolicy) {
        super(quoteLineItemRecord, approvalPolicy);
    }
    
    public Boolean approvalCheck() {
        QuoteLineItem quoteLineItemRecord = getQuoteLineItemRecord();
        Approval_Policy__c approvalPolicy = getApprovalPolicy();
        
        if (quoteLineItemRecord.Initial_Recurring_Charge__c == 0) {
            return false;
        }
        
        Decimal percentageDifference = ((quoteLineItemRecord.Initial_Recurring_Charge__c - quoteLineItemRecord.vlocity_cmt__RecurringCharge__c) / quoteLineItemRecord.Initial_Recurring_Charge__c) * 100;
        return percentageDifference > approvalPolicy.Threshold__c;
    }
}