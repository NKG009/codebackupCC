@isTest
public class Test_Reinstatedtemplatedata {
public static testmethod void testvfComp()
{
Account acc =  TestDataFactory.createCandidateAccount(1)[0];
insert acc;
Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
    con.Passport_Expiration_Date__c = System.today(); 
insert con;
     insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
    RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];
       
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='Active';
        pay.IP_Candidate__c=con.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        pay.P45_Initiated__c=true;
        pay.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
        pay.IP_Payroll_Leaver__c = 'PL';
        insert pay;
      RecordType rt1=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'LTD'];
       
        IP_PayProfile__c pay1= new IP_PayProfile__c();
        pay1.RecordTypeId=rt1.id;
        pay1.IP_PayrollID__c='Test8009';
        pay1.IP_Status__c='Active';
        pay1.IP_Candidate__c=con.Id;
        pay1.IP_CompanyRegNo__c='12345678';
        pay1.IP_VATRegistered__c=true;
        pay1.IP_VATNumber__c='123456789';
        pay1.P45_Initiated__c=true;
        pay1.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
       
        insert pay1;
    
       id certId = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Driving Licence').getRecordTypeId();
        ts2__Certification__c cert = new ts2__Certification__c();
        cert.ts2__Contact__c = con.id;
        cert.RecordTypeId = certId;
        cert.Valid_From__c = System.today();
        cert.Valid_To__c = System.today().addDays(10);
        cert.Verfied__c = false;
    cert.IP_Status__c = 'Lapsed';
        insert cert;
    
     id certId1 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Right to Work').getRecordTypeId();
        ts2__Certification__c cert1 = new ts2__Certification__c();
        cert1.ts2__Contact__c = con.id;
        cert1.RecordTypeId = certId1;
        cert1.VISA_Type__c = 'Work Visa';
       cert1.Identification_Type__c = 'Non EEA Passport';
        insert cert1;
    
     Test.startTest();
           Reinstatedtemplatedata obj = new Reinstatedtemplatedata();
    obj.con_Id=con.id;
           obj.getcertcount123();
    		obj.getpayecount123();
   			 obj.getallpaycount123();
    		obj.getltdcount123();
    obj.getportwcount123();
           Test.stopTest();

}
    
}