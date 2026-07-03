@isTest
public class CommentsCallOutTest {

    @isTest
    public static void commentsTest() {
        // Set up mock Account and Contact records
        Account acc2 = new Account(Name = 'Test2', Business_Type__c = 'Practice', Account_Status__c = 'Active');
        insert acc2;

        Contact con = new Contact(LastName = 'Test', Email = 'test@gmail.com',Zendesk_Id__c='384050244651',AccountId=acc2.id);
        insert con;
// Create Zendesk Record Type for Case
        RecordType zendeskRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND name = 'Knowledge Hub' LIMIT 1];
        
       
        integer startTicketId = 0;
        Integer endTicketNumber = 0;
        integer tempVar = 0;
        List<Integer> ticketNumbers = new List<Integer>();
        Zendesk_Ticket_Details__c custSet = new Zendesk_Ticket_Details__c(Name = 'Test Cust Set', Ticket_Start_Id__c = '2', TempVar__c = '2', Ticket_End_Id__c = '3');
        insert custSet;

        if (custSet.Ticket_Start_Id__c.isNumeric()) {
            startTicketId = Integer.valueOf(custSet.Ticket_Start_Id__c.subString(0));
        }
        if (custSet.Ticket_End_Id__c.isNumeric()) {
            endTicketNumber = Integer.valueOf(custSet.Ticket_End_Id__c.subString(0));
        }
        if (custSet.TempVar__c.isNumeric()) {
            tempVar = Integer.valueOf(custSet.TempVar__c.subString(0));
        }

        for (Integer i = startTicketId; i <= tempVar; i++) {
            ticketNumbers.add(i);
        }

