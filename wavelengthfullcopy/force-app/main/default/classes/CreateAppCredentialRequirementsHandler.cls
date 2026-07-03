/*
 * Author: Kalpana
 * Date: 15th July 2024
 * Jira : https://targetrecruit.atlassian.net/browse/WAVE-323
*/
public class CreateAppCredentialRequirementsHandler {
    
    public static void createCredentialRequirements(List<AVTRRT__Job_Applicant__c> newApplicants) {
        Set<Id> jobIds = new Set<Id>();
        for (AVTRRT__Job_Applicant__c applicant : newApplicants) {
            if (applicant.AVTRRT__Job__c != null) {
                jobIds.add(applicant.AVTRRT__Job__c);
            }
        }
        
        Map<Id, List<Credential_Requirement__c>> jobCredentialRequirementsMap = new Map<Id, List<Credential_Requirement__c>>();
        for (Credential_Requirement__c requirement : [
            SELECT Id, Name, Job__c, Credential_Master__c, Credential_Master__r.CRDNTLS__Question__c,Credential_Master__r.CRDNTLS__IsActive__c
            FROM Credential_Requirement__c 
            WHERE Job__c IN :jobIds AND Credential_Master__r.CRDNTLS__IsActive__c = true
        ]) {
            if (!jobCredentialRequirementsMap.containsKey(requirement.Job__c)) {
                jobCredentialRequirementsMap.put(requirement.Job__c, new List<Credential_Requirement__c>());
            }
            jobCredentialRequirementsMap.get(requirement.Job__c).add(requirement);
        }
        
        List<Credential_Requirement__c> newCredentialRequirements = new List<Credential_Requirement__c>();
        List<Contact> contactsToUpdate = new List<Contact>();
        
        for (AVTRRT__Job_Applicant__c applicant : [
            SELECT Id, Name, AVTRRT__Job__c, AVTRRT__Contact_Candidate__c,
            AVTRRT__Job__r.Credential_Packs__c, 
            AVTRRT__Contact_Candidate__r.CRDNTLS__Credential_Group__c
            FROM AVTRRT__Job_Applicant__c
            WHERE Id IN :newApplicants
        ]) {
            if (applicant.AVTRRT__Job__c != null && applicant.AVTRRT__Contact_Candidate__c != null) {
                String jobCredentials = applicant.AVTRRT__Job__r.Credential_Packs__c;
                String contactCredentialGroup = applicant.AVTRRT__Contact_Candidate__r.CRDNTLS__Credential_Group__c;
                
                if (String.isNotBlank(jobCredentials)) {
                    Set<String> jobCredentialSet = new Set<String>(jobCredentials.split(';'));
                    Set<String> contactCredentialGroupSet = new Set<String>();
                    if (String.isNotBlank(contactCredentialGroup)) {
                        contactCredentialGroupSet = new Set<String>(contactCredentialGroup.split(';'));
                    }
                    
                    List<Credential_Requirement__c> jobRequirements = jobCredentialRequirementsMap.get(applicant.AVTRRT__Job__c);
                    if (jobRequirements != null) {
                        for (Credential_Requirement__c jobRequirement : jobRequirements) {
                            Credential_Requirement__c newRequirement = new Credential_Requirement__c();
                            newRequirement.Name = applicant.Name + '-' + jobRequirement.Credential_Master__r.CRDNTLS__Question__c;
                            newRequirement.Credential_Master__c = jobRequirement.Credential_Master__c;
                            newRequirement.Job_Applicant__c = applicant.Id;
                            newRequirement.Candidate__c = applicant.AVTRRT__Contact_Candidate__c;
                            newCredentialRequirements.add(newRequirement);
                        }
                    }
                    
                    if (!contactCredentialGroupSet.containsAll(jobCredentialSet)) {
                        contactCredentialGroupSet.addAll(jobCredentialSet);
                        applicant.AVTRRT__Contact_Candidate__r.CRDNTLS__Credential_Group__c = String.join(contactCredentialGroupSet, ';');
                        contactsToUpdate.add(applicant.AVTRRT__Contact_Candidate__r);
                    }
                }
            }
        }
        
        if (!newCredentialRequirements.isEmpty()) {
            insert newCredentialRequirements;
        }
        
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}