public with sharing class VMSConfigController {
    
    @AuraEnabled(cacheable=true)
    public static List<sirenum__Site__c> getSitesForAccount(Id accountId, String searchTerm) {
        // If searchTerm is provided, filter based on the term
        String query = 'SELECT sirenum__Operating_Company__c, Id, Name, Additional_SLA__c, IP_MainContact__c, '
            + 'sirenum__Street_Address__c, sirenum__City__c, sirenum__Postal_Code__c, '
            + 'Additional_Supplier_Flat_Fee__c, Additional_Supplier_Percentage_Fee__c '
            + 'FROM sirenum__Site__c '
            + 'WHERE sirenum__Operating_Company__c = :accountId';
        
        if (String.isNotBlank(searchTerm)) {
            query += ' AND Name LIKE :\'%' + searchTerm + '%\'';
        }
        
        return Database.query(query);
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Suppliers__c> getSuppliersForAccount(Id accountId, Id siteId) {
        return [
            SELECT Id, Name, Account__c, Account__r.Name, Active__c, SLA__c, Supplier__c, Supplier__r.Name, Override__c,
            (SELECT Id, Tier__c FROM Site_Supplier_Links__r WHERE Site__c = :siteId) 
            FROM Suppliers__c
            WHERE Account__c = :accountId
        ];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<sirenum__JobOrder__c > getJobOrderforSite(Id accountId, Id siteId) {
        return [
            SELECT Id, sirenum__Site__c, sirenum__Account__c, sirenum__JobRole__c,sirenum__StartDate__c,sirenum__EndDate__c,
            sirenum__Site__r.Name, sirenum__Account__r.Name, sirenum__JobRole__r.Name, Name, Override__c FROM sirenum__JobOrder__c 
            WHERE sirenum__Site__c  = :siteId
        ];
    }
    
    
    @AuraEnabled(cacheable=true) 
    public static List<sirenum__Site__c> featchSiteData(Id selectedSiteId) {
        return [
            SELECT sirenum__Operating_Company__c, Id, Name, Additional_SLA__c, IP_MainContact__c,IP_MainContact__r.Name,
            sirenum__Street_Address__c, sirenum__City__c, sirenum__Postal_Code__c,
            Additional_Supplier_Flat_Fee__c, Additional_Supplier_Percentage_Fee__c
            FROM sirenum__Site__c
            WHERE Id = :selectedSiteId
        ];
    }
    
    @AuraEnabled
    public static String saveSupplierTiers(Id siteId, List<Map<String, String>> updates) {
        List<Site_Supplier_Link__c> recordsToUpsert = new List<Site_Supplier_Link__c>();
        List<Site_Supplier_Link__c> recordsToDeactivate = new List<Site_Supplier_Link__c>();
        List<Suppliers__c> suppliersToUpdate = new List<Suppliers__c>();
        
        // Query VMS_Tier_Config__mdt to get Tier and SLA__c mappings
        Map<String, Decimal> tierToSLA = new Map<String, Decimal>();
        List<VMS_Tier_Config__mdt> tierConfigs = [SELECT Id, Label, SLA__c, Tier__c FROM VMS_Tier_Config__mdt];
        for (VMS_Tier_Config__mdt tierConfig : tierConfigs) {
            tierToSLA.put(tierConfig.Tier__c, tierConfig.SLA__c);
        }
        
        for (Map<String, String> updatee : updates) {
            String supplierId = updatee.get('supplierId');
            String tier = updatee.get('tier');
            
            // Handle Site_Supplier_Link__c records
            List<Site_Supplier_Link__c> existingRecords = [
                SELECT Id, Site__c, Suppliers__c, Active__c, Tier__c
                FROM Site_Supplier_Link__c
                WHERE Site__c = :siteId
                AND Suppliers__c = :supplierId
            ];
            
            if (!existingRecords.isEmpty()) {
                for (Site_Supplier_Link__c record : existingRecords) {
                    if (String.isBlank(tier)) { 
                        // If tier is blank and old value exists, deactivate the record
                        if (!String.isBlank(record.Tier__c)) {
                            record.Active__c = false;
                            record.Tier__c = null;
                            recordsToDeactivate.add(record);
                        }
                    } else if (record.Tier__c != tier) { 
                        // If tier is changed, update the record
                        record.Tier__c = tier;
                        record.Active__c = true;
                        recordsToUpsert.add(record);
                    }
                }
            } else if (!String.isBlank(tier)) { 
                // If no record exists and a valid tier is provided, create a new record
                recordsToUpsert.add(new Site_Supplier_Link__c(
                    Site__c = siteId,
                    Suppliers__c = supplierId,
                    Active__c = true,
                    Tier__c = tier
                ));
            }
            
            // Only update supplier SLA if tier is NOT blank
            if (!String.isBlank(tier)) {
                // Get SLA value from map (returns Decimal)
                Decimal sla = tierToSLA.get(tier);
                
                if (sla != null) {
                    Suppliers__c supplier = [
                        SELECT Id, Name, Account__c, Active__c, SLA__c, Supplier__c, Override__c
                        FROM Suppliers__c
                        WHERE Id = :supplierId
                        LIMIT 1
                    ];
                    
                    // If supplier exists and SLA__c is different, update it
                    if (supplier != null && supplier.SLA__c != sla) {
                        supplier.SLA__c = sla;
                        suppliersToUpdate.add(supplier);
                    }
                }
                
                
            }
        }
        
        // Perform DML operations outside loops
        if (!recordsToUpsert.isEmpty()) {
            upsert recordsToUpsert;
        }
        
        if (!recordsToDeactivate.isEmpty()) {
            update recordsToDeactivate;
        }
        
        if (!suppliersToUpdate.isEmpty()) {
            update suppliersToUpdate;
        }
        
        return 'Supplier successfully updated!';
    }
    
    
    
    @AuraEnabled
    public static String updateSupplierOverrides(List<Map<String, Object>> updates) {
        List<Suppliers__c> recordsToUpdate = new List<Suppliers__c>();
        
        for (Map<String, Object> updatee : updates) {
            Id supplierId = (Id) updatee.get('supplierId');
            Boolean overrideValue = (Boolean) updatee.get('override');
            
            Suppliers__c supplier = new Suppliers__c(
                Id = supplierId,
                Override__c = overrideValue
            );
            recordsToUpdate.add(supplier);
        }
        
        if (!recordsToUpdate.isEmpty()) {
            update recordsToUpdate;
        }
        
        return 'Supplier overrides have been successfully updated!';
    }
    
    @AuraEnabled
    public static String updateJobOrderOverrides(Id selectedSiteId, Boolean overrideValue) {
        List<sirenum__JobOrder__c> jobOrdersToUpdate = [
            SELECT Id, Override__c 
            FROM sirenum__JobOrder__c 
            WHERE sirenum__Site__c = :selectedSiteId
        ];
        
        if (jobOrdersToUpdate.isEmpty()) {
            return 'No job orders found for this site.';
        }
        
        for (sirenum__JobOrder__c jobOrder : jobOrdersToUpdate) {
            jobOrder.Override__c = overrideValue;
        }
        
        update jobOrdersToUpdate;
        return 'Job order overrides updated successfully!';
    }
    
    
    
    
}