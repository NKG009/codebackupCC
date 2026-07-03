public without sharing class PlacementSyncHandler extends RecordSync {
    public override Schema.DescribeSObjectResult getObjectType() {
        return Schema.SObjectType.kruvi_staff__Open_Placement__c;
    }

    public override Schema.DescribeFieldResult getChildRelationalField() {
        return Schema.SObjectType.kruvi_staff__Open_Placement__c.fields.TR_Placement__c;
    }

    public override Schema.DescribeFieldResult getParentRelationalField() {
        return Schema.SObjectType.AVTRRT__Placement__c.fields.Isimio_Placement__c;
    }

    public override Boolean shouldSync(SObject record) {
        AVTRRT__Placement__c placement = (AVTRRT__Placement__c)record;
        return placement.Isimio_Contract__c != null && placement.AVTRRT__Start_Date__c != null;
    }

    public override Map<String, Object> getFieldMapping() {
        return new Map<String, Object> {
            'kruvi_staff__Candidate__c' => AVTRRT__Placement__c.fields.AVTRRT__Contact_Candidate__c,
            'kruvi_staff__Contract__c' => AVTRRT__Placement__c.fields.Isimio_Contract__c,
            'kruvi_staff__Start_Date__c' => AVTRRT__Placement__c.fields.AVTRRT__Start_Date__c,
            'kruvi_staff__End_Date__c' => AVTRRT__Placement__c.fields.AVTRRT__End_Date__c,
            'TR_Placement__c' => AVTRRT__Placement__c.fields.Id,
            'kruvi_staff__Generate_Timesheets__c' => true
        };
    }
}