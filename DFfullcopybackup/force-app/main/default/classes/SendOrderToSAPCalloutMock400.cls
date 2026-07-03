/**
 * @description       : 
 * @author            : avinash_s@decisionfoundry.com
 * @group             : 
 * @last modified on  : 01-13-2026;
 * @last modified by  : avinash_s@decisionfoundry.com
**/
@isTest
global class SendOrderToSAPCalloutMock400 implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
       
        String json = '{'+
           '    \"response\": {'+
            '        \"statusCode\": 400,'+
            '        \"message\": \"API creation is failed with not_found\",'+
            '        \"name\": \"Error\"'+
            '    }'+
            '}';
        response.setBody(json);
        response.setStatusCode(400);
        return response; 
    }  
}