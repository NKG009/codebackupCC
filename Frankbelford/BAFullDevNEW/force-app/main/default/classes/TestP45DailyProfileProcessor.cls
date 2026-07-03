@istest
public class TestP45DailyProfileProcessor {

    public static testmethod void testcase1()
    {
        Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc; 
                        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
         Contact c = new Contact();
        c.FirstName='Con';
        c.lastName='Test Contact';
        c.IP_CategoryOfWork__c='Catering';
        c.sirenum__National_Insurance__c='AA123456A';
        c.P45_Date_by_Head_Office__c=system.today();
        c.AccountID=acc.id;
        insert c;
                        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
       RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];
       
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='Active';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        pay.P45_Initiated__c=true;
        pay.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
        pay.IP_Payroll_Leaver__c = 'PL';
        insert pay;
        test.startTest();
        system.debug('@@ '+pay);
     P45DailyProfileProcessor sh1 = new P45DailyProfileProcessor();      
     String sch = '0  00 1 3 * ?';
       system.schedule('Test', sch, sh1);
        test.stopTest();
    }
    

     @istest static void testcapitaschedule(){
        
        Test.StartTest();
        Schedulecapitabatch sh1 = new Schedulecapitabatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test capita', sch, sh1);
        Test.stopTest();
    }
    

    
}