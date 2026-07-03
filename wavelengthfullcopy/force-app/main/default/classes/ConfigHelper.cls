// Used to get values from Config object
global without sharing class ConfigHelper {
	
	global static TRGTFCMS__CustomSettingsComponent__c getConfigDataSet() {
		return TRGTFCMS__CustomSettingsComponent__c.getValues('Default');
	}
	
	// Gets config record by config name.
	public static Object getConfigSetting(String configName) {
		TRGTFCMS__CustomSettingsComponent__c config = getConfigDataSet();
		return (config != null) ? config.get(configName) : null;
	}
	
	public static void setConfigSetting(String configName, Object value) {
		TRGTFCMS__CustomSettingsComponent__c config = getConfigDataSet();
		if (config == null) {
			config = setConfigDataSet(configName, value);
		} else {
			config.put(configName, value);
			update config;
		}
	}
	
	private static TRGTFCMS__CustomSettingsComponent__c setConfigDataSet(String configName, Object value) {
		TRGTFCMS__CustomSettingsComponent__c config = new TRGTFCMS__CustomSettingsComponent__c(
				Name = 'Default');
		config.put(configName, value);
		insert config;
		
		return config;
	}
	
	/**
	* @author Sergey Prishepo
	* @date 02/04/2013
	* @description It's code get custom settings for Vendor profile.
	* @return Vendor_Portal_Settings__c object custom setting hierarchy, Record Default Organization Level Value which use Vendor Profile.
	*/
	public static TRGTFCMS__Vendor_Portal_Settings__c getConfigDataSetFromVendor() {
		return TRGTFCMS__Vendor_Portal_Settings__c.getOrgDefaults();
	}
	
	public static TRGTFCMS__HierarchySettingsClientPortal__c getDataSet() {
		return TRGTFCMS__HierarchySettingsClientPortal__c.getOrgDefaults();
	}
	
	public static Object getConfigHierarchySetting(String configName) {
		
		TRGTFCMS__HierarchySettingsClientPortal__c config = getDataSet();
		
		return (config != null) ? config.get(configName) : null;
	}
	
	public static void setConfigHierarchySetting(String configName, Object value) {
		
		TRGTFCMS__HierarchySettingsClientPortal__c config = getDataSet();
		
		if (config == null) {
			config = setConfigHierarchyDataSet(configName, value);
		} else {
			config.put(configName, value);
			update config;
		}
	}
@testvisible
	private static TRGTFCMS__HierarchySettingsClientPortal__c setConfigHierarchyDataSet(
			String configName, Object value) {
		
		Organization org = [
				SELECT Id
				FROM Organization];
		
		TRGTFCMS__HierarchySettingsClientPortal__c config = new TRGTFCMS__HierarchySettingsClientPortal__c(
				SetupOwnerId = org.Id);
		
		config.put(configName, value);
		insert config;
		
		return config;
	}
}