/****************************
* Name : OrderTrigger
* Description : Trigger on Order object.
* Created By: Sumit Mishra
* Created Date: 14-04-2020
* Last Modified Date: 14-04-2020
****************************/

trigger OrderTrigger on Apttus_Config2__Order__c (before insert, after insert) {
    if(trigger.isInsert && Trigger.isBefore){
        // BEFORE INSERT
        If(Trigger.isBefore && Trigger.isInsert) {
            OrderTriggerHandler.onBeforeInsert(Trigger.New);
        }
    }
    
    if(Trigger.isAfter && trigger.isInsert){
        // AFTER INSERT
        If(Trigger.isAfter && Trigger.isInsert) {
            OrderTriggerHandler.onAfterInsert(Trigger.New);
        }
    }
}