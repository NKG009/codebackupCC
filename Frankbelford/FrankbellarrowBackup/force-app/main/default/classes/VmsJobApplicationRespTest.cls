/**
 * Created by mrahman on 2020-11-09.
 */

@IsTest
private class VmsJobApplicationRespTest {
    @TestSetup
    static void setupApplicationData(){
        Account candidateAccount = TestDataFactory.createCandidateAccount(1)[0];
        insert candidateAccount;
        TestDataFactory.setupCustomSettings(candidateAccount.Id);
        TestDataFactory.setupUserProfileCustomSettings();

        Contact worker = TestDataFactory.createCandidate(candidateAccount.Id, 1)[0];
        insert worker;
        IP_PayProfile__c ppPAYE = TestDataFactory.createPayProfilePaye(worker.Id, 1)[0];
        insert ppPAYE;
        
        //TestDataFactory.setupShifts();
        StagingJobOrder__c sjobOrder = TestDataFactory.createStagingJobOrders(1)[0];
        insert sjobOrder;
        StagingShift__c sShift = TestDataFactory.createStagingShifts(sjobOrder, 1)[0];
        insert sShift;
        insert new StagingJobApplication__c(stgFrontOfficeIntegrationSystem__c = sjobOrder.StgFrontOfficeIntegrationSystem__c
                                            ,stgVmsClientId__c = sjobOrder.StgClient_Id__c
                                            ,stgVmsRoleId__c = sjobOrder.StgRoleId__c
                                            ,stgPayProfile__c = ppPAYE.Id
                                            ,stgAtsCandidateIntegrationRef__c = worker.Id
                                            ,stgApplicationStatus__c = 'New'
                                            ,stgSubmissionDatetime__c = Datetime.now().addDays(-3));

        //,stgRejectionReason__c = sjobOrder.stgRejectionReason__c
        //,stgSubmittedJSON__c = sjobOrder.stgSubmittedJSON__c
        //,stgPayProfile__c = sjobOrder.stgPayProfile__c);
    }
    @IsTest
    static void testUpdateApplicationStatusSuccess() {
        StagingJobApplication__c sja = [SELECT Id FROM StagingJobApplication__c LIMIT 1];
        RequestBodyStructure rbs = new RequestBodyStructure();
        rbs.stgAtsApplicationId = sja.Id;
        rbs.stgRejectionReason = 'Test rejection';
        rbs.stgApplicationStatus = 'Rejected';
        RestRequest request = new RestRequest();
        request.requestURI = 'https//'+URL.getSalesforceBaseUrl().getHost() + '/vms-job-application-response/';
        request.httpMethod = 'GET';
        System.debug('response \n' + JSON.serializePretty(rbs));
        request.requestBody = Blob.valueOf(JSON.serializePretty(rbs));
        RestContext.request = request;
        String response = VmsJobApplicationResponse.updateApplicationStatus();
        System.assert(String.isNotBlank(response), 'No response received');
    }

    @IsTest
    static void testUpdateApplicationStatusFailure() {
        StagingJobApplication__c sja = [SELECT Id FROM StagingJobApplication__c LIMIT 1];
        RequestBodyStructure rbs = new RequestBodyStructure();
        rbs.stgAtsApplicationId = sja.Id;
        //rbs.stgRejectionReason = 'Test rejection';
        rbs.stgApplicationStatus = 'Accepted';
        RestRequest request = new RestRequest();
        request.requestURI = 'https//'+URL.getSalesforceBaseUrl().getHost() + '/vms-job-application-response/';
        request.httpMethod = 'GET';
        request.requestBody = Blob.valueOf(JSON.serializePretty(rbs));
        RestContext.request = request;
        String response = VmsJobApplicationResponse.updateApplicationStatus();
        System.assert(String.isNotBlank(response), 'No response received');
    }

    class RequestBodyStructure{
        String stgApplicationStatus;
        String stgRejectionReason;
        String stgAtsApplicationId;
    }
}