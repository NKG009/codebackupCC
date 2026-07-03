/**
 * Created by mrahman on 2020-11-04.
 * This API will only handle GET and POST request.
 * Upsert and Update is handled in Flow which processes the Staging Job Order and Staging Shift to JS Job Order and JS Shift
 * Delete is out of scope of this implementation
 */

@RestResource(urlMapping='/vms-job-order/*')
global with sharing class VmsJobOrderRESTService {
    @HttpGet
    global static StagingJobOrder__c getJobOrderById(){
        RestRequest request = RestContext.request;
        String stgRoleId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        System.debug('stgRoleId >> '+stgRoleId);
        StagingJobOrder__c stgJobOrder = [SELECT Id, Name,
                                                 StgSourceSystem__c
                                                ,StgClientName__c
                                                ,StgClient_Id__c
                                                ,StgRoleId__c
                                                ,StgJobTitle__c
                                                ,StgQuantity__c
                                                ,StgStartDate__c
                                                ,StgEndDate__c
                                                ,StgStartTime__c
                                                ,StgEndTime__c
                                                ,StgLocationId__c
                                                ,StgLocationName__c
                                                ,StgHasShifts__c
                                                ,StgCandidateRoleId__c
                                                ,(SELECT Id, Name,
                                                         StgSourceSystem__c
                                                        ,StgClientName__c
                                                        ,StgClientID__c
                                                        ,StgRoleId__c
                                                        ,StgShiftId__c
                                                        ,StgJobTitle__c
                                                        ,StgQuantity__c
                                                        ,StgRoleStartDate__c
                                                        ,StgRoleEndDate__c
                                                        ,StgShiftStartTime__c
                                                        ,StgShiftEndTime__c
                                                        ,StgLocationId__c
                                                        ,StgLocationName__c
                                                        ,StgCreatedDate__c
                                                        ,StgUpdatedDate__c
                                                        ,StgShiftStatus__c
                                                        ,StgFrontOfficeIntegrationSystem__c
                                                        ,StgFrontOfficeIntegrationSystemEntity__c
                                                        ,StgSector__c
                                                        ,StgPlacement__c
                                                    FROM Staging_Shifts__r)
                                                ,StgCreatedDate__c
                                                ,StgUpdatedDate__c
                                                ,StgFrontOfficeIntegrationSystem__c
                                                ,StgRoleRequirement__c
                                                ,StgRequiredStaff__c
                                            FROM StagingJobOrder__c
                                            WHERE Id=:stgRoleId
                                            LIMIT 1];
        String joJSONString = JSON.serializePretty(stgJobOrder);
        return stgJobOrder;
    }

    //INSERT
    @HttpPost
    global static String createJobOrder(){
        //StagingJobOrder__c jobOrder = [SELECT Id FROM StagingJobOrder__c LIMIT 1];
        RestRequest request = RestContext.request;
        String reqString = request.requestBody.toString();
        System.debug('reqString' + reqString);
        String response;
        try{
            VmsJobOrderHelper vmsJo = (VmsJobOrderHelper) JSON.deserialize(reqString, VmsJobOrderHelper.class);
            System.debug('vmsJo>> ' + vmsJo);
            response = VmsJobOrderRequestHandler.doInsertStagingJobOrder(vmsJo, reqString); 
        } catch(Exception ex) {
            return response = ex.getMessage();
        } finally {
            //Insert into Integration error log if the response is not an instance of Id
            if(!(response InstanceOf Id)){
                insert new Integration_Error_Log__c(End_Point__c = URL.getSalesforceBaseUrl().toExternalForm() + '/vms-job-order/'
                                                    ,Payload__c=reqString
                                                    ,CallType__c='Inbound'
                                                    ,Error__c=response);
            }
        }
        return response;
    }
}