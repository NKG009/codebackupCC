public class QBOQueryResponse {
    public ResponseQuickBooks QueryResponse;
    
    public class ResponseQuickBooks {
        public List<QuickBooksEntityItem> Item;
        public List<QuickBooksEntity> Bill;
        public List<QuickBooksEntity> VendorCredit;
        public List<QuickBooksEntity> SalesReceipt;
        public List<QuickBooksEntity> RefundReceipt;
        public List<QuickbooksInvoiceWrapper.QBOInvoice> Invoice;
        //public List<QuickbooksEstimateWrapper.QBOEstimate> Estimate;
        public List<QuickBooksEntity> CreditMemo;
        public List<QuickbooksPaymentWrapper.QBOPayment> Payment;
        public List<QuickbooksCustomerWrapper.Customer> Customer;
        //public List<VendorService.QuickBooksVendor> Vendor;
        //public List<QBTaxCodeWrapper> TaxCode;
        //public List<QBTaxRateWrapper> TaxRate;
        public Decimal TotalCount;
        public Decimal maxResults;
    }
    
    public class QuickBooksEntity {
        public String Id;
        public String SyncToken;
        public String DocNumber;
        public String TxnDate;
        public String DueDate;
        public String TotalAmt;
        public String Balance;
        public String RemainingCredit;
        public String UnappliedAmt;
        public String PrivateNote;
        public String PaymentRefNum;
        public List<QuickBooksLinkedTxn> LinkedTxn;
    }
    
    public class QuickBooksEntityItem {
        public String Id;
        public String Name;
        public String Sku; 
        public String Description;
        public Boolean Active;
        public Boolean Taxable;
        public Decimal UnitPrice;
        public String Type;
        public QBOInnerEntityWrapper IncomeAccountRef;
        public String domain;
        public Boolean sparse;
        public String SyncToken;
    }
    
    public class QuickBooksLinkedTxn {
        public String TxnId;
        public String TxnType;
    }
}