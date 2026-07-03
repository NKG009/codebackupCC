@istest
public class ManualPDFgenerate_test{

public static testmethod void pdfgenerate1(){
    insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
Account acc =  TestDataFactory.createCandidateAccount(1)[0];
insert acc;
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

IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
insert tpz;

sirenum__site__c site = TestDataFactory.createSites(acc.id,tpz.id,1)[0];
site.IP_PassClientToTempest__c = false;
insert site;

Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
User u = TestDataFactory.createUsers(p.id,1)[0];
u.username = 'abc.test0987@test.com';
u.IP_TempestDepartment__c = '1062';
insert u;

sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
ps.sirenum__site__c = site.id;
insert ps;

    test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(ps);               
        ManualPDFgenerate pdfgenerate = new ManualPDFgenerate(sc);   
        pdfgenerate.getpayrollweek();
        pdfgenerate.getpayrollyear(); 
        pdfgenerate.selectedpayrollweek = String.valueof(ps.Current_week__c);
        pdfgenerate.selectedpayrollyear = String.valueof(ps.Current_year__c);
        sirenum__Placement__c place = new sirenum__Placement__c(id=ps.id,Payroll_week__c = pdfgenerate.selectedpayrollweek,Payroll_year__c = pdfgenerate.selectedpayrollyear);
        update place;
        pdfgenerate.saverecord();
        pdfgenerate.printt();
    test.stopTest();


}
public static testmethod void pdfgeneratelightning(){
    insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
    insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
Account acc =  TestDataFactory.createCandidateAccount(1)[0];
insert acc;
Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
    con.email = 'test.class@impellam.com';
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
site.IP_PassClientToTempest__c = false;
insert site;

Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
User u = TestDataFactory.createUsers(p.id,1)[0];
u.username = 'abc.test0987@test.com';
u.IP_TempestDepartment__c = '1062';
insert u;

sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
ps.sirenum__site__c = site.id;
insert ps;

    test.startTest();
        ManualPDFGenerateLightning.sPlacementGetDetails(ps.id);
        ManualPDFGenerateLightning.saveRecord(ps.id,'50','2019');
        ManualPDFGenerateLightning.printTimesheet(ps.id,'50','2019');
    	ManualPDFGenerateLightning ml = new ManualPDFGenerateLightning();
    	ml.closePage();
    test.stopTest();


}

}