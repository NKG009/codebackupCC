public with sharing class shiftInviteResponseController {
  @AuraEnabled(cacheable=true)
  public static List<sirenum__Shift_Invitation__c> getUnfilledShiftShiftInvitations() {
    Date today = Date.today();
    List<sirenum__Shift_Invitation__c> shiftInvites = [
      SELECT
        Id,
        contact_name__c,
        sirenum__Contact__r.MobilePhone,
        sirenum__Contact__c,
        sirenum__Contact__r.Compliance_Status__c,sirenum__Contact__r.MailingPostalCode,
        Scheduled_Start_Time__c,
        Scheduled_End_Time__c,
        CreatedById,
        sirenum__Shift__r.OwnerId,IsPreviouslyWorked__c,
        sirenum__Shift__r.IP_BranchOfOwner__c,
        sirenum__Shift__r.sirenum__Team__c,
        sirenum__Shift__r.sirenum__Team__r.Name,
        sirenum__Shift__r.sirenum__Site__c,
        sirenum__Shift__r.Owner.Name,
        sirenum__Shift__r.sirenum__Site__r.Name,
        sirenum__Shift__r.sirenum__IsShiftDemand__c,
        Days_since_acceptance__c,
        sirenum__Shift__r.Owners_Branch_Id__c  
      FROM sirenum__Shift_Invitation__c
      WHERE
        (sirenum__Shift__r.sirenum__Published__c = FALSE
        OR sirenum__Shift__r.sirenum__IsShiftDemand__c = TRUE)
        AND sirenum__Shift__r.sirenum__Contact__c = NULL
        AND sirenum__Shift__r.sirenum__Cancelled__C = FALSE
        AND sirenum__Status__c = 'Accepted'
        AND Scheduled_Start_Time__c >= :today
      ORDER BY Scheduled_Start_Time__c ASC
    ];
    return shiftInvites;
  }
    
/** Get Rejection Reasons to display on Job Offer Response Screen */
 @AuraEnabled(Cacheable=true)
    public static List<JORejectionReasons__mdt> getRejectReasons() {
        List<JORejectionReasons__mdt> rejectRsnLst = [SELECT Label,RejectReasonComms__c FROM JORejectionReasons__mdt];
        return rejectRsnLst;
    }
    
    /** Check validations while accepting shifts on Job Offer Response Screen */
 @AuraEnabled()
    public static Map<Id,String> checkValidations(List<Id> selectedJOIdList) {
        Set<Id> candIdSet = new Set<Id>(); 
        Set<Id> updatedJOSetId = new Set<Id>(); 
        Boolean isShiftsOverlapping = false;
        Map<Id,sirenum__Shift_Invitation__c> joOverlapShiftsMap = new Map<Id,sirenum__Shift_Invitation__c>();
        Map<Id,List<sirenum__Shift__c>> candShiftMap = new Map<Id,List<sirenum__Shift__c>>();
        List<sirenum__Shift_Invitation__c> joToUpdateLst = new List<sirenum__Shift_Invitation__c>();
        List<sirenum__Shift_Invitation__c> selectedRows = new List<sirenum__Shift_Invitation__c>();
        List<sirenum__Shift_Invitation__c> completedJOLst = new List<sirenum__Shift_Invitation__c>();
        Map<Id,String> failedJOMap = new Map<Id,String>();
        Set<Id> selectedJOIdSet = new Set<Id>(),selectedShitIdSet = new Set<Id>();
        
        System.debug('selectedRows::'+JSON.serialize(selectedJOIdList));
        
        for(sirenum__Shift_Invitation__c eachShiftInvite : [ SELECT
        Id,
        contact_name__c,
        sirenum__Contact__r.MobilePhone,
        sirenum__Contact__c,
        sirenum__Contact__r.Compliance_Status__c,sirenum__Contact__r.MailingPostalCode,
        Scheduled_Start_Time__c,
        Scheduled_End_Time__c,
        CreatedById,sirenum__Shift__c,
        sirenum__Shift__r.OwnerId,IsPreviouslyWorked__c,
        sirenum__Shift__r.IP_BranchOfOwner__c,
        sirenum__Shift__r.sirenum__Team__c,
        sirenum__Shift__r.sirenum__Team__r.Name,
        sirenum__Shift__r.sirenum__Site__c,
        sirenum__Shift__r.Owner.Name,
        sirenum__Shift__r.sirenum__Site__r.Name,
        sirenum__Shift__r.sirenum__IsShiftDemand__c,
        Days_since_acceptance__c,
        sirenum__Shift__r.Owners_Branch_Id__c,
        sirenum__Shift__r.recordtype.developername FROM sirenum__Shift_Invitation__c WHERE Id IN :selectedJOIdList]){
            selectedRows.add(eachShiftInvite);
            candIdSet.add(eachShiftInvite.sirenum__Contact__c);
            selectedShitIdSet.add(eachShiftInvite.sirenum__Shift__c);
        }

        for(sirenum__Shift_Invitation__c eachShiftInvite : selectedRows){
            joToUpdateLst.add(eachShiftInvite);
        }

        if(!joToUpdateLst.isEmpty()){
            for(sirenum__Shift_Invitation__c eachShiftInvite : selectedRows){
                eachShiftInvite.sirenum__Status__c = 'Complete';
                Database.SaveResult srList = Database.update(eachShiftInvite,false);
                // Iterate through each returned result
                System.debug('updatedJOSetId::'+JSON.serialize(updatedJOSetId));
                if (srList.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                   updatedJOSetId.add(srList.getId());
                } else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : srList.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
            
            for(sirenum__Shift_Invitation__c eachShiftInvite : [SELECT Id,sirenum__Status__c,sirenum__Log__c FROM sirenum__Shift_Invitation__c WHERE Id IN :updatedJOSetId]){
                System.debug('eachShiftInvite::'+JSON.serialize(eachShiftInvite));
                if(eachShiftInvite.sirenum__Status__c == 'Failed'){
                    failedJOMap.put(eachShiftInvite.id,eachShiftInvite.sirenum__Log__c);
                }else if(eachShiftInvite.sirenum__Status__c == 'Complete'){
                    completedJOLst.add(eachShiftInvite);
                }
            }
    }
        System.debug('failedJOMap:::'+JSON.serialize(failedJOMap));
        return failedJOMap;
    }
}