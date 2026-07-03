trigger QuoteTrigger on Quote (before insert, before update, after update) {
    if (CurrentUserPolicy.runTriggers()) {
        if (Trigger.isBefore) {
    		QuoteTriggerHandler.setDefaultValues(Trigger.new, Trigger.oldMap);
        }
        
        if (Trigger.isBefore && Trigger.isUpdate) {
            QuoteTriggerHandler.handleBuildCost(Trigger.new, Trigger.oldMap);
        }
        
        if (Trigger.isAfter && Trigger.isUpdate) {
            QuoteTriggerHandler.handleApprovedQuotes(Trigger.new, Trigger.oldMap);
        }
        
        if (Trigger.isInsert) {
            QuoteTriggerHandler.resetClonedQuotes(Trigger.new);
        }
    }
}