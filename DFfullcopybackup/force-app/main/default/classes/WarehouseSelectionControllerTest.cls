@isTest
public class WarehouseSelectionControllerTest {
    @isTest
    static void warehouseSelectionTest(){
        PageReference pageRef = Page.WarehouseSelectionPage;
        Account acc = Testutility.createAccount();
        insert acc;
        contact con = Testutility.createContact(acc.Id);
        insert con;
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        pricelist.Name =  'Standard USD PriceList';
        pricelist.Apttus_Config2__Active__c = true;
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
        
        insert lineItem;
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id', String.valueOf(prodConfig.Id));
        WarehouseSelectionController testWhController = new WarehouseSelectionController();
        testWhController.configLineItemList = testWhController.getConfigLineItemData();
        testWhController.handleError();
        testWhController.cancel();
        
        testWhController.getConfigLineItemData();
        testWhController.saveLineItems();
        testWhController.saveAndBackToCart();
        Test.stopTest();
    }
    
    @isTest
    static void warehouseSelectionTest2(){
        PageReference pageRef = Page.WarehouseSelectionPage;
        
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id', String.valueOf(''));
        WarehouseSelectionController testWhController = new WarehouseSelectionController();
        testWhController.configLineItemList = testWhController.getConfigLineItemData();
        testWhController.handleError();
        testWhController.cancel();
        
        //Test Case to cover else part 
        
        testWhController.getConfigLineItemData();
        testWhController.saveLineItems();
        testWhController.saveAndBackToCart();
        Test.stopTest();
    }
}