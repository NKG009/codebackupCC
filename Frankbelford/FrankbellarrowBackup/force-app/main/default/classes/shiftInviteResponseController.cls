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
        sirenum__Contact__r.Compliance_Status__c,
        Scheduled_Start_Time__c,
        Scheduled_End_Time__c,
        CreatedById,
        sirenum__Shift__r.OwnerId,
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
}