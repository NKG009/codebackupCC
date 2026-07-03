@isTest
global class EmailnotValidatedResonse implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ResponseCode":"Invalid","ResponseMessage":"Email Address is not valid"}');
        res.setStatusCode(200);
        return res;
    }
}