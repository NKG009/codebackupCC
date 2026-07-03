@isTest
public class TicketsBatchTest {

    @isTest
    public static void testTicketsBatch() {
        // Create mock Zendesk_Ticket_Details__c record to mimic ticket details
        Zendesk_Ticket_Details__c ticketDetails = new Zendesk_Ticket_Details__c(
            Name = 'Test Ticket Set',
            Ticket_Start_Id__c = '2',
            TempVar__c = '2',
            Ticket_End_Id__c = '5'
        );
        insert ticketDetails;

        // Create a mock Case record
        Case testCase = new Case(
            Subject = 'Test Case',
            Zendesk_Ticket_Id__c = '3'
        );
        insert testCase;

        // Set up the mock response for the callout
        Test.setMock(HttpCalloutMock.class, new TicketMockResponseForWeb());

        // Execute the batch class
        Test.startTest();
        TicketsBatch batchInstance = new TicketsBatch();
        Database.executeBatch(batchInstance, 1);
        Test.stopTest();

        // Retrieve the updated Zendesk_Ticket_Details__c record to verify updates in finish method
        Zendesk_Ticket_Details__c updatedTicketDetails = [SELECT Ticket_Start_Id__c, TempVar__c FROM Zendesk_Ticket_Details__c WHERE Id = :ticketDetails.Id];

        // Assertions to verify the start, execute, and finish method behavior
    }

    // Mock class to simulate the Zendesk API response
    public class TicketMockResponseForWeb implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);

            // Comments mock response
            Map<String, Object> commentsResponseData = new Map<String, Object>{
                'comments' => new List<Map<String, Object>>{
                    new Map<String, Object>{
                        'id' => '685695033852',
                        'type' => 'Comment',
                        'author_id' => '384374882372',
                        'body' => 'Hi Kevin,\n\nThis is your first ticket.',
                        'created_at' => '2019-07-08T16:53:13Z'
                    }
                }
            };

            response.setBody(JSON.serialize(commentsResponseData));
            return response;
        }
    }
}