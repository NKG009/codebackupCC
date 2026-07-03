@isTest
public class AttachmentControllerTest {
    @testSetup
    static void setup() {
        // Create a sample record to associate attachments with
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Create a sample ContentVersion
        ContentVersion version = new ContentVersion(
            Title = 'Test Document',
            PathOnClient = 'TestDocument.application/msword',
            VersionData = Blob.valueOf('Test content'),
            FirstPublishLocationId = testAccount.Id
        );
       
        insert version;

        // Retrieve the ContentDocumentId from the ContentVersion
        ContentVersion insertedVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :version.Id LIMIT 1];

        // Check if the ContentDocumentLink already exists
        List<ContentDocumentLink> existingLinks = [
            SELECT Id 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :testAccount.Id 
            AND ContentDocumentId = :insertedVersion.ContentDocumentId
        ];

        if (existingLinks.isEmpty()) {
            // Link the ContentDocument to the test account
            ContentDocumentLink docLink = new ContentDocumentLink(
                LinkedEntityId = testAccount.Id,
                ContentDocumentId = insertedVersion.ContentDocumentId,
                ShareType = 'V'
            );
            insert docLink;
        }
    }

    @isTest
    static void testAttachmentController() {
        // Get the test Account record
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];

        // Create the StandardController with the test Account
        ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);

        // Instantiate the AttachmentController
        AttachmentController controller = new AttachmentController(sc);

        // Verify that the recordId is set correctly
        System.assertEquals(testAccount.Id, controller.recordId);
        System.debug('Record ID: ' + controller.recordId);

        // Call loadAttachments to ensure it works as expected
        Test.startTest();
        controller.loadAttachments();
        Test.stopTest();

        // Verify the attachments list is populated correctly
        System.assertNotEquals(0, controller.attachments.size());
        System.debug('Attachments size: ' + controller.attachments.size());
        System.assertEquals('Test Document', controller.attachments[0].title);

        // Verify the preview URL and contentDocUrl are set
        System.assertNotEquals(null, controller.attachments[0].previewUrl);
        System.assertNotEquals(null, controller.attachments[0].contentDocUrl);

        // Additional checks for various file types
        for (AttachmentController.AttachmentWrapper attachment : controller.attachments) {
            System.assertNotEquals(null, attachment.fileType);
            System.assertNotEquals(null, attachment.id);
            System.assert(attachment.previewUrl.contains('/sfc/servlet.shepherd/version/renditionDownload'));
        }
    }
}