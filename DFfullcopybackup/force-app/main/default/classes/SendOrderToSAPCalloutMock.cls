/**
 * @description       : 
 * @author            : avinash_s@decisionfoundry.com
 * @group             : 
 * @last modified on  : 01-13-2026;
 * @last modified by  : avinash_s@decisionfoundry.com
**/
@isTest
global class SendOrderToSAPCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
       
        String json = '{"response":{"message":"SAP SO Created","soNumber":"3000100615","statusCode":200}}';
        response.setBody(json);
        response.setStatusCode(200);
        return response; 
    }  
}