trigger AccountContactRelationTrigger on AccountContactRelation (after insert, after update, after delete) {
    
    if(trigger.isAfter) {
        if(trigger.isInsert) {
            AccountContactRelationTriggerHandler.afterInsert(trigger.NEW);
        }
        if(trigger.isUpdate) {
            AccountContactRelationTriggerHandler.afterUpdate(trigger.NEW, trigger.oldMap);
        }
        if(trigger.isDelete) {
            AccountContactRelationTriggerHandler.afterDelete(trigger.OLD);
        }
    }
}