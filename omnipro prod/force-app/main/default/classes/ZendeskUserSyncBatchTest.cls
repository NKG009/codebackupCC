@isTest
public class ZendeskUserSyncBatchTest {
    
    @testSetup
    static void setupData() {
        // Insert a contact to simulate existing data
        Contact existingContact = new Contact();
        existingContact.FirstName = 'John';
        existingContact.LastName = 'Doe';
        existingContact.Email = 'john.doe@example.com';
        existingContact.Zendesk_Id__c = '123';
        insert existingContact;
    }

    @isTest
    static void testBatchProcess() {
        // Mock HTTP callout response
        Test.setMock(HttpCalloutMock.class, new ZendeskUserSyncBatchTest.ZendeskUserSyncBatchMock());

        // Execute the batch job
        ZendeskUserSyncBatch batch = new ZendeskUserSyncBatch();
        Database.executeBatch(batch, 10); // Batch size 10

          }

    @isTest
    static void testPartialInsert() {
        // Mock HTTP callout response with an invalid contact (e.g., missing email)
        Test.setMock(HttpCalloutMock.class, new ZendeskUserSyncBatchTest.ZendeskUserSyncBatchMockWithError());

        // Execute the batch job
        ZendeskUserSyncBatch batch = new ZendeskUserSyncBatch();
        Database.executeBatch(batch, 10);

      
    }

    // Mock HTTP callout for successful batch run
    public class ZendeskUserSyncBatchMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"users":[{"id":"456","name":"Jane Doe","email":"jane.doe@example.com"}],"next_page":null}');
            return res;
        }
    }

    // Mock HTTP callout with error (e.g., missing email)
    public class ZendeskUserSyncBatchMockWithError implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"users":[{"id":"456","name":"Jane Doe","email":"jane.doe@example.com"},{"id":"789","name":"Invalid User","email":null}],"next_page":null}');
            return res;
        }
    }
}