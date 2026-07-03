/*
*   Executed:   After insert
*   Purpose:    
*/
trigger S3LinkFileTrigger on NEILON__File__c (after insert) {
    if(!S3LinkUtils.isTriggerDeactivate('NEILON__File__c')){
        S3LinkFileTriggerHandler objS3LinkFileTriggerHandler = new S3LinkFileTriggerHandler();
        if (Trigger.isInsert && Trigger.isAfter) {
            objS3LinkFileTriggerHandler.onAfterInsert(Trigger.new);
        }
    }
}