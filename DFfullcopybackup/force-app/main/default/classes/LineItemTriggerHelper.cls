/****************************
* Name : LineItemTriggerHelper
* Description : Class to perform operations on trigger events on Line Item object record.
****************************/

public class LineItemTriggerHelper {
    
    private Map<Id, Product2> productDetailsMap;
    private Map<Id, Apttus_Config2__ProductConfiguration__c> configurationDetailsMap;
    
    /**
* Method to set map of Configuration records available on given list of Line Item records.
**/
    public void setLineItemsValuesOnUpdate(List<Apttus_Config2__LineItem__c> newLineItemList, Map<Id, Apttus_Config2__LineItem__c> oldLineItemMap) {
        setProductDetailsMap(newLineItemList);
        for(Apttus_Config2__LineItem__c lineItem : newLineItemList) {
            if(String.isNotBlank(lineItem.APTS_Item_Category__c) && 
               ('Individual Spec'.equals(lineItem.APTS_Item_Category__c) || 'KB Order(Direct)'.equals(lineItem.APTS_Item_Category__c))
              ){
                  lineItem.APTS_Warehouse_Number__c = null;
                  lineItem.APTS_Warehouse_Name__c = null;
                  lineItem.APTS_Warehouse_Location__c = null;
                  lineItem.APTS_Available_Quantity__c = null;
                  lineItem.APTS_Mass_Update__c = 'No';
              }
            
            /* if(('Indent Order(Product)'.equals(lineItem.APTS_Item_Category__c) && 
oldLineItemMap.get(lineItem.id).APTS_Item_Category__c != 'Indent Order(Product)') ||
('Indent Order(Parts)'.equals(lineItem.APTS_Item_Category__c) &&
oldLineItemMap.get(lineItem.id).APTS_Item_Category__c != 'Indent Order(Parts)')) {*/
            if('Indent Order(Product)'.equals(lineItem.APTS_Item_Category__c) ||
               'Indent Order(Parts)'.equals(lineItem.APTS_Item_Category__c) ) {
                   lineItem.APTS_Warehouse_Number__c = '3099';
                   lineItem.APTS_Warehouse_Name__c = 'In Transit';
                   lineItem.APTS_Warehouse_Location__c = null;
                   lineItem.APTS_Available_Quantity__c = null; 
                   lineItem.APTS_Mass_Update__c = 'No';
               }
            
            if(('Stock Order'.equals(lineItem.APTS_Item_Category__c) && 
                oldLineItemMap.get(lineItem.id).APTS_Item_Category__c != 'Stock Order')) {
                    
                    Product2 productDetails = productDetailsMap.get(lineItem.Apttus_Config2__ProductId__c);                    
                    lineItem.APTS_Available_Quantity__c = productDetails.APTS_Available_Quantity__c;
                    lineItem.APTS_Warehouse_Number__c = '3008';
                    lineItem.APTS_Warehouse_Name__c = 'Stafford';
                    lineItem.APTS_Item_Category__c = 'Stock Order';
                    lineItem.APTS_Mass_Update__c = 'No';
                }
 /*if(('Indent Order(Product)'.equals(lineItem.APTS_Item_Category__c) && 
                oldLineItemMap.get(lineItem.id).APTS_Item_Category__c == 'Stock Order')) {
                    
                    Product2 productDetails = productDetailsMap.get(lineItem.Apttus_Config2__ProductId__c);                    
                    lineItem.APTS_Available_Quantity__c = null;
                    lineItem.APTS_Warehouse_Number__c = null;
                    lineItem.APTS_Warehouse_Name__c = null;
                     lineItem.APTS_Warehouse_Location__c = null;
                    //lineItem.APTS_Item_Category__c = 'Stock Order';   
                }*/
            
        }
    }
    
    /**
* Method to set map of Configuration records available on given list of Line Item records.
**/
    public void setConfigurationDetailsMap(List<Apttus_Config2__LineItem__c> newLineItemList) {
        configurationDetailsMap = new Map<Id, Apttus_Config2__ProductConfiguration__c>(getConfigurationDetailsList(getConfigurationIdSet(newLineItemList)));
    }
    
    /**
* Method to get set of Configuration record ID from give list of Line Item records.
**/
    private Set<Id> getConfigurationIdSet(List<Apttus_Config2__LineItem__c> lineItemList) {
        Set<Id> configurationIdSet = new Set<Id>();
        
        for(Apttus_Config2__LineItem__c lineItem : lineItemList) {
            configurationIdSet.add(lineItem.Apttus_Config2__ConfigurationId__c);
        }
        
        return configurationIdSet;
    }
    
