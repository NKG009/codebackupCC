@IsTest
global class CandidateconsentCallMock1 implements HttpCalloutMock {
    
    global HTTPresponse respond(HTTPrequest request) {
        Httpresponse response = new Httpresponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"access_token" : "3Hgv5+x/u9h1aFcofh+aImPY1E9/4yI92oUgod/srIKe6iUHDWtK9z6OYUk8Ui65mXnWGk1PVzoANtS+yuPPMV4/b8IdS/m6goOOMZFmx56yYQKRP9l+/UHjbj+ZBvRLNE8F4NGOYJRljp48Vq3W3r+hz9eUxj+2Ev9OY5ZiJqiyn9ZSm27lWgzbv4tuATYQOGQ=", "token_type":"Bearer"}');
        response.setStatusCode(200);
        return response;
    }

}