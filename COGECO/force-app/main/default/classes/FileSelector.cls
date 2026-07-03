public inherited sharing class FileSelector {
    public static List<ContentDocumentLink> getContentDocumentLinkForCustomerApproval(Id linkedEntityId) {
        Set<String> titleQuery = new Set<String>{
            ApexConstants.CONTENT_DOCUMENT_TITLE_LIKE_EN_PREFIX,
            ApexConstants.CONTENT_DOCUMENT_TITLE_LIKE_FR_PREFIX
        };
            
        return [SELECT ContentDocumentId, LinkedEntityId, ContentDocument.Title 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId = :linkedEntityId 
                AND ContentDocument.Title LIKE :titleQuery ORDER BY SystemModstamp DESC LIMIT 1];
    }
    
    public static List<ContentDocumentLink> getContentDocumentLinksFromContentDocumentIds(Set<Id> contentDocumentIds) {
        return [SELECT ContentDocumentId, LinkedEntityId, ContentDocument.Title 
                FROM ContentDocumentLink 
                WHERE ContentDocumentId IN :contentDocumentIds];
    }
    
    public static List<ContentDocumentLink> getContentDocumentLinksFromRelatedRecords(Set<Id> recordIds) {
        return [SELECT ContentDocumentId, LinkedEntityId, ContentDocument.Title, ShareType, Visibility 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId IN :recordIds];
    }
    
    public static List<ContentDocument> getContentDocumentsByIds(Set<Id> contentDocumentIds) {
        return [SELECT Id, Title FROM ContentDocument WHERE Id = :contentDocumentIds];
    }
    
    public static List<ContentVersion> getContentVersionsByContentDocumentIds(Set<Id> contentDocumentIds) {
        return [SELECT Id, Title, FileType, VersionData, IsLatest, ContentDocumentId, FileExtension, Description FROM ContentVersion WHERE IsLatest = TRUE AND ContentDocumentId IN :contentDocumentIds];
    }
    
    public static List<ContentVersion> getContentVersionsByContentVersionIds(Set<Id> contentVersionIds) {
        return [SELECT Id, Title, FileType, VersionData, IsLatest, ContentDocumentId FROM ContentVersion WHERE IsLatest = TRUE AND Id IN :contentVersionIds];
    }
    
    public static List<ContentDistribution> getPublicUrls(Set<Id> contentDocumentIds) {
        return [SELECT Id, ContentDocumentId, ContentDownloadUrl, DistributionPublicUrl, ContentVersion.Title, ContentVersion.FileType FROM ContentDistribution WHERE ContentDocumentId IN :contentDocumentIds];
    }
    
    public static List<ContentDistribution> getContentDistributionByIds(Set<Id> distributionIds) {
        return [SELECT Id, RelatedRecordId, ContentVersion.Title, ContentVersion.FileType, ContentDownloadUrl FROM ContentDistribution WHERE Id IN :distributionIds];
    }
    
    public static List<ContentFolderMember> getContentFolderMembersFromFolderId(Id languageFolderId) {
        return [SELECT ChildRecordId FROM ContentFolderMember WHERE ParentContentFolderId = :languageFolderId];
    }
}