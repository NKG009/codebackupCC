@isTest
public class SiteContactLinkController_Test {

    public static testmethod void contactsite1(){
        Account client1 = TestDataFactory.createClients(1)[0];
        insert client1;

        Account candacc = TestDataFactory.createCandidateAccount(1)[0];
        insert candacc;

        Account acccon = TestDataFactory.createAccounts(1)[0];
        insert acccon;

        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact candidateid = TestDataFactory.createCandidate(candacc.id,1)[0];
        insert candidateid;

        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact con = TestDataFactory.createContact(acccon.id,1)[0];
        //   con.IP_ContactType__c = 'Invoice Contact';
        insert con;

        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact con1 = TestDataFactory.createContact(acccon.id,1)[0];
        con1.FirstName = 'Test anc';
        con1.Lastname = 'test link';
        //  con1.IP_ContactType__c = 'Invoice Contact';
        con1.Email = 'test12313@ab.com';
        insert con1;

        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = TestDataFactory.createUsers(p.id, 1)[0];
        u.username = 'Test.espiredevhdh@test.com';
        u.IP_TempestDepartment__c = '1062';
        insert u;

        IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
        topaz.IP_SalesLedgerNumber__c = '645628';
        insert topaz;

        sirenum__Site__c site1 = TestDataFactory.createSites(acccon.id,topaz.id,1)[0];
        site1.IP_ClientIDLegacy__c = '1234'; 
        site1.IP_ClientInvoiceName__c = 'Testname';
        site1.IP_InvoiceAddressStreet__c = 'street1';
        site1.IP_InvoiceAddressCity__c = 'city1';
        site1.IP_InvoiceAddressPostcode__c = '7554';
        site1.IP_PublicSector__c = 'No';
        site1.IP_MainContact__c = con.id;
        site1.IP_InvoiceContact__c = con.id;
        site1.IP_PassClientToTempest__c = false;
        insert site1;
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(site1);               
        SiteContactLinkController permgenerate = new SiteContactLinkController(sc);
        List<SelectOption> selectedcontact=permgenerate.allcontacts;
        // permgenerate.linksite2();
        permgenerate.createmyString='Primary Hours Approver';
        permgenerate.fname = 'abc';
        permgenerate.lname ='xyz';
        permgenerate.createlink();
        permgenerate.closepage();
        Test.stopTest();
    }
     
    public static testmethod void contactsite2(){
        Account client1 = TestDataFactory.createClients(1)[0];
        insert client1;

        Account candacc = TestDataFactory.createCandidateAccount(1)[0];
        insert candacc;

        Account acccon = TestDataFactory.createAccounts(1)[0];
        insert acccon;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact candidateid = TestDataFactory.createCandidate(candacc.id,1)[0];
        insert candidateid;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact con = TestDataFactory.createContact(acccon.id,1)[0];
        //   con.IP_ContactType__c = 'Invoice Contact';
        insert con;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact con1 = TestDataFactory.createContact(acccon.id,1)[0];
        con1.FirstName = 'Test anc';
        con1.Lastname = 'test link';
        //   con1.IP_ContactType__c = 'Invoice Contact';
        con1.email = 'test123@abc.com';
        insert con1;

        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = TestDataFactory.createUsers(p.id, 1)[0];
        u.username = 'Test.espiwewredev@test.com';
        u.IP_TempestDepartment__c = '1062';
        insert u;

        IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
        topaz.IP_SalesLedgerNumber__c = '645628';
        insert topaz;

        sirenum__Site__c site1 = TestDataFactory.createSites(acccon.id,topaz.id,1)[0];
        site1.IP_ClientIDLegacy__c = '1234'; 
        site1.IP_ClientInvoiceName__c = 'Testname';
        site1.IP_InvoiceAddressStreet__c = 'street1';
        site1.IP_InvoiceAddressCity__c = 'city1';
        site1.IP_InvoiceAddressPostcode__c = '7554';
        site1.IP_PublicSector__c = 'No';
        site1.IP_MainContact__c = con.id;
        site1.IP_InvoiceContact__c = con.id;
        site1.IP_PassClientToTempest__c = false;
        insert site1;
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(site1);               
        SiteContactLinkController permgenerate = new SiteContactLinkController(sc);
        List<SelectOption> selectedcontact=permgenerate.allcontacts;
        permgenerate.selectedcontact = con1.Id;

        permgenerate.myString='Primary Hours Approver';
        permgenerate.createmyString='Primary Hours Approver';
        permgenerate.hidvalue = 'test@gmail.com';
        permgenerate.linksite2();
        permgenerate.fname = 'abc';
        permgenerate.createlink();
        permgenerate.closepage();
        Test.stopTest();
    }
    
