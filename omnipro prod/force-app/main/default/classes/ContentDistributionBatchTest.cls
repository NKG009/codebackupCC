@isTest
public class ContentDistributionBatchTest {

    @testSetup
    static void setupTestData() {
        
        List<Trigger_Disable__c> custSet = new List<Trigger_Disable__c>();
        Trigger_Disable__c custSetting1 = new Trigger_Disable__c(Name = 'Disable ContentVersion Trigger', isActive__c=false);
        custSet.add(custSetting1);
        
        insert custSet;
        
        List<Knowledge__kav> articles = new List<Knowledge__kav>();
        for (Integer i = 0; i < 5; i++) {
            Knowledge__kav k = new Knowledge__kav();
            k.Title = 'Test Article ' + i;
            k.UrlName = 'Test-Article-' + i;
            k.Language = 'en_US';
            articles.add(k);
        }
        insert articles;

        Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body to be inserted in test class for testing.');
        List<ContentVersion> cvList = new List<ContentVersion>();
        
        for (Integer i = 0; i < 5; i++) {
            ContentVersion cv = new ContentVersion();
            cv.Title = 'SampleTitle' + i;
            cv.PathOnClient = 'SampleTitle' + i + '.jpg';
            cv.VersionData = bodyBlob;
            cvList.add(cv);
        }
        insert cvList;

        List<ContentVersion> cdList = [SELECT ContentDocumentId FROM ContentVersion WHERE Id IN :cvList];

        List<ContentDocumentLink> documentLinks = new List<ContentDocumentLink>();
        for (Knowledge__kav article : articles) {
            for (ContentVersion cv : cdList) {
                ContentDocumentLink link = new ContentDocumentLink(
                    LinkedEntityId = article.Id,
                    ContentDocumentId = cv.ContentDocumentId, 
                    ShareType = 'V'
                );
                documentLinks.add(link);
            }
        }
        insert documentLinks;
    }

    @isTest
    static void testBatchExecution() {
        Set<Id> contentDocumentIds = new Set<Id>();
        List<ContentVersion> contentVersions = [SELECT ContentDocumentId FROM ContentVersion];
        for (ContentVersion cv : contentVersions) {
            contentDocumentIds.add(cv.ContentDocumentId);
        }
        system.debug('Size of cd : ' + contentDocumentIds.size());
        ContentDistributionBatch batch = new ContentDistributionBatch(contentDocumentIds);

        Test.startTest();
        Database.executeBatch(batch, 200); 
        Test.stopTest();
    }
    
    
    @isTest
    static void contentVersionAcc() {
        
        List<Trigger_Disable__c> custSet = new List<Trigger_Disable__c>();
        Trigger_Disable__c custSetting1 = new Trigger_Disable__c(Name = 'Disable ContentVersion Trigger', isActive__c=true);
        custSet.add(custSetting1);
        insert custSet;
        
        Blob bodyBlob = Blob.valueOf('ContentVersion Body to be inserted in test class for testing.');
          ContentVersion cv = new ContentVersion();
            cv.Title = 'Test Title';
            cv.PathOnClient = 'SampleTitle.jpg';
            cv.VersionData = bodyBlob;
            
        	insert cv;
    }
}