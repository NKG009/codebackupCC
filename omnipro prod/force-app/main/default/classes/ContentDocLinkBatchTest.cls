@isTest
public class ContentDocLinkBatchTest {
                @testSetup
        static void setup() {
                   

            List<Knowledge__kav> articles = new List<Knowledge__kav>();
            for (Integer i = 1; i <= 10; i++) {
                Knowledge__kav ka = new Knowledge__kav();
                ka.Title = 'Test Article ' + i;
                ka.UrlName = 'test-article-' + i;
                ka.Language = 'en_US';
                articles.add(ka);
            }
            insert articles;
            
           
            Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body for testing.');
            ContentVersion cv = new ContentVersion(
                Title = 'SampleTitle',
                PathOnClient = 'SampleTitle.jpg',
                VersionData = bodyBlob
            );
            insert cv;
            
           
            ContentVersion insertedContentVersion = [
                SELECT ContentDocumentId
                FROM ContentVersion
                WHERE Id = :cv.Id
                LIMIT 1
            ];
            Id contentDocumentId = insertedContentVersion.ContentDocumentId;
            
           
            if (contentDocumentId != null) {
                List<ContentDocumentLink> documentLinks = new List<ContentDocumentLink>();
                for (Knowledge__kav ka : [SELECT Id FROM Knowledge__kav]) {
                    ContentDocumentLink cdl = new ContentDocumentLink();
                    cdl.LinkedEntityId = ka.Id;
                    cdl.Visibility = 'InternalUsers';
                    cdl.ContentDocumentId = contentDocumentId;
                    system.debug('Inserted CD Link > ' + cdl);
                    documentLinks.add(cdl);
                }
                insert documentLinks;
                
                System.debug('ContentDocumentLinks successfully created: ' + documentLinks.size());
            } 



}
        @isTest
    static void testBatchExecution() {
        Test.startTest();
        ContentDocLinkBatch batch = new ContentDocLinkBatch();
        Database.executeBatch(batch, 50); 
        Test.stopTest();

      
    }
}