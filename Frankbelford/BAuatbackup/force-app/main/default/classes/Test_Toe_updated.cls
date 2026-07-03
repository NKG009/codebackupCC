@isTest
public class Test_Toe_updated {
    @TestSetup
    static void setupTestDate(){
        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        TestDataFactory.setupCustomSettings(acc.Id);
        TestDataFactory.setupUserProfileCustomSettings();
    }

    public testmethod static void testcandidate1(){

        Account acc =  [SELECT Id, Name FROM Account WHERE RecordType.Name = 'Candidate' LIMIT 1]; //TestDataFactory.createCandidateAccount(1)[0];
        //insert acc;
        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        con.Email='testsalesforcesfdc1211@imp.com';
        con.TOE_Completed__c = false;
        insert con;
        con.TOE_Completed__c = true;
        update con;
    }
    public testmethod static void testcandidate2(){
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

        IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
        setting.ToeBatchDateFilter__c =   system.today();
        setting.ToeDaysFilter__c = 'LAST_N_DAYS:7';
        insert setting;

        Account acc =  [SELECT Id, Name FROM Account WHERE RecordType.Name = 'Candidate' LIMIT 1]; //TestDataFactory.createCandidateAccount(1)[0];
        //          insert acc;

        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        con.TOE_Completed__c = True;
        con.TOE_Updated__c = System.today();
        con.Email='testsalesforcesfdc12309@imp.com';
        insert con;

        Database.executeBatch(new TOE_Update_Batch(), 10);

        Test.StartTest();

        TOE_updateSchedule sh1 = new TOE_updateSchedule();
        String sch = '0 30 * * * ?';
        system.schedule('Test TOE schedule', sch, sh1);
        Test.stopTest();
    }
    
}