public class productselectorvfcontroller {
    
    public Id lineId { get; set; }
    public Decimal qty { get; set; }
    public String warehouse { get; set; }
    
    public void updateQLI() {
        SBQQ__QuoteLine__c qli = [
            SELECT Id
            FROM SBQQ__QuoteLine__c
            WHERE Id = :lineId
            LIMIT 1
        ];
        
        qli.Available_Qty__c = qty;
        qli.Warehouse__c = warehouse;
        
        update qli;
    }

	@AuraEnabled
    public static void updateQuoteLineWarehouse(
        Id quoteLineId,
        String warehouseName,
        Decimal qty
    ) {
        SBQQ__QuoteLine__c ql = [
            SELECT Id, Warehouse__c, Available_Qty__c
            FROM SBQQ__QuoteLine__c
            WHERE Id ='a7NVG000000AvQ12AK' //:quoteLineId
        ];

        ql.Warehouse__c = warehouseName;
        ql.Available_Qty__c = qty;

        update ql;
        
    }

}