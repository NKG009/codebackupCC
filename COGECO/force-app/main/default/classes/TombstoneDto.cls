public without sharing class TombstoneDto {
    @AuraEnabled public String objectApiName {get;set;}
    @AuraEnabled public String spotlightValue {get;set;}
    @AuraEnabled public String highlightPhotoUrl {get;set;}
    @AuraEnabled public String subHighlightPhotoUrl {get;set;}
    @AuraEnabled public List<TombstoneSection> tombstoneSections {get;set;}
    
    public TombstoneDto() {
        this.tombstoneSections = new List<TombstoneSection>();
    }
    
    public TombstoneDto(String objectApiName) {
        this.objectApiName = objectApiName;
        
        this.tombstoneSections = new List<TombstoneSection>();
    }
    
    public TombstoneDto(String objectApiName, List<TombstoneSection> tombstoneSections) {
        this.objectApiName = objectApiName;
        this.tombstoneSections = tombstoneSections;
    }
    
    public class TombstoneSection {
        @AuraEnabled public String sectionName {get;set;}
        @AuraEnabled public List<TombstoneField> fields {get;set;}
        public String key {get;set;}
        
        public TombstoneSection() {
            this.fields = new List<TombstoneField>();
        }
        
        public TombstoneSection(String sectionName, String key) {
            this.sectionName = sectionName;
            this.key = key;
            
            this.fields = new List<TombstoneField>();
        }
        
        public TombstoneSection(String sectionName, List<TombstoneField> fields) {
            this.sectionName = sectionName;
            this.fields = fields;
        }
    }
    
    public class TombstoneField {
        @AuraEnabled public String fieldLabel {get;set;}
        @AuraEnabled public Object fieldValue {get;set;}
        @AuraEnabled public String fieldType {get;set;}
        
        public TombstoneField() { }
        
        public TombstoneField(String fieldLabel, Object fieldValue, String fieldType) {
            this.fieldLabel = fieldLabel;
            this.fieldValue = fieldValue;
            this.fieldType = fieldType;
        }
    }
}