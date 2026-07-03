/**
* @File Name : ContentVersionControllerTest.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : December 3, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | December 3, 2024 |   | Initial Version
**/

@IsTest
public class ContentVersionControllerTest {
    @TestSetup
    static void setup() {
        // Create a test Account or other record to associate the files
        /*Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;*/
        
         Contact con = new Contact(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com'
        );
        insert con;

        // Create ContentDocument and ContentVersion records
        ContentVersion cv = new ContentVersion(
            Title = 'Test File',
            PathOnClient = 'TestFile.pdf',
            VersionData = Blob.valueOf('Test Data'),
            FirstPublishLocationId = con.Id
        );
        insert cv;

        

        // Add another ContentVersion to test filtering
        ContentVersion cv2 = new ContentVersion(
            Title = 'Another File',
            PathOnClient = 'AnotherFile.snote',
            VersionData = Blob.valueOf('Another Data'),
             FirstPublishLocationId = con.Id
           
        );
        insert cv2;

      
    }

    @IsTest
    static void testGetContentVersions() {
        // Retrieve the test Account
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];

        // Call the method
        List<ContentVersion> result = ContentVersionController.getContentVersions(testContact.Id);

        // Verify the result
        System.assertEquals(1, result.size(), 'Only one ContentVersion should be returned.');
        System.assertEquals('Test File', result[0].Title, 'The file title should match the test data.');
    }

    @IsTest
    static void testUpdateContentVersion() {
        // Retrieve a ContentVersion record
        ContentVersion cv = [SELECT Id, Title FROM ContentVersion WHERE Title = 'Test File' LIMIT 1];

        // Update the Title
        cv.Title = 'Updated Test File';
        List<ContentVersion> updateList = new List<ContentVersion>{cv};

        // Call the method
        ContentVersionController.updateContentVersion(updateList);

        // Verify the update
        ContentVersion updatedCv = [SELECT Title FROM ContentVersion WHERE Id = :cv.Id];
        System.assertEquals('Updated Test File', updatedCv.Title, 'The ContentVersion title should be updated.');
    }

    @IsTest
    static void testDeleteContentDocument() {
        // Retrieve a ContentDocument
        ContentDocument cd = [SELECT Id FROM ContentDocument LIMIT 1];

        // Call the method to delete it
        ContentVersionController.deleteContentDocument(cd.Id);

        // Verify the deletion
        Integer count = [SELECT COUNT() FROM ContentDocument WHERE Id = :cd.Id];
        System.assertEquals(0, count, 'The ContentDocument should be deleted.');
    }
}