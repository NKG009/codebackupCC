/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is Apex Class used to check the code coverage of APTS_CustomPricingCallback
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Ravi Rajeev   <ravi.rajeev@mainspringcg.com>
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
@isTest
public class APTS_CustomPricingCallbackTest {
    private static Apttus_Config2__ConfigLineItemCustomFields__c customsettingpcb;
    private static Apttus_Config2__ConfigCustomClasses__c configCustomClassesProperty;
    private static void setup(){
        customsettingpcb = new Apttus_Config2__ConfigLineItemCustomFields__c ();
        customsettingpcb.Name = 'System Properties';
        string CustomFieldNames2;
        CustomFieldNames2 = 'APTS_Margin__c,';
        CustomFieldNames2+='APTS_Gross_Profit__c,';
        CustomFieldNames2+='APTS_Vendor_Cost__c,';
        CustomFieldNames2+='APTS_Extended_Gross_Profit__c,';
        CustomFieldNames2+='Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,';
        CustomFieldNames2+='Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Sales_Order_Type__c';        
        customsettingpcb.Apttus_Config2__CustomFieldNames2__c = CustomFieldNames2;
        
        string CustomFieldNames;
        CustomFieldNames = 'APTS_Material_Num__c,';
        CustomFieldNames+= 'APTS_Mat_Grp_3_Catgr_CD__c,';
        CustomFieldNames+= 'APTS_Mat_Grp_1_CIT__c,';
        CustomFieldNames+= 'APTS_Mat_Grp_2_Catlg__c,';
        CustomFieldNames+= 'APTS_Multiplier__c,';
        CustomFieldNames+= 'APTS_Override_Multiplier__c,';
        CustomFieldNames+= 'APTS_Weight_gm__c,';
        CustomFieldNames+= 'APTS_Total_Weight_gm__c';
        
        customsettingpcb.Apttus_Config2__CustomFieldNames3__c = 'Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c';
        customsettingpcb.Apttus_Config2__CustomFieldNames4__c = 'APTS_Item_Category__c';
        customsettingpcb.apttus_config2__customfieldnames__c = CustomFieldNames;        
        insert customsettingpcb;
        
        // Creating Custom Setting Entry
        configCustomClassesProperty = new Apttus_Config2__ConfigCustomClasses__c();
        configCustomClassesProperty.Name = 'Config Custom Classes';
        configCustomClassesProperty.Apttus_Config2__PricingCallbackClass__c = 'APTS_CustomPricingCallback';
        insert configCustomClassesProperty;
    }
    
