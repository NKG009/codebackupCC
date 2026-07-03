/**
* Date: Thursday, 05th August 2021
* Author: Jyothi Hale
* Test Class For Apex Classes: AddScheduleTaskToGenerateTimesheet, IdentifyShiftForPayrollProcessing.
*/
@IsTest
private class AddScheduleTaskToGenerateTimesheetTest {
    @testSetup
    static void createTestData() {
        // Inserting test accounts.
        Account candidateAccount = TestDataFactory.createCandidateAccount(1)[0];
        Account clientAccount = TestDataFactory.createAccounts(1)[0];
        insert new List<Account>{ candidateAccount, clientAccount };

        TestDataFactory.setupCustomSettings(candidateAccount.Id);
        TestDataFactory.setupUserProfileCustomSettings();

		// Inserting test user.
        User consultantUser = TestDataFactory.createUsers(User_Profile_Id__c.getValues('System Administrator').Profile_Id__c, 1)[0];
        consultantUser.IP_TempestDepartment__c = '1107';
        insert consultantUser;

        // Inserting test candidate contacts.
        List<Contact> candidates = TestDataFactory.createCandidate(candidateAccount.Id, 4);

        Contact candiSat2Fri = candidates[0];
        candiSat2Fri.FirstName = 'Saturday';
        candiSat2Fri.LastName = 'Friday Candidate';

        Contact candiSun2Sat = candidates[1];
        candiSun2Sat.FirstName = 'Sunday';
        candiSun2Sat.LastName = 'Saturday Candidate';

        Contact candiMon2Sun = candidates[2];
        candiMon2Sun.FirstName = 'Monday';
        candiMon2Sun.LastName = 'Sunday Candidate';

        Contact candiMixed = candidates[3];

		// Inserting test client contact.
        Contact invoiceContact = TestDataFactory.createContact(clientAccount.Id, 1)[0];
        invoiceContact.IP_ContactType__c = 'Invoice Contact';

        insert new List<Contact>{ candiSat2Fri, candiSun2Sat, candiMon2Sun, candiMixed, invoiceContact };

		// Inserting test topaz global client information.
        IP_TopazGlobalClientInformation__c topzClientInfo = TestDataFactory.createTopaz(1)[0];
        topzClientInfo.Name = clientAccount.Name;
        topzClientInfo.IP_SalesLedgerNumber__c = '345432';
        insert topzClientInfo;

        // Inserting test sector.
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0];
        insert sector;

		// Inserting test sites.
        List<sirenum__Site__c> siteList = TestDataFactory.createSites(clientAccount.Id, topzClientInfo.Id, 3);

        sirenum__Site__c siteSF = siteList[0];
        siteSF.Name = 'Test Site One - Saturday to Friday';
        siteSF.OwnerId = consultantUser.Id;
        siteSF.Process_TS_Line_Automatically__c = true;

        sirenum__Site__c siteSS = siteList[1];
        siteSS.Name = 'Test Site Two - Sunday to Saturday';
        siteSS.OwnerId = consultantUser.Id;
        siteSS.Process_TS_Line_Automatically__c = true;

        sirenum__Site__c siteMS = siteList[2];
        siteMS.Name = 'Test Site Three - Monday to Sunday';
        siteMS.OwnerId = consultantUser.Id;
        siteMS.Process_TS_Line_Automatically__c = true;

        insert new List<sirenum__Site__c> { siteSF, siteSS, siteMS };

        // Inserting payroll cycles.
        Map<String, sirenum__Payroll_Cycle__c> payrollCycles = TestDataFactory.getPayrollCycles();
        insert payrollCycles.values();

