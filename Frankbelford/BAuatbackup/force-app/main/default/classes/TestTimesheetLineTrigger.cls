@isTest
public class TestTimesheetLineTrigger {
    static testMethod void TestAccount(){
        TestDataFactory.setupUserProfileCustomSettings();
        Account client = TestDataFactory.createCandidateAccount(1)[0];
        Insert client;
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=client.Id);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        
        //Contact cont = TestDataFactory.createCandidate(client.id, 1)[0];
        //Insert cont;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        Insert candidate;

        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(client.Id, candidate.Id, 1)[0];
        Insert pac;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0]; 
        Insert sector;
        
        sirenum__Job_Type__c jobType =TestDataFactory.createJobType(sector.id, 1)[0];
        Insert jobType;
        
        sirenum__Team__c jrole = TestDataFactory.createJobRole(pac.Id, jobType.Id, 1)[0]; 
        Insert jrole;
        
        Profile p = [SELECT Id,name FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.IP_tempestDepartment__c = '1062';
        usr.username = 'testdummy1@abcd.com';
        insert usr;

        System.debug('SOQL Limit:: ' + Limits.getQueries());

        Profile p1 = [SELECT Id,name FROM Profile where name='Back Office'];
        system.debug('PROFILE NAME ----------------------'+p1.Name);
        //User usr1 = TestDataFactory.createUsers(p.Id,1)[0];
        User usr1 = new User(LastName = 'himanshu',FirstName='JASON',Alias = 'jliv1',Email = 'mm1.sf@outlook.com',
                                Username = 'dummyEmail989'+'@email.com', ProfileId = p1.Id, TimeZoneSidKey = 'GMT',
                                LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',IP_TempestDepartment__c='1062',
                                IP_TempestDivision__c='NTS',Department='1062',IP_PassToTempest__c=true); 
        insert usr1;
        system.debug('PROFILE NAME ----------------------'+usr1.Profile);
        
                
        IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
        insert topaz;
        
        sirenum__Site__c site = TestDataFactory.createSites(client.id,topaz.id,1)[0];
        site.IP_PassClientAddressToTempest__c = false;
        site.IP_PassClientToTempest__c = false;
        insert site;
        
        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr.Id, 1)[0]; 
        splace.sirenum__Site__c = site.id;
        splace.IP_Consultant1LookupSplitShare__c = usr.Id;

        sirenum__Placement__c splace1 = TestDataFactory.createSPlacement1(candidate.Id, pac.Id,jrole.Id,usr1.Id, 1)[0]; 
        splace1.sirenum__Site__c = site.id;
        splace1.IP_Consultant1LookupSplitShare__c = usr.Id;
        insert new List<sirenum__Placement__c> {splace, splace1};

        sirenum__Shift__c shft = TestDataFactory.createShift(splace.Id,site.id,1)[0];
        shft.sirenum__Contact__c = candidate.Id;

        sirenum__Shift__c shft1 = TestDataFactory.createShift(splace1.Id,site.id,1)[0];
        shft1.sirenum__Contact__c = candidate.Id;
        insert new List<sirenum__Shift__c>{shft, shft1};

        
        sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        Insert sts;                  
        
        sirenum__Timesheet_Line__c stsl = TestDataFactory.createTimeSheetLine(sts.Id,shft.id,1)[0];
        stsl.IP_LastPassedToTempest__c = date.newInstance(2016, 04, 04);

        sirenum__Timesheet_Line__c stsl1 = TestDataFactory.createTimeSheetLine(sts.Id,shft1.id,1)[0];
        stsl1.IP_LastPassedToTempest__c = date.newInstance(2016, 04, 04);
        insert new List<sirenum__Timesheet_Line__c> {stsl, stsl1};

        System.debug('SOQL Limit:: ' + Limits.getQueries());

        Test.startTest();
        System.runas(usr){
           delete stsl;
        }
        Test.stopTest();
    }

    @isTest
    static void test2ndTierPayCalculation(){
        //TestDataFactory.setupUserProfileCustomSettings();
        insert new List<User_Profile_Id__c>{
            new User_Profile_Id__c(Name = 'Client Portal User', Profile_Id__c = '00e3H000000DkrQQAS'),
            new User_Profile_Id__c(Name='User Portal', Profile_Id__c='00e0Y000000QNyxQAG')
        };
        //USER RECORD - RECRUITER PROFILE Name='JS Recruiter - Hybrid'
        User_Profile_Id__c recProfile = new User_Profile_Id__c();
        recProfile.Name='JS Recruiter - Hybrid';
        recProfile.Profile_Id__c='00e0Y000000viGlQAI';
        insert recProfile;

        User_Profile_Id__c sysAdminProfile = new User_Profile_Id__c();
        sysAdminProfile.Name='System Administrator';
        sysAdminProfile.Profile_Id__c='00e0Y000000viGiQAI';
        insert sysAdminProfile;

        User consultantUser = TestDataFactory.createUsers((Id)recProfile.Profile_Id__c, 1)[0];
        consultantUser.IP_TempestDepartment__c = '1107';
        insert consultantUser;

        //CANIDDATE ACCOUNT
        Account candiAcc = TestDataFactory.createCandidateAccount(1)[0];
        //CLIENT ACCOUTN
        Double managHrFee = 0.5;
        Double managPercentFee = 5;
        Double supplierFlatFee = 0.2;
        Double supplierFeePercent = 10;
        Account clientAcc = TestDataFactory.createAccounts(1)[0];
        clientAcc.VMS_Client__c = true;
        clientAcc.Management_Fee__c=managPercentFee;
        clientAcc.Management_Fee_hr__c=managHrFee;
        clientAcc.Supplier_Flat_Fee__c=supplierFlatFee;
        clientAcc.Supplier_Percentage_Fee__c=supplierFeePercent;
        Account client2ndTier = TestDataFactory.create2ndTierSupplierAccount(1)[0];
        insert new List<Account>{candiAcc, clientAcc, client2ndTier};
        //System.debug('2nd Tier Client')

        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candiAcc.Id);
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

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
        Contact candi2ndTier = TestDataFactory.createCandidate2ndTier(client2ndTier.Id,1)[0];
        candi2ndTier.FirstName = 'Second Tier';
        candi2ndTier.LastName = 'Candidate';
        System.debug('candidates>>>> ' + candidates);

        //CLIENT CONTACT - Contact
        Contact invoiceContact = TestDataFactory.createContact(clientAcc.Id, 1)[0];
        invoiceContact.IP_ContactType__c='Invoice Contact';
        Contact invoiceCont2T = TestDataFactory.createContact(client2ndTier.Id, 1)[0];
        invoiceCont2T.IP_ContactType__c='Invoice Contact';
        insert new List<Contact>{candiSat2Fri, candiSun2Sat, candiMon2Sun, candi2ndTier, invoiceContact, invoiceCont2T};


        //TOPAZ - IP_TopazGlobalClientInformation__c
        IP_TopazGlobalClientInformation__c topzClientInfo = TestDataFactory.createTopaz(1)[0];
        topzClientInfo.Name = clientAcc.Name;
        topzClientInfo.IP_SalesLedgerNumber__c='345432';
        insert topzClientInfo;

        //SECTOR - sirenum__Rota__c
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0];
        insert sector;

        //SITE - sirenum__Site__c
        List<sirenum__Site__c> siteList = TestDataFactory.createSites(clientAcc.Id, topzClientInfo.Id, 4);
        sirenum__Site__c siteSF = siteList[0];
        siteSF.Name='Test site one - Saturday to Friday';
        siteSF.Process_TS_Line_Automatically__c=true;
        sirenum__Site__c siteSS = siteList[1];
        siteSS.Name = 'Test site two - Sunday to Saturday';
        siteSS.Process_TS_Line_Automatically__c=true;
        sirenum__Site__c siteMS = siteList[2];
        siteMS.Name = 'Test site three - Monday to Sunday';
        siteMS.Process_TS_Line_Automatically__c=true;
        sirenum__Site__c site2ndTier = siteList[3];
        site2ndTier.Name = 'Test site 4 - for second tier client';
        site2ndTier.Process_TS_Line_Automatically__c=true;
        site2ndTier.sirenum__Operating_Company__c = client2ndTier.Id;
        //insert new List<sirenum__Site__c> {siteSF, siteSS, siteMS};
        insert siteList;

        //PAYROLL CYCLES - sirenum__Payroll_Cycle__c
        Map<String, sirenum__Payroll_Cycle__c> payrollCycles = TestDataFactory.getPayrollCycles();
        insert payrollCycles.values();
        //Saturday to Friday
        //Sunday to Saturday
        //Monday to Sunday


        //CONTRACT - sirenum__ProActiveContract__c
        List<sirenum__ProActiveContract__c> contracts = TestDataFactory.sirenumProActiveContract(clientAcc.Id, invoiceContact.Id, 4);
        sirenum__ProActiveContract__c contractSatFri = contracts[0];
        contractSatFri.sirenum__PayrollCycle__c = payrollCycles.get('Saturday to Friday').Id;
        sirenum__ProActiveContract__c contractSunSat = contracts[1];
        contractSunSat.sirenum__PayrollCycle__c = payrollCycles.get('Sunday to Saturday').Id;
        sirenum__ProActiveContract__c contractMonSun = contracts[2];
        contractMonSun.sirenum__PayrollCycle__c = payrollCycles.get('Monday to Sunday').Id;
        sirenum__ProActiveContract__c contract2ndtier = contracts[3];
        contract2ndtier.sirenum__PayrollCycle__c = payrollCycles.get('Monday to Sunday').Id;
        contract2ndtier.sirenum__Client__c = client2ndTier.Id;
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

        sirenum__Team__c jobrole2ndTier = TestDataFactory.createJobRole(contractMonSun.Id, jobType.Id, 1)[0];
        jobrole2ndTier.Name = clientAcc.Name + ' - ' + site2ndTier.Name + ' - Monday to Sunday';
        jobrole2ndTier.IP_OPWIPSRole__c = 'No';
        jobrole2ndTier.sirenum__Rota__c = sector.Id;

        insert new List<sirenum__Team__c>{jobroleSF, jobroleSS, jobroleMS, jobrole2ndTier};

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
        Contact_Site_link__c siteLink2ndTier = new Contact_Site_link__c(Account__c=client2ndTier.Id
                ,IP_Contact__c =invoiceCont2T.Id
                ,IP_PortalType__c='Primary Hours Approver'
                ,IP_Site__c = site2ndTier.Id);
        insert new List<Contact_Site_link__c>{siteLinkSF, siteLinkSS, siteLinkMS, siteLink2ndTier};

        //@TODO remove placement and add Job order instead
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
        sirenum__Placement__c placement2ndTier = new sirenum__Placement__c(
                Name = 'Monday to Sunday Placement',
                IP_Consultant1LookupSplitShare__c= consultantUser.Id,
                sirenum__Contact__c = candiMon2Sun.Id,
                sirenum__Site__c= site2ndTier.Id,
                sirenum__Job_Role__c = jobrole2ndTier.Id,
                sirenum__Contract__c = contract2ndtier.Id,
                sirenum__Status__c = 'Active',
                sirenum__Start_Date__c = Datetime.now().addDays(-60).date().toStartOfWeek(),
                IP_Consultant1PercentageSplit__c=100);

        insert new List<sirenum__Placement__c>{satToFriPlacement, sunToSatPlacement, MontoSunPlacement, placement2ndTier};

        //CREATE WORK SCHEDULE sirenum__WorkSchedule__c
        List<sirenum__WorkSchedule__c> workSchedule = TestDataFactory.createWorkSchedules(clientAcc.Id, 6);
        insert workSchedule;

        //CREATE JOB ORDER sirenum__JobOrder__c
        List<sirenum__JobOrder__c> jobOrders = TestDataFactory.createJobOrders(  clientAcc.Id
                                                                                ,contractSatFri.Id
                                                                                ,jobType.Id
                                                                                ,siteSF.Id
                                                                                ,jobroleSF.Id
                                                                                ,workSchedule[0].Id
                                                                                ,6);

        sirenum__JobOrder__c jobOrderSF = jobOrders[0];
        sirenum__JobOrder__c jobOrderSF2ndTier = jobOrders[1];
        jobOrderSF2ndTier.sirenum__WorkSchedule__c = workSchedule[1].Id;
        jobOrderSF2ndTier.sirenum__Account__c = clientAcc.Id;

        sirenum__JobOrder__c jobOrderSS = jobOrders[2];
        jobOrderSS.sirenum__WorkSchedule__c = workSchedule[2].Id;
        sirenum__JobOrder__c jobOrderSS2ndTier = jobOrders[3];
        jobOrderSS2ndTier.sirenum__WorkSchedule__c = workSchedule[3].Id;
        jobOrderSS2ndTier.sirenum__Account__c = clientAcc.Id;

        sirenum__JobOrder__c jobOrderMS = jobOrders[4];
        jobOrderMS.sirenum__WorkSchedule__c = workSchedule[4].Id;
        sirenum__JobOrder__c jobOrderMS2ndTier = jobOrders[5];
        jobOrderMS2ndTier.sirenum__WorkSchedule__c = workSchedule[5].Id;
        jobOrderMS2ndTier.sirenum__Account__c = clientAcc.Id;
        insert jobOrders;

        //SHIFT - sirenum__Shift__c
        Datetime wsSatFri = Datetime.now().addMonths(-1).date().toStartOfWeek().addDays(-2);
        Datetime wsSunSat = Datetime.now().addMonths(-1).date().toStartOfWeek().addDays(-1);
        Datetime wsMonSun = Datetime.now().addMonths(-1).date().toStartOfWeek();
        sirenum__Shift__c shiftSatFri = TestDataFactory.getAShift(satToFriPlacement.Id, sector.Id, jobroleSF.Id, siteSF.Id, candiSat2Fri.Id, wsSatFri);
        shiftSatFri.sirenum__JobOrder__c = jobOrderSF.Id;
        sirenum__Shift__c shiftSunSat = TestDataFactory.getAShift(sunToSatPlacement.Id, sector.Id, jobroleSS.Id, siteSS.Id, candiSun2Sat.Id, wsSunSat);
        shiftSunSat.sirenum__JobOrder__c = jobOrderSS.Id;
        sirenum__Shift__c shiftMonSun = TestDataFactory.getAShift(monToSunPlacement.Id, sector.Id, jobroleMS.Id, siteMS.Id, candiMon2Sun.Id, wsMonSun);
        shiftMonSun.sirenum__JobOrder__c = jobOrderMS.Id;

        sirenum__Shift__c shiftSatFri2T = TestDataFactory.getAShift(satToFriPlacement.Id, sector.Id, jobroleSF.Id, siteSF.Id, candi2ndTier.Id, wsSatFri);
        shiftSatFri2T.sirenum__JobOrder__c = jobOrderSF2ndTier.Id;
        sirenum__Shift__c shiftSunSat2T = TestDataFactory.getAShift(sunToSatPlacement.Id, sector.Id, jobroleSS.Id, siteSS.Id, candi2ndTier.Id, wsSunSat);
        shiftSunSat2T.sirenum__JobOrder__c = jobOrderSS2ndTier.Id;
        sirenum__Shift__c shiftMonSun2T = TestDataFactory.getAShift(monToSunPlacement.Id, sector.Id, jobroleMS.Id, siteMS.Id, candi2ndTier.Id, wsMonSun);
        shiftMonSun2T.sirenum__JobOrder__c = jobOrderMS2ndTier.Id;
        insert new List<sirenum__Shift__c>{shiftSatFri, shiftSunSat, shiftMonSun, shiftSatFri2T, shiftSunSat2T, shiftMonSun2T};
        System.debug('shiftSatFri2T:: '+shiftSatFri2T);
        System.debug('shiftSunSat2T:: '+shiftSunSat2T);
        System.debug('shiftMonSun2T:: '+shiftMonSun2T);

        //CREATE TIMESHEET sirenum__Timesheet__c
        List<sirenum__Timesheet__c> timesheets = TestDataFactory.createTimeSheet(clientAcc.id, candiSat2Fri.Id, 6);
        sirenum__Timesheet__c tsSF = timesheets[0];
        sirenum__Timesheet__c tsSF2T = timesheets[1];
        tsSF2T.sirenum__Worker__c=candi2ndTier.Id;

        sirenum__Timesheet__c tsSS = timesheets[2];
        tsSS.sirenum__Worker__c=candiSun2Sat.Id;
        sirenum__Timesheet__c tsSS2T = timesheets[3];
        tsSS2T.sirenum__Worker__c=candi2ndTier.Id;

        sirenum__Timesheet__c tsMS = timesheets[4];
        tsMS.sirenum__Worker__c=candiMon2Sun.Id;
        sirenum__Timesheet__c tsMS2T = timesheets[5];
        tsMS2T.sirenum__Worker__c=candi2ndTier.Id;
        insert timesheets;

        //CREATE TIMESHEET LINE sirenum__Timesheet_Line__c
        List<sirenum__Timesheet_Line__c> tsLines = TestDataFactory.createTimeSheetLine(tsSF.Id, shiftSatFri.Id, 6);
        Decimal sfRate = 10;
        sirenum__Timesheet_Line__c tsLineSF = tsLines[0];
        tsLineSF.sirenum__Rate__c = sfRate;
        tsLineSF.sirenum__Hours__c = 8;
        tsLineSF.sirenum__RateType__c='Hourly';
        tsLineSF.sirenum__Charge__c=14;
        //tsLineSF.IP_RateCodes__c = 'Standard Hours /P1';

        Decimal sfRate2T = 11;
        sirenum__Timesheet_Line__c tsLineSF2T = tsLines[1];
        tsLineSF2T.sirenum__Timesheet__c=tsSF2T.Id;
        tsLineSF2T.sirenum__Shift__c = shiftSatFri2T.Id;
        tsLineSF2T.sirenum__Rate__c = sfRate2T;
        tsLineSF2T.sirenum__Hours__c = 8;
        tsLineSF2T.sirenum__RateType__c='Hourly';
        tsLineSF2T.sirenum__Charge__c=15;
        tsLineSF2T.For_BatchClass__c=true;

        Decimal ssRate = 12;
        sirenum__Timesheet_Line__c tsLineSS = tsLines[2];
        tsLineSS.sirenum__Timesheet__c=tsSS.Id;
        tsLineSS.sirenum__Shift__c = shiftSunSat.Id;
        tsLineSS.sirenum__Rate__c = ssRate;
        tsLineSS.sirenum__Hours__c = 8;
        tsLineSS.sirenum__RateType__c='Hourly';
        tsLineSS.sirenum__Charge__c=15.50;
        //tsLineSS.IP_RateCodes__c = 'Standard Hours /P1';

        Decimal ssRate2T = 12.5;
        sirenum__Timesheet_Line__c tsLineSS2T = tsLines[3];
        tsLineSS2T.sirenum__Timesheet__c=tsSS2T.Id;
        tsLineSS2T.sirenum__Shift__c = shiftSunSat2T.Id;
        tsLineSS2T.sirenum__Rate__c = ssRate2T;
        tsLineSS2T.sirenum__Hours__c = 9;
        tsLineSS2T.sirenum__RateType__c='Hourly';
        tsLineSS2T.sirenum__Charge__c=15.50;
        tsLineSS2T.For_BatchClass__c=true;

        Decimal msRate = 10.5;
        sirenum__Timesheet_Line__c tsLineMS = tsLines[4];
        tsLineMS.sirenum__Timesheet__c=tsMS.Id;
        tsLineMS.sirenum__Shift__c = shiftMonSun.Id;
        tsLineMS.sirenum__Rate__c = msRate;
        tsLineMS.sirenum__Hours__c = 9;
        tsLineMS.sirenum__RateType__c='Hourly';
        tsLineMS.sirenum__Charge__c=14.50;
        //tsLineMS.IP_RateCodes__c = 'Standard Hours /P1';

        Decimal msRate2T = 10;
        sirenum__Timesheet_Line__c tsLineMS2T = tsLines[5];
        tsLineMS2T.sirenum__Timesheet__c=tsMS2T.Id;
        tsLineMS2T.sirenum__Shift__c = shiftMonSun2T.Id;
        tsLineMS2T.sirenum__Rate__c = msRate2T;
        tsLineMS2T.sirenum__Hours__c = 10;
        tsLineMS2T.sirenum__RateType__c='Hourly';
        tsLineMS2T.sirenum__Charge__c=14.00;
        tsLineMS2T.For_BatchClass__c=true;

        System.debug('before insert tsLineSF:: '+ tsLineSF);

        Test.startTest();
        insert tsLines;

        Test.stopTest();

        System.debug('after insert tsLineSF:: '+ tsLineSF);
        System.debug('Timesheet Lines:: '+tsLines);

        Map<Id, sirenum__Timesheet_Line__c> tsLinesPost = new Map<Id, sirenum__Timesheet_Line__c>([SELECT Id, sirenum__Rate__c FROM sirenum__Timesheet_Line__c WHERE Id IN :(tsLines)]);
        System.assert(tsLinesPost.get(tsLineSF.Id).sirenum__Rate__c==sfRate, 'Sat-Fri: Pay Rate should remain same');
        System.debug('\n Actual >> ' + tsLinesPost.get(tsLineSF2T.Id).sirenum__Rate__c + '\n Expected >> ' + getCalculatedRate(sfRate2T, managHrFee, managPercentFee, supplierFlatFee,supplierFeePercent));
        System.assert(tsLinesPost.get(tsLineSF2T.Id).sirenum__Rate__c==getCalculatedRate(sfRate2T, managHrFee, managPercentFee, supplierFlatFee,supplierFeePercent), 'Sat-Fri: Pay Rate should increase');

        System.assert(tsLinesPost.get(tsLineSS.Id).sirenum__Rate__c==ssRate, 'Sun-Sat: Pay Rate should remain same');
        System.assert(tsLinesPost.get(tsLineSS2T.Id).sirenum__Rate__c==getCalculatedRate(ssRate2T, managHrFee, managPercentFee, supplierFlatFee,supplierFeePercent), 'Pay Rate should increase');

        System.assert(tsLinesPost.get(tsLineMS.Id).sirenum__Rate__c==msRate, 'Mon-Sun: Pay Rate should remain same');
        System.assert(tsLinesPost.get(tsLineMS2T.Id).sirenum__Rate__c==getCalculatedRate(msRate2T, managHrFee, managPercentFee, supplierFlatFee,supplierFeePercent), 'Pay Rate should increase');
    }

    private static Decimal getCalculatedRate(Decimal oriPay
                                            ,Double managHrFee
                                            ,Double managPercentFee
                                            ,Double supplierFlatFee
                                            ,Double supplierFeePercent){
        return oriPay*(1+supplierFeePercent/100-managPercentFee/100)+supplierFlatFee-managHrFee;
        //oriPay + (((oriPay*supplierFeePercent/100)+supplierFlatFee) - ((oriPay*managPercentFee/100)+managHrFee));
    }
}