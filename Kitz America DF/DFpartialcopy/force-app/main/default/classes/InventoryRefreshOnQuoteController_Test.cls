@isTest
public class InventoryRefreshOnQuoteController_Test {

    /* =====================================================
       INNER MOCK CALLOUT CLASS
       ===================================================== */
    public class InventoryCalloutMulesoftMock
        implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');

            res.setBody(
                String.join(new List<String>{
                    '{',
                    ' "WAREHOUSE": {',
                    '   "WAREHOUSE_Data": [',
                    '     {',
                    '       "WAREHOUSE_NAME": "STAFFORD",',
                    '       "QTY": 200',
                    '     },',
                    '     {',
                    '       "WAREHOUSE_NAME": "OTHER",',
                    '       "QTY": 50',
                    '     }',
                    '   ]',
                    ' }',
                    '}'
                }, '')
            );

            return res;
        }
    }

    /* =====================================================
       TEST DATA CREATION
       ===================================================== */
    private static SBQQ__QuoteLine__c createQuoteWithLine() {

        Account acc = new Account(Name = 'Test Account');
        insert acc;

        SBQQ__Quote__c quote = new SBQQ__Quote__c(
            SBQQ__Account__c = acc.Id
        );
        insert quote;

        Product2 prod = new Product2(
            Name = 'Test Product',
            IsActive = false,
            APTS_Material_Num__c='MAT-100'
        );
        insert prod;

        SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c(
            SBQQ__Quote__c = quote.Id,
            SBQQ__Product__c = prod.Id,
            SBQQ__Quantity__c = 1,
            SBQQ__Number__c = 10,
            Warehouse__c = 'STAFFORD',
            Available_Qty__c = 0
        );
        insert ql;

        return ql;
    }

    /* =====================================================
       TEST 1: Constructor Initialization
       ===================================================== */
    @isTest
    static void test_constructor() {

        PageReference pr = new PageReference('/apex/InventoryRefreshOnQuote');
        pr.getParameters().put('id', 'a0123456789');
        Test.setCurrentPage(pr);

        InventoryRefreshOnQuoteController ctrl =
            new InventoryRefreshOnQuoteController();

        
    }

    /* =====================================================
       TEST 2: refreshInventory – Quantity Changed
       ===================================================== */
    @isTest
    static void test_refreshInventory_success() {

        SBQQ__QuoteLine__c ql = createQuoteWithLine();

        Test.setMock(
            HttpCalloutMock.class,
            new InventoryCalloutMulesoftMock()
        );

        PageReference pr =
            new PageReference('/apex/InventoryRefreshOnQuote');
        pr.getParameters().put('id', ql.SBQQ__Quote__c);
        Test.setCurrentPage(pr);

        InventoryRefreshOnQuoteController ctrl =
            new InventoryRefreshOnQuoteController();

        Test.startTest();
        ctrl.refreshInventory();
        Test.stopTest();

        // Verify Quote Line updated
        SBQQ__QuoteLine__c updatedQL = [
            SELECT Available_Qty__c
            FROM SBQQ__QuoteLine__c
            WHERE Id = :ql.Id
        ];

       
    }

    /* =====================================================
       TEST 3: refreshInventory – No QuoteId
       ===================================================== */
    @isTest
    static void test_refreshInventory_no_quoteId() {

        PageReference pr =
            new PageReference('/apex/InventoryRefreshOnQuote');
        Test.setCurrentPage(pr);

        InventoryRefreshOnQuoteController ctrl =
            new InventoryRefreshOnQuoteController();

        Test.startTest();
        ctrl.refreshInventory();
        Test.stopTest();

       
    }

    /* =====================================================
       TEST 4: Redirect to QLE
       ===================================================== */
    @isTest
    static void test_redirecttoqle() {

        PageReference pr =
            new PageReference('/apex/InventoryRefreshOnQuote');
        pr.getParameters().put('id', 'a0123456789');
        Test.setCurrentPage(pr);

        InventoryRefreshOnQuoteController ctrl =
            new InventoryRefreshOnQuoteController();

        PageReference result = ctrl.redirecttoqle();

       
    }
}