        Test.startTest();

        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new TicketMockResponseForWeb());

        // Call the method that performs the HTTP callout
        CommentsCallOut.basicAuthCallout(ticketNumbers);

        // Execute batch process
        Database.executeBatch(new TicketsBatch(), 1);

        Test.stopTest();
    }
    // Mock class to simulate the Zendesk API response
    public class TicketMockResponseForWeb implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);

            // Ticket mock response
            Map<String, Object> ticketResponseData = new Map<String, Object>{
                'ticket' => new Map<String, Object>{
                    'url' => 'https://omnipro.zendesk.com/api/v2/tickets/2034.json',
                    'id' => 2034,
                    'external_id' => null,
                    'via' => new Map<String, Object>{
                        'channel' => 'email',
                        'source' => new Map<String, Object>{
                            'from' => new Map<String, Object>{
                                'address' => 'ymurphy@bkk.ie',
                                'name' => 'Yvonne Murphy'
                            },
                            'to' => new Map<String, Object>{
                                'name' => 'OmniPro',
                                'address' => 'support@omnipro.zendesk.com'
                            },
                            'rel' => null
                        }
                    },
                    'created_at' => '2019-10-30T09:04:24Z',
                    'updated_at' => '2019-11-03T18:04:01Z',
                    'generated_timestamp' => 1572804241,
                    'subject' => 'Audit Company Being Struck Off',
                    'description' => 'Hi\n\n \n\nWe have ',
                    'status' => 'closed',
                    'requester_id' => '384050244651',
                    'submitter_id' => '384050244651',
                    'assignee_id' => '369382494011',
                    'organization_id' => '360520878191',
                    'group_id' => '360000106192',
                    'brand_id' => '360001203432',
                    'tags' => new List<String>{'arc', 'arc_charity', 'arc_non_audit', 'arc_premium', 'arc_propman', 'arc_solicitors', 'knowledgehub'},
                    'custom_fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                            'id' => '360000675331',
                            'value' => '309'
                        }
                    },
                    'allow_attachments' => true
                }
            };

            // Comments mock response
            Map<String, Object> commentsResponseData = new Map<String, Object>{
                'comments' => new List<Map<String, Object>>{
                    new Map<String, Object>{
                        'id' => '685695033852',
                        'type' => 'Comment',
                        'author_id' => '384374882372',
                        'body' => 'Hi Kevin,\n\nThis is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, support@brabo.zendesk.com. Your ticket will appear in ticket views.\n\nThat\'s the ticket on tickets. If you want to learn more, check out: \nhttps://support.zendesk.com/hc/en-us/articles/203691476',
                        'html_body' => '<div class="zd-comment" dir="auto"><p dir="auto">Hi Kevin,</p>\n\n<p dir="auto">This is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, <a href="mailto:support@brabo.zendesk.com" rel="noreferrer">support@brabo.zendesk.com</a>. Your ticket will appear in ticket views.</p>\n\n<p dir="auto">That\'s the ticket on tickets. If you want to learn more, check out: \n<br><a href="https://support.zendesk.com/hc/en-us/articles/203691476" target="_blank" rel="nofollow noreferrer">https://support.zendesk.com/hc/en-us/articles/203691476</a></p></div>',
                        'plain_body' => 'Hi Kevin, \n\n This is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, support@brabo.zendesk.com. Your ticket will appear in ticket views. \n\n That\'s the ticket on tickets. If you want to learn more, check out: \n\nhttps://support.zendesk.com/hc/en-us/articles/203691476',
                        'public' => true,
                        'attachments' => new List<Object>{},
                        'audit_id' => '685695033712',
                        'via' => new Map<String, Object>{
                            'channel' => 'web',
                            'source' => new Map<String, Object>{
                                'from' => new Map<String, Object>{},
                                'to' => new Map<String, Object>{},
                                'rel' => null
                            }
                        },
                        'created_at' => '2019-07-08T16:53:13Z',
                        'metadata' => new Map<String, Object>{
                            'system' => new Map<String, Object>{},
                            'custom' => new Map<String, Object>{}
                        }
                    }
                },
                'next_page' => null,
                'previous_page' => null,
                'count' => 1
            };

            String jsonTicketBody = JSON.serialize(ticketResponseData);
            String jsonCommentsBody = JSON.serialize(commentsResponseData);

            // Check if the requested endpoint contains 'ticket'
            if (req.getEndpoint().contains('ticket') && !req.getEndpoint().endsWith('comments')) {
                System.debug('Mock response for ticket details: ' + jsonTicketBody);
                response.setBody(jsonTicketBody);
            }
            // Check if the requested endpoint ends with 'comments'
            else if (req.getEndpoint().endsWith('comments')) {
                System.debug('Mock response for comments: ' + jsonCommentsBody);
                response.setBody(jsonCommentsBody);
            }

            return response;
        }
    }
    
    @isTest
    public static void commentsTest2() {
        // Set up mock Account and Contact records
        Account acc2 = new Account(Name = 'Test2', Business_Type__c = 'Practice', Account_Status__c = 'Active');
        insert acc2;

        Contact con = new Contact(LastName = 'Test', Email = 'test@gmail.com',Zendesk_Id__c='384050244651',AccountId=acc2.id);
        insert con;
// Create Zendesk Record Type for Case
        RecordType zendeskRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND name = 'Zendesk' LIMIT 1];
        
       
        integer startTicketId = 0;
        Integer endTicketNumber = 0;
        integer tempVar = 0;
        List<Integer> ticketNumbers = new List<Integer>();
        Zendesk_Ticket_Details__c custSet = new Zendesk_Ticket_Details__c(Name = 'Test Cust Set', Ticket_Start_Id__c = '2', TempVar__c = '2', Ticket_End_Id__c = '3');
        insert custSet;

        if (custSet.Ticket_Start_Id__c.isNumeric()) {
            startTicketId = Integer.valueOf(custSet.Ticket_Start_Id__c.subString(0));
        }
        if (custSet.Ticket_End_Id__c.isNumeric()) {
            endTicketNumber = Integer.valueOf(custSet.Ticket_End_Id__c.subString(0));
        }
        if (custSet.TempVar__c.isNumeric()) {
            tempVar = Integer.valueOf(custSet.TempVar__c.subString(0));
        }

        for (Integer i = startTicketId; i <= tempVar; i++) {
            ticketNumbers.add(i);
        }

        Test.startTest();

        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new TicketMockResponseForWeb1());

        // Call the method that performs the HTTP callout
        CommentsCallOut.basicAuthCallout(ticketNumbers);

        // Execute batch process
        Database.executeBatch(new TicketsBatch(), 1);

        Test.stopTest();
    }
    
