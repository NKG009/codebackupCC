trigger ShiftBreakTrigger on sirenum__Shift__c (after insert, after update) {
	try {
		sirenum__Trigger_Settings__c settings = sirenum__Trigger_Settings__c.getOrgDefaults();
		if (settings.Shift_Calculate_Breaks__c) {
			ShiftTriggerUtils.calculateBreaks();
		}
	} catch (Exception e) {throw new StringException(e.getMessage() + ' ' + e.getStackTraceString());}
}