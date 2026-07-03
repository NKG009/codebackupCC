public class InventoryResponseWrapper {

    @AuraEnabled public ETAWrapper ETA;
    @AuraEnabled public RestockWrapper RESTOCK;

    public class ETAWrapper {
        @AuraEnabled public List<ETAData> ETA_Data;
       @AuraEnabled  public String Message_Status;
        @AuraEnabled public String Message;
    }

    public class ETAData {
        @AuraEnabled public Decimal REC_REQD_QTY_ALT_UOM;
        @AuraEnabled public Datetime AVAIL_DATE;
    }

    public class RestockWrapper {
        @AuraEnabled public List<RestockData> RESTOCK_Data;
       @AuraEnabled  public String Message_Status;
        @AuraEnabled public String Message;
    }

    public class RestockData {
        @AuraEnabled public String PO_NUMBER;
        @AuraEnabled public String LINE_NUMBER;
        @AuraEnabled public Decimal REC_REQD_QTY_ALT_UOM;
        @AuraEnabled public Datetime AVAIL_DATE;
    }
}