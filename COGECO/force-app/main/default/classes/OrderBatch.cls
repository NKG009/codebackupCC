public without sharing class OrderBatch implements Database.Batchable<SObject> {
    private String accountId;
    
    public OrderBatch() { }
    
    public OrderBatch(String accountId) {
        this.accountId = accountId;
    }
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        String activatedStatus = ApexConstants.ORDER_STATUS_ACTIVATED;
        String activeStatus = ApexConstants.ASSET_PROVISIONING_STATUS_ACTIVE;
        String accountFilter = '';
        
        if (String.isNotBlank(this.accountId)) {
            String accountId = this.accountId;
            accountFilter = ' AND AccountId = :accountId ';
        }
        
        String query = 'SELECT Id, Renewal_Date__c, AccountId, Account.Next_Renewal_Date__c FROM Order WHERE Renewal_Date__c > TODAY ' + accountFilter + ' AND Status = :activatedStatus AND Account.Account_Status__c = :activeStatus';
        
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<SObject> scope) {
        if (scope == null || scope.isEmpty()) {
            return;
        }
        
        TriggerHelper.isAssetRollupBatchJob = true;
        processAccounts((List<Order>)scope);
    }
    
    public void finish(Database.BatchableContext context) {
        
    }
    @testVisible
    private static void processAccounts(List<Order> orderRecords) {
        Map<Id, Account> accountsToProcess = new Map<Id, Account>();
        
        if (orderRecords != null) {
            for (Order orderRecord : orderRecords) {
                if (orderRecord.Account.Next_Renewal_Date__c == null || orderRecord.Account.Next_Renewal_Date__c > orderRecord.Renewal_Date__c) {
                	accountsToProcess.put(orderRecord.AccountId, new Account(Id = orderRecord.AccountId, Next_Renewal_Date__c = orderRecord.Renewal_Date__c));
                }
            }
        }
        
        accountsToProcess.remove(null);
        
        if (!accountsToProcess.isEmpty()) {
            List<Database.SaveResult> saveResults = Database.update(accountsToProcess.values(), false);
        }
    }
}