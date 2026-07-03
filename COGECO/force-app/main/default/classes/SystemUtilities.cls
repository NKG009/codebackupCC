public without sharing class SystemUtilities {
    private static final String SOURCE_IP = 'SourceIp';
    
	/**
     * @description  Returns a map of fields to the developer from a fieldset
     * @param fieldSetName  The API names of the field set requested to be read
     * @param objectName  The API name of the object to find the fieldset against
     * @return  A map of fields from the specified object and fieldset. The key is the API name of the field, with the value being the label of the field
     * @note  If a fieldset is not found with the provided API name, an empty map will be returned
     */
    public static Map<String, String> getFieldApiNameAndLabelFromFieldSet(String fieldSetName, String objectApiName) {
        if (String.isBlank(fieldSetName)) {
            return null;
        }
        if (String.isBlank(objectApiName)) {
            return null;
        }
        Map<String, String> fieldApiNameAndLabel = new Map<String, String>();
        Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectApiName);
        Schema.DescribeSObjectResult describeSObjectResultGeneric = sObjectType.getDescribe();
        Schema.FieldSet fieldSetGeneric = describeSObjectResultGeneric.FieldSets.getMap().get(fieldSetName);
        if (fieldSetGeneric != null) {
            for (Schema.FieldSetMember fieldSetMemberGeneric : fieldSetGeneric.getFields()) {
                fieldApiNameAndLabel.put(fieldSetMemberGeneric.getFieldPath(), fieldSetMemberGeneric.getLabel());
            }
        }

        return fieldApiNameAndLabel; 
    }
    
    public static Map<String, Schema.SObjectField> getMetadataOfFieldsOnObject(String objectApiName) {
        return Schema.getGlobalDescribe().get(objectApiName)?.getDescribe().fields.getMap();
    }
    
    public static Schema.SoapType getFieldType(Schema.SObjectField objectField) {
        return objectField?.getDescribe().getSoapType();
    }
    
    public static OrgWideEmailAddress getOrgWideEmailAddressId(String displayName) {
        return [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = :displayName LIMIT 1];
    }
    
    public static String getUserIPAddress() {
		Map<String, String> session = new Map<String, String> ();
		if(!Test.isRunningTest())
        session = Auth.SessionManagement.getCurrentSession();
        else
        session.put('SOURCE_IP','TestSession');
		    
        return session.get(SOURCE_IP);
    }
}