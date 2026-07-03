@isTest
public class DrivingWeekController_Test {
    private static Date startDate = system.today().toStartOfWeek().addDays(-9);
    private static List<Reference_Period__c> periods;
    private static List<Contact> drivers;
    private static List<sirenum__Team__c> jobRoles;
    private static sirenum__Request_Type__c requestType;
    private static sirenum__Site__c site;
    private static sirenum__ProActiveContract__c contr;
    private static List<Id> timesheetIds;

    @testSetup static void setupData() {
        Driving_Settings__c settings = Driving_Settings__c.getOrgDefaults();
        settings.Weeks_to_View__c = 26;
        settings.Editable_Driving_Weeks__c = 2;
        settings.Disable_Break_Trigger__c = false;
        settings.Disable_Request_Trigger__c = false;
        settings.Disable_Week_Generation__c = false;

        upsert settings;
    }

    static void createTestData() {
        periods  = new List<Reference_Period__c>();
        drivers  = new List<Contact>();
        jobRoles = new List<sirenum__Team__c>();

        //Create reference periods
        periods.add(new Reference_Period__c(Name = 'Period 1', Start_Date__c = startDate, Allowed_Hours__c = 100));
        periods.add(new Reference_Period__c(Name = 'Period 2', Start_Date__c = startDate.addDays(26 * 7), Allowed_Hours__c = 100)); //Add 26 weeks for the second period
        insert periods;

        //Reload periods to get the end dates
        periods = [SELECT Id, Name, Start_Date__c, End_Date__c, Allowed_Hours__c FROM Reference_Period__c ORDER BY Start_Date__c];

        //Create client
        Account acc = new Account(Name = 'Test Client');
        insert acc;

        //Create contract
        contr = new sirenum__ProActiveContract__c(Name = 'Test Contract', sirenum__Client__c = acc.id);
        insert contr;

        sirenum__Rota__c sector = new sirenum__Rota__c(Name = 'Test Sector');
        insert sector;

        //Create job type
        sirenum__Job_Type__c jobType = new sirenum__Job_Type__c(Name='Driving', Driving_Applicable__c = true, Impellam_Sector__c = sector.id, Impellam_Core_Category__c = 'LGV Driving -LGV', Impellam_Job_Category__c = 'Driver -DA103');
        insert jobType;

        IP_TopazGlobalClientInformation__c tgci = new IP_TopazGlobalClientInformation__c(Name='Test', IP_StatusID__c = 1);
        insert tgci;

        site = new sirenum__Site__c(Name                          = 'Test Site', 
                                    sirenum__Operating_Company__c = acc.Id,
                                    GlobalClientName__c           = tgci.id, 
                                    IP_PublicSector__c            = 'No',
                                    IP_ClientIDLegacy__c          = '0987654321',
                                    IP_ClientInvoiceName__c       = 'Test Invoice Name',
                                    IP_InvoiceAddressStreet__c    = 'Test Street',
                                    IP_InvoiceAddressCity__c      = 'Test City',
                                    IP_InvoiceAddressPostcode__c  = 'AB12 3CD');

		insert site;

        //Create job roles
        for (Integer i=1;i <= 2;i++) {
            jobRoles.add(new sirenum__Team__c(Name='Test Team ' + i, 
                                              sirenum__Account__c = contr.id, 
                                              sirenum__Job_Type__c = jobType.id, 
                                              IP_OPWIPSRole__c = 'No',
                                              sirenum__Team_PO__c = 'PO123'));
        }
        insert jobRoles;

        //Create a time off request type
        requestType = new sirenum__Request_Type__c(Name='Unavailable', Driving_Applicable__c = true, sirenum__Available__c = false);
        insert requestType;

        //Create drivers
        for (Integer i = 1; i <= 3; i++) {
            drivers.add(new Contact(firstName = 'Drivy ' + i, lastName = 'McDriverFace', email = 'test@test.com', AccountId = acc.id)); //, RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId()));
        }
        insert drivers;
    }

