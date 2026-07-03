public without sharing class JobContractSyncHandler extends RecordSync {
    private static Id staffingJobId = Schema.SObjectType.AVTRRT__Job__c.getRecordTypeInfosByDeveloperName().get(Constants.RECORD_TYPE_STAFFING_JOB)?.getRecordTypeId();
    public override Schema.DescribeSObjectResult getObjectType() {
        return Schema.SObjectType.kruvi_staff__Contract__c;
    }

    public override Schema.DescribeFieldResult getChildRelationalField() {
        return Schema.SObjectType.kruvi_staff__Contract__c.fields.TR_Job__c;
    }

    public override Schema.DescribeFieldResult getParentRelationalField() {
        return Schema.SObjectType.AVTRRT__Job__c.fields.Isimio_Contract__c;
    }

    public override Boolean shouldSync(SObject record) {
        AVTRRT__Job__c job = (AVTRRT__Job__c)record;
        return job.AVTRRT__Account_Job__c != null;
    }

    public override Map<String, Object> getFieldMapping() {
        return new Map<String, Object> {
            'kruvi_staff__Account__c' => AVTRRT__Job__c.fields.AVTRRT__Account_Job__c,
            'kruvi_staff__Approver__c' => AVTRRT__Job__c.fields.Time_Approver__c,
            'kruvi_staff__Client_Contact__c' => AVTRRT__Job__c.fields.AVTRRT__Hiring_Manager__c,
            'Name' => AVTRRT__Job__c.fields.AVTRRT__Job_Title__c,
            'kruvi_staff__Schedule__c' => 'Mon-Sun', //AVTRRT__Job__c.fields.Work_Week__c,
            'TR_Job__c' => AVTRRT__Job__c.fields.Id,
            'kruvi_staff__Bill_Rate__c' => AVTRRT__Job__c.fields.Rate_Card__c,
            'kruvi_staff__Automatic_Placements__c' => true //Optional
        };
    }
}