/********************************************
* Name : CustomCostHelper
* Description : Class to automate cost population on Line Item object records through custom pricing callback.
********************************************/

public class CustomCostHelper {
    
    Map<String, List<APTS_AllCost__c>> productAllCostDetailsMap = new Map<String, List<APTS_AllCost__c>>();
    
    /*private Set<Id> productIdSet = new Set<Id>();
private Set<Id> soldToIdSet = new Set<Id>();
private Set<String> materialNumberSet = new Set<String>();*/
    
    
    public set<Id> beginToPopulateCostOnLineItems(List<Apttus_Config2__LineItem__c> lineItemList, list<APTS_AllCost__c> AllCostlst) {
        
        //getProductAndAllCostFilterSets(lineItemList);
        
        setProductCostDetailsMap(lineItemList, AllCostlst);
        Set<id> SetOfModifiedLineItemRecordId = populateCostOnLineItems(lineItemList);
        Set<Id> emptySet = new Set<Id>();
        if(!SetOfModifiedLineItemRecordId.isEmpty()){
            return SetOfModifiedLineItemRecordId;   
        } else {
            return emptySet;
        }
    }
    
    /**
* Method to set map of Product records available on given list of Line Item records.
**/
    public void setProductCostDetailsMap(List<Apttus_Config2__LineItem__c> lineItemList, list<APTS_AllCost__c> AllCostlst) {
        
        if(!lineItemList.isEmpty()) {
            
            for(APTS_AllCost__c allCost : AllCostlst) {
                
                if(String.isNotEmpty(allCost.APTS_Product_Name__c)) {
                    
                    if(!productAllCostDetailsMap.isEmpty() && productAllCostDetailsMap.containsKey(allCost.APTS_Product_Name__c)) {
                        
                        List<APTS_AllCost__c> allCostList = productAllCostDetailsMap.get(allCost.APTS_Product_Name__c);
                        allCostList.add(allCost);
                        
                        productAllCostDetailsMap.put(allCost.APTS_Product_Name__c, allCostList);
                        
                    } else {
                        productAllCostDetailsMap.put(allCost.APTS_Product_Name__c, new List<APTS_AllCost__c>{allCost});
                    }
                }
            }
        }
    }
    
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
}**/
    
    
    /**
* Method to get set of product ID and Different fields Set for filter in All Cost query from given list of Line Item records.

public void getProductAndAllCostFilterSets(List<Apttus_Config2__LineItem__c> lineItemList) {

if(!lineItemList.isEmpty()){

for(Apttus_Config2__LineItem__c lineItem : lineItemList) {

if(String.isNotBlank(lineItem.Apttus_Config2__ProductId__c)) {
productIdSet.add(lineItem.Apttus_Config2__ProductId__c);
}

if(lineItem.Apttus_Config2__ConfigurationId__c != null && String.isNotBlank(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c)) {
soldToIdSet.add(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c);
}

if(String.isNotBlank(lineItem.APTS_Material_Num__c)) {
materialNumberSet.add(lineItem.APTS_Material_Num__c);
}

}

}

}**/
    
    
    /**
* Method to populate cost value on Line Item record.
**/
    public set<Id> populateCostOnLineItems(List<Apttus_Config2__LineItem__c> lineItemList) {
        Set<id> SetOfModifiedLineItemRecordId = new Set<id>();
        
        if(!lineItemList.isEmpty() && !productAllCostDetailsMap.isEmpty()){
            for(Apttus_Config2__LineItem__c lineItem : lineItemList) {
                System.debug('lineItem===' +lineItem);
                if(String.isNotEmpty(lineItem.Apttus_Config2__ProductId__c) && productAllCostDetailsMap.containsKey(lineItem.Apttus_Config2__ProductId__c)) {
                    //Map<string, decimal> costOverrideMap = new Map<string, decimal>();
                    
                    DateTime dT = lineItem.Apttus_Config2__PricingDate__c;
                    Date pricingDate = date.newinstance(dT.year(), dT.month(), dT.day());
                    
                    for(APTS_AllCost__c allCostDetails : productAllCostDetailsMap.get(lineItem.Apttus_Config2__ProductId__c)) {
                        
                        System.debug('allCostDetails===='+allCostDetails);
                        
                        if(allCostDetails.APTS_Material_Number__c == lineItem.APTS_Material_Num__c
                           && allCostDetails.APTS_PriceList__c == lineItem.Apttus_Config2__PriceListId__c
                           && allCostDetails.APTS_Valid_From_Date__c <= pricingDate
                           && allCostDetails.APTS_Valid_Until_Date__c >= pricingDate
                           && allCostDetails.APTS_Invalid__c == FALSE) {
                               System.debug('Cost needs to update====' +lineItem.APTS_Material_Num__c);
                               if(lineItem.Apttus_Config2__ConfigurationId__c != null && allCostDetails.APTS_Sold_To_Account__c == lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c){
                                   //&& lineItem.Apttus_Config2__Cost__c != allCostDetails.APTS_Cost__c
                                   //costOverrideMap.put('Cost1',allCostDetails.APTS_Cost__c);
                                   
                                   lineItem.Apttus_Config2__Cost__c = allCostDetails.APTS_Cost__c;
                                   SetOfModifiedLineItemRecordId.add(lineItem.id);
                                   break;
                                   
                               }else if(allCostDetails.APTS_Sold_To_Account__c == null){
                                   //costOverrideMap.put('Cost2',allCostDetails.APTS_Cost__c);
                                   
                                   lineItem.Apttus_Config2__Cost__c = allCostDetails.APTS_Cost__c;
                                   SetOfModifiedLineItemRecordId.add(lineItem.id);
                                   break;
                               }
                           }
                    }
                    
                    System.debug('lineItem===='+lineItem);
                }
            }
        }
        return SetOfModifiedLineItemRecordId;
    }
}