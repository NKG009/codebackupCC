/*
* Class Name: EmailAddressVerificationController
* Test Class Name: TestEmailAddressVerificationController
* Description: Class to verify Email
*/
public class EmailAddressVerificationController{
    
    public Contact cont {get;set;}
    public Id conId {get;set;}
    public String contactEmailValue{get;set;}
    public String contactEmail{get;set;}
    public String responseCode{get;set;}
    public String responseMessage{get;set;}
    public boolean updateButtonDisplay{get;set;}
    
    /*
    * Method Name: EmailAddressVerificationController
    * Description: Constructor
    * Parameters : ApexPages.StandardController controller
    * Return Type: nothing
    */
    public EmailAddressVerificationController(){
        conId = ApexPages.currentPage().getParameters().get('conId');
        cont = [SELECT id, Email FROM Contact WHERE Id =: conId];
        if(String.IsNotBlank(cont.Email)){
            contactEmailValue = cont.Email;
        }
        else{
            contactEmailValue = '';
        }
        updateButtonDisplay = false;
    }
    
    /*
    * Method Name: contactEmailVerificationFunction
    * Description: Ceriftthe entered Email
    * Parameters : none
    * Return Type: nothing
    */
    public String contactEmailVerificationFunction(){
        system.debug('contactEmailValue***'+contactEmailValue);
        Boolean emailDomainExist = false;
        contactEmailValue = contactEmail;
        if(String.IsBlank(contactEmailValue)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Error: Email cannot be blank.'));
            return null;
        }
        else{
            String url = Label.Email_Verification_URL+getKey()+'&Email='+contactEmailValue+'&Timeout=5000';   
            system.debug('url***'+url);
            String response = getResponse(url);
            JSONParser parser = JSON.createParser(response);
            while (parser.nextToken() != null) {
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    if(parser.getCurrentName() == 'ResponseCode') {
                        parser.nextToken();
                        responseCode = parser.getText();
                    }
                    else if (parser.getCurrentName() == 'ResponseMessage') {
                        parser.nextToken();
                        responseMessage = parser.getText();
                    }
                }
            }
            system.debug('Response suggestions***'+response);
            if(responseCode=='Valid'){
                updateButtonDisplay = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.Email_Success_Message));
                return null;
            }
            if(responseCode=='Invalid'){
                updateButtonDisplay = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Email_Validation_Message));
                return null;
            }
            if(responseCode=='Valid_CatchAll'){system.debug('responseCode---'+responseCode);
                String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
                Pattern MyPattern = Pattern.compile(emailRegex);

                // Then instantiate a new Matcher object "MyMatcher"
                Matcher MyMatcher = MyPattern.matcher(contactEmailValue);

                if (!MyMatcher.matches()) {
                    updateButtonDisplay = false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Email_Message_Invalid+' '+contactEmailValue));
                    return null;
                }
                else {
                    updateButtonDisplay = true;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.Email_Success_Message));
                    return null;
                }
                
            }
            return null;
        }
    }
    
    /*
    * Method Name: contactEmailVerificationFunction
    * Description: Ceriftthe entered Email
    * Parameters : none
    * Return Type: nothing
    */
    public PageReference updateEmailOnContact(){
        cont.Email = contactEmail;
        try{
            update cont;
            PageReference pageref = new PageReference('/'+cont.id);
            pageref.setRedirect(true);
            return pageref;
        }
        catch(Exception e){
            if(e.getmessage().contains('creating a duplicate record. We recommend you use an existing record instead.')){
                Database.DMLOptions dml = new Database.DMLOptions();
                dml.DuplicateRuleHeader.allowSave = true;
                dml.DuplicateRuleHeader.runAsCurrentUser = true;                
                Database.SaveResult sr = Database.update(cont, dml); 
                PageReference pageref = new PageReference('/'+cont.id);
                pageref.setRedirect(true);
                return pageref;
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.EmailAlreadyExist));
                return null;
            }
        }
           
    }
    
    /*
    * Method Name: cancelEmailVerification
    * Description: Ceriftthe entered Email
    * Parameters : none
    * Return Type: nothing
    */
    public PageReference cancelEmailVerification(){
        /*if(String.IsNotBlank(cont.Email)){
            contactEmailValue = cont.Email;
        }
        else{
            contactEmailValue = '';
        }
        updateButtonDisplay = false;*/
        PageReference pageref = new PageReference('/'+cont.id);
        pageref.setRedirect(true);
        return pageref;
    }
    
    /**
    * @description : Common Utility method for making call out
    * @param : String
    * @return : string
    **/    
    public string getResponse(string strURL){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setMethod('GET');
        req.setEndpoint(strURL);
        req.setTimeout(120000);
        res = h.send(req); 
        String responseBody = res.getBody(); 
        system.debug('responseBody---'+responseBody);       
        return responseBody; 
    }
    
    /**
    * @description : To get the Email Api key from custom label
    * @param : 
    * @return : string
    **/
    public string getKey(){
        /*Enter your API key here*/
        string key = Label.Email_Verification_API_Key;
        string output = 'Key=' + key;   
        return output;
    }
    
}