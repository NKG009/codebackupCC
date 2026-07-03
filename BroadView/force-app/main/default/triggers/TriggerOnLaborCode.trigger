trigger TriggerOnLaborCode on Labor_Codes__c (before insert) {
    
    if(Trigger.isBefore && Trigger.isInsert){
        LaborCodeTriggerHandler.checkForContractLineItems(trigger.new);
    }

}