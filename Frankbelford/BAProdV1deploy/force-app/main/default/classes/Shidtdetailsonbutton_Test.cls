@isTest
public class Shidtdetailsonbutton_Test {
    @TestSetup
    public static void setupTestData(){
        TestDataFactory.setupUserProfileCustomSettings();
    }
    
    public static testmethod void shiftdetails1(){
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
        //insert new IP_Shift_Template__c(name = '8004', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');
        insert new IP_Shift_Template__c(name = '1181', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='E12 3SS',Branch_Address__c='street1',Email__c='no.reply@bluearrow.co.uk',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');

        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        TestDataFactory.setupCustomSettings(acc.Id);

        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = TestDataFactory.createUsers(p.id,1)[0];
        u.Email = 'jhy@123.com';
        u.username = 'jhy@123.com';
        u.IP_TempestDepartment__c = '1181';
        u.Brand__c='Blue Arrow';
        insert u;

        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        con.Email = 'test23432@abc.com';
        con.OwnerId = u.Id;
        insert con;

        sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
        insert ct;

        sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
        insert sec;

        sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
        insert jobcate;

        sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
        insert job;

        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
        insert tpz;

        sirenum__site__c site = TestDataFactory.createSites(acc.id,tpz.id,1)[0];
        site.IP_PassClientToTempest__c=false;
        site.IP_PassClientAddressToTempest__c=false;
        site.OwnerId = u.Id;
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
            ShiftDetailsonButton.sendemail(ps.id);
            pageReference pdfPage = Page.CandidateTemplate;
            pdfPage.getParameters().put('id',String.valueOf(ps.id));
            Integer invocations = Limits.getEmailInvocations();
        }
        test.stopTest();
    }

    public static testmethod void shiftdetails2(){
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
        insert new IP_Shift_Template__c(name = '1181', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='GG12 3XX',Branch_Address__c='street1',Email__c='no.reply@bluearrow.co.uk',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');

        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        TestDataFactory.setupCustomSettings(acc.Id);

        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = TestDataFactory.createUsers(p.id,1)[0];
        u.Email = 'jhy@123.com';
        u.username = 'jhy@123.com';
        u.IP_TempestDepartment__c = '1181';
        u.Brand__c='Tate';
        insert u;

        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        con.Email = 'test@abc.com';
        con.OwnerId = u.Id;
        insert con;

        sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
        insert ct;

        sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
        insert sec;

        sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
        insert jobcate;

        sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
        insert job;

        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
        insert tpz;

        sirenum__site__c site = TestDataFactory.createSites(acc.id,tpz.id,1)[0];
        site.IP_PassClientToTempest__c=false;
        site.IP_PassClientAddressToTempest__c=false;
        site.OwnerId = u.Id;
        insert site;

        sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
        ps.sirenum__site__c = site.id;
        ps.IP_Consultant1LookupSplitShare__c = u.Id;
        insert ps;

        system.debug('$$Placement created'+ps.IP_TempestDepartment__c);

        sirenum__Shift__c shft = TestDataFactory.createShift(ps.id,site.id,1)[0];
        insert shft;

        test.startTest();
        System.runAs(u) {
            ShiftDetailsOnButtonLightning.getSPlacementDetail(ps.id);
            ShiftDetailsOnButtonLightning.sendSiteEmailToCandidate(ps);
        }
        test.stopTest();
    }
    
    public static testmethod void shiftdetails3(){
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
        insert new IP_Shift_Template__c(name = '1181', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='EE1 2SS',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');

        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        TestDataFactory.setupCustomSettings(acc.Id);

        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        con.Email = 'test@abc.com';
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
        u.username = 'jhy@123.com';
        u.IP_TempestDepartment__c = '1181';
        u.Brand__c='Blue Arrow';
        insert u;

        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
        insert tpz;

        sirenum__site__c site = TestDataFactory.createSites(acc.id,tpz.id,1)[0];
        site.IP_PassClientToTempest__c=false;
        site.IP_PassClientAddressToTempest__c=false;
        insert site;

        sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
        ps.sirenum__site__c = site.id;
        ps.IP_Shift_Details_sent__c = TRUE;  
        insert ps;
        system.debug('$$Placement created'+ps.IP_TempestDepartment__c);

        sirenum__Shift__c shft = TestDataFactory.createShift(ps.id,site.id,1)[0];
        insert shft;

        test.startTest();

        ShiftDetailsOnButtonLightning.getSPlacementDetail(ps.id);
        ShiftDetailsOnButtonLightning.sendSiteEmailToCandidate(ps);

        test.stopTest();
    }
    
    public static testmethod void shiftdetails4(){
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
        insert new IP_Shift_Template__c(name = '1181', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='EE12 4TT',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');

        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        TestDataFactory.setupCustomSettings(acc.Id);

        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        con.Email = 'test@abc.com';
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
        u.username = 'jhy@123.com';
        u.IP_TempestDepartment__c = '1181';
        u.Brand__c='Tate';
        insert u;

        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
        insert tpz;

        sirenum__site__c site = TestDataFactory.createSites(acc.id,tpz.id,1)[0];
        site.IP_PassClientToTempest__c=false;
        site.IP_PassClientAddressToTempest__c=false;
        insert site;

        sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
        ps.sirenum__site__c = site.id;
        ps.IP_Shift_Details_sent__c = false;
        ps.sirenum__Status__c ='Inactive';
        insert ps;
        system.debug('$$Placement created'+ps.IP_TempestDepartment__c);

        sirenum__Shift__c shft = TestDataFactory.createShift(ps.id,site.id,1)[0];
        insert shft;

        test.startTest();

        ShiftDetailsOnButtonLightning.getSPlacementDetail(ps.id);
        ShiftDetailsOnButtonLightning.sendSiteEmailToCandidate(ps);

        test.stopTest();
    }
    
    public static testmethod void shiftdetails5(){
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
        insert new IP_Shift_Template__c(name = '1181', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='E12 3EE',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');

        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        TestDataFactory.setupCustomSettings(acc.Id);

        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        con.Email = '';
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
        u.username = 'jhy@123.com';
        u.IP_TempestDepartment__c = '1181';
        u.Brand__c='Blue Arrow';
        insert u;

        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
        insert tpz;

        sirenum__site__c site = TestDataFactory.createSites(acc.id,tpz.id,1)[0];
        site.IP_PassClientToTempest__c=false;
        site.IP_PassClientAddressToTempest__c=false;
        insert site;

        sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
        ps.sirenum__site__c = site.id;
        ps.IP_Shift_Details_sent__c = false;
        ps.sirenum__Status__c ='Active';
        insert ps;
        system.debug('$$Placement created'+ps.IP_TempestDepartment__c);

        sirenum__Shift__c shft = TestDataFactory.createShift(ps.id,site.id,1)[0];
        insert shft;

        test.startTest();

        ShiftDetailsOnButtonLightning.getSPlacementDetail(ps.id);
        ShiftDetailsOnButtonLightning.sendSiteEmailToCandidate(ps);

        test.stopTest();
    }
}