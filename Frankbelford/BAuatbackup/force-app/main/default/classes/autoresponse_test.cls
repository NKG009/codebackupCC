@isTest
public class autoresponse_test {
    static testMethod void test() {
        insert new IP_Shift_Template__c(name = '1062', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Phone__c='54735622');
        Profile Prof=[SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];

        Account client = TestDataFactory.createClients(1)[0];
        Insert client;

        Account account = TestDataFactory.createAccounts(1)[0];
        Insert account;

        Account accountcan = TestDataFactory.createCandidateAccount(1)[0];
        Insert accountcan;

        TestDataFactory.setupCustomSettings(accountcan.Id);
        TestDataFactory.setupUserProfileCustomSettings();

        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact cont = TestDataFactory.createContact(client.id, 1)[0];

        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=true);

        Insert cont;

        Recordtype rt1= [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
        contact con1 = new contact();
        con1.RecordTypeId=rt1.id;
        con1.AccountId=account.id;
        con1.FirstName='Vandita Test';
        con1.LastName='Kakkar Test';
        con1.IP_ContactType__c='Invoice Contact';
        insert con1;

        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=true);
        Insert candidate;


        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
        Insert tpz;
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'pokygj123@yts.com';
        usr.IP_TempestDepartment__c='2043';
        usr.IP_TempestID__c='1084675';
        usr.IP_TempestDivision__c='NTS';
        insert usr;

        sirenum__Site__c site = new sirenum__Site__c();

        site.Name = 'NewSite';
        site.sirenum__Operating_Company__c= account.id;
        site.IP_ClientIDLegacy__c ='QAWWSED34';
        site.IP_ClientInvoiceName__c='Test Invoice';
        site.IP_InvoiceAddressStreet__c='Test Street';
        site.IP_PublicSector__c='No';
        site.GlobalClientName__c= tpz.Id;
        site.sirenum__Postal_Code__c='124678';
        site.sirenum__City__c='New Delhi';
        site.IP_PublicSector__c='NO';

        site.IP_MainContact__c=con1.id;
        site.IP_InvoiceContact__c=con1.id;

        site.OwnerId=usr.id;
        site.IP_InvoiceAddressCity__c='Delhi';
        insert site;
        system.debug('Value in site'+ site);



        ts2__Job__c jb = TestDataFactory.createT2Job(usr.id, 1)[0];
        jb.ts2__Account__c = accountcan.id;
        jb.ts2__Contact__c = candidate.id;
        jb.sirenum_js__Site__c = site.id;
        jb.IP_Fixed_Fee__c = 100;
        Insert jb;

        ts2__Application__c app = new ts2__Application__c();
        app.ts2__Candidate_Contact__c = con1.id;
        app.ts2__Job__c = jb.id;
        insert app;
    }
    static testMethod void test1() {
        insert new IP_Shift_Template__c(name = '2043', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Phone__c='54735622');
        Profile Prof=[SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];

        Account client = TestDataFactory.createClients(1)[0];
        Insert client;

        Account account = TestDataFactory.createAccounts(1)[0];
        Insert account;

        Account accountcan = TestDataFactory.createCandidateAccount(1)[0];
        Insert accountcan;

        TestDataFactory.setupCustomSettings(accountcan.Id);
        TestDataFactory.setupUserProfileCustomSettings();


        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact cont = TestDataFactory.createContact(client.id, 1)[0];

        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=true);

        Insert cont;

        Recordtype rt1= [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
        contact con1 = new contact();

        con1.RecordTypeId=rt1.id;
        con1.AccountId=account.id;
        con1.FirstName='Vandita Test';
        con1.LastName='Kakkar Test';
        con1.IP_ContactType__c='Invoice Contact';
        insert con1;

        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=true);
        candidate.Email ='abc@gmail.com';

        Insert candidate;


        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
        Insert tpz;
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'pokygj123@yts.com';
        usr.IP_TempestDepartment__c='2043';
        usr.IP_TempestID__c='1084675';
        usr.IP_TempestDivision__c='NTS';
        usr.Brand__c='Blue Arrow';
        insert usr;

        sirenum__Site__c site = new sirenum__Site__c();

        site.Name = 'NewSite';
        site.sirenum__Operating_Company__c= account.id;
        site.IP_ClientIDLegacy__c ='QAWWSED34';
        site.IP_ClientInvoiceName__c='Test Invoice';
        site.IP_InvoiceAddressStreet__c='Test Street';
        site.IP_PublicSector__c='No';
        site.GlobalClientName__c= tpz.Id;
        site.sirenum__Postal_Code__c='124678';
        site.sirenum__City__c='New Delhi';
        site.IP_PublicSector__c='NO';
        site.IP_MainContact__c=con1.id;
        site.IP_InvoiceContact__c=con1.id;
        site.OwnerId=usr.id;
        site.IP_InvoiceAddressCity__c='Delhi';
        insert site;
        system.debug('Value in site'+ site);

        ts2__Job__c jb = TestDataFactory.createT2Job(usr.id, 1)[0];
        jb.ts2__Account__c = accountcan.id;
        jb.ts2__Contact__c = con1.id;
        jb.sirenum_js__Site__c = site.id;
        jb.IP_Fixed_Fee__c = 100;
        jb.OwnerId = usr.Id;
        Insert jb;

        ts2__Application__c app = new ts2__Application__c();
        app.ts2__Candidate_Contact__c = candidate.id;
        app.ts2__Job__c = jb.id;
        app.ts2__PrimaryRecruiter__c=usr.Id;
        insert app;
        app.ts2__Application_Status__c = 'Rejected';
        update app;

        Test.startTest();
        autoresponse auto = new autoresponse();
        auto.record_Id = app.id;

        auto.getconid();

        Test.stopTest();
    }

}