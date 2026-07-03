trigger ContentVersionTrigger on ContentVersion (after insert) {
    System.debug('Content Version Triggered Successfully');
    
  
    if (Trigger.isAfter && Trigger.isInsert) {
        Set<Id> contentDocumentIds = new Set<Id>();
        system.debug('Inside after insert ContentVersionTrigger');
        
        for (ContentVersion cv : Trigger.new) {
            contentDocumentIds.add(cv.ContentDocumentId);
        }
        
        if (!contentDocumentIds.isEmpty()) {
            ContentVersionTriggerHandler.getDocumentPublicLink(contentDocumentIds);
        }
    }

}