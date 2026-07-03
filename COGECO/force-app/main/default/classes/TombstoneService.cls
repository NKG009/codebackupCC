public class TombstoneService {
	private String objectApiName;
    private Map<Id, Tombstone_Setting__mdt> tombStoneSettings;
    private Set<String> fieldApiNames;
    
    public TombstoneService(String objectApiName) {
        this.objectApiName = objectApiName;
        this.fieldApiNames = new Set<String>();
    }
    
    public void initializeTombstoneSettings() {
        this.tombStoneSettings = new Map<Id, Tombstone_Setting__mdt>([SELECT Id, Sort_Order__c, Section_Label__c, Field_Set_API_Name__c, Target_Object__r.QualifiedApiName FROM Tombstone_Setting__mdt WHERE Target_Object__r.QualifiedApiName = :this.objectApiName AND Active__c = TRUE ORDER BY Sort_Order__c NULLS LAST]);
    }
    
    public List<Tombstone_Field__mdt> getTombstoneFieldSettings() {
        return [SELECT Id, Sort_Order__c, Tombstone_Setting__c, Target_Object__r.QualifiedApiName, Target_Field__r.Label, Target_Field__r.QualifiedApiName, Label_Override__c FROM Tombstone_Field__mdt WHERE Tombstone_Setting__c IN :tombStoneSettings.keySet() AND Active__c = TRUE ORDER BY Sort_Order__c NULLS LAST];
    }
    
    public Map<Id, Tombstone_Setting__mdt> getTombStoneSettings() {
        return this.tombStoneSettings;
    }
    
    public void setFieldApiNames(Set<String> fieldApiNames) {
        this.fieldApiNames = fieldApiNames;
    }

    public void addFieldApiNames(Set<String> fieldsToAdd) {
        this.fieldApiNames.addAll(fieldsToAdd);
        this.fieldApiNames.remove(null);
    }

    public Set<String> getFieldApiNames() {
        return this.fieldApiNames;
    }
}