    static Set<Id> createWorkData(Integer week) {
        //Simulate timesheet creation for every driver
        Date dt = startDate.addDays((week * 7) - 1);

        //Create timesheet records
        List<sirenum__Timesheet__c> timesheets = new List<sirenum__Timesheet__c>();
        for (Integer i=0;i<drivers.size();i++) {
            for (Integer j=0;j<jobRoles.size();j++) {
                //Create timesheets for driver
                timesheets.add(new sirenum__Timesheet__c(sirenum__Worker__c = drivers[i].id, sirenum__Week_Ending__c = dt, sirenum__Team__c = jobRoles[j].id));
            }
        }
        insert timesheets;

        //Create shifts for the timesheets
        List<sirenum__Shift__c> shifts = new List<sirenum__Shift__c>();
        for (Integer i=0;i < timesheets.size();i++) {
            timesheetIds.add(timesheets[i].id);
            shifts.add(new sirenum__Shift__c(sirenum__Contact__c = timesheets[i].sirenum__Worker__c,
                                             sirenum__Timesheet_summaries__c = timesheets[i].id,
                                             sirenum__Scheduled_Start_Time__c = DateTime.newInstance(startDate, Time.newInstance(12, 0, 0, 0)),
                                             sirenum__Scheduled_End_Time__c = DateTime.newInstance(startDate, Time.newInstance(22, 0, 0, 0)),
                                             sirenum__Team__c = timesheets[i].sirenum__Team__c,
                                             sirenum__Site__c = site.id));
        }
        insert shifts;

        //Create shift breaks for the shifts
        List<sirenum__Shift_Break__c> breaks = new List<sirenum__Shift_Break__c>();
        for (Integer i=0;i < shifts.size();i++) {
            //Create a one-hour break for every shift
            breaks.add(new sirenum__Shift_Break__c(sirenum__Shift__c = shifts[i].id, sirenum__Paid_Break__c = true, sirenum__Start_Time__c = shifts[i].sirenum__Scheduled_Start_Time__c.addHours(1), sirenum__End_Time__c = shifts[i].sirenum__Scheduled_Start_Time__c.addHours(2)));

            //Also add an unpaid break, which shouldn't count whatsoever
            breaks.add(new sirenum__Shift_Break__c(sirenum__Shift__c = shifts[i].id, sirenum__Paid_Break__c = false, sirenum__Start_Time__c = shifts[i].sirenum__Scheduled_Start_Time__c.addHours(1), sirenum__End_Time__c = shifts[i].sirenum__Scheduled_Start_Time__c.addHours(2)));

        }
        insert breaks;

        //Create unavailability requests
        List<sirenum__Employee_Request__c> requests = new List<sirenum__Employee_Request__c>();
        for (Contact d : drivers) {
            requests.add(new sirenum__Employee_Request__c(sirenum__Contact__c = d.id, sirenum__Date__c = startDate.addDays(1), sirenum__Type__c = requestType.Name, sirenum__Start_Time__c = DateTime.newInstance(startDate.addDays(1), Time.newInstance(8,0,0,0)), sirenum__End_Time__c = DateTime.newInstance(startDate.addDays(1), Time.newInstance(10,0,0,0)), sirenum__Availability__c = false));
        }
        insert requests;

        // Create placements
        List<sirenum__Placement__c> placements = new List<sirenum__Placement__c>();
        for (Integer i=0;i < timesheets.size();i++) {
            placements.add(new sirenum__Placement__c(Name='Placement ' + i,
                                                     sirenum__site__c = site.Id,
                                                     sirenum__Contract__c = contr.Id,
                                                     sirenum__Contact__c = timesheets[i].sirenum__Worker__c,
                                                     sirenum__Job_Role__c = timesheets[i].sirenum__Team__c,
                                                     sirenum__Start_Date__c = Date.newInstance(startDate.year(), startDate.month(), startDate.day()),
                                                     IP_PurchaseOrderNumber__c = 'PO 1',
                                                     IP_Consultant1LookupSplitShare__c = UserInfo.getUserId()));
        }
        insert placements;
        
        for (Integer i=0;i < timesheets.size();i++) {
            shifts[i].sirenum__Placement__c = placements[i].Id;
        }
        update shifts;
        
        List<Sirenum__Shift__c> placement_shifts = [SELECT sirenum__Placement__c,
                                                           sirenum__Placement__r.Name, 
                                                           sirenum__Placement__r.IP_Consultant1LookupSplitShare__c,
                                                           sirenum__Placement__r.IP_Consultant1IDnumberSplitShare__c
                                                    FROM   sirenum__Shift__c];

        for (sirenum__Shift__c shift : placement_shifts) {
            system.debug('Shift Placement ' + shift.sirenum__Placement__c);           
            system.debug('Shift Placement Name ' + shift.sirenum__Placement__r.Name);
            system.debug('Consultant ' + shift.sirenum__Placement__r.IP_Consultant1LookupSplitShare__c);
            system.debug('Consultant 1 Id ' + shift.sirenum__Placement__r.IP_Consultant1IDnumberSplitShare__c);
        }

        //Create timesheet lines
        List<sirenum__Timesheet_Line__c> lines = new List<sirenum__Timesheet_Line__c>();
        for (Integer i=0;i < timesheets.size();i++) {
            for (Integer l=0;l < 5;l++) {
                lines.add(new sirenum__Timesheet_Line__c(sirenum__Timesheet__c = timesheets[i].id,
                                                         sirenum__Hours__c = 1,
                                                         sirenum__Shift__c = shifts[i].id,
                                                         sirenum__Date__c = shifts[i].sirenum__Scheduled_Start_Time__c.date(),
                                                         sirenum__Rate__c = 10,
                                                         sirenum__Charge__c = 20,
                                                         sirenum__Code__c = 'T1',
                                                         IP_PassToTempest__c = false,
                                                         For_BatchClass__c = true,
                                                         IP_RateCodes__c = 'Standard Hours /P1'));
            }
        }
        insert lines;

        //The insertion of the lines will not trigger the creation of Reference Weeks and Reference Jobs in a test, since queueable
        //chaining is not allowed. Therefore, we have to call it manually.

        Set<Id> lineIds = new Set<Id>();
        for (sirenum__Timesheet_Line__c l : lines) {
            lineIds.add(l.id);
        }

        return lineIds;
    }

