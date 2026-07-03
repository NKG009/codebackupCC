/* 
* Author: Kalpana
* Date: 07/19/2024
* Jira : https://targetrecruit.atlassian.net/browse/WAVE-349
* Description : Trigger to count the number of Credential Requirements on Applicant
*/
trigger NumberofCredentialReqonApplicantTrigger on Credential_Requirement__c (after insert, after update, after delete, after undelete) {
    Set<Id> jobApplicantIds = new Set<Id>();
    Set<Id> placementIds = new Set<Id>();
    
    TR_CustomSettings__c cusSet = TR_CustomSettings__c.getInstance();
    
    if (Trigger.isAfter) {
        
        if (Trigger.isInsert || Trigger.isUndelete) {
            for (Credential_Requirement__c cr : Trigger.new) {
                if (cr.Job_Applicant__c != null) {
                    jobApplicantIds.add(cr.Job_Applicant__c);
                }
                if (cr.Placement__c != null) {
                    placementIds.add(cr.Placement__c);
                }
            }
        }
        
        if (Trigger.isUpdate) {
            for (Credential_Requirement__c cr : Trigger.new) {
                if (cr.Job_Applicant__c != null && cr.Credential__c != Trigger.oldMap.get(cr.Id).Credential__c) {
                    jobApplicantIds.add(cr.Job_Applicant__c);
                }
                if ((cr.Placement__c != null && cr.Credential__c != Trigger.oldMap.get(cr.Id).Credential__c) ||
                   (cr.Placement__c != null && cr.Placement__c != Trigger.oldMap.get(cr.Id).Placement__c)){
                    placementIds.add(cr.Placement__c);
                           placementIds.add(Trigger.oldMap.get(cr.Id).Placement__c);
                     
                }
            }
        }
        
        if (Trigger.isDelete) {
            for (Credential_Requirement__c cr : Trigger.old) {
                if (cr.Job_Applicant__c != null) {
                    jobApplicantIds.add(cr.Job_Applicant__c);
                }
                if (cr.Placement__c != null) {
                    placementIds.add(cr.Placement__c);
                }
            }
        }
        
        if (!jobApplicantIds.isEmpty() && !cusSet.Disable_NumberofCredentialReqonApplicant__c) {
            NumberofCredentialReqonApplicantHelper.updateJobApplicantFields(jobApplicantIds);
        }
        
        
        if (!placementIds.isEmpty() && !cusSet.Disable_NumberofCredentialReqonPlacement__c) {
            NumberofCredentialReqonPlacementHelper.updatePlacementFields(placementIds);
        }
        
    }
}