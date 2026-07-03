trigger PlacementTrigger on AVTRRT__Placement__c(after insert, after update, before delete) {
    new PlacementSyncHandler();
}