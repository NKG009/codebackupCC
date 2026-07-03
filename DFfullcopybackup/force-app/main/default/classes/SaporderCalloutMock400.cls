/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is Apex Class is Saporder Mock API callout for 400 status code(used in test class)
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Ravi Rajeev   <ravi.rajeev@mainspringcg.com>
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
@isTest
global class SaporderCalloutMock400 implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
       /* String json = '{'+
           '    \"error\": {'+
            '        \"statusCode\": 400,'+
            '        \"message\": \"API creation is failed with not_found\",'+
            '        \"name\": \"Error\"'+
            '    }'+
            '}'; */
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