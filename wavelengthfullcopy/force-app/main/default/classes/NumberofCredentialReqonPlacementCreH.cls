/* 
* Author: Kalpana
* Date: 09/10/2024
* Jira : https://targetrecruit.atlassian.net/browse/WAVE-380
* Description : Helper class for NumberofCredentialReqonApplicantCreTrigger to update count field on Placement
*/
public class NumberofCredentialReqonPlacementCreH {

public static void NumberofCredentialReqonPlacementCreM(Set<Id> credentialIds) {
        
        List<Credential_Requirement__c> creRequ = [SELECT Id,Credential__c,Placement__c 
                                                   FROM Credential_Requirement__c 
                                                   WHERE Credential__c IN:credentialIds and Placement__c != null];
        if(creRequ.size()>0){
            
            Set<Id> plcIds = new Set<Id>();
            
            for(Credential_Requirement__c cr :creRequ ){
                plcIds.add(cr.Placement__c);
            }
            
            NumberofCredentialReqonPlacementHelper.updatePlacementFields(plcIds);
        }
    }
    
}