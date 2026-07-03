@isTest
private class ContentDocumentLinkTriggerTest {
    
    @isTest
    static void testInsertTrigger() {
        WorkOrder wo = new WorkOrder();
        wo.subject ='title';
        insert wo;

        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [
            SELECT Id, Title, LatestPublishedVersionId 
            FROM ContentDocument
        ];
        
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = wo.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
    }
}