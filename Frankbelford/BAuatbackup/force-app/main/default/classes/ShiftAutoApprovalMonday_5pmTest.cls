@isTest
public class ShiftAutoApprovalMonday_5pmTest {
    @TestSetup
    static void setupTestData(){
        TestDataFactory.setupUserProfileCustomSettings();
        Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
        insert candidateAcc;
        TestDataFactory.setupCustomSettings(candidateAcc.Id);

        UserRole ur = [SELECT Id, Name, PortalAccountId, PortalRole, PortalType, LastModifiedDate
        FROM UserRole
        WHERE Name = 'Impellam IT'];
        Profile Prof = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1];
        Long gettime = Datetime.now().getTime();
        User u = new User();
        u.LastName = 'Data1';
        u.FirstName='TestUser';
        u.Alias = 'TstUrD';
        u.Email = 'abc.efg@GHI.com';
        u.Username = 'Email'+gettime+'@js.com.uk';
        u.ProfileId = Prof.id;
        u.TimeZoneSidKey = 'GMT';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LocaleSidKey = 'en_US';
        u.IP_TempestDepartment__c='2043';
        u.IP_TempestID__c='1084675';
        u.IP_TempestDivision__c='NTS';
        u.Department='1010';
        u.IP_PassToTempest__c=true;
        u.Brand__c = 'Impellam';
        u.UserRoleId=ur.Id;
        TestDataFactory.insertUser(new List<String> {JSON.serialize(u)});
    }

    static testMethod void testMethod1() {
        User u = [SELECT Id, Name, Email, Brand__c FROM User WHERE Email='abc.efg@GHI.com' AND IsActive=true ORDER BY CreatedDate DESC LIMIT 1];
        System.debug('Value in user'+ u);

        System.runAs(u) {
            insert new IP_ImpellamGDPRSettings__c (Name = 'Impellam GDPR settings', IP_ActivityTypesThatQualifyAsContact__c = 'Visit,Registration,General Call ,Send Email ,Send Contract', IP_UnworkedCandidateDataRetentionPeriod__c = -10);
            Datetime dateToday = Datetime.now();
            Account acc1 = new Account();
            RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client'];
            acc1.name = 'TestAccount1';
            acc1.Phone = '012034563433';
            acc1.BillingStreet = 'Street1';
            acc1.IP_Business_Type__c = 'catering';
            acc1.BillingCity = 'City1';
            acc1.BillingPostalCode = 'E2 5TT';
            acc1.BillingState = 'State1';
            acc1.BillingCountry = 'Country1';
            acc1.RecordTypeId = accountRec.id;
            acc1.OwnerId=u.Id;
            acc1.Owner=u;
            //acc1.Brand__c=u.Brand__c;
            insert acc1;
            system.debug('Account Inserted');

            Account canidateAccount = [SELECT Id, Name FROM Account WHERE RecordType.Name='Candidate' AND Name='Candidates' LIMIT 1]; //new Account();
            System.debug('Account Inserted');

            Recordtype recType = [Select id from Recordtype where sobjecttype = 'contact' and Name = 'Contact'];
            contact con2 = new contact();
            con2.RecordTypeId = recType.id;
            con2.AccountId = acc1.id;
            con2.FirstName = 'Test';
            con2.LastName = 'Data';
            con2.IP_ContactType__c = 'Invoice Contact';
            con2.OwnerId=u.Id;
            con2.Owner = u;
            //con2.Brand__c=u.Brand__c;
            insert con2;

            //RecordType contRec = [Select Id From RecordType Where sObjectType = 'Contact' And DeveloperName = 'Candidate'];
            List<Contact> workers = TestDataFactory.createCandidate(canidateAccount.Id, 6);
            insert workers;
            system.debug('test data factory  Candidate--' + workers);
            List<IP_PayProfile__c> workerPP = new List<IP_PayProfile__c>();
            for(Integer i=0; i<workers.size(); i++){
                workerPP.add(TestDataFactory.createPayProfilePaye(workers[i].Id, 1)[0]);
            }
            insert workerPP;

            IP_TopazGlobalClientInformation__c createtopaz = new IP_TopazGlobalClientInformation__c();
            createtopaz.name = 'TestClient2';
            createtopaz.IP_StatusID__c = 1;
            createtopaz.IP_SalesLedgerNumber__c = '123456';
            insert createtopaz;

            sirenum__Rota__c sector = new sirenum__Rota__c();
            sector.Name = 'new sector';
            insert sector;

            sirenum__Site__c site = new sirenum__Site__c();
            site.Name = 'testsite';
            site.sirenum__Operating_Company__c = acc1.id;
            site.IP_ClientIDLegacy__c = '123';
            site.IP_ClientInvoiceName__c = 'Test Invoice';
            site.IP_InvoiceAddressStreet__c = 'Test Street';
            site.IP_PublicSector__c = 'No';
            site.GlobalClientName__c = createtopaz.Id;
            site.sirenum__Postal_Code__c = 'E1 3GG';
            site.sirenum__City__c = 'New Delhi';
            site.IP_PublicSector__c = 'NO';
            site.IP_MainContact__c = con2.id;
            site.IP_InvoiceContact__c = con2.id;
            site.OwnerId = u.id;
            //site.Owner=u;
            site.IP_InvoiceAddressCity__c = 'Delhi';
            site.IP_Timesheet_Method__c = 'eTimesheet';
            site.IP_ScheduledAutoApproval__c = true;
            //site.Brand__c=u.Brand__c;
            insert site;

            system.debug('Value in site' + site);
            sirenum__Payroll_Cycle__c payrolcycle = new sirenum__Payroll_Cycle__c();
            payrolcycle.Name = 'Monday to Sunday';
            payrolcycle.sirenum__StartingDate__c = dateToday.addDays(-7).date();
            payrolcycle.sirenum__periodLength__c = 7;
            payrolcycle.sirenum__CyclePeriodUnits__c = 'Weeks';
            insert payrolcycle;


            sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
            contract.Name = 'test contract';
            contract.sirenum__Client__c = acc1.id;
            contract.sirenum__Employee__c = workers[0].id;
            contract.sirenum__PayrollCycle__c = payrolcycle.id;
            insert contract;

            sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
            jobtype.name = 'testjobtype';
            jobtype.Impellam_Sector__c = sector.id;
            jobtype.Impellam_Core_Category__c = 'Administration -ADM';
            jobtype.Impellam_Job_Category__c = 'Administrator -OA001';
            insert jobtype;

            sirenum__Team__c jobroll = new sirenum__Team__c();
            jobroll.name = 'testjobroll';
            jobroll.sirenum__Account__c = contract.id;
            jobroll.sirenum__Job_Type__c = jobtype.id;
            jobroll.sirenum__Rota__c = sector.id;
            jobroll.sirenum__AWR_Group__c = 'Group 2';
            jobroll.IP_OPWIPSRole__c = 'No';
            insert jobroll;

            ts2__Job__c assignJob = new ts2__Job__c();
            RecordType perms = [Select Id From RecordType Where DeveloperName = 'Perm' and sObjectType = 'ts2__Job__c'];
            assignJob.Name = 'Test Assignment for Job';
            assignJob.ts2__Account__c = acc1.Id;
            assignJob.IP_Fixed_Fee__c = 120;
            assignJob.sirenum_js__Site__c = site.Id;
            assignJob.ts2__Contact__c = workers[0].Id;
            assignJob.RecordTypeId = perms.Id;
            assignJob.ts2__Recruiter__c=u.Id;
            //assignJob.Owner=u;

            insert assignJob;

            sirenum__Placement__c splacement = new sirenum__Placement__c();
            splacement.Name = 'test placement ';
            splacement.sirenum__Contact__c = workers[0].id;
            splacement.sirenum__Start_Date__c = system.today();
            splacement.sirenum__Site__c = site.Id;
            splacement.IP_Consultant1LookupSplitShare__c = u.Id;
            splacement.IP_Consultant1PercentageSplit__c = 100;
            splacement.sirenum__Contract__c = contract.id;
            splacement.sirenum__Job_Role__c = jobroll.id;
            insert splacement;


            sirenum__Placement__c plcs = [select id, IP_Consultant1IDnumberSplitShare__c, IP_Consultant1LookupSplitShare__c
            from sirenum__Placement__c
            where id = :splacement.id];

            System.debug('Value in Consultantidno1swati' + plcs);

            sirenum__Timesheet__c createtimeshsheet = new sirenum__Timesheet__c();
            createtimeshsheet.sirenum__Client__c = acc1.id;
            createtimeshsheet.sirenum__Worker__c = workers[1].id;
            createtimeshsheet.sirenum__Team__c = jobroll.id;
            createtimeshsheet.sirenum__Site__c = site.id;
            createtimeshsheet.sirenum__Week_Ending__c = system.today();
            createtimeshsheet.sirenum__Non_Taxed_Expenses__c = 34.2;
            createtimeshsheet.sirenum__Taxed_Expenses__c = 22.2;
            createtimeshsheet.sirenum__Non_Taxed_Deductions__c = 22.0;
            createtimeshsheet.sirenum__Taxed_Deductions__c = 22.1;
            insert createtimeshsheet;
            system.debug('Value in createtimeshsheet' + createtimeshsheet);

            System.debug('workers[2] ---> ' + workers[2]);

            Datetime ssDatetime = dateToday.addDays(-7);
            Datetime seDatetime = dateToday.addDays(-7).addHours(8);
            //Monday Shift
            sirenum__Shift__c sshift =new sirenum__Shift__c();
            sshift.sirenum__Placement__c = plcs.id;
            sshift.sirenum__Rota__c = sector.Id;
            sshift.sirenum__Team__c = jobroll.id;
            sshift.sirenum__Timesheet_summaries__c = createtimeshsheet.id;
            sshift.sirenum__Site__c=site.id;
            sshift.sirenum__Published__c=true;
            sshift.sirenum__Contact__c=workers[2].id;
            sshift.sirenum__Cancelled__c= FALSE;
            sshift.sirenum__Published_Ever__c=TRUE;
            sshift.sirenum__Scheduled_Start_Time__c=ssDatetime;
            sshift.sirenum__Scheduled_End_Time__c=seDatetime;
            sshift.sirenum__Actual_Start_Time__c=ssDatetime;
            sshift.sirenum__Actual_End_Time__c=seDatetime;
            sshift.IP_CandidateApproved__c=true;
            sshift.IP_ClientRejected__c = false;
            sshift.sirenum__Allow_pay__c =false;
            sshift.sirenum__Allow_charge__c = false;
            insert sshift;

            sirenum__Shift__c sshift2 =new sirenum__Shift__c();
            sshift2.sirenum__Placement__c = plcs.id;
            sshift2.sirenum__Rota__c = sector.Id;
            sshift2.sirenum__Team__c = jobroll.id;
            sshift2.sirenum__Timesheet_summaries__c = createtimeshsheet.id;
            sshift2.sirenum__Site__c=site.id;
            sshift2.sirenum__Published__c=true;
            sshift2.sirenum__Contact__c=workers[2].id;
            sshift2.sirenum__Cancelled__c= FALSE;
            sshift2.sirenum__Published_Ever__c=TRUE;
            sshift2.sirenum__Scheduled_Start_Time__c=ssDatetime;
            sshift2.sirenum__Scheduled_End_Time__c=seDatetime;
            sshift2.sirenum__Actual_Start_Time__c=ssDatetime;
            sshift2.sirenum__Actual_End_Time__c=seDatetime;
            sshift2.sirenum__Billable_Start_Time__c=ssDatetime;
            sshift2.sirenum__Billable_End_Time__c=seDatetime;
            sshift2.IP_CandidateApproved__c=true;
            sshift2.IP_ClientApproved__c=true;
            sshift2.IP_ClientRejected__c = false;
            sshift2.sirenum__Allow_pay__c =false;
            sshift2.sirenum__Allow_charge__c = false;
            insert sshift2;

            sirenum__Shift__c sshift3 =new sirenum__Shift__c();
            sshift3.sirenum__Placement__c = plcs.id;
            sshift3.sirenum__Rota__c = sector.Id;
            sshift3.sirenum__Team__c = jobroll.id;
            sshift3.sirenum__Timesheet_summaries__c = createtimeshsheet.id;
            sshift3.sirenum__Site__c=site.id;
            sshift3.sirenum__Published__c=true;
            sshift3.sirenum__Contact__c=workers[2].id;
            sshift3.sirenum__Cancelled__c= FALSE;
            sshift3.sirenum__Published_Ever__c=TRUE;
            sshift3.sirenum__Scheduled_Start_Time__c=dateToday.addDays(-9);
            sshift3.sirenum__Scheduled_End_Time__c=dateToday.addDays(-9);
            sshift3.sirenum__Actual_Start_Time__c=dateToday.addDays(-9);
            sshift3.sirenum__Actual_End_Time__c=dateToday.addDays(-9);
            sshift3.IP_CandidateApproved__c=true;
            sshift3.IP_ClientRejected__c = false;
            sshift3.sirenum__Allow_pay__c =false;
            sshift3.sirenum__Allow_charge__c = false;
            insert sshift3;

            sirenum__Shift__c sshift4 =new sirenum__Shift__c();
            sshift4.sirenum__Placement__c = plcs.id;
            sshift4.sirenum__Rota__c = sector.Id;
            sshift4.sirenum__Team__c = jobroll.id;
            sshift4.sirenum__Timesheet_summaries__c = createtimeshsheet.id;
            sshift4.sirenum__Site__c=site.id;
            sshift4.sirenum__Published__c=true;
            sshift4.sirenum__Contact__c=workers[2].id;
            sshift4.sirenum__Cancelled__c= FALSE;
            sshift4.sirenum__Published_Ever__c=TRUE;
            sshift4.sirenum__Scheduled_Start_Time__c=dateToday.addDays(-9);
            sshift4.sirenum__Scheduled_End_Time__c=dateToday.addDays(-9);
            sshift4.sirenum__Actual_Start_Time__c=dateToday.addDays(-9);
            sshift4.sirenum__Actual_End_Time__c=dateToday.addDays(-9);
            sshift4.sirenum__Billable_Start_Time__c=dateToday.addDays(-9);
            sshift4.sirenum__Billable_End_Time__c=dateToday.addDays(-9);
            sshift4.IP_CandidateApproved__c=true;
            sshift4.IP_ClientApproved__c=true;
            sshift4.IP_ClientRejected__c = false;
            sshift4.sirenum__Allow_pay__c =false;
            sshift4.sirenum__Allow_charge__c = false;
            insert sshift4;

            Contact_Site_link__c csl = new Contact_Site_link__c();
            csl.Account__c = acc1.id;
            csl.IP_Contact__c = con2.id;
            csl.IP_PortalType__c = 'Primary Hours Approver';
            csl.IP_Site__c = site.id;
            insert csl;

            sshift2.IP_CandidateApproved__c=true;
            sshift2.IP_ClientApproved__c=true;
            sshift3.IP_CandidateApproved__c = true;
            sshift4.IP_CandidateApproved__c=true;
            sshift4.IP_ClientApproved__c=true;
            update new List<sirenum__Shift__c>{sshift2, sshift3, sshift4};
        }

        System.debug('Shifts >> ' + [SELECT Id, ts2__Account__r.Brand__c,
                                            sirenum_js__Site__r.Brand__c,
                                            ts2__Recruiter__r.Brand__c,
                                            Contact__r.Brand__c, Brand__c
                                    FROM ts2__Job__c]);

        Test.startTest();
        ShiftAutoApprovalMonday_5pm BC = new ShiftAutoApprovalMonday_5pm();
        DataBase.executeBatch(BC);
        Test.stopTest();

    }

    static testMethod void testMethod2() {
        contact con2;

        User u = [SELECT Id, Name, Email, Brand__c FROM User WHERE Email='abc.efg@GHI.com' AND IsActive=true ORDER BY CreatedDate DESC LIMIT 1];
        System.debug('Value in user'+ u);

        System.runAs(u) {
            Datetime dateToday = Datetime.now();
            Account acc = [SELECT Id, Name FROM Account WHERE RecordType.Name='Candidate' AND Name='Candidates' LIMIT 1]; //new Account();
            system.debug('Account Inserted >> ' + acc);

            Account acc1 = TestDataFactory.createClients(1)[0];
            acc1.OwnerId = u.Id;
            insert acc1;
            system.debug('Account Inserted >> '+ acc1);
            system.debug('Account Inserted >> '+ acc1);

            con2 = TestDataFactory.createContact(acc1.Id,1)[0];
            insert con2;

            List<Contact> workers = TestDataFactory.createCandidate(acc.Id, 6);
            insert workers;
            system.debug('test data factory  Candidate--' + workers);
            List<IP_PayProfile__c> workerPP = new List<IP_PayProfile__c>();
            for(Integer i=0; i<workers.size(); i++){
                workerPP.add(TestDataFactory.createPayProfilePaye(workers[i].Id, 1)[0]);
            }
            insert workerPP;
            system.debug('test data factory  Candidate--' + workers);

            IP_TopazGlobalClientInformation__c createtopaz = new IP_TopazGlobalClientInformation__c();
            createtopaz.name = 'TestClient2';
            createtopaz.IP_StatusID__c = 1;
            createtopaz.IP_SalesLedgerNumber__c = '123456';
            insert createtopaz;

            sirenum__Rota__c sector = new sirenum__Rota__c();
            sector.Name = 'new sector';
            insert sector;

            sirenum__Site__c site = new sirenum__Site__c();
            site.Name = 'testsite';
            site.sirenum__Operating_Company__c = acc1.id;
            site.IP_ClientIDLegacy__c = '123';
            site.IP_ClientInvoiceName__c = 'Test Invoice';
            site.IP_InvoiceAddressStreet__c = 'Test Street';
            site.IP_PublicSector__c = 'No';
            site.GlobalClientName__c = createtopaz.Id;
            site.sirenum__Postal_Code__c = 'E1 3GG';
            site.sirenum__City__c = 'New Delhi';
            site.IP_PublicSector__c = 'NO';
            site.IP_MainContact__c = con2.id;
            site.IP_InvoiceContact__c = con2.id;
            site.OwnerId = u.id;
            site.IP_InvoiceAddressCity__c = 'Delhi';
            site.IP_Timesheet_Method__c = 'eTimesheet';
            site.IP_ScheduledAutoApproval__c = true;
            insert site;
            system.debug('Value in site' + site);

            sirenum__Payroll_Cycle__c payrolcycle = new sirenum__Payroll_Cycle__c();
            payrolcycle.Name = 'Sunday to Saturday';
            payrolcycle.sirenum__StartingDate__c = date.newInstance(2019, 3, 10);
            payrolcycle.sirenum__periodLength__c = 7;
            payrolcycle.sirenum__CyclePeriodUnits__c = 'Weeks';
            insert payrolcycle;

            sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
            contract.Name = 'test contract';
            contract.sirenum__Client__c = acc1.id;
            contract.sirenum__Employee__c = workers[0].id;
            contract.sirenum__PayrollCycle__c = payrolcycle.id;
            insert contract;

            sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
            jobtype.name = 'testjobtype';
            jobtype.Impellam_Sector__c = sector.id;
            jobtype.Impellam_Core_Category__c = 'Administration -ADM';
            jobtype.Impellam_Job_Category__c = 'Administrator -OA001';
            insert jobtype;

            sirenum__Team__c jobroll = new sirenum__Team__c();
            jobroll.name = 'testjobroll';
            jobroll.sirenum__Account__c = contract.id;
            jobroll.sirenum__Job_Type__c = jobtype.id;
            jobroll.sirenum__Rota__c = sector.id;
            jobroll.sirenum__AWR_Group__c = 'Group 2';
            jobroll.IP_OPWIPSRole__c = 'No';
            insert jobroll;

            ts2__Job__c assignJob = new ts2__Job__c();
            RecordType perms = [Select Id From RecordType Where DeveloperName = 'Perm' and sObjectType = 'ts2__Job__c'];
            assignJob.Name = 'Test Assignment for Job';
            assignJob.ts2__Account__c = acc1.Id;
            assignJob.IP_Fixed_Fee__c = 120;
            assignJob.sirenum_js__Site__c = site.Id;
            assignJob.ts2__Contact__c = workers[0].Id;
            assignJob.RecordTypeId = perms.Id;
            assignJob.ts2__Recruiter__c=u.Id;
            insert assignJob;

            sirenum__Placement__c splacement = new sirenum__Placement__c();
            splacement.Name = 'test placement ';
            splacement.sirenum__Contact__c = workers[0].id;
            splacement.sirenum__Start_Date__c = system.today();
            splacement.sirenum__Site__c = site.Id;
            splacement.IP_Consultant1LookupSplitShare__c = u.Id;
            splacement.IP_Consultant1PercentageSplit__c = 100;
            splacement.sirenum__Contract__c = contract.id;
            splacement.sirenum__Job_Role__c = jobroll.id;
            insert splacement;

            System.debug('Value in Consultantidno1' + splacement.IP_Consultant1IDnumberSplitShare__c);
            System.debug('Value in Consultantidno1' + splacement.IP_Consultant1LookupSplitShare__c);
            System.debug('Value in Consultantidno1' + splacement.IP_Consultant1LookupSplitShare__r.IP_TempestID__c);

            sirenum__Placement__c plcs = [ select id, IP_Consultant1IDnumberSplitShare__c, IP_Consultant1LookupSplitShare__c
            from sirenum__Placement__c
            where id = :splacement.id];
            System.debug('Value in Consultantidno1swati' + plcs);

            //sirenum__Timesheet__c time = new sirenum__Timesheet__c();
            sirenum__Timesheet__c createtimeshsheet = new sirenum__Timesheet__c();
            createtimeshsheet.sirenum__Client__c = acc1.id;
            createtimeshsheet.sirenum__Worker__c = workers[1].id;
            createtimeshsheet.sirenum__Team__c = jobroll.id;
            createtimeshsheet.sirenum__Site__c = site.id;
            createtimeshsheet.sirenum__Week_Ending__c = system.today();
            createtimeshsheet.sirenum__Non_Taxed_Expenses__c = 34.2;
            createtimeshsheet.sirenum__Taxed_Expenses__c = 22.2;
            createtimeshsheet.sirenum__Non_Taxed_Deductions__c = 22.0;
            createtimeshsheet.sirenum__Taxed_Deductions__c = 22.1;
            insert createtimeshsheet;

            system.debug('Value in createtimeshsheet' + createtimeshsheet);

            Datetime ssDatetime = dateToday.addDays(-8);
            Datetime sEDatetime = dateToday.addDays(-8).addHours(8);
            sirenum__Shift__c sshift5 = new sirenum__Shift__c();
            sshift5.sirenum__Placement__c = plcs.id;
            sshift5.sirenum__Rota__c = sector.Id;
            sshift5.sirenum__Team__c = jobroll.id;
            sshift5.sirenum__Timesheet_summaries__c = createtimeshsheet.id;
            sshift5.sirenum__Site__c = site.id;
            sshift5.sirenum__Published__c = true;
            sshift5.sirenum__Contact__c = workers[2].id;
            sshift5.sirenum__Cancelled__c = false;
            sshift5.sirenum__Published_Ever__c = TRUE;
            sshift5.sirenum__Scheduled_Start_Time__c = ssDatetime;
            sshift5.sirenum__Scheduled_End_Time__c = sEDatetime;
            sshift5.sirenum__Actual_Start_Time__c = ssDatetime;
            sshift5.sirenum__Actual_End_Time__c = sEDatetime;
            sshift5.IP_CandidateApproved__c=true;
            sshift5.Actuals_confirmed__c=true;
            sshift5.IP_ClientRejected__c = false;
            sshift5.sirenum__Allow_pay__c = false;
            sshift5.sirenum__Allow_charge__c = false;
            insert sshift5;

            ssDatetime = dateToday.addDays(-7);
            sEDatetime = dateToday.addDays(-7).addHours(8);
            sirenum__Shift__c sshift6 = new sirenum__Shift__c();
            sshift6.sirenum__Placement__c = plcs.id;
            sshift6.sirenum__Rota__c = sector.Id;
            sshift6.sirenum__Team__c = jobroll.id;
            sshift6.sirenum__Timesheet_summaries__c = createtimeshsheet.id;
            sshift6.sirenum__Site__c = site.id;
            sshift6.sirenum__Published__c = true;
            sshift6.sirenum__Contact__c = workers[2].id;
            sshift6.sirenum__Cancelled__c = FALSE;
            sshift6.sirenum__Published_Ever__c = TRUE;
            sshift6.sirenum__Scheduled_Start_Time__c = ssDatetime;
            sshift6.sirenum__Scheduled_End_Time__c = sEDatetime;
            sshift6.sirenum__Actual_Start_Time__c = ssDatetime;
            sshift6.sirenum__Actual_End_Time__c = sEDatetime;
            //sshift6.sirenum__Billable_Start_Time__c = dateToday.addDays(-8);
            //sshift6.sirenum__Billable_End_Time__c = dateToday.addDays(-8);
            sshift6.IP_CandidateApproved__c = true;
            sshift6.IP_ClientApproved__c = true;
            sshift6.IP_ClientRejected__c = false;
            sshift6.sirenum__Allow_pay__c = false;
            sshift6.sirenum__Allow_charge__c = false;
            insert sshift6;

            sshift5.IP_CandidateApproved__c = true;
            sshift6.Actuals_confirmed__c = true;
            update new List<sirenum__Shift__c>{sshift5, sshift6};

            Contact_Site_link__c csl = new Contact_Site_link__c();
            csl.Account__c = acc1.id;
            csl.IP_Contact__c = con2.id;
            csl.IP_PortalType__c = 'Primary Hours Approver';
            csl.IP_Site__c = site.id;
            insert csl;
        }

        ApexPages.currentPage().getParameters().put('id', String.valueOf(con2.Id));
        CreateInstantPortalUserController.createUser();


        Map<Id, sirenum__Shift__c> shiftMap = new Map<Id, sirenum__Shift__c>(
                                            [SELECT Id, sirenum__Site__r.IP_Timesheet_Method__c,
                                                    sirenum__Site__r.IP_ScheduledAutoApproval__c, IP_CandidateApproved__c,Actuals_confirmed__c,
                                                    IP_ClientRejected__c, sirenum__Published__c, sirenum__Cancelled__c, sirenum__Scheduled_Start_Time__c,
                                                    sirenum__Scheduled_End_Time__c, sirenum__Allow_pay__c,sirenum__Allow_charge__c
                                            FROM sirenum__Shift__c]);
        Test.startTest();
        ShiftAutoApprovalMonday_5pm BC = new ShiftAutoApprovalMonday_5pm();
        DataBase.executeBatch(BC);
        Test.stopTest();
        Map<Id, sirenum__Shift__c> afterShiftMap = new Map<Id, sirenum__Shift__c>(
                                                    [SELECT Id, sirenum__Site__r.IP_Timesheet_Method__c,
                                                            sirenum__Site__r.IP_ScheduledAutoApproval__c, IP_CandidateApproved__c,Actuals_confirmed__c,
                                                            IP_ClientRejected__c, sirenum__Published__c, sirenum__Cancelled__c, sirenum__Scheduled_Start_Time__c,
                                                            sirenum__Scheduled_End_Time__c, sirenum__Allow_pay__c,sirenum__Allow_charge__c
                                                    FROM sirenum__Shift__c]);
        System.assertNotEquals (shiftMap.values()[0].sirenum__Allow_pay__c, afterShiftMap.get(shiftMap.values()[0].Id).sirenum__Allow_pay__c, 'Expected both to be approved');
    }

    static testMethod void testMethod3() {
        User u = [SELECT Id, Name, Email, Brand__c FROM User WHERE Email='abc.efg@GHI.com' AND IsActive=true ORDER BY CreatedDate DESC LIMIT 1];
        System.debug('Value in user'+ u);

        System.runAs(u) {
            Date dateToday = system.today();
            Account acc1 = new Account();
            RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client'];
            acc1.name = 'TestAccount1';
            acc1.Phone = '012034563433';
            acc1.BillingStreet = 'Street1';
            acc1.IP_Business_Type__c = 'catering';
            acc1.BillingCity = 'City1';
            acc1.BillingPostalCode = 'E1 3GG';
            acc1.BillingState = 'State1';
            acc1.BillingCountry = 'Country1';
            acc1.RecordTypeId = accountRec.id;
            insert acc1;
            system.debug('Account Inserted');

            Account acc = [SELECT Id, Name FROM Account WHERE RecordType.Name='Candidate' AND Name='Candidates' LIMIT 1]; //new Account();

            Recordtype recType = [Select id from Recordtype where sobjecttype = 'contact' and Name = 'Contact'];
            contact con2 = new contact();
            con2.RecordTypeId = recType.id;
            con2.AccountId = acc1.id;
            con2.FirstName = 'Test';
            con2.LastName = 'Data';
            con2.IP_ContactType__c = 'Invoice Contact';
            insert con2;

            List<Contact> workers = TestDataFactory.createCandidate(acc.Id, 6);
            insert workers;
            system.debug('test data factory  Candidate--' + workers);
            List<IP_PayProfile__c> workerPP = new List<IP_PayProfile__c>();
            for(Integer i=0; i<workers.size(); i++){
                workerPP.add(TestDataFactory.createPayProfilePaye(workers[i].Id, 1)[0]);
            }
            insert workerPP;
            system.debug('test data factory  Candidate--' + workers);

            IP_TopazGlobalClientInformation__c createtopaz = new IP_TopazGlobalClientInformation__c();
            createtopaz.name = 'TestClient2';
            createtopaz.IP_StatusID__c = 1;
            createtopaz.IP_SalesLedgerNumber__c = '123456';
            insert createtopaz;

            sirenum__Rota__c sector = new sirenum__Rota__c();
            sector.Name = 'new sector';
            insert sector;

            sirenum__Site__c site = new sirenum__Site__c();
            site.Name = 'testsite';
            site.sirenum__Operating_Company__c = acc1.id;
            site.IP_ClientIDLegacy__c = '123';
            site.IP_ClientInvoiceName__c = 'Test Invoice';
            site.IP_InvoiceAddressStreet__c = 'Test Street';
            site.IP_PublicSector__c = 'No';
            site.GlobalClientName__c = createtopaz.Id;
            site.sirenum__Postal_Code__c = 'E1 3GG';
            site.sirenum__City__c = 'New Delhi';
            site.IP_PublicSector__c = 'NO';
            site.IP_MainContact__c = con2.id;
            site.IP_InvoiceContact__c = con2.id;
            site.OwnerId = u.id;
            site.IP_InvoiceAddressCity__c = 'Delhi';
            site.IP_Timesheet_Method__c = 'eTimesheet';
            site.IP_ScheduledAutoApproval__c = true;
            insert site;

            system.debug('Value in site' + site);

            sirenum__Payroll_Cycle__c payrolcycle = new sirenum__Payroll_Cycle__c();
            payrolcycle.Name = 'Saturday to Friday';
            payrolcycle.sirenum__StartingDate__c = dateToday.addDays(-7);
            payrolcycle.sirenum__periodLength__c = 7;
            payrolcycle.sirenum__CyclePeriodUnits__c = 'Weeks';
            insert payrolcycle;


            sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
            contract.Name = 'test contract';
            contract.sirenum__Client__c = acc1.id;
            contract.sirenum__Employee__c = workers[0].id;
            contract.sirenum__PayrollCycle__c = payrolcycle.id;
            insert contract;


            sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
            jobtype.name = 'testjobtype';
            jobtype.Impellam_Sector__c = sector.id;
            jobtype.Impellam_Core_Category__c = 'Administration -ADM';
            jobtype.Impellam_Job_Category__c = 'Administrator -OA001';
            insert jobtype;


            sirenum__Team__c jobroll = new sirenum__Team__c();
            jobroll.name = 'testjobroll';
            jobroll.sirenum__Account__c = contract.id;
            jobroll.sirenum__Job_Type__c = jobtype.id;
            jobroll.sirenum__Rota__c = sector.id;
            jobroll.sirenum__AWR_Group__c = 'Group 2';
            jobroll.IP_OPWIPSRole__c = 'No';
            insert jobroll;


            ts2__Job__c assignJob = new ts2__Job__c();
            RecordType perms = [Select Id From RecordType Where DeveloperName = 'Perm' and sObjectType = 'ts2__Job__c'];
            assignJob.Name = 'Test Assignment for Job';
            assignJob.ts2__Account__c = acc1.Id;
            assignJob.IP_Fixed_Fee__c = 120;
            assignJob.sirenum_js__Site__c = site.Id;
            assignJob.ts2__Contact__c = workers[0].Id;
            assignJob.RecordTypeId = perms.Id;
            assignJob.ts2__Recruiter__c=u.Id;
            insert assignJob;


            sirenum__Placement__c splacement = new sirenum__Placement__c();
            splacement.Name = 'test placement ';
            splacement.sirenum__Contact__c = workers[0].id;
            splacement.sirenum__Start_Date__c = system.today();
            splacement.sirenum__Site__c = site.Id;
            splacement.IP_Consultant1LookupSplitShare__c = u.Id;
            splacement.IP_Consultant1PercentageSplit__c = 100;
            splacement.sirenum__Contract__c = contract.id;
            splacement.sirenum__Job_Role__c = jobroll.id;
            insert splacement;
            System.debug('Value in Consultantidno1' + splacement.IP_Consultant1IDnumberSplitShare__c);
            System.debug('Value in Consultantidno1' + splacement.IP_Consultant1LookupSplitShare__c);
            System.debug('Value in Consultantidno1' + splacement.IP_Consultant1LookupSplitShare__r.IP_TempestID__c);


            sirenum__Placement__c plcs = [
                    select id, IP_Consultant1IDnumberSplitShare__c, IP_Consultant1LookupSplitShare__c
                    from sirenum__Placement__c
                    where id = :splacement.id
            ];

            System.debug('Value in Consultantidno1swati' + plcs);


            //     sirenum__Timesheet__c time = new sirenum__Timesheet__c();

            sirenum__Timesheet__c createtimeshsheet = new sirenum__Timesheet__c();
            createtimeshsheet.sirenum__Client__c = acc1.id;
            createtimeshsheet.sirenum__Worker__c = workers[1].id;
            createtimeshsheet.sirenum__Team__c = jobroll.id;
            createtimeshsheet.sirenum__Site__c = site.id;
            createtimeshsheet.sirenum__Week_Ending__c = system.today();
            createtimeshsheet.sirenum__Non_Taxed_Expenses__c = 34.2;
            createtimeshsheet.sirenum__Taxed_Expenses__c = 22.2;
            createtimeshsheet.sirenum__Non_Taxed_Deductions__c = 22.0;
            createtimeshsheet.sirenum__Taxed_Deductions__c = 22.1;
            insert createtimeshsheet;
            system.debug('Value in createtimeshsheet' + createtimeshsheet);


            sirenum__Shift__c sshift3 = new sirenum__Shift__c();
            sshift3.sirenum__Placement__c = plcs.id;
            sshift3.sirenum__Rota__c = sector.Id;
            sshift3.sirenum__Team__c = jobroll.id;
            sshift3.sirenum__Timesheet_summaries__c = createtimeshsheet.id;
            sshift3.sirenum__Site__c = site.id;
            sshift3.sirenum__Published__c = true;
            sshift3.sirenum__Contact__c = workers[2].id;
            sshift3.sirenum__Cancelled__c = FALSE;
            sshift3.sirenum__Published_Ever__c = TRUE;
            sshift3.sirenum__Scheduled_Start_Time__c = dateToday.addDays(-9);
            sshift3.sirenum__Scheduled_End_Time__c = dateToday.addDays(-9);
            sshift3.sirenum__Actual_Start_Time__c = dateToday.addDays(-9);
            sshift3.sirenum__Actual_End_Time__c = dateToday.addDays(-9);
            sshift3.IP_CandidateApproved__c = true;
            sshift3.IP_ClientRejected__c = false;
            sshift3.sirenum__Allow_pay__c = false;
            sshift3.sirenum__Allow_charge__c = false;
            insert sshift3;

            sirenum__Shift__c sshift4 = new sirenum__Shift__c();
            sshift4.sirenum__Placement__c = plcs.id;
            sshift4.sirenum__Rota__c = sector.Id;
            sshift4.sirenum__Team__c = jobroll.id;
            sshift4.sirenum__Timesheet_summaries__c = createtimeshsheet.id;
            sshift4.sirenum__Site__c = site.id;
            sshift4.sirenum__Published__c = true;
            sshift4.sirenum__Contact__c = workers[2].id;
            sshift4.sirenum__Cancelled__c = FALSE;
            sshift4.sirenum__Published_Ever__c = TRUE;
            sshift4.sirenum__Scheduled_Start_Time__c = dateToday.addDays(-9);
            sshift4.sirenum__Scheduled_End_Time__c = dateToday.addDays(-9);
            sshift4.sirenum__Actual_Start_Time__c = dateToday.addDays(-9);
            sshift4.sirenum__Actual_End_Time__c = dateToday.addDays(-9);
            sshift4.sirenum__Billable_Start_Time__c = dateToday.addDays(-9);
            sshift4.sirenum__Billable_End_Time__c = dateToday.addDays(-9);
            sshift4.IP_CandidateApproved__c = true;
            sshift4.IP_ClientApproved__c = true;
            sshift4.IP_ClientRejected__c = false;
            sshift4.sirenum__Allow_pay__c = false;
            sshift4.sirenum__Allow_charge__c = false;
            insert sshift4;

            Contact_Site_link__c csl = new Contact_Site_link__c();
            csl.Account__c = acc1.id;
            csl.IP_Contact__c = con2.id;
            csl.IP_PortalType__c = 'Primary Hours Approver';
            csl.IP_Site__c = site.id;
            insert csl;

            sshift3.IP_CandidateApproved__c = true;
            sshift3.IP_ClientRejected__c = false;
            sshift4.IP_CandidateApproved__c = true;
            sshift4.IP_ClientApproved__c = true;
            update new List<sirenum__Shift__c>{sshift3, sshift4};
        }

        Test.startTest();
        ShiftAutoApprovalMonday_5pm BC = new ShiftAutoApprovalMonday_5pm();
        DataBase.executeBatch(BC);
        Test.stopTest();
    }

}