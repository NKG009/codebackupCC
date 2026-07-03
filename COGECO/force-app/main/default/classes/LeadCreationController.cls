public with sharing class LeadCreationController {

    @AuraEnabled
    public static Id createLead(Map<String, Object> formData) {
        // Validate and get Spotio record type id
        RecordType rt = [
            SELECT Id 
            FROM RecordType 
            WHERE SObjectType = 'Lead' AND Name = 'Spotio' 
            LIMIT 1
        ];

        Lead newLead = new Lead(
            RecordTypeId = rt.Id,
            LastName = (String)formData.get('Contact_Name_Lead_Form__c'), // required
            REP_ID__c = (String)formData.get('REP_ID__c'),
            Business_Name__c = (String)formData.get('Business_Name__c'),
            Company = (String)formData.get('Business_Name__c'),
            Business_Phone1__c = (String)formData.get('Business_Phone1__c'),
            Service_Address_Lead_Form__c = (String)formData.get('Service_Address_Lead_Form__c'),
            Postal_Code__c = (String)formData.get('Postal_Code__c'),
            Billing_Address_Lead_Form__c = (String)formData.get('Billing_Address_Lead_Form__c'),
            Contact_Name_Lead_Form__c = (String)formData.get('Contact_Name_Lead_Form__c'),
            Contact_Role__c = (String)formData.get('Contact_Role__c'),
            Contact_Phone__c = (String)formData.get('Contact_Phone__c'),
            Contact_Email__c = (String)formData.get('Contact_Email__c'),
            Internet_Sold__c = (String)formData.get('Internet_Sold__c'),
            Speed__c = (String)formData.get('Speed__c'),
            Internet_Term__c = (String)formData.get('Internet_Term__c'),
            Configuration__c = (String)formData.get('Configuration__c'),
            Wi_Fi_Type__c = (String)formData.get('Wi_Fi_Type__c'),
            WiFi_6_Extenders_Required__c = (String)formData.get('WiFi_6_Extenders_Required__c'),
            Total_Internet_MRR__c = parseDecimalField(formData, 'Total_Internet_MRR__c'),
            Voice_Sold__c = (String)formData.get('Voice_Sold__c'),
            of_Lines__c = parseDecimalField(formData, 'of_Lines__c'),
            Voice_Term__c = (String)formData.get('Voice_Term__c'),
            Number_Type__c = (String)formData.get('Number_Type__c'),
            Total_Voice_MRR__c = parseDecimalField(formData, 'Total_Voice_MRR__c'),
            Video_Sold__c = (String)formData.get('Video_Sold__c'),
            // NEW FIELDS
            Package__c = (String)formData.get('Package__c'),
            Video_Term__c = (String)formData.get('Video_Term__c'),
            Number_of_Boxes_Required__c = parseDecimalField(formData, 'Number_of_Boxes_Required__c'),
            List_any_additional_channels_packages_to__c = (String)formData.get('List_any_additional_channels_packages_to__c'),
            Total_Video_MRC__c = parseDecimalField(formData, 'Total_Video_MRC__c'),
            Professional_Install_Fee__c = parseDecimalField(formData, 'Professional_Install_Fee__c'),
            Additional_Comments__c = (String)formData.get('Additional_Comments__c'),
            Rep_Email__c = (String)formData.get('Rep_Email__c'),
            Rep_Name__c = (String)formData.get('Rep_Name__c')
        );

        insert newLead;
        return newLead.Id;
    }

    /**
     * Upload files as ContentVersion and link to Lead
     */
    @AuraEnabled
    public static void uploadFiles(Id leadId, List<Map<String, String>> files) {
        if (leadId == null || files == null || files.isEmpty()) {
            throw new AuraHandledException('No files or Lead ID provided.');
        }

        List<ContentVersion> contentVersions = new List<ContentVersion>();
        for (Map<String, String> fileMap : files) {
            String fileName = fileMap.get('fileName');
            String base64Data = fileMap.get('base64Data');
            String contentType = fileMap.get('contentType');
            if (String.isBlank(fileName) || String.isBlank(base64Data)) continue;

            ContentVersion cv = new ContentVersion();
            cv.Title = fileName;
            cv.PathOnClient = fileName;
            cv.VersionData = EncodingUtil.base64Decode(base64Data);
            cv.Description = 'Uploaded from B2B-D2D LWC form';
            contentVersions.add(cv);
        }

        insert contentVersions;

        // Link ContentDocuments to Lead
        List<ContentDocumentLink> links = new List<ContentDocumentLink>();
        for (ContentVersion cv : [
            SELECT Id, ContentDocumentId 
            FROM ContentVersion 
            WHERE Id IN :contentVersions
        ]) {
            links.add(new ContentDocumentLink(
                ContentDocumentId = cv.ContentDocumentId,
                LinkedEntityId = leadId,
                ShareType = 'V',  // Viewer access
                Visibility = 'AllUsers'
            ));
        }
        insert links;
    }

    // Helper to safely parse numeric fields from the incoming map
    private static Decimal parseDecimalField(Map<String, Object> formData, String key) {
        if (formData == null || !formData.containsKey(key)) return null;
        Object val = formData.get(key);
        if (val == null) return null;
        String s = String.valueOf(val);
        if (String.isBlank(s)) return null;
        try {
            return Decimal.valueOf(s);
        } catch (Exception e) {
            // If parse fails, return null (or you can choose to throw a validation exception)
            return null;
        }
    }
}