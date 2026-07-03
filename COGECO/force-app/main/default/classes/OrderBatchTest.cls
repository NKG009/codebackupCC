@isTest
private class OrderBatchTest {

    @isTest
    static void testOrderBatch() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account', Account_Status__c = 'Active', Next_Renewal_Date__c = Date.today().addDays(10));
        insert testAccount;

        Order testOrder = new Order(Status = 'Draft', EffectiveDate=System.today(),AccountId = testAccount.Id);
        insert testOrder;

        // Start the batch job
        Test.startTest();
        OrderBatch orderBatch = new OrderBatch(testAccount.Id);
        Database.executeBatch(orderBatch);
        Test.stopTest();

        // Verify the results
        Account updatedAccount = [SELECT Next_Renewal_Date__c FROM Account WHERE Id = :testAccount.Id LIMIT 1];
        System.assertEquals(Date.today().addDays(10), updatedAccount.Next_Renewal_Date__c, 'Next_Renewal_Date__c should be updated');
        
    }
    @istest
    static void testprocessAccounts(){
        Account testAccount = new Account(Name = 'Test Account', Account_Status__c = 'Active');
        insert testAccount;

        Order testOrder = new Order(Status = 'Draft',EffectiveDate=System.today(),AccountId = testAccount.Id);
        insert testOrder;
        List<Order> ord=[SELECT Id, Renewal_Date__c, AccountId, Account.Next_Renewal_Date__c FROM Order limit 1];
        OrderBatch.processAccounts(ord);
    }
}