@isTest
public class PortalSiteSetupApx_TEST {
    public static testmethod void Method1(){
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
        PortalSiteSetupApx.sitesetup(site1.id);
        Contact_Site_link__c csl = new Contact_Site_link__c();
        csl.Account__c = acccon.id;
        csl.IP_Contact__c = con.id;
        csl.IP_PortalType__c = 'Primary Hours Approver';
        csl.IP_Site__c = site1.id;        
        insert csl;
        PortalSiteSetupApx.sitesetup(site1.id);
         
        
    }

}