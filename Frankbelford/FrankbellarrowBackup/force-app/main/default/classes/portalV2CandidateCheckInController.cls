public with sharing class portalV2CandidateCheckInController {
    @AuraEnabled(cacheable=true)
    public static List<sirenum__Shift__c> getShiftsForSite(List<String> siteIds){
        DateTime today = System.today();
        DateTime endOfDay = DateTime.newInstance(System.Now().Year(), System.Now().Month(), System.Now().Day(), 23, 59, 59);
        //get current user account
        Id currentUserId = UserInfo.getUserId();
        User currentUser = [SELECT Id, ContactId FROM User WHERE Id =: currentUserId];
        Contact userContact = [SELECT Id, AccountId FROM Contact WHERE Id =: currentUser.ContactId];
    
        List<sirenum__Shift__c> output = new List<sirenum__Shift__c>();
        output = [SELECT Id, sirenum__Actual_Start_Time__c, sirenum__Actual_End_Time__c,
                sirenum__Contact__r.Name, sirenum__Accepted__c, sirenum__Team__r.Name,
                sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c
                FROM sirenum__Shift__c 
                WHERE sirenum__Contact__c != NULL 
                AND sirenum__Published__c = TRUE
                AND sirenum__Cancelled__c = FALSE
                AND sirenum__ShiftDemand__c = NULL
                AND Unfilled_Shift__c = FALSE
                AND sirenum__Site__c IN: siteIds
                AND ((sirenum__Scheduled_Start_Time__c >=: today AND sirenum__Scheduled_Start_Time__c <=: endOfDay) OR (sirenum__Scheduled_End_Time__c >=: today AND sirenum__Scheduled_End_Time__c <=: endOfDay)) 
                 AND IP_Account__c =: userContact.AccountId
                ];

        return output;
    }
}