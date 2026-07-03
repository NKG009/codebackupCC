@isTest
public class TicketContactDetailsTest {
    @isTest
    public static void contact(){
        Contact con = new Contact();
        con.LastName = 'Test';
        insert con;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockResponse());
        TicketContactDetails.contactDetail('6156086437140L');
        Test.setMock(HttpCalloutMock.class, new mockResponseElse());
        TicketContactDetails.contactDetail('6156086437140L');
		Test.stopTest();
        
    }
    public class mockResponse implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req){
            String jsonString = '{"user":{"name":"Test","email":"test@gmail.com"}}';
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