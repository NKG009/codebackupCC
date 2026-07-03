trigger OrderTrigger on Order (before insert) {
    if (CurrentUserPolicy.runTriggers()) {
		OrderTriggerHandler.setOrderDefaults(Trigger.new);
    }
}