@isTest
public class WarehouseScreenControllerTest {
    @isTest
    static void warehouseScreenTest(){
        
        PageReference pageRef = Page.WarehouseScreenPage;
        Account acc = Testutility.createAccount();
        insert acc;
        contact con = Testutility.createContact(acc.Id);
        insert con;
        
        SAP_Order_Integration_Settings__c Setting = new SAP_Order_Integration_Settings__c();
        Setting = Testutility.createSAP_Order_Integration_Settings(true);
        InventoryCallout call = new InventoryCallout();
        Test.setMock(HttpCalloutMock.class, new InventoryCalloutMock()); 
        String strResp = call.callInventory('01K1A87063', 'ALL');
        
        
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
        
        Apttus_Proposal__Proposal__c testProposal = Testutility.createProposal(acc.Id);
        insert testProposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = Testutility.createProductConfig(acc.Id, testProposal.Id);
        insert prodConfig;        
        
        Apttus_Config2__LineItem__c lineItem = Testutility.createLineItem(prodConfig.Id, prod.Id);
        lineItem.Apttus_Config2__PriceListId__c = priceList.Id;
        lineItem.Apttus_Config2__PriceListItemId__c = pli.id;
        lineItem.APTS_Material_Num__c = '01K1A87063';
        
        insert lineItem;
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('mtrno', '01K1A87063');
        ApexPages.currentPage().getParameters().put('id', String.valueOf(lineItem.Id));
        WarehouseScreenController testWhController = new WarehouseScreenController();
        testWhController.getLineItemDetails();
        testWhController.getMockDataForRestockOrderAndETA();
        testWhController.getMockDataForIndentETA();
        testWhController.getMockDataForAllocation();
        
        // Test case to cover populateLineItem
        testWhController.selectedWarehouseName = 'TestWH';
        testWhController.selectedWarehouseNo = 'TestWh3000';
        testWhController.selectedWarehouseLocation = 'Test Texas';
        testWhController.availQnty = 20;
        testWhController.restockmsg = true;
        
        testWhController.Indentmsg = true;
        
        testWhController.Allocationmsg  = true;
        testWhController.populateWareHouseOnLineItem();
        
        Test.stopTest();
    }
    
    @isTest
    static void warehouseScreenTest2(){
        
        PageReference pageRef = Page.WarehouseScreenPage;
        Account acc = Testutility.createAccount();
        insert acc;
        contact con = Testutility.createContact(acc.Id);
        insert con;
        
        SAP_Order_Integration_Settings__c Setting = new SAP_Order_Integration_Settings__c();
        Setting = Testutility.createSAP_Order_Integration_Settings(true);
        InventoryCallout call = new InventoryCallout();
        Test.setMock(HttpCalloutMock.class, new InventoryCalloutMock()); 
        String strResp = call.callInventory('01K1A87063', 'ALL');
        
        
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
        
        Apttus_Proposal__Proposal__c testProposal = Testutility.createProposal(acc.Id);
        insert testProposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = Testutility.createProductConfig(acc.Id, testProposal.Id);
        insert prodConfig;        
        
        Apttus_Config2__LineItem__c lineItem = Testutility.createLineItem(prodConfig.Id, prod.Id);
        lineItem.Apttus_Config2__PriceListId__c = priceList.Id;
        lineItem.Apttus_Config2__PriceListItemId__c = pli.id;
        lineItem.APTS_Material_Num__c = '01K1A87063';
        
        insert lineItem;
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('mtrno', '');
        ApexPages.currentPage().getParameters().put('id', '');
        WarehouseScreenController testWhController = new WarehouseScreenController();
        testWhController.getLineItemDetails();
        
        
        testWhController.populateWareHouseOnLineItem();
        Test.stopTest();
    }
    
}