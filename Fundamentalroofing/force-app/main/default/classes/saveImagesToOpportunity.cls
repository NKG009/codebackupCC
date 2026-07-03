public with sharing class saveImagesToOpportunity {
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getRichTextFields(Id oppId) {
        Opportunity opp = [
            SELECT Image_1__c, Image_2__c
            FROM Opportunity
            WHERE Id = :oppId
            LIMIT 1
        ];
        return new Map<String, String>{
            'rtf1' => opp.Image_1__c,
            'rtf2' => opp.Image_2__c
        };
    }

    @AuraEnabled
    public static void savePdfToOpportunity(Id oppId, String fileName, String base64Data) {
        ContentVersion cv = new ContentVersion();
        cv.Title = fileName;
        cv.PathOnClient = fileName;
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        insert cv;

        Id docId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = docId;
        cdl.LinkedEntityId = oppId;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
    }
}