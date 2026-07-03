public without sharing class PolicyAmount extends ApprovalFactory implements ApprovalCriteria {
    public PolicyAmount(QuoteLineItem quoteLineItemRecord, Approval_Policy__c approvalPolicy) {
        super(quoteLineItemRecord, approvalPolicy);
    }
    
    public Boolean approvalCheck() {
        QuoteLineItem quoteLineItemRecord = getQuoteLineItemRecord();
        Approval_Policy__c approvalPolicy = getApprovalPolicy();
        
        return quoteLineItemRecord.vlocity_cmt__RecurringCharge__c < approvalPolicy.Threshold__c;
    }
}