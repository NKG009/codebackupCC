public class AgencyAccountAuthenticationController {
    public static String oAuthCode{get;set;}
    public static String accessToken{get;set;}
    public static string recordid{get;set;}
    public static String RefreshToken{get;set;}
    public static integer expireinsec{get;set;}
    
    @auraEnabled
    public static String getOAuthcode(string recordId){
        system.debug('recordIdinapx'+recordId);
        recordid=recordId;
        Agency_Account_Integration_Info__mdt [] aaii =[select MasterLabel, Access_Token_Url__c,Client_ID__c,Client_Secret__c,OAuth_Url__c,Redirect_Uri__c from Agency_Account_Integration_Info__mdt limit 1];
        
        string Oauthurl=aaii[0].OAuth_Url__c+recordId+'&client_id='+aaii[0].Client_ID__c+'&scope=contact:read%20property:read%20activity:read%20activity:write%20communication:read%20transaction:write offline_access&redirect_uri='+aaii[0].Redirect_Uri__c;
        system.debug('url'+Oauthurl);
        
        return Oauthurl;
    }
    
    public PageReference getAuthorization(){
        String oAuthCode = ApexPages.currentPage().getParameters().get('code');  
        String agid = ApexPages.currentPage().getParameters().get('state');
        System.debug('oauthcode is='+oAuthCode);
        System.debug('agid is='+agid);
        
        Agency_Account_Integration_Info__mdt [] aaii =[select MasterLabel, Access_Token_Url__c,Client_ID__c,Client_Secret__c,OAuth_Url__c,Redirect_Uri__c from Agency_Account_Integration_Info__mdt limit 1];
        
        string client_Id=aaii[0].Client_ID__c;
        string consumer_Secret=aaii[0].Client_Secret__c;
        String encodedString = EncodingUtil.base64Encode(Blob.valueOf(client_Id+':'+consumer_Secret));
        String requestBody = 'grant_type=authorization_code&code='+oAuthCode+'&redirect_uri='+aaii[0].Redirect_Uri__c;
        String errorMessage ='';      
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        httpReq.setMethod('POST');
        httpReq.setEndPoint(aaii[0].Access_Token_Url__c);
        httpReq.setHeader('Authorization' , 'Basic '+encodedString);
        httpReq.setHeader('Content-Type' , 'application/x-www-form-urlencoded');
        httpReq.setBody(requestBody);
        HttpResponse httpRes = http.send(httpReq);
        if(httpRes.getStatusCode() == 200) {
            System.debug(httpRes.getBody());
            Map<String, Object> response_Map = (Map<String, Object>)JSON.deserializeUntyped(httpRes.getBody());
            accessToken = (String)response_Map.get('access_token');
            RefreshToken = (String)response_Map.get('refresh_token');
            expireinsec = (integer)response_Map.get('expires_in');

            system.debug('accessToken'+ accessToken);
            
            
            
        }
        else{
            System.debug('not connected');
            
        }
        system.debug('updrecordidate'+recordid);
        
        Agency_Integration_Info__c [] infotoupdate =[ select id,Agency_Account__c from Agency_Integration_Info__c where id=:agid limit 1];
        system.debug('infotoupdate'+infotoupdate);
        Agency_Integration_Info__c agi=new Agency_Integration_Info__c();
        agi.Id=infotoupdate[0].id;
        agi.Access_Token__c=accessToken;
        agi.Refresh_Token__c=RefreshToken;
        agi.Expires_In_Seconds__c=expireinsec;
        agi.Expires_In_Date_Time__c= system.now().addSeconds(expireinsec);
        agi.Connected__c='YES';
        update agi;
        
        final PageReference target = new PageReference('/'+agid);
        target.setRedirect(true);
        return target;
        
    }
    
    public static void GetRefreshToken(id AiiID){
        try{
        Agency_Account_Integration_Info__mdt [] aaii =[select MasterLabel, Access_Token_Url__c from Agency_Account_Integration_Info__mdt limit 1];
        Agency_Integration_Info__c AIIrec =[select id,Access_Token__c,Client_ID__c,Client_Secret__c,Refresh_Token__c from Agency_Integration_Info__c where id=:AiiID limit 1];
        
        string client_Id=AIIrec.Client_ID__c;
        string consumer_Secret=AIIrec.Client_Secret__c;
        String encodedString = EncodingUtil.base64Encode(Blob.valueOf(client_Id+':'+consumer_Secret));
        String requestBody ='grant_type=refresh_token&refresh_token='+AIIrec.Refresh_Token__c;
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        httpReq.setMethod('POST');
        httpReq.setEndPoint(aaii[0].Access_Token_Url__c);
        httpReq.setHeader('Authorization' , 'Basic '+encodedString);
        httpReq.setHeader('Content-Type' , 'application/x-www-form-urlencoded');
        httpReq.setBody(requestBody);
        HttpResponse httpRes = http.send(httpReq);
        if(httpRes.getStatusCode() == 200) {
            System.debug(httpRes.getBody());
            Map<String, Object> response_Map = (Map<String, Object>)JSON.deserializeUntyped(httpRes.getBody());
            String ReaccessToken = (String)response_Map.get('access_token');
            String ReRefreshToken = (String)response_Map.get('refresh_token');
            integer Reexptime = (integer)response_Map.get('expires_in');
            Agency_Integration_Info__c agi1=new Agency_Integration_Info__c();
            agi1.Id=AIIrec.id;
            agi1.Access_Token__c=ReaccessToken;
            agi1.Refresh_Token__c=ReRefreshToken;
            agi1.Expires_In_Seconds__c=Reexptime;
            agi1.Expires_In_Date_Time__c= system.now().addSeconds(Reexptime);
            update agi1;
        }
        }
          catch(Exception ex){
        Error_Log__c errorLog = new Error_Log__c();
            errorLog.Error_Type__c = 'ERROR';
            errorLog.Error_Status_Code__c = '';
            errorLog.Error_Message__c = ex.getMessage();
            errorLog.Error_Description__c = 'Error while processing the request:'+ ex;
            errorLog.Class_Name__c = 'BatchForRefreshTokenPropertyMe';
            errorLog.Method_Name__c = 'AgencyAccountAuthenticationController.GetRefreshToken';
            insert errorLog;
          }    
    }
}