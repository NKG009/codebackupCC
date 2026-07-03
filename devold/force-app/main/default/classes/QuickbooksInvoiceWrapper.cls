public class QuickbooksInvoiceWrapper {
    
    public static final String TAX_NOT_APPLICABLE = 'NotApplicable';
    public list<BatchItemRequest> BatchItemRequest;
    
    public class QBOInvoice {
        public String Id;
        public String SyncToken;
        public String DocNumber; 
        public String TxnDate;
        public String DueDate;
        public decimal TotalAmt;
        public List<CustomFieldwrapper> CustomField;
        public QuickbooksBillAddr BillAddr;
        public List<QBOInvoiceLinesWrapper> Line;
        public QBOInnerEntityWrapper CustomerRef;
        public QBOInnerEntityWrapper SalesTermRef;

        public QBOInvoice(Order orderrec) {
            if(orderrec != null) {
                //this.Id = orderrec.QBO_Invoice__r.QBO_Invoice_Id__c;
                //this.SyncToken = orderrec.QBO_Invoice__r.QBO_SyncToken__c;
                if(orderrec.Eterneva_Order_Products__r.size()>1){
                this.TxnDate = orderrec.Opportunity.CloseDate != null ? DateTime.newInstance(orderrec.Opportunity.CloseDate, Time.newInstance(0, 0, 0, 0)).format('yyyy-MM-dd') : null;
                this.DueDate = orderrec.Opportunity.CloseDate != null ? DateTime.newInstance(orderrec.Opportunity.CloseDate, Time.newInstance(0, 0, 0, 0)).format('yyyy-MM-dd') : null;
				  }
                else{
                this.TxnDate = orderrec.EffectiveDate != null ? DateTime.newInstance(orderrec.EffectiveDate, Time.newInstance(0, 0, 0, 0)).format('yyyy-MM-dd') : null;
                this.DueDate = orderrec.EffectiveDate != null ? DateTime.newInstance(orderrec.EffectiveDate, Time.newInstance(0, 0, 0, 0)).format('yyyy-MM-dd') : null;
                }
                //this.DocNumber = invoiceRec.Doc_Number__c;
                //this.Description = invoiceRec.Description__c;
                this.CustomField=new List<CustomFieldwrapper>();
                this.CustomField.add(new CustomFieldwrapper(orderrec.OrderNumber));
                if(orderrec.BillingAddress!= null) {
                    this.BillAddr = new QuickbooksBillAddr();
                   // List<String> addressList = orderrec.QBO_Billing_Address__c.split('\n');
                 	this.BillAddr.Line1 =orderrec.BillingStreet ;
                    this.BillAddr.Line2 = orderrec.BillingState;
                    this.BillAddr.Line3 = orderrec.BillingCity ;
                    this.BillAddr.Line4 = orderrec.BillingCountry;  
                     this.BillAddr.Line5= orderrec.BillingPostalCode;
                }
                decimal totalsalestax=0;
                this.Line = new List<QBOInvoiceLinesWrapper>();
                for(ET_Order_Product__c OrdLine : orderrec.Eterneva_Order_Products__r) {
                    
                    totalsalestax=totalsalestax+OrdLine.Adjusted_Total_Tax__c;
                         this.Line.add(new QBOInvoiceLinesWrapper(OrdLine,orderrec.Eterneva_Order_Products__r.size()));
                         
                }
                ET_Order_Product__c ec1 = new ET_Order_Product__c(Adjusted_Total_Price__c=orderrec.Opportunity.Total_Discount_Amount__c);
              //  this.Line.add(new QBOInvoiceLinesWrapper(ec1,null));
                              
                  if(orderrec.Eterneva_Order_Products__r.size()>1){
                QBOInvoiceLinesWrapper inr = new QBOInvoiceLinesWrapper();
                inr.Description='Total Discount';
                inr.Amount=-orderrec.Opportunity.Total_Discount_Amount__c;
                inr.DetailType='SalesItemLineDetail';
                 inr.SalesItemLineDetail= new QuickBooksInvoiceItemSalesItemLineDetailWrappper(null,Label.QBO_Discount_Product_ID,null);
                 this.Line.add(inr);
                
                QBOInvoiceLinesWrapper inr1 = new QBOInvoiceLinesWrapper();
                inr1.Description='Total Sales Tax';
                inr1.Amount=totalsalestax;
                inr1.DetailType='SalesItemLineDetail';
                inr1.SalesItemLineDetail= new QuickBooksInvoiceItemSalesItemLineDetailWrappper(null,Label.QBO_Sales_Tax_Product_ID,null);
                 this.Line.add(inr1);
                }
                              
                this.SalesTermRef = new QBOInnerEntityWrapper(Label.QBO_Terms_Id, null); 

                this.CustomerRef = new QBOInnerEntityWrapper(orderrec.BillToContact.QBO_Customer_Id__c, orderrec.BillToContact.Name);
            }
        }
    }
    
    public class QBOInvoiceLinesWrapper {
        QBOInvoiceLinesWrapper(){}
        public String Id;
        public String Description;
        public Decimal Amount;
        public String DetailType;
        public QuickBooksInvoiceItemSalesItemLineDetailWrappper SalesItemLineDetail;

        public QBOInvoiceLinesWrapper(ET_Order_Product__c OrdLine,integer size) {
            this.Description = OrdLine.Product__r.Name+' '+OrdLine.Name;
            system.debug('OrdLine.Adjusted_Total_Price__c'+OrdLine.Adjusted_Total_Price__c);
             system.debug('size::'+size);
             system.debug('OrdLine.RecordType.developername:'+OrdLine.RecordType.developername);
            if(OrdLine.Adjusted_Total_Price__c==null || OrdLine.Adjusted_Total_Price__c==0 || OrdLine.Adjusted_Total_Price__c==100 ){
                 if(size>1 && OrdLine.RecordType.developername =='Welcome_Kit'){
                     system.debug('here 2nd if');
                    this.Amount = -OrdLine.List_Price_MSRP__c;
                }
                else{
                     system.debug('here 2ndelse');
                    this.Amount = OrdLine.List_Price_MSRP__c; }
            }
            else{
                this.Amount = OrdLine.Adjusted_Total_Price__c;
            }
            
            system.debug('Amount'+this.Amount);
            this.DetailType = 'SalesItemLineDetail';   
            this.SalesItemLineDetail = new QuickBooksInvoiceItemSalesItemLineDetailWrappper(OrdLine,null,size);              
        }
    }
    public class QuickBooksInvoiceItemSalesItemLineDetailWrappper {
        // QuickBooksInvoiceItemSalesItemLineDetailWrappper(){}
        public Decimal UnitPrice;
        public Decimal Qty;
        public QBOInnerEntityWrapper ItemRef;
        public QBOInnerEntityWrapper TaxCodeRef;
        public QBOInnerEntityWrapper ItemAccountRef;
        
       public QuickBooksInvoiceItemSalesItemLineDetailWrappper(ET_Order_Product__c OrdLine,string itemid,integer size) {
            this.Qty = 1;
           if(itemid==null){
            if(OrdLine.Adjusted_Total_Price__c==null || OrdLine.Adjusted_Total_Price__c==0 || OrdLine.Adjusted_Total_Price__c==100){
                if(size>1 && OrdLine.RecordType.developername =='Welcome_Kit'){
                    
                    this.UnitPrice = -OrdLine.List_Price_MSRP__c;
                }
                else{
                    this.UnitPrice = OrdLine.List_Price_MSRP__c; }
            }
               else{ this.UnitPrice =OrdLine.Adjusted_Total_Price__c;}}
           if(itemid==null){
            this.ItemRef = new QBOInnerEntityWrapper(OrdLine.Product__r.QBO_Item_Id__c, null);
           }
           else{
               this.ItemRef = new QBOInnerEntityWrapper(itemid, null);
           }
           // if(invLine.Taxable__c) {
             //   this.TaxCodeRef = new QBOInnerEntityWrapper(QuickBooksUtilityClass.QBappInfo.Tax_Code_Ref_Id__c, null);
          //  }
        }
    }
    public class CustomFieldwrapper {
         public integer DefinitionId;
         public String Name;
          public String Type;
          public String  StringValue;
           
        public CustomFieldwrapper(string ordnum){
            this.DefinitionId=1;
            this.Name='P.O. Number';
            this.Type='StringType';
            this.StringValue=ordnum;
        }
        
    }
    public class BatchItemRequest {
        public QBOInvoice Invoice;
        public String operation;
        public String bId;
    }
}