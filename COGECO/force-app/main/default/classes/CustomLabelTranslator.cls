public without sharing class CustomLabelTranslator {
    private static final String ERR_NO_CUSTOM_LABELS_FOUND = 'ERR-001: At least one of the custom labels requested was not found';
        
    @AuraEnabled(cacheable=false)
    public static String translate(String language, String namespace, List<String> labels) {
        if (labels == null || labels.isEmpty()) {
            return null;
        }
        
        if (String.isBlank(language)) {
            language = UserInfo.getLanguage();
        }
        
        if (namespace == null) {
            namespace = '';
        }
        
        Map<String, String> labelValues = new Map<String, String>();

        try {
            for (String labelName : labels) {
                labelValues.put(labelName, System.Label.get(namespace, labelName, language));
            }

            labelValues.remove(null);            
            
            return JSON.serialize(labelValues);
        } catch (Exception e) {
            throw new AuraHandledException(ERR_NO_CUSTOM_LABELS_FOUND);
        }
    }
}