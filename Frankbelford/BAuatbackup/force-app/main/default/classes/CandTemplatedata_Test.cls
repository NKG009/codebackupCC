@isTest
public class CandTemplatedata_Test {
    @TestSetup
    public static void setupTest(){
        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        TestDataFactory.setupCustomSettings(acc.Id);
        TestDataFactory.setupUserProfileCustomSettings();
        insert new IP_Shift_Template__c(name = '2043', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='test@abc.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');
    }

    public static testmethod void candtemplate1(){
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account'];
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];

        Account acc =  [SELECT Id, Name FROM Account WHERE RecordType.Name='Candidate' LIMIT 1];

        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc1;

        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        insert con;

        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main Contact', AccountID=acc1.id, IP_ContactType__c = 'Invoice Contact');
        insert maincon;

        sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
        insert ct;

        sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
        insert sec;

        sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
        insert jobcate;

        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
        insert tpz;

        sirenum__Site__c site = new sirenum__Site__c();
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc1.id;
        site.IP_ClientIDLegacy__c='123';
        site.GlobalClientName__c=tpz.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';
        site.IP_InvoiceContact__c = maincon.id;
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;

        sirenum__Rate_Card__c rc = new sirenum__Rate_Card__c();
        rc.sirenum__Job_Type__c = jobcate.id;
        rc.sirenum__Sirenum_Contract__c = ct.id;
        rc.sirenum__Site__c = site.id;
        rc.sirenum__Account__c = acc.id;
        insert rc;


        sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
        job.sirenum__Rate_Card__c = rc.id;
        insert job;

        sirenum__Rate_Card_Page__c rcp = new sirenum__Rate_Card_Page__c ();
        rcp.sirenum__Condition_Suggestions__c = 'Royal_Mail_Formula__c';
        rcp.sirenum__Condition_Operator__c = 'Equal to';
        rcp.sirenum__Condition_value__c = '10';
        rcp.sirenum__Rate_Card__c = rc.id;
        rcp.sirenum__Valid_From_Date__c  = System.today().addDays(1);
        rcp.sirenum__Valid_Until_Date__c = System.today().addDays(2);
        rcp.sirenum__SortOrder__c = 0;
        insert rcp;

        sirenum__Rate_Line__c rl = new sirenum__Rate_Line__c();
        rl.sirenum__Rate_Card_Page__c = rcp.id;
        rl.sirenum__Day_Type__c= 'Any Day';
        rl.sirenum__Pay_Rate__c = 12;
        rl.sirenum__Code__c = 'P1';
        rl.sirenum__Charge_Rate__c = 13;
        rl.sirenum__SortOrder__c = 0;
        insert rl;

        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = TestDataFactory.createUsers(p.id,1)[0];
        u.IP_TempestDepartment__c = '2043';
        u.username = 'jhy@123.com';
        u.Brand__c = 'Blue Arrow';
        insert u;

        sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
        ps.sirenum__Start_Date__c = System.today();
        ps.sirenum__End_Date__c = System.today().addDays(15);
        ps.sirenum__Rota__c = sec.id;
        ps.sirenum__site__c = site.id;
        ps.IP_Consultant1LookupSplitShare__c = u.Id;
        insert ps;
        system.debug('$$Placement created'+ps);

        sirenum__Shift__c shft = TestDataFactory.createShift(ps.id,site.id,1)[0];
        shft.sirenum__Rota__c = sec.id;
        shft.sirenum__Scheduled_Start_Time__c = Datetime.now();
        shft.sirenum__Scheduled_End_Time__c = Datetime.now().addHours(8);
        insert shft;

