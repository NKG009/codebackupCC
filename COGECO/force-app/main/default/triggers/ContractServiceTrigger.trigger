trigger ContractServiceTrigger on ContractService__c (before insert, before update, after insert, after update) {
ContractServiceTriggerHandler instance = ContractServiceTriggerHandler.getInstance();
    switch on Trigger.OperationType{
        when BEFORE_INSERT{
            instance.onBeforeInsert(Trigger.new);
        }
        when BEFORE_UPDATE{
            instance.onBeforeUpdate(Trigger.new);
        }
        when AFTER_INSERT{
            instance.onAfterInsert(Trigger.new,Trigger.oldmap);
        }
        when AFTER_UPDATE{
            instance.onAfterUpdate(Trigger.new,Trigger.oldmap);
        }
    } 
}