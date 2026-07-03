/**
    * ─────────────────────────────────────────────────────────────────────────────────────────────────┐
    * This is Test Class for VendorScreenController
    * ──────────────────────────────────────────────────────────────────────────────────────────────────
    * @author         Sumit   <sumit.m@standav.com>
    * @modifiedBy     Sumit   <sumit.m@standav.com>
    * @maintainedBy   Sumit   <sumit.m@standav.com>
    * @version        1.0
    * @created        2020-04-29
    * @modified       2020-04-29
    * ────────────────────────────────────────────────────────────────────────────────────────────────── 
	*/

@isTest
public class VendorScreenController_Test {

    /**************************************Methods*************************************************/
    
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method to test vendor list scenario.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    none
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    
    @isTest
    static void testGetVendorsList(){

        Account acc1 = Testutility.createAccount();
        
        insert acc1;

        Contact con1 = Testutility.createContact(acc1.Id);

        insert con1;

        Product2 prod1 = Testutility.createProduct();
        prod1.APTS_Material_Num__c = '01A1A84040';

        insert prod1;

        Apttus_Config2__PriceList__c priceList1 = Testutility.createPriceList();

        insert priceList1;

        Apttus_Proposal__Proposal__c proposal1 = Testutility.createProposal(acc1.Id);
        proposal1.Apttus_QPConfig__PriceListId__c = priceList1.Id;

        insert proposal1;


        Apttus_Config2__ProductConfiguration__c productConfig1 = Testutility.createProductConfig(acc1.Id, proposal1.Id);
        
        insert productConfig1;
        
        
        Apttus_Config2__LineItem__c lineItem1 = Testutility.createLineItem(productConfig1.Id, prod1.Id);
        lineItem1.Apttus_Config2__PriceListId__c = priceList1.Id;
        lineItem1.Apttus_Config2__ShipToAccountId__c = acc1.Id;
        lineItem1.APTS_Material_Num__c = '01A1A84040';
        lineItem1.APTS_Mat_Grp_1_CIT__c = 'C';
        lineItem1.APTS_Mat_Grp_2_Catlg__c = 'LF';
        lineItem1.APTS_Mat_Grp_3_Catgr_CD__c = '21';

        insert lineItem1;

        Apexpages.currentPage().getParameters().put('id',lineItem1.Id);


        APTS_Vendor__c vendor1 = Testutility.createVendor();
        
        insert vendor1;

        VendorScreenController controller = new VendorScreenController();

    }

    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method to test no vendor list scenario.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    none
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */

    @isTest
    static void testNoVendorsList(){

        Account acc1 = Testutility.createAccount();
        
        insert acc1;

        Contact con1 = Testutility.createContact(acc1.Id);

        insert con1;

        Product2 prod1 = Testutility.createProduct();
        prod1.APTS_Material_Num__c = '01A1A84040';

        insert prod1;

        Apttus_Config2__PriceList__c priceList1 = Testutility.createPriceList();

        insert priceList1;

        Apttus_Proposal__Proposal__c proposal1 = Testutility.createProposal(acc1.Id);
        proposal1.Apttus_QPConfig__PriceListId__c = priceList1.Id;

        insert proposal1;


        Apttus_Config2__ProductConfiguration__c productConfig1 = Testutility.createProductConfig(acc1.Id, proposal1.Id);
        
        insert productConfig1;
        
        
        Apttus_Config2__LineItem__c lineItem1 = Testutility.createLineItem(productConfig1.Id, prod1.Id);
        lineItem1.Apttus_Config2__PriceListId__c = priceList1.Id;
        lineItem1.Apttus_Config2__ShipToAccountId__c = acc1.Id;
        lineItem1.APTS_Material_Num__c = '01A1A84040';
        lineItem1.APTS_Mat_Grp_1_CIT__c = 'C';
        lineItem1.APTS_Mat_Grp_2_Catlg__c = 'LF';
        lineItem1.APTS_Mat_Grp_3_Catgr_CD__c = '21';

        insert lineItem1;

        Apexpages.currentPage().getParameters().put('id',lineItem1.Id);

        VendorScreenController controller = new VendorScreenController();
    }

    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method to test no line item scenario.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    none
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */

    @isTest
    static void testNoLineItemId(){

        VendorScreenController controller = new VendorScreenController();
    }


    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method to test populate selected vendor on line item.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    none
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */

    @isTest
    static void testPopulateVendorIdOnLineItem(){

        Account acc1 = Testutility.createAccount();
        
        insert acc1;

        Contact con1 = Testutility.createContact(acc1.Id);

        insert con1;

        Product2 prod1 = Testutility.createProduct();
        prod1.APTS_Material_Num__c = '01A1A84040';

        insert prod1;

        Apttus_Config2__PriceList__c priceList1 = Testutility.createPriceList();

        insert priceList1;

        Apttus_Proposal__Proposal__c proposal1 = Testutility.createProposal(acc1.Id);
        proposal1.Apttus_QPConfig__PriceListId__c = priceList1.Id;

        insert proposal1;


        Apttus_Config2__ProductConfiguration__c productConfig1 = Testutility.createProductConfig(acc1.Id, proposal1.Id);
        
        insert productConfig1;
        
        
        Apttus_Config2__LineItem__c lineItem1 = Testutility.createLineItem(productConfig1.Id, prod1.Id);
        lineItem1.Apttus_Config2__PriceListId__c = priceList1.Id;
        lineItem1.Apttus_Config2__ShipToAccountId__c = acc1.Id;
        lineItem1.APTS_Material_Num__c = '01A1A84040';
        lineItem1.APTS_Mat_Grp_1_CIT__c = 'C';
        lineItem1.APTS_Mat_Grp_2_Catlg__c = 'LF';
        lineItem1.APTS_Mat_Grp_3_Catgr_CD__c = '21';

        insert lineItem1;

        Apexpages.currentPage().getParameters().put('id',lineItem1.Id);


        APTS_Vendor__c vendor1 = Testutility.createVendor();
        
        insert vendor1;

        VendorScreenController controller = new VendorScreenController();

        controller.selectedVendorId = vendor1.Id;

        controller.selectedVendorName = 'test';

        controller.selectedVendorNo = '123';

        controller.populateVendorIdOnLineItem();

        //For covering catch part

        controller.selectedVendorId = '1111';

        controller.populateVendorIdOnLineItem();
    }


    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method to test empty selected vendor id.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    none
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */

    @isTest
    static void testEmptySelectedVendorId(){

        VendorScreenController controller = new VendorScreenController();

        controller.populateVendorIdOnLineItem();
    }

    
}