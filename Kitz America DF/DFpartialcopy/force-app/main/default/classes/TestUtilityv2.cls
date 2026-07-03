@isTest
public with sharing class TestUtilityv2 {
    
    public static Account createAccount(){
        Account acc = new Account();
        acc.Name = 'TestUtilityAccount';
        acc.BillingCity = 'TestCity';
        acc.BillingCountry = 'US';
        acc.BillingPostalCode = '1001001';
        acc.BillingState = 'Test State';
        acc.BillingStreet = 'test street';
        return acc;
    }
    public static Contact createContact(Id accId){
        Contact con = new Contact();
        con.FirstName = 'TestUtilityF';
        con.LastName = 'TestUtilityL';
        con.AccountId = accId;
        return con;
    }
    public static Product2 createProduct() {
        Product2 prod = new Product2();
        prod.Name = 'Test product';
        prod.ProductCode = 'Test ProCode';
        prod.APTS_Material_Num__c = 'testMatNO1';
        prod.APTS_Mat_Grp_1_CIT__c = 'CC';
        prod.APTS_Mat_Grp_2_Catlg__c = 'LF' ;
        prod.APTS_Mat_Grp_3_Catgr_CD__c = 'C' ;
        prod.APTS_Spec_Pkg_Code__c = 'Test pckg';
        prod.APTS_Size_inch__c = '20';
        prod.APTS_KCA_Fig_Num__c = '123';
        prod.APTS_Main_Plant__c = 'test';
        prod.APTS_Weight_gm__c = 12.8;
        prod.IsActive = true;
        return prod;
    }

    public static APTS_Vendor__c createVendor(){
        
        APTS_Vendor__c vendor1 = new APTS_Vendor__c();
        vendor1.APTS_Vendor_Name__c = 'Test 1';
        vendor1.APTS_Vendor_Acct_Group_ID__c= 'Z301';
        vendor1.APTS_Invalid__c = false;
        
        return vendor1;
    }
    

    public static SAP_Order_Integration_Settings__c createSAP_Order_Integration_Settings_Mulesoft(Boolean insertNow){
        
        SAP_Order_Integration_Settings__c Setting = new SAP_Order_Integration_Settings__c();
        //Setting.Name = 'System Properties';
        //Setting.Inventory_Endpoint_Url__c = 'https://service.us.apiconnect.ibmcloud.com/gws/apigateway/api/df6143e5ec0c3a27a13a40b97e2a13aec467200abf77b321dde444d2b74df570/2StcJF/GET_INVENTORY/retreiveInventoryInformation?';
        Setting.X_IBM_Client_Id__c = '7e4f6af0-9aed-46f3-8943-1d5296c4517c';
        //Setting.Order_Endpoint_Url__c = 'https://service.us.apiconnect.ibmcloud.com/gws/apigateway/api/df6143e5ec0c3a27a13a40b97e2a13aec467200abf77b321dde444d2b74df570/DClHup/OrderRequest/';
        Setting.Order_X_IBM_Client_Id__c = '5b47e84f-fc41-455d-990f-e777b2abdda4'; 
        Setting.Name = 'Mulesoft Integration';
        Setting.Mulesoft_Client_Id__c = '38297349875';
        Setting.Mulesoft_Client_Secret__c = '38297349875';
        Setting.Inventory_Endpoint_Url__c = 'http://150.239.171.84:8081/v1/retreiveInventoryInformation?';
        Setting.Order_Endpoint_Url__c = 'http://150.239.171.84:8082/v1/send-sforder-to-sap';
        if(insertNow){
            insert Setting;
        }
        
        return Setting;
    }
}