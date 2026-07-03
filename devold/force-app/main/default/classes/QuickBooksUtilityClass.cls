public class QuickBooksUtilityClass {
    
    public static QBO_Quickbooks_App_Info__c QBappInfo = QBO_Quickbooks_App_Info__c.getOrgDefaults();
    /*
* @Name - doFetchAccessToken
* @Param - None
* @Description - to get the Access Token , Refresh Token and other Information after getting the authentication code
* @ReturnType - void
*/
    public static void doFetchAccessToken(){
        system.debug('QBappInfo'+QBappInfo);
        String encodedString = EncodingUtil.base64Encode(Blob.valueOf(QBappInfo.QBO_Client_ID__c+':'+QBappInfo.QBO_Client_Secret__c));
        String endPoint='';
        if(test.isRunningTest()){ endPoint='https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer';}
        else{ endPoint = QBappInfo.QBO_Access_Token_Url__c;}
        
        String oAuthCode = ApexPages.currentPage().getParameters().get('code');
        String requestBody = 'grant_type=authorization_code&code='+oAuthCode+'&redirect_uri='+QBappInfo.QBO_Redirect_URI__c;
        String errorMessage ='';
        
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        Http http = new Http();
        httpReq.setMethod('POST');
        httpReq.setEndPoint(endPoint);
        httpReq.setHeader('Authorization' , 'Basic '+encodedString);
        httpReq.setHeader('Content-Type' , 'application/x-www-form-urlencoded');
        httpReq.setBody(requestBody);
        
        try{
            httpRes = http.send(httpReq);
            
            if(httpRes.getStatusCode() == 200){
                system.debug('Body '+httpRes.getBody());
                Map<String, Object> response_Map = (Map<String, Object>)JSON.deserializeUntyped(httpRes.getBody());
                List<QBO_QuickBook_Auth_Info__c> connectSettingInfos = new List<QBO_QuickBook_Auth_Info__c>();
                connectSettingInfos = [Select Id, Name,QBO_Expires_In_Date_Time__c From QBO_QuickBook_Auth_Info__c order by createddate Desc Limit 1];
                QBO_QuickBook_Auth_Info__c quickBooksSettingInfo = new QBO_QuickBook_Auth_Info__c();
                system.debug(response_Map);
                String accessToken = (String)response_Map.get('access_token');
                String refreshToken = (String)response_Map.get('refresh_token');
                Decimal expiresIn = (Decimal)response_Map.get('expires_in');
                Decimal expiresInRefToken = (Decimal)response_Map.get('x_refresh_token_expires_in');
                
                
                quickBooksSettingInfo.QBO_Access_Token__c = accessToken;
                quickBooksSettingInfo.QBO_Refresh_Token__c = refreshToken;
                quickBooksSettingInfo.QBO_Expires_In_Seconds__c = expiresIn;
                quickBooksSettingInfo.QBO_Refresh_Token_Expires_In__c = expiresInRefToken;
                quickBooksSettingInfo.QBO_Expires_In_Date_Time__c = System.Now().addSeconds(Integer.valueOf(expiresIn));
                if(connectSettingInfos!=null && connectSettingInfos.size() > 0 ) quickBooksSettingInfo.Id = connectSettingInfos[0].Id;
                
                upsert quickBooksSettingInfo;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Successfully Authenticated with Quickbooks System!!!'));
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unexpected Error while communicating with Quickbooks API'+
                                                           'Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode()));
            }
            
        }catch(System.Exception e){
            System.debug('#### Exception Executed '+e.getStackTraceString());
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                    +' Remote Site Setting and add '+' '+ endPoint +' Endpoint';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                //return null;
            }else{
                errorMessage = 'Unexpected Error while communicating with Quickbooks API. '
                    +'Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode();
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                //return null;
            }
        }  
    }
    
    /*
* @Name - doRefreshAccessToken
* @Param - None
* @Description - to get the Refresh Token and other Information after access token expires
* @ReturnType - void
*/
    public static QBO_QuickBook_Auth_Info__c doRefreshAccessToken(){
        try{
       	    String encodedString = EncodingUtil.base64Encode(Blob.valueOf(QBappInfo.QBO_Client_ID__c+':'+QBappInfo.QBO_Client_Secret__c));
            String endPoint='';
           if(test.isRunningTest()){ endPoint='https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer';}
            else
            { endPoint = QBappInfo.QBO_Access_Token_Url__c;}
            
            List<QBO_QuickBook_Auth_Info__c> QBInfo = new List<QBO_QuickBook_Auth_Info__c>();
            QBInfo = [Select Id, QBO_Access_Token__c, QBO_Expires_In_Seconds__c,QBO_Expires_In_Date_Time__c, QBO_Refresh_Token__c,
                      QBO_Refresh_Token_Expires_In__c  From QBO_QuickBook_Auth_Info__c order by createddate Desc Limit 1];
            
            QBO_QuickBook_Auth_Info__c quickBooksSettingInfo= New QBO_QuickBook_Auth_Info__c();
            //String oAuthCode = ApexPages.currentPage().getParameters().get('code');
            String requestBody = 'grant_type=refresh_token&refresh_token=';
            if(QBInfo!=null && !QBInfo.isEmpty() && QBInfo[0].QBO_Refresh_Token__c != null){
                requestBody+= QBInfo[0].QBO_Refresh_Token__c;
                quickBooksSettingInfo=QBInfo[0];
            }
            if(QBInfo != null && QBInfo[0].QBO_Expires_In_Date_Time__c <= System.Now()){
                String errorMessage ='';
                
                HttpRequest httpReq = new HttpRequest();
                HttpResponse httpRes = new HttpResponse();
                Http http = new Http();
                httpReq.setMethod('POST');
                httpReq.setEndPoint(endPoint);
                httpReq.setHeader('Authorization' , 'Basic '+encodedString);
                httpReq.setHeader('Content-Type' , 'application/x-www-form-urlencoded');
                httpReq.setBody(requestBody);
                
                // Check if Access Token is expired or not.
                // if Expired then get the new Token
                httpRes = http.send(httpReq);
                if(httpRes.getStatusCode() == 200){
                    Map<String, Object> response_Map = (Map<String, Object>)JSON.deserializeUntyped(httpRes.getBody());
                    
                    String accessToken = (String)response_Map.get('access_token');
                    String refreshToken = (String)response_Map.get('refresh_token');
                    Decimal expiresIn = (Decimal)response_Map.get('expires_in');
                    Decimal expiresInRefToken = (Decimal)response_Map.get('x_refresh_token_expires_in');
                    
                    quickBooksSettingInfo.QBO_Access_Token__c = accessToken;
                    quickBooksSettingInfo.QBO_Refresh_Token__c = refreshToken;
                    quickBooksSettingInfo.QBO_Expires_In_Seconds__c = expiresIn;
                    quickBooksSettingInfo.QBO_Refresh_Token_Expires_In__c = expiresInRefToken;
                    quickBooksSettingInfo.QBO_Expires_In_Date_Time__c = System.Now().addSeconds(Integer.valueOf(expiresIn));
                    return quickBooksSettingInfo;
                } else {
                    LogUtil.errorLogs.add(LogUtil.createLog('QuickBooksUtilityClass', 'doRefreshAccessToken', LogUtil.ERROR, httpRes.getStatusCode(), 
                                                            httpRes.getBody()));
                }
            } else {
                return quickBooksSettingInfo;
            }
        } catch(System.Exception e){
            LogUtil.errorLogs.add(LogUtil.createLog('QuickBooksUtilityClass', 'doRefreshAccessToken', LogUtil.ERROR, null, 
                                                    e.getMessage() +' at line ' +e.getLineNumber() + ' '+ e.getStackTraceString()));
        }
        return null;
    }
}