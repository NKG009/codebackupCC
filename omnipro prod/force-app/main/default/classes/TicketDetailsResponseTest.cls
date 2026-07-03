@isTest
public class TicketDetailsResponseTest {
    
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
        Test.setMock(HttpCalloutMock.class, new mockResponse());
        TicketDetailsResponse.response(Decimal.valueOf(cse.Zendesk_Ticket_Id__c));
        Test.setMock(HttpCalloutMock.class, new mockResponseElse());
        TicketDetailsResponse.response(Decimal.valueOf(cse.Zendesk_Ticket_Id__c));
        Test.stopTest();
    }
    
    public class mockResponse implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req){
			String jsonString = '{"ticket":{"url":"https://brabo.zendesk.com/api/v2/tickets/1.json","id":1,"external_id":null,"via":{"channel":"sample_ticket","source":{"from":{},"to":{},"rel":null}},"created_at":"2019-07-08T16:53:13Z","updated_at":"2019-07-20T22:03:20Z","type":"incident","subject":"Sample ticket: Meet the ticket","raw_subject":"Sample ticket: Meet the ticket","description":"Hi Kevin,\n\nThis is your first ticket. Ta-da! Any customer request sent to your supported channels (email, chat, voicemail, web form, and tweet) will become a Support ticket, just like this one. Respond to this ticket by typing a message above and clicking Submit. You can also see how an email becomes a ticket by emailing your new account, support@brabo.zendesk.com. Your ticket will appear in ticket views.\n\nThat\'s the ticket on tickets. If you want to learn more, check out: \nhttps://support.zendesk.com/hc/en-us/articles/203691476\n","priority":"normal","status":"closed","recipient":null,"requester_id":384374882372,"submitter_id":384349810212,"assignee_id":384349810212,"organization_id":null,"group_id":360005284232,"collaborator_ids":[],"follower_ids":[],"email_cc_ids":[],"forum_topic_id":null,"problem_id":null,"has_incidents":false,"is_public":true,"due_at":null,"tags":["processed_payroll_","sample","support","zendesk"],"custom_fields":[{"id":360023998731,"value":null},{"id":360023998711,"value":null},{"id":360032051632,"value":null},{"id":360032051652,"value":null},{"id":360020604872,"value":["processed_payroll_"]},{"id":360037816372,"value":null},{"id":360040404791,"value":null},{"id":360037816392,"value":null},{"id":360040455532,"value":null},{"id":360040455552,"value":null},{"id":4412912472980,"value":null},{"id":360039641852,"value":null}],"satisfaction_rating":{"score":"unoffered"},"sharing_agreement_ids":[],"fields":[{"id":360023998731,"value":null},{"id":360023998711,"value":null},{"id":360032051632,"value":null},{"id":360032051652,"value":null},{"id":360020604872,"value":["processed_payroll_"]},{"id":360037816372,"value":null},{"id":360040404791,"value":null},{"id":360037816392,"value":null},{"id":360040455532,"value":null},{"id":360040455552,"value":null},{"id":4412912472980,"value":null},{"id":360039641852,"value":null}],"followup_ids":[],"brand_id":360002613852,"allow_channelback":false,"allow_attachments":true,"from_messaging_channel":false}}';
            HttpResponse resp = new HttpResponse();
            resp.setBody(jsonString);
            resp.setStatusCode(200);
            return resp;
        }
    } 
    
    public class mockResponseElse implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req){
           HttpResponse resp = new HttpResponse();
            resp.setBody('{"external_id":null}');
            resp.setStatusCode(400);
            return resp; 
        }
    }
    
    
    
    
    
    
    
    

}