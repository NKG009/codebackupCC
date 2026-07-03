/**
 * Created by mrahman on 2020-11-05.
 * Test class: VmsJobOrderRESTServiceTest
 */

trigger StagingJobOrder on StagingJobOrder__c (after insert) {
    if(Trigger.isAfter){
        //PUBLISH THE VMS INTEGRATION EVENT TO PROCESS DATA TO DOWN STREAM
        List<Database.SaveResult> results = VmsInregrationTriggerHandler.publisNewRecordEvent(Trigger.newMap.keySet(),'StagingJobOrder__c');
    }
}