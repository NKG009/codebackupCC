trigger OpportunityLineItemTrigger on OpportunityLineItem (after insert, before update, after update) {
    if (CurrentUserPolicy.runTriggers()) {
        if (Trigger.isInsert) {
            OpportunityLineItemTriggerHandler.processInsertSync(Trigger.new);
        }
        
        if (Trigger.isUpdate && Trigger.isBefore) {
            OpportunityLineItemTriggerHandler.setSalesPrice(Trigger.new);
        }
        
        if (Trigger.isUpdate && Trigger.isAfter) {
            OpportunityLineItemTriggerHandler.processUpdateSync(Trigger.new);
        }
    }
}