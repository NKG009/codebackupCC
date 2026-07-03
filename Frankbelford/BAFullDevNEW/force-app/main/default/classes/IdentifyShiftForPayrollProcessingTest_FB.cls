@IsTest
public class IdentifyShiftForPayrollProcessingTest_FB {
    
    @IsTest static void testLPayrollProcessing(){
        Test.startTest();

        // Create a test Payroll Cycle record
        sirenum__Payroll_Cycle__c payrollCycle = new sirenum__Payroll_Cycle__c(Name = 'Test Payroll Cycle');
        insert payrollCycle;

        // Create a test Week record
        sirenum__Week__c testWeek = new sirenum__Week__c(
            sirenum__PayrollCycle__c = payrollCycle.Id,
            sirenum__Start_Date__c = Date.newInstance(2024, 01, 01),
            sirenum__Week_Ending__c = Date.newInstance(2025, 05, 01)
        );
        insert testWeek;

        // Perform the query
        List<sirenum__Week__c> weeks = [SELECT sirenum__PayrollCycle__c, sirenum__PayrollCycle__r.Name, sirenum__Start_Date__c, sirenum__Week_Ending__c 
                                         FROM sirenum__Week__c 
                                         WHERE sirenum__Week_Ending__c >= 2021-02-01 
                                           AND sirenum__Week_Ending__c <= 2026-05-20];
        Boolean schdeuleTask = IdentifyShiftForPayrollProcessing.scheduleTheTask();
       	IdentifyShiftForPayrollProcessing.exposePrivateIdentifyPayrollCyclePeriodsToProcess('FB');

        Test.stopTest();
        
    }

}