    private static testMethod void TestCustomPricingCallback(){
        setup();
        Account acc = Testutility.createAccount();
        insert acc; 
        
        Apttus_Config2__ClassificationName__c cat = new Apttus_Config2__ClassificationName__c();
        cat.Name = 'test cat';
        cat.Apttus_Config2__HierarchyLabel__c = 'test cat';
        insert cat;
        
        Apttus_Config2__ClassificationHierarchy__c classH = new Apttus_Config2__ClassificationHierarchy__c();
        classH.Apttus_Config2__HierarchyId__c = cat.Id;
        classH.Apttus_Config2__Label__c =  'test cat';
        insert classH;
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        pricelist.Name =  'Standard USD PriceList';
        pricelist.Apttus_Config2__Active__c = true;
        insert priceList;               
        
        Product2 prod = Testutility.createProduct();
        insert prod;
        
        Apttus_Config2__PriceListItem__c pli =  new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c = priceList.id;
        pli.Apttus_Config2__ProductId__c = prod.id;
        
        pli.Apttus_Config2__ChargeType__c = 'test';
        pli.Apttus_Config2__PriceType__c = 'Usage';
        pli.Apttus_Config2__Frequency__c = 'Monthly';
        pli.Apttus_Config2__PriceMethod__c = 'Per Unit';
        pli.Apttus_Config2__ListPrice__c = 200;
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
        testProposal.Apttus_Proposal__Approval_Stage__c = 'Draft';
        testProposal.APTS_Sales_Order_Type__c = 'Project Order';
        testProposal.Apttus_QPConfig__ConfigurationFinalizedDate__c = system.today();
        insert testProposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = Testutility.createProductConfig(acc.Id, testProposal.Id);
        prodConfig.Name = 'test config';
        insert prodConfig;        
        
        
        Apttus_Config2__LineItem__c lineItem = Testutility.createLineItem(prodConfig.Id, prod.Id);
        lineItem.Apttus_Config2__PriceListItemId__c = pli.id;
        lineItem.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem.APTS_Item_Category__c = 'Indent Order(Product)';
        lineItem.Apttus_Config2__ListPrice__c = 282;
        lineItem.Apttus_Config2__NetPrice__c = 282;
        lineItem.APTS_Override_Multiplier__c = 2;
        lineItem.Apttus_Config2__LineNumber__c = 1;
        lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem.Apttus_Config2__IsPrimaryLine__c = true;
        insert lineItem;
        
         APTS_AllCost__c allCost = new APTS_AllCost__c();
        allCost.APTS_Material_Number__c = lineItem.APTS_Material_Num__c;
        allCost.APTS_Valid_From_Date__c = System.today() - 7;
        allCost.APTS_Valid_Until_Date__c = System.today() + 7;
        allCost.APTS_PriceList__c = lineItem.Apttus_Config2__PriceListId__c;
        allCost.APTS_Invalid__c = False;
        allCost.APTS_Product_Name__c  = prod.Id;
        allCost.APTS_Cost__c = 100;
        insert allCost;
        
        Apttus_Config2__LineItem__c lineItem2 = Testutility.createLineItem(prodConfig.Id, prod.Id);
        lineItem2.Apttus_Config2__PriceListItemId__c = pli.id;
        lineItem2.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem2.APTS_Item_Category__c = 'KB Order(Direct)';
        lineItem2.Apttus_Config2__ListPrice__c = 282;
        lineItem2.Apttus_Config2__NetPrice__c = 282;
        lineItem2.APTS_Override_Multiplier__c = 0;
        lineItem2.Apttus_Config2__LineNumber__c = 1;
        lineItem2.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem2.Apttus_Config2__IsPrimaryLine__c = true;
        insert lineItem2;
        
        Apttus_Config2__LineItem__c lineItem3 = Testutility.createLineItem(prodConfig.Id, prod.Id);
        lineItem3.Apttus_Config2__PriceListItemId__c = pli.id;
        lineItem3.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem3.APTS_Item_Category__c = 'Indent Order(Parts)';
        lineItem3.Apttus_Config2__BaseCostOverride__c = 222;
        lineItem3.Apttus_Config2__NetPrice__c = 282;
        lineItem3.Apttus_Config2__LineNumber__c = 1;
        lineItem3.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem3.Apttus_Config2__IsPrimaryLine__c = true;
        insert lineItem3;
        
        Apttus_Config2__LineItem__c lineItem4 = Testutility.createLineItem(prodConfig.Id, prod.Id);
        lineItem4.Apttus_Config2__PriceListItemId__c = pli.id;
        lineItem4.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem4.APTS_Item_Category__c = 'Indent Order(Parts)';
        lineItem4.APTS_Vendor_Cost__c = 222;
        lineItem4.Apttus_Config2__NetPrice__c = 282;
        lineItem4.Apttus_Config2__LineNumber__c = 1;
        lineItem4.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem4.Apttus_Config2__IsPrimaryLine__c = true;
        insert lineItem4;
        
        Apttus_Config2__LineItem__c lineItem5 = Testutility.createLineItem(prodConfig.Id, prod.Id);
        lineItem5.Apttus_Config2__PriceListItemId__c = pli.id;
        lineItem5.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem5.APTS_Item_Category__c = 'Indent Order(Parts)';
        lineItem5.APTS_Vendor_Cost__c = 222;
        lineItem5.Apttus_Config2__NetPrice__c = 282;
        lineItem5.Apttus_Config2__LineNumber__c = 1;
        lineItem5.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem5.Apttus_Config2__Quantity__c = 0;
        lineItem5.Apttus_Config2__IsPrimaryLine__c = true;
        insert lineItem5;
        
        Apttus_Config2__LineItem__c lineItem6 = Testutility.createLineItem(prodConfig.Id, prod.Id);
        lineItem6.Apttus_Config2__PriceListItemId__c = pli.id;
        lineItem6.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem6.APTS_Item_Category__c = 'Indent Order(Parts)';
        lineItem6.APTS_Vendor_Cost__c = 222;
        lineItem6.Apttus_Config2__NetPrice__c = 282;
        lineItem6.Apttus_Config2__LineNumber__c = 1;
        lineItem6.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem6.Apttus_Config2__Quantity__c = 0;
        lineItem6.Apttus_Config2__IsPrimaryLine__c = true;
        insert lineItem6;
        
        
        Test.startTest();        
        
        Boolean result1 = Apttus_Config2.PricingWebService.computeBasePriceForItemColl(prodConfig.Id, 1);
        Boolean result = Apttus_Config2.PricingWebService.computeNetPriceForItemColl(prodConfig.Id, 1);
        
        Test.stopTest();
    }
    