		// Inserting payroll periods.
        insert new List<sirenum__Week__c> {
            new sirenum__Week__c(
                sirenum__PayrollCycle__c = payrollCycles.get('Saturday to Friday').Id,
                sirenum__Start_Date__c = Date.newInstance(2021, 7, 17),
                sirenum__Week_Ending__c = Date.newInstance(2021, 7, 23)
            ),
            new sirenum__Week__c(
                sirenum__PayrollCycle__c = payrollCycles.get('Saturday to Friday').Id,
                sirenum__Start_Date__c = Date.newInstance(2021, 7, 24),
                sirenum__Week_Ending__c = Date.newInstance(2021, 7, 30)
            ),
            new sirenum__Week__c(
                sirenum__PayrollCycle__c = payrollCycles.get('Sunday to Saturday').Id,
                sirenum__Start_Date__c = Date.newInstance(2021, 7, 18),
                sirenum__Week_Ending__c = Date.newInstance(2021, 7, 24)
            ),
            new sirenum__Week__c(
                sirenum__PayrollCycle__c = payrollCycles.get('Sunday to Saturday').Id,
                sirenum__Start_Date__c = Date.newInstance(2021, 7, 25),
                sirenum__Week_Ending__c = Date.newInstance(2021, 7, 31)
            ),
            new sirenum__Week__c(
                sirenum__PayrollCycle__c = payrollCycles.get('Monday to Sunday').Id,
                sirenum__Start_Date__c = Date.newInstance(2021, 7, 19),
                sirenum__Week_Ending__c = Date.newInstance(2021, 7, 25)
            ),
            new sirenum__Week__c(
                sirenum__PayrollCycle__c = payrollCycles.get('Monday to Sunday').Id,
                sirenum__Start_Date__c = Date.newInstance(2021, 7, 26),
                sirenum__Week_Ending__c = Date.newInstance(2021, 8, 1)
            )
		};

		// Inserting test proactive contracts.
		List<sirenum__ProActiveContract__c> contracts = TestDataFactory.sirenumProActiveContract(clientAccount.Id, invoiceContact.Id, 3);

        sirenum__ProActiveContract__c contractSatFri = contracts[0];
        contractSatFri.sirenum__PayrollCycle__c = payrollCycles.get('Saturday to Friday').Id;

        sirenum__ProActiveContract__c contractSunSat = contracts[1];
        contractSunSat.sirenum__PayrollCycle__c = payrollCycles.get('Sunday to Saturday').Id;

        sirenum__ProActiveContract__c contractMonSun = contracts[2];
        contractMonSun.sirenum__PayrollCycle__c = payrollCycles.get('Monday to Sunday').Id;

        insert contracts;

        // Inserting test job types.
        sirenum__Job_Type__c jobType = TestDataFactory.createJobType(sector.Id, 1)[0];
        insert jobType;

		// Inserting test job roles.
        sirenum__Team__c jobroleSF = TestDataFactory.createJobRole(contractSatFri.Id, jobType.Id, 1)[0];
        jobroleSF.Name = clientAccount.Name + ' - ' + site.Name + ' - Saturday to Friday';
        jobroleSF.IP_OPWIPSRole__c = 'No';
        jobroleSF.sirenum__Rota__c = sector.Id;

        sirenum__Team__c jobroleSS = TestDataFactory.createJobRole(contractSunSat.Id, jobType.Id, 1)[0];
        jobroleSS.Name = clientAccount.Name + ' - ' + site.Name + ' - Sunday to Saturday';
        jobroleSS.IP_OPWIPSRole__c = 'No';
        jobroleSS.sirenum__Rota__c = sector.Id;

        sirenum__Team__c jobroleMS = TestDataFactory.createJobRole(contractMonSun.Id, jobType.Id, 1)[0];
        jobroleMS.Name = clientAccount.Name + ' - ' + site.Name + ' - Monday to Sunday';
        jobroleMS.IP_OPWIPSRole__c = 'No';
        jobroleMS.sirenum__Rota__c = sector.Id;

        insert new List<sirenum__Team__c>{ jobroleSF, jobroleSS, jobroleMS };

