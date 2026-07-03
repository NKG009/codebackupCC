trigger ShiftInvitationTrigger_FB on sirenum__Shift_Invitation__c (before insert, before update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
           
        }
    }
}