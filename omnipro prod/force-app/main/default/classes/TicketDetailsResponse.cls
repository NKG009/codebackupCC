public class TicketDetailsResponse {
    
    public static string response(Decimal zendId){ //String zdId
        Decimal zendeskId = zendId;
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://omnipro.zendesk.com/api/v2/tickets/'+zendeskId);
       
        req.setMethod('GET');
        String USER_EMAIL = 'ekehoe@omnipro.ie';
		String API_TOKEN = 'JsKfoxUDt3DJtjgqtH6CSGiu0Srxeu4w7zdvBQX2';
		String authHeader = USER_EMAIL + '/token:' + API_TOKEN;
        String authorizationHeader = EncodingUtil.base64Encode(Blob.valueOf(authHeader));
		req.setHeader('Authorization', 'Basic ' + authorizationHeader);        
        req.setHeader('Accept', 'application/json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('response body ::: '+res.getBody());
        if(res.getStatusCode() == 200){
            return res.getBody();
        }else{
            return 'RecordNotFound for ticket number '+zendId;
        }
        
    }

}