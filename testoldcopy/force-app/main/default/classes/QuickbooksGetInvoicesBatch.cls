global without sharing class QuickbooksGetInvoicesBatch implements Database.Batchable<Integer>, Database.AllowsCallouts, Schedulable,Database.Stateful {
   
    public Integer APICounter = 0;
    public Boolean recordFound = false;
    public DateTime currentDateTime = system.now();
    
    global QuickbooksGetInvoicesBatch(){}
    global QuickbooksGetInvoicesBatch(Integer APICounter) {
        this.APICounter = APICounter;
    }
    
    global Iterable<Integer> start(Database.BatchableContext bc) {
        return new List<Integer>{APICounter};
    }
    global void execute(Database.batchableContext bc, List<Integer> apiCountList) {
       /* system.debug('here execute');
        fetchInvoices();*/
    }
    
    global void finish(Database.batchableContext bc) {
        /* Integer APICounterend=APICounter+1;
        if(recordFound && !test.isRunningTest()) {
            Database.executeBatch(new QuickbooksGetInvoicesBatch(APICounterend));
        } else {
            QBO_Quickbooks_App_Info__c config = QBO_Quickbooks_App_Info__c.getOrgDefaults();
            //config.Last_Invoice_Fetched_Date__c = currentDateTime;
            //update config;
        }*/
    }
    
  /*  public void fetchInvoices() {
        String query = 'SELECT * FROM Invoice ';
        try {
            DateTime txnDate;// = Quickbooks_App_Info__c.getOrgDefaults().Last_Invoice_Fetched_Date__c;
            query += txnDate != null ? ' WHERE Metadata.LastUpdatedTime > \'' + txnDate.format('yyyy-MM-dd') + '\'' : '';
            system.debug('APICounter in fetchInvoices::'+APICounter);
            if(APICounter != null && APICounter != 0) {
                 system.debug('APICounter insideif::'+APICounter);
                query += ' STARTPOSITION '+ ((APICounter * 100) + 1);
            }
            query = EncodingUtil.urlEncode(query, 'UTF-8').replaceAll('\\+','%20');
            HttpResponse res = QuickbooksSendRequestAndRecieveResponse.getRequest('query?query='+query);
            if(res.getStatusCode() == 200){
                system.debug('== res.getBody() ==' + res.getBody());
                QBOQueryResponse qboResult = (QBOQueryResponse) System.JSON.deserialize(res.getBody(), QBOQueryResponse.class);
                if(qboResult.QueryResponse != null && qboResult.QueryResponse.Invoice != null && !qboResult.QueryResponse.Invoice.isEmpty()) {
                    List<QuickbooksInvoiceWrapper.QBOInvoice> invoiceList = qboResult.QueryResponse.Invoice;
                    createInvoices(invoiceList);
                    recordFound = true;
                }
            }
        } catch(Exception e) {
            LogUtil.errorLogs.add(LogUtil.createLog('QuickbooksGetInvoicesBatch', 'fetchInvoices', LogUtil.ERROR, query, 
                                                    null, e.getMessage() +' at line ' +e.getLineNumber() + ' '+ e.getStackTraceString()));
        } finally {
            upsert QuickbooksSendRequestAndRecieveResponse.quickBooksSettingInfo;
        }
        LogUtil.insertLogs();
    }
    
   
    
    public static Map<String, String> createInvoices(List<QuickbooksInvoiceWrapper.QBOInvoice> invoiceList) {
        QBO_ConstantUtilityClass.forceStopTrigger = true;
        Map<String, String> customerQBAccIdToSFId = getCustomerSFIdByQBOId(invoiceList);	//creates new customer if not found
        Map<String, String> productQBAccIdToSFId = getProductSFIdByQBOId(invoiceList);	//creates new product if not found
        Map<String, String> Contactidtooppid = getOppId(customerQBAccIdToSFId);
         Map<String, String> ContactidtoAccid = getAccId(customerQBAccIdToSFId);
        Map<String, QBO_Invoice__c> qboInvoiceIdToSFRecMap = getExistingInvoices(invoiceList);
        system.debug('qboInvoiceIdToSFRecMap'+qboInvoiceIdToSFRecMap);
        
        List<QBO_Invoice__c> invoiceListToUpsert = new List<QBO_Invoice__c>();
        for(QuickbooksInvoiceWrapper.QBOInvoice qboInvoice : invoiceList) {
            QBO_Invoice__c invoiceRec = new QBO_Invoice__c(
                QBO_Invoice_Id__c = qboInvoice.Id,
                QBO_SyncToken__c = qboInvoice.SyncToken,
                QBO_Doc_Number__c = qboInvoice.DocNumber,
                QBO_Invoice_Date__c = qboInvoice.TxnDate != null ? Date.valueOf(qboInvoice.TxnDate) : null,
                QBO_Due_Date__c = qboInvoice.DueDate != null ? Date.valueOf(qboInvoice.DueDate) : null,
                Total_Amount__c=qboInvoice.TotalAmt
            );
           
            String billingAddress = getBillingAddress(qboInvoice.BillAddr);
            if(String.isNotBlank(billingAddress)) invoiceRec.QBO_Billing_Address__c = billingAddress;
            if(qboInvoiceIdToSFRecMap.containsKey(qboInvoice.Id) && qboInvoiceIdToSFRecMap.get(qboInvoice.Id) != null ) {
                invoiceRec.Id = qboInvoiceIdToSFRecMap.get(qboInvoice.Id).Id;
            }
            if(qboInvoice.CustomerRef != null && qboInvoice.CustomerRef.value != null) {
                invoiceRec.Contact__c = customerQBAccIdToSFId.get(qboInvoice.CustomerRef.value);
                invoiceRec.Account__c=ContactidtoAccid.get(invoiceRec.Contact__c);
                invoiceRec.Opportunity__c=Contactidtooppid.get(invoiceRec.Contact__c);
            }
            
            invoiceListToUpsert.add(invoiceRec);
            
        }
        system.debug(' == invoiceListToUpsert == ' + invoiceListToUpsert.size());
        system.debug(' == invoiceListToUpsert == ' + invoiceListToUpsert);
        Map<String, String> newInvoiceQBOIdToSFIdMap = new Map<String, String>();
        if(!invoiceListToUpsert.isEmpty()) {
            upsert invoiceListToUpsert;
            
            for(QBO_Invoice__c invoiceRec : invoiceListToUpsert) {
                if(!qboInvoiceIdToSFRecMap.containsKey(invoiceRec.QBO_Invoice_Id__c) || qboInvoiceIdToSFRecMap.get(invoiceRec.QBO_Invoice_Id__c) == null) {
                    newInvoiceQBOIdToSFIdMap.put(invoiceRec.QBO_Invoice_Id__c, invoiceRec.Id);
                }
            }
            List<QBO_Invoice_Line__c> invoiceLinesToUpsert = new List<QBO_Invoice_Line__c>();
            List<QBO_Invoice_Line__c> invoiceLinesToDelete = new List<QBO_Invoice_Line__c>();
            for(QuickbooksInvoiceWrapper.QBOInvoice qboInvoice : invoiceList) {
                Integer lineIndex = -1;
                Integer totalLines = 0;
                for(QuickbooksInvoiceWrapper.QBOInvoiceLinesWrapper line : qboInvoice.Line) {
                	if(line.Id != null && line.SalesItemLineDetail != null && line.SalesItemLineDetail.ItemRef != null && line.SalesItemLineDetail.ItemRef.value != null) {
                        totalLines++;
                    }
                }
            	for(QuickbooksInvoiceWrapper.QBOInvoiceLinesWrapper line : qboInvoice.Line) {
                    lineIndex++;
                	if(line.SalesItemLineDetail != null && line.SalesItemLineDetail.ItemRef != null && line.SalesItemLineDetail.ItemRef.value != null) {
                        QBO_Invoice_Line__c invLine = new QBO_Invoice_Line__c(
                            QBO_Product__c = productQBAccIdToSFId.get(line.SalesItemLineDetail.ItemRef.value),
                            QBO_Quantity__c = line.SalesItemLineDetail.Qty,
                            QBO_Unit_Price__c = line.SalesItemLineDetail.UnitPrice,
                            QBO_Product_Name__c=line.SalesItemLineDetail.ItemRef.name
                        );
                        if(newInvoiceQBOIdToSFIdMap.containsKey(qboInvoice.Id)) {
                    		invLine.Invoice__c = newInvoiceQBOIdToSFIdMap.get(qboInvoice.Id);
                        } else {
                            QBO_Invoice__c existingInvoiceRec = qboInvoiceIdToSFRecMap.get(qboInvoice.Id);
                            if(existingInvoiceRec!=null){
                            invLine.Invoice__c = existingInvoiceRec.Id;
                            if(existingInvoiceRec.Invoice_Lines__r.size() > lineIndex) {
                            	invLine.Id = existingInvoiceRec.Invoice_Lines__r[lineIndex].Id;
                            }
                            if(lineIndex == 0 && existingInvoiceRec.Invoice_Lines__r.size() > totalLines) {
                                for(Integer i=totalLines; i<existingInvoiceRec.Invoice_Lines__r.size(); i++) {
                                    invoiceLinesToDelete.add(existingInvoiceRec.Invoice_Lines__r[i]);
                                }
                            }
                            }
                        }
                        invoiceLinesToUpsert.add(invLine);
                	}
                }
            }
            system.debug(' == invoiceLinesToUpsert == ' + invoiceLinesToUpsert.size());
            system.debug(' == invoiceLinesToUpsert == ' + invoiceLinesToUpsert);
            if(!invoiceLinesToUpsert.isEmpty()) {
                upsert invoiceLinesToUpsert;
            }
            system.debug(' == invoiceLinesToDelete == ' + invoiceLinesToDelete.size());
            system.debug(' == invoiceLinesToDelete == ' + invoiceLinesToDelete);
            if(!invoiceLinesToDelete.isEmpty()) {
                delete invoiceLinesToDelete;
            }
        }
        QBO_ConstantUtilityClass.forceStopTrigger = false;
        return newInvoiceQBOIdToSFIdMap;
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
    
    public static Map<String, String> getCustomerSFIdByQBOId(List<QuickbooksInvoiceWrapper.QBOInvoice> invoiceList) {
        Map<String, String> customerQBOIdToSFIdMap = new Map<String, String>();
        for(QuickbooksInvoiceWrapper.QBOInvoice invoice : invoiceList) {
            if(invoice.CustomerRef != null && invoice.CustomerRef.value != null) customerQBOIdToSFIdMap.put(invoice.CustomerRef.value, null);
        }
        if(!customerQBOIdToSFIdMap.isEmpty()) {
            for(Contact Con : [Select Id, QBO_Customer_Id__c FROM Contact WHERE QBO_Customer_Id__c IN: customerQBOIdToSFIdMap.keySet()]) {
                customerQBOIdToSFIdMap.put(con.QBO_Customer_Id__c, con.Id);
            }
       }
        return customerQBOIdToSFIdMap;
    }
    
    public static Map<String, String> getOppId(Map<String, String> customerQBAccIdToSFId) {
          Map<String, String> Contactidtooppid = new  Map<String, String>();
        for(string str : customerQBAccIdToSFId.values()){
            list<Opportunitycontactrole> ocr =[Select id,contactid, opportunityid,opportunity.stagename from Opportunitycontactrole where contactid =:str and opportunity.stagename = 'Closed Won'];
            if(ocr.size()==1){
                Contactidtooppid.put(str,ocr[0].opportunityid);
            }
        }
        
        return Contactidtooppid;
    }
    public static Map<String, String> getAccId(Map<String, String> customerQBAccIdToSFId) {
          Map<String, String> ContactidtoAccid = new  Map<String, String>();
         for(Contact Con : [Select Id, accountid FROM Contact WHERE QBO_Customer_Id__c IN: customerQBAccIdToSFId.Values()]) {
                ContactidtoAccid.put(con.Id,con.accountid);
            }
        return ContactidtoAccid;
    }
    
    public static Map<String, String> getProductSFIdByQBOId(List<QuickbooksInvoiceWrapper.QBOInvoice> invoiceList) {
        Map<String, String> productQBOIdToSFIdMap = new Map<String, String>();
        for(QuickbooksInvoiceWrapper.QBOInvoice invoice : invoiceList) {
            if(invoice.Line != null) {
                for(QuickbooksInvoiceWrapper.QBOInvoiceLinesWrapper line : invoice.Line) {
                    if(line.SalesItemLineDetail != null && line.SalesItemLineDetail.ItemRef != null && line.SalesItemLineDetail.ItemRef.value != null) {
						productQBOIdToSFIdMap.put(line.SalesItemLineDetail.ItemRef.value, null);
                    }
                }
            }
        }
        if(!productQBOIdToSFIdMap.isEmpty()) {
            for(Product2 product : [Select Id, QBO_Item_Id__c FROM Product2 WHERE QBO_Item_Id__c IN: productQBOIdToSFIdMap.keySet()]) {
                productQBOIdToSFIdMap.put(product.QBO_Item_Id__c, product.Id);
            }
        }
        return productQBOIdToSFIdMap;
    }
    
    private static Map<String, QBO_Invoice__c> getExistingInvoices(List<QuickbooksInvoiceWrapper.QBOInvoice> invoiceList) {
        Map<String, QBO_Invoice__c> invoiceQBOIdToSFRecMap = new Map<String, QBO_Invoice__c>();
        for(QuickbooksInvoiceWrapper.QBOInvoice invoice : invoiceList) {
            invoiceQBOIdToSFRecMap.put(invoice.id, null);
        }
        if(!invoiceQBOIdToSFRecMap.isEmpty()) {
            for(QBO_Invoice__c invoiceRec : [Select Id, QBO_Invoice_Id__c, (SELECT Id, Name, QBO_Quantity__c, QBO_Unit_Price__c, QBO_Product__c, 
                                       QBO_Product__r.QBO_Item_Id__c FROM Invoice_Lines__r Order By CreatedDate) FROM QBO_Invoice__c WHERE QBO_Invoice_Id__c IN: invoiceQBOIdToSFRecMap.keySet()]) {
                invoiceQBOIdToSFRecMap.put(invoiceRec.QBO_Invoice_Id__c, invoiceRec);
            }
        }
        return invoiceQBOIdToSFRecMap;
    }*/
    
    public void execute(SchedulableContext SC) {
        Database.executeBatch(new QuickbooksGetInvoicesBatch(), 1);
    }
}