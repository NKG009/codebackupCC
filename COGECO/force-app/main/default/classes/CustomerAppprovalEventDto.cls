public without sharing class CustomerAppprovalEventDto {
	@AuraEnabled public String customerApprovalId;
	@AuraEnabled public String approvedBy;
	@AuraEnabled public String approvedByEmail;
	@AuraEnabled public String comments;
	@AuraEnabled public String ipAddress;
	@AuraEnabled public String status;
    @AuraEnabled public Id contactId;
	@AuraEnabled public String consentedBy;
}