/*
* Author: Kalpana
* Date: 15th July 2024
* Jira : https://targetrecruit.atlassian.net/browse/WAVE-322
*/
trigger updateAccAddToJobAddressTrigger on AVTRRT__Job__c (before insert, before update,  after insert) {
    if(trigger.isInsert && trigger.isBefore && !AVTRRT__Config_Settings__c.getInstance('Default').Disable_update_Acc_Addres_To_Job_Address__c){
        updateAccAddToJobAddressHandler.updateAccountAddress(trigger.new);
    }
    
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate) 
      && !AVTRRT__Config_Settings__c.getInstance('Default').Disable_update_Job_State_from_State__c){
        stateToJobState.updateJobState(trigger.new, trigger.oldMap);
    }
    
    TR_CustomSettings__c cusSet = TR_CustomSettings__c.getInstance();
    List<String> jobStagesCs = new  List<String>();
    if(cusSet.Job_Stages_to_Create_Credential_Requirem__c != null){
        String jobStages = cusSet.Job_Stages_to_Create_Credential_Requirem__c;
        jobStagesCs = jobStages.split(';');
    }
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            if(!cusSet.Disable__c){
                AVTRRT_JobTriggerHandler.updateCredentialsPack(Trigger.new, false,false);
            }
        }
        
        if (Trigger.isUpdate) {
            List<AVTRRT__Job__c> jobsToConsider = new List<AVTRRT__Job__c>();
            for(AVTRRT__Job__c job:Trigger.new){
                if(jobStagesCs != null && jobStagesCs.contains(job.AVTRRT__Stage__c) && (job.AVTRRT__Stage__c != Trigger.oldMap.get(job.Id).AVTRRT__Stage__c || 
                                                                                         job.Credential_Packs__c != Trigger.oldMap.get(job.Id).Credential_Packs__c || 
                                                                                         job.Seniority_NEW__c != Trigger.oldMap.get(job.Id).Seniority_NEW__c || 
                                                                                         job.Specialty_NEW__c != Trigger.oldMap.get(job.Id).Specialty_NEW__c || 
                                                                                         job.AVTRRT__Job_State__c != Trigger.oldMap.get(job.Id).AVTRRT__Job_State__c || 
                                                                                         job.State_Seniority_Specialty__c != Trigger.oldMap.get(job.Id).State_Seniority_Specialty__c)){
                                                                                             jobsToConsider.add(job);
                                                                                         }
            }
            if(!cusSet.Disable__c && jobsToConsider.size()>0){
                AVTRRT_JobTriggerHandler.updateCredentialsPack(jobsToConsider, true,false);
            }
        }
    }
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            if(!cusSet.Disable__c){
                Boolean isInsert = Trigger.isInsert;
                AVTRRT_JobTriggerHandler.updateCredentialsPack(Trigger.new, isInsert,true);
            }
        }
    }    

}