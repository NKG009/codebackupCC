/**
 * Created by mrahman on 2020-11-06.
 */

@IsTest
private class VmsJobOrderRESTServiceTest {
    @TestSetup
    static void setupTestData(){
        insert new Payroll_Swtich__c(Name = 'Stoppayroll', Batch_check__c = false);

        StagingJobOrder__c sjobOrder = TestDataFactory.createStagingJobOrders(1)[0];
        insert sjobOrder;

        StagingShift__c sShift = TestDataFactory.createStagingShifts(sjobOrder, 1)[0];
        insert sShift;
    }

    @IsTest
    static void testGetJobOrderById() {
        StagingJobOrder__c jobOrder = [SELECT Id, Name
                                             ,StgSourceSystem__c
                                             ,StgClientName__c
                                        FROM StagingJobOrder__c LIMIT 1];
        RestRequest request = new RestRequest();
        request.requestURI = 'https//'+URL.getSalesforceBaseUrl().getHost() + '/vms-job-order/' + jobOrder.Id;
        request.httpMethod = 'GET';
        RestContext.request = request;

        StagingJobOrder__c response = VmsJobOrderRESTService.getJobOrderById();
        System.assert(response != null, 'Response should not be null');
    }

    @IsTest
    static void testCreateJobOrder(){
        VmsJobOrderHelper j = getRequestJO();
        String reqBody = JSON.serializePretty(j);

        RestRequest request = new RestRequest();
        request.requestURI = 'https//'+URL.getSalesforceBaseUrl().getHost() + '/vms-job-order/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(reqBody);
        RestContext.request = request;

        String response = VmsJobOrderRESTService.createJobOrder();
        System.assert(String.isNotBlank(response), 'Response is null/blank');
    }

    @IsTest
    static void testSubmitInvalidJobOrder(){
        VmsJobOrderHelper j =  new VmsJobOrderHelper();//getRequestJO();
        //j.StgRoleId = null;
        String reqBody = JSON.serializePretty(j);

        RestRequest request = new RestRequest();
        request.requestURI = 'https//'+URL.getSalesforceBaseUrl().getHost() + '/vms-job-order/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(reqBody);
        RestContext.request = request;

        String response = VmsJobOrderRESTService.createJobOrder();
        System.debug('response >> ' + response);
        List<Integration_Error_Log__c> iels = [SELECT Id, Name FROM Integration_Error_Log__c];
        System.debug('Error log >>> ' +iels);
        System.assert(iels.size()>0, 'Expected log an error');
        System.assert(String.isNotBlank(response), 'Response is null/blank');
    }

    private static VmsJobOrderHelper getRequestJO(){
        StagingJobOrder__c sj = [SELECT Id, Name,
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
        LIMIT 1];
        VmsJobOrderHelper.VmsShift s = new VmsJobOrderHelper.VmsShift();
        s.StgSourceSystem=sj.StgSourceSystem__c;
        s.StgClientName=sj.StgClientName__c;
        s.StgClientID=sj.StgClient_Id__c;
        s.StgRoleId=sj.StgRoleId__c;
        s.StgShiftId=sj.Staging_Shifts__r[0].StgShiftId__c;
        s.StgJobTitle=sj.StgJobTitle__c;
        s.StgQuantity=sj.StgQuantity__c;
        s.StgRoleStartDate=sj.Staging_Shifts__r[0].StgRoleStartDate__c;
        s.StgRoleEndDate=sj.Staging_Shifts__r[0].StgRoleEndDate__c;
        s.StgShiftStartTime=sj.Staging_Shifts__r[0].StgShiftStartTime__c;
        s.StgShiftEndTime=sj.Staging_Shifts__r[0].StgShiftEndTime__c;
        s.StgLocationId=sj.StgLocationId__c;
        s.StgLocationName=sj.StgLocationName__c;
        s.StgCreatedDate=sj.StgCreatedDate__c;
        s.StgUpdatedDate=sj.StgUpdatedDate__c;
        s.StgShiftStatus=sj.Staging_Shifts__r[0].StgShiftStatus__c;
        s.StgFrontOfficeIntegrationSystem=sj.StgFrontOfficeIntegrationSystem__c;
        s.StgFrontOfficeIntegrationSystemEntity=sj.Staging_Shifts__r[0].StgFrontOfficeIntegrationSystemEntity__c;
        s.StgSector=sj.Staging_Shifts__r[0].StgSector__c;
        s.StgPlacement=sj.Staging_Shifts__r[0].StgPlacement__c;

        VmsJobOrderHelper j = new VmsJobOrderHelper();
        j.StgSourceSystem = sj.StgSourceSystem__c;
        j.StgClientName = sj.StgClientName__c;
        j.StgClientId = sj.StgClient_Id__c;
        j.StgRoleId = sj.StgRoleId__c;
        j.StgJobTitle = sj.StgJobTitle__c;
        j.StgQuantity = sj.StgQuantity__c;
        j.StgStartDate = sj.StgStartDate__c;
        j.StgEndDate = sj.StgEndDate__c;
        j.StgStartTime = sj.StgStartTime__c;
        j.StgEndTime = sj.StgEndTime__c;
        j.StgLocationId = sj.StgLocationId__c;
        j.StgLocationName = sj.StgLocationName__c;
        j.StgHasShifts = sj.StgHasShifts__c;
        j.StgCreatedDate = sj.StgCreatedDate__c;
        j.StgUpdatedDate = sj.StgUpdatedDate__c;
        j.StgFrontOfficeIntegrationSystem = sj.StgFrontOfficeIntegrationSystem__c;
        j.StgRoleRequirement = sj.StgRoleRequirement__c;
        j.StgRequiredStaff = sj.StgRequiredStaff__c;
        j.stgShifts.add(s);
        return j;
    }
}