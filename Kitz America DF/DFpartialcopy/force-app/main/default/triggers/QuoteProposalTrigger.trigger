/****************************
* Name : QuoteProposalTrigger
* Description : Trigger on Quote/Proposal object.
****************************/
trigger QuoteProposalTrigger on Apttus_Proposal__Proposal__c (before insert, before update, after update) {
    
    // BEFORE INSERT
    if(Trigger.isBefore && Trigger.isInsert) {
        QuoteProposalTriggerHandler.onBeforeInsert(Trigger.new);
    }
    
    // BEFORE UPDATE
    if(Trigger.isBefore && Trigger.isUpdate) {
        QuoteProposalTriggerHandler.onBeforeUpdate(Trigger.newMap, Trigger.oldMap);
        
        QuoteProposalTriggerHandler.onBeforeUpdate(Trigger.newMap, Trigger.oldMap);
    }
    
    /*Commented as per the glen request
    // AFTER UPDATE
    if(Trigger.isAfter && Trigger.isUpdate) {        
        QuoteProposalTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
    }*/
}