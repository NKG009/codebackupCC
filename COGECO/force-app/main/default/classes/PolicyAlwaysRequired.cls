public without sharing class PolicyAlwaysRequired extends ApprovalFactory implements ApprovalCriteria {
    public PolicyAlwaysRequired(QuoteLineItem quoteLineItemRecord, Approval_Policy__c approvalPolicy) {
        super(quoteLineItemRecord, approvalPolicy);
    }
    
    public Boolean approvalCheck() {
        Approval_Policy__c approvalPolicy = getApprovalPolicy();
        
        return approvalPolicy.Rules__c?.contains(ApprovalRequestProcessor.APPROVAL_POLICY_RULE_ALWAYS_REQUIRE_APPROVAL);
    }
}