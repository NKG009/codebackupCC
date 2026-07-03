@isTest
public class ContentVersionTriggerHandlerTest {
    
    @isTest
    static void testGetDocumentPublicLink() {
        
        Account accRecord = new Account(
            Name = 'The Pepsico Company',
            Rating = 'Hot',
            Account_Status__c = 'Active',
            Business_Type__c = 'Industry'
        );
        insert accRecord;
       
        Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body to be inserted in test class for testing.');
        ContentVersion contentVersion = new ContentVersion(
            Title = 'SampleTitle', 
            PathOnClient = 'SampleTitle.jpg',
            VersionData = bodyBlob, 
            Origin = 'H'
        );
        insert contentVersion;
        
        ContentVersion contentVersionWithDocId = [SELECT Id, Title, ContentDocumentId 
                                                  FROM ContentVersion 
                                                  WHERE Id = :contentVersion.Id 
                                                  LIMIT 1];
        
        ContentDocumentLink contentLink = new ContentDocumentLink();
        contentLink.LinkedEntityId = accRecord.Id;
        contentLink.ContentDocumentId = contentVersionWithDocId.ContentDocumentId;
        contentLink.ShareType = 'V';
        insert contentLink;
        
        Set<Id> contentDocumentIds = new Set<Id>();
        contentDocumentIds.add(contentLink.ContentDocumentId);
        system.debug('contentDocumentIds ' + contentDocumentIds);

       // Test.startTest();
       // ContentVersionTriggerHandler.getDocumentPublicLink(contentDocumentIds);
        //Test.stopTest();
        
           }
}