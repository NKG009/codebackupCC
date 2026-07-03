/**
 * Created by mrahman on 2020-11-05.
 * Test Class: VmsSubmitCandidateTest
 */

trigger StagingJobApplication on StagingJobApplication__c (before insert, after insert, after update) {
    if(Trigger.isAfter){
        //PUBLISH THE JOB APPLICATION TO SNAPLOGIC--> VMS
        List<Database.SaveResult> results;
        if(Trigger.isInsert){
            System.debug('After Insert');
            results = VmsInregrationTriggerHandler.publisNewJobApplicationEvent(Trigger.newMap.keySet(),'StagingJobApplication__c');
            System.debug('preparing to publish event' + results);
        } else if(Trigger.isUpdate){
            System.debug('After Update');
            Set<Id> recordSetIds = new Set<Id>();
            for(StagingJobApplication__c stgja : Trigger.new){
                if(stgja.stgSPlacementId__c != null
                        && stgja.stgSPlacementId__c != Trigger.oldMap.get(stgja.Id).stgSPlacementId__c
                        && stgja.stgSPlacementSubmitted__c==false){
                    recordSetIds.add(stgja.Id);
                }
            }
            if(recordSetIds.size()>0){
                results = VmsInregrationTriggerHandler.publisNewJobApplicationEvent(Trigger.newMap.keySet(),'StagingJobApplication__c');
                System.debug('preparing to publish event' + results);
            }
        }
    }

    if(Trigger.isInsert && Trigger.isBefore){
        System.debug('Preparing to populate missing field values');
        VmsStgJobApplicationTriggerHelper.updateStgApplicationRequiredFields(Trigger.new);
    }
}