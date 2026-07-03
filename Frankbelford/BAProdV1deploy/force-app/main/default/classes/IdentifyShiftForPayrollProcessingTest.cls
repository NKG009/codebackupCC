/**
 * Created by mrahman on 2020-08-07.
 */

@IsTest
private class IdentifyShiftForPayrollProcessingTest {

    /**
     * CANDIDATE WITH ALL APPROVED SHIFTS WHERE WEEK ENDING EARLIER THEN LAST WEEK AND FALLS WITH IN LAST 3 MONTHS
     * MINIMUM 3 CANDIDATES TO COVER ALL PAYROLL CYCLES
     * AND 1 CANDIDATE WHO HAVE 3 SHIFTS FALLS IN EACH PAYROLL CYCLE
     */
    @IsTest
    static void testCandidateWithAllApproveShifts() {
        //CANIDDATE ACCOUNT
        Account candiAcc = TestDataFactory.createCandidateAccount(1)[0];
        //CLIENT ACCOUTN
        Account clientAcc = TestDataFactory.createAccounts(1)[0];
        insert new List<Account>{candiAcc, clientAcc};

        TestDataFactory.setupCustomSettings(candiAcc.Id);
        TestDataFactory.setupUserProfileCustomSettings();

        User consultantUser = TestDataFactory.createUsers(User_Profile_Id__c.getValues('System Administrator').Profile_Id__c, 1)[0];
        consultantUser.IP_TempestDepartment__c = '1107';
        insert consultantUser;

        //CANDIDATE - Contact
        List<Contact> candidates = TestDataFactory.createCandidate(candiAcc.Id, 4);
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
        System.debug('candidates>>>> ' + candidates);

        //CLIENT CONTACT - Contact
        Contact invoiceContact = TestDataFactory.createContact(clientAcc.Id, 1)[0];
        invoiceContact.IP_ContactType__c='Invoice Contact';
        insert new List<Contact>{candiSat2Fri, candiSun2Sat, candiMon2Sun, candiMixed, invoiceContact};


        //TOPAZ - IP_TopazGlobalClientInformation__c
        IP_TopazGlobalClientInformation__c topzClientInfo = TestDataFactory.createTopaz(1)[0];
        topzClientInfo.Name = clientAcc.Name;
        topzClientInfo.IP_SalesLedgerNumber__c='345432';
        insert topzClientInfo;

        //SECTOR - sirenum__Rota__c
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0];
        insert sector;

        //SITE - sirenum__Site__c
        List<sirenum__Site__c> siteList = TestDataFactory.createSites(clientAcc.Id, topzClientInfo.Id, 3);
        sirenum__Site__c siteSF = siteList[0];
        siteSF.Name='Test site one - Saturday to Friday';
        siteSF.Process_TS_Line_Automatically__c=true;
        sirenum__Site__c siteSS = siteList[1];
        siteSS.Name = 'Test site two - Sunday to Saturday';
        siteSS.Process_TS_Line_Automatically__c=true;
        sirenum__Site__c siteMS = siteList[2];
        siteMS.Name = 'Test site three - Monday to Sunday';
        siteMS.Process_TS_Line_Automatically__c=true;
        insert new List<sirenum__Site__c> {siteSF, siteSS, siteMS};

        //PAYROLL CYCLES - sirenum__Payroll_Cycle__c
        Map<String, sirenum__Payroll_Cycle__c> payrollCycles = TestDataFactory.getPayrollCycles();
        insert payrollCycles.values();

        //CONTRACT - sirenum__ProActiveContract__c
        List<sirenum__ProActiveContract__c> contracts = TestDataFactory.sirenumProActiveContract(clientAcc.Id, invoiceContact.Id, 3);
        sirenum__ProActiveContract__c contractSatFri = contracts[0];
        contractSatFri.sirenum__PayrollCycle__c = payrollCycles.get('Saturday to Friday').Id;
        sirenum__ProActiveContract__c contractSunSat = contracts[1];
        contractSunSat.sirenum__PayrollCycle__c = payrollCycles.get('Sunday to Saturday').Id;
        sirenum__ProActiveContract__c contractMonSun = contracts[2];
        contractMonSun.sirenum__PayrollCycle__c = payrollCycles.get('Monday to Sunday').Id;
        insert contracts;


        //JOB TYPE - sirenum__Job_Type__c
        sirenum__Job_Type__c jobType = TestDataFactory.createJobType(sector.Id, 1)[0];
        insert jobType;

        //JOB ROLL - sirenum__Team__c
        sirenum__Team__c jobroleSF = TestDataFactory.createJobRole(contractSatFri.Id, jobType.Id, 1)[0];
        jobroleSF.Name = clientAcc.Name + ' - ' + site.Name + ' - Saturday to Friday';
        jobroleSF.IP_OPWIPSRole__c = 'No';
        jobroleSF.sirenum__Rota__c = sector.Id;

