trigger OrderProductTriggerNew on OrderItem (before insert,before update) {
    
    if (Trigger.isBefore && (Trigger.isinsert || Trigger.isupdate)) {  // before insert or before update 
        OrderProductTriggerHandler.applyPricingandvaluepopulate(Trigger.new);
    }

	 if (Trigger.isBefore && Trigger.isupdate) {  // before update 
        OrderProductTriggerHandler.applyvalidationrule(Trigger.new);
    }

}