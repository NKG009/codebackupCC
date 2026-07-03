trigger OrderTrigger on Order (after update) {
    Manage_Triggers__c triggerCustomSetting = Manage_Triggers__c.getValues('OrderTrigger');
    if (triggerCustomSetting.isActive__c) {
        if(Trigger.isafter && Trigger.isupdate){ 
            
            OrderTriggerHandler.OrderIdaddtoCustomsettingforPMeInvoicepost(trigger.new,trigger.newmap,trigger.oldmap);
            OrderTriggerHandler.AddingOdrErroredrecordforPost(trigger.new,trigger.oldmap);
			OrderTriggerHandler.OrderidtocustomsettingPropertytree(trigger.new,trigger.oldmap,trigger.newmap);
        }
        
        
    }
    

}