global with sharing class DrivingDataGenerator_Batch implements Database.Batchable<Id> {
    private List<Id> timesheetIds = new List<Id>();
    global DrivingDataGenerator_Batch(List<Id> timesheetIds) {
        setTimesheetIds(timesheetIds);
    }

    public void setTimesheetIds(List<Id> timesheetIds) {
        system.debug('Received ' + timesheetIds.size() + ' timesheet IDs: ' + timesheetIds);
        this.timesheetIds = timesheetIds;
    }

    global List<Id> start(Database.BatchableContext BC) {
        return this.timesheetIds;
    }


    global void execute(Database.BatchableContext BC, List<Id> scope) {
        new DrivingData_Generator(null).processTimesheetChanges(scope);
    }

    global void finish(Database.BatchableContext BC) {

    }
}