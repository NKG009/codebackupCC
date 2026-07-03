/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is Test Class for VendorWarehouseSelectionController
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
public class VendorWarehouseSelectionController_Test {
    
    /**************************************Methods*************************************************/
    
    /**
* ─────────────────────────────────────────────────────────────────────────────────────────────┐
* Method to test vendor selection.
* ──────────────────────────────────────────────────────────────────────────────────────────────
* @param    none
* ─────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    
    @isTest
    static void vendorSelectionTest(){
        
        PageReference pageRef = Page.VendorWarehouseSelectionPage;
        Account acc = Testutility.createAccount();
        insert acc;
        contact con = Testutility.createContact(acc.Id);
        insert con;
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        pricelist.Name =  'Standard USD PriceList';
        insert priceList;               
        
        Product2 prod = Testutility.createProduct();
        insert prod;
        
        Apttus_Config2__PriceListItem__c pli =  new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c = priceList.id;
        pli.Apttus_Config2__ProductId__c = prod.id;
        pli.Apttus_Config2__ListPrice__c = 100;
        pli.Apttus_Config2__Active__c = true;
        insert pli;
        
        Product2 prod2 = Testutility.createProduct();
        prod2.APTS_Spec_Pkg_Code__c = '';
        prod2.APTS_Warehouse_Number__c = '';
        insert prod2;
        
        Apttus_Config2__PriceListItem__c pli2 =  new Apttus_Config2__PriceListItem__c();
        pli2.Apttus_Config2__PriceListId__c = priceList.id;
        pli2.Apttus_Config2__ProductId__c = prod2.id;
        pli2.Apttus_Config2__ListPrice__c = 100;
        pli2.Apttus_Config2__Active__c = true;
        insert pli2;
        
        APTS_Vendor__c Vendor = Testutility.createVendor();
        insert Vendor;
        
        Apttus_Proposal__Proposal__c testProposal = Testutility.createProposal(acc.Id);
        insert testProposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = Testutility.createProductConfig(acc.Id, testProposal.Id);
        prodConfig.Apttus_Config2__PriceListId__c = priceList.Id;        
        insert prodConfig;        
        
        
        
        Apttus_Config2__LineItem__c lineItem = Testutility.createLineItem(prodConfig.Id, prod.Id);
        lineItem.Apttus_Config2__PriceListItemId__c = pli.id;
        lineItem.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem.Apttus_Config2__Quantity__c = 20;
        lineItem.APTS_KCA_Fig_Num__c = 'TestKCA';
        lineItem.APTS_Item_Category__c = 'Stock Order';
        lineItem.APTS_Customer_PO_Line_Number__c = 1.0;
        lineItem.APTS_Size_inch__c = '12'; 
        lineItem.Apttus_Config2__LineNumber__c = 1.0;
        lineItem.APTS_Material_Num__c = '01A1A84040';
        lineItem.APTS_Mat_Grp_1_CIT__c = 'C';
        lineItem.APTS_Mat_Grp_2_Catlg__c = 'LF';
        lineItem.APTS_Mat_Grp_3_Catgr_CD__c = '21';
        insert lineItem;
        
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id', prodConfig.Id);
        VendorWarehouseSelectionController controller = new VendorWarehouseSelectionController();
        List<Apttus_Config2__LineItem__c> configLineItemList = controller.getConfigLineItemData();
        controller.handleError();
        controller.saveAndBackToCart();
        controller.saveLineItems();
        controller.cancel();
        
        
        Test.stopTest();
    }
    
    
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method to test no product config Id.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    none
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    
    @isTest
    static void testNoConfigId(){
        VendorWarehouseSelectionController controller = new VendorWarehouseSelectionController();
    }
}