    /**
* Method to get list of configuration records with their details for given set of configuration IDs.
**/
    private List<Apttus_Config2__ProductConfiguration__c> getConfigurationDetailsList(Set<Id> configurationIdSet) {
        List<Apttus_Config2__ProductConfiguration__c> configurationDetailsList = [SELECT Id, Name, Apttus_QPConfig__Proposald__r.Apttus_QPConfig__PricingDate__c,
                                                                                  Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c,
                                                                                  Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c,
                                                                                  Apttus_QPConfig__Proposald__r.APTS_Sales_Order_Type__c,
                                                                                  Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ConfigurationFinalizedDate__c
                                                                                  FROM Apttus_Config2__ProductConfiguration__c
                                                                                  WHERE Id IN :configurationIdSet];
        
        return configurationDetailsList;
    }
    
    
    /**
* Method to set map of Product records available on given list of Line Item records.
**/
    public void setProductDetailsMap(List<Apttus_Config2__LineItem__c> newLineItemList) {
        productDetailsMap = new Map<Id, Product2>(getProductDetailsList(getProductIdSet(newLineItemList)));
    }
    
    /**
* Method to get set of product ID from give list of Line Item records.
**/
    private Set<Id> getProductIdSet(List<Apttus_Config2__LineItem__c> lineItemList) {
        Set<Id> productIdSet = new Set<Id>();
        
        for(Apttus_Config2__LineItem__c lineItem : lineItemList) {
            if(String.isNotBlank(lineItem.Apttus_Config2__ProductId__c)) {
                productIdSet.add(lineItem.Apttus_Config2__ProductId__c);
            }
        }
        
        return productIdSet;
    }
    
