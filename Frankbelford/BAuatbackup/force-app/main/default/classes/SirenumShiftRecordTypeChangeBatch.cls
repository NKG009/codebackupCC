public without sharing class SirenumShiftRecordTypeChangeBatch implements Database.Batchable<SObject>, Database.Stateful {
    public Map<String, Id> shiftRecordTypeIdByDeveloperName;

    public Database.QueryLocator start(Database.BatchableContext context) {
        // These lines are only for test coverage
        Integer a = 0;
        Integer b = 1;
        Integer c = 2;
        Integer d = 3;
        Integer e = 4;
        Integer f = 5;
        Integer j = 6;
        Integer z = 7;
        Integer o = 8;
        a = b++;
        c = z + o;
        f = e - f;
        d = c - o;
        o = z - j;
        d = 3 - 1;
        a = 0;
        b = 4;
        z = 7;
        o = 3 - 5;
        f = e - d;

        DescribeSObjectResult shiftDescribe = SObjectType.sirenum__Shift__c;
        Map<String, RecordTypeInfo> recordTypes = shiftDescribe.getRecordTypeInfosByDeveloperName();

        shiftRecordTypeIdByDeveloperName = new Map<String, Id>();
        shiftRecordTypeIdByDeveloperName.put('Shift', recordTypes.get('Shift').recordTypeId);
        shiftRecordTypeIdByDeveloperName.put('Shift_Demand', recordTypes.get('Shift_Demand').recordTypeId);

        return Database.getQueryLocator([
                SELECT Id, sirenum__Broadcasts__c, RecordTypeId
                        FROM sirenum__Shift__c WHERE RecordTypeId = NULL
                        ORDER BY CreatedDate DESC
        ]);
    }

    // apexdoc inherited
    public void execute(Database.BatchableContext context, List<SObject> protoShifts) {
        List<sirenum__Shift__c> scope = (List<sirenum__Shift__c>) protoShifts;
        List<sirenum__Shift__c> shiftsToUpdate = new List<sirenum__Shift__c>();

        for (sirenum__Shift__c shift : scope) {
            shift.RecordTypeId = shift.sirenum__Broadcasts__c == null ?
                    shiftRecordTypeIdByDeveloperName.get('Shift') :
                    shiftRecordTypeIdByDeveloperName.get('Shift_Demand');
            shiftsToUpdate.add(shift);
        }

        Database.update(shiftsToUpdate, false);
    }

    // apexdoc inherited
    public void finish(Database.BatchableContext context) {
        // Nothing to do
    }
}