@isTest
public class Test_PoManagementCntrl {
    @testSetup
    static void shiftSetup() {
        Contact contact1 ;
        TestDataFactory.setupUserProfileCustomSettings();
        //Create account
        Account portalAccount1 = new Account(
                Name = 'TestAccount',
                //OwnerId = portalAccountOwner11.Id,
                Invoice_PO_Number_Format__c='AAAA'
        );
        Account candidateAccount = TestDataFactory.createCandidateAccount(1)[0];
        insert new List<Account>{portalAccount1, candidateAccount};
        TestDataFactory.setupCustomSettings(candidateAccount.Id);

        //Create contact
        contact1 = new Contact(
                FirstName = 'Test1',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                IP_IsInvoicecontact__c=true,
                //IP_ContactType__c='Invoice Contact',
                Email = System.now().millisecond() + 'test@test.com'
        );
        Database.insert(contact1);

        String portalProfileId = User_Profile_Id__c.getValues(Label.Client_Portal_User_Profile).Profile_Id__c;
        String userName = contact1.FirstName + '_' + System.now().millisecond() + 'test12345@test.com';
        User user1 = new User(
                Username = userName,
                ContactId = contact1.Id,
                ProfileId = portalProfileId,
                Alias = 'test123',
                Email = userName,
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                IP_TempestDepartment__c = '1062'
        );
        Database.insert(user1);
    }

    public static testmethod void test1(){
        insert new IP_Shift_Template__c(name = '1233', Email__c = 'singh.taji26@gmail.com');

        User u = [select id , contactId,contact.AccountId from user where lastname = 'McTesty' limit 1];
        ID ConTID = u.contactId;
        ID accDID = u.Contact.AccountId;

        Account acct1 = TestDataFactory.createAccounts(3)[2];
        insert acct1;
        Account acct = [SELECT Id, Name FROM Account WHERE RecordType.Name ='Candidate' LIMIT 1];

        Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];
        insert cond;

        IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0];
        tgci.IP_SalesLedgerNumber__c = '1112244';
        Insert tgci;

        sirenum__Site__c sites =  TestDataFactory.createSites(accDID, tgci.id, 1)[0];
        sites.ownerId = u.id;
        sites.sirenum__Operating_Company__c = accDID;
        sites.IP_MainContact__c = ConTID;
        sites.sirenum__Postal_Code__c = '10234';
        sites.sirenum__Street_Address__c = '1231';
        sites.IP_PassClientToTempest__c=false;
        sites.IP_Timesheet_Method__c = 'eTimesheet';
        sites.IP_InvoiceContact__c = ConTID;
        Insert sites;

        Contact_Site_link__c stlink = new Contact_Site_link__c();
        stlink.IP_Site__c = sites.id;
        stlink.IP_Contact__c = ConTID;
        stlink.Account__c = accDID;
        stlink.IP_PortalType__c ='Primary Hours Approver';
        insert stlink;

        sirenum__Payroll_Cycle__c payrollWeek = new sirenum__Payroll_Cycle__c();
        payrollWeek.sirenum__CyclePeriodUnits__c = 'Weeks';
        payrollWeek.sirenum__periodLength__c = 1;
        payrollWeek.Name = 'Monday to Sunday';
        Date dt = Date.newInstance(2020, 06, 22);
        payrollWeek.sirenum__StartingDate__c = dt;
        insert payrollWeek;

        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(accDID, cond.id,1)[0];
        pac.sirenum__PayrollCycle__c = payrollWeek.id;
        insert pac;

        sirenum__Rota__c rota = TestDataFactory.createSector(1)[0];
        Insert rota;

        sirenum__Job_Type__c job = TestDataFactory.createJobType(rota.id, 1)[0];
        Insert job;

        sirenum__Team__c tm = TestDataFactory.createJobRole(pac.id, job.id,1)[0];
        Insert tm;

        sirenum__Placement__c splacement = TestDataFactory.createSPlacement1(cond.id, pac.id, tm.id, u.id,1)[0];
        splacement.sirenum__Site__c = sites.id;
        splacement.IP_Consultant1LookupSplitShare__c = u.id;
        splacement.IP_Costcode__c = '1233';
        splacement.IP_PurchaseOrderNumber__c = 'LALA';
        splacement.sirenum__Start_Date__c = system.today()-5;
        splacement.sirenum__End_Date__c = system.today()+30;
        Insert splacement;
        List<Id> plist = new List<Id>();
        plist.add(splacement.Id);

        //  List<contact> conId = [select id, name,AccountId from contact where lastname like 'McTesty%' limit 5];
        IP_PayProfile__c pp = TestDataFactory.createPayProfilePaye(cond.id, 1)[0];
        insert pp;
        test.startTest();
        sirenum__Shift__c shftList = TestDataFactory.createShift(splacement.id, sites.id,1)[0];
        shftList.sirenum__Contact__c =  cond.id;
        shftList.sirenum__Scheduled_Start_Time__c = System.now();
        shftList.sirenum__Scheduled_End_Time__c = System.now()+1;
        shftList.sirenum__Forecast_Charge__c = 10;
        shftList.sirenum__Invalid_shift__c = false;
        shftList.StartTime__c = '10:30';
        shftList.EndTime__c = '18:30';
        shftList.IP_Account__c = accDID;
        shftList.sirenum__Team__c = tm.id;
        shftList.sirenum__Published__c = true;
        shftList.sirenum__Rota__c = rota.id;

        insert shftList;
        String CandId;
        String jobroleId;
        System.runAs(u) {
            PoManagementCntrl.getPlaceList(CandId, jobroleId);
            PoManagementCntrl.getSitesOfLoggedInUser();
            PoManagementCntrl.getContactList();
            PoManagementCntrl.fetchUser();
            PoManagementCntrl.getJobRoleList();
            //    PoManagementCntrl.getStartDate();

            PoManagementCntrl.StartDateMonday('Monday to Sunday');
            PoManagementCntrl.StartDateSaturday('Saturday to Friday');
            PoManagementCntrl.StartDateSunday('Sunday to Saturday');
            PoManagementCntrl.UpdateBulkPO('1234', plist);
            PoManagementCntrl.getShifts(splacement.id, 'Monday to Sunday');
        }
        test.stoptest();
    }

    public static testmethod void test2(){
        insert new IP_Shift_Template__c(name = '1233', Email__c = 'singh.taji26@gmail.com');

        User u = [select id , contactId,contact.AccountId from user where lastname = 'McTesty' limit 1];
        ID ConTID = u.contactId;
        ID accDID = u.Contact.AccountId;

        Account acct1 = TestDataFactory.createAccounts(3)[2];
        insert acct1;
        Account acct = [SELECT Id, Name FROM Account WHERE RecordType.Name ='Candidate' LIMIT 1];

        Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];
        Insert cond;

        IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0];
        tgci.IP_SalesLedgerNumber__c = '1112244';
        Insert tgci;

        sirenum__Site__c sites =  TestDataFactory.createSites(accDID, tgci.id, 1)[0];
        sites.ownerId = u.id;
        sites.sirenum__Operating_Company__c = accDID;
        sites.IP_MainContact__c = ConTID;
        sites.sirenum__Postal_Code__c = '10234';
        sites.sirenum__Street_Address__c = '1231';
        sites.IP_PassClientToTempest__c=false;
        sites.IP_Timesheet_Method__c = 'eTimesheet';
        sites.IP_InvoiceContact__c = ConTID;
        Insert sites;

        Contact_Site_link__c stlink = new Contact_Site_link__c();
        stlink.IP_Site__c = sites.id;
        stlink.IP_Contact__c = ConTID;
        stlink.Account__c = accDID;
        stlink.IP_PortalType__c ='Primary Hours Approver';
        insert stlink;

        sirenum__Payroll_Cycle__c payrollWeek = new sirenum__Payroll_Cycle__c();
        payrollWeek.sirenum__CyclePeriodUnits__c = 'Weeks';
        payrollWeek.sirenum__periodLength__c = 1;
        payrollWeek.Name = 'Sunday to Saturday';
        Date dt = Date.newInstance(2020, 06, 21);
        payrollWeek.sirenum__StartingDate__c = dt;
        insert payrollWeek;

        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(accDID, cond.id,1)[0];
        pac.sirenum__PayrollCycle__c = payrollWeek.id;
        insert pac;

        sirenum__Rota__c rota = TestDataFactory.createSector(1)[0];
        Insert rota;

        sirenum__Job_Type__c job = TestDataFactory.createJobType(rota.id, 1)[0];
        Insert job;

        sirenum__Team__c tm = TestDataFactory.createJobRole(pac.id, job.id,1)[0];
        Insert tm;

        sirenum__Placement__c splacement = TestDataFactory.createSPlacement1(cond.id, pac.id, tm.id, u.id,1)[0];
        splacement.sirenum__Site__c = sites.id;
        splacement.IP_Consultant1LookupSplitShare__c = u.id;
        splacement.IP_Costcode__c = '1233';
        splacement.IP_PurchaseOrderNumber__c = 'LALA';
        splacement.sirenum__Start_Date__c = system.today()-5;
        splacement.sirenum__End_Date__c = system.today()+30;
        Insert splacement;
        List<Id> plist = new List<Id>();
        plist.add(splacement.Id);

        //  List<contact> conId = [select id, name,AccountId from contact where lastname like 'McTesty%' limit 5];
        IP_PayProfile__c pp = TestDataFactory.createPayProfilePaye(cond.id, 1)[0];
        insert pp;
        test.startTest();
        sirenum__Shift__c shftList = TestDataFactory.createShift(splacement.id, sites.id,1)[0];
        shftList.sirenum__Contact__c =  cond.id;
        shftList.sirenum__Scheduled_Start_Time__c = System.now();
        shftList.sirenum__Scheduled_End_Time__c = System.now()+1;
        shftList.sirenum__Forecast_Charge__c = 10;
        shftList.sirenum__Invalid_shift__c = false;
        shftList.StartTime__c = '10:30';
        shftList.EndTime__c = '18:30';
        shftList.IP_Account__c = accDID;
        shftList.sirenum__Team__c = tm.id;
        shftList.sirenum__Published__c = true;
        shftList.sirenum__Rota__c = rota.id;

        insert shftList;
        String CandId;
        String jobroleId;
        System.runAs(u) {

            PoManagementCntrl.getPlaceList(CandId, jobroleId);
            PoManagementCntrl.StartDateMonday('Monday to Sunday');
            PoManagementCntrl.StartDateSaturday('Saturday to Friday');
            PoManagementCntrl.StartDateSunday('Sunday to Saturday');
            PoManagementCntrl.UpdateBulkPO('1234', plist);
            PoManagementCntrl.getShifts(splacement.id, 'Saturday to Friday');
            PoManagementCntrl.getShifts(splacement.id, 'Sunday to Saturday');
        }
        test.stoptest();
    }

    public static testmethod void test3(){
        insert new IP_Shift_Template__c(name = '1233', Email__c = 'singh.taji26@gmail.com');
        User u = [select id , contactId,contact.AccountId from user where lastname = 'McTesty' limit 1];
        ID ConTID = u.contactId;
        ID accDID = u.Contact.AccountId;

        Account acct1 = TestDataFactory.createAccounts(3)[2];
        insert acct1;
        Account acct = [SELECT Id, Name FROM Account WHERE RecordType.Name ='Candidate' LIMIT 1];
        Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];
        Insert cond;

        IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0];
        tgci.IP_SalesLedgerNumber__c = '1112244';
        Insert tgci;

        sirenum__Site__c sites =  TestDataFactory.createSites(accDID, tgci.id, 1)[0];
        sites.ownerId = u.id;
        sites.sirenum__Operating_Company__c = accDID;
        sites.IP_MainContact__c = ConTID;
        sites.sirenum__Postal_Code__c = '10234';
        sites.sirenum__Street_Address__c = '1231';
        sites.IP_PassClientToTempest__c=false;
        sites.IP_Timesheet_Method__c = 'eTimesheet';
        sites.IP_InvoiceContact__c = ConTID;
        Insert sites;

        Contact_Site_link__c stlink = new Contact_Site_link__c();
        stlink.IP_Site__c = sites.id;
        stlink.IP_Contact__c = ConTID;
        stlink.Account__c = accDID;
        stlink.IP_PortalType__c ='Primary Hours Approver';
        insert stlink;

        sirenum__Payroll_Cycle__c payrollWeek = new sirenum__Payroll_Cycle__c();
        payrollWeek.sirenum__CyclePeriodUnits__c = 'Weeks';
        payrollWeek.sirenum__periodLength__c = 1;
        payrollWeek.Name = 'Saturday to Friday';
        Date dt = Date.newInstance(2020, 06, 20);
        payrollWeek.sirenum__StartingDate__c = dt;
        insert payrollWeek;

        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(accDID, cond.id,1)[0];
        pac.sirenum__PayrollCycle__c = payrollWeek.id;
        insert pac;

        sirenum__Rota__c rota = TestDataFactory.createSector(1)[0];
        Insert rota;

        sirenum__Job_Type__c job = TestDataFactory.createJobType(rota.id, 1)[0];
        Insert job;

        sirenum__Team__c tm = TestDataFactory.createJobRole(pac.id, job.id,1)[0];
        Insert tm;

        sirenum__Placement__c splacement = TestDataFactory.createSPlacement1(cond.id, pac.id, tm.id, u.id,1)[0];
        splacement.sirenum__Site__c = sites.id;
        splacement.IP_Consultant1LookupSplitShare__c = u.id;
        splacement.IP_Costcode__c = '1233';
        splacement.IP_PurchaseOrderNumber__c = 'LALA';
        splacement.sirenum__Start_Date__c = system.today()-5;
        splacement.sirenum__End_Date__c = system.today()+30;
        Insert splacement;
        List<Id> plist = new List<Id>();
        plist.add(splacement.Id);

        //  List<contact> conId = [select id, name,AccountId from contact where lastname like 'McTesty%' limit 5];
        IP_PayProfile__c pp = TestDataFactory.createPayProfilePaye(cond.id, 1)[0];
        insert pp;
        test.startTest();
        sirenum__Shift__c shftList = TestDataFactory.createShift(splacement.id, sites.id,1)[0];
        shftList.sirenum__Contact__c =  cond.id;
        shftList.sirenum__Scheduled_Start_Time__c = System.now();
        shftList.sirenum__Scheduled_End_Time__c = System.now()+1;
        shftList.sirenum__Total_Charge__c = 10;
        shftList.sirenum__Invalid_shift__c = false;
        shftList.StartTime__c = '10:30';
        shftList.EndTime__c = '18:30';
        shftList.IP_Account__c = accDID;
        shftList.sirenum__Team__c = tm.id;
        shftList.sirenum__Published__c = true;
        shftList.sirenum__Rota__c = rota.id;

        insert shftList;
        String CandId;
        String jobroleId;
        System.runAs(u) {

            PoManagementCntrl.getPlaceList(CandId, jobroleId);
            PoManagementCntrl.StartDateMonday('Monday to Sunday');
            PoManagementCntrl.StartDateSaturday('Saturday to Friday');
            PoManagementCntrl.StartDateSunday('Sunday to Saturday');
            PoManagementCntrl.UpdateBulkPO('1234', plist);
            PoManagementCntrl.getShifts(splacement.id, 'Sunday to Saturday');
        }
        test.stoptest();
    }
}