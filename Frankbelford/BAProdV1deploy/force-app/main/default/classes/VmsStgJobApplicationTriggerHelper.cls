/**
 * Created by mrahman on 2020-11-20.
 * Test Class: VmsSubmitCandidateTest
 */

public class VmsStgJobApplicationTriggerHelper {

    /**
     * BEFORE UPDATE CALL THIS METHOD TO POPULATE ADDITIONAL FIELDS VALUE WHICH ARE NEED FOR CANDIDATE SUBMISSION
     *
     * @param stgAppMap
     */
    public static void updateStgApplicationRequiredFields(List<StagingJobApplication__c> stgAppList){
        Map<Id, StagingJobApplication__c> jobAppMap = new Map<Id, StagingJobApplication__c>(); //Job Order Id and RECORD
        Set<Id> stgJoIds = new Set<Id>();
        for(StagingJobApplication__c stgJobApp : stgAppList){
            jobAppMap.put(stgJobApp.Job_Order_Lookup__c, stgJobApp);
        }
        System.debug('jobAppMap >>> '+jobAppMap);
        for(StagingJobOrder__c stgJO : [SELECT Id, Name, StgClient_Id__c
                                                ,StgClientName__c
                                                ,StgRoleId__c
                                                ,StgFrontOfficeIntegrationSystem__c
                                                ,CreatedDate
                                                ,Job_Order_Lookup__c
                                        FROM StagingJobOrder__c
                                        WHERE Job_Order_Lookup__c IN: jobAppMap.keySet()
                                        ORDER BY CreatedDate ASC]){
            System.debug('Clent Id:: ' + stgJO.StgClient_Id__c);
            System.debug('Role Id:: ' + stgJO.StgRoleId__c);
            if(!stgJoIds.contains(stgJO.Id)){
                jobAppMap.get(stgJO.Job_Order_Lookup__c).stgVmsClientId__c = stgJO.StgClient_Id__c;
                jobAppMap.get(stgJO.Job_Order_Lookup__c).stgVmsRoleId__c = stgJO.StgRoleId__c;
                jobAppMap.get(stgJO.Job_Order_Lookup__c).StagingJobOrder__c = stgJO.Id;
                stgJoIds.add(stgJO.Id);
            }

        }
        System.debug('Staging Job Application field update >>> ' + jobAppMap.values());
        //return stgJoMap.values();
    }
}