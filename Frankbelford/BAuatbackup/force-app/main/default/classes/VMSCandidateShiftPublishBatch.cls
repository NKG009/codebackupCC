global class VMSCandidateShiftPublishBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query shift records using the collected IDs
        return Database.getQueryLocator([
            SELECT Name FROM VMSCandidateshiftsupdate__c
        ]);
    }

    global void execute(Database.BatchableContext BC, List<VMSCandidateshiftsupdate__c> scope) {
         List<String> shiftIds = new List<String>();
        if (!scope.isEmpty()) {
            for (VMSCandidateshiftsupdate__c setting : scope) {
            shiftIds.add(setting.Name);
        }
          list<sirenum__Shift__c> shiftsreclist=[SELECT Id, sirenum__Published__c FROM sirenum__Shift__c WHERE Id IN :shiftIds AND sirenum__AlertHighestSeverity__c !=4];
            for (sirenum__Shift__c shift : shiftsreclist) {
                shift.sirenum__Published__c = true;
            }
            update shiftsreclist;
        }

        List<VMSCandidateshiftsupdate__c> settingsToDelete = [
            SELECT Id FROM VMSCandidateshiftsupdate__c WHERE Name IN :shiftIds
        ];
        if (!settingsToDelete.isEmpty()) {
            delete settingsToDelete;
        }
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('Batch job completed successfully');
    }
}