/**
 * Created by Musaddekur Rahman on 11/11/2020
 * Test Class: VmsSubmitCandidateTest
 */
trigger StagingAPIIntegrationOutbound on VMS_API_Integration_Outbound__e (after insert) {
    //GET THE LIST OF JOB ORDER AND SEND THEM OVER
    Set<Id> stgJobAppIds = new Set<Id>();
    for(VMS_API_Integration_Outbound__e oe : Trigger.new){
        if(oe.Staging_Object_Name__c == 'StagingJobApplication__c'){
            stgJobAppIds.add(oe.SF_Record_Id__c);
        }
    }
    System.debug('Number of application to be sent = ' + stgJobAppIds.size());
    //UPDATE THE MANDATORY FIELDS
    //updateStgApplicationRequiredFields(stgJobAppIds);

    List<String> stgJAJSONs = new List<String>();
    if(stgJobAppIds.size()>0){
        for(StagingJobApplication__c stgJA : [SELECT Id, Name
                                                    ,stgFrontOfficeIntegrationSystem__c
                                                    ,stgVmsClientId__c
                                                    ,stgVmsRoleId__c
                                                    ,stgVmsShiftId__c
                                                    ,stgAtsShiftIntegrationRef__c
                                                    ,stgApplicationStatus__c
                                                    ,stgSPlacementId__c
                                                    ,stgSPlacementId__r.IP_AssignmentRef__c
                                                    ,stgPayProfile__r.IP_PayrollID__c
                                                    ,stgAtsCandidateIntegrationRef__r.FirstName
                                                    ,stgAtsCandidateIntegrationRef__r.LastName
                                                    ,stgAtsCandidateIntegrationRef__r.Email
                                                    ,stgAtsCandidateIntegrationRef__r.Salutation
                                                    ,stgAtsCandidateIntegrationRef__r.sirenum__National_Insurance__c
                                                    ,stgAtsCandidateIntegrationRef__r.MailingStreet
                                                    ,stgAtsCandidateIntegrationRef__r.MailingCity
                                                    ,stgAtsCandidateIntegrationRef__r.MailingPostalCode
                                                    ,stgSubmissionDatetime__c
                                                    ,stgSubmittedJSON__c
                                                    ,Proof_of_ID__c
                                                    ,References_Checked__c
                                                    ,PORTW_Type__c
                                                    ,Visa_Expiry_Date__c
                                                    ,Visa_Type__c
                                                    ,StagingJobOrder__r.StgMoveOrCopy__c
                                                    ,StagingJobOrder__r.StgTransactionType__c
                                                    ,StagingJobOrder__r.stgCandidateRoleId__c
                                              		,stgAtsCandidateIntegrationRef__r.Birthdate
                                              		,stgAtsCandidateIntegrationRef__r.ts2__EEO_Gender__c
                                              		,stgAtsCandidateIntegrationRef__r.Title
                                              		,stgAtsCandidateIntegrationRef__r.Phone
                                                    ,stgAtsCandidateIntegrationRef__r.MobilePhone//jyothi
                                              		,stgAtsCandidateIntegrationRef__r.MailingState
                                              		,stgAtsCandidateIntegrationRef__r.MailingCountry
                                              		,StagingJobOrder__r.StgSourceSystem__c
                                                FROM StagingJobApplication__c
                                                WHERE Id IN :stgJobAppIds]){
            stgJAJSONs.add(JSON.serialize(stgJA));
        }
    } else {
        System.debug('No Job Application to action');
    }
    System.debug('stgJSJSONs >>> ' + stgJAJSONs);
    if(stgJAJSONs.size()>0){
        VmsSubmitCandidate.doSubmitApplication(stgJAJSONs);
    }
}