/****************************
* Name : LineItemTriggerHandler
* Description : Class to handler trigger events on Line Item object record.
****************************/

public class LineItemTriggerHandler {
    
    /**
* Method to handle actions that need to be performed on before inserting record.
**/
    public static void onBeforeInsert(List<Apttus_Config2__LineItem__c> newLineItemList) {
        LineItemTriggerHelper helper = new LineItemTriggerHelper();
        
        helper.setConfigurationDetailsMap(newLineItemList);
        helper.setProductDetailsMap(newLineItemList);
        helper.populateValuesOnLineItem(newLineItemList);
    }    
    
       /**
* Method to handle actions that need to be performed on before updating record.
**/
    public static void onBeforeUpdate(List<Apttus_Config2__LineItem__c> newLineItemList, Map<Id, Apttus_Config2__LineItem__c> oldLineItemMap) {
        LineItemTriggerHelper helper = new LineItemTriggerHelper();        
        helper.setLineItemsValuesOnUpdate(newLineItemList,oldLineItemMap);      
    }    
}