    private static testMethod void TestCustomPricingCallback2(){
        setup();
        Account acc = Testutility.createAccount();
        insert acc; 
        
        Account shiptoacc = new Account();
        shiptoacc.Name = 'TestUtilityAccount';
        shiptoacc.shippingCity = 'TestCity';
        shiptoacc.shippingCountry = 'US';
        shiptoacc.shippingPostalCode = '1001001';
        shiptoacc.shippingState = 'Test State';
        shiptoacc.shippingStreet = 'test street';
        insert shiptoacc;       
        
        Apttus_Config2__ClassificationName__c cat = new Apttus_Config2__ClassificationName__c();
        cat.Name = 'test cat';
        cat.Apttus_Config2__HierarchyLabel__c = 'test cat';
        insert cat;
        
        Apttus_Config2__ClassificationHierarchy__c classH = new Apttus_Config2__ClassificationHierarchy__c();
        classH.Apttus_Config2__HierarchyId__c = cat.Id;
        classH.Apttus_Config2__Label__c =  'test cat';
        insert classH;
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        pricelist.Name =  'Standard USD PriceList';
        pricelist.Apttus_Config2__Active__c = true;
        insert priceList;               
        
        Product2 prod = Testutility.createProduct();
        insert prod;
        
        Apttus_Config2__PriceListItem__c pli =  new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c = priceList.id;
        pli.Apttus_Config2__ProductId__c = prod.id;
        
        pli.Apttus_Config2__ChargeType__c = 'test';
        pli.Apttus_Config2__PriceType__c = 'Usage';
        pli.Apttus_Config2__Frequency__c = 'Monthly';
        pli.Apttus_Config2__PriceMethod__c = 'Per Unit';
        pli.Apttus_Config2__ListPrice__c = 200;
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
        
        Apttus_Proposal__Proposal__c testProposal = Testutility.createProposal(null);
        testProposal.Apttus_Proposal__Approval_Stage__c = 'Draft';
        testProposal.APTS_Sales_Order_Type__c = 'Standard Order';
        testProposal.Apttus_QPConfig__ConfigurationFinalizedDate__c = system.today();
        insert testProposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = Testutility.createProductConfig(acc.Id, testProposal.Id);
        prodConfig.Name = 'test config';
        insert prodConfig;
        
        Apttus_Config2__LineItem__c lineItem2 = Testutility.createLineItem(prodConfig.Id, prod.Id);
        lineItem2.Apttus_Config2__PriceListItemId__c = pli.id;
        lineItem2.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem2.APTS_Item_Category__c = 'KB Order(Direct)';
        lineItem2.Apttus_Config2__ListPrice__c = 282;
        lineItem2.Apttus_Config2__NetPrice__c = 282;
        lineItem2.APTS_Override_Multiplier__c = 0;
        lineItem2.Apttus_Config2__LineNumber__c = 1;
        lineItem2.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem2.Apttus_Config2__IsPrimaryLine__c = true;
        
        insert lineItem2;
        
        Test.startTest();        
        
        Boolean result1 = Apttus_Config2.PricingWebService.computeBasePriceForItemColl(prodConfig.Id, 1);
        Boolean result = Apttus_Config2.PricingWebService.computeNetPriceForItemColl(prodConfig.Id, 1);
        
        Test.stopTest();
    }
}