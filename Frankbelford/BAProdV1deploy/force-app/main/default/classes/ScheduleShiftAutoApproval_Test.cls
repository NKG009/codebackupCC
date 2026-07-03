@isTest
public class ScheduleShiftAutoApproval_Test {
    @TestSetup static void setupData() {
        Impellam_Settings__c batchSize = new Impellam_Settings__c(Name = 'ShiftAutoApproval' ,Limit__c='150');
        insert batchSize;
        
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
        
    }
    public static testMethod void testschedule(){
        
        Test.StartTest();
        ScheduleShiftAutoApproval sh1 = new ScheduleShiftAutoApproval();
        String sch = '0 47 21 29 * ?';
        System.schedule('Test AutoApproval', sch, sh1);
        Test.stopTest();
        
    }
}