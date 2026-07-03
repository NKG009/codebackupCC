/****************************
* Name : NetVsMultiplierHelper
* Description : Class to automate the population of multiplier or net price on each line item based on Net vs multiplier pricing logic.
****************************/

public class NetVsMultiplierHelper {
    
    /*
private Set<Id> productIdSet = new Set<Id>();
private Set<Id> soldToIdSet = new Set<Id>();
private Set<Id> shipToIdSet = new Set<Id>();
private Set<Id> pricelistIdSet = new Set<Id>();
private Set<String> materialNumberSet = new Set<String>();
private Set<String> materialGroup1Set = new Set<String>();
private Set<String> materialGroup2Set = new Set<String>();
private Set<String> materialGroup3Set = new Set<String>();
*/
    
    
    /**
* Method to get Net Price or Multiplier based on Net vs Multiplier pricing logic from given list of Line Item records.
**/
    
    public Set<Id> getMultiplierOrNetPrice(List<Apttus_Config2__LineItem__c> configLineItemList, List<APTS_ContractualPriceMultiplier__c> ContractualPriceMultiplierlst){
        
        System.debug('inside class NetVsMultiplierHelper-----');
        
        Set<Id> idSetOfModifiedLineItems = new Set<Id>();
        
        if(!configLineItemList.isEmpty()){
            
            System.debug('configLineItemList---'+configLineItemList);
            
            Map<String, List<APTS_ContractualPriceMultiplier__c>> productIdVsContractualPriceMultiplierMap = new Map<String, List<APTS_ContractualPriceMultiplier__c>>();
            
            Map<String, List<APTS_ContractualPriceMultiplier__c>> materialGroup3VsContractualPriceMultiplierMap = new Map<String, List<APTS_ContractualPriceMultiplier__c>>();
            
            Map<String, List<APTS_ContractualPriceMultiplier__c>> materialGroup1and2VsContractualPriceMultiplierMap = new Map<String, List<APTS_ContractualPriceMultiplier__c>>();
            
/*getProductAndContractualMultiplierFilterSets(configLineItemList);
System.debug('materialGroup1Set--'+materialGroup1Set);
System.debug('materialGroup2Set--'+materialGroup2Set);
System.debug('materialGroup3Set--'+materialGroup3Set);
System.debug('pricelistIdSet--'+pricelistIdSet);
System.debug('soldToIdSet--'+soldToIdSet);
System.debug('shipToIdSet--'+shipToIdSet);
System.debug('productIdSet--'+productIdSet);
System.debug('materialNumberSet--'+materialNumberSet);*/
            
            System.debug('callingNetVsMultiplierHelper');  
            
            // Get related contractual price multiplier records based on different filter sets
            for(APTS_ContractualPriceMultiplier__c contractualPriceMultiplier : ContractualPriceMultiplierlst){
                
                if(String.isNotEmpty(contractualPriceMultiplier.APTS_Product_Name__c)){
                    
                    if(!productIdVsContractualPriceMultiplierMap.isEmpty() && productIdVsContractualPriceMultiplierMap.containsKey(contractualPriceMultiplier.APTS_Product_Name__c)){
                        
                        List<APTS_ContractualPriceMultiplier__c> existingContractualPriceMultiplierList = productIdVsContractualPriceMultiplierMap.get(contractualPriceMultiplier.APTS_Product_Name__c);
                        existingContractualPriceMultiplierList.add(contractualPriceMultiplier);
                        
                        productIdVsContractualPriceMultiplierMap.put(contractualPriceMultiplier.APTS_Product_Name__c, existingContractualPriceMultiplierList);
                        
                    } else {
                        
                        productIdVsContractualPriceMultiplierMap.put(contractualPriceMultiplier.APTS_Product_Name__c, new List<APTS_ContractualPriceMultiplier__c>{contractualPriceMultiplier});
                    }
                    
                }
                
                
                if(String.isNotEmpty(contractualPriceMultiplier.APTS_Mat_Grp_3_Catgr_CD__c)){
                    
                    System.debug('inside if of group 3 map--'+contractualPriceMultiplier.APTS_Mat_Grp_3_Catgr_CD__c);
                    
                    if(!materialGroup3VsContractualPriceMultiplierMap.isEmpty() && materialGroup3VsContractualPriceMultiplierMap.containsKey(contractualPriceMultiplier.APTS_Mat_Grp_3_Catgr_CD__c)){
                        
                        List<APTS_ContractualPriceMultiplier__c> existingContractualPriceMultiplierList = materialGroup3VsContractualPriceMultiplierMap.get(contractualPriceMultiplier.APTS_Mat_Grp_3_Catgr_CD__c);
                        existingContractualPriceMultiplierList.add(contractualPriceMultiplier);
                        
                        materialGroup3VsContractualPriceMultiplierMap.put(contractualPriceMultiplier.APTS_Mat_Grp_3_Catgr_CD__c, existingContractualPriceMultiplierList);
                        
                    } else {
                        
                        materialGroup3VsContractualPriceMultiplierMap.put(contractualPriceMultiplier.APTS_Mat_Grp_3_Catgr_CD__c, new List<APTS_ContractualPriceMultiplier__c>{contractualPriceMultiplier});
                    }
                    
                }
                
                
                if(String.isNotEmpty(contractualPriceMultiplier.APTS_Mat_Grp_1_CIT__c) && String.isNotEmpty(contractualPriceMultiplier.APTS_Mat_Grp_2_Catlg__c)){
                    
                    System.debug('inside if of group 1&2 map--'+contractualPriceMultiplier.APTS_Mat_Grp_3_Catgr_CD__c);
                    
                    String key = contractualPriceMultiplier.APTS_Mat_Grp_1_CIT__c + contractualPriceMultiplier.APTS_Mat_Grp_2_Catlg__c;
                    
                    if(!materialGroup1and2VsContractualPriceMultiplierMap.isEmpty() && materialGroup1and2VsContractualPriceMultiplierMap.containsKey(key)){
                        
                        List<APTS_ContractualPriceMultiplier__c> existingContractualPriceMultiplierList = materialGroup1and2VsContractualPriceMultiplierMap.get(key);
                        existingContractualPriceMultiplierList.add(contractualPriceMultiplier);
                        
                        materialGroup1and2VsContractualPriceMultiplierMap.put(key, existingContractualPriceMultiplierList);
                        
                    } else {
                        
                        materialGroup1and2VsContractualPriceMultiplierMap.put(key, new List<APTS_ContractualPriceMultiplier__c>{contractualPriceMultiplier});
                    }
                    
                }
                
            }
            
            System.debug('productIdVsContractualPriceMultiplierMap---'+productIdVsContractualPriceMultiplierMap);
            System.debug('materialGroup3VsContractualPriceMultiplierMap---'+materialGroup3VsContractualPriceMultiplierMap);
            System.debug('materialGroup1and2VsContractualPriceMultiplierMap---'+materialGroup1and2VsContractualPriceMultiplierMap);
            
            // if(!productIdVsContractualPriceMultiplierMap.isEmpty() || 
            // !materialGroup3VsContractualPriceMultiplierMap.isEmpty() || 
            // !materialGroup1and2VsContractualPriceMultiplierMap.isEmpty()){
            
            //System.debug('inside main if-----');
            
            for(Apttus_Config2__LineItem__c configLineItem : configLineItemList){
                
                if(!String.isBlank(configLineItem.Apttus_Config2__AdjustmentType__c) && configLineItem.Apttus_Config2__AdjustmentAmount__c == null){
                    
                    Boolean lineItemModifiedCheck = false;
                    
                    if(String.isNotEmpty(configLineItem.Apttus_Config2__ProductId__c) && 
                       !productIdVsContractualPriceMultiplierMap.isEmpty() && 
                       productIdVsContractualPriceMultiplierMap.containsKey(configLineItem.Apttus_Config2__ProductId__c) ){
                           
                           Map<string, decimal> basePriceMultiplierLineItemMap = new Map<string, decimal>();
                           
                           for( APTS_ContractualPriceMultiplier__c ContractualPriceMultiplier : productIdVsContractualPriceMultiplierMap.get(configLineItem.Apttus_Config2__ProductId__c)){
                               
                               System.debug('ContractualPriceMultiplier---'+ContractualPriceMultiplier);
                               
                               //System.debug('config sold to ---'+configLineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c);
                               
                               System.debug('config line item--'+configLineItem);
                               
                               System.debug('configLineItem.Apttus_Config2__PricingDate__c---'+configLineItem.Apttus_Config2__PricingDate__c);
                               
                               Boolean validDateRangeCheck = false;
                               
                               if(ContractualPriceMultiplier.APTS_Valid_From_Date__c != null && 
                                  ContractualPriceMultiplier.APTS_Valid_Until_Date__c != null && 
                                  configLineItem.Apttus_Config2__PricingDate__c != null){
                                      
                                      validDateRangeCheck = isValidPricingDate(ContractualPriceMultiplier.APTS_Valid_From_Date__c, ContractualPriceMultiplier.APTS_Valid_Until_Date__c, configLineItem.Apttus_Config2__PricingDate__c);
                                  }
                               
                               If (
                                   (configLineItem.Apttus_Config2__ConfigurationId__c != null && 
                                    configLineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c	!= null &&
                                    ContractualPriceMultiplier.APTS_Sold_To_Account__c == configLineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c) &&
                                   ContractualPriceMultiplier.APTS_PriceList__c == configLineItem.Apttus_Config2__PriceListId__c &&
                                   validDateRangeCheck &&
                                   ContractualPriceMultiplier.APTS_Invalid__c == false
                               ){
                                   
                                   If (
                                       ContractualPriceMultiplier.APTS_Ship_To_Account__c != null && configLineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c != null &&
                                       ContractualPriceMultiplier.APTS_Ship_To_Account__c == configLineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c &&
                                       ContractualPriceMultiplier.APTS_Material_Number__c == configLineItem.APTS_Material_Num__c &&
                                       ContractualPriceMultiplier.APTS_Contract_Price__c != null
                                   ){
                                       System.debug('inside condition 1');
                                       configLineItem.Apttus_Config2__BasePriceOverride__c = ContractualPriceMultiplier.APTS_Contract_Price__c;
                                       configLineItem.APTS_Multiplier__c = null;
                                       lineItemModifiedCheck = true;
                                       break;
                                       
                                   } else {
                                       If ( 
                                           ContractualPriceMultiplier.APTS_Ship_To_Account__c == null && 
                                           ContractualPriceMultiplier.APTS_Material_Number__c == configLineItem.APTS_Material_Num__c &&
                                           ContractualPriceMultiplier.APTS_Contract_Price__c != null
                                       ){
                                           System.debug('inside condition 2');
                                           configLineItem.Apttus_Config2__BasePriceOverride__c = ContractualPriceMultiplier.APTS_Contract_Price__c;
                                           configLineItem.APTS_Multiplier__c = null;
                                           lineItemModifiedCheck = true;
                                           break;
                                           
                                       } else {
                                           If ( 
                                               ContractualPriceMultiplier.APTS_Ship_To_Account__c != null && configLineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c != null &&
                                               ContractualPriceMultiplier.APTS_Ship_To_Account__c == configLineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c &&
                                               ContractualPriceMultiplier.APTS_Material_Number__c == configLineItem.APTS_Material_Num__c &&
                                               ContractualPriceMultiplier.APTS_Multiplier__c != null
                                           ){
                                               System.debug('inside condition 3');
                                               configLineItem.APTS_Multiplier__c = ContractualPriceMultiplier.APTS_Multiplier__c;
                                               lineItemModifiedCheck = true;
                                               break;
                                               
                                           } else {
                                               If (
                                                   ContractualPriceMultiplier.APTS_Ship_To_Account__c == null &&
                                                   ContractualPriceMultiplier.APTS_Material_Number__c == configLineItem.APTS_Material_Num__c &&
                                                   ContractualPriceMultiplier.APTS_Multiplier__c != null
                                               ){
                                                   System.debug('inside condition 4');
                                                   configLineItem.APTS_Multiplier__c = ContractualPriceMultiplier.APTS_Multiplier__c;
                                                   lineItemModifiedCheck = true;
                                                   break;
                                                   
                                               } else {
                                                   
                                               }
                                           }
                                       }
                                   }
                                   
                               } else {
                                   
                               }
                               
                           }  
                           
                       }
                    
                    
                    if(String.isNotEmpty(configLineItem.APTS_Mat_Grp_3_Catgr_CD__c) && 
                       !materialGroup3VsContractualPriceMultiplierMap.isEmpty() && 
                       materialGroup3VsContractualPriceMultiplierMap.containsKey(configLineItem.APTS_Mat_Grp_3_Catgr_CD__c) && 
                       !lineItemModifiedCheck ){
                           
                           
                           for( APTS_ContractualPriceMultiplier__c ContractualPriceMultiplier : materialGroup3VsContractualPriceMultiplierMap.get(configLineItem.APTS_Mat_Grp_3_Catgr_CD__c)){
                               
                               Boolean validDateRangeCheck = false;
                               
                               if(ContractualPriceMultiplier.APTS_Valid_From_Date__c != null && 
                                  ContractualPriceMultiplier.APTS_Valid_Until_Date__c != null && 
                                  configLineItem.Apttus_Config2__PricingDate__c != null){
                                      
                                      validDateRangeCheck = isValidPricingDate(ContractualPriceMultiplier.APTS_Valid_From_Date__c, ContractualPriceMultiplier.APTS_Valid_Until_Date__c, configLineItem.Apttus_Config2__PricingDate__c);
                                  }
                               
                               If (
                                   (configLineItem.Apttus_Config2__ConfigurationId__c != null && 
                                    configLineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c	!= null &&
                                    ContractualPriceMultiplier.APTS_Sold_To_Account__c == configLineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c) &&
                                   ContractualPriceMultiplier.APTS_PriceList__c == configLineItem.Apttus_Config2__PriceListId__c &&
                                   validDateRangeCheck &&
                                   ContractualPriceMultiplier.APTS_Invalid__c == false
                               ){
                                   If (
                                       ContractualPriceMultiplier.APTS_Ship_To_Account__c != null && configLineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c != null &&
                                       ContractualPriceMultiplier.APTS_Ship_To_Account__c == configLineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c &&
                                       ContractualPriceMultiplier.APTS_Mat_Grp_3_Catgr_CD__c == configLineItem.APTS_Mat_Grp_3_Catgr_CD__c &&
                                       ContractualPriceMultiplier.APTS_Multiplier__c != null
                                   ){
                                       System.debug('inside condition 5');
                                       configLineItem.APTS_Multiplier__c = ContractualPriceMultiplier.APTS_Multiplier__c;
                                       lineItemModifiedCheck = true;
                                       break;
                                       
                                   }
                               }
                           }
                       }
                    
                    
                    
                    if(String.isNotEmpty(configLineItem.APTS_Mat_Grp_1_CIT__c) && 
                       String.isNotEmpty(configLineItem.APTS_Mat_Grp_2_Catlg__c) && 
                       !materialGroup1and2VsContractualPriceMultiplierMap.isEmpty() && 
                       !lineItemModifiedCheck ){
                           
                           String key = configLineItem.APTS_Mat_Grp_1_CIT__c + configLineItem.APTS_Mat_Grp_2_Catlg__c;
                           
                           if(materialGroup1and2VsContractualPriceMultiplierMap.containsKey(key)){
                               
                               for( APTS_ContractualPriceMultiplier__c ContractualPriceMultiplier : materialGroup1and2VsContractualPriceMultiplierMap.get(key)){
                                   
                                   Boolean validDateRangeCheck = false;
                                   
                                   if(ContractualPriceMultiplier.APTS_Valid_From_Date__c != null && 
                                      ContractualPriceMultiplier.APTS_Valid_Until_Date__c != null && 
                                      configLineItem.Apttus_Config2__PricingDate__c != null){
                                          
                                          validDateRangeCheck = isValidPricingDate(ContractualPriceMultiplier.APTS_Valid_From_Date__c, ContractualPriceMultiplier.APTS_Valid_Until_Date__c, configLineItem.Apttus_Config2__PricingDate__c);
                                      }
                                   
                                   If (
                                       (configLineItem.Apttus_Config2__ConfigurationId__c != null && 
                                        configLineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c	!= null &&
                                        ContractualPriceMultiplier.APTS_Sold_To_Account__c == configLineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c) &&
                                       ContractualPriceMultiplier.APTS_PriceList__c == configLineItem.Apttus_Config2__PriceListId__c &&
                                       validDateRangeCheck &&
                                       ContractualPriceMultiplier.APTS_Invalid__c == false
                                   ){
                                       If ( 
                                           ContractualPriceMultiplier.APTS_Ship_To_Account__c != null && configLineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c != null &&
                                           ContractualPriceMultiplier.APTS_Ship_To_Account__c == configLineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c &&
                                           ContractualPriceMultiplier.APTS_Mat_Grp_1_CIT__c == configLineItem.APTS_Mat_Grp_1_CIT__c &&
                                           ContractualPriceMultiplier.APTS_Mat_Grp_2_Catlg__c == configLineItem.APTS_Mat_Grp_2_Catlg__c &&
                                           ContractualPriceMultiplier.APTS_Multiplier__c != null
                                       ){
                                           System.debug('inside condition 6');
                                           configLineItem.APTS_Multiplier__c = ContractualPriceMultiplier.APTS_Multiplier__c;
                                           lineItemModifiedCheck = true;
                                           break;
                                           
                                       }
                                   }
                               }
                               
                           }
                       }
                    
                    if (!lineItemModifiedCheck) {   
                        
                        System.debug('inside null condition------');
                        
                        configLineItem.Apttus_Config2__BasePriceOverride__c = null;
                        configLineItem.APTS_Multiplier__c = null;
                    }
                    
                    System.debug('before configLineItem.Apttus_Config2__ListPrice__c---'+configLineItem.Apttus_Config2__ListPrice__c);
                    System.debug('before configLineItem.Apttus_Config2__BasePriceOverride__c---'+configLineItem.Apttus_Config2__BasePriceOverride__c);
                    System.debug('before configLineItem.APTS_Multiplier__c---'+configLineItem.APTS_Multiplier__c);
                    System.debug('before configLineItem.APTS_Override_Multiplier__c---'+configLineItem.APTS_Override_Multiplier__c);
                    
                    
                    decimal listPrice = 0;
                    if (configLineItem.APTS_Override_Multiplier__c != null){
                        System.debug('inside override multiplier----');
                        if(configLineItem.Apttus_Config2__ListPrice__c != null){
                            listPrice = configLineItem.Apttus_Config2__ListPrice__c;
                            System.debug('list price 1---'+listPrice);
                        }
                        
                        if(configLineItem.APTS_Override_Multiplier__c == 0){
                            System.debug('inside 0 value condition');
                            configLineItem.Apttus_Config2__BasePriceOverride__c = 0;
                        } else {
                            configLineItem.Apttus_Config2__BasePriceOverride__c = (listPrice * configLineItem.APTS_Override_Multiplier__c)/100;
                        }
                        
                        lineItemModifiedCheck = true;
                    }
                    else {
                        System.debug('inside multiplier----');
                        if (configLineItem.APTS_Multiplier__c != null){
                            if(configLineItem.Apttus_Config2__ListPrice__c != null){
                                listPrice = configLineItem.Apttus_Config2__ListPrice__c;
                                System.debug('list price 2---'+listPrice);
                            }
                            configLineItem.Apttus_Config2__BasePriceOverride__c = (listPrice * configLineItem.APTS_Multiplier__c)/100;
                            lineItemModifiedCheck = true;
                        }
                        
                    }
                    
                    System.debug('after configLineItem.Apttus_Config2__ListPrice__c---'+configLineItem.Apttus_Config2__ListPrice__c);
                    System.debug('after configLineItem.Apttus_Config2__BasePriceOverride__c---'+configLineItem.Apttus_Config2__BasePriceOverride__c);
                    System.debug('after configLineItem.APTS_Multiplier__c---'+configLineItem.APTS_Multiplier__c);
                    System.debug('after configLineItem.APTS_Override_Multiplier__c---'+configLineItem.APTS_Override_Multiplier__c);
                    
                    System.debug('lineItemModifiedCheck----'+lineItemModifiedCheck);
                    if(lineItemModifiedCheck){
                        idSetOfModifiedLineItems.add(configLineItem.Id);
                    }
                    
                }
                
            }
            
            //}
            
            for(Apttus_Config2__LineItem__c configLineItem  : configLineItemList){
                
                System.debug('updated configLineItem---'+configLineItem);
            }
            
        }
        
        
        return idSetOfModifiedLineItems;
        
    }
    
    
    /**
* Method to get set of product ID and Different fields Set for filter in Contractual Price Multiplier query from given list of Line Item records.

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

}*/
    
