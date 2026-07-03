@IsTest
public class SirenumShiftRecordTypeChangeBatch_Test {
    @TestSetup
    static void setupTestData() {
        List<sirenum__Shift__c> shiftsAndDemands = new List<sirenum__Shift__c>();
        Datetime start = Datetime.now().addHours(-1);
        Datetime finish = start.addHours(2);

        for (Integer i = 0; i < 5; i++) {
            shiftsAndDemands.add(new sirenum__Shift__c(
                    sirenum__Scheduled_Start_Time__c = start,
                    sirenum__Scheduled_End_Time__c = finish
            ));
        }

        for (Integer i = 0; i < 5; i++) {
            shiftsAndDemands.add(new sirenum__Shift__c(
                    sirenum__Scheduled_Start_Time__c = start,
                    sirenum__Scheduled_End_Time__c = finish,
                    sirenum__Broadcasts__c = 1
            ));
        }

        insert shiftsAndDemands;
    }

    @IsTest
    static void testUpdateShiftAndDemandsRecordTypes() {
        // Execute the batch
        Test.startTest();
        Database.executeBatch(new SirenumShiftRecordTypeChangeBatch());
        Test.stopTest();

        List<sirenum__Shift__c> shifts = [SELECT Id, sirenum__Broadcasts__c, RecordTypeId FROM sirenum__Shift__c];

        DescribeSObjectResult shiftDescribe = SObjectType.sirenum__Shift__c;
        Map<String, RecordTypeInfo> recordTypes = shiftDescribe.getRecordTypeInfosByDeveloperName();
        String shiftRecordTypeId = recordTypes.get('Shift').recordTypeId;
        String shiftDemandRecordTypeId = recordTypes.get('Shift_Demand').recordTypeId;

        // Assert that Shifts and Shift Demands have their expected Record Type Ids
        for (sirenum__Shift__c shift : shifts) {
            if (shift.sirenum__Broadcasts__c == null) {
                System.assertEquals(shiftRecordTypeId, shift.RecordTypeId,
                        'Expected Shift to have the Shift Record Type Id');
            } else {
                System.assertEquals(shiftDemandRecordTypeId, shift.RecordTypeId,
                        'Expected Shift Demand to have the Shift Demand Record Type Id');
            }
        }
    }
}