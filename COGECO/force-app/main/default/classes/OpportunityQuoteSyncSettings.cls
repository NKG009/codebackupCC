public without sharing class OpportunityQuoteSyncSettings {
    @testVisible private List<Opportunity_Quote_Sync_Setting__mdt> syncSettings;
    @testVisible private Set<String> attributesToSync;
    private String scopeObject;
    
    public OpportunityQuoteSyncSettings() {
        this.attributesToSync = new Set<String>();
    }
    
    public OpportunityQuoteSyncSettings(String scopeObject) {
        this.scopeObject = scopeObject;
        this.attributesToSync = new Set<String>();
    }
    
    public void initializeSyncSettings() {
        this.getOpportunityQuoteSyncSettings();
        this.buildAttributeSyncCollection();
    }
    
     @testVisible private void getOpportunityQuoteSyncSettings() {
        this.syncSettings = [SELECT Id, Scope_Field__r.QualifiedApiName, Target_Object__r.QualifiedApiName, Target_Field__r.QualifiedApiName 
                FROM Opportunity_Quote_Sync_Setting__mdt 
                WHERE Active__c = TRUE AND Scope_Object__r.QualifiedApiName = :this.scopeObject];
        
        System.debug(this.syncSettings);
    }
    
    @testVisible private void buildAttributeSyncCollection() {
        Set<String> attributes = new Set<String>();
        
        for (Opportunity_Quote_Sync_Setting__mdt syncSetting : this.syncSettings) {
            attributes.add(syncSetting.Scope_Field__r.QualifiedApiName);
        }
        
        attributes.remove(null);
        
        this.attributesToSync = attributes;
        System.debug(attributes);
    }
    
    public List<Opportunity_Quote_Sync_Setting__mdt> getSyncSettings() {
        return this.syncSettings;
    }
    
    public Set<String> getAttributesToSync() {
        return this.attributesToSync;
    }
    
    public String getScopeObject() {
        return this.scopeObject;
    }
}