        test.startTest();
            PageReference pageRef = Page.CandidateTemplate;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ps);
            ApexPages.currentPage().getParameters().put('Id',ps.id);

            Candtemplatedata temp = new Candtemplatedata(sc);

            temp.createtask();
            temp.getratelines();
            temp.getrate1();
            temp.getrate2();
            List<sirenum__Shift__c> getshifts = temp.getshifts();
            //temp.Shiftstartdate(Datetime.now());
        test.stopTest();
    }

    public static testmethod void candtemplate2(){
        Account acc =  [SELECT Id, Name FROM Account WHERE RecordType.Name='Candidate' LIMIT 1];

        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account'];
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];

        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc1;

        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main Contact', AccountID=acc1.id, IP_ContactType__c = 'Invoice Contact');
        insert maincon;

        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        insert con;

        sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
        insert ct;

        sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
        insert sec;

        sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
        insert jobcate;

        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
        insert tpz;

        sirenum__Site__c site = new sirenum__Site__c();

        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc1.id;
        site.IP_ClientIDLegacy__c='123';
        site.GlobalClientName__c=tpz.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';

        site.IP_InvoiceContact__c = maincon.id;
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;

        sirenum__Rate_Card__c rc = new sirenum__Rate_Card__c();
        rc.sirenum__Job_Type__c = jobcate.id;
        rc.sirenum__Sirenum_Contract__c = ct.id;
        rc.sirenum__Site__c = site.id;
        rc.sirenum__Account__c = acc.id;
        insert rc;


        sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
        job.sirenum__Rate_Card__c = rc.id;
        insert job;

        sirenum__Rate_Card_Page__c rcp = new sirenum__Rate_Card_Page__c ();
        rcp.sirenum__Condition_Suggestions__c = 'Contact__c';
        rcp.sirenum__Condition_Operator__c = 'Equal to';
        rcp.sirenum__Condition_value__c = con.id;
        rcp.sirenum__Rate_Card__c = rc.id;
        rcp.sirenum__Valid_From_Date__c  = System.today().addDays(1);
        rcp.sirenum__Valid_Until_Date__c = System.today().addDays(2);
        rcp.sirenum__SortOrder__c = 0;
        insert rcp;

        sirenum__Rate_Card_Page__c rcp1 = new sirenum__Rate_Card_Page__c ();
        rcp1.sirenum__Condition_Suggestions__c = 'AWR';
        rcp1.sirenum__Condition_Operator__c = 'Equal to';
        rcp1.sirenum__Condition_value__c = 'Checked';
        rcp1.sirenum__Rate_Card__c = rc.id;
        rcp1.sirenum__Valid_From_Date__c  = System.today().addDays(1);
        rcp1.sirenum__Valid_Until_Date__c = System.today().addDays(2);
        rcp1.sirenum__SortOrder__c = 0;
        insert rcp1;

        sirenum__Rate_Line__c rl = new sirenum__Rate_Line__c();
        rl.sirenum__Rate_Card_Page__c = rcp.id;
        rl.sirenum__Day_Type__c= 'Any Day';
        rl.sirenum__Pay_Rate__c = 12;
        rl.sirenum__Code__c = 'P1';
        rl.sirenum__Charge_Rate__c = 114;
        rl.sirenum__SortOrder__c = 0;
        insert rl;

        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = TestDataFactory.createUsers(p.id,1)[0];
        u.IP_TempestDepartment__c = '2043';
        u.username = 'jhy@123.com';
        u.Brand__c = 'Blue Arrow';
        insert u;

        sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
        ps.sirenum__Start_Date__c = System.today();
        ps.sirenum__End_Date__c = System.today().addDays(15);
        ps.sirenum__Rota__c = sec.id;
        ps.sirenum__site__c = site.id;
        ps.IP_Consultant1LookupSplitShare__c=u.Id;
        insert ps;
        system.debug('$$Placement created'+ps);
        system.debug('$$Placement created123'+ps.IP_TempestDepartment__c);

        sirenum__Shift__c shft = TestDataFactory.createShift(ps.id,site.id,1)[0];
        shft.sirenum__Rota__c = sec.id;
        shft.sirenum__Scheduled_Start_Time__c = Datetime.now();
        shft.sirenum__Scheduled_End_Time__c = Datetime.now().addHours(8);
        insert shft;

        test.startTest();
            PageReference pageRef = Page.CandidateTemplate;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ps);
            ApexPages.currentPage().getParameters().put('Id',ps.id);
            Candtemplatedata temp = new Candtemplatedata(sc);
            temp.createtask();
            temp.getratelines();
            temp.getrate1();
            temp.getrate2();
        test.stopTest();
    }

    public static testmethod void candtemplate3(){
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account'];
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];

        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc1;

        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main Contact', AccountID=acc1.id, IP_ContactType__c = 'Invoice Contact');
        insert maincon;

        Account acc = [SELECT Id, Name FROM Account WHERE RecordType.Name='Candidate' LIMIT 1];
        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        insert con;

        sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
        insert ct;

        sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
        insert sec;

        sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
        insert jobcate;

        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
        insert tpz;

        sirenum__Site__c site = new sirenum__Site__c();
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc1.id;
        site.IP_ClientIDLegacy__c='123';
        site.GlobalClientName__c=tpz.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';
        site.IP_InvoiceContact__c = maincon.id;
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;

        sirenum__Rate_Card__c rc = new sirenum__Rate_Card__c();
        rc.sirenum__Job_Type__c = jobcate.id;
        rc.sirenum__Sirenum_Contract__c = ct.id;
        rc.sirenum__Site__c = site.id;
        rc.sirenum__Account__c = acc.id;
        insert rc;

        sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
        job.sirenum__Rate_Card__c = rc.id;
        insert job;

        sirenum__Rate_Card_Page__c rcp = new sirenum__Rate_Card_Page__c ();
        rcp.sirenum__Condition_Suggestions__c = 'Contact__c';
        rcp.sirenum__Condition_Operator__c = 'Equal to';
        rcp.sirenum__Condition_value__c = con.id;
        rcp.sirenum__Rate_Card__c = rc.id;
        rcp.sirenum__Valid_From_Date__c  = System.today().addDays(1);
        rcp.sirenum__Valid_Until_Date__c = System.today().addDays(2);
        rcp.sirenum__SortOrder__c = 0;
        insert rcp;

        sirenum__Rate_Card_Page__c rcp1 = new sirenum__Rate_Card_Page__c ();
        rcp1.sirenum__Condition_Suggestions__c = 'AWR';
        rcp1.sirenum__Condition_Operator__c = 'Equal to';
        rcp1.sirenum__Condition_value__c = 'Checked';
        rcp1.sirenum__Rate_Card__c = rc.id;
        rcp1.sirenum__Valid_From_Date__c  = System.today().addDays(1);
        rcp1.sirenum__Valid_Until_Date__c = System.today().addDays(2);
        rcp1.sirenum__SortOrder__c = 1;
        insert rcp1;

        sirenum__Rate_Line__c rl = new sirenum__Rate_Line__c();
        rl.sirenum__Rate_Card_Page__c = rcp.id;
        rl.sirenum__Day_Type__c= 'Any Day';
        rl.sirenum__Pay_Rate__c = 12;
        rl.sirenum__Code__c = 'P1';
        rl.sirenum__Charge_Rate__c = 12;
        rl.sirenum__SortOrder__c = 0;
        insert rl;

        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = TestDataFactory.createUsers(p.id,1)[0];
        u.IP_TempestDepartment__c = '2043';
        u.username = 'jhy@123.com';
        u.Brand__c = 'Blue Arrow';
        insert u;

        sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
        ps.sirenum__Start_Date__c = System.today();
        ps.sirenum__End_Date__c = System.today().addDays(15);
        ps.sirenum__Rota__c = sec.id;
        ps.sirenum__site__c = site.id;
        ps.IP_Consultant1LookupSplitShare__c=u.Id;
        insert ps;
        system.debug('$$Placement created'+ps);

        sirenum__Shift__c shft = TestDataFactory.createShift(ps.id,site.id,1)[0];
        shft.sirenum__Rota__c = sec.id;
        insert shft;

        test.startTest();
            PageReference pageRef = Page.CandidateTemplate;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ps);
            ApexPages.currentPage().getParameters().put('Id',ps.id);

            Candtemplatedata temp = new Candtemplatedata(sc);
            temp.createtask();
            temp.getratelines();
            temp.getrate1();
            temp.getrate2();
        test.stopTest();
    }

}