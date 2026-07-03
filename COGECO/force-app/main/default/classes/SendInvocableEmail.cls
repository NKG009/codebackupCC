public without sharing class SendInvocableEmail {
    @InvocableMethod
    public static void sendCustomerFinalApprovalEmail(List<EmailWrapper> emailWrappers) {
        if (emailWrappers == null || emailWrappers.isEmpty()) {
            return;
        }
        
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        
        try {
            emailMessage.setTemplateId(emailWrappers[0]?.templateId);
            emailMessage.setTargetObjectId(emailWrappers[0]?.targetId);
            emailMessage.setTreatTargetObjectAsRecipient(false);
            emailMessage.setWhatId(emailWrappers[0]?.relatedRecordId);
            
            if (emailWrappers[0]?.isFromOrgEmail) {
                OrgWideEmailAddress emailAddress = SystemUtilities.getOrgWideEmailAddressId(emailWrappers[0].emailFrom);
            	emailMessage.setOrgWideEmailAddressId(emailAddress.Id);
            }
            
            if (!emailWrappers[0]?.isInternalEmail) {
            	setAddresses(emailMessage, emailWrappers[0]);
            } else {
                List<String> internalEmails = General_Settings__c.getInstance().Internal_Contract_Delivery_Email__c.split(ApexConstants.COMMA);
                emailMessage.setToAddresses(internalEmails);
            }
            
            if (emailWrappers[0]?.sendAttachment && emailWrappers[0]?.attachmentName != null) {
                String likeCriteria = ApexConstants.LIKE_NOTATION + emailWrappers[0]?.attachmentName + ApexConstants.LIKE_NOTATION;
                
                List<ContentDocumentLink> files = FileSelector.getContentDocumentLinkForCustomerApproval(emailWrappers[0].recordId);
                Set<Id> allAttachmentContentDocumentIds = new Set<Id>{ files[0].ContentDocumentId };
                
                if (String.isNotBlank(emailWrappers[0]?.additionalContentDocumentIdsForAttachments)) {
                    for (String contentDocumentId : emailWrappers[0]?.additionalContentDocumentIdsForAttachments.split(ApexConstants.SEMICOLON)) {
                        allAttachmentContentDocumentIds.add(contentDocumentId);
                    }
                    
                    for (ContentDocumentLink documentLink : FileSelector.getContentDocumentLinksFromContentDocumentIds(allAttachmentContentDocumentIds)) {
                        files.add(documentLink);
                    }
                }
                
                if (!files.isEmpty()) {
                    emailMessage.setFileAttachments(contentDocumentAsAttachement(allAttachmentContentDocumentIds));
                }
            }
            
            Messaging.SendEmailResult[] emailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailMessage });
            
            if (emailWrappers[0]?.createDocumentLink != null && emailWrappers[0]?.createDocumentLink) {
        		FileService.shareContractsWithAccount(emailWrappers[0]?.recordId, emailWrappers[0]?.relatedRecordId, emailWrappers[0]?.attachmentName);
            }
        } catch (Exception e) {
            icServiceErrorHandler.LogError('SendInvocableEmail', 'sendCustomerFinalApprovalEmail', e.getStackTraceString(), e.getMessage(), null);
        }
    }
    
    private static void setAddresses(Messaging.SingleEmailMessage emailMessage, EmailWrapper emailWrapper) {
        if (String.isNotBlank(emailWrapper.emailTo)) {
        	emailMessage.setToAddresses(new List<String>{ emailWrapper.emailTo });
        }
        
        if (emailWrapper.emailTos != null && !emailWrapper.emailTos.isEmpty()) {
        	emailMessage.setToAddresses(emailWrapper.emailTos);
        }

       if (emailWrapper.emailBccs != null && !emailWrapper.emailBccs.isEmpty()) {
        emailMessage.setBccAddresses(emailWrapper.emailBccs);
    }
}
    
    private static List<Messaging.EmailFileAttachment> contentDocumentAsAttachement(Set<Id> contentDocumentIds) {
        if (contentDocumentIds == null || contentDocumentIds.isEmpty()) {
            return null;
        }
        
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        
        for (ContentVersion document : FileSelector.getContentVersionsByContentDocumentIds(new Set<Id>(contentDocumentIds))) {
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            
            attachment.setBody(document.VersionData);
            attachment.setFileName(document.Title + ApexConstants.DOT + document.FileExtension);
            
            attachments.add(attachment);
        }
        
        return attachments;
    }
}