global without sharing class MyDemoToken {

    
    public static HttpResponse getAccessToken(){
        try{  
            
            Map<String, Object> results = new Map<String, Object>();                 
            HttpRequest req = new HttpRequest(); 
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept','application/json');    
            req.setEndpoint('https://dev-integration-dx.impellamapi.com/api/v1/oauth2/token');            
            req.setTimeout(120000); 
            req.setBody('{"grant_type" : "client_credentials","client_id":"e7838bae08a24a08b51b0a0b378cfed363280d993367457689e008f74c46b3a1","client_secret" : "33907fc327cd46e696f35dac31ac089c"}');
            Http http = new Http();
            HTTPResponse response = http.send(req);    
            //results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            //results.put('update','yes');                                           
            return response;
        }catch(CallOutException e){
            throw e;
        }        
    }
    
}