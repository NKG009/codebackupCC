/**
 * @description       : 
 * @author            : avinash_s@decisionfoundry.com
 * @group             : 
 * @last modified on  : 12-30-2025;
 * @last modified by  : avinash_s@decisionfoundry.com
**/
public with sharing class OrderErrorQueueController {
    @AuraEnabled(Cacheable = true)
    public static List<Order_Error_Queue__c> getOEQRecords(){
        return [SELECT Id, Order__c,Order_Name__c,Error_Message__c,Last_Retry__c,CreatedDate,LastModifiedDate      
                FROM Order_Error_Queue__c 
                ORDER BY CreatedDate DESC 
                LIMIT 50];

    }
}