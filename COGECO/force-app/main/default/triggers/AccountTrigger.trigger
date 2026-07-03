trigger AccountTrigger on Account(before insert, before update) {
    if (CurrentUserPolicy.runTriggers()) {
        if (Trigger.isInsert || Trigger.isUpdate) {
			AccountTriggerHandler.setDefaultPriceList(Trigger.new);
        }
        
        if (Trigger.isUpdate) {
            AccountTriggerHandler.setDefaultValues(Trigger.new, Trigger.oldMap);
        }
    }
}