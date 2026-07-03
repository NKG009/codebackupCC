public class restockOrdersAndETAController {
    
    public String quoteId { get; private set; }
    public String materialNumber { get; private set; }

    public restockOrdersAndETAController() {
        quoteId = ApexPages.currentPage().getParameters().get('id');
        materialNumber = ApexPages.currentPage().getParameters().get('MatNum');
    }
    
    @AuraEnabled(cacheable=true)
    public static InventoryResponseWrapper restockOrdersAndETA(String materialNumber) {
	
        
     InventoryCalloutMulesoft call = new InventoryCalloutMulesoft();
        string reqbody ;
        if(test.isrunningtest()) {
            reqbody ='{"WAREHOUSE":{"WAREHOUSE_Data":[{"WAREHOUSE_NAME":"STAFFORD","WAREHOUSE_LOC":"USA","LGORT":"3008","QTY":100},{"WAREHOUSE_NAME":"INTRASIT","WAREHOUSE_LOC":"TRANSIT","LGORT":"3099","QTY":50}]}}';
        }
        else{reqbody = call.callInventory(materialNumber,'ALL');}
            
 
     
        InventoryResponseWrapper rawResponse =
            (InventoryResponseWrapper) JSON.deserialize(
                reqbody,
                InventoryResponseWrapper.class
            );

        
      

        return rawResponse;
    }
    
    

}