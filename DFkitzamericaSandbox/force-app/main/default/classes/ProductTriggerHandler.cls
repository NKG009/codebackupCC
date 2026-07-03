/****************************
* Name : ProductTriggerHandler
* Description : Class to handler trigger events on product object record.
****************************/

public class ProductTriggerHandler {
        
    /**
* Method to handle actions that need to be performed on after inserting record.
**/
 public static void onAfterInsert(List<Product2> newproductList, Map<Id, Product2> oldMap) {
        Producthelper helper = new Producthelper();
       // helper.onAfterInsert(newproductList,oldMap);
     
    }
}