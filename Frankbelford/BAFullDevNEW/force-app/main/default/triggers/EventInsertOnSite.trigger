/*
* Class Name: EventInsertOnSite
* Description: JPC- 1645
* Date : 18th July 2019
*/
trigger EventInsertOnSite on Event (before insert) {
    
    if(Trigger.isbefore && Trigger.isInsert){
        EventTriggerHandler.handleBeforeInsert(trigger.new);
    }
}