trigger Request_UpdateDriving on sirenum__Employee_Request__c (after insert, after update, after delete) {
    //Recount unavailability hours on reference period weeks
    try {
        if (!Driving_Settings__c.getOrgDefaults().Disable_Request_Trigger__c) {
            DrivingData_Generator.handleRequest((Trigger.isDelete) ? Trigger.old : Trigger.new);
        }
    } catch (Exception e) {
        //Do nothing
    }
}