    public static testmethod void contactsiteSelectedContactnull(){
        Account client1 = TestDataFactory.createClients(1)[0];
        insert client1;

        Account candacc = TestDataFactory.createCandidateAccount(1)[0];
        insert candacc;

        Account acccon = TestDataFactory.createAccounts(1)[0];
        insert acccon;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact candidateid = TestDataFactory.createCandidate(candacc.id,1)[0];
        insert candidateid;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact con = TestDataFactory.createContact(acccon.id,1)[0];
        //   con.IP_ContactType__c = 'Invoice Contact';
        insert con;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact con1 = TestDataFactory.createContact(acccon.id,1)[0];
        con1.FirstName = 'Test anc';
        con1.Lastname = 'test link';
        //   con1.IP_ContactType__c = 'Invoice Contact';
        con1.email = 'test123@abc.com';
        insert con1;

        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = TestDataFactory.createUsers(p.id, 1)[0];
        u.username = 'Test.espiwewredev@test.com';
        u.IP_TempestDepartment__c = '1062';
        insert u;

        IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
        topaz.IP_SalesLedgerNumber__c = '645628';
        insert topaz;

        sirenum__Site__c site1 = TestDataFactory.createSites(acccon.id,topaz.id,1)[0];
        site1.IP_ClientIDLegacy__c = '1234'; 
        site1.IP_ClientInvoiceName__c = 'Testname';
        site1.IP_InvoiceAddressStreet__c = 'street1';
        site1.IP_InvoiceAddressCity__c = 'city1';
        site1.IP_InvoiceAddressPostcode__c = '7554';
        site1.IP_PublicSector__c = 'No';
        site1.IP_MainContact__c = con.id;
        site1.IP_InvoiceContact__c = con.id;
        site1.IP_PassClientToTempest__c = false;
        insert site1;
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(site1);               
        SiteContactLinkController permgenerate = new SiteContactLinkController(sc);
        List<SelectOption> selectedcontact=permgenerate.allcontacts;
        //permgenerate.selectedcontact = con1.Id;

        permgenerate.myString='Primary Hours Approver';
        permgenerate.createmyString='Primary Hours Approver';
        permgenerate.hidvalue = '';
        permgenerate.linksite2();
        permgenerate.fname = 'abc';
        permgenerate.createlink();
        permgenerate.closepage();
        Test.stopTest();
    }
       
    public static testmethod void contactsite3(){
        Account client1 = TestDataFactory.createClients(1)[0];
        insert client1;

        Account candacc = TestDataFactory.createCandidateAccount(1)[0];
        insert candacc;

        Account acccon = TestDataFactory.createAccounts(1)[0];
        insert acccon;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact candidateid = TestDataFactory.createCandidate(candacc.id,1)[0];
        insert candidateid;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact con = TestDataFactory.createContact(acccon.id,1)[0];
        //   con.IP_ContactType__c = 'Invoice Contact';
        insert con;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact con1 = TestDataFactory.createContact(acccon.id,1)[0];
        con1.FirstName = 'Test anc';
        con1.Lastname = 'test link';
        //   con1.IP_ContactType__c = 'Invoice Contact';

        insert con1;

        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = TestDataFactory.createUsers(p.id, 1)[0];
        u.username = 'Test.espiwewredev@test.com';
        u.IP_TempestDepartment__c = '1062';
        insert u;

        IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
        topaz.IP_SalesLedgerNumber__c = '645628';
        insert topaz;

        sirenum__Site__c site1 = TestDataFactory.createSites(acccon.id,topaz.id,1)[0];
        site1.IP_ClientIDLegacy__c = '1234'; 
        site1.IP_ClientInvoiceName__c = 'Testname';
        site1.IP_InvoiceAddressStreet__c = 'street1';
        site1.IP_InvoiceAddressCity__c = 'city1';
        site1.IP_InvoiceAddressPostcode__c = '7554';
        site1.IP_PublicSector__c = 'No';
        site1.IP_MainContact__c = con.id;
        site1.IP_InvoiceContact__c = con.id;
        site1.IP_PassClientToTempest__c = false;
        insert site1;
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(site1);               
        SiteContactLinkController permgenerate = new SiteContactLinkController(sc);
        List<SelectOption> selectedcontact=permgenerate.allcontacts;
        permgenerate.selectedcontact = con1.Id;

        permgenerate.myString='Primary Hours Approver;Escalation Hours Approver';

        permgenerate.hidvalue = '';
        permgenerate.linksite2();
        permgenerate.fname = 'abc';
        //   permgenerate.createlink();
        //  permgenerate.closepage();
        Test.stopTest();
    }
    
