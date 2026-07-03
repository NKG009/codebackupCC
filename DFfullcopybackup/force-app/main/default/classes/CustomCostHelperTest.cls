@isTest
public class CustomCostHelperTest {
  
    @isTest
    public static void testMethod1(){
        Account acc = Testutility.createAccount();
        insert acc;
        
        Account acc2 = Testutility.createAccount();
        acc2.Name = 'test 2';
        acc2.ParentId = acc.Id;
        insert acc2;
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        pricelist.Name =  'Standard USD PriceList';
        insert priceList;
        
        Product2 prod = Testutility.createProduct();
        prod.APTS_Material_Num__c = '01A1A84040a';
        
        insert prod;
        
        Apttus_Proposal__Proposal__c testProposal = Testutility.createProposal(acc.Id);
        insert testProposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = Testutility.createProductConfig(acc.Id, testProposal.Id);
        insert prodConfig;        
        List<Apttus_Config2__LineItem__c> lineItemList = new List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c lineItem = Testutility.createLineItem(prodConfig.Id, prod.Id);
        lineItem.Apttus_Config2__PriceListId__c = priceList.Id;
        lineItem.Apttus_Config2__ShipToAccountId__c = acc2.Id;
        lineItem.APTS_Material_Num__c = '01A1A84040';
        insert lineItem;
        
        Apttus_Config2__LineItem__c lineItem2 = Testutility.createLineItem(prodConfig.Id, prod.Id);
        lineItem2.Apttus_Config2__PriceListId__c = priceList.Id;
        lineItem2.Apttus_Config2__ShipToAccountId__c = acc2.Id;
        lineItem2.APTS_Material_Num__c = 'RR282';
        insert lineItem2;
        
        lineItemList.add(lineItem);
        lineItemList.add(lineItem2);
        
        APTS_AllCost__c allCost = new APTS_AllCost__c();
        allCost.APTS_Material_Number__c = lineItem.APTS_Material_Num__c;
        allCost.APTS_Valid_From_Date__c = System.today() - 7;
        allCost.APTS_Valid_Until_Date__c = System.today() + 7;
        allCost.APTS_PriceList__c = lineItem.Apttus_Config2__PriceListId__c;
        allCost.APTS_Invalid__c = False;
        allCost.APTS_Product_Name__c  = prod.Id;
        allCost.APTS_Cost__c = 100;
        insert allCost;
        
        APTS_AllCost__c allCost2 = new APTS_AllCost__c();
        allCost2.APTS_Material_Number__c = lineItem2.APTS_Material_Num__c;
        allCost2.APTS_Valid_From_Date__c = System.today() - 7;
        allCost2.APTS_Valid_Until_Date__c = System.today() + 7;
        allCost2.APTS_Sold_To_Account__c = acc2.id;
        allCost2.APTS_PriceList__c = lineItem2.Apttus_Config2__PriceListId__c;
        allCost2.APTS_Invalid__c = False;
        allCost2.APTS_Product_Name__c  = prod.Id;
        allCost2.APTS_Cost__c = 100;
        insert allCost2;
        
        list<APTS_AllCost__c> allCostlst = new list<APTS_AllCost__c>();
        allCostlst.add(allCost);
        allCostlst.add(allCost2);
        CustomCostHelper helperTest = new CustomCostHelper();
        
        helperTest.beginToPopulateCostOnLineItems(lineItemList,allCostlst);
        helperTest.populateCostOnLineItems(lineItemList);
    }
}