    static void debugWeeks() {
        List<Reference_Period_Week__c> weeks = [SELECT Contact__r.Name, Reference_Period__r.Name, Start_Date__c,
        (SELECT Id FROM Reference_Period_Jobs__r)
        FROM Reference_Period_Week__c ORDER BY Contact__r.Name, Start_Date__c];
        String strDebug = '';
        for (Reference_Period_Week__c w : weeks) {
            strDebug += w.Contact__r.Name + ' - ' + w.Reference_Period__r.Name + ' - ' + w.Start_Date__c.format() + ' = ' + w.Reference_Period_Jobs__r.size() + '\r\n';
        }

        throw new StringException(strDebug);
    }

    static testmethod void testTimesheetWeekCreation() {
        timesheetIds = new List<Id>();
        startDate = system.today().toStartOfWeek().addDays(-9);
        createTestData();

        Set<Id> lineIds = createWorkData(1); //Week end of the first week

        Test.startTest();
        System.enqueueJob(new DrivingData_Generator(lineIds));
        Test.stopTest();

        //Query for weeks and jobs
        List<Reference_Period_Week__c> weeks = [SELECT Id, Contact__c, Duty_Hours__c, Breaks__c, Start_Date__c, Manually_Saved__c, Total_Hours__c,
                Unavailable_Hours__c,
        (SELECT Id, Break__c, Timesheet__c, Job_Role__c, Duty_Hours__c FROM Reference_Period_Jobs__r)
        FROM Reference_Period_Week__c
        ORDER BY Contact__r.FirstName, Start_Date__c];

        //Verify weeks have been created for all drivers
        system.assertEquals(drivers.size(), weeks.size());
        for (Integer i=0;i< weeks.size();i++) {
            system.assertEquals(drivers[i].id, weeks[i].Contact__c);
            system.assertEquals(startDate, weeks[i].Start_Date__c);
            system.assertEquals(false, weeks[i].Manually_Saved__c);
            system.assertEquals((5 * jobRoles.size() + 2 - (1 * jobRoles.size())), weeks[i].Total_Hours__c); //Work Hours + Unavailable Hours - Break Hours
            system.assertEquals(5 * jobRoles.size(), weeks[i].Duty_Hours__c);
            system.assertEquals(jobRoles.size(), weeks[i].Breaks__c); //1 hour break per shift, 1 shift per job role
            system.assertEquals(2, weeks[i].Unavailable_Hours__c);

            system.assertEquals(jobRoles.size(), weeks[i].Reference_Period_Jobs__r.size());
        }
    }

