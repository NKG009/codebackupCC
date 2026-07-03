public without sharing abstract class ApprovalFactory {
    private QuoteLineItem quoteLineItemRecord;
    private Approval_Policy__c approvalPolicy;
    
    @TestVisible private static final String AF_002_UNEXPECTED_POLICY_TYPE_PROVIDED = 'PF-002: An unexpected policy type was provided for a policy check.';
    
    public ApprovalFactory(QuoteLineItem quoteLineItemRecord, Approval_Policy__c approvalPolicy) {
        this.quoteLineItemRecord = quoteLineItemRecord;
        this.approvalPolicy = approvalPolicy;
    }
    
    public static ApprovalCriteria getThresholdPolicy(QuoteLineItem quoteLineItemRecord, Approval_Policy__c approvalPolicy) {
        if (String.isBlank(approvalPolicy.Type__c)) {
            return null;
        }
        
    	ApprovalCriteria criteriaCheck;
        
        if (approvalPolicy.Rules__c?.contains(ApprovalRequestProcessor.APPROVAL_POLICY_RULE_ALWAYS_REQUIRE_APPROVAL)) {
            criteriaCheck = new PolicyAlwaysRequired(quoteLineItemRecord, approvalPolicy);
        } else if (approvalPolicy.Rules__c?.contains(ApprovalRequestProcessor.APPROVAL_POLICY_RULE_THRESHOLD) && approvalPolicy.Type__c == ApprovalRequestProcessor.APPROVAL_POLICY_FIELD_MATCH_TYPE_AMOUNT) {
            criteriaCheck = new PolicyAmount(quoteLineItemRecord, approvalPolicy);
        } else if (approvalPolicy.Rules__c?.contains(ApprovalRequestProcessor.APPROVAL_POLICY_RULE_THRESHOLD) && approvalPolicy.Type__c == ApprovalRequestProcessor.APPROVAL_POLICY_FIELD_MATCH_TYPE_PERCENT) {
            criteriaCheck = new PolicyPercent(quoteLineItemRecord, approvalPolicy);
        } else {
            throw new ApprovalProcessor.ApprovalProcessorException(AF_002_UNEXPECTED_POLICY_TYPE_PROVIDED);
        }
        
        return criteriaCheck;
    }
    
    public static Boolean isBusinessCaseRequired(QuoteLineItem quoteLineItemRecord, Approval_Policy__c approvalPolicy) {
        if (approvalPolicy.Rules__c?.contains(ApprovalRequestProcessor.APPROVAL_POLICY_RULE_BUSINESS_CASE)) {
            return new PolicyBusinessCase(quoteLineItemRecord, approvalPolicy).approvalCheck();
        }
        
        return false;
    }
    
    public QuoteLineItem getQuoteLineItemRecord() {
        return this.quoteLineItemRecord;
    }
    
    public Approval_Policy__c getApprovalPolicy() {
        return this.approvalPolicy;
    }
}