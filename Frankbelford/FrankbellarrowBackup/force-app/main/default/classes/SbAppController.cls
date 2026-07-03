//********************************************************************************************
//********************************************************************************************
//
//     SourceBreaker App Controller, for SSO / AuthCode generation on SourceBreaker App iFrame.
//
//********************************************************************************************
//********************************************************************************************

public class SbAppController {
    public String vfAuthCode {get; set;}
    
    public SbAppController(){
       
        String whichEnviron = SbHelper.whichEnviron();
        Map<String, String> mapOfSettings = SbHelper.findSettings(whichEnviron);
        
        String companySecret = '';
        if(mapOfSettings.containsKey('companysecret') && String.isNotBlank(mapOfSettings.get('companysecret'))){
            companySecret = mapOfSettings.get('companysecret');
        }else{
            companySecret = 'tbc';
            system.debug('No Company Secret defined, please update in SourceBreaker Settings.');
        }
        
        Auth a = new Auth();
        DateTime dt = DateTime.now();
        a.ts = string.valueOf(dt.getTime());
        system.debug(a.ts);
        a.userId = UserInfo.getUserId();
        string authString = 'ts:' + a.ts + ',userId:' + a.userId;
        system.debug('authString: ' +authString);
        Blob tokenBlob = crypto.generateMac('hmacSHA256', Blob.valueOf(authString), Blob.valueOf(companySecret));
        a.authcode = EncodingUtil.base64Encode(tokenBlob);
        system.debug('token: ' + a.authcode);
       
        vfAuthCode = EncodingUtil.base64Encode(Blob.valueOf(JSON.serialize(a)));
        
    }
    
    //A inner class used to generate the authentication info
    private class Auth{
        String authcode;
        String userId;
        String ts;
    } 
    
}