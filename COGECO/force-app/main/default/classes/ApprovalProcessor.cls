public without sharing class ApprovalProcessor {
    public class ApprovalProcessorException extends Exception { }
    @TestVisible private static final String AP_001_UNEXPECTED_FIELD_TYPE_PROVIDED = 'AP-001: An unexpected data type was provided for an approval policy check.';

    private ApprovalStateEnum state;
    
    private Map<Id, QuoteLineItem> quoteLineItemsToProcess;
    private Map<Id, ApprovalProcessorQuoteDto> quoteRecords;
    private Map<String, Pricing_Approval_Request__c> existingOpenApprovalRequests;
    private Map<String, Pricing_Approval_Request__c> completedApprovalRequests;
    private Map<ApprovalStateEnum, List<Pricing_Approval_Request__c>> approvalRequestsToProcess;
    private Map<String, Approval_Policy__c> policyMap;
    
    private Set<String> policyKeys;
    private Set<Id> allQuoteLineItemIdsForPolicy;
    
    public ApprovalProcessor(Map<Id, QuoteLineItem> quoteLineItemsToProcess, ApprovalStateEnum state) {
        this.state = state;
        
        this.quoteLineItemsToProcess = quoteLineItemsToProcess;
        this.quoteRecords = new Map<Id, ApprovalProcessorQuoteDto>();
        this.existingOpenApprovalRequests = new Map<String, Pricing_Approval_Request__c>();
        this.completedApprovalRequests = new Map<String, Pricing_Approval_Request__c>();
        this.approvalRequestsToProcess = new Map<ApprovalStateEnum, List<Pricing_Approval_Request__c>>();
        this.policyMap = new Map<String, Approval_Policy__c>();
        
        this.policyKeys = new Set<String>();
        this.allQuoteLineItemIdsForPolicy = new Set<Id>();
    }
    
    /**
     * @description  Calling statement to execute processing
     */
    public void process() {
        this.setKeysForApprovalRequestsToProcess();
        SavePoint savePoint = Database.setSavepoint();
        
        try {
            if (this.state == ApprovalStateEnum.ISINSERT) {
                this.processInsert();
            } else if (this.state == ApprovalStateEnum.ISUPDATE) {
                this.processUpdate();
            } else if (this.state == ApprovalStateEnum.ISDELETE) {
                this.processDelete();
            } else {
                throw new ApprovalProcessorException(AP_001_UNEXPECTED_FIELD_TYPE_PROVIDED);
            }
        } catch (Exception e) {
            Database.rollback(savePoint);
        }
    }
    
    private void getQuoteIds() {
        for (QuoteLineItem quoteLineItemRecord : this.quoteLineItemsToProcess.values()) {
            this.quoteRecords.put(quoteLineItemRecord.QuoteId, null);
            this.policyKeys.add(quoteLineItemRecord.Product2Id.to15() + ApexConstants.PIPE + quoteLineItemRecord.Quoted_Price_List__c + ApexConstants.PIPE + quoteLineItemRecord.Account_Territory__c);
        }
        
        this.quoteRecords.remove(null);
        this.policyKeys.remove(null);
    }
    
    private void buildQuoteMaps() {
        for (Quote quoteRecord : QuoteSelector.getQuotesForApprovals(this.quoteRecords.keySet())) {
            ApprovalProcessorQuoteDto quoteDto = new ApprovalProcessorQuoteDto();
            quoteDto.quoteId = quoteRecord.Id;
            quoteDto.quotePriceListId = quoteRecord.vlocity_cmt__PriceListId__c;
            quoteDto.quoteApprovalRequired = false;//default for later processing
            quoteDto.quoteBusinessCaseRequired = false;//default for later processing
            quoteDto.territoryProvince = quoteRecord.Account.Territory__r.Province__c;
            quoteDto.buildCost = quoteRecord.Build_Cost__c;
            
            this.quoteRecords.put(quoteRecord.Id, quoteDto);
        }
        
        this.quoteRecords.remove(null);
    }
    
    private void getExistingPricingApprovalRequests() {
        this.existingOpenApprovalRequests.clear();
        this.completedApprovalRequests.clear();
            
        for (Pricing_Approval_Request__c existingRequest : PricingApprovalRequestSelector.getPricingApprovalRequestsFromQuoteByStatus(this.quoteRecords.keySet(), ApexConstants.PRICING_APPROVAL_REQUEST_STATUS_APPROVAL_REQUIRED)) {
            this.existingOpenApprovalRequests.put(existingRequest.Quote_Approval_Key__c, existingRequest);
        }
            
        for (Pricing_Approval_Request__c existingRequest : PricingApprovalRequestSelector.getPricingApprovalRequestsFromQuotesByStatus(this.quoteRecords.keySet(), ApexConstants.PRICING_APPROVAL_REQUEST_STATUS_APPROVED)) {
            this.completedApprovalRequests.put(existingRequest.Quote_Approval_Key__c, existingRequest);
        }
        
        this.existingOpenApprovalRequests.remove(null);
        this.completedApprovalRequests.remove(null);
    }
    
    private void getApprovalPolicies() {
        for (Approval_Policy__c approvalPolicy : ApprovalPolicySelector.getActiveApprovalPoliciesByKey(this.policyKeys)) {
            this.policyMap.put(approvalPolicy.Policy_Key__c, approvalPolicy);
        }
        
        this.policyMap.remove(null);
    }
    
    private void policyCheck() {
        if (this.policyMap.isEmpty()) {
            return;
        }
        
        for (QuoteLineItem quoteLineItemRecord : this.quoteLineItemsToProcess.values()) {
            
            Pricing_Approval_Request__c openRequest = this.existingOpenApprovalRequests.get(quoteLineItemRecord.QuoteId + ApexConstants.PIPE + quoteLineItemRecord.Id + ApexConstants.PIPE + quoteLineItemRecord.Quoted_Price_List__c);
            
            if (openRequest != null) {
                continue;
            }
            
            ApprovalProcessorQuoteDto quoteRecordDto = this.quoteRecords.get(quoteLineItemRecord.QuoteId);
            String policyKey = quoteLineItemRecord.Product2Id.to15() + ApexConstants.PIPE + quoteLineItemRecord.Quoted_Price_List__c + ApexConstants.PIPE + quoteRecordDto.territoryProvince;
            
            if (!this.policyMap.containsKey(policyKey)) {
                continue;
            }
            
            Approval_Policy__c policy = this.policyMap.get(policyKey);
            //Boolean provinceSatisfied = isProvinceSatisfied(quoteRecordDto?.territoryProvince, policy);
            
            if (policy != null) {
                new ApprovalRequestProcessor(quoteLineItemRecord, this, policy).processPolicyCheck();
            }
        }
    }
    
    private Boolean isProvinceSatisfied(String province, Approval_Policy__c policy) {
        return policy?.Applicable_Province__c?.contains(province);
    }
    
    private void processInsert() {
        this.getQuoteIds();
        this.getExistingPricingApprovalRequests();
        this.buildQuoteMaps();
        this.getApprovalPolicies();
        
        if (this.policyKeys.isEmpty()) {
            return;
        }
        
        this.policyCheck();
        
        this.processInsertionOfPricingApprovalRequests();
        this.processDeletionOfPricingApprovalRequests();
        
        this.processQuotes();
    }
    
    private void processUpdate() {
        this.getQuoteIds();
        this.getExistingPricingApprovalRequests();
        this.buildQuoteMaps();
        this.getApprovalPolicies();
        
        if (this.policyKeys.isEmpty()) {
            return;
        }
        
        this.policyCheck();
        
        this.processInsertionOfPricingApprovalRequests();
        this.processDeletionOfPricingApprovalRequests();
        
        this.processQuotes();
    }
    
    private void processDelete() {
        this.getQuoteIds();
        this.getExistingPricingApprovalRequests();
        this.buildQuoteMaps();
        
        this.processDeletionOfPricingApprovalRequests();
        
        this.processQuotes();
    }
    
    private void processInsertionOfPricingApprovalRequests() {
        List<Pricing_Approval_Request__c> newApprovalRequests = this.approvalRequestsToProcess.get(ApprovalStateEnum.ISINSERT);
        
        if (!newApprovalRequests.isEmpty()) {
            insert newApprovalRequests;
        }
    }
    
    private void processDeletionOfPricingApprovalRequests() {
        List<Pricing_Approval_Request__c> deleteApprovalRequests = this.approvalRequestsToProcess.get(ApprovalStateEnum.ISDELETE);
        
        //process straight deletions of quote line items
        if (this.state == ApprovalStateEnum.ISDELETE) {
            for (QuoteLineItem deletedQuoteLineItem : this.quoteLineItemsToProcess.values()) {
                Pricing_Approval_Request__c existingPricingApprovalRequest = this.existingOpenApprovalRequests.get(deletedQuoteLineItem.QuoteId + ApexConstants.PIPE + deletedQuoteLineItem.Id + ApexConstants.PIPE + deletedQuoteLineItem.Quoted_Price_List__c);
                
                if (existingPricingApprovalRequest != null) {
                	deleteApprovalRequests.add(existingPricingApprovalRequest);
                }
            }
        }
        
        if (!deleteApprovalRequests.isEmpty()) {
            delete deleteApprovalRequests;
        }
    }
    
    private void processQuotes() {
        this.getExistingPricingApprovalRequests();
        Map<Id, Quote> quoteRecordsToUpdate = new Map<Id, Quote>();
        
        for (ApprovalProcessorQuoteDto quoteRecordDto : this.quoteRecords.values()) {
            Quote quoteToUpdate = new Quote(
            	Id = quoteRecordDto.quoteId,
                Approval_Required__c = quoteRecordDto.quoteApprovalRequired,
                Business_Case_Required__c = quoteRecordDto.quoteBusinessCaseRequired,
                Status = ApexConstants.QUOTE_STATUS_DRAFT
            );
            
            if (quoteRecordDto.buildCost != null) {
                quoteToUpdate.Approval_Required__c = true;
                quoteToUpdate.Business_Case_Required__c = true;
                quoteToUpdate.Status = ApexConstants.QUOTE_STATUS_NEEDS_REVIEW;
            }
            
            quoteRecordsToUpdate.put(quoteRecordDto.quoteId, quoteToUpdate);
        }
        
        quoteRecordsToUpdate.remove(null);
        
        for (Pricing_Approval_Request__c existingRequest : this.existingOpenApprovalRequests.values()) {
            Quote quoteRecord = quoteRecordsToUpdate.get(existingRequest.Quote__c);
            
            if (!quoteRecord.Business_Case_Required__c) {
            	quoteRecord.Business_Case_Required__c = existingRequest.Approval_Policy__r.Rules__c?.contains(ApprovalRequestProcessor.APPROVAL_POLICY_RULE_BUSINESS_CASE);
            }
            
            quoteRecord.Approval_Required__c = true;
            quoteRecord.Status = ApexConstants.QUOTE_STATUS_NEEDS_REVIEW;
            quoteRecord.Approved_By__c = null;
            quoteRecord.Approval_Date__c = null;
            
            quoteRecordsToUpdate.put(quoteRecord.Id, quoteRecord);
        }
        
        if (!quoteRecordsToUpdate.isEmpty()) {
            update quoteRecordsToUpdate.values();
        }
    }
    
    private void setKeysForApprovalRequestsToProcess() {
        approvalRequestsToProcess.put(ApprovalStateEnum.ISINSERT, new List<Pricing_Approval_Request__c>());
        approvalRequestsToProcess.put(ApprovalStateEnum.ISDELETE, new List<Pricing_Approval_Request__c>());
    }
    
    public Map<String, Pricing_Approval_Request__c> getExistingApprovalRequests() {
        return this.existingOpenApprovalRequests;
    }
    
    public Map<ApprovalStateEnum, List<Pricing_Approval_Request__c>> getApprovalRequestsToProcess() {        
        return this.approvalRequestsToProcess;
    }
    
    public Map<Id, ApprovalProcessorQuoteDto> getQuoteRecords() {
        return this.quoteRecords;
    }
}