        sirenum__Team__c jobroleSS = TestDataFactory.createJobRole(contractSunSat.Id, jobType.Id, 1)[0];
        jobroleSS.Name = clientAcc.Name + ' - ' + site.Name + ' - Sundayd to Saturday';
        jobroleSS.IP_OPWIPSRole__c = 'No';
        jobroleSS.sirenum__Rota__c = sector.Id;

        sirenum__Team__c jobroleMS = TestDataFactory.createJobRole(contractMonSun.Id, jobType.Id, 1)[0];
        jobroleMS.Name = clientAcc.Name + ' - ' + site.Name + ' - Monday to Sunday';
        jobroleMS.IP_OPWIPSRole__c = 'No';
        jobroleMS.sirenum__Rota__c = sector.Id;

        insert new List<sirenum__Team__c>{jobroleSF, jobroleSS, jobroleMS};

        //CONTACT SITE LINK - Contact_Site_link__c   (IP_PortalType__c = 'Primary Hours Approver')
        Contact_Site_link__c siteLinkSF = new Contact_Site_link__c(Account__c=clientAcc.Id
                ,IP_Contact__c =invoiceContact.Id
                ,IP_PortalType__c='Primary Hours Approver'
                ,IP_Site__c = siteSF.Id);
        Contact_Site_link__c siteLinkSS = new Contact_Site_link__c(Account__c=clientAcc.Id
                ,IP_Contact__c =invoiceContact.Id
                ,IP_PortalType__c='Primary Hours Approver'
                ,IP_Site__c = siteSS.Id);
        Contact_Site_link__c siteLinkMS = new Contact_Site_link__c(Account__c=clientAcc.Id
                ,IP_Contact__c =invoiceContact.Id
                ,IP_PortalType__c='Primary Hours Approver'
                ,IP_Site__c = siteMS.Id);
        insert new List<Contact_Site_link__c>{siteLinkSF, siteLinkSS, siteLinkMS};

        //S-PLACEMENT - sirenum__Placement__c
        sirenum__Placement__c satToFriPlacement = new sirenum__Placement__c();
        satToFriPlacement.Name = 'Saturday to Sunday Placement';
        satToFriPlacement.IP_Consultant1LookupSplitShare__c= consultantUser.Id;
        satToFriPlacement.sirenum__Contact__c = candiSat2Fri.Id;
        satToFriPlacement.sirenum__Site__c= siteSF.Id;
        satToFriPlacement.sirenum__Job_Role__c = jobroleSF.Id;
        satToFriPlacement.sirenum__Contract__c = contractSatFri.Id;
        satToFriPlacement.sirenum__Status__c = 'Active';
        satToFriPlacement.sirenum__Start_Date__c = Datetime.now().addDays(-60).date().toStartOfWeek();
        satToFriPlacement.IP_Consultant1PercentageSplit__c=100;

        sirenum__Placement__c sunToSatPlacement = new sirenum__Placement__c(
                                                    Name = 'Sunday to Saturday Placement',
                                                    IP_Consultant1LookupSplitShare__c= consultantUser.Id,
                                                    sirenum__Contact__c = candiSun2Sat.Id,
                                                    sirenum__Site__c= siteSS.Id,
                                                    sirenum__Job_Role__c = jobroleSS.Id,
                                                    sirenum__Contract__c = contractSunSat.Id,
                                                    sirenum__Status__c = 'Active',
                                                    sirenum__Start_Date__c = Datetime.now().addDays(-60).date().toStartOfWeek(),
                                                    IP_Consultant1PercentageSplit__c=100);
        sirenum__Placement__c MontoSunPlacement = new sirenum__Placement__c(
                                                    Name = 'Monday to Sunday Placement',
                                                    IP_Consultant1LookupSplitShare__c= consultantUser.Id,
                                                    sirenum__Contact__c = candiMon2Sun.Id,
                                                    sirenum__Site__c= siteMS.Id,
                                                    sirenum__Job_Role__c = jobroleMS.Id,
                                                    sirenum__Contract__c = contractSunSat.Id,
                                                    sirenum__Status__c = 'Active',
                                                    sirenum__Start_Date__c = Datetime.now().addDays(-60).date().toStartOfWeek(),
                                                    IP_Consultant1PercentageSplit__c=100);

        insert new List<sirenum__Placement__c>{satToFriPlacement, sunToSatPlacement, MontoSunPlacement};

