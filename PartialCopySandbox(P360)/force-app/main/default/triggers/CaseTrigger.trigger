trigger CaseTrigger on Case (before insert, before update) {

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            CaseTriggerHandler.beforeInsert();
        }
        if(Trigger.isUpdate){
            CaseTriggerHandler.beforeUpdate();
        }
    }

}