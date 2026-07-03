public class CreateContactPage_ext {

    public Contact conrec{get;set;}
    public string accIdfrompage{get;set;}
    public String recordtypeid{get;set;}
    public String rectypename{get;set;}
    public String OwnerID{get;set;}
    public String ownername{get;set;}
    public boolean checkacc{get;set;}
    public String Acctid;
    public static String fname{get;set;}
    public String lname{get;set;}
    public String SiteId{get;set;}
    public String PorRole{get;set;}
    public String emailval{get;set;}
    public String SiteContact{get;set;}
    public String AccountName{get;set;}
    public Account acc{get;set;}
    public sirenum__Site__c sitedetail{get;set;}
    public string lightningTheme ='Theme4d';
    public String responseCode{get;set;}
    public String responseMessage{get;set;}
    
    // Simple accessors for the System.UserInfo theme methods
    public String getContextUserUiThemeDisplayed() {
        return UserInfo.getUiThemeDisplayed();
    }
    
    public CreateContactPage_ext(ApexPages.StandardController controller) {
        conrec= new Contact();
        recordtypeid = ApexPages.currentPage().getParameters().get('recid');
        RecordType rec = [Select id,Name from RecordType where id =: recordtypeid];
        rectypename = rec.Name;
        system.debug('action '+accIdfrompage);
        if(ApexPages.currentPage().getParameters().get('siteId') != null){
            fname =  ApexPages.currentPage().getParameters().get('fname');
            lname =  ApexPages.currentPage().getParameters().get('lname');
            Acctid = ApexPages.currentPage().getParameters().get('accid');
            SiteId = ApexPages.currentPage().getParameters().get('siteId');
            emailval = ApexPages.currentPage().getParameters().get('eml');
            conrec.FirstName = fname;
            conrec.LastName = lname;
            conrec.Email = emailval;
            PorRole = ApexPages.currentPage().getParameters().get('prole');
            sitedetail = [Select id,sirenum__Phone1__c,sirenum__Street_Address__c,sirenum__City__c,sirenum__County__c,sirenum__Country__c,sirenum__Postal_Code__c from sirenum__Site__c where id=: SiteId limit 1];    
            conrec.AccountID = Acctid;
            conrec.MailingStreet= sitedetail.sirenum__Street_Address__c;
            conrec.MailingCity=sitedetail.sirenum__City__c; 
            conrec.MailingPostalCode=sitedetail.sirenum__Postal_Code__c ;
            conrec.MailingState=sitedetail.sirenum__County__c;
            conrec.MailingCountry=sitedetail.sirenum__Country__c;
            conrec.Phone=sitedetail.sirenum__Phone1__c;      
        }
        else if(ApexPages.currentPage().getParameters().get('accid') != null){
            checkacc = false;  
            if(ApexPages.currentPage().getParameters().get('fname')!=null){
                fname =  ApexPages.currentPage().getParameters().get('fname');
                lname =  ApexPages.currentPage().getParameters().get('lname');
                //   SiteContact = ApexPages.currentPage().getParameters().get('Sconlink');
                SiteId = ApexPages.currentPage().getParameters().get('siteId');
                conrec.FirstName = fname;
                conrec.LastName = lname;           
                conrec.Email = emailval;
            }
            else{
                conrec.FirstName = fname;              
                conrec.LastName = lname;
            }
            Acctid = ApexPages.currentPage().getParameters().get('accid');
            acc = [select Id,name,BillingStreet,recordType.DeveloperName, BillingCity, BillingPostalCode, BillingState, BillingCountry, Phone from Account where id=:Acctid limit 1];
            system.debug('ACC '+acc);
            AccountName = acc.Name;
            conrec.AccountID = acc.ID;
            conrec.MailingStreet= acc.BillingStreet;
            conrec.MailingCity=acc.BillingCity;      
            conrec.MailingPostalCode=acc.BillingPostalCode;
            conrec.MailingState=acc.BillingState;     
            conrec.MailingCountry=acc.BillingCountry;      
        }
        else{
            checkacc = true;
        }
        User u = [Select id,Name from User where id=:UserInfo.getUserId()];
        ownername = u.Name;
    }
    
    public pageReference cancelredirect(){
        Pagereference pagenew = new Pagereference('/003/o');
        pagenew.setRedirect(true);
        return pagenew;
    }
    
    
    
    public PageReference changeAcc(){
        system.debug('action '+accIdfrompage);
        /*  acc= [select Id,name,BillingStreet,recordType.DeveloperName, BillingCity, BillingPostalCode, BillingState, BillingCountry, Phone from Account where id=:accIdfrompage limit 1];
        AccountName = acc.Name;

        conrec.AccountID = acc.ID;
        conrec.MailingStreet= acc.BillingStreet;
        conrec.MailingCity=acc.BillingCity; 
        conrec.MailingPostalCode=acc.BillingPostalCode;
        conrec.MailingState=acc.BillingState;
        conrec.MailingCountry=acc.BillingCountry;  */
        PageReference pageref = new PageReference('/apex/CreateContactPage?recid=0120Y000000UW9kQAG&accid='+accIdfrompage+'&lname='+conrec.LastName+'&fname='+conrec.Firstname);
        pageref.setRedirect(true);
        return pageref;
        // return null;
    }
    
    public PageReference SaveandAddAddress(){
        system.debug('ACCin class '+acc);
        Contact con = new Contact();
        con.AccountID = Acctid;
        con.Salutation = conrec.Salutation;
        con.Phone =conrec.Phone;
        con.FirstName = conrec.FirstName;
        con.MobilePhone = conrec.MobilePhone;
        con.MiddleName = conrec.MiddleName;
        con.Fax= conrec.Fax;
        con.LastName = conrec.LastName;
        con.OtherPhone = conrec.OtherPhone;    
        con.Suffix = conrec.Suffix;
        con.Email = conrec.Email;
        con.ts2__Preferred_Name__c = conrec.ts2__Preferred_Name__c;
        con.IP_PreferredMethodOfContact__c = conrec.IP_PreferredMethodOfContact__c;

        con.OwnerID = UserInfo.getUserId();
        con.RecordTypeid = recordtypeid;
        con.IP_JobTitle__c = conrec.IP_JobTitle__c;
        con.Department = conrec.Department;    
        con.Person_Status__c = conrec.Person_Status__c;
        con.IP_CategoryOfWork__c = conrec.IP_CategoryOfWork__c;
        con.IP_BusinessFunction__c = conrec.IP_BusinessFunction__c;
        con.IP_ContactType__c = conrec.IP_ContactType__c;
        con.ts2__Legacy_ContactID__c = conrec.ts2__Legacy_ContactID__c;        
        try{
            if(String.IsNotblank(conrec.Email)){
                String responseCodeValue = contactEmailVerificationFunction(conrec.Email);
                if(responseCodeValue=='Valid' ||  responseCodeValue=='Valid_CatchAll'){
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
                        if(SiteId!=null){
                            Contact_Site_link__c cs1 = new Contact_Site_link__c();
                            cs1.IP_Contact__c = con.id;
                            cs1.IP_Site__c = SiteId;
                            cs1.Account__c  = Acctid;
                            cs1.IP_PortalType__c = PorRole;
                            insert cs1;
                        }
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
                else if(responseCodeValue=='Invalid'){
                    conrec.Email = conrec.Email;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Email_Validation_Message));
                    return null;
                }
            }   
            else{
                insert con; 
                if(SiteId!=null){
                    Contact_Site_link__c cs1 = new Contact_Site_link__c();
                    cs1.IP_Contact__c = con.id;
                    cs1.IP_Site__c = SiteId;
                    cs1.Account__c  = Acctid;
                    cs1.IP_PortalType__c = PorRole;
                    insert cs1;
                }
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
            System.debug('SS '+e);
            return null;
        }return null;
    }
    
    public PageReference  saveandredirect2(){
        system.debug('PorRole '+PorRole);
        system.debug('Conrec Account '+conrec.Account.recordtype.Developername);
        system.debug('Conrec '+conrec.LastName);
        Contact con = new Contact();
        con.AccountID = Acctid ;
        con.Salutation = conrec.Salutation;
        con.Phone =conrec.Phone;
        con.FirstName = conrec.FirstName;
        con.MobilePhone = conrec.MobilePhone;
        con.MiddleName = conrec.MiddleName;
        con.Fax= conrec.Fax;
        con.LastName = conrec.LastName;
        con.OtherPhone = conrec.OtherPhone;    
        con.Suffix = conrec.Suffix;
        con.Email = conrec.Email;
        con.ts2__Preferred_Name__c = conrec.ts2__Preferred_Name__c;
        con.IP_PreferredMethodOfContact__c = conrec.IP_PreferredMethodOfContact__c;
        /* if(Acctid == null)
        {
        con.AccountID = conrec.AccountID;
        acc = [Select id,BillingStreet,BillingCity,BillingPostalCode,BillingState,BillingCountry from Account where id=: conrec.AccountID];
        }
        else
        {
        con.AccountID = Acctid;
        acc = [Select id,BillingStreet,BillingCity,BillingPostalCode,BillingState,BillingCountry from Account where id=: Acctid];

        }

        con.MailingStreet = acc.BillingStreet;
        con.MailingCity=acc.BillingCity; 
        con.MailingPostalCode=acc.BillingPostalCode;
        con.MailingState=acc.BillingState;
        con.MailingCountry=acc.BillingCountry;*/
        con.OwnerID = UserInfo.getUserId();
        con.RecordTypeid = recordtypeid;
        con.IP_JobTitle__c = conrec.IP_JobTitle__c;
        con.Department = conrec.Department;    
        con.Person_Status__c = conrec.Person_Status__c;
        con.IP_CategoryOfWork__c = conrec.IP_CategoryOfWork__c;
        con.IP_BusinessFunction__c = conrec.IP_BusinessFunction__c;
        con.IP_ContactType__c = conrec.IP_ContactType__c;
        con.ts2__Legacy_ContactID__c = conrec.ts2__Legacy_ContactID__c;  
        con.MailingStreet= conrec.MailingStreet;
        con.MailingCity=conrec.MailingCity; 
        con.MailingPostalCode=conrec.MailingPostalCode;
        con.MailingState=conrec.MailingState;
        con.MailingCountry=conrec.MailingCountry;       
        con.OtherStreet= conrec.OtherStreet;
        con.OtherCity=conrec.OtherCity; 
        con.OtherPostalCode=conrec.OtherPostalCode;
        con.OtherState=conrec.OtherState;
        con.OtherCountry=conrec.OtherCountry; 
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
                        if(SiteId!=null){
                            Contact_Site_link__c cs1 = new Contact_Site_link__c();
                            cs1.IP_Contact__c = con.id;
                            cs1.IP_Site__c = SiteId;
                            cs1.Account__c  = Acctid;
                            cs1.IP_PortalType__c = PorRole;
                            insert cs1;
                        }
                        PageReference pageref = new PageReference('/'+con.id);
                        pageref.setRedirect(true);     
                        return pageref;
                    }
                    
                }
                else if(responseCodeValue=='Invalid'){
                    conrec.Email = conrec.Email;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Email_Validation_Message));
                    return null;
                }
            }   
            else{
                insert con; 
                if(SiteId!=null){
                    Contact_Site_link__c cs1 = new Contact_Site_link__c();
                    cs1.IP_Contact__c = con.id;
                    cs1.IP_Site__c = SiteId;
                    cs1.Account__c  = Acctid;
                    cs1.IP_PortalType__c = PorRole;
                    insert cs1;
                }
                PageReference pageref = new PageReference('/'+con.id);
                pageref.setRedirect(true);     
                return pageref;
            }
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            System.debug('SS '+e);
            return null;
        }return null;
    }
    
    /**
    * @description : API Call to validate the Email
    * @param : String
    * @return : string
    **/
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