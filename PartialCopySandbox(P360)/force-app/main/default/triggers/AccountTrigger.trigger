trigger AccountTrigger on Account (after insert, after update, before insert, before update) {
Manage_Triggers__c triggerCustomSetting = Manage_Triggers__c.getValues('AccountTrigger');
    if (triggerCustomSetting.isActive__c) {
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                AccountTriggerHandler.afterInsert(trigger.New);
            }
            if(Trigger.isUpdate){
                AccountTriggerHandler.afterUpdate(trigger.New, trigger.oldMap);
            }
        }
          if(Trigger.isBefore){
            if(Trigger.isInsert){
               AccountTriggerHandler.beforeInsert(trigger.New);
            }
             if(Trigger.isupdate){
               AccountTriggerHandler.beforeUpdate(trigger.New, trigger.oldMap);
            }
        } 
    
    }
   
}