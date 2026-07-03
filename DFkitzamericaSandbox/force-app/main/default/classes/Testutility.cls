@isTest
public class Testutility {
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
    
    public static Apttus_Config2__PriceList__c createPriceList(){
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        priceList.Name = 'Standard USD PriceList';
        priceList.Apttus_Config2__Active__c = true;
        priceList.Apttus_Config2__EffectiveDate__c = System.now().addDays(-10);
        priceList.Apttus_Config2__ExpirationDate__c = System.now().addMonths(1);
        
        priceList.Apttus_Config2__Type__c = 'Standard';
        
        return priceList;
    }
    public static Apttus_Config2__PriceListItem__c createpricelistitem(Id prodId,Id pricelistid){
        Apttus_Config2__PriceListItem__c pricelistitem= new Apttus_Config2__PriceListItem__c();
        pricelistitem.APTS_Material_Num__c='testMatNO1';
        pricelistitem.Apttus_Config2__ProductId__c=prodId;
        priceListitem.Apttus_Config2__PriceListId__c=pricelistid;
        return pricelistitem;
    }
    public static Apttus_Proposal__Proposal__c createProposal(Id accId) {
        Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c();
        testProposal.Apttus_Proposal__Account__c = accId;
        return testProposal;
    }
    
    public static Apttus_Config2__ProductConfiguration__c createProductConfig(Id accId, Id proposalId) {
        Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c();
        prodConfig.Apttus_Config2__AccountId__c = accId;
        prodConfig.Apttus_Config2__ShipToAccountId__c = accId;
        prodConfig.Apttus_QPConfig__Proposald__c = proposalId;
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        return prodConfig;
    }
    
    public static Apttus_Config2__LineItem__c createLineItem(Id prodConfigId, Id prodId) {
        Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c();
        
        
        lineItem.Apttus_Config2__ConfigurationId__c = prodConfigId;
        lineItem.Apttus_Config2__ProductId__c = prodId;
        lineItem.Apttus_Config2__AddedBy__c = 'User';
        lineItem.Apttus_Config2__AdjustedPrice__c = 0;
        lineItem.Apttus_Config2__AllocateGroupAdjustment__c = true;
        lineItem.Apttus_Config2__AllowManualAdjustment__c = true;
        lineItem.Apttus_Config2__AllowProration__c = false;
        lineItem.Apttus_Config2__AllowRemoval__c = true;
        lineItem.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem.Apttus_Config2__AssetId__c = null;
        lineItem.Apttus_Config2__AssetLineItemId__c = null;
        lineItem.Apttus_Config2__AutoRenew__c = false;
        lineItem.Apttus_Config2__BaseExtendedCost__c = 0.00000;
        lineItem.Apttus_Config2__BaseExtendedPrice__c = 0;
        lineItem.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__BasePrice__c = 0;
        lineItem.Apttus_Config2__BaseProductId__c = null;
        lineItem.Apttus_Config2__BillingRule__c = 'Bill In Advance';
        lineItem.Apttus_Config2__ChargeGroupId__c = null;
        lineItem.Apttus_Config2__ChargeType__c = 'Usage Fee';
        
        lineItem.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem.Apttus_Config2__Customizable__c = true;
        lineItem.Apttus_Config2__DeltaPrice__c = 0.00000;
        lineItem.Apttus_Config2__DeltaQuantity__c = 1.00000;
        lineItem.Apttus_Config2__DerivedFromId__c = null;
        lineItem.Apttus_Config2__Description__c = 'dashDB - Enterprise';
        lineItem.Apttus_Config2__EndDate__c = Date.today();
        lineItem.Apttus_Config2__ExtendedCost__c = 0.00000;
        lineItem.Apttus_Config2__ExtendedPrice__c = 0.00000;
        lineItem.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem.Apttus_Config2__HasAttributes__c = true;
        lineItem.Apttus_Config2__HasBaseProduct__c = false;
        lineItem.Apttus_Config2__HasDefaults__c = false;
        lineItem.Apttus_Config2__HasIncentives__c = false;
        lineItem.Apttus_Config2__HasOptions__c = false;
        lineItem.Apttus_Config2__HasTieredPrice__c = false;
        lineItem.Apttus_Config2__HideCopyAction__c = false;
        lineItem.Apttus_Config2__HideInvoiceDisplay__c = false;
        lineItem.Apttus_Config2__IncentiveId__c = null;
        lineItem.Apttus_Config2__IsAssetPricing__c = false;
        lineItem.Apttus_Config2__IsCustomPricing__c = false;
        lineItem.Apttus_Config2__IsHidden__c = false;
        lineItem.Apttus_Config2__IsOptionRollupLine__c = false;
        lineItem.Apttus_Config2__IsPrimaryLine__c = true;
        lineItem.Apttus_Config2__IsPrimaryRampLine__c = false;
        lineItem.Apttus_Config2__IsQuantityModifiable__c = true;
        lineItem.Apttus_Config2__IsReadOnly__c = false;
        lineItem.Apttus_Config2__IsSellingTermReadOnly__c = false;
        lineItem.Apttus_Config2__IsUsageTierModifiable__c = false;
        lineItem.Apttus_Config2__ItemSequence__c = 1;
        lineItem.Apttus_Config2__LineNumber__c = 1;
        lineItem.Apttus_Config2__LineSequence__c = 1;
        lineItem.Apttus_Config2__LineStatus__c = 'New';
        lineItem.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem.Apttus_Config2__ListPrice__c = 0.00000;
        lineItem.Apttus_Config2__NetAdjustmentPercent__c = 0.0000;
        lineItem.Apttus_Config2__NetPrice__c = 0.00000;
        lineItem.Apttus_Config2__NetUnitPrice__c = 0.00000;
        lineItem.Apttus_Config2__OptionId__c = null;
        lineItem.Apttus_Config2__OptionSequence__c = 0;
        lineItem.Apttus_Config2__PaymentTermId__c = null;
        lineItem.Apttus_Config2__PriceIncludedInBundle__c = false;
        lineItem.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem.Apttus_Config2__PriceUom__c = 'Each';
        lineItem.Apttus_Config2__PricingDate__c = DateTime.now();
        lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
        lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem.Apttus_Config2__ProductOptionId__c = null;
        lineItem.Apttus_Config2__ProductVersion__c = 1.00;
        lineItem.Apttus_Config2__Quantity__c = 1.00000;
        lineItem.Apttus_Config2__RelatedItemId__c = null;
        lineItem.Apttus_Config2__RollupPriceToBundle__c = true;
        lineItem.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__SellingTerm__c = 12.00000;
        lineItem.Apttus_Config2__ServiceLocationId__c = null;
        lineItem.Apttus_Config2__StartDate__c = Date.today();
        lineItem.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem.Apttus_Config2__TaxCodeId__c = null;
        lineItem.Apttus_Config2__TaxInclusive__c = false;
        lineItem.Apttus_Config2__Taxable__c = true;
        lineItem.Apttus_Config2__Term__c = 1;
        lineItem.Apttus_Config2__TotalQuantity__c = 1.00000;
        lineItem.Apttus_Config2__Uom__c = 'Each';
        
        return lineItem;
    }
    
