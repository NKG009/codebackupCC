/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is Apex Class used to check the code coverage of APTS_CustomValidationCallback
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Ravi Rajeev   <ravi.rajeev@mainspringcg.com>
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
@isTest
public class APTS_CustomValidationCallbackTest {
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
        CustomFieldNames+= 'APTS_Total_Weight_gm__c,';
        CustomFieldNames+= 'APTS_Mass_Update__c';
        
        
        customsettingpcb.Apttus_Config2__CustomFieldNames3__c = 'Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c';
        customsettingpcb.Apttus_Config2__CustomFieldNames4__c = 'APTS_Item_Category__c';
        customsettingpcb.apttus_config2__customfieldnames__c = CustomFieldNames;        
        insert customsettingpcb;
        
        // Creating Custom Setting Entry
        configCustomClassesProperty = new Apttus_Config2__ConfigCustomClasses__c();
        configCustomClassesProperty.Name = 'Config Custom Classes';
        configCustomClassesProperty.Apttus_Config2__ValidationCallbackClass__c= 'APTS_CustomValidationCallback';
        
        insert configCustomClassesProperty;
    }
    
    private static testMethod void TestMethod1(){
        setup();
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
        lineItem.APTS_Mass_Update__c = 'No';
        insert lineItem;
        
        Apttus_Config2__LineItem__c lineItem2 = Testutility.createLineItem(prodConfig.Id, prod.Id);
        lineItem2.APTS_Item_Category__c = 'KB Order(Direct)';        
        lineItem2.APTS_Warehouse_Name__c = 'RR282';
        lineItem2.Apttus_Config2__BaseCostOverride__c = 22;
        lineItem2.Apttus_Config2__PriceListItemId__c = pli.id;
        lineItem2.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem2.APTS_Mass_Update__c = 'No';
        insert lineItem2;
        
        Apttus_Config2__LineItem__c lineItem3 = Testutility.createLineItem(prodConfig.Id, prod.Id);
        lineItem3.APTS_Item_Category__c = 'Indent Order(Parts)';
        lineItem3.Apttus_Config2__LineSequence__c = 2;
        lineItem3.Apttus_Config2__PriceListItemId__c = pli.id;
        lineItem3.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem3.APTS_Mass_Update__c = 'No';
        insert lineItem3;
        
        Apttus_Config2__LineItem__c lineItem4 = Testutility.createLineItem(prodConfig.Id, prod.Id);
        lineItem4.APTS_Item_Category__c = 'Test';
        lineItem4.APTS_Vendor_ID__c = Vendor.id;
        lineItem4.Apttus_Config2__PriceListItemId__c = pli.id;
        lineItem4.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem4.APTS_Mass_Update__c = 'No';
        insert lineItem4;
        
        Apttus_Config2__LineItem__c lineItem5 = Testutility.createLineItem(prodConfig.Id, prod.Id);
        lineItem5.APTS_Item_Category__c = 'Indent Order(Product)';
        lineItem5.Apttus_Config2__PriceListItemId__c = pli.id;
        lineItem5.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem5.APTS_Mass_Update__c = 'No';
        insert lineItem5;
        
        Apttus_Config2__LineItem__c lineItem6 = Testutility.createLineItem(prodConfig.Id, prod2.Id);
        lineItem6.APTS_Item_Category__c = 'Indent Order(Product)';
        lineItem6.Apttus_Config2__PriceListItemId__c = pli2.id;
        lineItem6.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem6.APTS_Mass_Update__c = 'No';
        insert lineItem6;
        
        Apttus_Config2__LineItem__c lineItem7 = Testutility.createLineItem(prodConfig.Id, prod.Id);
        lineItem7.Apttus_Config2__PriceListItemId__c = pli.id;
        lineItem7.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem7.APTS_Item_Category__c = 'Individual Spec';
        lineItem7.APTS_Mass_Update__c = 'No';
        insert lineItem7;
        
        Apttus_Config2__LineItem__c lineItem8 = Testutility.createLineItem(prodConfig.Id, prod2.Id);
        lineItem8.Apttus_Config2__PriceListItemId__c = pli.id;
        lineItem8.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem8.APTS_Item_Category__c = 'Individual Spec';
        lineItem8.Apttus_Config2__BaseCostOverride__c = 22;     
        lineItem8.APTS_Mass_Update__c = 'No';   
        insert lineItem8;
        
        Apttus_Config2__LineItem__c lineItem9 = Testutility.createLineItem(prodConfig.Id, prod2.Id);
        lineItem9.APTS_Item_Category__c = 'Individual Spec';
        lineItem9.APTS_Spec_Desc__c = 'Test RR'; 
        lineItem9.Apttus_Config2__PriceListItemId__c = pli2.id;
        lineItem9.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem9.APTS_Mass_Update__c = 'No';
        insert lineItem9;
        
        Apttus_Config2__LineItem__c lineItem10 = Testutility.createLineItem(prodConfig.Id, prod2.Id);
        lineItem10.APTS_Item_Category__c = 'Individual Spec';
        lineItem10.Apttus_Config2__PriceListItemId__c = pli2.id;
        lineItem10.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem10.APTS_Mass_Update__c = 'No';
        insert lineItem10;
        
        Apttus_Config2__LineItem__c lineItem11 = Testutility.createLineItem(prodConfig.Id, prod2.Id);
        lineItem11.APTS_Item_Category__c = 'Project w/ Spec';
        lineItem11.Apttus_Config2__PriceListItemId__c = pli2.id;
        lineItem11.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem11.APTS_Mass_Update__c = 'No';
        insert lineItem11;
        
        Apttus_Config2__LineItem__c lineItem12 = Testutility.createLineItem(prodConfig.Id, prod2.Id);
        lineItem12.APTS_Warehouse_Number__c = '3008';
        lineItem12.Apttus_Config2__PriceListItemId__c = pli2.id;
        lineItem12.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem12.APTS_Mass_Update__c = 'No';
        insert lineItem12;
        
        Apttus_Config2__LineItem__c lineItem13= Testutility.createLineItem(prodConfig.Id, prod2.Id);
        lineItem13.APTS_Warehouse_Number__c = '30W';
        lineItem13.Apttus_Config2__PriceListItemId__c = pli2.id;
        lineItem13.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem13.APTS_Mass_Update__c = 'No';
        insert lineItem13;
        
        Apttus_Config2__LineItem__c lineItem14 = Testutility.createLineItem(prodConfig.Id, prod2.Id);
        lineItem14.APTS_Item_Category__c = 'Consigned Stock Order';
        lineItem14.APTS_Spec_Desc__c = 'Test RR';
        lineItem14.Apttus_Config2__PriceListItemId__c = pli.id;
        lineItem14.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem14.APTS_Mass_Update__c = 'No';
        insert lineItem14;
               
        //callbackTest.validateVendorOnLineItem(lineItemList, validationResult);
        //Blank ramplines and assetItems
        List<Apttus_Config2__LineItem__c> rampLines = new List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__TempRenew__c> assetItems = new List<Apttus_Config2__TempRenew__c>(); 
        
        Test.startTest();
        //Calling Validation callback
        Apttus_Config2.CallbackTester.testValidationCallback(prodConfig.Id, rampLines, assetItems, new APTS_CustomValidationCallback());
        Test.stopTest();
        
    }  
    
}