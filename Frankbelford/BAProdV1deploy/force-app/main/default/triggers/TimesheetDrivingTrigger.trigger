trigger TimesheetDrivingTrigger on sirenum__Timesheet__c (before delete) {
    String test1;
	try {
		DrivingData_Generator.handleTimesheetDeletion(Trigger.old);
	} catch (Exception e) {if (Test.isRunningTest()) {throw e;}}
}