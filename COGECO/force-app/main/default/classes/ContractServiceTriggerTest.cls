@isTest
private class ContractServiceTriggerTest {
    @isTest
    static void testBeforeInsert() {
        ContractService__c testContractService = new ContractService__c(
            Status__c = 'Present'

        );

        Test.startTest();
        insert testContractService;
        Test.stopTest();

        ContractService__c insertedContractService = [SELECT Status__c FROM ContractService__c WHERE Id = :testContractService.Id];
        System.assertEquals('Present', insertedContractService.Status__c, 'Status should be Present after BEFORE INSERT');
    }

    @isTest
    static void testBeforeUpdate() {
        ContractService__c testContractService = new ContractService__c(
            Status__c = 'Present'

        );
        insert testContractService;

        Test.startTest();
        testContractService.Status__c = 'Future'; 
        update testContractService;
        Test.stopTest();

 
        ContractService__c updatedContractService = [SELECT Status__c FROM ContractService__c WHERE Id = :testContractService.Id];
        System.assertEquals('Future', updatedContractService.Status__c, 'Status should be Future after BEFORE UPDATE');

    }

    @isTest
    static void testAfterInsert() {
        CustomContract__c testCustomContract = new CustomContract__c();
        insert testCustomContract;

        ContractService__c testContractService = new ContractService__c(
            Status__c = 'Present',
            Contract__c = testCustomContract.Id
        );

        Test.startTest();
        insert testContractService;
        Test.stopTest();

        CustomContract__c updatedContract = [SELECT Id, Monthly_Revenue__c FROM CustomContract__c WHERE Id = :testCustomContract.Id];
        System.assertNotEquals(null, updatedContract, 'CustomContract__c record should be updated');
    }

    @isTest
    static void testAfterUpdate() {
        CustomContract__c testCustomContract = new CustomContract__c();
        insert testCustomContract;

        ContractService__c testContractService = new ContractService__c(
            Status__c = 'Present',
            Contract__c = testCustomContract.Id
        );
        insert testContractService;

        testContractService.Status__c = 'Future'; 

        Test.startTest();
        update testContractService;
        Test.stopTest();

        CustomContract__c updatedContract = [SELECT Id, Monthly_Revenue__c FROM CustomContract__c WHERE Id = :testCustomContract.Id];
        System.assertNotEquals(null, updatedContract, 'CustomContract__c record should be updated');
        ContractService__c updatedContractService = [SELECT Status__c FROM ContractService__c WHERE Id = :testContractService.Id];
        System.assertEquals('Future', updatedContractService.Status__c, 'Status should be Future after AFTER UPDATE');
    }
}