/*
* Trigger Name: TaskInsertOnSite
* Description: JPC- 1645
* Date : 18th July 2019
*/
trigger TaskInsertOnSite on Task (before insert) {
    
    if(Trigger.isBefore||Trigger.isInsert){
        TaskTriggerHandler.handleBeforeInsert(trigger.new);
    }
}