    static testmethod void testSirenumPlugin() {
        timesheetIds = new List<Id>();
        startDate = system.today().toStartOfWeek().addDays(-9);
        createTestData();

        Set<Id> lineIds = createWorkData(1); //Week end of the first week

        Test.startTest();
        SirenumPlugin_Payroll plugin = new SirenumPlugin_Payroll();
        plugin.timesheetIds = timesheetIds;
        plugin.handleevent(null);
        Test.stopTest();

        //Query for weeks and jobs
        List<Reference_Period_Week__c> weeks = [SELECT Id, Contact__c, Duty_Hours__c, Breaks__c, Start_Date__c, Manually_Saved__c, Total_Hours__c,
                Unavailable_Hours__c,
        (SELECT Id, Break__c, Timesheet__c, Job_Role__c, Duty_Hours__c FROM Reference_Period_Jobs__r)
        FROM Reference_Period_Week__c
        ORDER BY Contact__r.FirstName, Start_Date__c];

        //Verify weeks have been created for all drivers
        system.assertEquals(drivers.size(), weeks.size());
        for (Integer i=0;i< weeks.size();i++) {
            system.assertEquals(drivers[i].id, weeks[i].Contact__c);
            system.assertEquals(startDate, weeks[i].Start_Date__c);
            system.assertEquals(false, weeks[i].Manually_Saved__c);
            system.assertEquals((5 * jobRoles.size() + 2 - (1 * jobRoles.size())), weeks[i].Total_Hours__c); //Work Hours + Unavailable Hours - Break Hours
            system.assertEquals(5 * jobRoles.size(), weeks[i].Duty_Hours__c);
            system.assertEquals(jobRoles.size(), weeks[i].Breaks__c); //1 hour break per shift, 1 shift per job role
            system.assertEquals(2, weeks[i].Unavailable_Hours__c);

            system.assertEquals(jobRoles.size(), weeks[i].Reference_Period_Jobs__r.size());
        }
    }

    static testmethod void testTimesheetMissingWeekCreation() {
        timesheetIds = new List<Id>();
        startDate = system.today().toStartOfWeek().addDays(-9);
        createTestData();

        //Create existing weeks per driver
        List<Reference_Period_Week__c> weeks = new List<Reference_Period_Week__c>();
        for (Contact d : drivers) {
            weeks.add(new Reference_Period_Week__c(Contact__c = d.id, Reference_Period__c = periods[0].id, Start_Date__c = startDate));
        }
        insert weeks;

        Set<Id> lineIds = createWorkData(3); //Week end of the third week

        Test.startTest();
        Database.executeBatch(new DrivingDataGenerator_Batch(timesheetIds));
        Test.stopTest();

        //Query for weeks and jobs
        weeks = [SELECT Id, Contact__c, Duty_Hours__c, Breaks__c, Start_Date__c, Manually_Saved__c, Total_Hours__c,
                Unavailable_Hours__c, Contact__r.Name, Reference_Period__r.Name,
        (SELECT Id, Break__c, Timesheet__c, Job_Role__c, Duty_Hours__c FROM Reference_Period_Jobs__r)
        FROM Reference_Period_Week__c
        ORDER BY Contact__r.FirstName, Start_Date__c];

        //Verify weeks have been created for all drivers
        system.assertEquals(drivers.size() * 3, weeks.size()); //We should have 3 (not 2) weeks in the system per driver

        //Validate the weeks have been correctly assigned per driver
        Integer index=0;
        Date dt;
        for (Integer i=0;i < drivers.size();i++) {
            dt = startDate;
            for (Integer j=0;j < 3;j++) {
                system.assertEquals(dt, weeks[index].Start_Date__c);
                system.assertEquals(drivers[i].id, weeks[index].Contact__c);
                dt = dt.addDays(7);
                index++;
            }
        }
    }

