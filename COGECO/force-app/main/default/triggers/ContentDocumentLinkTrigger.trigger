trigger ContentDocumentLinkTrigger on ContentDocumentLink(before insert, after insert) {
    if (CurrentUserPolicy.runTriggers()) {
        if (Trigger.isBefore) {
            ContentDocumentLinkTriggerHandler.processContentDocumentLinkSharing(Trigger.new);
        }
        
        if (Trigger.isAfter) {
            ContentDocumentLinkTriggerHandler.processContentDistributions(Trigger.new);
            ContentDocumentLinkTriggerHandler.launchEmailCustomerFlow(Trigger.new);
        }
    }
}