trigger ServiceAppointmentTrigger on ServiceAppointment (before insert, before update, after insert, after update) {
    Manage_Triggers__c triggerCustomSetting = Manage_Triggers__c.getValues('ServiceAppointmentTrigger');
    System.debug('03 =>' + triggerCustomSetting);
    if (triggerCustomSetting.isActive__c) {
        if ((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter) {
            if (ServiceAppointmentTriggerHandler.isFirstTime) {
                ServiceAppointmentTriggerHandler.isFirstTime = false;
                ServiceAppointmentTriggerHandler.calculateBookingCount(Trigger.new, Trigger.oldMap);
            }
        }
    }
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore) {
        ServiceAppointmentTriggerHandler.calculateArrivalDateTime(Trigger.new, Trigger.oldMap);
    }
}