/* 
* Author: Kalpana
* Date: 09/10/2024
* Jira : https://targetrecruit.atlassian.net/browse/WAVE-380
* Description : Helper class for UpdateratesFromDealSheet to update Placement lookup on the related Applicant's CredentialRequirements
*/
public class PlacementTriggerHelper {
    // Method to handle insert operations
    public static void handleInsert(List<AVTRRT__Placement__c> newList) {
        updateCredentialRequirements(newList);
    }
    
    // Method to handle update operations
    /*  public static void handleUpdate(Map<Id,AVTRRT__Placement__c> oldList, List<AVTRRT__Placement__c> newList) {
List<AVTRRT__Placement__c> relevantPlacements = new List<AVTRRT__Placement__c>();
for (AVTRRT__Placement__c plc :newList) {
AVTRRT__Placement__c oldPlacement = oldList.get(plc.Id);
AVTRRT__Placement__c newPlacement = plc;
if (newPlacement.TR_Placement_Status__c == 'Started' && newPlacement.AVTRRT__Extension__c &&
oldPlacement.TR_Placement_Status__c != newPlacement.TR_Placement_Status__c
) {
relevantPlacements.add(newPlacement);
}
}
updateCredentialRequirements(relevantPlacements);
} 

https://targetrecruit.atlassian.net/browse/WAVE-380 , 
commneting as we are implementing button as per chnage request(09/12/2024)
*/
    
    // Utility method to update Credential Requirements based on the Placement records
    private static void updateCredentialRequirements(List<AVTRRT__Placement__c> placements) {
        Map<Id, AVTRRT__Placement__c> placementMap = new Map<Id, AVTRRT__Placement__c>();
        for (AVTRRT__Placement__c placement : placements) {
            if (((!placement.AVTRRT__Extension__c && !placement.Rate_Change__c) || 
                 (placement.AVTRRT__Extension__c || placement.Rate_Change__c))) {
                     placementMap.put(placement.AVTRRT__Job_Applicant__c, placement);
                 }
        }
        
        List<Credential_Requirement__c> credReqsToUpdate = new List<Credential_Requirement__c>();
        List<String> placementStatusCS = new List<String>();
        TR_CustomSettings__c cs = TR_CustomSettings__c.getInstance();
        if(cs.Credential_Requirements_Placement_Status__c != null){
            placementStatusCS = cs.Credential_Requirements_Placement_Status__c.split(';'); 
        }
        for (Credential_Requirement__c credReq : [SELECT Id, Placement__c,Placement__r.TR_Placement_Status__c, Job_Applicant__c FROM Credential_Requirement__c WHERE Job_Applicant__c IN :placementMap.keySet()]) {
            AVTRRT__Placement__c relatedPlacement = placementMap.get(credReq.Job_Applicant__c);
            if (relatedPlacement != null) {
                if((!relatedPlacement.AVTRRT__Extension__c && !relatedPlacement.Rate_Change__c) ||
                   ( credReq.Placement__c != null &&  placementStatusCS != null && placementStatusCS.contains(credReq.Placement__r.TR_Placement_Status__c) &&
                    (relatedPlacement.AVTRRT__Extension__c || relatedPlacement.Rate_Change__c))){
                        credReq.Placement__c = relatedPlacement.Id;
                        credReqsToUpdate.add(credReq);
                    }
                
            }
        }
        
        if (!credReqsToUpdate.isEmpty()) {
            update credReqsToUpdate;
        }
    }
}