@IsTest
global class CandidateconsentCallMock implements HttpCalloutMock {
    global Id con;
    global CandidateconsentCallMock(Id con){
        this.con = con;
    }
    global HTTPresponse respond(HTTPrequest request) {
   
        Httpresponse response = new Httpresponse();
        
        response.setHeader('Content-Type', 'application/json');
        if(request.getBody().contains('client_id'))
        {
        response.setBody('{"access_token" : "3Hgv5+x/u9h1aFcofh+aImPY1E9/4yI92oUgod/srIKe6iUHDWtK9z6OYUk8Ui65mXnWGk1PVzoANtS+yuPPMV4/b8IdS/m6goOOMZFmx56yYQKRP9l+/UHjbj+ZBvRLNE8F4NGOYJRljp48Vq3W3r+hz9eUxj+2Ev9OY5ZiJqiyn9ZSm27lWgzbv4tuATYQOGQ=", "token_type":"Bearer" }');
       system.debug('@@ 1st ');
        }
        else if(request.getBody().contains('ConsentRegistrationLookupByDateRange'))
        {
              system.debug('@@ 2nd ');
            response.setBody('{"consentRegistrations":[{"brandName":"Blue Arrow","sourceIdentifier":"'+con+'","forename":"Alistair","surname":"Bussell","emailAddress":"Test@outlook.com","secondaryEmailAddress":null,"addressLine1":"16 Road A","addressLine2":"","city":"Basingstoke","county":"Hampshire","postcode":null,"mobileNumber":"","telephoneNumber":"11111111111","lastUpdateDate":"2018-05-18T11:52:20","lastUpdatedBy":"Herbie.Hopkins","consentOptions":{"Email":true,"Phone":true,"Post":true,"SMS":true},"consentOptionsLastUpdateDate":"2018-05-18T11:52:20","consentOptionsLastUpdatedBy":"Herbie.Hopkins"}]}');
       
            
        }
            response.setStatusCode(200);
        return response;
    }

}