    /**
* Method to get set of product ID from given list of Line Item records.

public Set<Id> getProductIdSet(List<Apttus_Config2__LineItem__c> lineItemList) {
Set<Id> productIdSet = new Set<Id>();

for(Apttus_Config2__LineItem__c lineItem : lineItemList) {
if(String.isNotBlank(lineItem.Apttus_Config2__ProductId__c)) {
productIdSet.add(lineItem.Apttus_Config2__ProductId__c);
}
}

return productIdSet;
} **/
    
    /**
* Method to get set of Sold To - Account ID from given list of Line Item records.

public Set<Id> getSoldToIdSet(List<Apttus_Config2__LineItem__c> lineItemList) {
Set<Id> soldToIdSet = new Set<Id>();

for(Apttus_Config2__LineItem__c lineItem : lineItemList) {
if(lineItem.Apttus_Config2__ConfigurationId__c != null && 
lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c != null &&
String.isNotBlank(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c)) {
soldToIdSet.add(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c);
}
}

return soldToIdSet;
}**/
    
    /**
* Method to get set of Ship To - Account ID from given list of Line Item records.

public Set<Id> getShipToIdSet(List<Apttus_Config2__LineItem__c> lineItemList) {
Set<Id> shipToIdSet = new Set<Id>();

for(Apttus_Config2__LineItem__c lineItem : lineItemList) {
if(lineItem.Apttus_Config2__ConfigurationId__c != null && 
lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c != null &&
String.isNotBlank(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c)) {
shipToIdSet.add(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c);
}
}

return shipToIdSet;
}**/
    
    
    /**
* Method to get set of Material Number from given list of Line Item records.

public Set<String> getMaterialNumberSet(List<Apttus_Config2__LineItem__c> lineItemList) {
Set<String> materialNumberSet = new Set<String>();

for(Apttus_Config2__LineItem__c lineItem : lineItemList) {
if(String.isNotBlank(lineItem.APTS_Material_Num__c)) {
materialNumberSet.add(lineItem.APTS_Material_Num__c);
}
}

return materialNumberSet;
}**/
    
