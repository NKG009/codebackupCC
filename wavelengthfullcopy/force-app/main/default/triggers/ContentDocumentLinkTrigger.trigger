trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
    Set<Id> contentDocumentIds = new Set<Id>();
    
    // Collect ContentDocumentIds from the ContentDocumentLink records
    for (ContentDocumentLink cdl : Trigger.new) {
        contentDocumentIds.add(cdl.ContentDocumentId);
    }
    
    if (!contentDocumentIds.isEmpty()) {
        // Query related ContentVersion records using ContentDocumentId
        List<ContentVersion> contentVersionsToUpdate = [
            SELECT Id, ContentDocumentId 
            FROM ContentVersion 
            WHERE ContentDocumentId IN :contentDocumentIds
        ];
        
        // Populate the custom field on ContentVersion
        for (ContentVersion cv : contentVersionsToUpdate) {
            cv.ContentDocumentId__c = cv.ContentDocumentId;
        }
        
        // Update ContentVersion records with populated custom field
        if (!contentVersionsToUpdate.isEmpty()) {
            update contentVersionsToUpdate;
        }
    }
}