/**
 * Created by akruv on 03/01/2018.
 */

global with sharing class SirenumPlugin_Payroll implements sirenum.TimesheetResultsListener {
    @testVisible private List<Id> timesheetIds = null;
    global SirenumPlugin_Payroll() {

    }

    global void handleEvent(Sirenum.TimesheetResultsEvent event) {
        if (!Driving_Settings__c.getOrgDefaults().Disable_Week_Generation__c) {
            Database.executeBatch(new DrivingDataGenerator_Batch(((this.timesheetIds != null) ? this.timesheetIds : event.getIds())));
        }
    }
}