@isTest
private class CopyFutureServicesIntoPresentTest {

    @isTest
    static void testTriggerLogic() {
        CustomContract__c testContract = new CustomContract__c(
            FutureEffectiveFlag__c = true,
            future_effective_date__c = Date.today()
            
        );
        insert testContract;

        ContractService__c presentService = new ContractService__c(
            Status__c = 'Present',
            Contract__c = testContract.Id
            
        );
        insert presentService;

        ContractService__c futureService = new ContractService__c(
            Status__c = 'Future',
            Contract__c = testContract.Id
            
        );
        insert futureService;

        Test.startTest();
        testContract.FutureEffectiveFlag__c = true;
        update testContract;
        Test.stopTest();

        List<ContractService__c> updatedServices = [
            SELECT Id, Status__c, Z_Inactive_Date__c
            FROM ContractService__c
            WHERE Contract__c = :testContract.Id
        ];

        System.assertEquals(2, updatedServices.size());
        for (ContractService__c service : updatedServices) {
            if (service.Status__c == 'Z - Inactive') {              
                System.assertEquals(testContract.future_effective_date__c, service.Z_Inactive_Date__c);
            } else if (service.Status__c == 'Future') {
               
            }
        }
    }
}