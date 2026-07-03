public without sharing class PolicyBusinessCase extends ApprovalFactory implements ApprovalCriteria {
    public PolicyBusinessCase(QuoteLineItem quoteLineItemRecord, Approval_Policy__c approvalPolicy) {
        super(quoteLineItemRecord, approvalPolicy);
    }
    
    public Boolean approvalCheck() {
        Approval_Policy__c approvalPolicy = getApprovalPolicy();
        
        return approvalPolicy.Rules__c?.contains(ApprovalRequestProcessor.APPROVAL_POLICY_RULE_BUSINESS_CASE);
    }
}