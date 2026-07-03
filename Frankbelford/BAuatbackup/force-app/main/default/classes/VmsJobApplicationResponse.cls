/**
 * Created by mrahman on 2020-11-05.
 */

@RestResource(urlMapping='/vms-job-application-response/*')
global with sharing class VmsJobApplicationResponse {
    @HttpPost
    global static String updateApplicationStatus(){
        //PROCESS RESPONSE
        String response='API UNDER HAMMER AND WILL BE AVAILABLE SOON!';

        RestRequest request = RestContext.request;
        String reqString = request.requestBody.toString();
        System.debug('reqString' + reqString);
        try{
            RequestBodyStructure vmsJobAppRes = (RequestBodyStructure) JSON.deserialize(reqString, RequestBodyStructure.class);
            System.debug('vmsJobAppRes>> ' + vmsJobAppRes);
            response = doApplicationUpdate(vmsJobAppRes);
            if (response != 'success') {
                throw new Exception.DmlException(response);
            }
        } catch(Exception ex) {
            //insert the json request in log object
            insert new Integration_Error_Log__c(End_Point__c = URL.getSalesforceBaseUrl().toExternalForm() + '/vms-job-application-response/'
                    ,Payload__c=reqString
                    ,CallType__c='Inbound'
                    ,Error__c=response);
            return response = ex.getMessage();
        }
        return response;
    }

    private static String doApplicationUpdate(RequestBodyStructure request){
        //PERFORM DML OPERATION AFTER VALIDATION
        String response = 'Invalid request';
        StagingJobApplication__c sja = [SELECT Id, stgApplicationStatus__c, stgRejectionReason__c
        FROM StagingJobApplication__c
        WHERE Id =: request.stgAtsApplicationId];
        if(String.isNotBlank(request.stgAtsApplicationId) && request.stgApplicationStatus.capitalize() == 'REJECTED'){
            try{
                sja.stgApplicationStatus__c = request.stgApplicationStatus;
                sja.stgRejectionReason__c = request.stgRejectionReason;
                update sja;
                response = 'success';
            } catch(Exception ex) {
                System.debug('Unable to process request >> '+ ex.getMessage());
                response = ex.getMessage();
            }

        } else if(String.isNotBlank(request.stgAtsApplicationId) && request.stgApplicationStatus.capitalize() == 'ACCEPTED'){
            try{
                sja.stgApplicationStatus__c = request.stgApplicationStatus;
                update sja;
            } catch(Exception ex) {
                System.debug('Unable to process request >> '+ ex.getMessage());
                response = ex.getMessage();
            }
        } else {
            response='Unable to process the request due to required field values are missing';
        }
        return response;
    }

    class RequestBodyStructure{
        String stgApplicationStatus;
        String stgRejectionReason;
        String stgAtsApplicationId;

    }
}