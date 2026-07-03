@isTest
public class VendorSelectorVFController_Test {

    /* -------------------------------
     * Test Data Setup
     * ------------------------------- */
    private static SBQQ__QuoteLine__c createQuoteLine() {

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
            SBQQ__ListPrice__c = 100
        );
        insert ql;

        return ql;
    }

    private static void createVendor(String groupName) {
        APTS_Vendor__c vendor = new APTS_Vendor__c(
            APTS_Vendor_Name__c = 'Test Vendor',
            APTS_Vendor_Number__c = 'V001',
            APTS_Vendor_City__c = 'Bangalore',
            APTS_Vendor_State__c = 'KA',
            APTS_Invalid__c = false
        );
        insert vendor;
    }

    /* ------------------------------------------------
     * TEST 1: Constructor – LineId missing
     * ------------------------------------------------ */
    @isTest
    static void test_constructor_no_lineId() {

        PageReference pr = Page.VendorSelectorVF;
        pr.getParameters().put('QuoteId', 'Q123');
        Test.setCurrentPage(pr);

        VendorSelectorVFController ctrl =
            new VendorSelectorVFController();

        System.assertEquals(true, ctrl.errorCheck);
        System.assert(
            ctrl.errorMessage.contains('Line Item Id not found'),
            'Expected LineId error'
        );
    }

    /* ------------------------------------------------
     * TEST 2: Constructor – KB Order (Direct)
     * ------------------------------------------------ */
    @isTest
    static void test_constructor_kb_order_direct() {

        SBQQ__QuoteLine__c ql = createQuoteLine();
        createVendor('KCA Vendor');

        PageReference pr = Page.VendorSelectorVF;
        pr.getParameters().put('LineId', ql.Id);
        pr.getParameters().put('QuoteId', ql.SBQQ__Quote__c);
        pr.getParameters().put('itemCategory', 'KB Order(Direct)');
        Test.setCurrentPage(pr);

        VendorSelectorVFController ctrl =
            new VendorSelectorVFController();

       
    }

    /* ------------------------------------------------
     * TEST 3: Constructor – Project Category
     * ------------------------------------------------ */
    @isTest
    static void test_constructor_project_category() {

        SBQQ__QuoteLine__c ql = createQuoteLine();
        createVendor('Kitz Group Vendor');

        PageReference pr = Page.VendorSelectorVF;
        pr.getParameters().put('LineId', ql.Id);
        pr.getParameters().put('QuoteId', ql.SBQQ__Quote__c);
        pr.getParameters().put('itemCategory', 'Project w/ Spec');
        Test.setCurrentPage(pr);

        VendorSelectorVFController ctrl =
            new VendorSelectorVFController();

       
    }

    /* ------------------------------------------------
     * TEST 4: populateVendorIdOnLineItem – Success
     * ------------------------------------------------ */
    @isTest
    static void test_populate_vendor_success() {

        SBQQ__QuoteLine__c ql = createQuoteLine();

        PageReference pr = Page.VendorSelectorVF;
        pr.getParameters().put('LineId', ql.Id);
        pr.getParameters().put('QuoteId', ql.SBQQ__Quote__c);
        pr.getParameters().put('itemCategory', 'KB Order(Direct)');
        Test.setCurrentPage(pr);

        VendorSelectorVFController ctrl =
            new VendorSelectorVFController();

        ctrl.selectedVendorId = 'a0123456789';
        ctrl.selectedVendorName = 'Vendor ABC';
        ctrl.selectedVendorNo = 'V-100';

        Test.startTest();
        ctrl.populateVendorIdOnLineItem();
        Test.stopTest();

        SBQQ__QuoteLine__c updatedQL = [
            SELECT Vendor_Name__c, Vendor_No__c, Item_Category__c
            FROM SBQQ__QuoteLine__c
            WHERE Id = :ql.Id
        ];

        System.assertEquals('Vendor ABC', updatedQL.Vendor_Name__c);
        System.assertEquals('V-100', updatedQL.Vendor_No__c);
        System.assertEquals('KB Order(Direct)', updatedQL.Item_Category__c);
    }

    /* ------------------------------------------------
     * TEST 5: populateVendorIdOnLineItem – No Vendor
     * ------------------------------------------------ */
    @isTest
    static void test_populate_vendor_no_selection() {

        SBQQ__QuoteLine__c ql = createQuoteLine();

        PageReference pr = Page.VendorSelectorVF;
        pr.getParameters().put('LineId', ql.Id);
        pr.getParameters().put('QuoteId', ql.SBQQ__Quote__c);
        Test.setCurrentPage(pr);

        VendorSelectorVFController ctrl =
            new VendorSelectorVFController();

        Test.startTest();
        ctrl.populateVendorIdOnLineItem();
        Test.stopTest();

        System.assertEquals(true, ctrl.errorCheck);
        System.assertEquals(
            'Selected Vendor Id is null.',
            ctrl.errorMessage
        );
    }
}