    public static APTS_ContractualPriceMultiplier__c createContractualPriceMultiplier(){
        
        APTS_ContractualPriceMultiplier__c priceMultiplier = new APTS_ContractualPriceMultiplier__c();
        priceMultiplier.APTS_Contract_Price__c = 90;
        priceMultiplier.APTS_Multiplier__c = 0.40;
        priceMultiplier.APTS_Mat_Grp_1_CIT__c = 'C';
        priceMultiplier.APTS_Mat_Grp_2_Catlg__c = 'LF';
        priceMultiplier.APTS_Mat_Grp_3_Catgr_CD__c = '21';
        priceMultiplier.APTS_Material_Number__c = '01A1A84040';
        priceMultiplier.APTS_Valid_From_Date__c = System.today().addDays(-10);
        priceMultiplier.APTS_Valid_Until_Date__c = System.today().addDays(10);
        
        return priceMultiplier;
    }
    
    public static APTS_Vendor__c createVendor(){
        
        APTS_Vendor__c vendor1 = new APTS_Vendor__c();
        vendor1.APTS_Vendor_Name__c = 'Test 1';
        vendor1.APTS_Vendor_Acct_Group_ID__c= 'Z301';
        vendor1.APTS_Invalid__c = false;
        
        return vendor1;
    }
    
    public static SAP_Order_Integration_Settings__c createSAP_Order_Integration_Settings(Boolean insertNow){
        
        SAP_Order_Integration_Settings__c Setting = new SAP_Order_Integration_Settings__c();
        Setting.Name = 'System Properties';
        Setting.Inventory_Endpoint_Url__c = 'https://service.us.apiconnect.ibmcloud.com/gws/apigateway/api/df6143e5ec0c3a27a13a40b97e2a13aec467200abf77b321dde444d2b74df570/2StcJF/GET_INVENTORY/retreiveInventoryInformation?';
        Setting.X_IBM_Client_Id__c = '7e4f6af0-9aed-46f3-8943-1d5296c4517c';
        Setting.Order_Endpoint_Url__c = 'https://service.us.apiconnect.ibmcloud.com/gws/apigateway/api/df6143e5ec0c3a27a13a40b97e2a13aec467200abf77b321dde444d2b74df570/DClHup/OrderRequest/';
        Setting.Order_X_IBM_Client_Id__c = '5b47e84f-fc41-455d-990f-e777b2abdda4';
        
        if(insertNow){
            insert Setting;
        }
        
        return Setting;
    }
    
}