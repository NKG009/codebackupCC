@isTest
public class CandidateDetails_Test {
public static testmethod void testEmailComp()
{
    Payroll_Swtich__c pay = new Payroll_Swtich__c();
        pay.Name = 'Stoppayroll'; // Match the name expected by the trigger
        pay.Batch_check__c = true;
        insert pay;
          
insert new IP_Shift_Template__c(name = '0000', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='test@abc.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');
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

Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
User u = TestDataFactory.createUsers(p.id,1)[0];
u.username = 'jhy@123.com';
insert u;

IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
insert tpz;

sirenum__site__c site = TestDataFactory.createSites(acc.id,tpz.id,1)[0];
insert site;
    
sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
ps.sirenum__site__c = site.id;
insert ps;
    system.debug('$$Placement created'+ps);
    
    sirenum__Shift__c shft = TestDataFactory.createShift(ps.id,site.id,1)[0];
    shft.sirenum__Rota__c = sec.id;
    insert shft;

           Test.startTest();
           Candidatedetails obj = new Candidatedetails();
    obj.record_id=ps.id;
           obj.getplaceid();
           Test.stopTest();

}
}