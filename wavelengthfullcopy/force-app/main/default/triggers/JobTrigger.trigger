trigger JobTrigger on avtrrt__Job__c (after insert, after update, before delete) {
    new JobContractSyncHandler();
}