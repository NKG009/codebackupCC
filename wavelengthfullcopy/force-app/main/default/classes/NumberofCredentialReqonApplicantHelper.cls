/* 
* Author: Kalpana
* Date: 07/19/2024
* Jira : https://targetrecruit.atlassian.net/browse/WAVE-349
* Description : Helper class for NumberofCredentialReqonApplicantTrigger
*/
public class NumberofCredentialReqonApplicantHelper {
    public static void updateJobApplicantFields(Set<Id> jobApplicantIds) {
        List<AVTRRT__Job_Applicant__c> listApp = new List<AVTRRT__Job_Applicant__c>();
        Integer totalCredentialRequirements;
        Integer totalCompliantReq;
        Integer totalNonCompliantReq;
        
        List<String> totalCompliantReqCS = new List<String>();
        TR_CustomSettings__c cs = TR_CustomSettings__c.getInstance();
        if(cs.Applicant_Compliant_Req_Stages__c != null){
            totalCompliantReqCS = cs.Applicant_Compliant_Req_Stages__c.split(';'); 
        }
        
        List<String> totalNonCompliantReqCS = new List<String>();
        if(cs.Non_Compliant_Req_Stages__c != null){
            totalNonCompliantReqCS = cs.Non_Compliant_Req_Stages__c.split(';'); 
        }
        
        
        for (AVTRRT__Job_Applicant__c app : [select id,Total_Credential_Requirements__c,Total_Non_Compliant_Req__c,Total_Compliant_Req__c
                                             , (select id,Credential__r.CRDNTLS__Status__c from Credential_Requirements__r ) from AVTRRT__Job_Applicant__c where id IN:jobApplicantIds] ){
                                                 totalCredentialRequirements = 0;
                                                 totalCompliantReq = 0;
                                                 totalNonCompliantReq = 0;
                                                 
                                                 for (Credential_Requirement__c creReq : app.Credential_Requirements__r){
                                                     if(creReq.Credential__c != null && creReq.Credential__r.CRDNTLS__Status__c != null){
                                                         if(totalCompliantReqCS.contains(creReq.Credential__r.CRDNTLS__Status__c) ){
                                                             totalCompliantReq++;  }
                                                         
                                                         if(totalNonCompliantReqCS.contains(creReq.Credential__r.CRDNTLS__Status__c) ){
                                                             totalNonCompliantReq++;  }
                                                     }
                                                     
                                                     totalCredentialRequirements++;
                                                 }
                                                 if(app.Total_Credential_Requirements__c != totalCredentialRequirements ||
                                                    app.Total_Compliant_Req__c != totalCompliantReq ||
                                                    app.Total_Non_Compliant_Req__c != totalNonCompliantReq){
                                                        if(app.Total_Credential_Requirements__c != totalCredentialRequirements){
                                                            app.Total_Credential_Requirements__c = totalCredentialRequirements;
                                                        }
                                                        if(app.Total_Compliant_Req__c != totalCompliantReq){
                                                            app.Total_Compliant_Req__c = totalCompliantReq;
                                                        }
                                                        if(app.Total_Non_Compliant_Req__c != totalNonCompliantReq){
                                                            app.Total_Non_Compliant_Req__c = totalNonCompliantReq;
                                                        }
                                                        
                                                        listApp.add(app);
                                                    }
                                             }
        if (listApp != NULL){
            update listApp;
        }
    }
}