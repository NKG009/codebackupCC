public with sharing class PlacementController {
    
    @AuraEnabled
    public static void updateApplicant(Id placementId) {
        AVTRRT__Placement__c placement = [
            SELECT Id, AVTRRT__Job_Applicant__c
            FROM AVTRRT__Placement__c 
            WHERE Id = :placementId
            LIMIT 1
        ];
        
        if (placement.AVTRRT__Job_Applicant__c == null) {
            throw new AuraHandledException('No related Job Applicant found for this Placement.');
        }
        List<Credential_Requirement__c> creReqToUpdate = new List<Credential_Requirement__c>();
        List<Credential_Requirement__c> credentialRequirements = [
            SELECT Id, Job_Applicant__c, Placement__c
            FROM Credential_Requirement__c
            WHERE Job_Applicant__c = :placement.AVTRRT__Job_Applicant__c
        ];
        
        if (credentialRequirements.isEmpty()) {
            throw new AuraHandledException('No Credential Requirements found for the related Job Applicant.');
        }
        
        for (Credential_Requirement__c credReq : credentialRequirements) {
            if( credReq.Placement__c != placementId){
                credReq.Placement__c = placementId; 
                creReqToUpdate.add(credReq);
            }
            
        }
        if(creReqToUpdate.size()>0){
            update creReqToUpdate;
        }
    }
}