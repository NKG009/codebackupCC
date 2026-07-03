@isTest
public class SitedetailsonButton_Test {
public static testmethod void sitedetails1(){
            insert new IP_Shift_Template__c(name = '1062', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');

Account acc =  TestDataFactory.createCandidateAccount(1)[0];
insert acc;
insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
insert con;

sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
insert ct;

sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
insert sec;

sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
insert jobcate;

sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
insert job;

Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
User u = TestDataFactory.createUsers(p.id,1)[0];
    u.IP_TempestDepartment__c = '1062';
u.username = 'jhy@123.com';
insert u;

IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
insert tpz;

sirenum__site__c site = TestDataFactory.createSites(acc.id,tpz.id,1)[0];
    site.IP_PassClientToTempest__c = false;
    site.IP_PassClientAddressToTempest__c=false;
insert site;
    
sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
ps.sirenum__site__c = site.id;
insert ps;
    system.debug('$$Placement created'+ps);
    
    sirenum__Shift__c shft = TestDataFactory.createShift(ps.id,site.id,1)[0];
    insert shft;

test.startTest();

        SitedetailsonButton.sendsiteemail(site.id);
        pageReference pdfPage = Page.Site_Candidate_Template;
        pdfPage.getParameters().put('id',String.valueOf(site.id));

        Integer invocations = Limits.getEmailInvocations();
test.stopTest();
}
public static testmethod void sitedetails2(){
            insert new IP_Shift_Template__c(name = '1181', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');
RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 

        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc1;
    
Account acc =  TestDataFactory.createCandidateAccount(1)[0];
insert acc;
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
Contact con = TestDataFactory.createCandidate(acc.id,1)[0];

insert con;
RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
      
           Contact maincon = new Contact(RecordTypeId=maincondRec.id,email='test@abc.com',FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
    
    insert maincon;
sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
insert ct;

sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
insert sec;

sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
insert jobcate;

sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
insert job;

Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
User u = TestDataFactory.createUsers(p.id,1)[0];
    u.IP_TempestDepartment__c = '1181';
u.username = 'jhy@123.com';
insert u;
 
IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
        globalclient.IP_SalesLedgerNumber__c='123';
        insert globalclient;

        sirenum__Site__c site = new sirenum__Site__c();
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc1.id;
        site.IP_ClientIDLegacy__c='123';
        site.GlobalClientName__c=globalclient.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';
        site.sirenum__Street_Address__c = 'ABC';
        site.sirenum__City__c = 'ABC';
      //  site.IP_InvoiceContact__c = maincon.id;
        site.IP_InvoiceContactText__c = 'Test12';
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
    site.Email_Shifts_to_Client__c = TRUE;
        insert site;

 System.debug('insert site'+site);
    
sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
ps.sirenum__site__c = site.id;
insert ps;
   
    
    sirenum__Shift__c shft = TestDataFactory.createShift(ps.id,site.id,1)[0];
    insert shft;

test.startTest();
SitedetailsOnButtonLightning.getSiteDetail(site.id);
//SitedetailsOnButtonLightning.sendSiteEmailToCandidate(site);
        
test.stopTest();
}

}