    /**
* Method to get set of Material Group 1 from given list of Line Item records.

public Set<String> getMaterialGroup1Set(List<Apttus_Config2__LineItem__c> lineItemList) {
Set<String> materialGroup1Set = new Set<String>();

for(Apttus_Config2__LineItem__c lineItem : lineItemList) {
if(String.isNotBlank(lineItem.APTS_Material_Num__c)) {
materialGroup1Set.add(lineItem.APTS_Material_Num__c);
}
}

return materialGroup1Set;
}**/
    
    /**
* Method to get set of Material Group 2 from given list of Line Item records.

public Set<String> getMaterialGroup2Set(List<Apttus_Config2__LineItem__c> lineItemList) {
Set<String> materialGroup2Set = new Set<String>();

for(Apttus_Config2__LineItem__c lineItem : lineItemList) {
if(String.isNotBlank(lineItem.APTS_Mat_Grp_2_Catlg__c)) {
materialGroup2Set.add(lineItem.APTS_Mat_Grp_2_Catlg__c);
}
}

return materialGroup2Set;
}**/
    
    /**
* Method to get set of Material Group 3 from given list of Line Item records.

public Set<String> getMaterialGroup3Set(List<Apttus_Config2__LineItem__c> lineItemList) {
Set<String> materialGroup3Set = new Set<String>();

for(Apttus_Config2__LineItem__c lineItem : lineItemList) {
if(String.isNotBlank(lineItem.APTS_Mat_Grp_3_Catgr_CD__c)) {
materialGroup3Set.add(lineItem.APTS_Mat_Grp_3_Catgr_CD__c);
}
}

return materialGroup3Set;
}**/
    
