@isTest
public class LineItemTriggerTest {
    @isTest 
    static void testBeforeInsertLineItemTrigger(){
        Account acc = Testutility.createAccount();
        insert acc;
        contact con = Testutility.createContact(acc.Id);
        insert con;
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        pricelist.Name =  'Standard USD PriceList';
        insert priceList;
        
        Product2 prod = Testutility.createProduct();
        insert prod;
        
        Apttus_Proposal__Proposal__c testProposal = Testutility.createProposal(acc.Id);
        testProposal.APTS_Sales_Order_Type__c = 'Standard Order';
        insert testProposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = Testutility.createProductConfig(acc.Id, testProposal.Id);
		insert prodConfig;        
        
        Apttus_Config2__LineItem__c lineItem = Testutility.createLineItem(prodConfig.Id, prod.Id);
        insert lineItem;
        
        lineItem.APTS_Item_Category__c = 'Individual Spec';
        update lineItem;
        
        lineItem.APTS_Item_Category__c = 'Indent Order(Product)';
        update lineItem;
        
        lineItem.APTS_Item_Category__c = 'Indent Order(Parts)';
        update lineItem;
        
        lineItem.APTS_Item_Category__c = 'Stock Order';
        update lineItem;
       
    }
    
    @isTest 
    static void testBeforeInsertLineItemTrigger2(){
        Account acc = Testutility.createAccount();
        insert acc;
        contact con = Testutility.createContact(acc.Id);
        insert con;
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        pricelist.Name =  'Standard USD PriceList';
        insert priceList;
        
        Product2 prod = Testutility.createProduct();
        insert prod;
        
        Apttus_Proposal__Proposal__c testProposal = Testutility.createProposal(acc.Id);
        testProposal.APTS_Sales_Order_Type__c = 'Project Order';
        insert testProposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = Testutility.createProductConfig(acc.Id, testProposal.Id);
		insert prodConfig;        
        
        Apttus_Config2__LineItem__c lineItem = Testutility.createLineItem(prodConfig.Id, prod.Id);
        
        insert lineItem;
        
        lineItem.APTS_Item_Category__c = 'Individual Spec';
        update lineItem;
    }
    
}