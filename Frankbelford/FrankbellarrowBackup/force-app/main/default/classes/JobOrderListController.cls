/**
 * Created by mrahman on 2020-08-21.
 */

public with sharing class JobOrderListController {

    /**
     * This function returns all job order of the user account
     *
     * @param userId
     * @param status
     *
     * @return
     */
    @AuraEnabled
    public static List<sirenum__JobOrder__c> getJobOrders(Id userId, String status) {
        Id accountId = [SELECT Contact.Account.Id FROM User WHERE Id = :userId].Contact.Account.Id;
        System.debug('userId: ' + userId + ' status: ' + status + ' accountId: ' + accountId);
        List<sirenum__JobOrder__c> jobOrders = [SELECT Id, Name
                                                        ,sirenum__StartDate__c
                                                        ,sirenum__EndDate__c
                                                        ,sirenum__Status__c
                                                        ,Date_Confirmed__C
                                                        ,CreatedDate
                                                FROM sirenum__JobOrder__c
                                                WHERE sirenum__Status__c =: status
                                                  AND sirenum__Account__c =: accountId];
        return jobOrders;
    }

}