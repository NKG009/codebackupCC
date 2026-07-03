/* 
* Author: Kalpana
* Date: 07/19/2024
* Jira : https://targetrecruit.atlassian.net/browse/WAVE-349
* Description : Helper class for NumberofCredentialReqonApplicantCreTrigger
*/
public class NumberofCredentialReqonApplicantCreH {
    
    public static void NumberofCredentialReqonApplicantCreM(Set<Id> credentialIds) {
        
        List<Credential_Requirement__c> creRequ = [SELECT Id,Credential__c,Job_Applicant__c 
                                                   FROM Credential_Requirement__c 
                                                   WHERE Credential__c IN:credentialIds and Job_Applicant__c != null];
        if(creRequ.size()>0){
            
            Set<Id> appIds = new Set<Id>();
            
            for(Credential_Requirement__c cr :creRequ ){
                appIds.add(cr.Job_Applicant__c);
            }
            
            NumberofCredentialReqonApplicantHelper.updateJobApplicantFields(appIds);
        }
    }
    
}