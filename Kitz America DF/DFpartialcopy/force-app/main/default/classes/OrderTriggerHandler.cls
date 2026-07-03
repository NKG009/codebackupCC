/****************************
* Name : OrderTriggerHandler
* Description : Class to handler trigger events on Order object record.
****************************/

public class OrderTriggerHandler {
    
    /**
* Method to handle actions that need to be performed on before inserting record.
**/
    public static void onBeforeInsert(List<Apttus_Config2__Order__c> newOrderList) {
        OrderTriggerHelper helper = new OrderTriggerHelper();
        
        helper.setProposalDetailsMap(newOrderList);
        helper.populateValuesOnOrder(newOrderList);
    }
    
    public static void onAfterInsert(List<Apttus_Config2__Order__c> newOrderList) {
        set<string> oids = new set<string>();
        for(Apttus_Config2__Order__c o : newOrderList){
            oids.add(o.id);
        }
        
        if(oids.size() > 0){
            Saporder.sendorderInfo(oids);
        }
    }
}