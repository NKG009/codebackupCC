@isTest
public class ConfigHelperTC {
static testMethod void testConfigHelper() {
        
       
        TRGTFCMS__CustomSettingsComponent__c testConfig = ConfigHelper.getConfigDataSet();
        //System.assertNotEquals(null, testConfig);
        Object testObject = ConfigHelper.getConfigSetting('Name');
        System.assertNotEquals('', (String)testObject);
        ConfigHelper.setConfigSetting('Name', 'test_Name');

        ConfigHelper.setConfigSetting('TRGTFCMS__email_address__c', '');
        ConfigHelper.setConfigSetting('TRGTFCMS__email_address__c', 'SomeValue@email.com');
        ConfigHelper.getConfigDataSetFromVendor();
        ConfigHelper.getConfigHierarchySetting('Name');
    //  ConfigHelper.setConfigHierarchySetting('Name', 'test');
        TRGTFCMS__Vendor_Portal_Settings__c testConfig1 = ConfigHelper.getConfigDataSetFromVendor();
        TRGTFCMS__HierarchySettingsClientPortal__c testConfig2 = ConfigHelper.getDataSet();
        TRGTFCMS__HierarchySettingsClientPortal__c testConfig33 = new TRGTFCMS__HierarchySettingsClientPortal__c();
        
        ConfigHelper.getConfigHierarchySetting('TRGTFCMS__Candidate_List_Columns__c');
        ConfigHelper.setConfigHierarchyDataSet('TRGTFCMS__Job_Alert_Account_ID__c','');
        
        
    }
}