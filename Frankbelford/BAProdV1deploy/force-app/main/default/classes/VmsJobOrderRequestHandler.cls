/**
 * Created by mrahman on 2020-11-04.
 */

public with sharing class VmsJobOrderRequestHandler {
    public static String doInsertStagingJobOrder(VmsJobOrderHelper joHelper, String stgReqPayload){
        String result;
        StagingJobOrder__c sJobOrder = new StagingJobOrder__c(  StgSourceSystem__c=joHelper.StgSourceSystem
                                                                ,StgClientName__c=joHelper.StgClientName
                                                                ,StgClient_Id__c=joHelper.StgClientId
                                                                ,StgRoleId__c=joHelper.StgRoleId
                                                                ,StgJobTitle__c=joHelper.StgJobTitle
                                                                ,StgQuantity__c=String.isBlank(joHelper.StgQuantity) && String.isNotBlank(joHelper.StgJobApplicationId)?'1':joHelper.StgQuantity
                                                                ,StgStartDate__c=joHelper.StgStartDate
                                                                ,StgEndDate__c=joHelper.StgEndDate
                                                                ,StgStartTime__c=joHelper.StgStartTime
                                                                ,StgEndTime__c=joHelper.StgEndTime
                                                                ,StgLocationId__c=joHelper.StgLocationId
                                                                ,StgLocationName__c=joHelper.StgLocationName
                                                                ,StgHasShifts__c=joHelper.StgHasShifts
                                                                ,StgCreatedDate__c=joHelper.StgCreatedDate
                                                                ,StgUpdatedDate__c=joHelper.StgUpdatedDate
                                                                ,StgFrontOfficeIntegrationSystem__c=joHelper.StgFrontOfficeIntegrationSystem
                                                                ,StgRoleRequirement__c=joHelper.StgRoleRequirement
                                                                ,StgRequiredStaff__c=joHelper.StgRequiredStaff
                                                                ,Staging_Job_Application__c=joHelper.StgJobApplicationId
                                                                ,StgCandidateRoleId__c=joHelper.StgCandidateRoleId
                                                                ,StgJobRoleId__c=joHelper.StgJobRoleId
                                                                ,StgJobRoleName__c=joHelper.StgJobRoleName
                                                                ,StgMoveOrCopy__c = joHelper.StgMoveOrCopy
                                                                ,StgTransactionType__c = joHelper.StgTransactionType
                                                              	,StgSecWatchdog__c = joHelper.StgSecWatchdog
                                                              	,StgCVRequired__c = joHelper.StgCVRequired
                                                              	,StgPostCode__c = joHelper.StgPostCode
                                                              	,StgJobCat__c = joHelper.StgJobCat
                                                              	,StgCostCentre__c = joHelper.StgCostCentre
                                                              	,StgReqPayload__c = stgReqPayload
                                                             );
        List<StagingShift__c> sShifts = new List<StagingShift__c>();

        //SAVE point to rollback the transaction in the event of error
        Savepoint sp = Database.setSavepoint();
        try{
            insert sJobOrder;
            if(joHelper.StgHasShifts.capitalize() == 'TRUE' && joHelper.stgShifts.size() > 0){
                for(VmsJobOrderHelper.VmsShift s : joHelper.stgShifts){
                    sShifts.add(new StagingShift__c(Staging_Job_Order__c = sJobOrder.Id
                            ,StgSourceSystem__c=s.StgSourceSystem
                            ,StgClientName__c=s.StgClientName
                            ,StgClientID__c=s.StgClientID
                            ,StgRoleId__c=s.StgRoleId
                            ,StgShiftId__c=s.StgShiftId
                            ,StgJobTitle__c=s.StgJobTitle
                            ,StgQuantity__c=s.StgQuantity
                            ,StgRoleStartDate__c=s.StgRoleStartDate
                            ,StgRoleEndDate__c=s.StgRoleEndDate
                            ,StgShiftStartTime__c=s.StgShiftStartTime
                            ,StgShiftEndTime__c=s.StgShiftEndTime
                            ,StgLocationId__c=s.StgLocationId
                            ,StgLocationName__c=s.StgLocationName
                            ,StgCreatedDate__c=s.StgCreatedDate
                            ,StgUpdatedDate__c=s.StgUpdatedDate
                            ,StgShiftStatus__c=s.StgShiftStatus
                            ,StgFrontOfficeIntegrationSystem__c=s.StgFrontOfficeIntegrationSystem
                            ,StgFrontOfficeIntegrationSystemEntity__c=s.StgFrontOfficeIntegrationSystemEntity
                            ,StgSector__c=s.StgSector
                            ,StgPlacement__c=s.StgPlacement));
                }
                try{
                    insert sShifts;
                    //result = sJobOrder.Id;
                } catch(Exception ex){
                    Database.rollback(sp);
                    return result='Error in shift details: ' + ex.getMessage().replaceAll('__c','');
                }
            }
            result = sJobOrder.Id;
        } catch(Exception ex){
            Database.rollback(sp);
            return result='Error in Job Order details: '+ex.getMessage().replaceAll('__c','');
        }
        return result;
    }
}