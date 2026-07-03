@isTest
private class OpportunityQuoteSyncSettingsTest {

    @isTest
    static void testInitializeSyncSettings() {
        // how to create test data? DML operation doesnt work on metadata

        List<Opportunity_Quote_Sync_Setting__mdt> syncSettings = [SELECT Id, Scope_Field__r.QualifiedApiName, Target_Object__r.QualifiedApiName, Target_Field__r.QualifiedApiName FROM Opportunity_Quote_Sync_Setting__mdt];
        
        OpportunityQuoteSyncSettings settings = new OpportunityQuoteSyncSettings();
        Test.startTest();
        settings.initializeSyncSettings();
        Test.stopTest();
        
        //System.assertEquals(0, settings.getOpportunityQuoteSyncSettings()[0]);
        System.assertEquals(0, settings.getAttributesToSync().size());
    }

    @isTest
    static void testBuildAttributeSyncCollection() {
        
        
        OpportunityQuoteSyncSettings settings = new OpportunityQuoteSyncSettings();
        settings.syncSettings = new List<Opportunity_Quote_Sync_Setting__mdt>{
            // Create test records??
        };
        
        Test.startTest();
        settings.buildAttributeSyncCollection();
        Test.stopTest();
        
        System.assertEquals(0, settings.getAttributesToSync().size());
    }
}