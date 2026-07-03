public class CustomerSignatureDto {
    @AuraEnabled public Customer_Approval__c customerApproval {get;set;}
    @AuraEnabled public String fileName {get;set;}
    @AuraEnabled public String fileType {get;set;}
    @AuraEnabled public String downloadUrl {get;set;}
    @AuraEnabled public String ipAddress {get;set;}
    @AuraEnabled public List<CustomerApprovalApproversDto> approvers {get;set;}
    @AuraEnabled public String aprovedBy {get;set;}
    @AuraEnabled public String aprovedByEmail {get;set;}
}