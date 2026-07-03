public without sharing class CustomerSignatureController {    
    private static final String ERR_NO_CUSTOMER_APPROVAL_FOUND = 'ERR-001: A customer approval was not found. Please contact your Sales Executive to have this issue resolved.';
    
    @AuraEnabled(cacheable=true)
    public static String validate(String approvalRecordId, String verificationCode) {
        if (String.isBlank(approvalRecordId) || String.isBlank(verificationCode)) {
            return null;
        }
        
        Map<Customer_Approval__c, ContentVersion> getApprovalFilesDetails = new Map<Customer_Approval__c, ContentVersion>();
        
        try {
        	List<Customer_Approval__c> approvals = CustomerApprovalSelector.getSingleCustomerApprovalFromIdAndVerificationCode(approvalRecordId, verificationCode);
            
            CustomerSignatureValidationDto validationDto = new CustomerSignatureValidationDto();
            validationDto.readyForSignature = approvals[0].Status__c == ApexConstants.CUSTOMER_APPROVAL_STATUS_WITH_CUSTOMER;
            validationDto.customerApprovalRecord = approvals[0];
            
            return JSON.serialize(validationDto);
        } catch (Exception e) {
            icServiceErrorHandler.LogError('CustomerSignatureController', 'validate', e.getStackTraceString(), e.getMessage(), null);
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static String getCustomerApprovalToAction(String approvalRecordId) {
        if (String.isBlank(approvalRecordId)) {
            return null;
        }
        
        CustomerSignatureDto signatureDto = new CustomerSignatureDto();
        Set<Id> contentDocumentIds = new Set<Id>();
        
        try {
        	List<Customer_Approval__c> approvals = CustomerApprovalSelector.getSingleCustomerApprovalFromId(approvalRecordId);
            
            signatureDto.customerApproval = approvals[0];
            
            CustomerSignatureDto signatureDtoDeserialize = (CustomerSignatureDto)JSON.deserialize(signatureDto.customerApproval.Customer_Contract_Details__c, CustomerSignatureDto.class);
            List<CustomerApprovalApproversDto> approversDeserialize = (List<CustomerApprovalApproversDto>)JSON.deserialize(signatureDto.customerApproval.Approvers__c, List<CustomerApprovalApproversDto>.class);
            
            signatureDto.fileName = signatureDtoDeserialize.fileName;
            signatureDto.fileType = signatureDtoDeserialize.fileType;
            signatureDto.downloadUrl = signatureDtoDeserialize.downloadUrl;
            signatureDto.approvers = approversDeserialize;
            
        	return JSON.serialize(signatureDto);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void save(String jsonData, String jsonFiles, String recordId) {
        SavePoint savepoint = Database.setSavepoint();
        
        try {
            Customer_Approval_Event__e customerApprovalEvent = new Customer_Approval_Event__e(Approval_Response__c = jsonData);
            Database.SaveResult saveResult = EventBus.publish(customerApprovalEvent);
        	
            List<CustomerSignatureFileDto> filesDeserialize = (List<CustomerSignatureFileDto>)JSON.deserialize(jsonFiles, List<CustomerSignatureFileDto>.class);
        	
            if (!filesDeserialize.isEmpty()) {
            	insertFiles(filesDeserialize, recordId);
            }
        } catch (Exception e) {
            Database.rollback(savepoint);
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    private static void insertFiles(List<CustomerSignatureFileDto> filesList, String recordId) {
        if (filesList == null || filesList.isEmpty()) {
            return;
        }
        
        List<ContentVersion> contentVersions = createContentVersion(filesList);
        
        Set<Id> contentVersionIds = new Set<Id>();
        
        for (ContentVersion contentVersion : contentVersions) {
			contentVersionIds.add(contentVersion.Id);
        }
        
        contentVersionIds.remove(null);
        
        List<ContentDocumentLink> contentDocumentLink = createContentLink(contentVersionIds, recordId);
    }
    
    private static List<ContentVersion> createContentVersion(List<CustomerSignatureFileDto> filesList) {
        List<ContentVersion> versions = new List<ContentVersion>();
        
        for (CustomerSignatureFileDto fileDto : filesList) {
            versions.add(new ContentVersion(
                VersionData = EncodingUtil.base64Decode(fileDto.base64),
                Title = fileDto.filename,
                PathOnClient = fileDto.filename
            ));
        }
        
        insert versions;
        return versions;
    }
    
    private static List<ContentDocumentLink> createContentLink(Set<Id> contentVersionIds, String recordId) {
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink(
        	LinkedEntityId = recordId
        );
        
        Set<Id> contentDocumentIds = new Set<Id>();
        List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
        
        for (ContentVersion contentVersion : FileSelector.getContentVersionsByContentVersionIds(contentVersionIds)) {
            contentDocumentLinks.add(new ContentDocumentLink(
                LinkedEntityId = recordId,
                ContentDocumentId = contentVersion.ContentDocumentId
            ));
        }
        
        contentDocumentIds.remove(null);
        
        insert contentDocumentLinks;
        return contentDocumentLinks;
    }
    
    @AuraEnabled(cacheable=true)
    public static Boolean is911FormSectionRequired(Id customerApprovalId) {
        if (String.isBlank(customerApprovalId)) {
            return false;
        }
        
        Customer_Approval__c customerApproval = [SELECT Id, Quote__c,Quote__r.Selected_Attachments__c FROM Customer_Approval__c WHERE Id = :customerApprovalId LIMIT 1];
 
        Set<String> attachmentIds = new Set<String>();
        
        if (customerApproval.Quote__r.Selected_Attachments__c != null && String.isNotBlank(customerApproval.Quote__r.Selected_Attachments__c)) {
            attachmentIds = new Set<String>(customerApproval.Quote__r.Selected_Attachments__c.split(ApexConstants.SEMICOLON));
        }
        
        if (attachmentIds.isEmpty()) {
            return false;
        }
        
        Map<Id, Boolean> attachmenIds = new Map<Id, Boolean>();

        for (Customer_Email_Attachment__c emailAttachmentSetting : Customer_Email_Attachment__c.getAll().values()) {
            attachmenIds.put(emailAttachmentSetting.Attachment_Id__c, emailAttachmentSetting.Require_911_Form_Section__c);
        }
        
        attachmenIds.remove(null);

        for (String attachmentId : attachmentIds) {
            if (attachmenIds.get(attachmentId) != null && attachmenIds.get(attachmentId)) {
                return true;
            }
        }
        
        return false;
    }
}