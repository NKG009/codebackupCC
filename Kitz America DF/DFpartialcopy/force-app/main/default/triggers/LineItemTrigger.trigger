/****************************
 * Name : LineItemTrigger
 * Description : Trigger on Line Item object.
 ****************************/

trigger LineItemTrigger on Apttus_Config2__LineItem__c (before insert, before update) {
    
    // BEFORE INSERT
    if(Trigger.isBefore && Trigger.isInsert ) {
        LineItemTriggerHandler.onBeforeInsert(Trigger.new);
    }
    
    // BEFORE UPDATE
    if(Trigger.isBefore && Trigger.isUpdate ) {
        LineItemTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
}