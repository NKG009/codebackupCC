@isTest
public class WarehouseSelectorVFController_Test {

    // ------------------------------------
    // INNER MOCK CALLOUT CLASS
    // ------------------------------------
    public class InventoryCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);

            res.setBody('{"WAREHOUSE":{"WAREHOUSE_Data":[{"WAREHOUSE_NAME":"STAFFORD","WAREHOUSE_LOC":"USA","LGORT":"3008","QTY":100},{"WAREHOUSE_NAME":"INTRASIT","WAREHOUSE_LOC":"TRANSIT","LGORT":"3099","QTY":50}]}}');

            return res;
        }
    }

    // ------------------------------------
    // TEST DATA CREATION
    // ------------------------------------
    private static SBQQ__QuoteLine__c createQuoteData() {

        Account acc = new Account(Name = 'Test Account');
        insert acc;

        SBQQ__Quote__c quote = new SBQQ__Quote__c(
            SBQQ__Account__c = acc.Id
        );
        insert quote;

        Product2 prod = new Product2(
            Name = 'Test Product',
            IsActive = true
        );
        insert prod;

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

    // ------------------------------------
    // TEST 1: Constructor – LineId NULL
    // ------------------------------------
    @isTest
    static void test_constructor_no_lineId() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new InventoryCalloutMock());

        PageReference pr = Page.WarehouseSelectorVF;
        pr.getParameters().put('QuoteId', 'Q123');
        pr.getParameters().put('MatNum', '01K1AF6110');

        Test.setCurrentPage(pr);

        WarehouseSelectorVFController ctrl = new WarehouseSelectorVFController();

        System.assertEquals(true, ctrl.showLineIdError);
        System.assertEquals(
            '⚠️ Please do a Quick Save on Quote before Warehouse Selection.',
            ctrl.errorMessage
        );

        Test.stopTest();
    }

    // ------------------------------------
    // TEST 2: Apply Warehouse – Success
    // ------------------------------------
    @isTest
    static void test_applyWarehouse_success() {

        SBQQ__QuoteLine__c ql = createQuoteData();

        Test.setMock(HttpCalloutMock.class, new InventoryCalloutMock());

        PageReference pr = Page.WarehouseSelectorVF;
        pr.getParameters().put('LineId', ql.Id);
        pr.getParameters().put('QuoteId', ql.SBQQ__Quote__c);
        pr.getParameters().put('MatNum', '01K1AF6110');
        pr.getParameters().put('warehouseSelect', '1'); // STAFFORD

        Test.setCurrentPage(pr);

        WarehouseSelectorVFController ctrl = new WarehouseSelectorVFController();

        Test.startTest();
        PageReference result = ctrl.applyWarehouse();
        Test.stopTest();

        System.assertNotEquals(null, result);
        System.assert(
            result.getUrl().contains('/apex/SBQQ__sb'),
            'Should redirect to CPQ QLE'
        );

        SBQQ__QuoteLine__c updatedQL = [
            SELECT Warehouse__c,
                   Warehouse_Location__c,
                   Warehouse_Number__c,
                   Available_Qty__c
            FROM SBQQ__QuoteLine__c
            WHERE Id = :ql.Id
        ];

        System.assertEquals('STAFFORD', updatedQL.Warehouse__c);
        System.assertEquals('USA', updatedQL.Warehouse_Location__c);
        System.assertEquals('3008', updatedQL.Warehouse_Number__c);
        System.assertEquals(100, updatedQL.Available_Qty__c);
    }
}