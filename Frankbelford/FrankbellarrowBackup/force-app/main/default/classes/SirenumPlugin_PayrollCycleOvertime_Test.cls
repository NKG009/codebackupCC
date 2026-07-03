@IsTest
public class SirenumPlugin_PayrollCycleOvertime_Test {

    private static List<sirenum__Payroll_Cycle__c>     payrollCycles = new List<sirenum__Payroll_Cycle__c>();
    private static List<sirenum__ProActiveContract__c> contracts     = new List<sirenum__ProActiveContract__c>();
    private static List<sirenum__Team__c>              jobRoles      = new List<sirenum__Team__c>();
    private static List<sirenum__Shift__c>             shifts        = new List<sirenum__Shift__c>();
    
    static void createTestData() {

        // Client
        Account a = new Account(Name = 'Test Client');
        insert a;
        
        // Candidate
        Contact c = new Contact(firstName = 'Candy ', lastName = 'Date', email = 'candy@date.com', AccountId = a.id); 
        
        // Site
        IP_TopazGlobalClientInformation__c tgci = new IP_TopazGlobalClientInformation__c(Name='Test', IP_StatusID__c = 1);
        insert tgci;
        
        sirenum__Site__c site = new sirenum__Site__c(Name                          = 'Test Site', 
                                                     sirenum__Operating_Company__c = a.Id,
                                                     GlobalClientName__c           = tgci.id, 
                                                     IP_PublicSector__c            = 'No',
                                                     IP_ClientIDLegacy__c          = '0987654321',
                                                     IP_ClientInvoiceName__c       = 'Test Invoice Name',
                                                     IP_InvoiceAddressStreet__c    = 'Test Street',
                                                     IP_InvoiceAddressCity__c      = 'Test City',
                                                     IP_InvoiceAddressPostcode__c  = 'AB12 3CD');
        insert site;

        // Payroll cycles with start dates from Monday to Sunday
        for (Integer i = 0; i < 7; i++) {
          payrollCycles.add(new sirenum__Payroll_Cycle__c(Name                         = 'Payroll Cycle ' + i, 
                                                          sirenum__CyclePeriodUnits__c = 'Weeks',
                                                          sirenum__periodLength__c     = 1,
                                                          sirenum__StartingDate__c     = Date.newInstance(2018, 1, 1+i))); // 01/01/2018 = Monday
        }
        insert payrollCycles;

        // Contracts
        for (Integer i = 0; i < 7; i++) {
          contracts.add(new sirenum__ProActiveContract__c(Name                     = 'Contract ' + i, 
                                                          sirenum__Client__c       = a.Id,
                                                          sirenum__PayrollCycle__c = payrollCycles.get(i).Id));
        }
        insert contracts;

        // Sector
        sirenum__Rota__c sector = new sirenum__Rota__c(Name = 'Test Sector');
        insert sector;

        //Job type
        sirenum__Job_Type__c jobType = new sirenum__Job_Type__c(Name                      ='Test Job Type', 
                                                                Impellam_Sector__c        = sector.id,
                                                                Impellam_Core_Category__c = 'Retail -RET',
                                                                Impellam_Job_Category__c  = 'Retail Staff (Com) -OA148');
        insert jobType;

        // Job roles
        for (Integer i = 0; i < 7; i++) {
          jobRoles.add(new sirenum__Team__c(Name                 = 'Job Role ' + i, 
                                            sirenum__Account__c  = contracts.get(i).Id,
                                            sirenum__Job_Type__c = jobType.id,
                                            IP_OPWIPSRole__c     = 'No'));
        }
        insert jobRoles;
        
        // Shifts
        for (Integer jobRole = 0; jobRole < 7; jobRole++) {
            for (Integer i = 0; i < 7; i++) {
                shifts.add(new sirenum__Shift__c(sirenum__Contact__c              = c.Id,
                                                 sirenum__Team__c                 = jobRoles.get(jobRole).Id,
                                                 sirenum__Site__c                 = site.Id,
                                                 sirenum__Scheduled_Start_Time__c = Datetime.newInstance(2018, 4, 2+i, 9, 0, 0), // 02/04/2018 = Monday
                                                 sirenum__Scheduled_End_Time__c   = Datetime.newInstance(2018, 4, 2+i, 17, 0, 0),
                                                 sirenum__Billable_Start_Time__c  = Datetime.newInstance(2018, 4, 2+i, 9, 0, 0),
                                                 sirenum__Billable_End_Time__c    = Datetime.newInstance(2018, 4, 2+i, 17, 0, 0))); 
            }
        }
        insert shifts;

    }

    
    @IsTest
    static void testRequiredFields() {
        SirenumPlugin_PayrollCycleBasedOvertime overtimePlugin = new SirenumPlugin_PayrollCycleBasedOvertime();
        Set<String> requiredFieldPaths = overtimePlugin.getRequiredFieldPaths();
        system.assertEquals(6, requiredFieldPaths.size());
        system.assertEquals(true, requiredFieldPaths.contains('sirenum__Billable_Calculated_Start_Time__c'));
        system.assertEquals(true, requiredFieldPaths.contains('sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__CyclePeriodUnits__c'));
        system.assertEquals(true, requiredFieldPaths.contains('sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__periodLength__c'));
        system.assertEquals(true, requiredFieldPaths.contains('sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__StartingDate__c'));
        system.assertEquals(true, requiredFieldPaths.contains('sirenum__Team__c'));
        system.assertEquals(true, requiredFieldPaths.contains('sirenum__Site__c'));
    }

