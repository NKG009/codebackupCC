/*Author: Salma
* Class Name : RejectedReasonPopulateHandler
* Description: 1. Helper class to Update Who_Rejected field From custom Setting(Job Applicant Rejected Stages) based on Stage Selected on Job Applicant record, 
                  and also showing validation message is Reson for Rejection Field is not selected.
*/

trigger UpdateRejectedReasonTrigger on AVTRRT__Job_Applicant__c (before update, before insert, after Insert) {
    
    if(!AVTRRT__Config_Settings__c.getInstance('Default').Disable_UpdateratesFromDealSheetToJobApp__c) {
        UpdateratesFromDealSheetToJobAppHelper helper = new UpdateratesFromDealSheetToJobAppHelper();
    helper.updateAppRates(trigger.new, false);
    } 
    
    
    AVTRRT__Config_Settings__c cusSet = AVTRRT__Config_Settings__c.getInstance('Default');
    
     TR_CustomSettings__c cusSetc = TR_CustomSettings__c.getInstance();
    List<AVTRRT__Job_Applicant__c> jobAppList = new List<AVTRRT__Job_Applicant__c>();
    
       if(trigger.isUpdate && trigger.isBefore)
       {
           
        //https://targetrecruit.atlassian.net/browse/UPP-81
        for(AVTRRT__Job_Applicant__c JobApp: trigger.new){
            if(JobApp.AVTRRT__Stage__c != Null && trigger.oldMap.get(JobApp.Id).AVTRRT__Stage__c != JobApp.AVTRRT__Stage__c){
                jobAppList.add(JobApp);
            }     
        }
           
        //https://targetrecruit.atlassian.net/browse/UPP-82
           for (AVTRRT__Job_Applicant__c oldRecord : Trigger.old) {
               AVTRRT__Job_Applicant__c newRecord = Trigger.newMap.get(oldRecord.Id);
               
               if (oldRecord.AVTRRT__Stage__c != newRecord.AVTRRT__Stage__c) {
                   newRecord.Rejected_In_Stage__c = oldRecord.AVTRRT__Stage__c;
               }
           }  
      }
    if(!cusSet.Disabled_UpdateRejectedReasonTrigger__c && jobAppList.size() > 0){
        
        RejectedReasonPopulateHandler sh=new RejectedReasonPopulateHandler();
        sh.updateReason(jobAppList);
    }
   
    
    if (Trigger.isAfter && Trigger.isInsert) {
        if(!cusSetc.Disable_createCredentialRequirements__c)
        CreateAppCredentialRequirementsHandler.createCredentialRequirements(Trigger.new); //Kalpana - https://targetrecruit.atlassian.net/browse/WAVE-323
    }
    
}