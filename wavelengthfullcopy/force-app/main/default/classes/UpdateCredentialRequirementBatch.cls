/*
 * Author: Kalpana
 * Date: 15th July 2024
 * Jira : https://targetrecruit.atlassian.net/browse/WAVE-323
*/
global class UpdateCredentialRequirementBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, Candidate__c, Credential_Master__c, Credential__c
            FROM Credential_Requirement__c 
            WHERE Candidate__c != null AND Job_Applicant__c != null AND Credential__c = null
        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Credential_Requirement__c> scope) {
        
        Set<Id> candidateIds = new Set<Id>();
        Set<Id> credenMasIds = new Set<Id>();
        for(Credential_Requirement__c req : scope) {
            candidateIds.add(req.Candidate__c);
            credenMasIds.add(req.Credential_Master__c);
        }
        
        List<CRDNTLS__Credentials_Answers__c> answersList = [
            SELECT Id, CRDNTLS__Contact__c, CRDNTLS__Credentials_Question_ID__c
            FROM CRDNTLS__Credentials_Answers__c 
            WHERE CRDNTLS__Contact__c IN :candidateIds AND CRDNTLS__Credentials_Question_ID__c IN : credenMasIds
        ];
        if(answersList.size()>0){
            Map<String, Id> candidateToAnswersMap = new Map<String, Id>();
            for(CRDNTLS__Credentials_Answers__c answer : answersList) {
                candidateToAnswersMap.put(answer.CRDNTLS__Contact__c+'-'+answer.CRDNTLS__Credentials_Question_ID__c,answer.Id);
            }
            
            List<Credential_Requirement__c> recordsToUpdate = new List<Credential_Requirement__c>();
            
            for(Credential_Requirement__c req : scope) {
                if(candidateToAnswersMap.get(req.Candidate__c+'-'+req.Credential_Master__c)!= null) {
                    req.Credential__c = candidateToAnswersMap.get(req.Candidate__c+'-'+req.Credential_Master__c);
                    recordsToUpdate.add(req);
                }
            }
            if(!recordsToUpdate.isEmpty()) {
                update recordsToUpdate;
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
    }
}