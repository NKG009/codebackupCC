@isTest
private class MobilityServiceControllerTest {

    private static AccountPlan createAccountPlan() {
        AccountPlan accPlan = new AccountPlan(Name = 'Test Plan');
        insert accPlan;
        return accPlan;
    }

    private static Mobility_Related_Service__c createService(Id accountPlanId) {
        Mobility_Related_Service__c service = new Mobility_Related_Service__c(
            Service_Element__c = 'Service A',
            TELUS_Roaming__c = 'Roaming',
            TELUS_MVNO_Wholesale__c = 'MVNO',
            ROGERS__c = 'Rogers',
            BELL__c = 'Bell',
            Account_Plan__c = accountPlanId
        );
        insert service;
        return service;
    }

    @isTest
    static void testGetMobilityServices() {
        AccountPlan plan = createAccountPlan();
        createService(plan.Id);

        Test.startTest();
        List<Mobility_Related_Service__c> results = MobilityServiceController.getMobilityServices(plan.Id);
        Test.stopTest();

        System.assertNotEquals(0, results.size(), 'Expected services to be returned');
    }

    @isTest
    static void testGetMobilityServicesWithBlankId() {
        Test.startTest();
        List<Mobility_Related_Service__c> results = MobilityServiceController.getMobilityServices('');
        Test.stopTest();

        System.assertEquals(0, results.size(), 'Expected no services for blank account plan Id');
    }

    @isTest
    static void testSaveMobilityServices_Insert() {
        AccountPlan plan = createAccountPlan();

        List<Mobility_Related_Service__c> newServices = new List<Mobility_Related_Service__c>{
            new Mobility_Related_Service__c(
                Service_Element__c = 'Insert Test',
                TELUS_Roaming__c = 'Roaming 1',
                TELUS_MVNO_Wholesale__c = 'MVNO 1',
                ROGERS__c = 'Rogers 1',
                BELL__c = 'Bell 1'
            )
        };

        Test.startTest();
        List<Mobility_Related_Service__c> saved = MobilityServiceController.saveMobilityServices(newServices, plan.Id);
        Test.stopTest();

        System.assertEquals(1, saved.size(), 'One record should be inserted');
        System.assertNotEquals(null, saved[0].Id, 'Record ID should not be null');
        System.assertEquals('Roaming 1', saved[0].TELUS_Roaming__c, 'Roaming value should match');
    }

    @isTest
    static void testSaveMobilityServices_Update() {
        AccountPlan plan = createAccountPlan();
        Mobility_Related_Service__c service = createService(plan.Id);
        service.TELUS_Roaming__c = 'Updated Roaming';

        Test.startTest();
        List<Mobility_Related_Service__c> updated = MobilityServiceController.saveMobilityServices(
            new List<Mobility_Related_Service__c>{ service }, plan.Id
        );
        Test.stopTest();

        System.assertEquals('Updated Roaming', updated[0].TELUS_Roaming__c);
    }

    @isTest
    static void testSaveMobilityServicesWithEmptyRecord() {
        AccountPlan plan = createAccountPlan();
        List<Mobility_Related_Service__c> emptyRecordList = new List<Mobility_Related_Service__c>{
            new Mobility_Related_Service__c() // All fields null
        };

        Test.startTest();
        try {
            MobilityServiceController.saveMobilityServices(emptyRecordList, plan.Id);
            System.assert(false, 'Expected AuraHandledException for empty record');
        } catch (AuraHandledException e) {}
        Test.stopTest();
    }

    @isTest
    static void testSaveMobilityServicesWithNullPlanId() {
        Boolean caught = false;
        try {
            MobilityServiceController.saveMobilityServices(
                new List<Mobility_Related_Service__c>{
                    new Mobility_Related_Service__c(Service_Element__c = 'S1')
                }, null
            );
        } catch (AuraHandledException e) {
            caught = true;
        }
        System.assert(caught, 'Expected exception for null AccountPlanId');
    }

    @isTest
    static void testDeleteMobilityService() {
        AccountPlan plan = createAccountPlan();
        Mobility_Related_Service__c service = createService(plan.Id);

        Test.startTest();
        MobilityServiceController.deleteMobilityService(service.Id);
        Test.stopTest();

        Integer count = [SELECT COUNT() FROM Mobility_Related_Service__c WHERE Id = :service.Id];
        System.assertEquals(0, count, 'Expected service to be deleted');
    }

    @isTest
    static void testDeleteMobilityServiceWithInvalidId() {
        Test.startTest();
        try {
            MobilityServiceController.deleteMobilityService(null);
            System.assert(false, 'Expected AuraHandledException for null ID');
        } catch (AuraHandledException e) {}
        Test.stopTest();
    }

    @isTest
    static void testValidateAccountPlanTrue() {
        AccountPlan plan = createAccountPlan();

        Test.startTest();
        Boolean isValid = MobilityServiceController.validateAccountPlan(plan.Id);
        Test.stopTest();

        System.assertEquals(true, isValid);
    }

    @isTest
    static void testValidateAccountPlanFalse() {
        Test.startTest();
        Boolean isValid = MobilityServiceController.validateAccountPlan('001000000000000');
        Test.stopTest();

        System.assertEquals(false, isValid);
    }

    @isTest
    static void testValidateAccountPlanWithNull() {
        Test.startTest();
        Boolean isValid = MobilityServiceController.validateAccountPlan(null);
        Test.stopTest();

        System.assertEquals(false, isValid);
    }
}