        //SHIFT - sirenum__Shift__c
        Datetime wsSatFri = Datetime.now().date().toStartOfWeek().addDays(-1).toStartOfWeek().addDays(-2);
        Datetime wsSunSat = Datetime.now().date().toStartOfWeek().addDays(-1).toStartOfWeek().addDays(-1);
        Datetime wsMonSun = Datetime.now().date().toStartOfWeek().addDays(-1).toStartOfWeek();
        sirenum__Shift__c shiftSatFri = TestDataFactory.getAShift(satToFriPlacement.Id, sector.Id, jobroleSF.Id, siteSF.Id, candiSat2Fri.Id, wsSatFri);
        sirenum__Shift__c shiftSunSat = TestDataFactory.getAShift(sunToSatPlacement.Id, sector.Id, jobroleSS.Id, siteSS.Id, candiSun2Sat.Id, wsSunSat);
        sirenum__Shift__c shiftMonSun = TestDataFactory.getAShift(monToSunPlacement.Id, sector.Id, jobroleMS.Id, siteMS.Id, candiMon2Sun.Id, wsMonSun);

        sirenum__Shift__c shiftSatFriMx = TestDataFactory.getAShift(satToFriPlacement.Id, sector.Id, jobroleSF.Id, siteSF.Id, candiMixed.Id, wsSatFri);
        sirenum__Shift__c shiftSunSatMx = TestDataFactory.getAShift(sunToSatPlacement.Id, sector.Id, jobroleSS.Id, siteSS.Id, candiMixed.Id, wsSunSat);
        sirenum__Shift__c shiftMonSunMx = TestDataFactory.getAShift(monToSunPlacement.Id, sector.Id, jobroleMS.Id, siteMS.Id, candiMixed.Id, wsMonSun);

        Test.startTest();
        insert new List<sirenum__Shift__c>{shiftSatFri, shiftSunSat, shiftMonSun, shiftSatFriMx, shiftSunSatMx, shiftMonSunMx};
        System.debug('shiftSatFri:: '+shiftSatFri);
        System.debug('shiftSunSat:: '+shiftSunSat);
        System.debug('shiftMonSun:: '+shiftMonSun);

