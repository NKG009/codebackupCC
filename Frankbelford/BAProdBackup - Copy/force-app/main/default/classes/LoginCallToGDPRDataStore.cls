public class LoginCallToGDPRDataStore {
    
    public  static String logincall()
    {
        Requestbody.GdprData req = new Requestbody.GdprData();
        req.grant_type  = 'client_credentials';
        req.client_id = 'e7838bae08a24a08b51b0a0b378cfed363280d993367457689e008f74c46b3a1';
        req.client_secret ='33907fc327cd46e696f35dac31ac089c'; 
        
        String JSONBody = JSON.serialize(req); 
        
        System.debug('JSON Body-->'+JSONBody);
        
        //  string endpoint = 'https://dev-integration-dx.impellamapi.com/api/v1/oAuth2/token';
        string endpoint = 'https://prod-integration-dx.impellamapi.com/api/v1/oauth2/token';
        Map<String,String> loginheaders = new Map<String, String>();
        loginheaders.put('Content-Type', 'application/json;charset=UTF-8');
        
        HttpResponse res = RestCalloutUtil.MakeCallout(endpoint, 'POST', JSONBody, loginheaders);
        
        system.debug('@@response body '+res.getBody());
        
        ResponseParser.gdprResponse responsegdpr =(ResponseParser.gdprResponse)System.JSON.deserialize(res.getbody(), ResponseParser.gdprResponse.class);
        
        System.Debug('Respone--> '+responsegdpr);
        
        return responsegdpr.access_token;
    }
    
    public  static String postcall(string accesstoken, Id scope)
    {
        String callresult;
        Requestbody.consentdelete req1 = new Requestbody.consentdelete();
        Requestbody.filtersdel req2 = new Requestbody.filtersdel();                     
        req1.deleteType = 'ConsentRegistrationDelete';
        req2.brandname = 'Blue Arrow';
        req2.sourceIdentifier =  scope; 
        req2.actionedBy = Userinfo.getUserId();
        System.debug('Application ID sent'+req2.sourceIdentifier);            
        req1.filter= req2;
        String JSONBody1 = JSON.serialize(req1);
        Map<String,String> headers = new Map<String, String>();
        headers.put('Content-Type', 'application/json;charset=UTF-8');
        headers.put('Authorization', 'Bearer '+ accesstoken);     
        System.debug('Request Body'+req1);
         String endpoint2 = 'https://prod-integration-dx.impellamapi.com/api/v1/consentregistrations/delete';
       // String endpoint2 = 'https://dev-integration-dx.impellamapi.com/api/v1/consentregistrations/delete';      
        HttpResponse res1 = RestCalloutUtil.MakeCallout(endpoint2, 'POST', JSONBody1, headers); 
        System.debug('**Response Recieved**'+res1.getStatusCode());
        if(res1.getStatusCode()!= 200)
        {
            callresult = String.ValueOf(res1.getStatusCode()) ;
        }
        else
        {
            callresult = String.ValueOf(res1.getStatusCode()) ;
        }
        System.debug('callresult '+callresult);
        
        return callresult;
    }
    
    public  static String postcallwithsetting(String accesstoken,Id scope)
    {
        String callresult;
        String statuscode;
        
        Requestbody.consentdelete req1 = new Requestbody.consentdelete();
        Requestbody.filtersdel req2 = new Requestbody.filtersdel();                     
        req1.deleteType = 'ConsentRegistrationDelete';
        req2.brandname = 'Blue Arrow';
        req2.sourceIdentifier =  scope; 
        req2.actionedBy = Userinfo.getUserId();
        System.debug('Application ID sent'+req2.sourceIdentifier);            
        req1.filter= req2;
        String JSONBody1 = JSON.serialize(req1);
        Map<String,String> headers = new Map<String, String>();
        headers.put('Content-Type', 'application/json;charset=UTF-8');
        headers.put('Authorization', 'Bearer '+ accesstoken);     
        System.debug('Request Body'+req1);
        System.debug('Request JSONBody1 '+JSONBody1);
          String endpoint2 = 'https://prod-integration-dx.impellamapi.com/api/v1/consentregistrations/delete';
       // String endpoint2 = 'https://dev-integration-dx.impellamapi.com/api/v1/consentregistrations/delete';      
        HttpResponse res1 = RestCalloutUtil.MakeCallout(endpoint2, 'POST', JSONBody1, headers); 
        System.debug('**Response Recieved**'+res1.getStatusCode());
        
        callresult = String.ValueOf(res1.getStatusCode());
        
        System.debug('callresult '+callresult);
        
        return callresult;
    }
    
}