trigger QuoteTrigger on SBQQ__Quote__c (before insert, Before update) {
    
    if(trigger.isbefore && (trigger.isinsert || trigger.isupdate)){
        
        Set<Id> shipToAccountIds = new Set<Id>();
        
        /* -----------------------------------
Collect Ship-To Account Ids
------------------------------------*/
        for (SBQQ__Quote__c q : Trigger.new) {
            if (q.SBQQ__Account__c != null) {
                
                // On update, run only if AccountId changed
                if (Trigger.isInsert ||
                    (Trigger.isUpdate &&
                     q.SBQQ__Account__c != Trigger.oldMap.get(q.Id).SBQQ__Account__c)
                   ) {
                       shipToAccountIds.add(q.SBQQ__Account__c);
                   }
            }
        }
        
        if (shipToAccountIds.isEmpty()) return;
        
        /* -----------------------------------
Query Ship-To Accounts
------------------------------------*/
        Map<Id, Account> shipToAccountMap = new Map<Id, Account>(
            [
                SELECT Id,
                Name,
                ShippingStreet,
                shippingCity,
                shippingState,
                shippingPostalCode,
                shippingCountry,
                ParentId
                FROM Account
                WHERE Id IN :shipToAccountIds
            ]
        );
        
        /* -----------------------------------
Collect Sold-To Account Ids
------------------------------------*/
        Set<Id> soldToAccountIds = new Set<Id>();
        
        for (Account acc : shipToAccountMap.values()) {
            if (acc.ParentId != null) {
                soldToAccountIds.add(acc.ParentId);
            }
        }
        
        Map<Id, Account> soldToAccountMap = soldToAccountIds.isEmpty()
            ? new Map<Id, Account>()
            : new Map<Id, Account>(
                [
                    SELECT Id, APTS_Pricing_Notes__c
                    FROM Account
                    WHERE Id IN :soldToAccountIds
                ]
            );
        
        /* -----------------------------------
Populate Quote Fields
------------------------------------*/
        for (SBQQ__Quote__c q : Trigger.new) {
            
            if (q.SBQQ__Account__c == null ||
                !shipToAccountMap.containsKey(q.SBQQ__Account__c)
               ) {
                   continue;
               }
            
            Account shipToAccount = shipToAccountMap.get(q.SBQQ__Account__c);
            
            // Ship-To Address mapping
            q.SBQQ__ShippingName__c       = shipToAccount.Name;
            q.SBQQ__ShippingStreet__c     = shipToAccount.ShippingStreet !=null?shipToAccount.ShippingStreet : '';
            q.SBQQ__ShippingCity__c       = shipToAccount.shippingCity !=null ? shipToAccount.shippingCity : '';
            q.SBQQ__ShippingState__c      = shipToAccount.shippingState !=null? shipToAccount.shippingState: '';
            q.SBQQ__ShippingPostalCode__c = shipToAccount.shippingPostalCode != null ? shipToAccount.shippingPostalCode :'';
            q.SBQQ__ShippingCountry__c    = shipToAccount.shippingCountry !=null? shipToAccount.shippingCountry : '';
            
            // Pricing Notes from Sold-To Account
            if (shipToAccount.ParentId != null &&
                soldToAccountMap.containsKey(shipToAccount.ParentId)
               ) {
                   q.Pricing_Notes__c =
                       soldToAccountMap.get(shipToAccount.ParentId).APTS_Pricing_Notes__c;
               }
        }
        
        
    }
    
}