@isTest
    public static void commentsTest1() {
        // Set up mock Account and Contact records
        Account acc2 = new Account(Name = 'Test2', Business_Type__c = 'Practice', Account_Status__c = 'Active');
        insert acc2;

        Contact con = new Contact(LastName = 'Test', Email = 'test@gmail.com',Zendesk_Id__c='',AccountId=acc2.id);
        insert con;
// Create Zendesk Record Type for Case
        RecordType zendeskRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND name = 'Zendesk' LIMIT 1];
        
       
        integer startTicketId = 0;
        Integer endTicketNumber = 0;
        integer tempVar = 0;
        List<Integer> ticketNumbers = new List<Integer>();
        Zendesk_Ticket_Details__c custSet = new Zendesk_Ticket_Details__c(Name = 'Test Cust Set', Ticket_Start_Id__c = '2', TempVar__c = '2', Ticket_End_Id__c = '3');
        insert custSet;

        if (custSet.Ticket_Start_Id__c.isNumeric()) {
            startTicketId = Integer.valueOf(custSet.Ticket_Start_Id__c.subString(0));
        }
        if (custSet.Ticket_End_Id__c.isNumeric()) {
            endTicketNumber = Integer.valueOf(custSet.Ticket_End_Id__c.subString(0));
        }
        if (custSet.TempVar__c.isNumeric()) {
            tempVar = Integer.valueOf(custSet.TempVar__c.subString(0));
        }

        for (Integer i = startTicketId; i <= tempVar; i++) {
            ticketNumbers.add(i);
        }

        Test.startTest();

        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new TicketMockResponseForWeb1());

        // Call the method that performs the HTTP callout
        CommentsCallOut.basicAuthCallout(ticketNumbers);

        // Execute batch process
        Database.executeBatch(new TicketsBatch(), 1);

        Test.stopTest();
    }
    // Mock class to simulate the Zendesk API response
    public class TicketMockResponseForWeb1 implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);

            // Ticket mock response
            Map<String, Object> ticketResponseData = new Map<String, Object>{
                'ticket' => new Map<String, Object>{
                    'url' => 'https://omnipro.zendesk.com/api/v2/tickets/2034.json',
                    'id' => 2034,
                    'external_id' => null,
                    'via' => new Map<String, Object>{
                        'channel' => 'email',
                        'source' => new Map<String, Object>{
                            'from' => new Map<String, Object>{
                                'address' => 'ymurphy@bkk.ie',
                                'name' => 'Yvonne Murphy'
                            },
                            'to' => new Map<String, Object>{
                                'name' => 'OmniPro',
                                'address' => 'support@omnipro.zendesk.com'
                            },
                            'rel' => null
                        }
                    },
                    'created_at' => '2019-10-30T09:04:24Z',
                    'updated_at' => '2019-11-03T18:04:01Z',
                    'generated_timestamp' => 1572804241,
                    'subject' => 'Audit Company Being Struck Off',
                    'description' => 'Hi\n\n \n\nWe have ',
                    'status' => 'closed',
                    'requester_id' => '384050244651',
                    'submitter_id' => '384050244651',
                    'assignee_id' => '369382494011',
                    'organization_id' => '360520878191',
                    'group_id' => '360000106192',
                    'tags' => new List<String>{'arc', 'arc_charity', 'arc_non_audit', 'arc_premium', 'arc_propman', 'arc_solicitors', 'knowledgehub'},
                    'custom_fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                            'id' => '360000675331',
                            'value' => '309'
                        }
                    },
                    'allow_attachments' => true
                }
            };

            // Comments mock response
            Map<String, Object> commentsResponseData = new Map<String, Object>{
                'comments' => new List<Map<String, Object>>{
                    new Map<String, Object>{
                        'id' => '685695033852',
                        'type' => 'Comment',
                        'author_id' => '384374882372',
                        'body' => 'Hi Kevin,\n\nThis is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, support@brabo.zendesk.com. Your ticket will appear in ticket views.\n\nThat\'s the ticket on tickets. If you want to learn more, check out: \nhttps://support.zendesk.com/hc/en-us/articles/203691476',
                        'html_body' => '<div class="zd-comment" dir="auto"><p dir="auto">Hi Kevin,</p>\n\n<p dir="auto">This is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, <a href="mailto:support@brabo.zendesk.com" rel="noreferrer">support@brabo.zendesk.com</a>. Your ticket will appear in ticket views.</p>\n\n<p dir="auto">That\'s the ticket on tickets. If you want to learn more, check out: \n<br><a href="https://support.zendesk.com/hc/en-us/articles/203691476" target="_blank" rel="nofollow noreferrer">https://support.zendesk.com/hc/en-us/articles/203691476</a></p></div>',
                        'plain_body' => 'Hi Kevin, \n\n This is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, support@brabo.zendesk.com. Your ticket will appear in ticket views. \n\n That\'s the ticket on tickets. If you want to learn more, check out: \n\nhttps://support.zendesk.com/hc/en-us/articles/203691476',
                        'public' => true,
                        'attachments' => new List<Object>{},
                        'audit_id' => '685695033712',
                        'via' => new Map<String, Object>{
                            'channel' => 'voice',
                            'source' => new Map<String, Object>{
                                'from' => new Map<String, Object>{},
                                'to' => new Map<String, Object>{},
                                'rel' => null
                            }
                        },
                        'created_at' => '2019-07-08T16:53:13Z',
                        'metadata' => new Map<String, Object>{
                            'system' => new Map<String, Object>{},
                            'custom' => new Map<String, Object>{}
                        }
                    }
                },
                'next_page' => null,
                'previous_page' => null,
                'count' => 1
            };

            String jsonTicketBody = JSON.serialize(ticketResponseData);
            String jsonCommentsBody = JSON.serialize(commentsResponseData);

            // Check if the requested endpoint contains 'ticket'
            if (req.getEndpoint().contains('ticket') && !req.getEndpoint().endsWith('comments')) {
                System.debug('Mock response for ticket details: ' + jsonTicketBody);
                response.setBody(jsonTicketBody);
            }
            // Check if the requested endpoint ends with 'comments'
            else if (req.getEndpoint().endsWith('comments')) {
                System.debug('Mock response for comments: ' + jsonCommentsBody);
                response.setBody(jsonCommentsBody);
            }

            return response;
        }
    }
    @isTest
    public static void commentsTest3() {
        // Set up mock Account and Contact records
        Account acc2 = new Account(Name = 'Test2', Business_Type__c = 'Practice', Account_Status__c = 'Active');
        insert acc2;

        Contact con = new Contact(LastName = 'Test', Email = 'test@gmail.com',Zendesk_Id__c='384050244651',AccountId=acc2.id);
        insert con;
// Create Zendesk Record Type for Case
        RecordType zendeskRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND name = 'CPDStore IE' LIMIT 1];
        
       
        integer startTicketId = 0;
        Integer endTicketNumber = 0;
        integer tempVar = 0;
        List<Integer> ticketNumbers = new List<Integer>();
        Zendesk_Ticket_Details__c custSet = new Zendesk_Ticket_Details__c(Name = 'Test Cust Set', Ticket_Start_Id__c = '2', TempVar__c = '2', Ticket_End_Id__c = '3');
        insert custSet;

        if (custSet.Ticket_Start_Id__c.isNumeric()) {
            startTicketId = Integer.valueOf(custSet.Ticket_Start_Id__c.subString(0));
        }
        if (custSet.Ticket_End_Id__c.isNumeric()) {
            endTicketNumber = Integer.valueOf(custSet.Ticket_End_Id__c.subString(0));
        }
        if (custSet.TempVar__c.isNumeric()) {
            tempVar = Integer.valueOf(custSet.TempVar__c.subString(0));
        }

        for (Integer i = startTicketId; i <= tempVar; i++) {
            ticketNumbers.add(i);
        }

        Test.startTest();

        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new TicketMockResponseForWeb2());

        // Call the method that performs the HTTP callout
        CommentsCallOut.basicAuthCallout(ticketNumbers);

        // Execute batch process
        Database.executeBatch(new TicketsBatch(), 1);

        Test.stopTest();
    }
    // Mock class to simulate the Zendesk API response
    public class TicketMockResponseForWeb2 implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);

            // Ticket mock response
            Map<String, Object> ticketResponseData = new Map<String, Object>{
                'ticket' => new Map<String, Object>{
                    'url' => 'https://omnipro.zendesk.com/api/v2/tickets/2034.json',
                    'id' => 2034,
                    'external_id' => null,
                    'via' => new Map<String, Object>{
                        'channel' => 'email',
                        'source' => new Map<String, Object>{
                            'from' => new Map<String, Object>{
                                'address' => 'ymurphy@bkk.ie',
                                'name' => 'Yvonne Murphy'
                            },
                            'to' => new Map<String, Object>{
                                'name' => 'OmniPro',
                                'address' => 'support@omnipro.zendesk.com'
                            },
                            'rel' => null
                        }
                    },
                    'created_at' => '2019-10-30T09:04:24Z',
                    'updated_at' => '2019-11-03T18:04:01Z',
                    'generated_timestamp' => 1572804241,
                    'subject' => 'Audit Company Being Struck Off',
                    'description' => 'Hi\n\n \n\nWe have ',
                    'status' => 'New',
                    'requester_id' => '384050244651',
                    'submitter_id' => '384050244651',
                    'assignee_id' => '369382494011',
                    'organization_id' => '360520878191',
                    'group_id' => '360000106192',
                    'brand_id' => '7651505943197',
                    'tags' => new List<String>{'arc', 'arc_charity', 'arc_non_audit', 'arc_premium', 'arc_propman', 'arc_solicitors', 'knowledgehub'},
                    'custom_fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                            'id' => '360000675331',
                            'value' => '309'
                        }
                    },
                    'allow_attachments' => true
                }
            };

            // Comments mock response
            Map<String, Object> commentsResponseData = new Map<String, Object>{
                'comments' => new List<Map<String, Object>>{
                    new Map<String, Object>{
                        'id' => '685695033852',
                        'type' => 'Comment',
                        'author_id' => '384374882372',
                        'body' => 'Hi Kevin,\n\nThis is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, support@brabo.zendesk.com. Your ticket will appear in ticket views.\n\nThat\'s the ticket on tickets. If you want to learn more, check out: \nhttps://support.zendesk.com/hc/en-us/articles/203691476',
                        'html_body' => '<div class="zd-comment" dir="auto"><p dir="auto">Hi Kevin,</p>\n\n<p dir="auto">This is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, <a href="mailto:support@brabo.zendesk.com" rel="noreferrer">support@brabo.zendesk.com</a>. Your ticket will appear in ticket views.</p>\n\n<p dir="auto">That\'s the ticket on tickets. If you want to learn more, check out: \n<br><a href="https://support.zendesk.com/hc/en-us/articles/203691476" target="_blank" rel="nofollow noreferrer">https://support.zendesk.com/hc/en-us/articles/203691476</a></p></div>',
                        'plain_body' => 'Hi Kevin, \n\n This is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, support@brabo.zendesk.com. Your ticket will appear in ticket views. \n\n That\'s the ticket on tickets. If you want to learn more, check out: \n\nhttps://support.zendesk.com/hc/en-us/articles/203691476',
                        'public' => true,
                        'attachments' => new List<Object>{},
                        'audit_id' => '685695033712',
                        'via' => new Map<String, Object>{
                            'channel' => 'email',
                            'source' => new Map<String, Object>{
                                'from' => new Map<String, Object>{},
                                'to' => new Map<String, Object>{},
                                'rel' => null
                            }
                        },
                        'created_at' => '2019-07-08T16:53:13Z',
                        'metadata' => new Map<String, Object>{
                            'system' => new Map<String, Object>{},
                            'custom' => new Map<String, Object>{}
                        }
                    }
                },
                'next_page' => null,
                'previous_page' => null,
                'count' => 1
            };

            String jsonTicketBody = JSON.serialize(ticketResponseData);
            String jsonCommentsBody = JSON.serialize(commentsResponseData);

            // Check if the requested endpoint contains 'ticket'
            if (req.getEndpoint().contains('ticket') && !req.getEndpoint().endsWith('comments')) {
                System.debug('Mock response for ticket details: ' + jsonTicketBody);
                response.setBody(jsonTicketBody);
            }
            // Check if the requested endpoint ends with 'comments'
            else if (req.getEndpoint().endsWith('comments')) {
                System.debug('Mock response for comments: ' + jsonCommentsBody);
                response.setBody(jsonCommentsBody);
            }

            return response;
        }
    }
    @isTest
    public static void commentsTest4() {
        // Set up mock Account and Contact records
        
// Create Zendesk Record Type for Case
        RecordType zendeskRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND name = 'CPDStore UK' LIMIT 1];
        
       
        integer startTicketId = 0;
        Integer endTicketNumber = 0;
        integer tempVar = 0;
        List<Integer> ticketNumbers = new List<Integer>();
        Zendesk_Ticket_Details__c custSet = new Zendesk_Ticket_Details__c(Name = 'Test Cust Set', Ticket_Start_Id__c = '2', TempVar__c = '2', Ticket_End_Id__c = '3');
        insert custSet;

        if (custSet.Ticket_Start_Id__c.isNumeric()) {
            startTicketId = Integer.valueOf(custSet.Ticket_Start_Id__c.subString(0));
        }
        if (custSet.Ticket_End_Id__c.isNumeric()) {
            endTicketNumber = Integer.valueOf(custSet.Ticket_End_Id__c.subString(0));
        }
        if (custSet.TempVar__c.isNumeric()) {
            tempVar = Integer.valueOf(custSet.TempVar__c.subString(0));
        }

        for (Integer i = startTicketId; i <= tempVar; i++) {
            ticketNumbers.add(i);
        }

        Test.startTest();

        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new TicketMockResponseForWeb3());

        // Call the method that performs the HTTP callout
        CommentsCallOut.basicAuthCallout(ticketNumbers);

        // Execute batch process
        Database.executeBatch(new TicketsBatch(), 1);

        Test.stopTest();
    }
    // Mock class to simulate the Zendesk API response
    public class TicketMockResponseForWeb3 implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);

            // Ticket mock response
            Map<String, Object> ticketResponseData = new Map<String, Object>{
                'ticket' => new Map<String, Object>{
                    'url' => 'https://omnipro.zendesk.com/api/v2/tickets/2034.json',
                    'id' => 2034,
                    'external_id' => null,
                    'via' => new Map<String, Object>{
                        'channel' => 'email',
                        'source' => new Map<String, Object>{
                            'from' => new Map<String, Object>{
                                'address' => 'ymurphy@bkk.ie',
                                'name' => 'Yvonne Murphy'
                            },
                            'to' => new Map<String, Object>{
                                'name' => 'OmniPro',
                                'address' => 'support@omnipro.zendesk.com'
                            },
                            'rel' => null
                        }
                    },
                    'created_at' => '2019-10-30T09:04:24Z',
                    'updated_at' => '2019-11-03T18:04:01Z',
                    'generated_timestamp' => 1572804241,
                    'subject' => 'Audit Company Being Struck Off',
                    'description' => 'Hi\n\n \n\nWe have ',
                    'status' => 'New',
                    'requester_id' => '384050244651',
                    'submitter_id' => '384050244651',
                    'assignee_id' => '369382494011',
                    'organization_id' => '360520878191',
                    'group_id' => '360000106192',
                    'brand_id' => '7651544743325',
                    'tags' => new List<String>{'arc', 'arc_charity', 'arc_non_audit', 'arc_premium', 'arc_propman', 'arc_solicitors', 'knowledgehub'},
                    'custom_fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                            'id' => '360000675331',
                            'value' => '309'
                        }
                    },
                    'allow_attachments' => true
                }
            };

            // Comments mock response
            Map<String, Object> commentsResponseData = new Map<String, Object>{
                'comments' => new List<Map<String, Object>>{
                    new Map<String, Object>{
                        'id' => '685695033852',
                        'type' => 'Comment',
                        'author_id' => '384374882372',
                        'body' => 'Hi Kevin,\n\nThis is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, support@brabo.zendesk.com. Your ticket will appear in ticket views.\n\nThat\'s the ticket on tickets. If you want to learn more, check out: \nhttps://support.zendesk.com/hc/en-us/articles/203691476',
                        'html_body' => '<div class="zd-comment" dir="auto"><p dir="auto">Hi Kevin,</p>\n\n<p dir="auto">This is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, <a href="mailto:support@brabo.zendesk.com" rel="noreferrer">support@brabo.zendesk.com</a>. Your ticket will appear in ticket views.</p>\n\n<p dir="auto">That\'s the ticket on tickets. If you want to learn more, check out: \n<br><a href="https://support.zendesk.com/hc/en-us/articles/203691476" target="_blank" rel="nofollow noreferrer">https://support.zendesk.com/hc/en-us/articles/203691476</a></p></div>',
                        'plain_body' => 'Hi Kevin, \n\n This is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, support@brabo.zendesk.com. Your ticket will appear in ticket views. \n\n That\'s the ticket on tickets. If you want to learn more, check out: \n\nhttps://support.zendesk.com/hc/en-us/articles/203691476',
                        'public' => true,
                        'attachments' => new List<Object>{},
                        'audit_id' => '685695033712',
                        'via' => new Map<String, Object>{
                            'channel' => 'api',
                            'source' => new Map<String, Object>{
                                'from' => new Map<String, Object>{},
                                'to' => new Map<String, Object>{},
                                'rel' => null
                            }
                        },
                        'created_at' => '2019-07-08T16:53:13Z',
                        'metadata' => new Map<String, Object>{
                            'system' => new Map<String, Object>{},
                            'custom' => new Map<String, Object>{}
                        }
                    }
                },
                'next_page' => null,
                'previous_page' => null,
                'count' => 1
            };

            String jsonTicketBody = JSON.serialize(ticketResponseData);
            String jsonCommentsBody = JSON.serialize(commentsResponseData);

            // Check if the requested endpoint contains 'ticket'
            if (req.getEndpoint().contains('ticket') && !req.getEndpoint().endsWith('comments')) {
                System.debug('Mock response for ticket details: ' + jsonTicketBody);
                response.setBody(jsonTicketBody);
            }
            // Check if the requested endpoint ends with 'comments'
            else if (req.getEndpoint().endsWith('comments')) {
                System.debug('Mock response for comments: ' + jsonCommentsBody);
                response.setBody(jsonCommentsBody);
            }

            return response;
        }
    }
        @isTest
    public static void commentsTest5() {
        // Set up mock Account and Contact records
        Account acc2 = new Account(Name = 'Test2', Business_Type__c = 'Practice', Account_Status__c = 'Active');
        insert acc2;

        Contact con = new Contact(LastName = 'Test', Email = 'test@gmail.com',Zendesk_Id__c='384050244651',AccountId=acc2.id);
        insert con;
// Create Zendesk Record Type for Case
        RecordType zendeskRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND name = 'CPDStore IE' LIMIT 1];
        
       
        integer startTicketId = 0;
        Integer endTicketNumber = 0;
        integer tempVar = 0;
        List<Integer> ticketNumbers = new List<Integer>();
        Zendesk_Ticket_Details__c custSet = new Zendesk_Ticket_Details__c(Name = 'Test Cust Set', Ticket_Start_Id__c = '2', TempVar__c = '2', Ticket_End_Id__c = '3');
        insert custSet;

        if (custSet.Ticket_Start_Id__c.isNumeric()) {
            startTicketId = Integer.valueOf(custSet.Ticket_Start_Id__c.subString(0));
        }
        if (custSet.Ticket_End_Id__c.isNumeric()) {
            endTicketNumber = Integer.valueOf(custSet.Ticket_End_Id__c.subString(0));
        }
        if (custSet.TempVar__c.isNumeric()) {
            tempVar = Integer.valueOf(custSet.TempVar__c.subString(0));
        }

        for (Integer i = startTicketId; i <= tempVar; i++) {
            ticketNumbers.add(i);
        }

        Test.startTest();

        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new TicketMockResponseForWeb4());

        // Call the method that performs the HTTP callout
        CommentsCallOut.basicAuthCallout(ticketNumbers);

        // Execute batch process
        Database.executeBatch(new TicketsBatch(), 1);

        Test.stopTest();
    }
    // Mock class to simulate the Zendesk API response
    public class TicketMockResponseForWeb4 implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);

            // Ticket mock response
            Map<String, Object> ticketResponseData = new Map<String, Object>{
                'ticket' => new Map<String, Object>{
                    'url' => 'https://omnipro.zendesk.com/api/v2/tickets/2034.json',
                    'id' => 2034,
                    'external_id' => null,
                    'via' => new Map<String, Object>{
                        'channel' => 'email',
                        'source' => new Map<String, Object>{
                            'from' => new Map<String, Object>{
                                'address' => 'ymurphy@bkk.ie',
                                'name' => 'Yvonne Murphy'
                            },
                            'to' => new Map<String, Object>{
                                'name' => 'OmniPro',
                                'address' => 'support@omnipro.zendesk.com'
                            },
                            'rel' => null
                        }
                    },
                    'created_at' => '2019-10-30T09:04:24Z',
                    'updated_at' => '2019-11-03T18:04:01Z',
                    'generated_timestamp' => 1572804241,
                    'subject' => 'Audit Company Being Struck Off',
                    'description' => 'Hi\n\n \n\nWe have ',
                    'status' => 'New',
                    'requester_id' => '384050244651',
                    'submitter_id' => '384050244651',
                    'assignee_id' => '369382494011',
                    'organization_id' => '360520878191',
                    'group_id' => '360000106192',
                    'brand_id' => '7651505943197',
                    'tags' => new List<String>{'arc', 'arc_charity', 'arc_non_audit', 'arc_premium', 'arc_propman', 'arc_solicitors', 'knowledgehub'},
                    'custom_fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                            'id' => '360000675331',
                            'value' => '309'
                        }
                    },
                    'allow_attachments' => true
                }
            };

            // Comments mock response
            Map<String, Object> commentsResponseData = new Map<String, Object>{
                'comments' => new List<Map<String, Object>>{
                    new Map<String, Object>{
                        'id' => '685695033852',
                        'type' => 'Comment',
                        'author_id' => '384374882372',
                        'body' => 'Hi Kevin,\n\nThis is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, support@brabo.zendesk.com. Your ticket will appear in ticket views.\n\nThat\'s the ticket on tickets. If you want to learn more, check out: \nhttps://support.zendesk.com/hc/en-us/articles/203691476',
                        'html_body' => '<div class="zd-comment" dir="auto"><p dir="auto">Hi Kevin,</p>\n\n<p dir="auto">This is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, <a href="mailto:support@brabo.zendesk.com" rel="noreferrer">support@brabo.zendesk.com</a>. Your ticket will appear in ticket views.</p>\n\n<p dir="auto">That\'s the ticket on tickets. If you want to learn more, check out: \n<br><a href="https://support.zendesk.com/hc/en-us/articles/203691476" target="_blank" rel="nofollow noreferrer">https://support.zendesk.com/hc/en-us/articles/203691476</a></p></div>',
                        'plain_body' => 'Hi Kevin, \n\n This is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, support@brabo.zendesk.com. Your ticket will appear in ticket views. \n\n That\'s the ticket on tickets. If you want to learn more, check out: \n\nhttps://support.zendesk.com/hc/en-us/articles/203691476',
                        'public' => true,
                        'attachments' => new List<Object>{},
                        'audit_id' => '685695033712',
                        'via' => new Map<String, Object>{
                            'channel' => 'Voice',
                            'source' => new Map<String, Object>{
                                'from' => new Map<String, Object>{},
                                'to' => new Map<String, Object>{},
                                'rel' => null
                            }
                        },
                        'created_at' => '2019-07-08T16:53:13Z',
                        'metadata' => new Map<String, Object>{
                            'system' => new Map<String, Object>{},
                            'custom' => new Map<String, Object>{}
                        }
                    }
                },
                'next_page' => null,
                'previous_page' => null,
                'count' => 1
            };

            String jsonTicketBody = JSON.serialize(ticketResponseData);
            String jsonCommentsBody = JSON.serialize(commentsResponseData);

            // Check if the requested endpoint contains 'ticket'
            if (req.getEndpoint().contains('ticket') && !req.getEndpoint().endsWith('comments')) {
                System.debug('Mock response for ticket details: ' + jsonTicketBody);
                response.setBody(jsonTicketBody);
            }
            // Check if the requested endpoint ends with 'comments'
            else if (req.getEndpoint().endsWith('comments')) {
                System.debug('Mock response for comments: ' + jsonCommentsBody);
                response.setBody(jsonCommentsBody);
            }

            return response;
        }
    }
}