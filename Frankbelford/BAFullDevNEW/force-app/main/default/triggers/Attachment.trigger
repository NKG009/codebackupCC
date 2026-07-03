trigger Attachment on TR1__Reference__c (after insert,after update) {
    
   if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        AttachmentReferencetrggerHandler.handleAfterInsertUpdate(trigger.new);
    }
}