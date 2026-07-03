@isTest
public with sharing class ShiftBreakTrigger_Test {
	@TestSetup static void setup() {
		//Enable break trigger
		sirenum__Trigger_Settings__c tSettings = sirenum__Trigger_Settings__c.getOrgDefaults();
		tSettings.Shift_Calculate_Breaks__c = true;
		upsert tSettings;

		//Set to calculate by billable calculated time
		sirenum__TimesheetSettings__c tsSettings = sirenum__TimesheetSettings__c.getOrgDefaults();
		tsSettings.Break_Calculation_Type__c = 'Break_Calculation';
		upsert tsSettings;
        
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

	}

	static testmethod void testBreaksBillable() {
		List<Account> clients = TestDataFactory.createClients(1);
		insert clients;

		List<sirenum__Site__c> sites = TestDataFactory.createSites(clients[0].id, null, 1);
		insert sites;
		sirenum__Site__c site = sites[0];

		List<sirenum__ProActiveContract__c> contracts = TestDataFactory.sirenumProActiveContract(clients[0].id, null, 1);
		insert contracts;

		List<sirenum__Rota__c> sectors = TestDataFactory.createSector(1);
		insert sectors;

		List<sirenum__Job_Type__c> jobTypes = TestDataFactory.createJobType(sectors[0].id, 1);
		insert jobTypes;

		List<sirenum__Team__c> jobRoles = TestDataFactory.createJobRole(contracts[0].id, jobTypes[0].id, 1);
		insert jobRoles;
		sirenum__Team__c jobRole = jobRoles[0];

		sirenum__Break_definition__c[] breakDefs = new sirenum__Break_definition__c[] {
			new sirenum__Break_definition__c(Name='Over 2 hours', sirenum__Minimum_shift_length__c = 2, sirenum__Site__c = site.id, sirenum__Team__c = jobRole.id, sirenum__Break_length__c = 15, sirenum__HoursAfterStart__c=1),
			new sirenum__Break_definition__c(Name='Over 4 hours', sirenum__Minimum_shift_length__c = 4, sirenum__Site__c = site.id, sirenum__Team__c = jobRole.id, sirenum__Break_length__c = 30, sirenum__HoursBeforeEnd__c=1),
			new sirenum__Break_definition__c(Name='TEAM ONLY Over 6 hours', sirenum__Minimum_shift_length__c = 6, sirenum__Team__c = jobRole.id, sirenum__Break_length__c = 60, sirenum__BreakTime__c = '14:00'),
			new sirenum__Break_definition__c(Name='SITE ONLY Over 6 hours', sirenum__Minimum_shift_length__c = 6, sirenum__Site__c = site.id, sirenum__Break_length__c = 75, sirenum__HoursAfterStart__c=1)
		};
		insert breakDefs;

		DateTime dtS  = DateTime.newInstance(Date.newInstance(2018,1,1), Time.newInstance(10,0,0,0));
		DateTime dtE2 = DateTime.newInstance(Date.newInstance(2018,1,1), Time.newInstance(12,0,0,0)); //2 hours
		DateTime dtE4 = DateTime.newInstance(Date.newInstance(2018,1,1), Time.newInstance(14,0,0,0)); //4 Hours
		DateTime dtE8 = DateTime.newInstance(Date.newInstance(2018,1,1), Time.newInstance(18,0,0,0)); //8 Hours

		//The scheduled start times are to try and confuse the system - we should be using the billables
		sirenum__Shift__c[] shifts = new sirenum__Shift__c[] {
			new sirenum__Shift__c(sirenum__Scheduled_Start_Time__c = dtS, sirenum__Scheduled_End_Time__c = dtE2,
								  sirenum__Billable_Start_Time__c = dtS, sirenum__Billable_End_Time__c = dtE4,
								  sirenum__Site__c = site.id, sirenum__Team__c = jobRole.id), //4 hour shift on site and team

			new sirenum__Shift__c(sirenum__Scheduled_Start_Time__c = dtS, sirenum__Scheduled_End_Time__c = dtE2,
								  sirenum__Billable_Start_Time__c = dtS, sirenum__Billable_End_Time__c = dtE4,
								  sirenum__Site__c = site.id, sirenum__Team__c = null), //4 hour shift on Site only

			new sirenum__Shift__c(sirenum__Scheduled_Start_Time__c = dtS, sirenum__Scheduled_End_Time__c = dtE4,
  								  sirenum__Billable_Start_Time__c = dtS, sirenum__Billable_End_Time__c = dtE8,
								  sirenum__Site__c = site.id, sirenum__Team__c = null), //8 hour shift on Site only

			new sirenum__Shift__c(sirenum__Scheduled_Start_Time__c = dtS, sirenum__Scheduled_End_Time__c = dtE2,
								  sirenum__Billable_Start_Time__c = dtS, sirenum__Billable_End_Time__c = dtE8,
								  sirenum__Site__c = null, sirenum__Team__c = jobRole.id), //8 hour shift on Team only

			new sirenum__Shift__c(sirenum__Scheduled_Start_Time__c = dtS, sirenum__Scheduled_End_Time__c = dtE2,
								  sirenum__Billable_Start_Time__c = dtS, sirenum__Billable_End_Time__c = dtE8,
								  sirenum__Site__c = site.id, sirenum__Team__c = jobRole.id)  //8 hour shift on site and team
		};

		Test.startTest();
		insert shifts;
		Test.stopTest();

		//Load the shifts with their new break data
		Map<Id, sirenum__Shift__c> mapShifts = new Map<Id, sirenum__Shift__c>(
												[SELECT Id, sirenum__Billable_Calculated_Start_Time__c, sirenum__Billable_Calculated_End_Time__c,
												(SELECT sirenum__Start_Time__c, sirenum__Duration__c, sirenum__Paid_Break__c
												 FROM sirenum__Shift_Breaks__r
												 ORDER BY sirenum__Start_Time__c)
												 FROM sirenum__Shift__c
												 WHERE Id IN :shifts]);

		//Check the break times
		//Shift 1
		sirenum__Shift__c shift = mapShifts.get(shifts[0].id);
		system.assertEquals(2, shift.sirenum__Shift_Breaks__r.size());
		system.assertEquals(shift.sirenum__Billable_Calculated_Start_Time__c.addHours(1), shift.sirenum__Shift_Breaks__r[0].sirenum__Start_Time__c);
		system.assertEquals(0.25, shift.sirenum__Shift_Breaks__r[0].sirenum__Duration__c);

		system.assertEquals(shift.sirenum__Billable_Calculated_End_Time__c.addHours(-1), shift.sirenum__Shift_Breaks__r[1].sirenum__Start_Time__c);
		system.assertEquals(0.5, shift.sirenum__Shift_Breaks__r[1].sirenum__Duration__c);

		//Shift 2
		shift = mapShifts.get(shifts[1].id);
		system.assertEquals(0, shift.sirenum__Shift_Breaks__r.size());

		//Shift 3
		shift = mapShifts.get(shifts[2].id);
		system.assertEquals(1, shift.sirenum__Shift_Breaks__r.size());

		//Shift 4
		shift = mapShifts.get(shifts[3].id);
		system.assertEquals(1, shift.sirenum__Shift_Breaks__r.size());

		//Shift 5
		shift = mapShifts.get(shifts[4].id);
		system.assertEquals(4, shift.sirenum__Shift_Breaks__r.size());

		//Update Shifts with new End Time (2 hours)
		for (sirenum__Shift__c s : shifts) {
			s.sirenum__Billable_End_Time__c = dtE2;
		}
		update shifts;

		//Check results
		mapShifts = new Map<Id, sirenum__Shift__c>(
					[SELECT Id, (SELECT Id FROM sirenum__Shift_Breaks__r)
					 FROM sirenum__Shift__c
					 WHERE Id IN :shifts]);

		//Check the break times
		system.assertEquals(1, mapShifts.get(shifts[0].id).sirenum__Shift_Breaks__r.size());
		system.assertEquals(0, mapShifts.get(shifts[1].id).sirenum__Shift_Breaks__r.size());
		system.assertEquals(0, mapShifts.get(shifts[2].id).sirenum__Shift_Breaks__r.size());
		system.assertEquals(0, mapShifts.get(shifts[3].id).sirenum__Shift_Breaks__r.size());
		system.assertEquals(1, mapShifts.get(shifts[4].id).sirenum__Shift_Breaks__r.size());
	}

	static testmethod void testBreaksLargeInsert() {
		List<Account> clients = TestDataFactory.createClients(1);
		insert clients;

		List<sirenum__Site__c> sites = TestDataFactory.createSites(clients[0].id, null, 1);
		insert sites;
		sirenum__Site__c site = sites[0];

		List<sirenum__ProActiveContract__c> contracts = TestDataFactory.sirenumProActiveContract(clients[0].id, null, 1);
		insert contracts;

		List<sirenum__Rota__c> sectors = TestDataFactory.createSector(1);
		insert sectors;

		List<sirenum__Job_Type__c> jobTypes = TestDataFactory.createJobType(sectors[0].id, 1);
		insert jobTypes;

		List<sirenum__Team__c> jobRoles = TestDataFactory.createJobRole(contracts[0].id, jobTypes[0].id, 1);
		insert jobRoles;
		sirenum__Team__c jobRole = jobRoles[0];

		sirenum__Break_definition__c[] breakDefs = new sirenum__Break_definition__c[] {
				new sirenum__Break_definition__c(Name='Over 2 hours', sirenum__Minimum_shift_length__c = 2, sirenum__Site__c = site.id, sirenum__Team__c = jobRole.id, sirenum__Break_length__c = 15, sirenum__HoursAfterStart__c=1),
				new sirenum__Break_definition__c(Name='Over 4 hours', sirenum__Minimum_shift_length__c = 4, sirenum__Site__c = site.id, sirenum__Team__c = jobRole.id, sirenum__Break_length__c = 30, sirenum__HoursAfterStart__c=1),
				new sirenum__Break_definition__c(Name='TEAM ONLY Over 6 hours', sirenum__Minimum_shift_length__c = 6, sirenum__Team__c = jobRole.id, sirenum__Break_length__c = 60, sirenum__HoursAfterStart__c=1),
				new sirenum__Break_definition__c(Name='SITE ONLY Over 6 hours', sirenum__Minimum_shift_length__c = 6, sirenum__Site__c = site.id, sirenum__Break_length__c = 75, sirenum__HoursAfterStart__c=1)
		};
		insert breakDefs;

		DateTime dtS  = DateTime.newInstance(Date.newInstance(2018,1,1), Time.newInstance(10,0,0,0));
		DateTime dtE8 = DateTime.newInstance(Date.newInstance(2018,1,1), Time.newInstance(18,0,0,0)); //8 Hours

		//The scheduled start times are to try and confuse the system - we should be using the billables
		List<sirenum__Shift__c> shifts = new List<sirenum__Shift__c>();
		for (Integer i=0;i < 45;i++) {
			shifts.add(
				new sirenum__Shift__c(sirenum__Actual_Start_Time__c = dtS,
						sirenum__Billable_Start_Time__c = dtS, sirenum__Billable_End_Time__c = dtE8,
						sirenum__Site__c = site.id, sirenum__Team__c = jobRole.id)); //8 hour shift on site and team
		}

		Test.startTest();
		insert shifts;
		Test.stopTest();

		//Load the shifts with their new break data
		shifts = [SELECT Id, (SELECT sirenum__Duration__c FROM sirenum__Shift_Breaks__r ORDER BY sirenum__Duration__c) FROM sirenum__Shift__c];

		//Check the break times
		for (sirenum__Shift__c s : shifts) {
			system.assertEquals(4, s.sirenum__Shift_Breaks__r.size());
			system.assertEquals(0.25, s.sirenum__Shift_Breaks__r[0].sirenum__Duration__c);
			system.assertEquals(0.5, s.sirenum__Shift_Breaks__r[1].sirenum__Duration__c);
			system.assertEquals(1, s.sirenum__Shift_Breaks__r[2].sirenum__Duration__c);
			system.assertEquals(1.25, s.sirenum__Shift_Breaks__r[3].sirenum__Duration__c);
		}
	}
}