    public static testmethod void contactsite4(){
        Account client1 = TestDataFactory.createClients(1)[0];
        insert client1;

        Account candacc = TestDataFactory.createCandidateAccount(1)[0];
        insert candacc;

        Account acccon = TestDataFactory.createAccounts(1)[0];
        insert acccon;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact candidateid = TestDataFactory.createCandidate(candacc.id,1)[0];
        insert candidateid;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact con = TestDataFactory.createContact(acccon.id,1)[0];
        //   con.IP_ContactType__c = 'Invoice Contact';
        insert con;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact con1 = TestDataFactory.createContact(acccon.id,1)[0];
        con1.FirstName = 'Test anc';
        con1.Lastname = 'test link';
        // con1.IP_ContactType__c = 'Invoice Contact';

        insert con1;

        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = TestDataFactory.createUsers(p.id, 1)[0];
        u.username = 'Test.espiwewredev@test.com';
        u.IP_TempestDepartment__c = '1062';
        insert u;

        IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
        topaz.IP_SalesLedgerNumber__c = '645628';
        insert topaz;

        sirenum__Site__c site1 = TestDataFactory.createSites(acccon.id,topaz.id,1)[0];
        site1.IP_ClientIDLegacy__c = '1234'; 
        site1.IP_ClientInvoiceName__c = 'Testname';
        site1.IP_InvoiceAddressStreet__c = 'street1';
        site1.IP_InvoiceAddressCity__c = 'city1';
        site1.IP_InvoiceAddressPostcode__c = '7554';
        site1.IP_PublicSector__c = 'No';
        site1.IP_MainContact__c = con.id;
        site1.IP_InvoiceContact__c = con.id;
        site1.IP_PassClientToTempest__c = false;
        insert site1;
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(site1);               
        SiteContactLinkController permgenerate = new SiteContactLinkController(sc);
        List<SelectOption> selectedcontact=permgenerate.allcontacts;
        permgenerate.selectedcontact = con1.Id;

        permgenerate.createmyString='Primary Hours Approver;Escalation Hours Approver';

        permgenerate.hidvalue = '';
        //   permgenerate.linksite2();
        permgenerate.fname = 'abc';
        permgenerate.createlink();
        //  permgenerate.closepage();
        Test.stopTest();
    }
    
    public static testmethod void contactsite5(){
        Account client1 = TestDataFactory.createClients(1)[0];
        insert client1;

        Account candacc = TestDataFactory.createCandidateAccount(1)[0];
        insert candacc;

        Account acccon = TestDataFactory.createAccounts(1)[0];
        insert acccon;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact candidateid = TestDataFactory.createCandidate(candacc.id,1)[0];
        insert candidateid;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact con = TestDataFactory.createContact(acccon.id,1)[0];
        //   con.IP_ContactType__c = 'Invoice Contact';
        insert con;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact con1 = TestDataFactory.createContact(acccon.id,1)[0];
        con1.FirstName = 'Test anc';
        con1.Lastname = 'test link';
        // con1.IP_ContactType__c = 'Invoice Contact';
        insert con1;    

        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = TestDataFactory.createUsers(p.id, 1)[0];
        u.username = 'Test.espiwewredev@test.com';
        u.IP_TempestDepartment__c = '1062';
        insert u;

        IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
        topaz.IP_SalesLedgerNumber__c = '645628';
        insert topaz;

        sirenum__Site__c site1 = TestDataFactory.createSites(acccon.id,topaz.id,1)[0];
        site1.IP_ClientIDLegacy__c = '1234'; 
        site1.IP_ClientInvoiceName__c = 'Testname';
        site1.IP_InvoiceAddressStreet__c = 'street1';
        site1.IP_InvoiceAddressCity__c = 'city1';
        site1.IP_InvoiceAddressPostcode__c = '7554';
        site1.IP_PublicSector__c = 'No';
        site1.IP_MainContact__c = con.id;
        site1.IP_InvoiceContact__c = con.id;
        site1.IP_PassClientToTempest__c = false;
        insert site1;
        
        Contact_Site_link__c csl = new Contact_Site_link__c();
        csl.Account__c = acccon.id;
        csl.IP_Contact__c = con.id;
        csl.IP_PortalType__c = 'Primary Hours Approver';
        csl.IP_Site__c = site1.id;        
        insert csl;
        
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(site1);               
        SiteContactLinkController permgenerate = new SiteContactLinkController(sc);
        List<SelectOption> selectedcontact=permgenerate.allcontacts;
        permgenerate.selectedcontact = con1.Id;

        permgenerate.createmyString='Primary Hours Approver;Escalation Hours Approver';

        permgenerate.hidvalue = '';
        //   permgenerate.linksite2();
        permgenerate.fname = 'abc';
        permgenerate.createlink();
        //  permgenerate.closepage();
        Test.stopTest();
    }
}