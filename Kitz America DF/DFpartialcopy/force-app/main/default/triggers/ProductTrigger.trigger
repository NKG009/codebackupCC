/****************************
 * Name : ProductTrigger
 * Description : Trigger on Product object.
 ****************************/

trigger ProductTrigger on Product2 (before insert,after insert, before update, after update) {
 
    // After INSERT
    if(Trigger.isAfter && trigger.isUpdate){
                  ProductTriggerHandler.onAfterInsert(trigger.new,Trigger.oldmap);
        }
    
}