    public Date getDateInUserLocale(Date dt){
        
        List<String> dateParamList = new List<String>();
        
        if(dt != null){
            
            String dateString = dt.format();
            
            if(String.isEmpty(dateString) && dateString.contains('/')){
                
                dateParamList = dateString.split('/');
                
                Date newDate = date.newInstance(Integer.valueOf(dateParamList[2]), Integer.valueOf(dateParamList[0]), Integer.valueOf(dateParamList[1]) );
                
                return newDate;
                
            } else {
                return null;
            }
            
        } else {
            return null;
        }
        
    }
    
    
    /*public DateTime getDateTimeInUserLocale(Datetime dt){

if(dt != null){
Datetime newDateTime = dt.Date();
newDateTime = newDateTime.addHours(dt.hour());
newDateTime = newDateTime.addMinutes(dt.minute());
newDateTime = newDateTime.addSeconds(dt.second());

return newDateTime;

} else {
return null;
}
}*/
    
    
    public Boolean isValidPricingDate(Date validFrom, Date validUntill, DateTime pricingDate){
        
        Date convertedValidFrom = getDateInUserLocale(validFrom);
        Date convertedValidUntill = getDateInUserLocale(validUntill);
        //Datetime convertedPricingDate = getDateTimeInUserLocale(pricingDate);
        Date convertedPricingDate = pricingDate.date();
        
        System.debug('convertedPricingDate---'+convertedPricingDate);
        
        if(validFrom <= convertedPricingDate && validUntill >= convertedPricingDate){
            return true;
        } else {
            return false;
        }
        
        
    }
    
}