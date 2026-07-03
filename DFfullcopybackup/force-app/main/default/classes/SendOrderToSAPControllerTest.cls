/**
 * @description       : 
 * @author            : avinash_s@decisionfoundry.com
 * @group             : 
 * @last modified on  : 01-02-2026;
 * @last modified by  : avinash_s@decisionfoundry.com
**/
@isTest
public with sharing class SendOrderToSAPControllerTest {

    @testSetup
    static void setupData() {
        SAP_Order_Integration_Settings__c Setting = new SAP_Order_Integration_Settings__c();
        Setting = TestUtilityv2.createSAP_Order_Integration_Settings_Mulesoft(true);
        
        Account acc = TestUtilityv2.createAccount();
        insert acc;
        
        contact con = TestUtilityv2.createContact(acc.Id);
        insert con;

        Opportunity opp = new Opportunity(
            Name = 'Test Opp',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Pricebook2Id = Test.getStandardPricebookId() // Crucial for CPQ
        );
        insert opp;

        Product2 prod = Testutility.createProduct();
        insert prod;

        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = prod.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert pbe;

        SBQQ__Quote__c quote = new SBQQ__Quote__c(
            SBQQ__Account__c = acc.Id,
            SBQQ__Opportunity2__c = opp.Id,
            SBQQ__PricebookId__c = Test.getStandardPricebookId(),
            SBQQ__Primary__c = true,
            SBQQ__StartDate__c = Date.today()
        );
        insert quote;

        SBQQ__QuoteLine__c qLine = new SBQQ__QuoteLine__c(
            SBQQ__Quote__c = quote.Id,
            SBQQ__Product__c = prod.Id,
            SBQQ__PricebookEntryId__c = pbe.Id,
            SBQQ__Quantity__c = 1,
            SBQQ__ListPrice__c = 100
        );
        insert qLine;        
    }
    
    @isTest
    static void sendOrderToSAPSuccessTest(){
        SBQQ__Quote__c quote = [SELECT Id, SBQQ__Ordered__c FROM SBQQ__Quote__c LIMIT 1];
        
        
        quote.SBQQ__Ordered__c = true;
        update quote;
        Order[] orders = [SELECT Id, Status, AccountId FROM Order WHERE SBQQ__Quote__c = :quote.Id];
        System.assertEquals(1, orders.size(), 'Order should have been created automatically by CPQ.');
        orders[0].Sales_Order_Type__c = 'Standard Order';
        orders[0].PoNumber = 'CPQTest-Indent';
        orders[0].Freight_Terms__c = 'Freight Allowed';
        update orders[0];
        Test.setMock(HttpCalloutMock.class, new SendOrderToSAPCalloutMock());
        Test.startTest();
        SendOrderToSAPController.sendOrderToSAP(orders[0].Id);
        Test.stopTest(); 
    }

    @isTest
    static void sendOrderToSAPFailureTest(){
        SBQQ__Quote__c quote = [SELECT Id, SBQQ__Ordered__c FROM SBQQ__Quote__c LIMIT 1];
        quote.SBQQ__Ordered__c = true;
        update quote;
        Order[] orders = [SELECT Id, Status, AccountId FROM Order WHERE SBQQ__Quote__c = :quote.Id];
        System.assertEquals(1, orders.size(), 'Order should have been created automatically by CPQ.');
        orders[0].Sales_Order_Type__c = 'Standard Order';
        orders[0].PoNumber = 'CPQTest-Indent';
        orders[0].Freight_Terms__c = 'Freight Allowed';
        update orders[0];
        Test.setMock(HttpCalloutMock.class, new SendOrderToSAPCalloutMock400());
        Test.startTest();
        SendOrderToSAPController.sendOrderToSAP(orders[0].Id);
        OrderErrorQueueController.getOEQRecords();
        Test.stopTest(); 
    }

    @isTest
    static void sendOrderToSAPFailureTest2(){
        SBQQ__Quote__c quote = [SELECT Id, SBQQ__Ordered__c FROM SBQQ__Quote__c LIMIT 1];
        quote.SBQQ__Ordered__c = true;
        update quote;
        Order[] orders = [SELECT Id, Status, AccountId FROM Order WHERE SBQQ__Quote__c = :quote.Id];
        System.assertEquals(1, orders.size(), 'Order should have been created automatically by CPQ.');
        orders[0].Sales_Order_Type__c = 'Standard Order';
        orders[0].PoNumber = 'CPQTest-Indent';
        orders[0].Freight_Terms__c = 'Freight Allowed';
        update orders[0];
        Test.setMock(HttpCalloutMock.class, new SendOrderToSAPCalloutMock2400());
        Test.startTest();
        SendOrderToSAPController.sendOrderToSAP(orders[0].Id);
        OrderErrorQueueController.getOEQRecords();
        Test.stopTest(); 
    }

    @isTest
    static void checkForDuplicatesTest(){
        SBQQ__Quote__c quote = [SELECT Id, SBQQ__Ordered__c FROM SBQQ__Quote__c LIMIT 1];
        
        quote.SBQQ__Ordered__c = true;
        update quote;
        Order[] orders = [SELECT Id, Status, AccountId FROM Order WHERE SBQQ__Quote__c = :quote.Id];        
        
        SendOrderToSAPController.checkForDuplicates(orders[0].Id);
    }

    @isTest
    static void checkValidationsTest(){
        SBQQ__Quote__c quote = [SELECT Id, SBQQ__Ordered__c FROM SBQQ__Quote__c LIMIT 1];
        
        quote.SBQQ__Ordered__c = true;
        update quote;
        Order[] orders = [SELECT Id, Status, AccountId FROM Order WHERE SBQQ__Quote__c = :quote.Id];        
        
        Test.setMock(HttpCalloutMock.class, new SaporderCalloutMock());
        Test.startTest();
        SendOrderToSAPController.sendOrderToSAP(orders[0].Id);
        Test.stopTest(); 
    }


}