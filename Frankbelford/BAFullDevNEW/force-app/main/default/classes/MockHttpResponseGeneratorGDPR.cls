@isTest
global class MockHttpResponseGeneratorGDPR implements HttpCalloutMock  {
    global  HTTPResponse respond(HTTPRequest req) 
    {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setBody('{"access_token":"JT6EY0OWdiKLK9oxhwEZHQ3pkFjPtUCyv2nHwTdtBvALDhjMv9NNukgwh1VwLWDZr7g4S880AXGICxOSIfFzhxAXogb3T9VpuA8ShaX5WT274KWv7mbq9qGf0tIxx+QqHNxSB85wPXQIpRBZdY2W/rVpAWfoMzeJwPqKBQEMDZbg3cyiU/B840wRrsV+Im0BMDM=","token_type":"Bearer","issued_at":"2018-12-10T06:51:24.9480299+00:00","expires_at":"2018-12-10T07:51:24.9480299+00:00"}  ');
        res.setStatusCode(200);
        System.assertEquals('POST', req.getMethod());
        
        return res;
    }
}