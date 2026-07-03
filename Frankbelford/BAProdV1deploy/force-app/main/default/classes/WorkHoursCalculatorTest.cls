/**
 * @AUTHOR      Charlie Nash (RSSGlobal)
 * @DATE        11/07/2023
 *
 * @DESCRIPTION:
 *
 * ============================================== VERSION HISTORY ==============================================
 *
 * V1.0 - WorkHoursCalculatorTest.cls created - 11/07/2023
 *
 * =============================================================================================================
 */

@IsTest
private class WorkHoursCalculatorTest {

    @TestSetup 
    static void testSetup(){

        //Create a test hours setting
        BlueArrowWorkingHours__c hours = createHoursVar();
        insert hours;

    }

    @IsTest
    static void testDateTimeInWorkHours() {

        Test.startTest();
        Boolean result = WorkHoursCalculator.isInWorkHours(Datetime.now());
        Test.stopTest();
        System.assert(result != null);
    }

    @IsTest
    static void testDateTimeInWorkHoursInvocable(){

        List<WorkHoursCalculator.FlowOutputs> results = new List<WorkHoursCalculator.FlowOutputs>();

        Test.startTest();

        results = WorkHoursCalculator.isInWorkHoursInvocable();

        Test.stopTest();

        System.assert(results != null);
    }

    static BlueArrowWorkingHours__c createHoursVar (){

        BlueArrowWorkingHours__c hours = new BlueArrowWorkingHours__c();
        hours.Start_Time__c = 22;
        hours.End_Time__c = 23;

        return hours;

    }

}