		// Inserting test site links.
		Contact_Site_link__c siteLinkSF = new Contact_Site_link__c(
            Account__c = clientAccount.Id,
			IP_Contact__c = invoiceContact.Id,
			IP_PortalType__c = 'Primary Hours Approver',
			IP_Site__c = siteSF.Id
        );
        Contact_Site_link__c siteLinkSS = new Contact_Site_link__c(
            Account__c = clientAccount.Id,
			IP_Contact__c = invoiceContact.Id,
			IP_PortalType__c = 'Primary Hours Approver',
			IP_Site__c = siteSS.Id
        );
        Contact_Site_link__c siteLinkMS = new Contact_Site_link__c(
            Account__c = clientAccount.Id,
			IP_Contact__c = invoiceContact.Id,
			IP_PortalType__c = 'Primary Hours Approver',
			IP_Site__c = siteMS.Id
        );
        insert new List<Contact_Site_link__c>{ siteLinkSF, siteLinkSS, siteLinkMS };

		// Inserting test placements.
        sirenum__Placement__c satToFriPlacement = new sirenum__Placement__c(
			Name = 'Saturday to Sunday Placement',
            IP_Consultant1LookupSplitShare__c = consultantUser.Id,
            sirenum__Contact__c = candiSat2Fri.Id,
            sirenum__Site__c = siteSF.Id,
            sirenum__Job_Role__c = jobroleSF.Id,
            sirenum__Contract__c = contractSatFri.Id,
            sirenum__Status__c = 'Active',
            sirenum__Start_Date__c = Datetime.now().addDays(-60).date().toStartOfWeek(),
            IP_Consultant1PercentageSplit__c = 100
        );

        sirenum__Placement__c sunToSatPlacement = new sirenum__Placement__c(
            Name = 'Sunday to Saturday Placement',
            IP_Consultant1LookupSplitShare__c = consultantUser.Id,
            sirenum__Contact__c = candiSun2Sat.Id,
            sirenum__Site__c = siteSS.Id,
            sirenum__Job_Role__c = jobroleSS.Id,
            sirenum__Contract__c = contractSunSat.Id,
            sirenum__Status__c = 'Active',
            sirenum__Start_Date__c = Datetime.now().addDays(-60).date().toStartOfWeek(),
            IP_Consultant1PercentageSplit__c = 100
        );

        sirenum__Placement__c MontoSunPlacement = new sirenum__Placement__c(
            Name = 'Monday to Sunday Placement',
            IP_Consultant1LookupSplitShare__c = consultantUser.Id,
            sirenum__Contact__c = candiMon2Sun.Id,
            sirenum__Site__c = siteMS.Id,
            sirenum__Job_Role__c = jobroleMS.Id,
            sirenum__Contract__c = contractSunSat.Id,
            sirenum__Status__c = 'Active',
            sirenum__Start_Date__c = Datetime.now().addDays(-60).date().toStartOfWeek(),
            IP_Consultant1PercentageSplit__c = 100
        );

        insert new List<sirenum__Placement__c>{ satToFriPlacement, sunToSatPlacement, MontoSunPlacement };

		// Inserting test shifts.
        sirenum__Shift__c shiftSatFriWeekOne = TestDataFactory.getAShift(satToFriPlacement.Id, sector.Id, jobroleSF.Id, siteSF.Id, candiSat2Fri.Id, DateTime.newInstance(2021, 7, 20, 0, 0, 0));
		shiftSatFriWeekOne.sirenum__Published__c = true;
		shiftSatFriWeekOne.sirenum__Allow_pay__c = true;
		shiftSatFriWeekOne.sirenum__Allow_charge__c = true;

        sirenum__Shift__c shiftSatFriWeekTwo = TestDataFactory.getAShift(satToFriPlacement.Id, sector.Id, jobroleSF.Id, siteSF.Id, candiMixed.Id, DateTime.newInstance(2021, 7, 26, 0, 0, 0));
		shiftSatFriWeekTwo.sirenum__Published__c = true;
		shiftSatFriWeekTwo.sirenum__Allow_pay__c = true;
		shiftSatFriWeekTwo.sirenum__Allow_charge__c = true;

