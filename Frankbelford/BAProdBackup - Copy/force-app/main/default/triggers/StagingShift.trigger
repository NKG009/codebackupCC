/**
 * Created by mrahman on 2020-11-05.
 * Test Class: VmsJobOrderRESTServiceTest
 */

trigger StagingShift on StagingShift__c (after insert) {
    if(Trigger.isAfter){
        //PUBLISH THE VMS INTEGRATION EVENT TO PROCESS DATA TO DOWN STREAM
        List<Database.SaveResult> results = VmsInregrationTriggerHandler.publisNewRecordEvent(Trigger.newMap.keySet(),'StagingShift__c');
    }
}