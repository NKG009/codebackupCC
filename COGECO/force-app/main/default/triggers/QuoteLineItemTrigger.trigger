trigger QuoteLineItemTrigger on QuoteLineItem(before insert, before update, after insert, after update, before delete) {
    if (CurrentUserPolicy.runTriggers()) {
        if (Trigger.isInsert && Trigger.isBefore) {
            QuoteLineItemTriggerHandler.processInsertSync(Trigger.new);
            QuoteLineItemTriggerHandler.setDefaultValues(Trigger.new);    
             
        }
        
        if (Trigger.isUpdate && Trigger.isAfter) {
            QuoteLineItemTriggerHandler.processUpdateSync(Trigger.new);
             
        }
        
        if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
            QuoteLineItemTriggerHandler.setSalesPrice(Trigger.new);
        }
        
        if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
            Map<Id, QuoteLineItem> quoteLineItemsToCheckForApproval = QuoteLineItemTriggerHandler.getQuoteLineItemsToCheckForApproval(Trigger.newMap, Trigger.oldMap);
         
            if (!quoteLineItemsToCheckForApproval.isEmpty()) {
                QuoteLineItemTriggerHandler.processApprovals(quoteLineItemsToCheckForApproval, Trigger.operationType);
            }
        } else if (Trigger.isDelete) {
            QuoteLineItemTriggerHandler.processApprovals(Trigger.oldMap, Trigger.operationType);
        }        
    }
}