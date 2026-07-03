/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is Apex Class is Saporder Mock API callout for 200 status code(used in test class)
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Ravi Rajeev   <ravi.rajeev@mainspringcg.com>
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
@isTest
global class SaporderCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        String json = '{"OrderID":"a3tDv000000oBE6IAM","error":{"message":"Message queued for processing on SAP - O-00000057","name":"Success","statusCode":200}}';
        response.setBody(json);
        response.setStatusCode(200);
        return response; 
    }   
   
}