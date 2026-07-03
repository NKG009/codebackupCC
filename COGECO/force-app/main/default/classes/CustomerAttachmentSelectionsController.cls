public with sharing class CustomerAttachmentSelectionsController {
    @AuraEnabled
    public static String getCustomerEmailAttachments(String recordId) {
        if (String.isBlank(recordId)) {
            return null;
        }

        try {
            Quote quoteRecord = QuoteSelector.getSingleQuoteCommunicationLanguage(recordId);
    
            String languageFolderId = System_Values__c.getInstance(ApexConstants.SYSTEM_VALUES_CUSTOMER_ATTACHMENT_FOLDER_ENGLISH_ID).Value__c;
    
            if (quoteRecord.Communication_Language__c == ApexConstants.FRENCH) {
                languageFolderId = System_Values__c.getInstance(ApexConstants.SYSTEM_VALUES_CUSTOMER_ATTACHMENT_FOLDER_FRENCH_ID).Value__c;
            }
    
            Set<Id> contentDocumentIdsFromFolder = new Set<Id>();
    
            Map<Id, Customer_Email_Attachment__c> customerEmailAttachmentRules = new Map<Id, Customer_Email_Attachment__c>();
    
            for (Customer_Email_Attachment__c emailAttachmentRule : Customer_Email_Attachment__c.getAll().values()) {
                if (emailAttachmentRule.Active__c) {
                    customerEmailAttachmentRules.put(emailAttachmentRule.Attachment_Id__c, emailAttachmentRule);
                }
            }
    
            customerEmailAttachmentRules.remove(null);
    
            for (ContentFolderMember folderMember : FileSelector.getContentFolderMembersFromFolderId(languageFolderId)) {
                if (customerEmailAttachmentRules.containsKey(folderMember.ChildRecordId)) {
                    contentDocumentIdsFromFolder.add(folderMember.ChildRecordId);
                }
            }
    
            contentDocumentIdsFromFolder.remove(null);
    
            List<CustomerEmailAttachmentDto> customerAttachmentDtos = new List<CustomerEmailAttachmentDto>();
    
            for (ContentVersion contentVersionRecord : FileSelector.getContentVersionsByContentDocumentIds(contentDocumentIdsFromFolder)) {
                Customer_Email_Attachment__c emailAttachmentRule = customerEmailAttachmentRules.get(contentVersionRecord.ContentDocumentId);
    
                if (emailAttachmentRule == null) {
                    continue;
                }
    
                String title = String.isBlank(emailAttachmentRule.Attachment_Name_Override__c) ? contentVersionRecord.Title : System.Label.get('', emailAttachmentRule.Attachment_Name_Override__c, quoteRecord.Communication_Language__c);
                String description = String.isBlank(emailAttachmentRule.Attachment_Description_Override__c) ? contentVersionRecord.Title : System.Label.get('', emailAttachmentRule.Attachment_Description_Override__c, quoteRecord.Communication_Language__c);
    
                customerAttachmentDtos.add(new CustomerEmailAttachmentDto(
                    contentVersionRecord.ContentDocumentId,
                    title,
                    description,
                    contentVersionRecord.FileExtension
                ));
            }
    
            return JSON.serialize(customerAttachmentDtos);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}