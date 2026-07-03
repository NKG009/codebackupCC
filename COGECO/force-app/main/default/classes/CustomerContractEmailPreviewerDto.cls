public without sharing class CustomerContractEmailPreviewerDto {
    @AuraEnabled public Id templateId {get;set;}
    @AuraEnabled public String subject {get;set;}
    @AuraEnabled public String htmlValue {get;set;}
}