trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert) {
    if(trigger.isBefore) {
        if(trigger.isInsert) ContentDocumentLinkTriggerHelper.beforeInsert(trigger.NEW);
    }
}