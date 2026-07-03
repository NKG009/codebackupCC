public class CustomerSignatureValidationDto {
    @AuraEnabled public Boolean readyForSignature {get;set;}
    @AuraEnabled public Customer_Approval__c customerApprovalRecord {get;set;}
}