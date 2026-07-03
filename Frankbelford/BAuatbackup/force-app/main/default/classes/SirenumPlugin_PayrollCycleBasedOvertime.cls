/**
* @author Dean Morris
* @description Calculate overtime based on payroll cycle periods
*/
global with sharing class SirenumPlugin_PayrollCycleBasedOvertime implements sirenum.ShiftProcessorOvertimeExtension  {

    global SirenumPlugin_PayrollCycleBasedOvertime() {
    }

    /**
	* @description Fields required by later methods
	*
	*/
    global Set<String> getRequiredFieldPaths() {
        return new Set<String>{'sirenum__Billable_Calculated_Start_Time__c',
		                       'sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__CyclePeriodUnits__c',
                               'sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__periodLength__c',
                               'sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__StartingDate__c',
                               'sirenum__Team__c',
                               'sirenum__Site__c'};
    }
    
    /**
	* @description    Determine start date for overtime calculations - only works for weekly payroll cycles
	* @param shift    Shift being considered
	* @param fallback Fallback routine to call if payroll cycle is not weekly
	* @return         Start of payroll period for the shift
	*/	
    global Date getStartOfWeekFor(sirenum__Shift__c shift,
                                  sirenum.ShiftProcessorOvertimeExtension fallback) {

        // This method only works for payroll cycle periods of one week
        if (shift.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__CyclePeriodUnits__c != 'Weeks' || 
            shift.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__periodLength__c     != 1) {
            return fallback.getStartOfWeekFor(shift, null);
        }
        else
        {
            // Get start of shift day of week as a number where 1 = Monday ... 7 = Sunday
            Date startOfShiftDate = shift.sirenum__Billable_Calculated_Start_Time__c.date();
            Integer startOfShiftDay = Integer.valueOf(shift.sirenum__Billable_Calculated_Start_Time__c.format('u'));
            
            // The 'u' format (day number of week) only works for Datetime not Date so create a Datetime from the payroll cycle starting date
            Datetime startOfPayrollCycleDate = Datetime.newInstance(shift.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__StartingDate__c, 
                                                                    Time.newInstance(0,0,0,0));
            Integer startOfPayrollCycleDay = Integer.valueOf(startOfPayrollCycleDate.format('u'));
            
            // Return start of payroll period
            if (startOfShiftDay >= startOfPayrollCycleDay) {
                return startOfShiftDate.addDays(startOfPayrollCycleDay-startOfShiftDay);
            }
            else {
                return startOfShiftDate.addDays(startOfPayrollCycleDay-startOfShiftDay) - 7;
            }
        }
    }
    
    /**
	* @description    Shifts must be for same Job Role and Site to be considered for overtime. Note that null Job Roles/Sites are considered to be a match
	* @param context  Shift being considered
	* @param nominee  Shift being considered for relevance as past shift for the context shift
	* @return         True if nominee is relevant as a past shift otherwise false
	*/	
    global Boolean isNomineeRelevantAsPastWork(sirenum__Shift__c context,
                                               sirenum__Shift__c nominee,
                                               sirenum.ShiftProcessorOvertimeExtension fallback) {
        return context.sirenum__Team__c == nominee.sirenum__Team__c && context.sirenum__Site__c == nominee.sirenum__Site__c;
    }
    
}