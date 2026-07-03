trigger CustomerApprovalTrigger on Customer_Approval__c (before insert) {
    if (CurrentUserPolicy.runTriggers()) {
        if (Trigger.isBefore && Trigger.isInsert) {
            CustomerApprovalTriggerHandler.setDefaultValues(Trigger.New);
            CustomerApprovalTriggerHandler.updateAttachmentsAndLanguage(Trigger.New);
            CustomerApproval911approvers.setDefaultValues(Trigger.New);
        }
    }
}