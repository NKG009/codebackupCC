@RestResource(urlMapping='/QuickbooksPaymentWebService/*')
global class QuickbooksPaymentWebService {
  /*  
    
    @HttpPost
    global static void GetPaymentWebhooksResponse(){
         try {
         Map<String, Set<String>> paymentOperationTypeToEntityIdMap = new Map<String, Set<String>>();
          Set<String> qboPaymentIdsToUpsert = new Set<String>(); 
        if(QBO_Quickbooks_App_Info__c.getOrgDefaults().QBO_Enable_Quickbooks__c) {
            system.debug('Event Payload:: ' + RestContext.request.requestbody.toString());
            QBOWebhookWrapper qboWebookObj = (QBOWebhookWrapper) System.JSON.deserialize(RestContext.request.requestbody.toString(), QBOWebhookWrapper.class);
           
            for(QBOWebhookWrapper.EventNotification eventNotification : qboWebookObj.eventNotifications) {
                if(eventNotification.dataChangeEvent != null && eventNotification.dataChangeEvent.entities != null) {
                    for(QBOWebhookWrapper.Entity entity : eventNotification.dataChangeEvent.entities) {
                        entity.operation = entity.operation.toLowerCase();
                        if(entity.Name.equalsIgnoreCase('Payment')) {
                            if(!paymentOperationTypeToEntityIdMap.containsKey(entity.operation)) {
                                paymentOperationTypeToEntityIdMap.put(entity.operation, new Set<String>());
                            }
                            paymentOperationTypeToEntityIdMap.get(entity.operation).add(entity.id);
                        }
                    }
                }
                
            }
            
       }
         for(Set<String> qboPaymentIds : paymentOperationTypeToEntityIdMap.values()) {
                qboPaymentIdsToUpsert.addAll(qboPaymentIds);
            }
        fetchPaymentByIds(qboPaymentIdsToUpsert);
        
        
    }
        catch(Exception e) {
            LogUtil.errorLogs.add(LogUtil.createLog('QuickbooksPaymentWebService', 'GetPaymentWebhooksResponse', LogUtil.ERROR, null, null, 
                                                    RestContext.request.requestbody.toString(), e.getMessage() +' at line ' +e.getLineNumber() + ' '+ e.getStackTraceString()));
        }
        LogUtil.insertLogs(); 
    
    }  
    
        public static void fetchPaymentByIds(Set<String> qboPaymentIds) {
            system.debug('fetchPaymentByIds');
        try {
            if(qboPaymentIds != null && !qboPaymentIds.isEmpty()) {
                String query = 'SELECT * FROM Payment WHERE Id IN (\'' + String.join(new List<String>(qboPaymentIds), '\',\'') + '\')';
                query = EncodingUtil.urlEncode(query, 'UTF-8').replaceAll('\\+','%20');
                HttpResponse res = QuickbooksSendRequestAndRecieveResponse.getRequest('query?query='+query);
                if(res.getStatusCode() == 200){
                    system.debug('== res.getBody() ==' + res.getBody());
                    QBOQueryResponse qboResult = (QBOQueryResponse) System.JSON.deserialize(res.getBody(), QBOQueryResponse.class);
                    if(qboResult.QueryResponse != null && qboResult.QueryResponse.payment != null && !qboResult.QueryResponse.Payment.isEmpty()) {
                        List<QuickbooksPaymentWrapper.qboPayment> paymentList = qboResult.QueryResponse.Payment;
                        createpayments(paymentList);
                        if(qboPaymentIds.size() != paymentList.size()) {
                            Set<String> existingqboPaymentIds = new Set<String>();
                            for(QuickbooksPaymentWrapper.qboPayment qboPayment : paymentList) {
                                existingqboPaymentIds.add(qboPayment.Id);
                            }
                            qboPaymentIds.removeAll(existingqboPaymentIds);
                           deletePayment(qboPaymentIds);
                        }
                    } else {
                        //if(test.isRunningTest())createpayments(paymentList);
                       deletePayment(qboPaymentIds);
                    }
                }
            }
        } catch(Exception e) {
            LogUtil.errorLogs.add(LogUtil.createLog('QBOGetPaymentsBatch', 'fetchPaymentByIds_future', LogUtil.ERROR, qboPaymentIds.toString(), 
                                                    null, e.getMessage() +' at line ' +e.getLineNumber() + ' '+ e.getStackTraceString()));
        } finally {
            upsert QuickbooksSendRequestAndRecieveResponse.quickBooksSettingInfo;
        }
        system.debug('final payment logs::'+LogUtil.errorLogs);
        LogUtil.insertLogs(); 
    }
    
    
     public static void deletePayment(Set<String> qboPaymentIds) {
        if(qboPaymentIds != null && !qboPaymentIds.isEmpty()) {
            delete [Select Id FROM QBO_Payment__c WHERE QBO_payment_Id__c IN: qboPaymentIds];
        }
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
               // QBO_SyncToken__c = qboPayment.SyncToken,
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
            paymentListToUpsert.add(paymentRec);
        }
        system.debug(' == paymentListToUpsert == ' + paymentListToUpsert.size());
        system.debug(' == paymentListToUpsert == ' + paymentListToUpsert);
        if(!paymentListToUpsert.isEmpty()) {
           // QBO_ConstantUtilityClass.forceStopTrigger = true;
            upsert paymentListToUpsert;
            //List<Database.UpsertResult> upsertResultList = Database.upsert(paymentListToUpsert, false);
           // QBO_ConstantUtilityClass.forceStopTrigger = false;
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
               // invoiceQBOIdToSFIdMap.putAll(fetchInvoiceByIds(newInvQBIdSet));
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
 
    */
    
}