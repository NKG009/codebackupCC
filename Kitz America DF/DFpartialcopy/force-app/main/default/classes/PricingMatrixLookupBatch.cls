global class PricingMatrixLookupBatch implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator([
            SELECT Id,
             Active__c,
                   Valid_From__c,
                   Valid_Till__c,

                   SAP_Account_Number__c,
                   SAP_Account_Number_Child__c,
                   SAP_Material_Number__c,

                   Parent_Account__c,
                   Customer_Account__c,
                   Product__c,

                   Product_Category_CIT__c,
                   Product_Catalog__c,
                   Product_Sub_Category__c,

                   NET_Price__c,
                   Product_Discount__c
            FROM Pricing_Matrix__c
            WHERE Active__c = true
            AND Valid_Till__c >= :System.today()
          //  AND Createddate >= :System.today()
            AND (
                Customer_Account__c = NULL
                AND Parent_Account__c = NULL
                AND Product__c = NULL
            )
        ]);
    }
    
    global void execute(Database.BatchableContext bc, List<Pricing_Matrix__c> scope) {
        
        Set<String> parentSapSet = new Set<String>();
        Set<String> childSapSet  = new Set<String>();
        Set<String> materialSet  = new Set<String>();
        system.debug('scope:'+scope.size());
        for (Pricing_Matrix__c pm : scope) {
            if (pm.SAP_Account_Number__c != null)
                parentSapSet.add(pm.SAP_Account_Number__c);
            
            if (pm.SAP_Account_Number_Child__c != null)
                childSapSet.add(pm.SAP_Account_Number_Child__c);
            
            if (pm.SAP_Material_Number__c != null)
                materialSet.add(pm.SAP_Material_Number__c);
        }
        
        /* ---------------- Account Queries ---------------- */
        
        Map<String, Id> parentAccountMap = new Map<String, Id>();
        if (!parentSapSet.isEmpty()) {
            for (Account acc : [
                SELECT Id, AccountNumber
                FROM Account
                WHERE ParentId =null AND AccountNumber IN :parentSapSet
            ]) {
                parentAccountMap.put(acc.AccountNumber, acc.Id);
            }
        }
        
        Map<String, Id> childAccountMap = new Map<String, Id>();
        if (!childSapSet.isEmpty()) {
            for (Account acc : [
                SELECT Id, AccountNumber
                FROM Account
                WHERE ParentId !=null AND AccountNumber IN :childSapSet
            ]) {
                childAccountMap.put(acc.AccountNumber, acc.Id);
            }
        }
        
        /* ---------------- Product Query ---------------- */
        
        Map<String, Id> productMap = new Map<String, Id>();
        if (!materialSet.isEmpty()) {
            for (Product2 p : [
                SELECT Id, APTS_Material_Num__c
                FROM Product2
                WHERE APTS_Material_Num__c IN :materialSet
            ]) {
                productMap.put(p.APTS_Material_Num__c, p.Id);
            }
        }
        
        /* ---------------- Mapping ---------------- */
        
        List<Pricing_Matrix__c> updates = new List<Pricing_Matrix__c>();
        
        for (Pricing_Matrix__c pm : scope) {
            
            Boolean changed = false;
            
            if (pm.Parent_Account__c == null &&
                pm.SAP_Account_Number__c != null &&
                parentAccountMap.containsKey(pm.SAP_Account_Number__c)) {
                    
                    pm.Parent_Account__c =
                        parentAccountMap.get(pm.SAP_Account_Number__c);
                    changed = true;
                }
            
            if (pm.Customer_Account__c == null &&
                pm.SAP_Account_Number_Child__c != null &&
                childAccountMap.containsKey(pm.SAP_Account_Number_Child__c)) {
                    
                    pm.Customer_Account__c =
                        childAccountMap.get(pm.SAP_Account_Number_Child__c);
                    changed = true;
                }
            
            if (pm.Product__c == null &&
                pm.SAP_Material_Number__c != null &&
                productMap.containsKey(pm.SAP_Material_Number__c)) {
                    
                    pm.Product__c =
                        productMap.get(pm.SAP_Material_Number__c);
                    changed = true;
                }
            
            if (changed) {
                updates.add(pm);
            }
        }
        system.debug('pmrec to update:'+updates);
        system.debug('pmrec to update:'+updates.size());
        if (!updates.isEmpty()) {
           update updates;
        }
        
        /* =========================
SCENARIO-AWARE DEACTIVATION
========================= */
        
        Map<String, Pricing_Matrix__c> newKeyMap = new Map<String, Pricing_Matrix__c>();
        Set<String> newKeys = new Set<String>();
        
                /* =========================
           ACCOUNT + PRODUCT LOOKUPS
           ========================= */

        Set<Id> chaccountIds = new Set<Id>();
        Set<Id> PaaccountIds = new Set<Id>();
        Set<Id> productIds = new Set<Id>();
        Set<string> subCats    = new Set<string>();
        Set<string> cats       = new Set<string>();
        Set<string> catalogs   = new Set<string>();

        for (Pricing_Matrix__c pm : scope) {

            if (pm.Customer_Account__c != null)
                chaccountIds.add(pm.Customer_Account__c);
            else if (pm.Parent_Account__c != null)
                PaaccountIds.add(pm.Parent_Account__c);

            if (pm.Product__c != null)
                productIds.add(pm.Product__c);

            if (pm.Product_Sub_Category__c != null)
                subCats.add(pm.Product_Sub_Category__c);

            if (pm.Product_Category_CIT__c != null)
                cats.add(pm.Product_Category_CIT__c);

            if (pm.Product_Catalog__c != null)
                catalogs.add(pm.Product_Catalog__c);
        }

        /* =========================
           BUILD NEW KEYS
           ========================= */


        for (Pricing_Matrix__c pm : scope) {
            String key = buildPricingKey(pm);
            if (key != null) {
                newKeys.add(key);
            }
        }
		system.debug('newKeys:'+newKeys);
        if (newKeys.isEmpty()) return;

        /* =========================
           SCOPED QUERY (FIX)
           ========================= */

        List<Pricing_Matrix__c> oldActive = [
            SELECT Id,
                   Active__c,
                   Parent_Account__c,
                   Customer_Account__c,
                   Product__c,
                   Product_Sub_Category__c,
                   Product_Category_CIT__c,
                   Product_Catalog__c,
                   NET_Price__c,
                   Product_Discount__c
            FROM Pricing_Matrix__c
            WHERE Active__c = true
            AND Id NOT IN :scope
            AND (
                Parent_Account__c IN :PaaccountIds
                OR Customer_Account__c IN :chaccountIds
            )
            AND (
                Product__c IN :productIds
                OR Product_Sub_Category__c IN :subCats 
                OR Product_Category_CIT__c IN :cats
                OR  Product_Catalog__c IN :catalogs
                
            )
        ];

        /* =========================
           DEACTIVATE MATCHES
           ========================= */

        List<Pricing_Matrix__c> deactivate = new List<Pricing_Matrix__c>();

        for (Pricing_Matrix__c oldPm : oldActive) {
            
            String oldKey = buildPricingKey(oldPm);
            system.debug('oldKey:'+oldKey);
            if (oldKey != null && newKeys.contains(oldKey)) {
                oldPm.Active__c = false;
                deactivate.add(oldPm);
            }
        }

        if (!deactivate.isEmpty()) {
            update deactivate;
        }
        
        
    }
    
    
    
    
    
    
    
    global void finish(Database.BatchableContext bc) {
        System.debug('Pricing Matrix lookup mapping completed.');
    }
    
    
    /* =========================
KEY BUILDER (CORE LOGIC)
========================= */
    private static String buildPricingKey(Pricing_Matrix__c pm) {
        
        Id accountId = pm.Customer_Account__c != null
            ? pm.Customer_Account__c
            : pm.Parent_Account__c;
        
        if (accountId == null) return null;
        
        // MATERIAL
        if (pm.Product__c != null &&
            (pm.NET_Price__c != null || pm.Product_Discount__c != null)) {
                
                return accountId + '|MAT|' + pm.Product__c;
            }
        
        // SUB CATEGORY
        if (pm.Product_Sub_Category__c != null) {
            return accountId + '|SUB|' + pm.Product_Sub_Category__c;
        }
        
        // CATEGORY + CATALOG
        if (pm.Product_Category_CIT__c != null &&
            pm.Product_Catalog__c != null) {
                
                return accountId + '|CAT|' +
                    pm.Product_Category_CIT__c + '|' +
                    pm.Product_Catalog__c;
            }
        
        return null;
    }
}