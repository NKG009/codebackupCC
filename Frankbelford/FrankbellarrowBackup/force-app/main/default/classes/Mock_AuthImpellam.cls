@isTest
global class Mock_AuthImpellam   implements HttpCalloutMock {
 
    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('https://dev-integration-dx.impellamapi.com/api/v1/oauth2/token', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);
        return res;
    }
}