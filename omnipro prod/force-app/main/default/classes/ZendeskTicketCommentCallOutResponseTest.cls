@isTest
public class ZendeskTicketCommentCallOutResponseTest {
    @testSetup
    Public static void commonData(){
        Case c = new Case();
        c.Status = 'New';
        c.Priority = 'Low';
        c.Origin = 'Phone';
        c.Zendesk_Ticket_Id__c = '56546';
        insert c; 
    }
    @isTest
    public static void responseTest(){
        Case cse = [Select id, Zendesk_Ticket_Id__c from Case];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TicketCommentMockResponse());
        ZendeskTicketCommentCallOutResponse.response(cse.Zendesk_Ticket_Id__c);
        Test.setMock(HttpCalloutMock.class, new TicketCommentMockResponseForElse());
        ZendeskTicketCommentCallOutResponse.response(cse.Zendesk_Ticket_Id__c);
        Test.stopTest();
    }
    
    public class TicketCommentMockResponse implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req){
            String jsonString = '{"comments":[{"id":685695033852,"type":"Comment","author_id":384374882372,"body":"Hi Kevin,\n\nThis is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, support@brabo.zendesk.com. Your ticket will appear in ticket views.\n\nThat\'s the ticket on tickets. If you want to learn more, check out: \nhttps://support.zendesk.com/hc/en-us/articles/203691476","html_body":"<div class=\"zd-comment\" dir=\"auto\"><p dir=\"auto\">Hi Kevin,</p>\n\n<p dir=\"auto\">This is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, <a href=\"mailto:support@brabo.zendesk.com\" rel=\"noreferrer\">support@brabo.zendesk.com</a>. Your ticket will appear in ticket views.</p>\n\n<p dir=\"auto\">That\'s the ticket on tickets. If you want to learn more, check out: \n<br><a href=\"https://support.zendesk.com/hc/en-us/articles/203691476\" target=\"_blank\" rel=\"nofollow noreferrer\">https://support.zendesk.com/hc/en-us/articles/203691476</a></p></div>","plain_body":"Hi Kevin, \n\n This is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, support@brabo.zendesk.com. Your ticket will appear in ticket views. \n\n That\'s the ticket on tickets. If you want to learn more, check out: \n\nhttps://support.zendesk.com/hc/en-us/articles/203691476","public":true,"attachments":[],"audit_id":685695033712,"via":{"channel":"sample_ticket","source":{"from":{},"to":{},"rel":null}},"created_at":"2019-07-08T16:53:13Z","metadata":{"system":{},"custom":{}}}],"next_page":null,"previous_page":null,"count":1}';
            HttpResponse resp = new HttpResponse();
            resp.setBody(jsonString);
            resp.setStatusCode(200);
            return resp;
        }
    }
    public class TicketCommentMockResponseForElse implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req){
            HttpResponse resp = new HttpResponse();
            resp.setBody('{"id":685695033852}');
            resp.setStatusCode(400);
            return resp;
        }
    }
}