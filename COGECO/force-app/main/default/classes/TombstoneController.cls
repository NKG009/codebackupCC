public with sharing class TombstoneController {
	@AuraEnabled
    public static TombstoneDto getTombstoneData(String objectApiName, Id recordId, String spotlghtFieldApiName, String highlightPhotoUrl, String subHighlightPhotoUrl) {
        TombstoneService tombstoneService = new TombstoneService(objectApiName);
        tombstoneService.initializeTombstoneSettings();
        
        Map<String, String> fieldApiNamesAndLabels = new Map<String, String>();
        Map<String, String> fieldApiNamesToSection = new Map<String, String>();
        
        TombstoneDto tombstone = new TombstoneDto(objectApiName);
        
        fieldApiNamesAndLabels.put(spotlghtFieldApiName, null);
        fieldApiNamesAndLabels.put(highlightPhotoUrl, null);
        fieldApiNamesAndLabels.put(subHighlightPhotoUrl, null);  
        
        //get fields
        for (Tombstone_Setting__mdt tombstoneSetting : tombstoneService.getTombStoneSettings().values()) {
            Map<String, String> fieldApiNamesAndLabelsFromCurrentFieldSet = SystemUtilities.getFieldApiNameAndLabelFromFieldSet(tombstoneSetting.Field_Set_API_Name__c, tombstoneSetting.Target_Object__r.QualifiedApiName);
            
            for (String fieldApiName : fieldApiNamesAndLabelsFromCurrentFieldSet.keySet()) {
            	fieldApiNamesToSection.put(fieldApiName, tombstoneSetting.Field_Set_API_Name__c);
            }
            
            tombstone.tombstoneSections.add(new TombstoneDto.TombstoneSection(
                System.Label.get(null, tombstoneSetting.Section_Label__c, UserInfo.getLanguage()),
                tombstoneSetting.Field_Set_API_Name__c
            ));
            
            fieldApiNamesAndLabels.putAll(fieldApiNamesAndLabelsFromCurrentFieldSet);
        }      
        
        fieldApiNamesToSection.remove(null);
        fieldApiNamesAndLabels.remove(null);
        
        //override labels        
        for (Tombstone_Field__mdt tombstoneField : tombstoneService.getTombstoneFieldSettings()) {
            if (String.isNotBlank(tombstoneField.Label_Override__c)) {
                fieldApiNamesAndLabels.put(tombstoneField.Target_Field__r.QualifiedApiName, System.Label.get(null, tombstoneField.Label_Override__c, UserInfo.getLanguage()));
            }
        }
        
        //get data
        SObject recordData = GenericDataService.getGenericDataFromRecordId(objectApiName, fieldApiNamesAndLabels.keySet(), recordId);
        
        //build sections
        Map<String, Schema.SObjectField> fieldsOnObject = SystemUtilities.getMetadataOfFieldsOnObject(objectApiName);
        List<Account> accountRecordExtraValues = AccountSelector.getAdditionalFieldsForTombstone(recordId);
        /*Set<String> billingAccountNumbers = AccountService.getBillingAccountNumbersFromBillingAccounts(AccountSelector.getAllActiveBillingAccountsFromCustomerAccount(recordId));
        String billingAccountNumbersJoined = null; 
        
        if (!billingAccountNumbers.isEmpty()) {
            billingAccountNumbersJoined = String.join(new List<String>(billingAccountNumbers), ApexConstants.HTML_BREAK);
        }

        Boolean billingAccountsSet = false;*/
        Boolean extraValuesSet = false;
        
        for (String fieldApiName : fieldApiNamesAndLabels.keySet()) {
            String sectionKey = fieldApiNamesToSection.get(fieldApiName);
            
            if (fieldApiName == spotlghtFieldApiName) {
                tombstone.spotlightValue = String.valueOf(recordData.get(fieldApiName));
                continue;
            } else if (fieldApiName == highlightPhotoUrl) {
                tombstone.highlightPhotoUrl = String.valueOf(recordData.get(fieldApiName));
                continue;
            } else if (fieldApiName == subHighlightPhotoUrl) {
                tombstone.subHighlightPhotoUrl = String.valueOf(recordData.get(fieldApiName));
                continue;
            }
            
            for (TombstoneDto.TombstoneSection tombstoneSection : tombstone.tombstoneSections) {
                if (sectionKey == tombstoneSection.key) {
                    if (!extraValuesSet) {
                        for (Account accountRecord : accountRecordExtraValues) {
                            tombstoneSection.fields.add(new TombstoneDto.TombstoneField(
                                SystemUtilities.getMetadataOfFieldsOnObject(ApexConstants.ACCOUNT_OBJECT_API_NAME)?.get(ApexConstants.ACCOUNT_STATUS_FIELD_API_NAME)?.getDescribe().getLabel(),
                                accountRecord.Account_Status__c,
                                null
                            ));
                        }

                        extraValuesSet = true;
                    }

                    /*if (!billingAccountsSet) {
                        tombstoneSection.fields.add(new TombstoneDto.TombstoneField(
                            Label.Billing_Account_Number,
                            billingAccountNumbersJoined,
                            null
                        ));

                        billingAccountsSet = true;
                    }*/

                    List<String> relationshipSplit = new List<String>();

                    if (fieldApiName.contains(ApexConstants.RELATIONSHIP_FIELD_SUFFIX) || fieldApiName.contains(ApexConstants.DOT)) {
                        relationshipSplit = fieldApiName.split(ApexConstants.RELATIONSHIP_SPLIT_DELIMITER);
                    }
    
                    Object fieldValue = relationshipSplit.isEmpty()
                        ? recordData.get(fieldApiName)
                        : recordData.getSObject(relationshipSplit[0])?.get(relationshipSplit[1]);
                    
                    tombstoneSection.fields.add(new TombstoneDto.TombstoneField(
                    	fieldApiNamesAndLabels.get(fieldApiName),
                        fieldValue,
                        String.valueOf(SystemUtilities.getFieldType(fieldsOnObject.get(fieldApiName)))
                    ));
                }
            }
        }
        
        return tombstone;
    }
}