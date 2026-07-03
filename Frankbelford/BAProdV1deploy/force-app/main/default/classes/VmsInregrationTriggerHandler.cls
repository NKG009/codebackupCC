/**
 * Created by mrahman on 2020-11-05.
 * TEST CLASS: VmsJobOrderRESTServiceTest
 */

public with sharing class VmsInregrationTriggerHandler {
    /**
     * PUBLISH INBOUND MESSAGE PROCESSING EVENT
     * @param recordIds - SF RECORD ID
     * @param stgObjectName - SF OBJECT API NAME
     * @return
     */
    public static List<Database.SaveResult> publisNewRecordEvent(Set<Id> recordIds, String stgObjectName){
        List<VMS_API_Integration__e> ingegEvent = new List<VMS_API_Integration__e>();
        for(Id eachId : recordIds){
            ingegEvent.add(new VMS_API_Integration__e(SF_Record_Id__c = eachId, Staging_Object_Name__c = stgObjectName));
        }
        List<Database.SaveResult> results = EventBus.publish(ingegEvent);
        return results;
    }

    /**
     * PUBLISH OUTBOUND JOB APPLICATION MESSAGE PROCESSING EVENT
     * @param recordIds - SF RECORD ID
     * @param stgObjectName - SF OBJECT API NAME
     * @return
     */
    public static List<Database.SaveResult> publisNewJobApplicationEvent(Set<Id> recordIds, String stgObjectName){
        System.debug('Publish Event recordIds >>> '+ recordIds);
        List<Database.SaveResult> results;
        List<VMS_API_Integration_Outbound__e> submitApp = new List<VMS_API_Integration_Outbound__e>();
        for(StagingJobApplication__c stgJA : [SELECT Id, stgApplicationStatus__c, stgSPlacementId__c, stgSPlacementSubmitted__c, StagingJobOrder__r.StgMoveOrCopy__c
                                                FROM StagingJobApplication__c WHERE Id IN: recordIds]){
            //FILTER OUT APPROPRIATELY TO AVOID CALLING THE ASYNC PROCESS (FUTURE METHOD)
            if(stgJA.stgApplicationStatus__c == 'New' ||
                    (stgJA.StagingJobOrder__r.StgMoveOrCopy__c == 'Copy') ||
                    (stgJA.stgApplicationStatus__c == 'Accepted' &&
                            String.isNotBlank(stgJA.stgSPlacementId__c) &&
                            stgJA.stgSPlacementSubmitted__c==false)){
                submitApp.add(new VMS_API_Integration_Outbound__e(SF_Record_Id__c = stgJA.Id, Staging_Object_Name__c = stgObjectName));
            }
        }
        System.debug('Event size = ' + submitApp.size());
        if(submitApp.size()>0){
            results = EventBus.publish(submitApp);
        }
        System.debug('Outbound Job Application Event has published >>> '+ results);
        return results;
    }
}