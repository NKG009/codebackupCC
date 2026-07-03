public without sharing class AssetCleanupBatch implements Database.Batchable<SObject> {
    
    General_Settings__c custSetting = General_Settings__c.getInstance();
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        List<String> inactiveAssetStatus;
        try {
            inactiveAssetStatus = custSetting.Inactive_Asset_Status__c.split(ApexConstants.COMMA);
        } catch (Exception e) {
            inactiveAssetStatus = new List<String>();
        }
    
        String query = 'SELECT Id FROM Asset WHERE vlocity_cmt__ProvisioningStatus__c != null AND vlocity_cmt__ProvisioningStatus__c IN :inactiveAssetStatus';
        
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<SObject> scope) {
        if (scope == null || scope.isEmpty()) {
            return;
        }
        
        Database.delete(scope);
    }
    
    public void finish(Database.BatchableContext context) {
        
    }
}