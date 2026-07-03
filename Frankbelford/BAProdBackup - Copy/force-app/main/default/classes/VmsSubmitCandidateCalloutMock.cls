@isTest
global class VmsSubmitCandidateCalloutMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"response":{"message":"OK","statusLine":"200","status":"success","ruuid":"5f354e66730200ada3c1395c_a8e3b28f-f205-4f45-93b9-8fc4013a8a5d"}}]');
        response.setStatusCode(200);
        response.setStatus('success');
        return response;
    }
}