public class QuickbooksPaymentWrapper {
    
    public static final String TAX_NOT_APPLICABLE = 'NotApplicable';
    public list<BatchItemRequest> BatchItemRequest;
    
    public class QBOPayment {
        public String Id;
        public String SyncToken;
        public Decimal TotalAmt;
        public QBOInnerEntityWrapper CustomerRef;
        public List<QuickBooksLineWrapper> Line;

       /* public QBOPayment(Payment__c paymentRec) {
            if(paymentRec != null) {
                this.Id = paymentRec.QBO_Payment_Id__c;
                this.SyncToken = paymentRec.QBO_SyncToken__c;
                this.TotalAmt = paymentRec.Amount__c;
                /**if(paymentRec.Customer__c != null) {
                	this.CustomerRef = new QBOInnerEntityWrapper(paymentRec.Customer__r.QBO_Customer_Id__c, paymentRec.Customer__r.Name);
                }**/
              /*  this.Line = new List<QuickBooksLineWrapper>();
                if(paymentRec.Invoice__c != null && paymentRec.Invoice__r.QBO_Invoice_Id__c != null) {
            		this.Line.add(new QuickBooksLineWrapper(paymentRec.Amount__c, paymentRec.Invoice__r.QBO_Invoice_Id__c, 'Invoice'));
                    if(this.CustomerRef == null && paymentRec.Invoice__r.Billing_Account__c != null) {
                        this.CustomerRef = new QBOInnerEntityWrapper(paymentRec.Invoice__r.Billing_Account__r.QBO_Customer_Id__c, paymentRec.Invoice__r.Billing_Account__r.Name);
                    }
                }
            }
        }*/
    }
    
    public class QuickBooksLineWrapper{
        public Decimal Amount;
        public List<QuickBooksLinkedTxnWrapper> LinkedTxn; 
        
       /* public QuickBooksLineWrapper(Decimal amount, String txnId, String txnType) {
            this.Amount = amount;  
            
            this.LinkedTxn = new List<QuickBooksLinkedTxnWrapper>();
            this.LinkedTxn.add(new QuickBooksLinkedTxnWrapper(txnId, txnType));          
        }*/
     }
    
    public class QuickBooksLinkedTxnWrapper{
        public String TxnId;
        public String TxnType;

       /* public QuickBooksLinkedTxnWrapper(String txnId, String txnType) {
            this.TxnId = txnId;
            this.TxnType = txnType; 
        }*/
     }
    
    public class BatchItemRequest {
        public QBOPayment Payment;
        public String operation;
        public String bId;
    }
}