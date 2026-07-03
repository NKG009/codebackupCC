/*
* Trigger Name: UpdateDivisionOnSPlacement.
* Description: Incident - 11081
* Test Class: TestUpdateDivisionOnSPlacementHandler
* Date : 20th March 2020
*/
trigger UpdateDivisionOnSPlacement on sirenum__Placement__c (before insert , before update) {
    
    if(Trigger.isBefore && Trigger.isUpdate){
        UpdateDivisionOnSPlacementHandler.handleBeforeUpdate(trigger.newMap, trigger.oldMap);
    }
    
    if(Trigger.isBefore && Trigger.isInsert){
        UpdateDivisionOnSPlacementHandler.handleBeforeInsert(trigger.new);
    }
}