public inherited sharing class AccountSelector {
    public static List<Account> getAllActiveBillingAccountsFromCustomerAccount(Id recordId) {
        return [SELECT Id, AccountNumber FROM Account WHERE ParentId = :recordId AND RecordTypeId = :ApexConstants.ACCOUNT_BILLING_RECORD_TYPE_ID AND vlocity_cmt__Active__c IN :ApexConstants.BILLING_ACCOUNT_ACTIVE_STATUSES];
    }
    
    public static List<Account> getAccountsForRollupProcessing(Set<Id> accountIds) {
        return [SELECT Id, MRR_Rollup_Job_Id__c, Recurring_Total__c, Next_Renewal_Date__c FROM Account WHERE Id IN :accountIds];
    }

    public static List<Account> getAdditionalFieldsForTombstone(Id recordId) {
        return [SELECT toLabel(Account_Status__c) FROM Account WHERE Id = :recordId];
    }
}