public without sharing class ApprovalRequestProcessor {
    public static final String APPROVAL_POLICY_FIELD_MATCH_TYPE_AMOUNT = 'Amount';
    public static final String APPROVAL_POLICY_FIELD_MATCH_TYPE_PERCENT = 'Percent';
    public static final String APPROVAL_POLICY_RULE_ALWAYS_REQUIRE_APPROVAL = 'Always Require Approval';
    public static final String APPROVAL_POLICY_RULE_THRESHOLD = 'Threshold';
    public static final String APPROVAL_POLICY_RULE_BUSINESS_CASE = 'Business Case';
    public static final String PRICING_APPROVAL_REQUEST_STATUS_APPROVAL_REQUIRED = 'Approval Required';
    public static final Set<String> APPLICABLE_PROVINCES = new Set<String>{ 'ON', 'QC' };
    
    private QuoteLineItem quoteLineItemRecord;
    private ApprovalProcessor approvalProcessor;
    private Approval_Policy__c policy;
    
    public ApprovalRequestProcessor(QuoteLineItem quoteLineItemRecord, ApprovalProcessor approvalProcessor, Approval_Policy__c policy) {
        this.quoteLineItemRecord = quoteLineItemRecord;
        this.approvalProcessor = approvalProcessor;
        this.policy = policy;
    }
    
    public void processPolicyCheck() {
        ApprovalCriteria criteriaCheck = ApprovalFactory.getThresholdPolicy(this.quoteLineItemRecord, this.policy);
        Boolean isSatisfied = criteriaCheck.approvalCheck();
        Boolean businessCaseRequired = ApprovalFactory.isBusinessCaseRequired(this.quoteLineItemRecord, this.policy);
        
        ApprovalProcessorQuoteDto quoteDto = this.approvalProcessor.getQuoteRecords().get(this.quoteLineItemRecord.QuoteId);
        
        if (isSatisfied) {
            this.approvalProcessor.getApprovalRequestsToProcess().get(ApprovalStateEnum.ISINSERT).add(
                new Pricing_Approval_Request__c(
                    Approval_Policy__c = this.policy.Id,
           			Quote__c = this.quoteLineItemRecord.QuoteId,
                    Quote_Line_Item__c = quoteLineItemRecord.Id,
                    Status__c = PRICING_APPROVAL_REQUEST_STATUS_APPROVAL_REQUIRED,
                    Requested_Recurring_Charge__c = this.quoteLineItemRecord.vlocity_cmt__RecurringCharge__c
                )
            );
            
            quoteDto.quoteApprovalRequired = true;
            this.approvalProcessor.getQuoteRecords().put(this.quoteLineItemRecord.QuoteId, quoteDto);
        
            if (businessCaseRequired) {
                quoteDto.quoteBusinessCaseRequired = true;
                this.approvalProcessor.getQuoteRecords().put(this.quoteLineItemRecord.QuoteId, quoteDto);
            }
            
            this.processDeletionIfRequired();
        } else {            
            this.processDeletionIfRequired();
        }
    }
    
    private void processDeletionIfRequired() {
        String pricingApprovalRequestKey = this.quoteLineItemRecord.QuoteId + ApexConstants.PIPE + this.quoteLineItemRecord.Id + ApexConstants.PIPE + this.quoteLineItemRecord.Quoted_Price_List__c;
            
        if (this.approvalProcessor.getExistingApprovalRequests().containsKey(pricingApprovalRequestKey)) {
            this.approvalProcessor.getApprovalRequestsToProcess().get(ApprovalStateEnum.ISDELETE).add(
                this.approvalProcessor.getExistingApprovalRequests().get(pricingApprovalRequestKey)
            );
        }
    }
}