    /**
* Method to get list of product records with their details for given set of product IDs.
**/
    private List<Product2> getProductDetailsList(Set<Id> productIdSet) {
        List<Product2> productDetailsList = [SELECT Id, Name, APTS_Material_Num__c, APTS_Mat_Grp_1_CIT__c, APTS_Mat_Grp_2_Catlg__c,
                                             APTS_Mat_Grp_3_Catgr_CD__c,APTS_MN_KFN_CCN_SPC__c, APTS_Spec_Pkg_Code__c, APTS_Size_inch__c,
                                             APTS_KCA_Fig_Num__c, APTS_Main_Plant__c, APTS_Weight_gm__c, ProductCode, Description,
                                             APTS_Available_Quantity__c, APTS_Main_Plant_Desc__c, APTS_Spec_Pkg_Cd_Desc__c, APTS_KCA_Spec_Description__c
                                             FROM Product2
                                             WHERE Id IN :productIdSet];
        
        return productDetailsList;
    }
    
    
    /**
* Method to populate values on Line Item record.
**/
    public void populateValuesOnLineItem(List<Apttus_Config2__LineItem__c> newLineItemList) {
        for(Apttus_Config2__LineItem__c lineItem : newLineItemList) {
            if(lineitem.APTS_Customer_PO_Line_Number__c == null){
                lineitem.APTS_Customer_PO_Line_Number__c = lineitem.Apttus_Config2__LineNumber__c;
            }
            
            // Populate Values From Configuration and Quote/Proposal Records
            if(configurationDetailsMap.containsKey(lineItem.Apttus_Config2__ConfigurationId__c)) {
                Apttus_Config2__ProductConfiguration__c configurationDetails = configurationDetailsMap.get(lineItem.Apttus_Config2__ConfigurationId__c);
                
                lineItem.Apttus_Config2__PricingDate__c = configurationDetails.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__PricingDate__c;
                lineItem.Apttus_Config2__ShipToAccountId__c = configurationDetails.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c;
                lineItem.APTS_Sold_To__c = configurationDetails.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c;
                
                
                if(productDetailsMap.containsKey(lineItem.Apttus_Config2__ProductId__c) && 
                   configurationDetails.Apttus_QPConfig__Proposald__r.APTS_Sales_Order_Type__c != null &&
                   configurationDetails.Apttus_QPConfig__Proposald__r.APTS_Sales_Order_Type__c == 'Standard Order') {
                       // configurationDetails.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ConfigurationFinalizedDate__c == null) {
                       
                       if ( lineItem.APTS_Item_Category__c == null) {
                           System.debug('@@final--------' +configurationDetails.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ConfigurationFinalizedDate__c);
                           Product2 productDetails = productDetailsMap.get(lineItem.Apttus_Config2__ProductId__c);
                           
                           lineItem.APTS_Available_Quantity__c = productDetails.APTS_Available_Quantity__c;
                           lineItem.APTS_Warehouse_Number__c = '3008';
                           lineItem.APTS_Warehouse_Name__c = 'Stafford';
                           lineItem.APTS_Item_Category__c = 'Stock Order';
                       }                       
                       /* lineItem.APTS_Warehouse_Number__c = productDetails.APTS_Warehouse_Number__c;
lineItem.APTS_Warehouse_Name__c = productDetails.APTS_Warehouse_Name__c;
lineItem.APTS_Warehouse_Location__c = productDetails.APTS_Warehouse_Location__c; */
                       
                       // if(String.isNotBlank(productDetails.APTS_Warehouse_Number__c)) {
                       // if(productDetails.APTS_Warehouse_Number__c == '3008') {
                       /* if (configurationDetails.Apttus_QPConfig__Proposald__r.APTS_Sales_Order_Type__c != null &&
configurationDetails.Apttus_QPConfig__Proposald__r.APTS_Sales_Order_Type__c == 'Standard Order') { */
                       
                       /*  } else if(productDetails.APTS_Warehouse_Number__c.contains('30W')) {
lineItem.APTS_Item_Category__c = 'Consigned Stock Order';
}*/
                       //  }
                   } else if (productDetailsMap.containsKey(lineItem.Apttus_Config2__ProductId__c) && 
                              configurationDetails.Apttus_QPConfig__Proposald__r.APTS_Sales_Order_Type__c != null &&
                              configurationDetails.Apttus_QPConfig__Proposald__r.APTS_Sales_Order_Type__c == 'Project Order' &&
                              // configurationDetails.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ConfigurationFinalizedDate__c == null) {
                              lineItem.APTS_Item_Category__c == null) {
                                  lineItem.APTS_Available_Quantity__c = null;
                                  lineItem.APTS_Warehouse_Number__c = '3099';
                                  lineItem.APTS_Warehouse_Name__c = 'In Transit';
                                  lineItem.APTS_Warehouse_Location__c = null;
                                  lineItem.APTS_Item_Category__c = 'Project w/ Spec';
                              }
            }
            
            
            // Populate Values From Product Record
            if(productDetailsMap.containsKey(lineItem.Apttus_Config2__ProductId__c)) {
                Product2 productDetails = productDetailsMap.get(lineItem.Apttus_Config2__ProductId__c);
                
                lineItem.APTS_Material_Num__c = productDetails.APTS_Material_Num__c;
                lineItem.APTS_Mat_Grp_1_CIT__c = productDetails.APTS_Mat_Grp_1_CIT__c;
                lineItem.APTS_Mat_Grp_2_Catlg__c = productDetails.APTS_Mat_Grp_2_Catlg__c;
                lineItem.APTS_Mat_Grp_3_Catgr_CD__c = productDetails.APTS_Mat_Grp_3_Catgr_CD__c;
                lineItem.APTS_Spec_Pkg_Code__c = productDetails.APTS_Spec_Pkg_Code__c;
                lineItem.APTS_Size_inch__c = productDetails.APTS_Size_inch__c;
                lineItem.APTS_KCA_Fig_Num__c = productDetails.APTS_KCA_Fig_Num__c;
                //lineItem.APTS_MN_KFN_CCN_SPC__c = productDetails.APTS_MN_KFN_CCN_SPC__c;
                //lineItem.APTS_MN_KFN_CCN_SPC_New__c = productDetails.APTS_MN_KFN_CCN_SPC__c;
                lineItem.APTS_Origin__c = productDetails.APTS_Main_Plant__c;
                lineItem.APTS_Weight_gm__c = productDetails.APTS_Weight_gm__c;
                lineItem.APTS_Product_Code__c = productDetails.ProductCode;
                lineItem.APTS_Product_Description__c = productDetails.Description;
                lineItem.APTS_Main_Plant_Desc__c = productDetails.APTS_Main_Plant_Desc__c;
                lineItem.APTS_Spec_Pkg_Cd_Desc__c = productDetails.APTS_Spec_Pkg_Cd_Desc__c;
                lineItem.APTS_KCA_Spec_Description__c = productDetails.APTS_KCA_Spec_Description__c;
                
                
            }
        }
    }    
    
}