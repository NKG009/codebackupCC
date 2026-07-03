@isTest
public class UpdateCriminalConvictionDetails_Test {
    @isTest static void Test1(){
        
        Account acct = TestDataFactory.createCandidateAccount(1)[0];
        insert acct;
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];    
        insert cond;
        
        ts2__Certification__c cert = new ts2__Certification__c();
        RecordType rt= [Select Id from RecordType where sObjectType ='ts2__Certification__c' and Name ='Declaration'];
        cert.RecordTypeId = rt.Id;
        cert.ts2__Contact__c= cond.Id;
        cert.IP_Offence__c='Theft';
        cert.IP_Conviction__c='Theft';
        cert.Unspent_Criminal_Convictions_Details__c= System.today();
        cert.IP_Rehabilitation_Period_End_Date__c= System.today();
        cert.Unspent_Criminal_Convictions__c='Yes';
        insert cert;
        
        Test.startTest();
        UpdateCriminalConvictionDetails ucd = new UpdateCriminalConvictionDetails();
        Database.executeBatch(ucd);
        Test.stopTest();
        
    }}