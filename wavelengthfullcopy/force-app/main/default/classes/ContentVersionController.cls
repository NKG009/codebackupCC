public without sharing class ContentVersionController {
    @AuraEnabled(cacheable=true)
    public static List<ContentVersion> getContentVersions(String recordId) {
        
        List<ContentDocumentLink> documentLinks = [
            SELECT ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :recordId
        ];
        
        
        Set<Id> contentDocumentIds = new Set<Id>();
        for (ContentDocumentLink link : documentLinks) {
            contentDocumentIds.add(link.ContentDocumentId);
        }
        
        
        if (!contentDocumentIds.isEmpty()) {
            return [
                SELECT Id, Title, ContentDocumentId, CreatedDate, FileType, ContentSize, Owner.Name,CA_Image_Url_Link__c
                FROM ContentVersion
                WHERE ContentDocumentId IN :contentDocumentIds AND isLatest = true AND FileType!='SNOTE'
            ];
        } else {
            return new List<ContentVersion>();
        }
    }
    
    @AuraEnabled
    public static void updateContentVersion(Object data) {
        List < ContentVersion > filesForUpdate = ( List < ContentVersion > ) JSON.deserialize(
            JSON.serialize( data ),
            List < ContentVersion >.class
        );
        try {
            update filesForUpdate;
        } catch (DmlException e) {
            throw new AuraHandledException('Error updating records: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteContentDocument(String contentDocumentId) {
        ContentDocument cd = [SELECT Id FROM ContentDocument WHERE Id = :contentDocumentId];
        delete cd;
    }
}