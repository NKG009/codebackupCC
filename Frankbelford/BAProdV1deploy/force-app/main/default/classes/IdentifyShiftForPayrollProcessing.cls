/**
* Date: Tuesday, 03rd August 2021
* Author: Jyothi Hale
* Description: Insert scheduled tasks to create timesheets for shifts that fall in last 2 weeks as per the payroll associated with shifts.
*			   The shift will be taken into consideration only if it is approved, pay and charge is checked and the site has been signed off for
*              automated payroll processing. If for a particular week, any shift is not approved, we will ignore all other shifts for that week.
*/
public without sharing class IdentifyShiftForPayrollProcessing {
	private static Date minimumPayrollPeriodDate = Test.isRunningTest() ? Date.newInstance(2021, 8, 1) : Date.today();
    private static Date maximumPayrollPeriodDate = Test.isRunningTest() ? Date.newInstance(2021, 7, 17) : Date.today().addDays(-14);
    private static List<GenerateTimesheetLnConfig> ctlConfigList = new List<GenerateTimesheetLnConfig>();
    private static Map<String, List<sirenum__Shift__c>> excWorkerIdWeMap = new Map<String, List<sirenum__Shift__c>>();
    private static Map<String, List<sirenum__Shift__c>> incWorkerIdWeMap = new Map<String, List<sirenum__Shift__c>>();
    private static Map<String, List<sirenum__Shift__c>> siteShifts = new Map<String, List<sirenum__Shift__c>>();

    public static Boolean scheduleTheTask() {
        Boolean canSchedule = true;
        List<AsyncApexJob> existingJobs = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'AddScheduleTaskToGenerateTimesheet' AND Status = 'Processing'];
        if(existingJobs.size() > 0) {
            canSchedule = false;
        }

		System.debug('IdentifyShiftForPayrollProcessing - scheduleTheTask - canSchedule - ' + canSchedule);
        return canSchedule;
    }

    private static Map<Id, List<sirenum__Week__c>> identifyPayrollCyclePeriodsToProcess() {
		Date startDate = null;
        Date endDate = null;
		String theQuery = Test.isRunningTest() ? 'SELECT sirenum__PayrollCycle__c, sirenum__PayrollCycle__r.Name, sirenum__Start_Date__c, sirenum__Week_Ending__c ' +
            'FROM sirenum__Week__c WHERE sirenum__Week_Ending__c >= 2021-07-17 AND sirenum__Week_Ending__c <= 2021-08-01' : 'SELECT sirenum__PayrollCycle__c, ' +
            'sirenum__PayrollCycle__r.Name, sirenum__Start_Date__c, sirenum__Week_Ending__c FROM sirenum__Week__c WHERE sirenum__Week_Ending__c = LAST_N_WEEKS:2';

        Map<Id, List<sirenum__Week__c>> thePayrollPeriods = new Map<Id, List<sirenum__Week__c>>();
        for(sirenum__Week__c thePayrollPeriod : Database.query(theQuery)) {
			startDate = thePayrollPeriod.sirenum__Start_Date__c;
			endDate = thePayrollPeriod.sirenum__Week_Ending__c;

			if(startDate < minimumPayrollPeriodDate) {
                minimumPayrollPeriodDate = startDate;
            }
			if(endDate > maximumPayrollPeriodDate) {
                maximumPayrollPeriodDate = endDate;
			}

			if(!thePayrollPeriods.containsKey(thePayrollPeriod.sirenum__PayrollCycle__c)) {
				thePayrollPeriods.put(thePayrollPeriod.sirenum__PayrollCycle__c, new List<sirenum__Week__c>());
			}
			thePayrollPeriods.get(thePayrollPeriod.sirenum__PayrollCycle__c).add(thePayrollPeriod);
        }

		System.debug('IdentifyShiftForPayrollProcessing - identifyPayrollCycleStartAndEndDates - thePayrollPeriods - ' + thePayrollPeriods);
		System.debug('IdentifyShiftForPayrollProcessing - identifyPayrollCycleStartAndEndDates - minimumPayrollDate - ' + minimumPayrollPeriodDate);
        System.debug('IdentifyShiftForPayrollProcessing - identifyPayrollCycleStartAndEndDates - maximumPayrollDate - ' + maximumPayrollPeriodDate);
        return thePayrollPeriods;
	}

    private static List<sirenum__Shift__c> identifyShiftsToProcess(Map<Id, List<sirenum__Week__c>> thePayrollPeriods) {
        Map<Id, List<sirenum__Shift__c>> groupingShiftsBasedOnPayrollCycle = new Map<Id, List<sirenum__Shift__c>>();
        for(sirenum__Shift__c theShift : [SELECT
											Name,
                                          	sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__c,
                                          	sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.Name,
                                            sirenum__Placement__r.IP_Consultant1LookupSplitShare__r.Name,
                                            sirenum__Placement__r.sirenum__Contract__r.sirenum__PayrollCycle__r.Name,
                                            ActualStartTime__c,
                                            ActualEndTime__c,
                                            sirenum__Contact__c,
                                            sirenum__Contact__r.Name,
                                            sirenum__Allow_charge__c,
                                            sirenum__Allow_pay__c,
                                            Calendar_Week_Start__c,
                                            Calendar_Week_End__c,
                                            Friday_Weekending__c,
                                            Saturday_Weekending__c,
                                            Sunday_Weekending__c,
                                            sirenum__Site__c,
                                            sirenum__Site__r.sirenum__Operating_Company__r.Name,
                                            sirenum__Site__r.sirenum__Operating_Company__r.Owner.Id,
                                            sirenum__Site__r.sirenum__Operating_Company__r.Owner.Email,
                                            sirenum__Site__r.Name,
                                            sirenum__Site__r.Process_TS_Line_Automatically__c,
                                            sirenum__Site__r.Owner.Email,
                                            sirenum__Site__r.Owner.Id,
                                          	sirenum__Scheduled_Start_Time__c,
                                          	sirenum__Scheduled_End_Time__c,
                                          	IP_ClientApproved__c,
                                            sirenum__Published__c,
                                            (SELECT Id, sirenum__Shift__c FROM sirenum__Timesheet_Lines__r)
										FROM sirenum__Shift__c
                                    	WHERE
											sirenum__Site__r.Process_TS_Line_Automatically__c = true AND
                                          	sirenum__Timesheet_summaries__c = null AND
                                          	sirenum__Cancelled__c = false AND
                                          	sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__c != null AND
                                          	sirenum__Scheduled_Start_Time__c >= :minimumPayrollPeriodDate AND
                                          	sirenum__Scheduled_End_Time__c <= :maximumPayrollPeriodDate]
		) {
            System.debug('IdentifyShiftForPayrollProcessing - identifyShiftsToProcess - SOQL - Level 1 - Shift Name - ' + theShift.Name);

            if(!groupingShiftsBasedOnPayrollCycle.containsKey(theShift.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__c)) {
                groupingShiftsBasedOnPayrollCycle.put(theShift.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__c, new List<sirenum__Shift__c>());
            }
            groupingShiftsBasedOnPayrollCycle.get(theShift.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__c).add(theShift);
        }
        System.debug('IdentifyShiftForPayrollProcessing - identifyShiftsToProcess - groupingShiftsBasedOnPayrollCycle - ' + groupingShiftsBasedOnPayrollCycle);

		List<sirenum__Shift__c> shiftsToProcess = new List<sirenum__Shift__c>();
        if(groupingShiftsBasedOnPayrollCycle.size() > 0) {
			Map<Id, Map<Id, List<sirenum__Shift__c>>> groupingShiftsBasedOnContactAndPayrollPeriod = new Map<Id, Map<Id, List<sirenum__Shift__c>>>();
            for(Id thePayrollCycleId : groupingShiftsBasedOnPayrollCycle.keySet()) {
                for(sirenum__Shift__c theShift : groupingShiftsBasedOnPayrollCycle.get(thePayrollCycleId)) {
                    if(!groupingShiftsBasedOnContactAndPayrollPeriod.containsKey(theShift.sirenum__Contact__c)) {
                        groupingShiftsBasedOnContactAndPayrollPeriod.put(theShift.sirenum__Contact__c, new Map<Id, List<sirenum__Shift__c>>());
                    }

                    for(sirenum__Week__c thePayrollWeek : thePayrollPeriods.get(thePayrollCycleId)) {
                        if(
                            theShift.sirenum__Scheduled_Start_Time__c.date() >= thePayrollWeek.sirenum__Start_Date__c &&
                            theShift.sirenum__Scheduled_End_Time__c.date() <= thePayrollWeek.sirenum__Week_Ending__c
                        ) {
							System.debug('IdentifyShiftForPayrollProcessing - identifyShiftsToProcess - Period Range - Level 2 - Shift Name - ' + theShift.Name);

                            if(!groupingShiftsBasedOnContactAndPayrollPeriod.get(theShift.sirenum__Contact__c).containsKey(thePayrollWeek.Id)) {
                                groupingShiftsBasedOnContactAndPayrollPeriod.get(theShift.sirenum__Contact__c).put(thePayrollWeek.Id, new List<sirenum__Shift__c>());
                            }
                            groupingShiftsBasedOnContactAndPayrollPeriod.get(theShift.sirenum__Contact__c).get(thePayrollWeek.Id).add(theShift);
                            break;
                        }
                    }
                }
            }
            System.debug('IdentifyShiftForPayrollProcessing - identifyShiftsToProcess - groupingShiftsBasedOnContactAndPayrollPeriod - ' + groupingShiftsBasedOnContactAndPayrollPeriod);

            if(groupingShiftsBasedOnContactAndPayrollPeriod.size() > 0) {
                for(Id theContactId : groupingShiftsBasedOnContactAndPayrollPeriod.keySet()) {
                    for(Id thePayRollWeekId : groupingShiftsBasedOnContactAndPayrollPeriod.get(theContactId).keySet()) {
                        for(sirenum__Shift__c theShift : groupingShiftsBasedOnContactAndPayrollPeriod.get(theContactId).get(thePayRollWeekId)) {
                            if(
                                theShift.IP_ClientApproved__c == false ||
                                theShift.sirenum__Published__c == false ||
                                theShift.sirenum__Allow_pay__c == false ||
                                theShift.sirenum__Allow_charge__c == false
                            ) {
                                System.debug('IdentifyShiftForPayrollProcessing - identifyShiftsToProcess - Clearing Week - ' + thePayRollWeekId);
                                groupingShiftsBasedOnContactAndPayrollPeriod.get(theContactId).get(thePayRollWeekId).clear();
                                break;
                            }
                        }
                    }
                }
				System.debug('IdentifyShiftForPayrollProcessing - identifyShiftsToProcess - groupingShiftsBasedOnContactAndPayrollPeriod - ' + groupingShiftsBasedOnContactAndPayrollPeriod);

                for(Id theContactId : groupingShiftsBasedOnContactAndPayrollPeriod.keySet()) {
                    for(Id thePayRollWeekId : groupingShiftsBasedOnContactAndPayrollPeriod.get(theContactId).keySet()) {
                        for(sirenum__Shift__c theShift : groupingShiftsBasedOnContactAndPayrollPeriod.get(theContactId).get(thePayRollWeekId)) {
                            shiftsToProcess.add(theShift);
                        }
                    }
                }
            }
        }

        System.debug('IdentifyShiftForPayrollProcessing - identifyShiftsToProcess - shiftsToProcess.size - ' + shiftsToProcess.size());
        return shiftsToProcess;
    }

    private static void getAllShiftsToProcess() {
        // Fetching payroll periods information and grouping by payroll cycle.
		Map<Id, List<sirenum__Week__c>> thePayrollPeriods = identifyPayrollCyclePeriodsToProcess();

        // Fetching shifts based on payroll week.
        List<sirenum__Shift__c> shiftsToProcess = identifyShiftsToProcess(thePayrollPeriods);
        for(sirenum__Shift__c s : shiftsToProcess) {
			System.debug('IdentifyShiftForPayrollProcessing - identifyShiftsToProcess - Final Level - Shift Name - ' + s.Name);

            String workerIdWE = s.sirenum__Contact__c + ',' + getWeekendDateString(s);
            if(
                s.sirenum__Allow_pay__c == true &&
                s.sirenum__Allow_charge__c == true &&
                s.sirenum__Timesheet_Lines__r.size() == 0 &&
                !excWorkerIdWeMap.containsKey(workerIdWE)
            ) {
				addShift(incWorkerIdWeMap, s);
			}
            else {
				addShift(excWorkerIdWeMap,s);

                // Remove the worker if already included.
				incWorkerIdWeMap.remove(workerIdWE);
			}
        }
        System.debug('IdentifyShiftForPayrollProcessing - identifyShiftsToProcess - incWorkerIdWeMap.size - ' + incWorkerIdWeMap.size());
        System.debug('IdentifyShiftForPayrollProcessing - identifyShiftsToProcess - excWorkerIdWeMap.size - ' + excWorkerIdWeMap.size());

        for(List<sirenum__Shift__c> sList : incWorkerIdWeMap.values()) {
            for(sirenum__Shift__c s : sList) {
                String accountWE = s.sirenum__Site__r.sirenum__Operating_Company__r.Name + '!!!!' + getWeekendDateString(s) + '>>>>' + s.sirenum__Site__r.Owner.Id;
                if(siteShifts.containsKey(accountWE)) {
                    siteShifts.get(accountWE).add(s);
                }
                else {
					siteShifts.put(accountWE, new List<sirenum__Shift__c>{s});
                }
            }
        }
        System.debug('IdentifyShiftForPayrollProcessing - identifyShiftsToProcess - siteShifts.size - ' + siteShifts.size());
    }

    public static String getWeekendDateString(sirenum__Shift__c s) {
        String weekendString = null;
        if(s.sirenum__Placement__r.sirenum__Contract__r.sirenum__PayrollCycle__r.Name == 'Saturday to Friday') {
            weekendString = String.valueof(s.Friday_Weekending__c);
        }
        else if(s.sirenum__Placement__r.sirenum__Contract__r.sirenum__PayrollCycle__r.Name == 'Sunday to Saturday') {
            weekendString = String.valueof(s.Saturday_Weekending__c);
        }
        else if(s.sirenum__Placement__r.sirenum__Contract__r.sirenum__PayrollCycle__r.Name == 'Monday to Sunday') {
            weekendString = String.valueof(s.Sunday_Weekending__c);
        }

        System.debug('IdentifyShiftForPayrollProcessing - getWeekendDateString - weekendString - ' + weekendString);
        return weekendString;
    }

    private static void addShift(Map<String, List<sirenum__Shift__c>> workerIdWeShiftMap, sirenum__Shift__c s) {
        String workerIdWE = s.sirenum__Contact__c + ',' + getWeekendDateString(s);
        if(workerIdWeShiftMap.containsKey(workerIdWE)) {
            workerIdWeShiftMap.get(workerIdWE).add(s);
        }
        else {
			workerIdWeShiftMap.put(workerIdWE, new List<sirenum__Shift__c>{s});
        }
    }

    private static void buildConfigurationFilter(sirenum__Shift__c shift, GenerateTimesheetLnConfig ctlConfig) {
        if(!ctlConfig.Filter.IP_Consultant1LookupSplitShare.contains(shift.sirenum__Placement__r.IP_Consultant1LookupSplitShare__r.Name)) {
            ctlConfig.Filter.IP_Consultant1LookupSplitShare.add(shift.sirenum__Placement__r.IP_Consultant1LookupSplitShare__r.Name);
        }
        if(!ctlConfig.Filter.sirenum_Contact.contains(shift.sirenum__Contact__r.Name)) {
            ctlConfig.Filter.sirenum_Contact.add(shift.sirenum__Contact__r.Name);
        }
        if(!ctlConfig.Filter.sirenum_Site.contains(shift.sirenum__Site__r.Name)) {
            ctlConfig.Filter.sirenum_Site.add(shift.sirenum__Site__r.Name);
        }
        if(String.isBlank(ctlConfig.notify)) {
            ctlConfig.notify = Impellam_Settings__c.getValues('AutoTimesheetNotificationEmail').Email__c;
        }
    }

    private static String applyFieldName(String jsonString) {
        jsonString = jsonString.replace('IP_Consultant1LookupSplitShare', 'sirenum_js__Placement__r.IP_Consultant1LookupSplitShare');
        jsonString = jsonString.replace('"sirenum_Site"', '"sirenum__Site__c"');
        jsonString = jsonString.replace('"sirenum_Contact"', '"sirenum__Contact__c"');
        return jsonString;
    }

    public static Map<String, String> getConfiguration() {
        Map<String, String> jsonStringMap = new Map<String, String>();

        getAllShiftsToProcess();
        for(String eachSite : siteShifts.keySet()) {
            GenerateTimesheetLnConfig ctlLnConfig = new GenerateTimesheetLnConfig();
            String payCycleName;
            String siteName = eachSite.split('!!!!')[0];
            String closingWeekEnd = eachSite.split('!!!!')[1];
            for(sirenum__Shift__c s : siteShifts.get(eachSite)) {
                payCycleName = s.sirenum__Placement__r.sirenum__Contract__r.sirenum__PayrollCycle__r.Name;
                buildConfigurationFilter(s, ctlLnConfig);
            }

            ctlLnConfig.Period.selectionClause = 'sirenum__PayrollCycle__r.Name = \'' + payCycleName + '\' AND Week_Ending__c = LAST_N_WEEKS:2';
            ctlLnConfig.Period.orderByClause = 'Week_Ending__c DESC';
            ctlConfigList.add(ctlLnConfig);

            jsonStringMap.put(siteName + ' - WE ' + closingWeekEnd, applyFieldName(JSON.serializePretty(ctlLnConfig)));
        }
        return jsonStringMap;
    }
}