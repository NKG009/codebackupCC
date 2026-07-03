trigger ShiftBreak_UpdateDriving on sirenum__Shift_Break__c (after insert, after update, after delete) {
    //Recount break hours on reference period weeks
    try {
        if (!Driving_Settings__c.getOrgDefaults().Disable_Break_Trigger__c) {
            DrivingData_Generator.handleBreaks((Trigger.isDelete) ? Trigger.old : Trigger.new);
        }
    } catch (Exception e) {
        //Do nothing
    }
}