public without sharing class OpportunityLineItemTriggerHandler {
    public static void setSalesPrice(List<OpportunityLineItem> opportunityLineItems) {
        if (opportunityLineItems == null || opportunityLineItems.isEmpty()) {
            return;
        }
        
        for (OpportunityLineItem opportunityLineItemRecord : opportunityLineItems) {
            opportunityLineItemRecord.UnitPrice = opportunityLineItemRecord.Total__c;
        }
    }
    
    public static void processInsertSync(List<OpportunityLineItem> opportunityLineItems) {
        if (opportunityLineItems == null || opportunityLineItems.isEmpty()) {
            return;
        }
        
        if (TriggerHelper.hasSyncInsertStarted) { return; }
        TriggerHelper.stopOppLine = true;
        TriggerHelper.hasSyncInsertStarted = true;
        
        Set<Id> opportunityLineItemIds = new Set<Id>();
        
        for (OpportunityLineItem opportunityLineItemRecord : opportunityLineItems) {
            opportunityLineItemIds.add(opportunityLineItemRecord.Id);
        }
        
        opportunityLineItemIds.remove(null);
        
        if (!opportunityLineItemIds.isEmpty()) {
        	processInsertSyncFuture(opportunityLineItemIds);
        }
    }
    
    @future
    public static void processInsertSyncFuture(Set<Id> opportunityLineItemIds) {
        Map<Id, QuoteLineItem> idMap = new Map<Id, QuoteLineItem>();
        Map<Id, Boolean> isQuoteSyncingMap = new Map<Id, Boolean>();
        
        OpportunityQuoteSyncSettings opportunityLineItemSyncSettings = new OpportunityQuoteSyncSettings(ApexConstants.OPPORTUNITY_LINE_ITEM_OBJECT_API_NAME);
        opportunityLineItemSyncSettings.initializeSyncSettings();
        
        for (QuoteLineItem quoteLineItemRecord : QuoteLineItemSelector.getQuoteLineItemsForSyncByQueryString(opportunityLineItemSyncSettings.getAttributesToSync(), opportunityLineItemIds)) {
            idMap.put(quoteLineItemRecord.OpportunityLineItemId, quoteLineItemRecord);
            isQuoteSyncingMap.put(quoteLineItemRecord.QuoteId, false);
        }
        
        idMap.remove(null);
        isQuoteSyncingMap.remove(null);
        
        if (!idMap.isEmpty()) {
        	List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
            
            for (Quote quoteRecord : QuoteSelector.getSyncedQuotes(isQuoteSyncingMap.keySet())) {
                isQuoteSyncingMap.put(quoteRecord.Id, true);
            }
            
            OpportunityQuoteSyncSettings quoteLineItemSyncSettings = new OpportunityQuoteSyncSettings(ApexConstants.QUOTE_LINE_ITEM_OBJECT_API_NAME);
            quoteLineItemSyncSettings.initializeSyncSettings();
            
            for (OpportunityLineItem opportunityLineItemRecord : OpportunityLineItemSelector.getOpportunityLineItemsForSyncByQueryString(quoteLineItemSyncSettings.getAttributesToSync(), idMap.keySet())) {
                QuoteLineItem quoteLineItemRecord = idMap.get(opportunityLineItemRecord.Id);
                Boolean isQuoteSyncing = isQuoteSyncingMap.get(quoteLineItemRecord.QuoteId);
                
                if (isQuoteSyncing != null && isQuoteSyncing) {
                    for (Opportunity_Quote_Sync_Setting__mdt syncAttribute : quoteLineItemSyncSettings.getSyncSettings()) {
                        opportunityLineItemRecord.put(syncAttribute.Target_Field__r.QualifiedApiName, quoteLineItemRecord.get(syncAttribute.Scope_Field__r.QualifiedApiName));
                        opportunityLineItemRecord.Quote_Sync_Established__c = true;
                    }
                    
                    opportunityLineItems.add(opportunityLineItemRecord);
                }
            }
            
            if (!opportunityLineItems.isEmpty()) {
                update opportunityLineItems;
            }
        }
    }
    
    public static void processUpdateSync(List<OpportunityLineItem> opportunityLineItems) {
        if (opportunityLineItems == null || opportunityLineItems.isEmpty() || System.isFuture()) {
            return;
        }
        
        if (TriggerHelper.stopOppLine) { return; }
        TriggerHelper.stopOppLine = true;
        
        Set<Id> opportunityLineToQuoteLineIds = new Set<Id>();
        
        for (OpportunityLineItem opportunityLineItemRecord : opportunityLineItems) {
            if (opportunityLineItemRecord.Quote_Sync_Established__c) {
            	opportunityLineToQuoteLineIds.add(opportunityLineItemRecord.Id);
            }
        }
        
        opportunityLineToQuoteLineIds.remove(null);
        
        if (!opportunityLineToQuoteLineIds.isEmpty()) {
        	List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
            
            OpportunityQuoteSyncSettings syncSettings = new OpportunityQuoteSyncSettings(ApexConstants.OPPORTUNITY_LINE_ITEM_OBJECT_API_NAME);
            syncSettings.initializeSyncSettings();
            
            for (QuoteLineItem quoteLineItemRecord : QuoteLineItemSelector.getQuoteLineItemsForSyncByQueryString(syncSettings.getAttributesToSync(), opportunityLineToQuoteLineIds)) {
                OpportunityLineItem opportunityLineItemRecord = (OpportunityLineItem)Trigger.newMap.get(quoteLineItemRecord.OpportunityLineItemId);
                
                for (Opportunity_Quote_Sync_Setting__mdt syncAttribute : syncSettings.getSyncSettings()) {
                    quoteLineItemRecord.put(syncAttribute.Target_Field__r.QualifiedApiName, opportunityLineItemRecord.get(syncAttribute.Scope_Field__r.QualifiedApiName));
                }
                
                quoteLineItems.add(quoteLineItemRecord);
            }
            
            if (!quoteLineItems.isEmpty()) {
                update quoteLineItems;
            }
        }
    }
}