        sirenum__Shift__c shiftSunSatWeekOne = TestDataFactory.getAShift(sunToSatPlacement.Id, sector.Id, jobroleSS.Id, siteSS.Id, candiSun2Sat.Id, DateTime.newInstance(2021, 7, 21, 0, 0, 0));
		shiftSunSatWeekOne.sirenum__Published__c = true;
		shiftSunSatWeekOne.sirenum__Allow_pay__c = true;
		shiftSunSatWeekOne.sirenum__Allow_charge__c = true;

        sirenum__Shift__c shiftSunSatWeekTwo = TestDataFactory.getAShift(sunToSatPlacement.Id, sector.Id, jobroleSS.Id, siteSS.Id, candiMixed.Id, DateTime.newInstance(2021, 7, 28, 0, 0, 0));
		shiftSunSatWeekTwo.sirenum__Published__c = true;
		shiftSunSatWeekTwo.sirenum__Allow_pay__c = true;
		shiftSunSatWeekTwo.sirenum__Allow_charge__c = true;

        sirenum__Shift__c shiftMonSunWeekOne = TestDataFactory.getAShift(monToSunPlacement.Id, sector.Id, jobroleMS.Id, siteMS.Id, candiMon2Sun.Id, DateTime.newInstance(2021, 7, 23, 0, 0, 0));
		shiftMonSunWeekOne.sirenum__Published__c = true;
		shiftMonSunWeekOne.sirenum__Allow_pay__c = true;
		shiftMonSunWeekOne.sirenum__Allow_charge__c = true;

        sirenum__Shift__c shiftMonSunWeekTwo = TestDataFactory.getAShift(monToSunPlacement.Id, sector.Id, jobroleMS.Id, siteMS.Id, candiMixed.Id, DateTime.newInstance(2021, 7, 30, 0, 0, 0));
		shiftMonSunWeekTwo.sirenum__Published__c = true;
		shiftMonSunWeekTwo.sirenum__Allow_pay__c = true;
		shiftMonSunWeekTwo.sirenum__Allow_charge__c = true;

        insert new List<sirenum__Shift__c>{ shiftSatFriWeekOne, shiftSatFriWeekTwo, shiftSunSatWeekOne, shiftSunSatWeekTwo, shiftMonSunWeekOne, shiftMonSunWeekTwo };

		// Updating test shifts.
		shiftSatFriWeekOne.IP_ClientApproved__c = false;
        shiftSatFriWeekTwo.IP_ClientApproved__c = true;
        shiftSunSatWeekOne.IP_ClientApproved__c = true;
        shiftSunSatWeekTwo.IP_ClientApproved__c = true;
        shiftMonSunWeekOne.IP_ClientApproved__c = true;
        shiftMonSunWeekTwo.IP_ClientApproved__c = true;
        update new List<sirenum__Shift__c>{ shiftSatFriWeekOne, shiftSatFriWeekTwo, shiftSunSatWeekOne, shiftSunSatWeekTwo, shiftMonSunWeekOne, shiftMonSunWeekTwo };
	}

    @IsTest
    static void validateFunctionality() {
        Datetime today = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 ' + today.time().minute() + ' ' + today.time().hour() + ' ' + today.day() + ' ' + today.month() + ' ?';

        Test.startTest();

        String jobId = System.schedule('Scheduled Task Timesheet Generation Test', CRON_EXP, new AddScheduleTaskToGenerateTimesheet());

        Test.stopTest();

        List<sirenum__Scheduled_Task__c> theScheduledTasks = [SELECT Id FROM sirenum__Scheduled_Task__c WHERE sirenum__Task_Type__c = 'Timesheet Generation'];
        System.assert(theScheduledTasks.size() > 0, 'Error: No task was created by the job.');
    }
}