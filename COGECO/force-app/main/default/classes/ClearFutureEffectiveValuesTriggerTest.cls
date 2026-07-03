@isTest
private class ClearFutureEffectiveValuesTriggerTest {

    @isTest
    static void testClearFutureEffectiveValues() {
      
        CustomContract__c testContract = new CustomContract__c();
        testContract.FutureEffectiveClearFlag__c = true;
        insert testContract;

       
        ContractService__c presentService = new ContractService__c(
            Status__c = 'Present',
            Contract__c = testContract.Id,
            Bulk_Rate__c = 100 
        );
        insert presentService;

        Test.startTest();
        testContract.FutureEffectiveClearFlag__c = true;
        update testContract;
        Test.stopTest();

        CustomContract__c updatedContract = [SELECT Id, Monthly_Revenue__c, FutureEffectiveFlag__c, FutureEffectiveClearFlag__c, future_effective_date__c FROM CustomContract__c WHERE Id = :testContract.Id];

        System.assertEquals(100, updatedContract.Monthly_Revenue__c, 'Monthly Revenue should match the total Bulk Rate');
        System.assertEquals(false, updatedContract.FutureEffectiveFlag__c, 'FutureEffectiveFlag__c should be set to false');
        System.assertEquals(false, updatedContract.FutureEffectiveClearFlag__c, 'FutureEffectiveClearFlag__c should be set to false');
        System.assert(updatedContract.future_effective_date__c == null, 'future_effective_date__c should be null');
    
    }
}