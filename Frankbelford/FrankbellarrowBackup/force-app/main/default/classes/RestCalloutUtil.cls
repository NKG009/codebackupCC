global class RestCalloutUtil
{  
/**
* This method is used to make http callouts.
* @param - It will have Endpoint, Method(pre/post) and Body values.
* @return - It returns HttpResponse
* @throws - This method throws a Callout exception.
*/
    public static HttpResponse MakeCallout(string endpoint, string method, string strJson, Map<String,String> header)
    {
        Http h = new Http(); 
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        for (String headerKey : header.keySet()){
            req.setHeader(headerKey, header.get(headerKey));
        }
        req.setEndpoint(endpoint); 
        req.setMethod(method);
        req.setTimeout(120000);
        System.debug('method=>'+method); 
        System.debug('endpoint=>'+endpoint);
        System.debug('header=>'+header); 
        System.debug('String JSON=>'+strJson); 
        if (strJson!=null && strJson!='')req.setBody(strJson);
        try{
            res = h.send(req);
            System.debug('res=>'+res);       
            if(res.getStatusCode()!=200){   
                System.debug('An exception occured');
            }
            return res; 
        }catch(Exception e){ 
            System.debug('An exception occured: '+ e);
            return res;
        }           
    }
}