        Map<String, String> configurationStr = IdentifyShiftForPayrollProcessing.getConfiguration();
        System.debug('configurationStr'+configurationStr);
        System.assert(configurationStr.size()==1);
        Test.stopTest();
    }

    /**
     * CANDIDATE WITH ALL APPROVED SHIFTS WHERE SOME SHIFTS HAS WEEK ENDING EARLIER THEN LAST WEEK AND
     * SOME SHIFT ARE FROM PAST BUT FALLS WITH IN LAST 3 MONTHS
     * MINIMUM 3 CANDIDATES TO COVER ALL PAYROLL CYCLES
     * AND 1 CANDIDATE WHO HAVE 3 SHIFTS FALLS IN EACH PAYROLL CYCLE
     * HISTORICAL SHIFT SHOULD BE EXCLUDED (OLDER THEN 3 MONTHS)
     * CURRENT WEEK'S SHIFTS SHOULD BE EXCLUDED
     */
    @IsTest
    static void testCandiWithAprvedShiftsInPastNCrntWeek() {
        //CANIDDATE ACCOUNT
        Account candiAcc = TestDataFactory.createCandidateAccount(1)[0];
        //CLIENT ACCOUTN
        Account clientAcc = TestDataFactory.createAccounts(1)[0];
        insert new List<Account>{candiAcc, clientAcc};

        TestDataFactory.setupCustomSettings(candiAcc.Id);
        TestDataFactory.setupUserProfileCustomSettings();

        User consultantUser = TestDataFactory.createUsers(User_Profile_Id__c.getValues('System Administrator').Profile_Id__c, 1)[0];
        consultantUser.IP_TempestDepartment__c = '1107';
        insert consultantUser;

        //CANDIDATE - Contact
        List<Contact> candidates = TestDataFactory.createCandidate(candiAcc.Id, 4);
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
        System.debug('candidates>>>> ' + candidates);

        //CLIENT CONTACT - Contact
        Contact invoiceContact = TestDataFactory.createContact(clientAcc.Id, 1)[0];
        invoiceContact.IP_ContactType__c='Invoice Contact';
        insert new List<Contact>{candiSat2Fri, candiSun2Sat, candiMon2Sun, candiMixed, invoiceContact};


        //TOPAZ - IP_TopazGlobalClientInformation__c
        IP_TopazGlobalClientInformation__c topzClientInfo = TestDataFactory.createTopaz(1)[0];
        topzClientInfo.Name = clientAcc.Name;
        topzClientInfo.IP_SalesLedgerNumber__c='345432';
        insert topzClientInfo;

        //SECTOR - sirenum__Rota__c
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0];
        insert sector;

        //SITE - sirenum__Site__c
        List<sirenum__Site__c> siteList = TestDataFactory.createSites(clientAcc.Id, topzClientInfo.Id, 3);
        sirenum__Site__c siteSF = siteList[0];
        siteSF.Name='Test site one - Saturday to Friday';
        siteSF.Process_TS_Line_Automatically__c=true;
        sirenum__Site__c siteSS = siteList[1];
        siteSS.Name = 'Test site two - Sunday to Saturday';
        siteSS.Process_TS_Line_Automatically__c=true;
        sirenum__Site__c siteMS = siteList[2];
        siteMS.Name = 'Test site three - Monday to Sunday';
        siteMS.Process_TS_Line_Automatically__c=true;
        insert new List<sirenum__Site__c> {siteSF, siteSS, siteMS};

        //PAYROLL CYCLES - sirenum__Payroll_Cycle__c
        Map<String, sirenum__Payroll_Cycle__c> payrollCycles = TestDataFactory.getPayrollCycles();
        insert payrollCycles.values();
        //Saturday to Friday
        //Sunday to Saturday
        //Monday to Sunday


        //CONTRACT - sirenum__ProActiveContract__c
        List<sirenum__ProActiveContract__c> contracts = TestDataFactory.sirenumProActiveContract(clientAcc.Id, invoiceContact.Id, 3);
        sirenum__ProActiveContract__c contractSatFri = contracts[0];
        contractSatFri.sirenum__PayrollCycle__c = payrollCycles.get('Saturday to Friday').Id;
        sirenum__ProActiveContract__c contractSunSat = contracts[1];
        contractSunSat.sirenum__PayrollCycle__c = payrollCycles.get('Sunday to Saturday').Id;
        sirenum__ProActiveContract__c contractMonSun = contracts[2];
        contractMonSun.sirenum__PayrollCycle__c = payrollCycles.get('Monday to Sunday').Id;
        insert contracts;


        //JOB TYPE - sirenum__Job_Type__c
        sirenum__Job_Type__c jobType = TestDataFactory.createJobType(sector.Id, 1)[0];
        insert jobType;

        //JOB ROLL - sirenum__Team__c
        sirenum__Team__c jobroleSF = TestDataFactory.createJobRole(contractSatFri.Id, jobType.Id, 1)[0];
        jobroleSF.Name = clientAcc.Name + ' - ' + siteSF.Name + ' - Saturday to Friday';
        jobroleSF.IP_OPWIPSRole__c = 'No';
        jobroleSF.sirenum__Rota__c = sector.Id;

        sirenum__Team__c jobroleSS = TestDataFactory.createJobRole(contractSunSat.Id, jobType.Id, 1)[0];
        jobroleSS.Name = clientAcc.Name + ' - ' + siteSS.Name + ' - Sundayd to Saturday';
        jobroleSS.IP_OPWIPSRole__c = 'No';
        jobroleSS.sirenum__Rota__c = sector.Id;

        sirenum__Team__c jobroleMS = TestDataFactory.createJobRole(contractMonSun.Id, jobType.Id, 1)[0];
        jobroleMS.Name = clientAcc.Name + ' - ' + siteMS.Name + ' - Monday to Sunday';
        jobroleMS.IP_OPWIPSRole__c = 'No';
        jobroleMS.sirenum__Rota__c = sector.Id;

        insert new List<sirenum__Team__c>{jobroleSF, jobroleSS, jobroleMS};

        //CONTACT SITE LINK - Contact_Site_link__c   (IP_PortalType__c = 'Primary Hours Approver')
        Contact_Site_link__c siteLinkSF = new Contact_Site_link__c(Account__c=clientAcc.Id
                ,IP_Contact__c =invoiceContact.Id
                ,IP_PortalType__c='Primary Hours Approver'
                ,IP_Site__c = siteSF.Id);
        Contact_Site_link__c siteLinkSS = new Contact_Site_link__c(Account__c=clientAcc.Id
                ,IP_Contact__c =invoiceContact.Id
                ,IP_PortalType__c='Primary Hours Approver'
                ,IP_Site__c = siteSS.Id);
        Contact_Site_link__c siteLinkMS = new Contact_Site_link__c(Account__c=clientAcc.Id
                ,IP_Contact__c =invoiceContact.Id
                ,IP_PortalType__c='Primary Hours Approver'
                ,IP_Site__c = siteMS.Id);
        insert new List<Contact_Site_link__c>{siteLinkSF, siteLinkSS, siteLinkMS};

        //S-PLACEMENT - sirenum__Placement__c
        sirenum__Placement__c satToFriPlacement = new sirenum__Placement__c();
        satToFriPlacement.Name = 'Saturday to Sunday Placement';
        satToFriPlacement.IP_Consultant1LookupSplitShare__c= consultantUser.Id;
        satToFriPlacement.sirenum__Contact__c = candiSat2Fri.Id;
        satToFriPlacement.sirenum__Site__c= siteSF.Id;
        satToFriPlacement.sirenum__Job_Role__c = jobroleSF.Id;
        satToFriPlacement.sirenum__Contract__c = contractSatFri.Id;
        satToFriPlacement.sirenum__Status__c = 'Active';
        satToFriPlacement.sirenum__Start_Date__c = Datetime.now().addDays(-60).date().toStartOfWeek();
        satToFriPlacement.IP_Consultant1PercentageSplit__c=100;

        sirenum__Placement__c sunToSatPlacement = new sirenum__Placement__c(
                Name = 'Sunday to Saturday Placement',
                IP_Consultant1LookupSplitShare__c= consultantUser.Id,
                sirenum__Contact__c = candiSun2Sat.Id,
                sirenum__Site__c= siteSS.Id,
                sirenum__Job_Role__c = jobroleSS.Id,
                sirenum__Contract__c = contractSunSat.Id,
                sirenum__Status__c = 'Active',
                sirenum__Start_Date__c = Datetime.now().addDays(-60).date().toStartOfWeek(),
                IP_Consultant1PercentageSplit__c=100);
        sirenum__Placement__c MontoSunPlacement = new sirenum__Placement__c(
                Name = 'Monday to Sunday Placement',
                IP_Consultant1LookupSplitShare__c= consultantUser.Id,
                sirenum__Contact__c = candiMon2Sun.Id,
                sirenum__Site__c= siteMS.Id,
                sirenum__Job_Role__c = jobroleMS.Id,
                sirenum__Contract__c = contractSunSat.Id,
                sirenum__Status__c = 'Active',
                sirenum__Start_Date__c = Datetime.now().addDays(-60).date().toStartOfWeek(),
                IP_Consultant1PercentageSplit__c=100);

        insert new List<sirenum__Placement__c>{satToFriPlacement, sunToSatPlacement, MontoSunPlacement};

        //SHIFT - sirenum__Shift__c
        List<sirenum__Shift__c> allShifts = new List<sirenum__Shift__c>();
        Datetime wsSatFri = Datetime.now().addMonths(-4).date().toStartOfWeek().addDays(-2); //HISTORICAL SHIFT SHOULD BE EXCULDED
        Datetime wsSunSat = Datetime.now().addMonths(-1).date().toStartOfWeek().addDays(-1);
        Datetime wsMonSun = Datetime.now().date().toStartOfWeek();                //CURRENT WEEK'S SHIFTS SHOULD BE EXCLUDED
        sirenum__Shift__c shiftSatFri = TestDataFactory.getAShift(satToFriPlacement.Id, sector.Id, jobroleSF.Id, siteSF.Id, candiSat2Fri.Id, wsSatFri);
        sirenum__Shift__c shiftSunSat = TestDataFactory.getAShift(sunToSatPlacement.Id, sector.Id, jobroleSS.Id, siteSS.Id, candiSun2Sat.Id, wsSunSat);
        sirenum__Shift__c shiftMonSun = TestDataFactory.getAShift(monToSunPlacement.Id, sector.Id, jobroleMS.Id, siteSS.Id, candiMon2Sun.Id, wsMonSun);

        sirenum__Shift__c shiftSatFriMx = TestDataFactory.getAShift(satToFriPlacement.Id, sector.Id, jobroleSF.Id, siteSF.Id, candiMixed.Id, wsSatFri);
        sirenum__Shift__c shiftSunSatMx = TestDataFactory.getAShift(sunToSatPlacement.Id, sector.Id, jobroleSS.Id, siteSS.Id, candiMixed.Id, wsSunSat);
        sirenum__Shift__c shiftMonSunMx = TestDataFactory.getAShift(monToSunPlacement.Id, sector.Id, jobroleMS.Id, siteSS.Id, candiMixed.Id, wsMonSun);
        allShifts.addAll(new List<sirenum__Shift__c>{shiftSatFri, shiftSunSat, shiftMonSun, shiftSatFriMx, shiftSunSatMx, shiftMonSunMx});
        insert allShifts;

        System.debug('shiftSatFri:: '+shiftSatFri);
        System.debug('shiftSunSat:: '+shiftSunSat);
        System.debug('shiftMonSun:: '+shiftMonSun);

        Test.startTest();
        Map<String, String> configurationStr = IdentifyShiftForPayrollProcessing.getConfiguration();
        System.debug('configurationStr'+configurationStr);
        System.assert(configurationStr.size()==0);
        Test.stopTest();
    }

    /**
     * CANDIDATE WITH SOME APPROVED SHIFTS AND UNAPPROVED SHIFTS WHERE WEEK ENDING EARLIER THEN LAST WEEK AND
     * FALLS WITH IN LAST 3 MONTHS
     * MINIMUM 3 CANDIDATES TO COVER ALL PAYROLL CYCLES
     * AND 1 CANDIDATE WHO HAVE 3 SHIFTS FALLS IN EACH PAYROLL CYCLE
     * INCOMPLETE WEEKS'S SHIFTS OF A CANDIDATE SHOULD BE REMOVED
     */
    @IsTest
    static void testCandidateWithMixedShifts() {
        //CANIDDATE ACCOUNT
        Account candiAcc = TestDataFactory.createCandidateAccount(1)[0];
        //CLIENT ACCOUTN
        Account clientAcc = TestDataFactory.createAccounts(1)[0];
        insert new List<Account>{candiAcc, clientAcc};

        TestDataFactory.setupCustomSettings(candiAcc.Id);
        TestDataFactory.setupUserProfileCustomSettings();

        User consultantUser = TestDataFactory.createUsers(User_Profile_Id__c.getValues('System Administrator').Profile_Id__c, 1)[0];
        consultantUser.IP_TempestDepartment__c = '1107';
        insert consultantUser;

        //CANDIDATE - Contact
        List<Contact> candidates = TestDataFactory.createCandidate(candiAcc.Id, 4);
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
        System.debug('candidates>>>> ' + candidates);

        //CLIENT CONTACT - Contact
        Contact invoiceContact = TestDataFactory.createContact(clientAcc.Id, 1)[0];
        invoiceContact.IP_ContactType__c='Invoice Contact';
        insert new List<Contact>{candiSat2Fri, candiSun2Sat, candiMon2Sun, candiMixed, invoiceContact};


        //TOPAZ - IP_TopazGlobalClientInformation__c
        IP_TopazGlobalClientInformation__c topzClientInfo = TestDataFactory.createTopaz(1)[0];
        topzClientInfo.Name = clientAcc.Name;
        topzClientInfo.IP_SalesLedgerNumber__c='345432';
        insert topzClientInfo;

        //SECTOR - sirenum__Rota__c
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0];
        insert sector;

        //SITE - sirenum__Site__c
        List<sirenum__Site__c> siteList = TestDataFactory.createSites(clientAcc.Id, topzClientInfo.Id, 3);
        sirenum__Site__c siteSF = siteList[0];
        siteSF.Name='Test site one - Saturday to Friday';
        siteSF.Process_TS_Line_Automatically__c=true;
        siteSF.OwnerId = consultantUser.Id;
        sirenum__Site__c siteSS = siteList[1];
        siteSS.Name = 'Test site two - Sunday to Saturday';
        siteSS.Process_TS_Line_Automatically__c=true;
        siteSS.OwnerId = consultantUser.Id;
        sirenum__Site__c siteMS = siteList[2];
        siteMS.Name = 'Test site three - Monday to Sunday';
        siteMS.Process_TS_Line_Automatically__c=true;
        siteMS.OwnerId = consultantUser.Id;
        insert new List<sirenum__Site__c> {siteSF, siteSS, siteMS};

        //PAYROLL CYCLES - sirenum__Payroll_Cycle__c
        Map<String, sirenum__Payroll_Cycle__c> payrollCycles = TestDataFactory.getPayrollCycles();
        insert payrollCycles.values();

        //CONTRACT - sirenum__ProActiveContract__c
        List<sirenum__ProActiveContract__c> contracts = TestDataFactory.sirenumProActiveContract(clientAcc.Id, invoiceContact.Id, 3);
        sirenum__ProActiveContract__c contractSatFri = contracts[0];
        contractSatFri.sirenum__PayrollCycle__c = payrollCycles.get('Saturday to Friday').Id;
        sirenum__ProActiveContract__c contractSunSat = contracts[1];
        contractSunSat.sirenum__PayrollCycle__c = payrollCycles.get('Sunday to Saturday').Id;
        sirenum__ProActiveContract__c contractMonSun = contracts[2];
        contractMonSun.sirenum__PayrollCycle__c = payrollCycles.get('Monday to Sunday').Id;
        insert contracts;

        //JOB TYPE - sirenum__Job_Type__c
        sirenum__Job_Type__c jobType = TestDataFactory.createJobType(sector.Id, 1)[0];
        insert jobType;

        //JOB ROLL - sirenum__Team__c
        sirenum__Team__c jobroleSF = TestDataFactory.createJobRole(contractSatFri.Id, jobType.Id, 1)[0];
        jobroleSF.Name = clientAcc.Name + ' - ' + siteSF.Name + ' - Saturday to Friday';
        jobroleSF.IP_OPWIPSRole__c = 'No';
        jobroleSF.sirenum__Rota__c = sector.Id;

        sirenum__Team__c jobroleSS = TestDataFactory.createJobRole(contractSunSat.Id, jobType.Id, 1)[0];
        jobroleSS.Name = clientAcc.Name + ' - ' + siteSS.Name + ' - Sundayd to Saturday';
        jobroleSS.IP_OPWIPSRole__c = 'No';
        jobroleSS.sirenum__Rota__c = sector.Id;

        sirenum__Team__c jobroleMS = TestDataFactory.createJobRole(contractMonSun.Id, jobType.Id, 1)[0];
        jobroleMS.Name = clientAcc.Name + ' - ' + siteMS.Name + ' - Monday to Sunday';
        jobroleMS.IP_OPWIPSRole__c = 'No';
        jobroleMS.sirenum__Rota__c = sector.Id;

        insert new List<sirenum__Team__c>{jobroleSF, jobroleSS, jobroleMS};

        //CONTACT SITE LINK - Contact_Site_link__c   (IP_PortalType__c = 'Primary Hours Approver')
        Contact_Site_link__c siteLinkSF = new Contact_Site_link__c(Account__c=clientAcc.Id
                ,IP_Contact__c =invoiceContact.Id
                ,IP_PortalType__c='Primary Hours Approver'
                ,IP_Site__c = siteSF.Id);
        Contact_Site_link__c siteLinkSS = new Contact_Site_link__c(Account__c=clientAcc.Id
                ,IP_Contact__c =invoiceContact.Id
                ,IP_PortalType__c='Primary Hours Approver'
                ,IP_Site__c = siteSS.Id);
        Contact_Site_link__c siteLinkMS = new Contact_Site_link__c(Account__c=clientAcc.Id
                ,IP_Contact__c =invoiceContact.Id
                ,IP_PortalType__c='Primary Hours Approver'
                ,IP_Site__c = siteMS.Id);
        insert new List<Contact_Site_link__c>{siteLinkSF, siteLinkSS, siteLinkMS};

        //S-PLACEMENT - sirenum__Placement__c
        sirenum__Placement__c satToFriPlacement = new sirenum__Placement__c();
        satToFriPlacement.Name = 'Saturday to Sunday Placement';
        satToFriPlacement.IP_Consultant1LookupSplitShare__c= consultantUser.Id;
        satToFriPlacement.sirenum__Contact__c = candiSat2Fri.Id;
        satToFriPlacement.sirenum__Site__c= siteSF.Id;
        satToFriPlacement.sirenum__Job_Role__c = jobroleSF.Id;
        satToFriPlacement.sirenum__Contract__c = contractSatFri.Id;
        satToFriPlacement.sirenum__Status__c = 'Active';
        satToFriPlacement.sirenum__Start_Date__c = Datetime.now().addDays(-60).date().toStartOfWeek();
        satToFriPlacement.IP_Consultant1PercentageSplit__c=100;

        sirenum__Placement__c sunToSatPlacement = new sirenum__Placement__c(
                Name = 'Sunday to Saturday Placement',
                IP_Consultant1LookupSplitShare__c= consultantUser.Id,
                sirenum__Contact__c = candiSun2Sat.Id,
                sirenum__Site__c= siteSS.Id,
                sirenum__Job_Role__c = jobroleSS.Id,
                sirenum__Contract__c = contractSunSat.Id,
                sirenum__Status__c = 'Active',
                sirenum__Start_Date__c = Datetime.now().addDays(-60).date().toStartOfWeek(),
                IP_Consultant1PercentageSplit__c=100);
        sirenum__Placement__c MontoSunPlacement = new sirenum__Placement__c(
                Name = 'Monday to Sunday Placement',
                IP_Consultant1LookupSplitShare__c= consultantUser.Id,
                sirenum__Contact__c = candiMon2Sun.Id,
                sirenum__Site__c= siteMS.Id,
                sirenum__Job_Role__c = jobroleMS.Id,
                sirenum__Contract__c = contractSunSat.Id,
                sirenum__Status__c = 'Active',
                sirenum__Start_Date__c = Datetime.now().addDays(-60).date().toStartOfWeek(),
                IP_Consultant1PercentageSplit__c=100);

        insert new List<sirenum__Placement__c>{satToFriPlacement, sunToSatPlacement, MontoSunPlacement};

        //SHIFT - sirenum__Shift__c
        List<sirenum__Shift__c> allShifts = new List<sirenum__Shift__c>();
        /*Datetime wsSatFri = Datetime.now().addMonths(-1).date().toStartOfWeek().addDays(-2);
        Datetime wsSunSat = Datetime.now().addMonths(-1).date().toStartOfWeek().addDays(-1);
        Datetime wsMonSun = Datetime.now().addMonths(-1).date().toStartOfWeek();*/
        Datetime wsSatFri = Datetime.now().date().toStartOfWeek().addDays(-3);
        Datetime wsSunSat = Datetime.now().date().toStartOfWeek().addDays(-2);
        Datetime wsMonSun = Datetime.now().date().toStartOfWeek().addDays(-4);
        sirenum__Shift__c shiftSatFri1 = TestDataFactory.getAShift(satToFriPlacement.Id, sector.Id, jobroleSF.Id, siteSF.Id, candiSat2Fri.Id, wsSatFri);
        sirenum__Shift__c shiftSatFri2 = TestDataFactory.getAShift(satToFriPlacement.Id, sector.Id, jobroleSF.Id, siteSF.Id, candiSat2Fri.Id, wsSatFri);
        shiftSatFri2.sirenum__Scheduled_Start_Time__c=wsSatFri.addDays(1);
        shiftSatFri2.sirenum__Scheduled_End_Time__c=wsSatFri.addDays(1).addHours(8);
        shiftSatFri2.sirenum__Actual_Start_Time__c=wsSatFri.addDays(1);
        shiftSatFri2.sirenum__Actual_End_Time__c=wsSatFri.addDays(1).addHours(8);
        shiftSatFri2.sirenum__Allow_pay__c =false;
        shiftSatFri2.sirenum__Allow_charge__c = false;
        allShifts.addAll(new List<sirenum__Shift__c>{shiftSatFri1, shiftSatFri2});

        sirenum__Shift__c shiftSunSat = TestDataFactory.getAShift(sunToSatPlacement.Id, sector.Id, jobroleSS.Id, siteSS.Id, candiSun2Sat.Id, wsSunSat);
        allShifts.add(shiftSunSat);

        Datetime wsSunSatCurrent = Datetime.now().addMonths(-1).date().toStartOfWeek().addDays(-1);
        sirenum__Shift__c shiftMonSun = TestDataFactory.getAShift(monToSunPlacement.Id, sector.Id, jobroleMS.Id, siteMS.Id, candiMon2Sun.Id, wsMonSun);
        sirenum__Shift__c shiftMonSunCurrent = TestDataFactory.getAShift(monToSunPlacement.Id, sector.Id, jobroleMS.Id, siteMS.Id, candiMon2Sun.Id, wsSunSatCurrent);
        shiftMonSunCurrent.sirenum__Scheduled_Start_Time__c=wsSunSatCurrent.addDays(1);
        shiftMonSunCurrent.sirenum__Scheduled_End_Time__c=wsSunSatCurrent.addDays(1).addHours(8);
        shiftMonSunCurrent.sirenum__Actual_Start_Time__c=wsSunSatCurrent.addDays(1);
        shiftMonSunCurrent.sirenum__Actual_End_Time__c=wsSunSatCurrent.addDays(1).addHours(8);
        shiftMonSunCurrent.sirenum__Allow_pay__c =false;
        shiftMonSunCurrent.sirenum__Allow_charge__c = false;
        allShifts.addAll(new List<sirenum__Shift__c>{shiftMonSun, shiftMonSunCurrent});

        sirenum__Shift__c shiftSatFriMx = TestDataFactory.getAShift(satToFriPlacement.Id, sector.Id, jobroleSF.Id, siteSF.Id, candiMixed.Id, wsSatFri);
        sirenum__Shift__c shiftSunSatMx = TestDataFactory.getAShift(sunToSatPlacement.Id, sector.Id, jobroleSS.Id, siteSS.Id, candiMixed.Id, wsSunSat);
        sirenum__Shift__c shiftMonSunMx = TestDataFactory.getAShift(montoSunPlacement.Id, sector.Id, jobroleMS.Id, siteMS.Id, candiMixed.Id, wsMonSun);
        allShifts.addAll(new List<sirenum__Shift__c>{shiftSatFriMx, shiftSunSatMx, shiftMonSunMx});

        Test.startTest();
        insert allShifts;
        System.debug('shiftSatFri:: '+shiftSatFri1);
        System.debug('shiftSunSat:: '+shiftSunSat);
        System.debug('shiftMonSun:: '+shiftMonSun);

        Map<String, String> configurationStr = IdentifyShiftForPayrollProcessing.getConfiguration();
        System.debug('configurationStr'+configurationStr);
        System.assert(configurationStr.size()==1);
        IdentifyShiftForPayrollProcessing.scheduleTheTask();
        Test.stopTest();
    }
}