    @IsTest
    static void testGetStartOfWeekFor() {
        SirenumPlugin_PayrollCycleBasedOvertime overtimePlugin = new SirenumPlugin_PayrollCycleBasedOvertime();
        Date startOfWeek = null;
        createTestData();
        
        // Retrieve shifts with all values required by called method
        List<sirenum__Shift__c> retrievedShifts = [SELECT Id,
                                                   sirenum__Scheduled_Start_Time__c,
                                                   sirenum__Billable_Start_Time__c,
                                                   sirenum__Billable_Calculated_Start_Time__c,
                                                   sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__CyclePeriodUnits__c,
                                                   sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__periodLength__c,
                                                   sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__StartingDate__c
                                            FROM   sirenum__Shift__c
                                            WHERE  Id IN :shifts];

        for (sirenum__Shift__c shift : retrievedShifts) {

            startOfWeek = overtimePlugin.getStartOfWeekFor(shift, null);

            if (shift.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__StartingDate__c == Date.newInstance(2018, 1, 1)) { // Monday
                system.assertEquals(Date.newInstance(2018, 4, 2), startOfWeek);
            } else if (shift.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__StartingDate__c == Date.newInstance(2018, 1, 2)) { // Tuesday
                if (shift.sirenum__Billable_Calculated_Start_Time__c.date() <= Date.newInstance(2018, 4, 2)) {
                    system.assertEquals(Date.newInstance(2018, 3, 27), startOfWeek);
                } else {
                    system.assertEquals(Date.newInstance(2018, 4, 3), startOfWeek);
                }
            } else if (shift.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__StartingDate__c == Date.newInstance(2018, 1, 3)) { // Wednesday
                if (shift.sirenum__Billable_Calculated_Start_Time__c.date() <= Date.newInstance(2018, 4, 3)) {
                    system.assertEquals(Date.newInstance(2018, 3, 28), startOfWeek);
                } else {
                    system.assertEquals(Date.newInstance(2018, 4, 4), startOfWeek);
                }
            } else if (shift.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__StartingDate__c == Date.newInstance(2018, 1, 4)) { // Thursday
                if (shift.sirenum__Billable_Calculated_Start_Time__c.date() <= Date.newInstance(2018, 4, 4)) {
                    system.assertEquals(Date.newInstance(2018, 3, 29), startOfWeek);
                } else {
                    system.assertEquals(Date.newInstance(2018, 4, 5), startOfWeek);
                }
            } else if (shift.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__StartingDate__c == Date.newInstance(2018, 1, 5)) { // Friday
                if (shift.sirenum__Billable_Calculated_Start_Time__c.date() <= Date.newInstance(2018, 4, 5)) {
                    system.assertEquals(Date.newInstance(2018, 3, 30), startOfWeek);
                } else {
                    system.assertEquals(Date.newInstance(2018, 4, 6), startOfWeek);
                }
            } else if (shift.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__StartingDate__c == Date.newInstance(2018, 1, 6)) { // Saturday
                if (shift.sirenum__Billable_Calculated_Start_Time__c.date() <= Date.newInstance(2018, 4, 6)) {
                    system.assertEquals(Date.newInstance(2018, 3, 31), startOfWeek);
                } else {
                    system.assertEquals(Date.newInstance(2018, 4, 7), startOfWeek);
                }
            } else if (shift.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__StartingDate__c == Date.newInstance(2018, 1, 7)) { // Sunday
                if (shift.sirenum__Billable_Calculated_Start_Time__c.date() <= Date.newInstance(2018, 4, 7)) {
                    system.assertEquals(Date.newInstance(2018, 4, 1), startOfWeek);
                } else {
                    system.assertEquals(Date.newInstance(2018, 4, 8), startOfWeek);
                }
            }
        }
        
        // Payroll cycle != one week
        TestOvertime fallback = new TestOvertime();
        sirenum__Payroll_Cycle__c payrollCycle = payrollCycles.get(0);

        payrollCycle.sirenum__periodLength__c = 2; // Two weeks
        update payrollCycle;
        sirenum__Shift__c shift1 = [SELECT Id,
                                           sirenum__Scheduled_Start_Time__c,
                                           sirenum__Billable_Start_Time__c,
                                           sirenum__Billable_Calculated_Start_Time__c,
                                           sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__CyclePeriodUnits__c,
                                           sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__periodLength__c,
                                           sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__StartingDate__c
                                    FROM   sirenum__Shift__c
                                    WHERE  Id = :shifts.get(0).Id LIMIT 1];
        startOfWeek = overtimePlugin.getStartOfWeekFor(shift1, fallback);
        system.assertEquals(Date.newInstance(2018, 2, 3), startOfWeek);

        payrollCycle.sirenum__periodLength__c = 1; // One month
        payrollCycle.sirenum__CyclePeriodUnits__c = 'Months';
        update payrollCycle;
        sirenum__Shift__c shift2 = [SELECT Id,
                                           sirenum__Scheduled_Start_Time__c,
                                           sirenum__Billable_Start_Time__c,
                                           sirenum__Billable_Calculated_Start_Time__c,
                                           sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__CyclePeriodUnits__c,
                                           sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__periodLength__c,
                                           sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__StartingDate__c
                                    FROM   sirenum__Shift__c
                                    WHERE  Id = :shifts.get(0).Id LIMIT 1];
        startOfWeek = overtimePlugin.getStartOfWeekFor(shift2, fallback);
        system.assertEquals(Date.newInstance(2018, 2, 3), startOfWeek);

    }

