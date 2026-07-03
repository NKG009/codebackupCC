public without sharing class ShiftTriggerUtils {
	private static final String DEFAULT_BREAK_TYPE = 'Break_Calculation';
	//private static final String NAMESPACE_PREFIX = 'sirenum__';
	private static final String START_TIME_POSTFIX = '_Start_Time__c';
	private static final String END_TIME_POSTFIX = '_End_Time__c';

	public static void calculateBreaks() {
		//Figure out which fields to use to get the start and end times of the shift
		sirenum__TimesheetSettings__c settings = sirenum__TimesheetSettings__c.getOrgDefaults();
		if (settings.Break_Calculation_Type__c == null) {
			settings.Break_Calculation_Type__c = DEFAULT_BREAK_TYPE;
		}

		String fldStart = settings.Break_Calculation_Type__c + START_TIME_POSTFIX;
		String fldEnd = settings.Break_Calculation_Type__c + END_TIME_POSTFIX;

		//Create a list of all relevant team and site IDs
		Set<Id> idTeams = new Set<Id>();
		Set<Id> idSites = new Set<Id>();
		List<sirenum__Shift__c> shiftsToProcess = new List<sirenum__Shift__c>();
		List<sirenum__Shift_Break__c> breaks = new List<sirenum__Shift_Break__c>();

		Integer cntShifts = Trigger.new.size();
		for (Integer i=0;i < cntShifts;i++) {
			//Get new and old shift from the trigger
			sirenum__Shift__c shift = (sirenum__Shift__c)Trigger.new[i];
			sirenum__Shift__c oldShift = (Trigger.isUpdate) ? (sirenum__Shift__c)Trigger.old[i] : null;

			//Check that changes were made to the shift in the relevant field
			if (!Trigger.isUpdate ||
				shift.sirenum__Team__c != oldShift.sirenum__Team__c ||
				shift.sirenum__Site__c != oldShift.sirenum__Site__c ||
				shift.get(fldStart) != oldShift.get(fldStart) ||
				shift.get(fldEnd) != oldShift.get(fldEnd)) {
				// Collect shifts to process, team and site ids (only for shifts that we need calculate later)
				if (!shift.sirenum__Break_Override__c) {
					shiftsToProcess.add(shift);
					if (shift.sirenum__Team__c != null) idTeams.add(shift.sirenum__Team__c);
					if (shift.sirenum__Site__c != null) idSites.add(shift.sirenum__Site__c);
				}
			}
		}

		if (shiftsToProcess.size() > 0) {
			// Load break definitions according to team + site
			Map<Id[], List<sirenum__Break_Definition__c>> mapBreaks  = loadBreakDefinitions(idTeams, idSites);

			//Iterate over all shifts and find the relevant break for each
			for (sirenum__Shift__c shift : shiftsToProcess) {
				//Get the start/end time of the shift
				DateTime dtStart = (DateTime)shift.get(fldStart),
						 dtEnd = (DateTime)shift.get(fldEnd);

				//If no value in the configured fields, use billable calculated times by default
				if (dtStart == null) {
					dtStart = shift.Break_Calculation_Start_Time__c;
				}

				if (dtEnd == null) {
					dtEnd = shift.Break_Calculation_End_Time__c;
				}

				if (dtEnd == null || dtStart == null) {
					continue;
				}

				//Calculate shift length in hours
				Decimal shiftLength = (dtEnd.getTime() - dtStart.getTime()) / 3600000.0;

				//Find most appropriate break definition
				List<sirenum__Break_Definition__c> breakDefinitions = getBreaks(mapBreaks, shift.sirenum__Team__c, shift.sirenum__Site__c, shiftLength);

				//Create all breaks and add them to the list of breaks to insert to the database
				breaks.addAll(createBreaks(shift, dtStart, dtEnd, breakDefinitions));
			}

			//Remove all old breaks from the database
			delete [SELECT Id FROM sirenum__Shift_Break__c WHERE sirenum__Shift__c IN :shiftsToProcess LIMIT 5000];

			//Insert all new breaks
			insert breaks;
		}
	}

	/* Create break instances for the provided shift */
	private static List<sirenum__Shift_Break__c> createBreaks(sirenum__Shift__c shift, DateTime dtStart, DateTime dtEnd, List<sirenum__Break_definition__c> breakDefinitions) {
		List<sirenum__Shift_Break__c> breaks = new List<sirenum__Shift_Break__c>();
		for (sirenum__Break_definition__c def : breakDefinitions) {
			sirenum__Shift_Break__c br = new sirenum__Shift_Break__c();

			br.sirenum__Start_Time__c = computeBreakStartTime(dtStart, dtEnd, def); // CRUD/FLS False Positive
			if (br.sirenum__Start_Time__c != null) {
				br.sirenum__End_Time__c = br.sirenum__Start_Time__c.addMinutes(Integer.valueOf(def.sirenum__Break_length__c));
				br.sirenum__Shift__c = shift.id;
				br.sirenum__Paid_Break__c = def.sirenum__Is_Paid__c;
				br.sirenum__Is_auto__c = true;

				breaks.add(br);
			} else {
				//Break definition invalid?
			}
		}

		return breaks;
	}

	/**
	 * Load map of Break_Definition__c with key of [team_id,site_id] for the specified set of team ids and site ids
	 *
	 * @param idTeams set of team ids
	 * @param idSites set of site ids
	 *
	 * @return Map of Break_Definition__c with key of [team_id,site_id]
	 */
	private static Map<Id[], List<sirenum__Break_Definition__c>> loadBreakDefinitions(Set<Id> idTeams, Set<Id> idSites) {
		Map<Id[], List<sirenum__Break_Definition__c>> result = new Map<Id[], List<sirenum__Break_Definition__c>>();

		//Query break definitions from the database
		List<sirenum__Break_definition__c> breakList = [
				SELECT sirenum__Team__c, sirenum__Site__c, sirenum__BreakTime__c, sirenum__HoursAfterStart__c, sirenum__HoursBeforeEnd__c,
						sirenum__Break_length__c, sirenum__Minimum_shift_length__c , sirenum__Is_Paid__c
				FROM sirenum__Break_definition__c
				WHERE sirenum__Team__c IN :idTeams OR sirenum__Site__c IN :idSites // Use OR will also load items with Team__c or Site__c that are null (fallback)
				ORDER BY sirenum__Minimum_Shift_Length__c DESC]; // Order by larger minimum shift length first to ensure lookup works as expected

		//Map break definitions by team and site
		for (sirenum__Break_Definition__c b : breakList) {

			//Make a key from the team and site IDs
			Id[] key = new Id[] {b.sirenum__Team__c, b.sirenum__Site__c};

			// Find the key in our map
			List<sirenum__Break_Definition__c> definitionsPerKey = result.get(key);

			// Lazy create the list
			if (definitionsPerKey == null) {
				definitionsPerKey = new List<sirenum__Break_Definition__c>();
				result.put(key, definitionsPerKey);
			}

			// Add break definition to the list, query sort order ensure list order is by Minimum_Shift_Length__c DESC
			definitionsPerKey.add(b);
		}

		return result;
	}

	/**
	 * Locate all appropriate shift break definitions for the specified team-id, site-id and shift-length
	 *
	 * @param mapBreaks Map of Break_Definition__c with key of [team_id,site_id]
	 * @param teamId The team id of the shift (can be null)
	 * @param siteId The site id of the shift (can be null)
	 * @param shiftLength The shift legit to check against the definition's Minimum_Shift_Length__c
	 *
	 * @return All matching definitions, which could be an empty list
	 */
	private static List<sirenum__Break_definition__c> getBreaks(Map<Id[], List<sirenum__Break_Definition__c>> mapBreaks, Id teamId, Id siteId, Decimal shiftLength) {
		//Initialize return map
		List<sirenum__Break_definition__c> breaks = new List<sirenum__Break_Definition__c>();

		// Init the key values
		Id[] key = new Id[] {teamId, siteId};

		// Look for matching items
		while (key[0] != null || key[1] != null) {
			// Get the definitions for the team and site key
			List<sirenum__Break_Definition__c> definitions = mapBreaks.get(key);

			if (definitions != null) {
				// Iterate over list to find the best break definition (it'll be the first one due to the query being ordered)
				for (sirenum__Break_Definition__c definition : definitions) {
					if (shiftLength >= definition.sirenum__Minimum_Shift_Length__c) {
						// Found result
						breaks.add(definition);
					}
				}
			}

			// No result yet, change the key

			// By site only
			if (key[0] != null && key[1] != null && siteId != null) key = new Id[] {null, siteId};
			// Bey team only
			else if (key[0] == null && key[1] != null && teamId != null) key = new Id[] {teamId, null};
			// Global
			else key = new Id[] {null, null};
		}

		//Return results
		return breaks;
	}

	public static DateTime computeBreakStartTime(DateTime shiftStartTime, DateTime shiftEndTime, sirenum__Break_Definition__c breakDefinition) {
		// Validate input parameters
		if (shiftStartTime == null || shiftEndTime == null || breakDefinition == null) return null;

		// Get break definition details
		Time fixedStartTime = String.isNotBlank(breakDefinition.sirenum__BreakTime__c) ? SirenumUtils.parseTime(breakDefinition.sirenum__BreakTime__c) : null;
		Decimal hoursAfterStart = breakDefinition.sirenum__HoursAfterStart__c;
		Decimal hoursBeforeEnd = breakDefinition.sirenum__HoursBeforeEnd__c;
		Integer breakLength = (Integer)breakDefinition.sirenum__Break_length__c;

		// Ensure we have valid break length
		if (breakLength == null) breakLength = 0;
		if (breakLength < 0) breakLength = 0;

		// Calculate break start time using the first not null value
		Datetime breakStart = null;
		if (fixedStartTime != null) {
			// The exact time at the shift's start date
			breakStart = Datetime.newInstance(shiftStartTime.date(), fixedStartTime);
		} else if (hoursAfterStart != null) {
			// The shift start time + hours after start
			breakStart = shiftStartTime.addMinutes(Integer.valueOf(hoursAfterStart * 60));
		} else if (hoursBeforeEnd != null) {
			// The shift end time - hours before end
			breakStart = shiftEndTime.addMinutes(Integer.valueOf(-hoursBeforeEnd * 60));
		} else {
			//Nothing defined? Put break at end of shift
			breakStart = shiftEndTime.addMinutes(0 - breakLength);
		}

		// Validate the break is inside the shift time
		if (breakStart != null) {
			if (breakStart < shiftStartTime || breakStart.addMinutes(breakLength) > shiftEndTime) {
				// Invalid break - reset the start
				breakStart = null;
			}
		}

		// Return the start
		return breakStart;
	}
}