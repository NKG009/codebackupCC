@isTest
public class ConfigHelperCustomTC {
static testMethod void testConfigHelper() {
        
       
        TRGTFCMS__CustomSettingsComponent__c testConfig = ConfigHelperCustom.getConfigDataSet();
        //System.assertNotEquals(null, testConfig);
        Object testObject = ConfigHelperCustom.getConfigSetting('Name');
        System.assertNotEquals('', (String)testObject);
        ConfigHelperCustom.setConfigSetting('Name', 'test_Name');

        ConfigHelperCustom.setConfigSetting('TRGTFCMS__email_address__c', '');
        ConfigHelperCustom.setConfigSetting('TRGTFCMS__email_address__c', 'SomeValue@email.com');
        ConfigHelperCustom.getConfigDataSetFromVendor();
        ConfigHelperCustom.getConfigHierarchySetting('Name');
    //  ConfigHelperCustom.setConfigHierarchySetting('Name', 'test');
        TRGTFCMS__Vendor_Portal_Settings__c testConfig1 = ConfigHelperCustom.getConfigDataSetFromVendor();
        TRGTFCMS__HierarchySettingsClientPortal__c testConfig2 = ConfigHelperCustom.getDataSet();
        TRGTFCMS__HierarchySettingsClientPortal__c testConfig33 = new TRGTFCMS__HierarchySettingsClientPortal__c();
        
        ConfigHelperCustom.getConfigHierarchySetting('TRGTFCMS__Candidate_List_Columns__c');
        ConfigHelperCustom.setConfigHierarchyDataSet('TRGTFCMS__Job_Alert_Account_ID__c','');
        
        
    }
}