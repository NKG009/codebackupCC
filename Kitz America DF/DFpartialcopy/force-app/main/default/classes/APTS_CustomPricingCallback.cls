/*******************************************
* Name : APTS_CustomPricingCallback
* Description : Class to implement custom pricing.
*******************************************/

global class APTS_CustomPricingCallback implements Apttus_Config2.CustomClass.IPricingCallback3 {
    
    Apttus_Config2.CustomClass.PricingMode pricingMode;
    
    private Set<Id> productIdSet = new Set<Id>();
    private Set<Id> soldToIdSet = new Set<Id>();
    private Set<Id> shipToIdSet = new Set<Id>();
    private Set<Id> pricelistIdSet = new Set<Id>();
    private Set<String> materialNumberSet = new Set<String>();
    private Set<String> materialGroup1Set = new Set<String>();
    private Set<String> materialGroup2Set = new Set<String>();
    private Set<String> materialGroup3Set = new Set<String>();
    private list<APTS_ContractualPriceMultiplier__c> ContractualPriceMultiplierlst = new list<APTS_ContractualPriceMultiplier__c>();
    private list<Apttus_Config2__LineItem__c> lineItemList = new list<Apttus_Config2__LineItem__c> ();
    
    private Set<Id> productIdSetc = new Set<Id>();
    private Set<Id> soldToIdSetc = new Set<Id>();
    private Set<String> materialNumberSetc = new Set<String>();
    private list<APTS_AllCost__c> AllCostlst = new list<APTS_AllCost__c>();
    private map<id,product2> productmap;
    global void start(Apttus_Config2.ProductConfiguration config) {
        Apttus_Config2__ProductConfiguration__c configuration = config.getConfigSO();
        List<Apttus_Config2__LineItem__c> lineItemList = new List<Apttus_Config2__LineItem__c> ();
        
        lineItemList = [select id,Apttus_Config2__ConfigurationId__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,
                        Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c,
                        Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c,
                        APTS_Material_Num__c, APTS_Mat_Grp_2_Catlg__c, APTS_Mat_Grp_3_Catgr_CD__c, APTS_Mat_Grp_1_CIT__c,
                        Apttus_Config2__ProductId__c, Apttus_Config2__PriceListId__c from Apttus_Config2__LineItem__c
                        where Apttus_Config2__ConfigurationId__c = :configuration.id];
        
        getProductAndContractualMultiplierFilterSets(lineItemList);
        
        ContractualPriceMultiplierlst = [Select Id, APTS_Ship_To_Account__c, APTS_Sold_To_Account__c, APTS_Valid_From_Date__c,
                                         APTS_Valid_Until_Date__c, APTS_Contract_Price__c, APTS_Invalid__c, APTS_Material_Number__c,
                                         APTS_Multiplier__c, APTS_PriceList__c, APTS_Mat_Grp_1_CIT__c, APTS_Mat_Grp_2_Catlg__c,
                                         APTS_Mat_Grp_3_Catgr_CD__c, APTS_Product_Name__c  
                                         From APTS_ContractualPriceMultiplier__c 
                                         Where APTS_Invalid__c = false AND
                                         APTS_NetVsMultiplier_Sequence__c <> 0 AND APTS_PriceList__c IN :pricelistIdSet
                                         AND APTS_Sold_To_Account__c IN :soldToIdSet AND 
                                         (APTS_Ship_To_Account__c IN :shipToIdSet OR APTS_Ship_To_Account__c = null) AND
                                         ((APTS_Material_Number__c IN :materialNumberSet AND  APTS_Product_Name__c IN :productIdSet) OR 
                                          (APTS_Mat_Grp_1_CIT__c IN :materialGroup1Set OR APTS_Mat_Grp_2_Catlg__c IN :materialGroup2Set OR 
                                           APTS_Mat_Grp_3_Catgr_CD__c IN :materialGroup3Set)) 
                                         ORDER BY APTS_NetVsMultiplier_Sequence__c Asc
                                        ];
        
        getProductAndAllCostFilterSets(lineItemList);
        
        AllCostlst = [SELECT Id, APTS_Material_Number__c,APTS_Cost__c, APTS_Valid_From_Date__c, APTS_Valid_Until_Date__c,
                      APTS_PriceList__c, APTS_Invalid__c, APTS_Sold_To_Account__c, APTS_Product_Name__c
                      FROM APTS_AllCost__c
                      WHERE APTS_Product_Name__c IN :productIdSetc AND APTS_Invalid__c = false AND
                      (APTS_Sold_To_Account__c IN :soldToIdSetc OR APTS_Sold_To_Account__c = null) AND
                      APTS_Material_Number__c IN :materialNumberSetc AND APTS_Cost_Calculation_Sequence__c <> 0 
                      ORDER BY APTS_Cost_Calculation_Sequence__c Asc
                     ];
        
        set<id> productidset = new set<id>();
        for(Apttus_Config2__LineItem__c li : lineItemList){
            productidset.add(li.Apttus_Config2__ProductId__c);
        }
        
        productmap = new map<id,product2>([SELECT Id, APTS_Available_Quantity__c FROM Product2 WHERE Id IN :productidset]);
        
        
        
    }
    
    global void setMode(Apttus_Config2.CustomClass.PricingMode pricingMode) {
        this.pricingMode = pricingMode;
    }
    
    global void beforePricing(Apttus_Config2.ProductConfiguration.LineItemColl lineItemCollection) {
        
    }
    
    global void beforePricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl lineItemCollection, Apttus_Config2.LineItem lineItem) {
        
    }
    
    global void onPriceItemSet(Apttus_Config2__PriceListItem__c priceListItem, Apttus_Config2.LineItem lineItem) {
        
    }
    
    global void afterPricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl lineItemCollection, Apttus_Config2.LineItem lineItem) {
        
    }
    
    global void afterPricing(Apttus_Config2.ProductConfiguration.LineItemColl lineItemCollection) {
        
        if(pricingMode == Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT) {
            
            Set<Id> setOfIdsOfModifiedLineItems = new Set<Id>();
            List<Apttus_Config2__LineItem__c> lineItemSOList = getLineItemSOList(lineItemCollection);
            
            if(lineItemSOList[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Sales_Order_Type__c == 'Project Order'){
                
                setOfIdsOfModifiedLineItems.addAll(setBasePriceOverrideWithOverrideMultiplierOnLineItems(lineItemSOList));
                
            } else {
                
                for(Apttus_Config2__LineItem__c Lineitem : lineItemSOList){
                    if(String.isBlank(Lineitem.Apttus_Config2__AdjustmentType__c)){
                        Lineitem.Apttus_Config2__AdjustmentAmount__c = null;
                        Lineitem.APTS_Override_Multiplier__c = null;
                    }
                }
                
                System.debug('callingpricecallback');
                
                setOfIdsOfModifiedLineItems.addAll(setBasePriceOverrideOrMultiplierOnLineItems(lineItemSOList));
                setOfIdsOfModifiedLineItems.addAll(setCustomCostOnLineItems(lineItemSOList));
            }
            
            
            updatePriceOnLineItems(setOfIdsOfModifiedLineItems, lineItemCollection);
            
            updateExtendedCostOnLineItems(lineItemSOList);
            updateTotalFieldsOnLineItems(lineItemSOList);
            updateavailableqty(lineItemSOList);
            //updateWarehouseDetailsBasedOnItemCategory(lineItemSOList);
        }
    }
    
    global void finish() {
        
    }
    
    
    ////////////////////////////////////   IMPLEMENTATION   ////////////////////////////////////
     /**
* Method to set Product Available Quantity for given list of Line Items.
**/
    private void updateavailableqty(List<Apttus_Config2__LineItem__c> lineItemSOList) {
        
        for(Apttus_Config2__LineItem__c lineItemSO : lineItemSOList) {
            if(lineItemSO.APTS_Item_Category__c == 'Stock Order'){
            lineItemSO.APTS_Available_Quantity__c = productmap.get(lineItemSO.Apttus_Config2__ProductId__c).APTS_Available_Quantity__c;
            }
        }
    }
    
    
    private List<Apttus_Config2__LineItem__c> getLineItemSOList(Apttus_Config2.ProductConfiguration.LineItemColl lineItemCollection) {
        List<Apttus_Config2__LineItem__c> lineItemSOList = new List<Apttus_Config2__LineItem__c>();
        
        for(Apttus_Config2.LineItem lineItem : lineItemCollection.getAllLineItems()) {
            lineItemSOList.add(lineItem.getLineItemSO());
        }
        
        return lineItemSOList;
    }
    
    private Set<Id> setBasePriceOverrideOrMultiplierOnLineItems(List<Apttus_Config2__LineItem__c> lineItemSOList) {
        NetVsMultiplierHelper helper = new NetVsMultiplierHelper();
        
        Set<Id> setOfIdsOfModifiedLineItems = new Set<id>();
        List<Apttus_Config2__LineItem__c> lineItemSOListtemp = new List<Apttus_Config2__LineItem__c> ();
        
        /*for(Apttus_Config2__LineItem__c Lineitem : lineItemSOList){
if(Lineitem.Apttus_Config2__PricingStatus__c == 'Pending'){
lineItemSOListtemp.add(Lineitem);
}
}*/
        //if(lineItemSOListtemp.size() > 0){
        setOfIdsOfModifiedLineItems = helper.getMultiplierOrNetPrice(lineItemSOList, ContractualPriceMultiplierlst);
        //}
        return setOfIdsOfModifiedLineItems;
    }
    
    private Set<Id> setBasePriceOverrideWithOverrideMultiplierOnLineItems(List<Apttus_Config2__LineItem__c> lineItemSOList) {
        
        Set<Id> setOfIdsOfModifiedLineItems = new Set<Id>();
        
        for(Apttus_Config2__LineItem__c configLineItem : lineItemSOList){
            
            if(String.isBlank(configLineItem.Apttus_Config2__AdjustmentType__c) || configLineItem.Apttus_Config2__AdjustmentAmount__c == null){
                
                decimal listPrice = 0;
                if (configLineItem.APTS_Override_Multiplier__c != null){
                    System.debug('*********inside override multiplier----');
                    if(configLineItem.Apttus_Config2__ListPrice__c != null){
                        listPrice = configLineItem.Apttus_Config2__ListPrice__c;
                        System.debug('**********list price 1---'+listPrice);
                    }
                    
                    if(configLineItem.APTS_Override_Multiplier__c == 0){
                        System.debug('************inside 0 value condition');
                        configLineItem.Apttus_Config2__BasePriceOverride__c = 0;
                    } else {
                        configLineItem.Apttus_Config2__BasePriceOverride__c = (listPrice * configLineItem.APTS_Override_Multiplier__c)/100;
                    }
                    
                    setOfIdsOfModifiedLineItems.add(configLineItem.Id);
                }
            }
        }
        
        return setOfIdsOfModifiedLineItems;
    }
    
    private Set<Id> setCustomCostOnLineItems(List<Apttus_Config2__LineItem__c> lineItemSOList) {
        CustomCostHelper helper = new CustomCostHelper();
        Set<Id> setOfIdsOfModifiedLineItems = helper.beginToPopulateCostOnLineItems(lineItemSOList, AllCostlst);
        
        return setOfIdsOfModifiedLineItems;
    }
    
    private void updatePriceOnLineItems(Set<Id> setOfIdsOfModifiedLineItems, Apttus_Config2.ProductConfiguration.LineItemColl lineItemCollection) {
        if(setOfIdsOfModifiedLineItems != null && !setOfIdsOfModifiedLineItems.isEmpty()) {
            
            for(Apttus_Config2.LineItem lineItem : lineItemCollection.getAllLineItems()) {
                if(setOfIdsOfModifiedLineItems.contains(lineItem.getLineItemSO().Id)) {
                    lineItem.updatePrice();
                }
            }
        }
    }
    
    private void updateExtendedCostOnLineItems(List<Apttus_Config2__LineItem__c> lineItemSOList) {
        
        for(Apttus_Config2__LineItem__c lineItemSO : lineItemSOList) {
            
            Decimal baseCostOverride = lineItemSO.Apttus_Config2__BaseCostOverride__c;
            Decimal cost = lineItemSO.Apttus_Config2__Cost__c == null ? 0 : lineItemSO.Apttus_Config2__Cost__c;
            Decimal vendorCost = lineItemSO.APTS_Vendor_Cost__c == null ? 0 : lineItemSO.APTS_Vendor_Cost__c;
            
            if(baseCostOverride != null) {
                lineItemSO.Apttus_Config2__ExtendedCost__c = (baseCostOverride + vendorCost) * lineItemSO.Apttus_Config2__Quantity__c;
            }
            
            else if(lineItemSO.Apttus_Config2__Cost__c != null || lineItemSO.APTS_Vendor_Cost__c != null) {
                lineItemSO.Apttus_Config2__ExtendedCost__c = (cost + vendorCost) * lineItemSO.Apttus_Config2__Quantity__c;
            }
        }
    }
    
    private void updateTotalFieldsOnLineItems(List<Apttus_Config2__LineItem__c> lineItemSOList) {
        
        for(Apttus_Config2__LineItem__c lineItemSO : lineItemSOList) {
            
            Decimal quantity = lineItemSO.Apttus_Config2__Quantity__c;
            Decimal netPrice = lineItemSO.Apttus_Config2__NetPrice__c;
            
            if(quantity != null && quantity > 0) {
                
                Decimal weightGms = lineItemSO.APTS_Weight_gm__c == null ? 0 : lineItemSO.APTS_Weight_gm__c;
                Decimal extendedCost = lineItemSO.Apttus_Config2__ExtendedCost__c == null ? 0 : lineItemSO.Apttus_Config2__ExtendedCost__c;
                
                lineItemSO.APTS_Total_Weight_gm__c = quantity * weightGms;
                
                if(netPrice != null && netPrice > 0) {
                    lineItemSO.APTS_Gross_Profit__c = (netPrice - extendedCost) / quantity;
                    lineItemSO.APTS_Extended_Gross_Profit__c = lineItemSO.APTS_Gross_Profit__c * quantity;
                    lineItemSO.APTS_Margin__c = lineItemSO.APTS_Extended_Gross_Profit__c / netPrice;
                    
                } else {
                    lineItemSO.APTS_Gross_Profit__c = null;
                    lineItemSO.APTS_Extended_Gross_Profit__c = null;
                    lineItemSO.APTS_Margin__c = null;
                }
                
            } else {
                lineItemSO.APTS_Total_Weight_gm__c = null;
            }
        }
    }
    
    /*private void updateWarehouseDetailsBasedOnItemCategory(List<Apttus_Config2__LineItem__c> lineItemSOList) {

for(Apttus_Config2__LineItem__c lineItemSO : lineItemSOList) {

if('Individual Spec'.equals(lineItemSO.APTS_Item_Category__c) || 'KB Order(Direct)'.equals(lineItemSO.APTS_Item_Category__c)) {
lineItemSO.APTS_Warehouse_Number__c = null;
lineItemSO.APTS_Warehouse_Name__c = null;
lineItemSO.APTS_Warehouse_Location__c = null;
lineItemSO.APTS_Available_Quantity__c = null;
}

else if('Indent Order(Product)'.equals(lineItemSO.APTS_Item_Category__c) || 'Indent Order(Parts)'.equals(lineItemSO.APTS_Item_Category__c)) {
lineItemSO.APTS_Warehouse_Number__c = '3099';
lineItemSO.APTS_Warehouse_Name__c = 'In Transit';
lineItemSO.APTS_Warehouse_Location__c = null;
lineItemSO.APTS_Available_Quantity__c = null;                
}
}
}*/
    
    
    //NetVsMultiplierHelper variables
    
    /**
* Method to get set of product ID and Different fields Set for filter in Contractual Price Multiplier query from given list of Line Item records.
**/
    private void getProductAndContractualMultiplierFilterSets(List<Apttus_Config2__LineItem__c> lineItemList) {
        
        for(Apttus_Config2__LineItem__c lineItem : lineItemList) {
            if(String.isNotBlank(lineItem.Apttus_Config2__ProductId__c)) {
                productIdSet.add(lineItem.Apttus_Config2__ProductId__c);
            }
            
            if(lineItem.Apttus_Config2__ConfigurationId__c != null && 
               lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c != null &&
               String.isNotBlank(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c)) {
                   soldToIdSet.add(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c);
               }
            
            if(lineItem.Apttus_Config2__ConfigurationId__c != null && 
               lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c != null &&
               String.isNotBlank(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c)) {
                   shipToIdSet.add(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c);
               }
            
            if (String.isNotEmpty(lineItem.Apttus_Config2__PriceListId__c)) {
                pricelistIdSet.add(lineItem.Apttus_Config2__PriceListId__c);
            }
            
            if(String.isNotBlank(lineItem.APTS_Material_Num__c)) {
                materialNumberSet.add(lineItem.APTS_Material_Num__c);
            }
            
            if(String.isNotBlank(lineItem.APTS_Mat_Grp_1_CIT__c)) {
                materialGroup1Set.add(lineItem.APTS_Mat_Grp_1_CIT__c);
            }
            
            if(String.isNotBlank(lineItem.APTS_Mat_Grp_2_Catlg__c)) {
                materialGroup2Set.add(lineItem.APTS_Mat_Grp_2_Catlg__c);
            }
            
            if(String.isNotBlank(lineItem.APTS_Mat_Grp_3_Catgr_CD__c)) {
                materialGroup3Set.add(lineItem.APTS_Mat_Grp_3_Catgr_CD__c);
            }
            
        }
        
    }
    
    //CustomCostHelper
    
    /**
* Method to get set of product ID and Different fields Set for filter in All Cost query from given list of Line Item records.
**/
    public void getProductAndAllCostFilterSets(List<Apttus_Config2__LineItem__c> lineItemList) {
        
        if(!lineItemList.isEmpty()){
            
            for(Apttus_Config2__LineItem__c lineItem : lineItemList) {
                
                if(String.isNotBlank(lineItem.Apttus_Config2__ProductId__c)) {
                    productIdSetc.add(lineItem.Apttus_Config2__ProductId__c);
                }
                
                if(lineItem.Apttus_Config2__ConfigurationId__c != null && String.isNotBlank(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c)) {
                    soldToIdSetc.add(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c);
                }
                
                if(String.isNotBlank(lineItem.APTS_Material_Num__c)) {
                    materialNumberSetc.add(lineItem.APTS_Material_Num__c);
                }
                
            }
            
        }
        
    }
    
    
}