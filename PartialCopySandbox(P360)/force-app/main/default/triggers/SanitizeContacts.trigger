trigger SanitizeContacts on Contact (before insert, before update, after update) {
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {
        for (Contact contactToUpdate : Trigger.New) {
            if (contactToUpdate.MobilePhone != NULL) {
                contactToUpdate.MobilePhone = DataSanitizer.sanitizeMobileNumber(contactToUpdate.MobilePhone);
            }
        }
     ContactTriggerHandler.EmailUpdateOnContactInsertOrUpdate(trigger.new); 
    }
    if(trigger.isAfter) {
        if(trigger.isUpdate) {
            ContactTriggerHandler.afterUpdate(trigger.newMap, trigger.oldMap);
        }
    }

}