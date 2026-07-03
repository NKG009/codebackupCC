public with sharing class FileController {

    @AuraEnabled(cacheable=true)
    public static List<ContentDocument> getFiles(Id parentId) {
        try {
            List<ContentDocument> documents = new List<ContentDocument>();
            List<ContentDocumentLink> links = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :parentId];
            for (ContentDocumentLink link : links) {
                ContentDocument doc = [SELECT Id, Title, FileType,FileExtension, CreatedDate FROM ContentDocument WHERE Id = :link.ContentDocumentId ORDER BY CreatedDate DESC];
                documents.add(doc);
            }
            return documents;
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving files: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteFile(Id contentDocumentId) {
        try {
            delete [SELECT Id FROM ContentDocument WHERE Id = :contentDocumentId];
        } catch (Exception e) {
            throw new AuraHandledException('Error deleting file: ' + e.getMessage());
        }
    }
}