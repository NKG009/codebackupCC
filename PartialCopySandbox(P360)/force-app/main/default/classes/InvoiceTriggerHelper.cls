public without sharing class InvoiceTriggerHelper {
    
    public static void shareInvoices(Set<Id> aIdSet) {      
        System.debug('shareInvoices start');
        try{
             List<ContentDocumentLink> cdlToInsertList = new List<ContentDocumentLink>();
        Map<Id,Id> orderidToContentDocumentId = new Map<Id,Id>();
        Map<Id,Id>InvidToContentDocumentlinkId = new Map<Id,Id>();
            List<Bread_Winner__Invoice__c> invList = getInvoices(aIdSet);        
            List<Bread_Winner__Invoice__Share> ishToInsertList = new  List<Bread_Winner__Invoice__Share>();
            Set<Id> accIdSet = new Set<Id>();

            Map<Id, Id> invoiceToOrderMap = new Map<Id, Id>();
            System.debug('invList: ' + invList);
            for(Bread_Winner__Invoice__c inv : invList){
                if(inv.Order_Lookup__c != null){                    
                    invoiceToOrderMap.put(inv.Order_Lookup__c,inv.Id);
                    if(inv.Order_Lookup__r.AccountId != null
                    && inv.Order_Lookup__r.Account.Property_Office_Agent__c != null){                
                        Bread_Winner__Invoice__Share ishToInsert = new Bread_Winner__Invoice__Share();
                        ishToInsert.AccessLevel = 'Read';
                        ishToInsert.ParentId = inv.Id;
                        ishToInsert.RowCause = 'Manual';
                        ishToInsert.UserOrGroupId = inv.Order_Lookup__r.Account.Property_Office_Agent__c;
                        ishToInsertList.add(ishToInsert);                
                    }
                }
            }
          
            if(!ishToInsertList.isEmpty()){
                Database.insert(ishToInsertList, false);
            }
            System.debug('ishToInsertList: ' + ishToInsertList);              

            System.debug('invoiceToOrderMap: ' + invoiceToOrderMap);
            if(!invoiceToOrderMap.isEmpty()){
                  for (ContentDocumentLink OrderCDL : [SELECT Id,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink  WHERE LinkedEntityId IN: invoiceToOrderMap.keyset()  AND ContentDocument.FileType = 'PDF']){
                orderidToContentDocumentId.put(OrderCDL.LinkedEntityId,OrderCDL.ContentDocumentId);
            }
            
            for (ContentDocumentLink InvCDL : [SELECT Id,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink  WHERE LinkedEntityId IN: invoiceToOrderMap.values()  AND ContentDocument.FileType = 'PDF']){
                
                InvidToContentDocumentlinkId.put(InvCDL.LinkedEntityId,InvCDL.Id);
                
            }
            for(Id OrdId : invoiceToOrderMap.keyset()){    
                id invid=invoiceToOrderMap.get(OrdId);
                id invcdlID = InvidToContentDocumentlinkId.get(invid);
                id cdlid=orderidToContentDocumentId.get(OrdId);
                if(invcdlID==null && invid !=null && cdlid !=null){
                    ContentDocumentLink cdlToInsert = new ContentDocumentLink();
                    cdlToInsert.ContentDocumentId =cdlid;
                    cdlToInsert.LinkedEntityId = invid;
                    cdlToInsert.Visibility = 'AllUsers';
                    cdlToInsertList.add(cdlToInsert);
                }   
            }                 
             /*   Map<Id, ContentDocumentLink> cdlMap = new Map<Id, ContentDocumentLink>(getContentDocumentLinks(invoiceToOrderMap.values()));
                List<ContentDocumentLink> cdlToInsertList = new List<ContentDocumentLink>();
                for(Id invId : invoiceToOrderMap.keySet()){                                         
                    ContentDocumentLink cdl = cdlMap.get(invId);
                    if(cdl != null){
                        ContentDocumentLink cdlToInsert = new ContentDocumentLink();
                        cdlToInsert.ContentDocumentId = cdl.ContentDocumentId;
                        cdlToInsert.LinkedEntityId = invId;
                        cdlToInsert.Visibility = 'AllUsers';
                        cdlToInsertList.add(cdlToInsert);
                    }
                }   
                if(!cdlToInsertList.isEmpty()){
                    Database.insert(cdlToInsertList, false);
                }
                System.debug('cdlToInsertList: ' + cdlToInsertList);        */                                     
            }
             if(cdlToInsertList.size()>0){
            insert cdlToInsertList;
        }
        }catch(Exception e){
            System.debug(e.getLineNumber() + ' : ' + e.getMessage());
        }
    }

    public static List<Bread_Winner__Invoice__c> getInvoices(Set<Id> aIdSet) {
        return [
            SELECT Id,
                   Order_Lookup__c,
                   Order_Lookup__r.AccountId,
                   Order_Lookup__r.Account.Property_Office_Agent__c
            FROM Bread_Winner__Invoice__c
            WHERE Id =: aIdSet
        ];        
    }

/*    public static List<ContentDocumentLink> getContentDocumentLinks(List<Id> aIdSet) {
        return [
            SELECT Id
            FROM ContentDocumentLink
            WHERE LinkedEntityId =: aIdSet
              AND ContentDocument.FileType = 'PDF'
        ];        
    } */   
    public static void InvoiceSharetoPowerUser(set<id> Invids){
        list<Bread_Winner__Invoice__Share> InvoicetoShareList = new list<Bread_Winner__Invoice__Share>();
        
         for(Bread_Winner__Invoice__c Inv : [select id,Bread_Winner__Account__c,Bread_Winner__Account__r.Power_User__c,Bread_Winner__Account__r.name,Bread_Winner__Account__r.recordtype.developername from Bread_Winner__Invoice__c where id IN:Invids ]){
                if(Inv.Bread_Winner__Account__r.Power_User__c !=null){
                    Bread_Winner__Invoice__Share ishToInsert = new Bread_Winner__Invoice__Share();
                    ishToInsert.AccessLevel = 'Read';
                    ishToInsert.ParentId = Inv.Id;
                    ishToInsert.UserOrGroupId = Inv.Bread_Winner__Account__r.Power_User__c;
                    InvoicetoShareList.add(ishToInsert);
                   
                } 
         }
        if(InvoicetoShareList.size()>0){
            insert InvoicetoShareList;
        }
    }
}