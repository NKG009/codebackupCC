global without sharing class QuickbooksPaymentsBatch implements Database.Batchable<Integer>, Database.AllowsCallouts, Schedulable,Database.Stateful {
    
    public Integer APICounter = 0;
    public Boolean recordFound = false;
    public DateTime currentDateTime = system.now();
    
    global QuickbooksPaymentsBatch(){}
    global QuickbooksPaymentsBatch(Integer APICounter) {
        this.APICounter = APICounter;
    }
    
    global Iterable<Integer> start(Database.BatchableContext bc) {
        return new List<Integer>{APICounter};
    }
    global void execute(Database.batchableContext bc, List<Integer> apiCountList) {
        fetchPayments();
    }
     
    global void finish(Database.batchableContext bc) {
        
        if(recordFound && !test.isRunningTest()) {
            Database.executeBatch(new QuickbooksPaymentsBatch(++APICounter));
        } else {
            QBO_Quickbooks_App_Info__c config = QBO_Quickbooks_App_Info__c.getOrgDefaults();
            //config.Last_payment_Fetched_Date__c = currentDateTime;
            //update config;
        }
    }
    
    public void fetchPayments() {
        String query = 'SELECT * FROM Payment ';
        try {
            DateTime txnDate ;//= Quickbooks_App_Info__c.getOrgDefaults().Last_payment_Fetched_Date__c;
            query += txnDate != null ? ' WHERE Metadata.LastUpdatedTime > \'' + txnDate.format('yyyy-MM-dd') + '\'' : '';
            if(APICounter != null && APICounter != 0) {
                query += ' STARTPOSITION '+ ((APICounter * 100) + 1);
            }
            query = EncodingUtil.urlEncode(query, 'UTF-8').replaceAll('\\+','%20');
            HttpResponse res = QuickbooksSendRequestAndRecieveResponse.getRequest('query?query='+query);
            if(res.getStatusCode() == 200){
                system.debug('== res.getBody() ==' + res.getBody());
                QBOQueryResponse qboResult = (QBOQueryResponse) System.JSON.deserialize(res.getBody(), QBOQueryResponse.class);
                if(qboResult.QueryResponse != null && qboResult.QueryResponse.Payment != null && !qboResult.QueryResponse.Payment.isEmpty()) {
                    List<QuickbooksPaymentWrapper.qboPayment> paymentList = qboResult.QueryResponse.Payment;
                    createPayments(paymentList);
                    recordFound = true;
                }
            }
        } catch(Exception e) {
            LogUtil.errorLogs.add(LogUtil.createLog('QuickbooksPaymentsBatch', 'fetchPayments', LogUtil.ERROR, query, 
                                                    null, e.getMessage() +' at line ' +e.getLineNumber() + ' '+ e.getStackTraceString()));
        } finally {
            upsert QuickbooksSendRequestAndRecieveResponse.quickBooksSettingInfo;
        }
        LogUtil.insertLogs();
    }
    
    
    public static void createpayments(List<QuickbooksPaymentWrapper.qboPayment> paymentList) {
        Map<String, QBO_Payment__c> qboPaymentIdToSFRecMap = getExistingpayments(paymentList);
        List<QuickbooksPaymentWrapper.qboPayment> notFoundPaymentList = new List<QuickbooksPaymentWrapper.qboPayment>();
        for(QuickbooksPaymentWrapper.qboPayment qboPayment : paymentList) {
            if(qboPaymentIdToSFRecMap.get(qboPayment.Id) == null) {
                notFoundPaymentList.add(qboPayment);
            }
        }
        Map<String, String> qboInvoiceIdToSFRecMap = getInvoiceSFIdByQBOId(notFoundPaymentList);
        
        List<QBO_Payment__c> paymentListToUpsert = new List<QBO_Payment__c>();
        for(QuickbooksPaymentWrapper.qboPayment qboPayment : paymentList) {
            QBO_Payment__c paymentRec = new QBO_Payment__c(
                QBO_Payment_Id__c = qboPayment.Id,
                QBO_Amount__c = qboPayment.TotalAmt
            );
            if(qboPaymentIdToSFRecMap.containsKey(qboPayment.Id) && qboPaymentIdToSFRecMap.get(qboPayment.Id) != null) {
                paymentRec.Id = qboPaymentIdToSFRecMap.get(qboPayment.Id).Id;
            }
            system.debug('qboPayment::'+qboPayment);
            system.debug('qboPayment line::'+qboPayment.Line);
            if(qboPayment.Line != null && !qboPayment.Line.isEmpty()) {
                Map<String, String> invoiceQBOIdToSFIdMap = new Map<String, String>();
                for(QuickbooksPaymentWrapper.QuickBooksLineWrapper qboPaymentLine : qboPayment.Line) {
                    for(QuickbooksPaymentWrapper.QuickBooksLinkedTxnWrapper txn : qboPaymentLine.LinkedTxn) {
                        if(txn.TxnType.equalsIgnoreCase('Invoice') && qboInvoiceIdToSFRecMap.containsKey(txn.TxnId) && qboInvoiceIdToSFRecMap.get(txn.TxnId) != null) {
                            paymentRec.QBO_Invoice__c = qboInvoiceIdToSFRecMap.get(txn.TxnId);
                        }
                    }
                }
            }
            if(paymentRec.QBO_Invoice__c!=null){
            paymentListToUpsert.add(paymentRec);
            }
            
        }
        system.debug(' == paymentListToUpsert == ' + paymentListToUpsert.size());
        system.debug(' == paymentListToUpsert == ' + paymentListToUpsert);
        if(!paymentListToUpsert.isEmpty()) {
            QBO_ConstantUtilityClass.forceStopTrigger = true;
            upsert paymentListToUpsert;
            //List<Database.UpsertResult> upsertResultList = Database.upsert(paymentListToUpsert, false);
            QBO_ConstantUtilityClass.forceStopTrigger = false;
        }
    }
    
    public static Map<String, String> getInvoiceSFIdByQBOId(List<QuickbooksPaymentWrapper.qboPayment> paymentList) {
        Map<String, String> invoiceQBOIdToSFIdMap = new Map<String, String>();
        for(QuickbooksPaymentWrapper.QBOPayment payment : paymentList) {
            if(payment.Line != null && !payment.Line.isEmpty()) {
                for(QuickbooksPaymentWrapper.QuickBooksLineWrapper qboPaymentLine : payment.Line) {
                    for(QuickbooksPaymentWrapper.QuickBooksLinkedTxnWrapper txn : qboPaymentLine.LinkedTxn) {
                        if(txn.TxnType.equalsIgnoreCase('Invoice')) {
                        	invoiceQBOIdToSFIdMap.put(txn.TxnId, null);
                        }
                    }
                }
            }
        }
        if(!invoiceQBOIdToSFIdMap.isEmpty()) {
            for(QBO_Invoice__c inv : [Select Id, QBO_Invoice_Id__c FROM QBO_Invoice__c WHERE QBO_Invoice_Id__c IN: invoiceQBOIdToSFIdMap.keySet()]) {
                invoiceQBOIdToSFIdMap.put(inv.QBO_Invoice_Id__c, inv.Id);
            }
            Set<String> newInvQBIdSet = new Set<String>();
            for(String invQBOId : invoiceQBOIdToSFIdMap.keySet()) {
                if(invoiceQBOIdToSFIdMap.get(invQBOId) == null) newInvQBIdSet.add(invQBOId);
            }
            if(!newInvQBIdSet.isEmpty()) {
               // invoiceQBOIdToSFIdMap.putAll(QBOGetInvoicesBatch.fetchInvoiceByIds(newInvQBIdSet));
            }
        }
        return invoiceQBOIdToSFIdMap;
    }
    
    private static Map<String, QBO_Payment__c> getExistingpayments(List<QuickbooksPaymentWrapper.qboPayment> paymentList) {
        Map<String, QBO_Payment__c> paymentQBOIdToSFRecMap = new Map<String, QBO_Payment__c>();
        for(QuickbooksPaymentWrapper.qboPayment payment : paymentList) {
            paymentQBOIdToSFRecMap.put(payment.id, null);
        }
        if(!paymentQBOIdToSFRecMap.isEmpty()) {
            for(QBO_Payment__c paymentRec : [Select Id, QBO_Payment_Id__c FROM QBO_Payment__c WHERE QBO_Payment_Id__c IN: paymentQBOIdToSFRecMap.keySet()]) {
                paymentQBOIdToSFRecMap.put(paymentRec.QBO_Payment_Id__c, paymentRec);
            }
        }
        return paymentQBOIdToSFRecMap;
    }
    
    public void execute(SchedulableContext SC) {
        Database.executeBatch(new QuickbooksPaymentsBatch(), 1);
    }
}