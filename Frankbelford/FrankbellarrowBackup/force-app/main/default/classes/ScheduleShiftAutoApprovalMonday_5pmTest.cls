@isTest
public class ScheduleShiftAutoApprovalMonday_5pmTest {

    @TestSetup
    static void setupData() {
        Impellam_Settings__c batchSize = new Impellam_Settings__c(Name = 'ShiftAutoApproval' ,Limit__c='150');
        insert batchSize;
        Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
        Insert candidateAcc;
        TestDataFactory.setupCustomSettings(candidateAcc.Id);
        TestDataFactory.setupUserProfileCustomSettings();
        //insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candidateAcc.Id);
        //insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        //insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
    }

    public static testMethod void testschedule(){
        Test.StartTest();
        ScheduleShiftAutoApprovalMonday_5pm sh1 = new ScheduleShiftAutoApprovalMonday_5pm();
        String sch = '0 23 22 29 * ?';
        system.schedule('Test Notification', sch, sh1); 
        Test.stopTest();
    }

}