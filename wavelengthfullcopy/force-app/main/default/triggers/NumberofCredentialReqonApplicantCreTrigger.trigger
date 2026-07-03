/* 
* Author: Kalpana
* Date: 07/19/2024
* Jira : https://targetrecruit.atlassian.net/browse/WAVE-349
* Description : Trigger to count the number of Credential Requirements on Applicant
*/
trigger NumberofCredentialReqonApplicantCreTrigger on CRDNTLS__Credentials_Answers__c (after update) {
    Set<Id> credentialIds = new Set<Id>();
    
    TR_CustomSettings__c cusSet = TR_CustomSettings__c.getInstance();
    if (Trigger.isAfter) {
        
        if (Trigger.isUpdate) {
            for (CRDNTLS__Credentials_Answers__c cr : Trigger.new) {
                if (cr.CRDNTLS__Status__c != Trigger.oldMap.get(cr.Id).CRDNTLS__Status__c) {
                    credentialIds.add(cr.Id);
                }
            }
        }
        
        if (!credentialIds.isEmpty()  && !cusSet.Disable_NumberofCredentialReqonApplicatt__c) {
            NumberofCredentialReqonApplicantCreH.NumberofCredentialReqonApplicantCreM(credentialIds);
        }
        
        if (!credentialIds.isEmpty()  && !cusSet.Disable_NumberofCredentialReqonPlac__c) {
            NumberofCredentialReqonPlacementCreH.NumberofCredentialReqonPlacementCreM(credentialIds);
        }
    }
    
}