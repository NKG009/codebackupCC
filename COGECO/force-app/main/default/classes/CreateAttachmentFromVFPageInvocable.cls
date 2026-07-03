public class CreateAttachmentFromVFPageInvocable {
    @InvocableMethod
    public static void createAttachmentFromVisualforcePage(List<EmailWrapper> emailWrappers) {
        if (emailWrappers == null || emailWrappers.isEmpty()) {
            return;
        }
        
        try {
            PageReference documentContent;
            
            if (emailWrappers[0]?.visualforcePageName == ApexConstants.VLOCITY_VF_PAGE_QUOTEDOCUMENTPDF) {
                documentContent = Page.vlocity_cmt__QuoteDocumentPdf;
            }
            
            documentContent.getParameters().put('Id', emailWrappers[0]?.relatedRecordId);
            
            Blob contentBlob;
            
            if (Test.isRunningTest()) {
                contentBlob = Blob.toPdf(CreateAttachmentFromVFPageInvocableTest.TEST_BLOB_CONTENT);
            } else {
                contentBlob = documentContent.getContentAsPDF();
            }
            
            ContentVersion newContentVersion = new ContentVersion(
                VersionData = contentBlob,
                Title = emailWrappers[0]?.attachmentName,
                PathOnClient = emailWrappers[0]?.attachmentName + ApexConstants.FILE_EXTENSION_PDF
            );
            insert newContentVersion;
            
            newContentVersion = FileSelector.getContentVersionsByContentVersionIds(new Set<Id>{ newContentVersion.Id })?.get(0);
            
            insert new ContentDocumentLink(
                ContentDocumentId = newContentVersion.ContentDocumentId,
                ShareType = ApexConstants.CONTENT_DOCUMENT_LINK_SHARE_TYPE_INFERRED,
                LinkedEntityId = emailWrappers[0]?.relatedRecordId
            );
        } catch (Exception e) {
            icServiceErrorHandler.LogError('CreateAttachmentFromVFPageInvocable', 'createAttachmentFromVisualforcePage', e.getStackTraceString(), e.getMessage(), null);
        }
    }
}