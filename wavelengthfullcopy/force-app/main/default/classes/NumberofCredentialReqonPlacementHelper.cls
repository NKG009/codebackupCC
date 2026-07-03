/* 
* Author: Kalpana
* Date: 09/10/2024
* Jira : https://https://targetrecruit.atlassian.net/browse/WAVE-380
* Description : Helper class for NumberofCredentialReqonApplicantTrigger to update count on the placement
*/
public class NumberofCredentialReqonPlacementHelper {
    
    public static void updatePlacementFields(Set<Id> placementIds) {
        List<AVTRRT__Placement__c> listPlc = new List<AVTRRT__Placement__c>();
        Integer totalCredentialRequirements;
        Integer totalCompliantReq;
        Integer totalNonCompliantReq;
        
        List<String> totalCompliantReqCS = new List<String>();
        TR_CustomSettings__c cs = TR_CustomSettings__c.getInstance();
        if(cs.Placement_Compliant_Req_Stages__c != null){
            totalCompliantReqCS = cs.Placement_Compliant_Req_Stages__c.split(';'); 
        }
        
        List<String> totalNonCompliantReqCS = new List<String>();
        if(cs.Placement_Non_Compliant_Req_Stages__c != null){
            totalNonCompliantReqCS = cs.Placement_Non_Compliant_Req_Stages__c.split(';'); 
        }
        
        
        for (AVTRRT__Placement__c plc : [select id,Total_Credential_Requirements__c,Total_Non_Compliant_Req__c,Total_Compliant_Req__c
                                         , (select id,Credential__r.CRDNTLS__Status__c from Credential_Requirements__r ) from AVTRRT__Placement__c where id IN:placementIds] ){
                                             totalCredentialRequirements = 0;
                                             totalCompliantReq = 0;
                                             totalNonCompliantReq = 0;
                                             
                                             for (Credential_Requirement__c creReq : plc.Credential_Requirements__r){
                                                 if(creReq.Credential__c != null && creReq.Credential__r.CRDNTLS__Status__c != null){
                                                     if(totalCompliantReqCS.contains(creReq.Credential__r.CRDNTLS__Status__c) ){
                                                         totalCompliantReq++;  }
                                                     
                                                     if(totalNonCompliantReqCS.contains(creReq.Credential__r.CRDNTLS__Status__c) ){
                                                         totalNonCompliantReq++;  }
                                                 }
                                                 
                                                 totalCredentialRequirements++;
                                             }
                                             if(plc.Total_Credential_Requirements__c != totalCredentialRequirements ||
                                                plc.Total_Compliant_Req__c != totalCompliantReq ||
                                                plc.Total_Non_Compliant_Req__c != totalNonCompliantReq){
                                                    if(plc.Total_Credential_Requirements__c != totalCredentialRequirements){
                                                        plc.Total_Credential_Requirements__c = totalCredentialRequirements;
                                                    }
                                                    if(plc.Total_Compliant_Req__c != totalCompliantReq){
                                                        plc.Total_Compliant_Req__c = totalCompliantReq;
                                                    }
                                                    if(plc.Total_Non_Compliant_Req__c != totalNonCompliantReq){
                                                        plc.Total_Non_Compliant_Req__c = totalNonCompliantReq;
                                                    }
                                                    
                                                    listPlc.add(plc);
                                                }
                                         }
        if (listPlc != NULL){
            update listPlc;
        }
    }
}