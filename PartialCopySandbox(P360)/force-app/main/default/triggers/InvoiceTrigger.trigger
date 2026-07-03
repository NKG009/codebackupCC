trigger InvoiceTrigger on Bread_Winner__Invoice__c (after insert, after update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            InvoiceTriggerHandler.afterInsert();
        }
        if(Trigger.isUpdate){        
            InvoiceTriggerHandler.afterUpdate();            
        }
    }

}