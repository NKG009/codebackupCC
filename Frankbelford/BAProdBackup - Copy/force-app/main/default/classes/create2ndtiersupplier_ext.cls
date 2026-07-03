public class create2ndtiersupplier_ext {
    
    public Contact conrec{get;set;}
    public String recordtypeid{get;set;}
    public String rectypename{get;set;}
    public String OwnerID{get;set;}
    public String ownername{get;set;}
    public string lightningTheme ='Theme4d';
    public String responseCode{get;set;}
    public String responseMessage{get;set;}
    
    // Simple accessors for the System.UserInfo theme methods
    public String getContextUserUiThemeDisplayed() {
        return UserInfo.getUiThemeDisplayed();
    }

    public create2ndtiersupplier_ext(ApexPages.StandardController controller){
        conrec= new Contact();
        recordtypeid = ApexPages.currentPage().getParameters().get('recid');
        conrec.RecordTypeId = recordtypeid;//jyothi
        RecordType rec = [Select id,Name from RecordType where id =: recordtypeid];
        rectypename = rec.Name;

        // ownerid = UserInfo.getUserId();
        User u = [Select id,Name from User where id=:UserInfo.getUserId()];
        ownername = u.Name;
    }
    
    public pageReference cancelredirect(){
        Pagereference pagenew = new Pagereference('/003/o');
        pagenew.setRedirect(true);
        return pagenew;
    }

    
    public PageReference saveandredirect1(){
        Contact con = new Contact();
        con.RecordTypeid = recordtypeid;
        con.OwnerID = UserInfo.getUserId();
        con.Person_Status__c = conrec.Person_Status__c;
        con.Salutation = conrec.Salutation;
        con.MobilePhone = conrec.MobilePhone;
        con.FirstName = conrec.FirstName;
        con.Phone =conrec.Phone;
        con.MiddleName = conrec.MiddleName;
        con.OtherPhone = conrec.OtherPhone;
        con.LastName = conrec.LastName;
        con.Email = conrec.Email;
        con.Suffix = conrec.Suffix;
        con.ts2__Contact_Method__c = conrec.ts2__Contact_Method__c;     
        con.IP_CandidateIDlegacy__c = conrec.IP_CandidateIDlegacy__c;
        con.sirenum__General_Comments__c = conrec.sirenum__General_Comments__c;
        con.ts2__EEO_Gender__c = conrec.ts2__EEO_Gender__c;
        con.Birthdate =conrec.Birthdate;
        con.IP_CategoryOfWork__c = conrec.IP_CategoryOfWork__c;    
        con.sirenum__National_Insurance__c = conrec.sirenum__National_Insurance__c;
        con.IP_WorkerStartDate__c =conrec.IP_WorkerStartDate__c;
        con.AccountID = conrec.AccountID;
        con.ts2__Preferred_Name__c = conrec.ts2__Preferred_Name__c;
     
        try{
            if(String.IsNotblank(conrec.Email)){
                String responseCodeValue = contactEmailVerificationFunction(conrec.Email);
                if(responseCodeValue=='Valid' || responseCodeValue=='Valid_CatchAll'){
                    String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
                    Pattern MyPattern = Pattern.compile(emailRegex);

                    // Then instantiate a new Matcher object "MyMatcher"
                    Matcher MyMatcher = MyPattern.matcher(conrec.Email);

                    if (!MyMatcher.matches()) {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Email_Message_Invalid+' '+conrec.Email));
                        return null;
                    }
                    else {
                        con.Email = conrec.Email;
                        insert con;
                        String getLightning = getContextUserUiThemeDisplayed();
                        if(lightningTheme.equals(getLightning)){
                            PageReference pageref = new PageReference('/apex/ContactAddressFinder?id='+con.id);
                            pageref.setRedirect(true);
                            return pageref;
                        }
                        else{
                            PageReference pageref = new PageReference('/apex/pca__ContactAddressFinder?id='+con.id);
                            pageref.setRedirect(true);
                            return pageref;
                        }
                    }                    
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Email address was fully validated'));
                    //return null;
                }
                else if(responseCodeValue=='Invalid'){
                    conrec.Email = conrec.Email;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Email_Validation_Message));
                    return null;
                }
            }   
            else{
                insert con;
                String getLightning = getContextUserUiThemeDisplayed();
                if(lightningTheme.equals(getLightning)){
                    PageReference pageref = new PageReference('/apex/ContactAddressFinder?id='+con.id);
                    pageref.setRedirect(true);
                    return pageref;
                }
                else{
                    PageReference pageref = new PageReference('/apex/pca__ContactAddressFinder?id='+con.id);
                    pageref.setRedirect(true);
                    return pageref;
                }
            }
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
        return null;        
    }

    public String contactEmailVerificationFunction(String contactEmailValue){
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
        return responseCode;
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