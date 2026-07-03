public class OrderTriggerHandler {
    public static void setOrderDefaults(List<Order> orderRecords) {
        if (orderRecords == null || orderRecords.isEmpty()) {
            return;
        }
        
        for (Order orderRecord : orderRecords) {
            if (String.isBlank(orderRecord.vlocity_cmt__FulfilmentStatus__c)) {
            	orderRecord.vlocity_cmt__FulfilmentStatus__c = System_Values__c.getInstance(ApexConstants.SYSTEM_VALUES_ORDER_FULFILLMENT_STATUS_DEFAULT).Value__c;
            }
        }
    }
}