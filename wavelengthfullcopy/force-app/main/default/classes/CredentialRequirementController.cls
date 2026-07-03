/*
* Author: Kalpana
* Date: 8th Aug 2024
* Description : Controller for  createjobcredentialrequiremnetcomponent (Add/Remove Credential Requirements Button on Job Object)
* Jira : https://targetrecruit.atlassian.net/browse/WAVE-352
*/

public with sharing class CredentialRequirementController {
    @AuraEnabled(cacheable=true)
    public static List<CRDNTLS__CredentialQuestion__c> getActiveCredentialQuestions(String searchKey) {
        String searchPattern = '%' + searchKey + '%';
        return [SELECT Id, CRDNTLS__Question__c FROM CRDNTLS__CredentialQuestion__c 
                WHERE CRDNTLS__IsActive__c = true AND CRDNTLS__Question__c LIKE :searchPattern ORDER BY CRDNTLS__Question__c];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Credential_Requirement__c> getCredentialRequirements(Id jobId, String searchKey) {
        String searchPattern = '%' + searchKey + '%';
        return [SELECT Id, Name, Credential_Master__r.CRDNTLS__Question__c 
                FROM Credential_Requirement__c 
                WHERE Job__c = :jobId AND Name LIKE :searchPattern ORDER By Name];
    }
    
    @AuraEnabled
    public static void createCredentialRequirements(List<Id> questionIds, Id jobId) {
        List<Credential_Requirement__c> requirementsjob = new List<Credential_Requirement__c>();
        
        AVTRRT__Job__c job = [SELECT Id, Name FROM AVTRRT__Job__c WHERE Id = :jobId];
        
        List<CRDNTLS__CredentialQuestion__c> selectedQuestions = [SELECT Id, CRDNTLS__Question__c FROM CRDNTLS__CredentialQuestion__c WHERE Id IN:questionIds];
        
        List<Credential_Requirement__c> exitingRequirements = [SELECT Id, Credential_Master__r.CRDNTLS__Question__c 
                                                               FROM Credential_Requirement__c 
                                                               WHERE Credential_Master__c IN :questionIds AND Job__c = :jobId];
        Set<Id> exitingRequirementsMasterIds = new Set<Id>();
        if(exitingRequirements.size()>0){
            for(Credential_Requirement__c cr:exitingRequirements){
                exitingRequirementsMasterIds.add(cr.Credential_Master__c );
            }
        }
        for (CRDNTLS__CredentialQuestion__c question : selectedQuestions) {
            if (exitingRequirementsMasterIds != null && !exitingRequirementsMasterIds.contains(question.Id)) {
                requirementsjob.add(new Credential_Requirement__c(
                    Name = job.Name+'-'+question.CRDNTLS__Question__c,
                    Job__c = jobId,
                    Credential_Master__c = question.Id
                ));
            }
        }
        
        if (!requirementsjob.isEmpty()) {
            insert requirementsjob;
        }
        
        
        List<AVTRRT__Job_Applicant__c> jobApps = [SELECT Id,AVTRRT__Job__c,Name,AVTRRT__Contact_Candidate__c,
                                                  (SELECT Id, Job_Applicant__c, Credential_Master__c FROM Credential_Requirements__r WHERE Credential_Master__c IN :questionIds) 
                                                  FROM AVTRRT__Job_Applicant__c 
                                                  WHERE AVTRRT__Job__c = :jobId AND (AVTRRT__Stage__c != 'Rejected' AND AVTRRT__Stage__c != 'Withdrew')];
        Map<String, Id> existingjobAppcredres = new Map<String, Id>();
        if(jobApps.size()>0){
            List<Credential_Requirement__c> requirements = new List<Credential_Requirement__c>();
            Set<Id> candidates = new  Set<Id>();
            for(AVTRRT__Job_Applicant__c jobApp : jobApps){
                candidates.add(jobApp.AVTRRT__Contact_Candidate__c);
for(Credential_Requirement__c cr : jobApp.Credential_Requirements__r){
    String key = cr.Job_Applicant__c + '-' + cr.Credential_Master__c;
    existingjobAppcredres.put(key, cr.Credential_Master__c);
}

                for (CRDNTLS__CredentialQuestion__c question : selectedQuestions) {
    String key = jobApp.Id + '-' + question.Id;
    if(!existingjobAppcredres.containsKey(key)) {
        requirements.add(new Credential_Requirement__c(
            Name = jobApp.Name + '-' + question.CRDNTLS__Question__c,
            Credential_Master__c = question.Id,
            Job_Applicant__c = jobApp.Id,
            Candidate__c = jobApp.AVTRRT__Contact_Candidate__c
        ));
    } 
}

                
            }
            
            if (!requirements.isEmpty()) {
                insert requirements;
            }
            
            if(candidates.size()>0){
                List<CRDNTLS__Credentials_Answers__c> credAns = [SELECT Id, CRDNTLS__Contact__c, CRDNTLS__Credentials_Question_ID__c
                                                                 FROM CRDNTLS__Credentials_Answers__c
                                                                 WHERE CRDNTLS__Contact__c IN:candidates AND CRDNTLS__Credentials_Question_ID__c IN:questionIds];
                Set<String> existcredAns = new Set<String>();
                for(CRDNTLS__Credentials_Answers__c credAn : credAns){
                    existcredAns.add(credAn.CRDNTLS__Contact__c+'-'+credAn.CRDNTLS__Credentials_Question_ID__c);
                }
                
                List<CRDNTLS__Credentials_Answers__c> credentialsToCreate = new List<CRDNTLS__Credentials_Answers__c>();
                
                for(Id quetionId : questionIds){
                    for(Id candidateId : candidates){
                        if(!existcredAns.contains(candidateId+'-'+quetionId)){
                            credentialsToCreate.add(new CRDNTLS__Credentials_Answers__c(
                                CRDNTLS__Credentials_Question_ID__c = quetionId,
                                CRDNTLS__Contact__c = candidateId
                            ));   
                        }
                        
                    }
                }
                
                if (!credentialsToCreate.isEmpty()) {
                    insert credentialsToCreate;
                }
                
            }
            
        }
        
        
    }
    
    @AuraEnabled
    public static void deleteCredentialRequirements(List<Id> requirementIds) {
        List<Credential_Requirement__c> requirementsToDelete = [SELECT Id,Credential_Master__c,Job__c FROM Credential_Requirement__c WHERE Id IN :requirementIds];
        Id jobId;
        Set<Id> questionIds = new Set<Id>();
        for(Credential_Requirement__c cr:requirementsToDelete){
            jobId = cr.Job__c;
            questionIds.add(cr.Credential_Master__c);
        }
        
        List<AVTRRT__Job_Applicant__c> jobApps = [SELECT Id,AVTRRT__Job__c,Name,AVTRRT__Contact_Candidate__c,
                                                  (SELECT Id, Job_Applicant__c, Credential_Master__c FROM Credential_Requirements__r WHERE Credential_Master__c IN :questionIds) 
                                                  FROM AVTRRT__Job_Applicant__c 
                                                  WHERE AVTRRT__Job__c = :jobId AND (AVTRRT__Stage__c != 'Rejected' AND AVTRRT__Stage__c != 'Withdrew')];
        
        for(AVTRRT__Job_Applicant__c jobApp : jobApps){
            requirementsToDelete.addAll(jobApp.Credential_Requirements__r);
        }
        
        if (!requirementsToDelete.isEmpty()) {
            delete requirementsToDelete;
        }
    }
}