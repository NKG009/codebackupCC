public class QuickbooksBatchResponse {

    public list<BatchItemResponse> BatchItemResponse;
    
    //public QueryResponse QueryResponse;
    public class Line {
        public String SyncToken;
        public Boolean sparse;
        public String Id;
        public decimal Amount;
        public String Description;
        public QuickBooksInvoiceItemSalesItemLineDetailWrappper SalesItemLineDetail;
    }
    public class Item {
        public String SyncToken;
        public Boolean sparse;
        public String Id;
    }
     public class QuickBooksInvoiceItemSalesItemLineDetailWrappper {
        public integer UnitPrice;
        public Decimal Qty;
        public QBOInnerEntityWrapper ItemRef;
        public QBOInnerEntityWrapper TaxCodeRef;
        public QBOInnerEntityWrapper ItemAccountRef;
        
    }
    public class Invoice {
        public String SyncToken;
        public Boolean sparse;
        public String Id;
        public String DocNumber;
        public String TxnDate;
        public String DueDate;
        public decimal TotalAmt;
        public List<Line> Line;
        public QuickbooksBillAddr BillAddr; 
    }
    public class Payment {
        public String SyncToken;
        public Boolean sparse;
        public String Id;
    }
    public class BatchItemResponse{
        public Item Item;
        public Invoice Invoice;
        public Invoice Estimate;
        public Payment Payment;
        public String bId;
    }
	/**
    public class QueryResponse{
        public list<Item> Item;
        public list<Invoice> Invoice;
        public Integer maxResults;
        public Integer startPosition;
    }
    **/
}