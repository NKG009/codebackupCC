/**
 * Created by mrahman on 2021-05-07.
 */

@IsTest
private class ClientComApprovedShiftControllerTest {

    @TestSetup
    static void setupTestData(){
        TestDataFactory.setupShifts();
    }
    @IsTest
    static void testGetAllApprovedShifts() {
        List<sirenum__Shift__c> shifts = [SELECT sirenum__Site__c, sirenum__Contact__c, Brand__c, sirenum__Allow_charge__c, sirenum__Allow_pay__c FROM sirenum__Shift__c];

        Test.startTest();
        System.assert(ClientComApprovedShiftController.getAllApprovedShifts(shifts[0].sirenum__Site__c,null).size() > 0);
        System.assert(ClientComApprovedShiftController.getAllApprovedShifts(shifts[0].sirenum__Site__c,shifts[0].sirenum__Contact__c).size() > 0);
        Test.stopTest();
    }
}