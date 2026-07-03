@isTest
public class SitedetailsOnButtonLightningTest {
    @TestSetup
    public static void setupTestData(){
        TestDataFactory.setupUserProfileCustomSettings();
    }

    public static testmethod void sitedetails1(){
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
        insert new IP_Shift_Template__c(name = '1107', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='E12 3SS',Branch_Address__c='street1',Email__c='no.reply@bluearrow.co.uk',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');

        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        TestDataFactory.setupCustomSettings(acc.Id);

        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = TestDataFactory.createUsers(p.id,1)[0];
        u.Email = 'jhy@123.com';
        u.username = 'jhy@123.com';
        u.IP_TempestDepartment__c = '1107';
        u.Brand__c='Blue Arrow';
        insert u;

        Account account = TestDataFactory.createAccounts(1)[0];
        account.OwnerId = u.Id;
        Insert account;

        contact con2 = TestDataFactory.createContact(account.Id,1)[0];
        con2.OwnerId = u.Id;
        insert con2;

        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        con.Email = 'test23432@abc.com';
        con.OwnerId = u.Id;
        insert con;

        sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(account.id,con.id,1)[0];
        insert ct;

        sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
        insert sec;

        sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
        insert jobcate;

        sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
        insert job;

        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
        insert tpz;

        sirenum__site__c site = TestDataFactory.createSites(account.id,tpz.id,1)[0];
        site.IP_PassClientToTempest__c=false;
        site.IP_PassClientAddressToTempest__c=false;
        site.OwnerId = u.Id;
        site.IP_MainContact__c = con2.Id;
        insert site;

        sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
        ps.sirenum__site__c = site.id;
        ps.IP_Consultant1LookupSplitShare__c = u.Id;
        insert ps;
        system.debug('$$Placement created'+ps);

        sirenum__Shift__c shft = TestDataFactory.createShift(ps.id,site.id,1)[0];
        insert shft;

        test.startTest();
        System.runAs(u){
            SitedetailsOnButtonLightning.getSiteDetail(site.id);
            SitedetailsOnButtonLightning.sendSiteEmailToCandidate(site);
            Integer invocations = Limits.getEmailInvocations();
        }
        test.stopTest();
    }
    
}