    static testmethod void testController() {
        timesheetIds = new List<Id>();
        startDate = system.today().toStartOfWeek().addDays(-198);
        createTestData();

        Set<Id> lineIds = createWorkData(26); //Week end of the last week of period 1
        lineIds.addAll(createWorkData(27)); //Week end of the first week of period 2
        lineIds.addAll(createWorkData(28)); //Week end of the second week of period 2

        Test.startTest();
        System.enqueueJob(new DrivingData_Generator(lineIds));
        Test.stopTest();

        //Create controller
        DrivingWeekController controller = new DrivingWeekController();

        //Load driver 1
        controller.wFilter.Contact__c = drivers[0].id;
        controller.loadDriver();

        //Verify three weeks of data
        system.assertEquals(2, controller.periods.size());

        String strDebug = '';
        for (Integer i=0;i<controller.periods.size();i++) {
            for (Integer j = 0;j < controller.periods[i].weeks.size();j++) {
                for (Integer x = 0;x < controller.periods[i].weeks[j].Reference_Period_Jobs__r.size();x++) {
                    strDebug += 'P' + i + ' W' + j + ' > ' + controller.periods[i].weeks[j].Reference_Period_Jobs__r[x].Job_Role__r.Name + '\r\n';
                }
            }
        }

        //Verify 2 jobs exist on each of the weeks we created data for
        system.assertEquals(2, controller.periods[0].weeks[0].Reference_Period_Jobs__r.size()); //Period 2 - week 2
        system.assertEquals(2, controller.periods[0].weeks[1].Reference_Period_Jobs__r.size()); //Period 2 - week 1
        system.assertEquals(2, controller.periods[1].weeks[0].Reference_Period_Jobs__r.size()); //Period 1 - week 26

        //Save some stuff
        controller.periods[0].weeks[0].Reference_Period_Jobs__r[0].Duty_Hours__c = 50;
        controller.periods[0].weeks[0].Reference_Period_Jobs__r[0].Break__c = 2.5;
        controller.periods[0].weeks[0].Reference_Period_Jobs__r[0].Period_of_Availability__c = 4;
        controller.periods[0].weeks[0].Unavailable_Hours__c = 16.5;
        controller.periods[0].weeks[0].Other_Hours__c = 15;

        //These changes should not be saved, because the maximum weeks to edit is 2 and this is 3 weeks old
        controller.periods[1].weeks[0].Reference_Period_Jobs__r[0].Duty_Hours__c = 50;
        controller.periods[1].weeks[0].Reference_Period_Jobs__r[0].Break__c = 2.5;
        controller.periods[1].weeks[0].Reference_Period_Jobs__r[0].Period_of_Availability__c = 4;
        controller.periods[1].weeks[0].Unavailable_Hours__c = 16.5;
        controller.periods[1].weeks[0].Other_Hours__c = 15;

        controller.doSave();

        //Verify changes were saved
        system.assertEquals(50,    controller.periods[0].weeks[0].Reference_Period_Jobs__r[0].Duty_Hours__c); //Verify saved
        system.assertEquals(2.5,   controller.periods[0].weeks[0].Reference_Period_Jobs__r[0].Break__c);
        system.assertEquals(4,     controller.periods[0].weeks[0].Reference_Period_Jobs__r[0].Period_of_Availability__c);
        system.assertEquals(16.5,  controller.periods[0].weeks[0].Unavailable_Hours__c);
        system.assertEquals(15,    controller.periods[0].weeks[0].Other_Hours__c);
        system.assertNotEquals(15, controller.periods[1].weeks[0].Other_Hours__c); //Verify not saved
    }

    static testmethod void testTimesheetDeletion() {
        timesheetIds = new List<Id>();
        startDate = system.today().toStartOfWeek().addDays(-9);
        createTestData();

        Set<Id> lineIds = createWorkData(1); //Week end of the first week

        Test.startTest();
        System.enqueueJob(new DrivingData_Generator(lineIds));
        Test.stopTest();
        
        //Query for jobs and verify there's one for every timesheet
        List<Reference_Period_Job__c> jobs = [SELECT Id, Timesheet__c FROM Reference_Period_Job__c WHERE Timesheet__c IN :timesheetIds];
        system.assertEquals(6, timesheetIds.size());

        system.assertEquals(timesheetIds.size(), jobs.size());

        //Now delete the timesheets - jobs should be deleted as well
        delete [SELECT Id FROM sirenum__Timesheet__c WHERE Id IN : timesheetIds];
        system.assertEquals(0, [SELECT Id FROM Reference_Period_Job__c WHERE Id IN :jobs].size());
    }
}