    @IsTest
    static void testIsNomineeRelevantAsPastWork() {
        SirenumPlugin_PayrollCycleBasedOvertime overtimePlugin = new SirenumPlugin_PayrollCycleBasedOvertime();
        Boolean isNomineeRelevantAsPastWork;
        
        // Client
        Account a = new Account(Name = 'Test Client');
        insert a;
        
        // Candidate
        Contact c = new Contact(firstName = 'Candy ', lastName = 'Date', email = 'candy@date.com', AccountId = a.id); 
        insert c;
        
        IP_TopazGlobalClientInformation__c tgci = new IP_TopazGlobalClientInformation__c(Name='Test', IP_StatusID__c = 1);
        insert tgci;
        
        // Site 1
        sirenum__Site__c site1 = new sirenum__Site__c(Name                          = 'Test Site 1', 
                                                      sirenum__Operating_Company__c = a.Id,
                                                      GlobalClientName__c           = tgci.id, 
                                                      IP_PublicSector__c            = 'No',
                                                      IP_ClientIDLegacy__c          = '0987654321',
                                                      IP_ClientInvoiceName__c       = 'Test Invoice Name',
                                                      IP_InvoiceAddressStreet__c    = 'Test Street',
                                                      IP_InvoiceAddressCity__c      = 'Test City',
                                                      IP_InvoiceAddressPostcode__c  = 'AB12 3CD');
        insert site1;

        // Site 2
        sirenum__Site__c site2 = new sirenum__Site__c(Name                          = 'Test Site 2', 
                                                      sirenum__Operating_Company__c = a.Id,
                                                      GlobalClientName__c           = tgci.id, 
                                                      IP_PublicSector__c            = 'No',
                                                      IP_ClientIDLegacy__c          = '0987654322',
                                                      IP_ClientInvoiceName__c       = 'Test Invoice Name',
                                                      IP_InvoiceAddressStreet__c    = 'Test Street',
                                                      IP_InvoiceAddressCity__c      = 'Test City',
                                                      IP_InvoiceAddressPostcode__c  = 'AB12 3CD');
        insert site2;

        // Contract
        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c(Name                     = 'Test Contract ', 
                                                                                   sirenum__Client__c       = a.Id);
        insert contracts;

        // Sector
        sirenum__Rota__c sector = new sirenum__Rota__c(Name = 'Test Sector');
        insert sector;

        //Job types
        sirenum__Job_Type__c jobType = new sirenum__Job_Type__c(Name                      ='Test Job Type', 
                                                                Impellam_Sector__c        = sector.id,
                                                                Impellam_Core_Category__c = 'Retail -RET',
                                                                Impellam_Job_Category__c  = 'Retail Staff (Com) -OA148');
        insert jobType;
        
        // Job roles
        sirenum__Team__c jobRole1 = new sirenum__Team__c(Name                 = 'Job Role 1', 
                                                         sirenum__Account__c  = contract.Id,
                                                         sirenum__Job_Type__c = jobType.id,
                                                         IP_OPWIPSRole__c     = 'No');
        insert jobRole1;
        
        sirenum__Team__c jobRole2 = new sirenum__Team__c(Name                 = 'Job Role 2', 
                                                         sirenum__Account__c  = contract.Id,
                                                         sirenum__Job_Type__c = jobType.id,
                                                         IP_OPWIPSRole__c     = 'No');
        insert jobRole2;
        
        sirenum__Shift__c shift11 = new sirenum__Shift__c(sirenum__Contact__c              = c.Id,
                                                          sirenum__Team__c                 = jobRole1.Id,
                                                          sirenum__Site__c                 = site1.Id);
        
        sirenum__Shift__c shift12 = new sirenum__Shift__c(sirenum__Contact__c              = c.Id,
                                                          sirenum__Team__c                 = jobRole1.Id,
                                                          sirenum__Site__c                 = site2.Id);
        
        sirenum__Shift__c shift21 = new sirenum__Shift__c(sirenum__Contact__c              = c.Id,
                                                          sirenum__Team__c                 = jobRole2.Id,
                                                          sirenum__Site__c                 = site1.Id);
                
        isNomineeRelevantAsPastWork = overtimePlugin.isNomineeRelevantAsPastWork(shift11, shift11, null); // Same job role and site
        system.assertEquals(true, isNomineeRelevantAsPastWork);

        isNomineeRelevantAsPastWork = overtimePlugin.isNomineeRelevantAsPastWork(shift11, shift12, null); // Same job role, different site
        system.assertEquals(false, isNomineeRelevantAsPastWork);

        isNomineeRelevantAsPastWork = overtimePlugin.isNomineeRelevantAsPastWork(shift11, shift21, null); // Different job role, same site
        system.assertEquals(false, isNomineeRelevantAsPastWork);

        isNomineeRelevantAsPastWork = overtimePlugin.isNomineeRelevantAsPastWork(shift12, shift21, null); // Different job role and site
        system.assertEquals(false, isNomineeRelevantAsPastWork);

    }

    public class TestOvertime implements sirenum.ShiftProcessorOvertimeExtension {
        
        public TestOvertime() {
        }

        public Set<String> getRequiredFieldPaths() {
            return new Set<String>();
        }
        
        public Date getStartOfWeekFor(sirenum__Shift__c shift,
                                      sirenum.ShiftProcessorOvertimeExtension fallback) {
            return Date.newInstance(2018, 2, 3);
        }

        public Boolean isNomineeRelevantAsPastWork(sirenum__Shift__c context,
                                                   sirenum__Shift__c nominee,
                                                   sirenum.ShiftProcessorOvertimeExtension fallback) {
            return true;
        }        
    }
}