public without sharing class QuoteLineItemTriggerHandler {
    public static void processInsertSync(List<QuoteLineItem> quoteLineItems) {
        if (quoteLineItems == null || quoteLineItems.isEmpty()) {
            return;
        }
        
        if (TriggerHelper.stopQuoteLine) { 
            return; 
        }
        TriggerHelper.stopQuoteLine = true;
        
        Map<Id, QuoteLineItem> idMap = new Map<Id, QuoteLineItem>();
        Map<Id, Boolean> isQuoteSyncingMap = new Map<Id, Boolean>();
        
        for (QuoteLineItem quoteLineItemRecord : quoteLineItems) {

            if (String.isNotBlank(quoteLineItemRecord.OpportunityLineItemId)) {
                idMap.put(quoteLineItemRecord.OpportunityLineItemId, quoteLineItemRecord);
                isQuoteSyncingMap.put(quoteLineItemRecord.QuoteId, false);
            }
        }
        
        idMap.remove(null);
        isQuoteSyncingMap.remove(null);
        
        if (!idMap.isEmpty()) {
            for (Quote quoteRecord : QuoteSelector.getSyncedQuotes(isQuoteSyncingMap.keySet())) {
                isQuoteSyncingMap.put(quoteRecord.Id, true);
            }
            
            OpportunityQuoteSyncSettings syncSettings = new OpportunityQuoteSyncSettings(ApexConstants.OPPORTUNITY_LINE_ITEM_OBJECT_API_NAME);
            syncSettings.initializeSyncSettings();
            
            for (OpportunityLineItem opportunityLineItemRecord : OpportunityLineItemSelector.getOpportunityLineItemsForSyncByQueryString(syncSettings.getAttributesToSync(), idMap.keySet())) {
                QuoteLineItem quoteLineItemRecord = idMap.get(opportunityLineItemRecord.Id);
                Boolean isQuoteSyncing = isQuoteSyncingMap.get(quoteLineItemRecord.QuoteId);
                
                if (isQuoteSyncing != null && isQuoteSyncing) {
                    for (Opportunity_Quote_Sync_Setting__mdt syncAttribute : syncSettings.getSyncSettings()) {                        
                        quoteLineItemRecord.put(syncAttribute.Target_Field__r.QualifiedApiName, opportunityLineItemRecord.get(syncAttribute.Scope_Field__r.QualifiedApiName));
                    }
                }
            }
        }
    }
    
    public static void processUpdateSync(List<QuoteLineItem> quoteLineItems) {
        if (quoteLineItems == null || quoteLineItems.isEmpty() || System.isFuture()) {
            return;
        }
        
        if (TriggerHelper.stopQuoteLine) { 
            return; 
        }
    
        TriggerHelper.stopQuoteLine = true;
        
        Map<Id, QuoteLineItem> idMap = new Map<Id, QuoteLineItem>();
        Map<Id, Boolean> isQuoteSyncingLineItem = new Map<Id, Boolean>();
        Map<Id, Boolean> isQuoteSyncingMap = new Map<Id, Boolean>();
        
        for (QuoteLineItem quoteLineItemRecord : quoteLineItems) {
            if (String.isNotBlank(quoteLineItemRecord.OpportunityLineItemId)) {
                idMap.put(quoteLineItemRecord.OpportunityLineItemId, quoteLineItemRecord);
                isQuoteSyncingMap.put(quoteLineItemRecord.QuoteId, false);
            }
        }
        
        idMap.remove(null);
        isQuoteSyncingMap.remove(null);
        
        List<OpportunityLineItem> opportunityLineItemsToSync = new List<OpportunityLineItem>();
        
        if (!idMap.isEmpty()) {
            for (Quote quoteRecord : QuoteSelector.getSyncedQuotes(isQuoteSyncingMap.keySet())) {
                isQuoteSyncingMap.put(quoteRecord.Id, true);
            }
            
            OpportunityQuoteSyncSettings syncSettings = new OpportunityQuoteSyncSettings(ApexConstants.QUOTE_LINE_ITEM_OBJECT_API_NAME);
            syncSettings.initializeSyncSettings();
            
            for (OpportunityLineItem opportunityLineItemRecord : OpportunityLineItemSelector.getOpportunityLineItemsForSyncByQueryString(syncSettings.getAttributesToSync(), idMap.keySet())) {
                QuoteLineItem quoteLineItemRecord = idMap.get(opportunityLineItemRecord.Id);
                Boolean isQuoteSyncing = isQuoteSyncingMap.get(quoteLineItemRecord.QuoteId);
                
                if (isQuoteSyncing != null && isQuoteSyncing) {
                    for (Opportunity_Quote_Sync_Setting__mdt syncAttribute : syncSettings.getSyncSettings()) {
                        opportunityLineItemRecord.put(syncAttribute.Target_Field__r.QualifiedApiName, quoteLineItemRecord.get(syncAttribute.Scope_Field__r.QualifiedApiName));
                    }
                }
                
                opportunityLineItemsToSync.add(opportunityLineItemRecord);
            }
        }
        
        if (!opportunityLineItemsToSync.isEmpty()) {
            update opportunityLineItemsToSync;
        }
    }
    
    public static void setDefaultValues(List<QuoteLineItem> quoteLineItems) {
        if (quoteLineItems == null || quoteLineItems.isEmpty()) {
            return;
        }
        Map<Id, Id> quoteToPrimaryAddressMap = new Map<Id, Id>();
        
        for (QuoteLineItem lineItem : quoteLineItems) {
            quoteToPrimaryAddressMap.put(lineItem.QuoteId, null);
        }
        quoteToPrimaryAddressMap.remove(null);
        
        if (!quoteToPrimaryAddressMap.isEmpty()) {
            for (Quote quoteRecord : QuoteSelector.getPrimaryServiceAccountFromQuotes(quoteToPrimaryAddressMap.keySet())) {
                if (String.isBlank(quoteRecord.Account.Primary_Service_Account__c)) {
                    quoteToPrimaryAddressMap.put(quoteRecord.Id, quoteRecord.AccountId);
                    continue;
                }
                
                quoteToPrimaryAddressMap.put(quoteRecord.Id, quoteRecord.Account.Primary_Service_Account__c);
            }
        }
        
        for (QuoteLineItem lineItem : quoteLineItems) {
            if (quoteToPrimaryAddressMap.containsKey(lineItem.QuoteId) && lineItem.Service_Account_Record_Type_ID__c != ApexConstants.ACCOUNT_SERVICE_RECORD_TYPE_ID) {
                lineItem.vlocity_cmt__ServiceAccountId__c = quoteToPrimaryAddressMap.get(lineItem.QuoteId);
            }
            
            if (lineItem.Initial_Recurring_Charge__c == null) {
                lineItem.Initial_Recurring_Charge__c = lineItem.vlocity_cmt__RecurringCharge__c;
            }
            
            if (lineItem.Initial_One_Time_Charge__c == null) {
                lineItem.Initial_One_Time_Charge__c = lineItem.vlocity_cmt__OneTimeCharge__c;
            }
        }
    }
    
    public static void setSalesPrice(List<QuoteLineItem> quoteLineItems) {
        if (quoteLineItems == null || quoteLineItems.isEmpty()) {
            return;
        }
        for (QuoteLineItem quoteLineItemRecord : quoteLineItems) {
            quoteLineItemRecord.UnitPrice = quoteLineItemRecord.Total__c;
        }
    }
    
    public static void processApprovals(Map<Id, QuoteLineItem> lineItems, TriggerOperation operationType) {
        if (operationType == TriggerOperation.AFTER_INSERT && !TriggerHelper.stopQuoteLineApprovalsInsert) {
            TriggerHelper.stopQuoteLineApprovalsInsert = true;
            new ApprovalProcessor(lineItems, ApprovalStateEnum.ISINSERT).process();
            //TriggerHelper.stopQuoteLineApprovalsInsert = false;
        } else if (operationType == TriggerOperation.AFTER_UPDATE && !TriggerHelper.stopQuoteLineApprovalsUpdate) {
            TriggerHelper.stopQuoteLineApprovalsUpdate = true;
            new ApprovalProcessor(lineItems, ApprovalStateEnum.ISUPDATE).process();
            //TriggerHelper.stopQuoteLineApprovalsUpdate = false;
        } else if (operationType == TriggerOperation.BEFORE_DELETE && !TriggerHelper.stopQuoteLineApprovalsDelete) {
            TriggerHelper.stopQuoteLineApprovalsDelete = true;
            new ApprovalProcessor(lineItems, ApprovalStateEnum.ISDELETE).process(); 
            //TriggerHelper.stopQuoteLineApprovalsDelete = false;
        }
    }
    
    public static Map<Id, QuoteLineItem> getQuoteLineItemsToCheckForApproval(Map<Id, QuoteLineItem> newMap, Map<Id, QuoteLineItem> oldMap) {
        Map<Id, QuoteLineItem> quoteLineItemsToProcess = new Map<Id, QuoteLineItem>();

        for (QuoteLineItem quoteLineItemRecord : newMap.values()) {
            QuoteLineItem oldQuoteLineItemRecord = oldMap?.get(quoteLineItemRecord.Id) == null ? new QuoteLineItem() : oldMap?.get(quoteLineItemRecord.Id);
            if (quoteLineItemRecord.vlocity_cmt__Action__c == 'Disconnect' || quoteLineItemRecord.vlocity_cmt__Action__c == 'Existing') {
                continue;
            }
            
            if (quoteLineItemRecord.vlocity_cmt__RecurringCharge__c == oldQuoteLineItemRecord.vlocity_cmt__RecurringCharge__c) {
                continue;
            }
           
            quoteLineItemsToProcess.put(quoteLineItemRecord.Id, quoteLineItemRecord);
        }
        
        quoteLineItemsToProcess.remove(null);

        return quoteLineItemsToProcess;
    }
}