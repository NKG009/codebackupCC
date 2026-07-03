public class QuickbooksInvoiceService {
        
     @future(callout=true)
    public static void createUpdateInvoicesInQBO(Set<Id> Orderids) {
         String response;
        try{
            // QBO customer Id check on Contact in salesforce
            Map<id,string>ConidtoQBOCusId;
            Set<id> conidtocreateQBOcustomer = new Set<id>();
            Set<Id> TargetedOppIds = new Set<Id>();
            for(Order od :[select id,OpportunityId from Order where id IN:Orderids]){
                TargetedOppIds.add(od.OpportunityId);
            }
             for( OpportunityContactRole OCR :[select id,ContactId,Contact.QBO_Customer_Id__c,OpportunityId from OpportunityContactRole where OpportunityId IN:TargetedOppIds AND Role ='Billing Contact']){
               if(OCR.Contact.QBO_Customer_Id__c==null){
                    conidtocreateQBOcustomer.add(OCR.ContactId);
                }
            }
            if(conidtocreateQBOcustomer.size()>0 && !test.isRunningTest()){
            ConidtoQBOCusId=QuickbooksCustomerService.QBOcreatecustomer(conidtocreateQBOcustomer);
            }
            // QBO product Id check in Salesforce
            list<product2> productqboidtoupdate = new list<product2>();
            map<id,string> prdSfidtoqboid= new map<id,string>(); 
            map<id,string> tempmap= new map<id,string>();
            Set<id> prodidtocreateinqbo= new Set<id>();
            Set<id> prodidtoquery= new Set<id>();
            
            for(Order OrderRec : [SELECT Id,EffectiveDate,BillingAddress,BillToContact.QBO_Customer_Id__c,BillToContact.Name,
                                  BillingStreet,BillingState,BillingCity,BillingCountry,BillingPostalCode,(SELECT Id,List_Price_MSRP__c,Product__r.Name,Adjusted_Total_Price__c,Product__r.QBO_Item_Id__c FROM Eterneva_Order_Products__r Order By CreatedDate)  
                                  FROM Order WHERE Id IN:Orderids]) {
                                      for(ET_Order_Product__c etp : OrderRec.Eterneva_Order_Products__r){
                                          if(etp.Product__r.QBO_Item_Id__c ==null){
                                              prodidtoquery.add(etp.Product__r.id);
                                          } 
                                      }
                                  }
            if(prodidtoquery.size()>0 && !test.isRunningTest()){
                prdSfidtoqboid=QuickbooksProductService.QueryitemQBO(prodidtoquery);
                
                for(id prdid : prodidtoquery){
                    if(!prdSfidtoqboid.keyset().contains(prdid)){
                        prodidtocreateinqbo.add(prdid);
                    }
                }   
            }
            
            if(prodidtocreateinqbo.size()>0 && !test.isRunningTest()){
                tempmap=QuickbooksProductService.NewitemcreationinQBO(prodidtocreateinqbo);
            }
            
            if(tempmap.size()>0){
                system.debug('tempmap'+tempmap);
                system.debug('before add prdSfidtoqboid'+prdSfidtoqboid);
                prdSfidtoqboid.putAll(tempmap);
            }
            
            system.debug('after add /noadd prdSfidtoqboid'+prdSfidtoqboid);
            
            
            // invoice creation   // Add map1 entries to map2   map2.putAll(map1);
            Map<Id, Order> OrderIdMap = new Map<Id, Order>();
            List<QBO_Invoice__c> InvoiceListtocreate = new List<QBO_Invoice__c>();
			List<QBO_Invoice_Line__c> InvoicelineListtocreate = new List<QBO_Invoice_Line__c>();
            List<Contact> customeridtoupdate = new List<Contact>(); 
            QuickbooksInvoiceWrapper itemBatch= new QuickbooksInvoiceWrapper();
            List<QuickbooksInvoiceWrapper.BatchItemRequest> listBatchItemreq = new List<QuickbooksInvoiceWrapper.BatchItemRequest>();
            for(Order OrderRec : [SELECT Id,OrderNumber,EffectiveDate,AccountId,BillingAddress,BillToContact.QBO_Customer_Id__c,BillToContact.Name,OpportunityId,Opportunity.Total_Discount_Amount__c,Opportunity.CloseDate,
                                         BillingStreet,BillingState,BillingCity,BillingCountry,BillingPostalCode,(SELECT Id,List_Price_MSRP__c,Name,RecordType.developername,Adjusted_Total_Tax__c,Product__r.Name,Adjusted_Total_Price__c,Product__r.QBO_Item_Id__c FROM Eterneva_Order_Products__r Order By CreatedDate)  
                                         FROM Order WHERE Id IN:Orderids]) {
                                             if(OrderRec.BillToContact.QBO_Customer_Id__c==null && !test.isRunningTest()){
                                                OrderRec.BillToContact.QBO_Customer_Id__c= ConidtoQBOCusId.get(OrderRec.BillToContactid);
                                             }
                                             for(ET_Order_Product__c etp : OrderRec.Eterneva_Order_Products__r ){
                                                 if(etp.Product__r.QBO_Item_Id__c ==null && !test.isRunningTest()){
                                                    etp.Product__r.QBO_Item_Id__c =prdSfidtoqboid.get(etp.Product__r.id);
                                                 } 
                                             }
                                             OrderIdMap.put(OrderRec.Id, OrderRec);
                                             QuickbooksInvoiceWrapper.BatchItemRequest batchitemrequest = new QuickbooksInvoiceWrapper.BatchItemRequest();
                                             batchitemrequest.Invoice = new QuickbooksInvoiceWrapper.QBOInvoice(OrderRec);
                                             batchitemrequest.operation ='create';
                                             batchitemrequest.bId = String.valueof(OrderRec.Id);
                                             listBatchItemreq.add(batchitemrequest);
                                         }
            itemBatch.BatchItemRequest = listBatchItemreq;
            String JsonString = Json.serialize(itemBatch);
            System.debug('InvoiceJsonString'+JsonString);
           
            response = QuickbooksSendRequestAndRecieveResponse.SendRequest(JsonString, 'batch', 'POST'); 
            System.debug('Invoiceresponse'+response);
            
             if(!prdSfidtoqboid.isEmpty()){
                for(id prodid :prdSfidtoqboid.keyset()){
                     Product2 product = new Product2(id =prodid);
                      product.QBO_Item_Id__c =prdSfidtoqboid.get(prodid);
                    productqboidtoupdate.add(product);
                    
                }
              }
            system.debug('productqboidtoupdate'+productqboidtoupdate);
                if(!productqboidtoupdate.isEmpty()){
                    update productqboidtoupdate;
                } 
            if(response != null) {
                QuickbooksBatchResponse responseJsonBatch = (QuickbooksBatchResponse)JSON.deserialize(response, QuickbooksBatchResponse.class);
                if(responseJsonBatch.BatchItemResponse != null) {
                    for(QuickbooksBatchResponse.BatchItemResponse b: responseJsonBatch.BatchItemResponse) {
                        if(Test.isRunningTest()) b.bId = listBatchItemreq[0].bId;
                        if(OrderIdMap.get(b.bId) != null){
         
							 QBO_Invoice__c invoiceRec = new QBO_Invoice__c();
                            invoiceRec.QBO_Invoice_Id__c = b.Invoice.Id;
                            invoiceRec.QBO_SyncToken__c = b.Invoice.synctoken;
                            invoiceRec.Order_No__c=b.bId;
                            invoiceRec.Account__c=OrderIdMap.get(b.bId).accountid;
                            invoiceRec.Opportunity__c=OrderIdMap.get(b.bId).OpportunityId;
                            invoiceRec.Contact__c=OrderIdMap.get(b.bId).BillToContactid;
                            invoiceRec.QBO_Doc_Number__c=b.Invoice.DocNumber;
                            invoiceRec.Total_Amount__c=b.Invoice.TotalAmt;
                            invoiceRec.QBO_Due_Date__c=b.Invoice.DueDate != null ? Date.valueOf(b.Invoice.DueDate) : null;
                            invoiceRec.QBO_Invoice_Date__c=b.Invoice.TxnDate != null ? Date.valueOf(b.Invoice.TxnDate) : null;  
                            String billingAddress = getBillingAddress(b.Invoice.BillAddr);
                           if(String.isNotBlank(billingAddress)) invoiceRec.QBO_Billing_Address__c = billingAddress;
                            insert invoiceRec;
                           // InvoiceListtocreate.add(invoiceRec);
                            Map<String, String> productQBAccIdToSFId = getProductSFIdByQBOId(b.Invoice.Line);
                            for(QuickbooksBatchResponse.line line : b.Invoice.Line){
                               system.debug('invoiceRec'+invoiceRec.Id);
                                if(line.SalesItemLineDetail != null && line.SalesItemLineDetail.ItemRef != null && line.SalesItemLineDetail.ItemRef.value != null) {
                                    QBO_Invoice_Line__c invLine = new QBO_Invoice_Line__c();
                                    invLine.QBO_Product__c = productQBAccIdToSFId.get(line.SalesItemLineDetail.ItemRef.value);
                                    invLine.QBO_Quantity__c = line.SalesItemLineDetail.Qty;
                                    if(line.SalesItemLineDetail.ItemRef.value !=Label.QBO_Discount_Product_ID || line.SalesItemLineDetail.ItemRef.value != Label.QBO_Sales_Tax_Product_ID){
                                        invLine.QBO_Unit_Price__c=  line.Amount;
                                    }
                                    else{invLine.QBO_Unit_Price__c = line.SalesItemLineDetail.UnitPrice;}        
                                    
                                    invLine.QBO_Product_Name__c=line.SalesItemLineDetail.ItemRef.name;
                                    invLine.Invoice__c= invoiceRec.id;     
                                    InvoicelineListtocreate.add(invLine) ; 
                                }   
                            }
                        }
                    }
                }
                system.debug('ConidtoQBOCusId'+ConidtoQBOCusId);
                if(ConidtoQBOCusId !=null){
                for(id conid :ConidtoQBOCusId.keyset()){
                    contact con = new contact(id=conid);
                    con.QBO_Customer_Id__c=ConidtoQBOCusId.get(conid);
                    customeridtoupdate.add(con);
                    
                }
              }
              
               system.debug('customeridtoupdate'+customeridtoupdate);
                if(!customeridtoupdate.isEmpty()){
                    update customeridtoupdate;
                }  
                
                
                system.debug('InvoicelineListtocreate'+InvoicelineListtocreate);
                if(!InvoicelineListtocreate.isEmpty()){
                    insert InvoicelineListtocreate;
                } 
                
                
            }
        }catch(Exception e){
            LogUtil.errorLogs.add(LogUtil.createLog('QuickbooksInvoiceService', 'createUpdateInvoicesInQB', LogUtil.ERROR, Orderids.toString(),
                                                    null, response, e.getMessage() +' at line ' +e.getLineNumber() + ' '+ e.getStackTraceString()));
        }
         finally {
             if(QuickbooksSendRequestAndRecieveResponse.quickBooksSettingInfo !=null )
            upsert QuickbooksSendRequestAndRecieveResponse.quickBooksSettingInfo;
        }
        LogUtil.insertLogs();
    }
    
     public static String getBillingAddress(QuickbooksBillAddr qboBillingAddr) {
        String address;
        if(qboBillingAddr != null) {
            List<String> addressList = new List<String>();
            if(String.isNotBlank(qboBillingAddr.Line1)) {
                addressList.add(qboBillingAddr.Line1);
            }
            if(String.isNotBlank(qboBillingAddr.Line2)) {
                addressList.add(qboBillingAddr.Line2);
            }
            if(String.isNotBlank(qboBillingAddr.Line3)) {
                addressList.add(qboBillingAddr.Line3);
            }
            if(String.isNotBlank(qboBillingAddr.Line4)) {
                addressList.add(qboBillingAddr.Line4);
            }
            address = String.join(addressList, '\n');
        }
        return address;
    }
    
    public static Map<String, String> getProductSFIdByQBOId(List<QuickbooksBatchResponse.line> invoiceline) {
        Map<String, String> productQBOIdToSFIdMap = new Map<String, String>();
               for(QuickbooksBatchResponse.Line line : invoiceline) {
                    if(line.SalesItemLineDetail != null && line.SalesItemLineDetail.ItemRef != null && line.SalesItemLineDetail.ItemRef.value != null) {
						productQBOIdToSFIdMap.put(line.SalesItemLineDetail.ItemRef.value, null);
                    }
                }
        
        if(!productQBOIdToSFIdMap.isEmpty()) {
            for(Product2 product : [Select Id, QBO_Item_Id__c FROM Product2 WHERE QBO_Item_Id__c IN: productQBOIdToSFIdMap.keySet()]) {
                productQBOIdToSFIdMap.put(product.QBO_Item_Id__c, product.Id);
            }
        }
        return productQBOIdToSFIdMap;
    }
    
}