@isTest
public class restockOrdersAndETAController_Test {

    /* =========================================
       TEST 1: Constructor Parameter Assignment
       ========================================= */
    @isTest
    static void test_constructor() {

        PageReference pr = new PageReference('/apex/RestockOrdersAndETA');
        pr.getParameters().put('id', 'a0123456789');
        pr.getParameters().put('MatNum', 'MAT-100');

        Test.setCurrentPage(pr);

        restockOrdersAndETAController ctrl =
            new restockOrdersAndETAController();

        System.assertEquals('a0123456789', ctrl.quoteId);
        System.assertEquals('MAT-100', ctrl.materialNumber);
    }

    /* =========================================
       TEST 2: restockOrdersAndETA() Method
       ========================================= */
    @isTest
    static void test_restockOrdersAndETA() {

        Test.startTest();
        
       restockOrdersAndETAController.restockOrdersAndETA('MAT-100');
        Test.stopTest();

      
       
    }
}