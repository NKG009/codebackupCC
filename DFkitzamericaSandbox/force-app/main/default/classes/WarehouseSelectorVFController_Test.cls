@isTest
public class WarehouseSelectorVFController_Test {
    
    private static PricebookEntry createPBE(Product2 prod) {
        Pricebook2 pb = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];

        PricebookEntry pbe = new PricebookEntry(
            Product2Id = prod.Id,
            Pricebook2Id = pb.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert pbe;
        return pbe;
    }
    

    // Helper to create Quote + QuoteLine
    private static SBQQ__QuoteLine__c createQuoteData() {
        
        // Create an Account
        Account acc = new Account(Name = 'Test Acc');
        insert acc;

        // Create Quote
        SBQQ__Quote__c quote = new SBQQ__Quote__c(
           
            SBQQ__Account__c = acc.Id
        );
        insert quote;
		
        Product2 prod = new Product2(
            Name = 'Discount Product',
            IsActive = true
        );
        insert prod;

        // Create Quote Line
        SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c(
            SBQQ__Quote__c = quote.Id,
            SBQQ__Product__c = prod.Id,
            SBQQ__Quantity__c = 1,
            SBQQ__ListPrice__c = 200,
            SBQQ__Discount__c = 0
        );
        insert ql;

        return ql;
    }

    // ------------------------------------------------------
    // TEST 1: Constructor when quoteLineId = null
    // ------------------------------------------------------
    @isTest
    static void test_constructor_no_lineId() {

        Test.startTest();

        PageReference pr = Page.WarehouseSelectorVF; // create a VF page in test context
        pr.getParameters().put('LineId', null);
        pr.getParameters().put('QuoteId', 'Q123');

        Test.setCurrentPage(pr);

        WarehouseSelectorVFController ctrl = new WarehouseSelectorVFController();

        System.assertEquals(true, ctrl.showLineIdError, 'Error flag should be true when LineId is null');
        System.assertNotEquals(0, ctrl.warehouseList.size(), 'Warehouse list should be created');

        Test.stopTest();
    }

    @isTest
    static void test_applyWarehouse_success() {

        SBQQ__QuoteLine__c ql = createQuoteData();

        PageReference pr = Page.WarehouseSelectorVF;
        pr.getParameters().put('LineId', ql.Id);
        pr.getParameters().put('QuoteId', ql.SBQQ__Quote__c);
        pr.getParameters().put('warehouseSelect', '1');  // selects ROW 1 from data

        Test.setCurrentPage(pr);

        WarehouseSelectorVFController ctrl = new WarehouseSelectorVFController();

        Test.startTest();
        PageReference result = ctrl.applyWarehouse();
        Test.stopTest();

        // Verify redirect is correct
        System.assertNotEquals(null, result, 'Should redirect');
        System.assert(result.getUrl().contains('/apex/SBQQ__sb'), 'Must redirect to CPQ QLE');

        // Verify line was updated
        SBQQ__QuoteLine__c qlUpdated = [
            SELECT Warehouse__c, Available_Qty__c
            FROM SBQQ__QuoteLine__c
            WHERE Id = :ql.Id
        ];

        System.assertNotEquals(null, qlUpdated.Warehouse__c, 'Warehouse value must be set');
        System.assert(qlUpdated.Available_Qty__c > 0, 'Quantity must be updated from warehouse list');
    }
}