public without sharing class FileService {
    public static void shareContractsWithAccount(Id currentRecordId, Id accountId, String languageFilter) {
        List<ContentDocumentLink> documentLinksToInsert = new List<ContentDocumentLink>();
        
        for (ContentDocumentLink contentDocumentLinkRecord : FileSelector.getContentDocumentLinksFromRelatedRecords(new Set<Id>{ currentRecordId })) {
            if (contentDocumentLinkRecord.ContentDocument.Title?.startsWith(languageFilter)) {
            	ContentDocumentLink contentDocumentLinkRecordCloned = contentDocumentLinkRecord.clone(false, false, false, false);
                contentDocumentLinkRecordCloned.LinkedEntityId = accountId;
                
                documentLinksToInsert.add(contentDocumentLinkRecordCloned);
            }
        }
        
        if (!documentLinksToInsert.isEmpty()) {
            insert documentLinksToInsert;
        }
    }
}