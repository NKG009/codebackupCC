@isTest
global class EmailMockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ResponseCode":"Valid","ResponseMessage":"Email address was fully validated"}');
        res.setStatusCode(200);
        return res;
    }
}