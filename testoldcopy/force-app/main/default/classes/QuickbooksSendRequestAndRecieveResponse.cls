public class QuickbooksSendRequestAndRecieveResponse {
  /*  private static String CompanyId = QBO_Quickbooks_App_Info__c.getOrgDefaults().QBO_Company_Id__c;
    private static String Endpoint = QBO_Quickbooks_App_Info__c.getOrgDefaults().QBO_OrgEndPoint__c;
    public static QBO_QuickBook_Auth_Info__c quickBooksSettingInfo = QuickBooksUtilityClass.doRefreshAccessToken();
    
    public static string SendRequest(String requestbody, String ObjectType, String method) {
        system.debug('quickBooksSettingInfo::' + quickBooksSettingInfo);
        if(quickBooksSettingInfo != null) {
            try{
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setMethod(method);
                req.setEndPoint(Endpoint+'/v3/company/'+CompanyId+'/'+ObjectType);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Authorization', 'Bearer '+quickBooksSettingInfo.QBO_Access_Token__c);
                req.setHeader('Accept', 'application/json');
                req.setBody(requestbody);
                HttpResponse res = h.send(req);
                system.debug('Status Code::'+res.getStatusCode());
                system.debug('Response body::'+res.getBody());
                if(res.getStatusCode() == 200 || res.getStatusCode() == 201) {
                    return res.getbody();
                } else {
                    LogUtil.errorLogs.add(LogUtil.createLog('QuickbooksSendRequestAndRecieveResponse', 'SendRequest', LogUtil.ERROR, res.getStatusCode(), 
                                                            res.getBody()));
                }
            }catch(exception e){
                LogUtil.errorLogs.add(LogUtil.createLog('QuickbooksSendRequestAndRecieveResponse', 'SendRequest', LogUtil.ERROR, null, 
                                                        e.getMessage() +' at line ' +e.getLineNumber() + ' '+ e.getStackTraceString()));
            } 
        }
        return null;
    }
    
    public static HTTPResponse getRequest(String objectType) {
        String APIURL = Endpoint +'/v3/company/' + CompanyId + '/' + objectType;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(APIURL);
        req.setMethod('GET');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Bearer ' + quickBooksSettingInfo.QBO_Access_Token__c);
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-type', 'application/json'); 
        Http http = new Http();
        HTTPResponse res = http.send(req);
        system.debug('Status Code::'+res.getStatusCode());
        system.debug('Response body::'+res.getBody());
        if(res.getStatusCode() != 200 && res.getStatusCode() != 201) {
            LogUtil.errorLogs.add(LogUtil.createLog('QuickbooksSendRequestAndRecieveResponse', 'getRequest', LogUtil.ERROR, objectType, 
                                                    res.getStatusCode(), res.getBody()));
        }
        return res;
    }*/
}