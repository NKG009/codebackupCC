public class CreateCandidatePage_ext {

    public Contact conrec{get;set;}
    public String recordtypeid{get;set;}
    public String rectypename{get;set;}
    public String OwnerID{get;set;}
    public String ownername{get;set;}
    public boolean displayduplicate{get;set;}
    public Contact con;
    public integer countdup{get;set;}
    public List<Contact> ppList{get;set;} 
    public List<Contact> conList = new List<Contact>();
    public string lightningTheme ='Theme4d';
    public String responseCode{get;set;}
    public String responseMessage{get;set;}
    
    // Simple accessors for the System.UserInfo theme methods
    public String getContextUserUiThemeDisplayed() {
        return UserInfo.getUiThemeDisplayed();
    }

    public CreateCandidatePage_ext(ApexPages.StandardController controller) {
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
    
    public PageReference  saveandredirect(){
        con = new Contact();
        con.RecordTypeid = recordtypeid;
        con.OwnerID = UserInfo.getUserId();
        con.Person_Status__c = conrec.Person_Status__c;
        con.Reference_Status__c = conrec.Reference_Status__c;
        con.Salutation = conrec.Salutation;
        con.MobilePhone = conrec.MobilePhone;
        con.FirstName = conrec.FirstName;
        con.Phone =conrec.Phone;
        con.MiddleName = conrec.MiddleName;
        con.OtherPhone = conrec.OtherPhone;
        con.LastName = conrec.LastName;
        con.Email = conrec.Email;
        con.Suffix = conrec.Suffix;
        con.Preferred_Name__c = conrec.Preferred_Name__c;
        con.TR1__Consent_Types__c = conrec.TR1__Consent_Types__c;     
        con.IP_NextOfKinInfo__c = conrec.IP_NextOfKinInfo__c;
        con.Perm_Work__c = conrec.Perm_Work__c;
        con.IP_CandidateIDlegacy__c = conrec.IP_CandidateIDlegacy__c;
        con.Temp_Work__c = conrec.Temp_Work__c;
        con.IP_PreferredLocation__c = conrec.IP_PreferredLocation__c;
        con.Student__c = conrec.Student__c;
        con.IP_StudentWorkHours__c =conrec.IP_StudentWorkHours__c;
        con.sirenum__General_Comments__c = conrec.sirenum__General_Comments__c;
        con.IP_Term1StartDate__c = conrec.IP_Term1StartDate__c;
        con.IP_Term1EndDate__c = conrec.IP_Term1EndDate__c;
        con.IP_Term2StartDate__c = conrec.IP_Term2StartDate__c;
        con.IP_Term2EndDate__c = conrec.IP_Term2EndDate__c;
        con.IP_Term3StartDate__c = conrec.IP_Term3StartDate__c;
        con.IP_Term3EndDate__c = conrec.IP_Term3EndDate__c;     
        con.IP_StudyComplete__c = conrec.IP_StudyComplete__c;
        con.IP_LastRecordedTermdate__c = conrec.IP_LastRecordedTermdate__c;
        con.IP_FirstRecordedTermDate__c = conrec.IP_FirstRecordedTermDate__c;
        con.EEO_Gender__c = conrec.EEO_Gender__c;
        con.IP_BorrowedTemp__c = conrec.IP_BorrowedTemp__c;
        con.Birthdate =conrec.Birthdate;
        con.IP_Unspent_Criminal_Convictions__c = conrec.IP_Unspent_Criminal_Convictions__c;
        con.IP_CategoryOfWork__c = conrec.IP_CategoryOfWork__c;
        con.IP_Unspent_Criminal_Convictions_Details__c = conrec.IP_Unspent_Criminal_Convictions_Details__c;
        con.IP_ReasonForRegistration__c = conrec.IP_ReasonForRegistration__c;
        con.IP_Offence__c = conrec.IP_Offence__c;
        con.Candidate_Source__c = conrec.Candidate_Source__c;     
        con.IP_Conviction__c = conrec.IP_Conviction__c;
        con.IP_Rehabilitation_Period_End_Date__c = conrec.IP_Rehabilitation_Period_End_Date__c;     
        con.sirenum__National_Insurance__c = conrec.sirenum__National_Insurance__c;
        con.P45_Suppression_Reason__c = conrec.P45_Suppression_Reason__c;
        con.IP_Minimum_Pay_Rate_Ltd__c = conrec.IP_Minimum_Pay_Rate_Ltd__c;
        con.IP_AWRType__c = conrec.IP_AWRType__c;
        con.IP_Minimum_Pay_Rate_PAYE__c = conrec.IP_Minimum_Pay_Rate_PAYE__c;
        con.IP_WorkerStartDate__c =conrec.IP_WorkerStartDate__c;
        con.TR1__Current_Last_Salary__c = conrec.TR1__Current_Last_Salary__c;
        con.TR1__Desired_Salary__c = conrec.TR1__Desired_Salary__c;
        con.sirenum__Client_Password__c = conrec.sirenum__Client_Password__c;
        con.HasOptedOutOfEmail = conrec.HasOptedOutOfEmail;
        con.TR1__Current_Last_Salary__c = conrec.TR1__Current_Last_Salary__c;
     
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
                            //PageReference pageref = new PageReference('/apex/ContactAddressFinder?id='+con.id);
                            PageReference pageref = new PageReference('/'+con.id);
                            pageref.setRedirect(true);
                            return pageref;
                        }
                        else{
                            //PageReference pageref = new PageReference('/apex/pca__ContactAddressFinder?id='+con.id);
                            PageReference pageref = new PageReference('/'+con.id);
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
                    //PageReference pageref = new PageReference('/apex/ContactAddressFinder?id='+con.id);
                    PageReference pageref = new PageReference('/'+con.id);
                    pageref.setRedirect(true);
                    return pageref;
                }
                else{
                    //
                    //PageReference pageref = new PageReference('/apex/pca__ContactAddressFinder?id='+con.id);
                    PageReference pageref = new PageReference('/'+con.id);
                    pageref.setRedirect(true);
                    return pageref;
                }
            }
        }     
        catch(Exception e){
            System.debug('check error'+e);
            System.debug('check error message'+e.getMessage());
            if(e.getMessage() == 'Insert failed. First exception on row 0; first error: DUPLICATES_DETECTED, You\'re creating a duplicate record. We recommend you use an existing record instead.: []'){
                // ApexPages.addMessages(e);
                displayduplicate = true; 
                System.debug('check boolean'+displayduplicate);
                conlist.add(con);
                checkduplicate();
            }
            else{
                ApexPages.addMessages(e);
            }
            return null;
        }
        return null;
    }
    
    public List<Contact> checkduplicate(){
        String checkfname = con.FirstName;
        String checklname = con.LastName;
        String checkemail = con.Email;
        String checkphone = con.MobilePhone;
        List<id> duplicatelist = new List<id>();
        if(!Test.isRunningTest()){
            Datacloud.FindDuplicatesResult[] results = Datacloud.FindDuplicates.findDuplicates(conList);
            for (Datacloud.FindDuplicatesResult findDupeResult : results) {
                for (Datacloud.DuplicateResult dupeResult : findDupeResult.getDuplicateResults()) {
                    for (Datacloud.MatchResult matchResult : dupeResult.getMatchResults()) {
                      for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) {
                          System.debug('Duplicate Record: ' + matchRecord.getRecord());
                          duplicatelist.add(matchRecord.getRecord().id);
                      }
                    }
                }
            }
        }
        else{
            duplicatelist.add(con.id);
        }
        ppList = [Select id,Name,Owner.name,Email,MobilePhone,Lastmodifieddate,Owner.id from Contact where id in: duplicatelist ];
        System.debug('check duplicate list'+ppList);
        countdup = ppList.size();
        return ppList;
    }
    
    public pagereference saveandredirectallowbypass(){
        con = new Contact();
        con.RecordTypeid = recordtypeid;
        con.OwnerID = UserInfo.getUserId();
        con.Person_Status__c = conrec.Person_Status__c;
        con.Reference_Status__c = conrec.Reference_Status__c;
        con.Salutation = conrec.Salutation;
        con.MobilePhone = conrec.MobilePhone;
        con.FirstName = conrec.FirstName;
        con.Phone =conrec.Phone;
        con.MiddleName = conrec.MiddleName;
        con.OtherPhone = conrec.OtherPhone;
        con.LastName = conrec.LastName;
        con.Email = conrec.Email;
        con.Suffix = conrec.Suffix;
        con.Preferred_Name__c = conrec.Preferred_Name__c;
        con.TR1__Consent_Types__c = conrec.TR1__Consent_Types__c;     
        con.IP_NextOfKinInfo__c = conrec.IP_NextOfKinInfo__c;
        con.Perm_Work__c = conrec.Perm_Work__c;
        con.IP_CandidateIDlegacy__c = conrec.IP_CandidateIDlegacy__c;
        con.Temp_Work__c = conrec.Temp_Work__c;
        con.IP_PreferredLocation__c = conrec.IP_PreferredLocation__c;
        con.Student__c = conrec.Student__c;
        con.IP_StudentWorkHours__c =conrec.IP_StudentWorkHours__c;
        con.sirenum__General_Comments__c = conrec.sirenum__General_Comments__c;
        con.IP_Term1StartDate__c = conrec.IP_Term1StartDate__c;
        con.IP_Term1EndDate__c = conrec.IP_Term1EndDate__c;
        con.IP_Term2StartDate__c = conrec.IP_Term2StartDate__c;
        con.IP_Term2EndDate__c = conrec.IP_Term2EndDate__c;
        con.IP_Term3StartDate__c = conrec.IP_Term3StartDate__c;
        con.IP_Term3EndDate__c = conrec.IP_Term3EndDate__c;     
        con.IP_StudyComplete__c = conrec.IP_StudyComplete__c;
        con.IP_LastRecordedTermdate__c = conrec.IP_LastRecordedTermdate__c;
        con.IP_FirstRecordedTermDate__c = conrec.IP_FirstRecordedTermDate__c;
        con.EEO_Gender__c = conrec.EEO_Gender__c;
        con.IP_BorrowedTemp__c = conrec.IP_BorrowedTemp__c;
        con.Birthdate =conrec.Birthdate;
        con.IP_Unspent_Criminal_Convictions__c = conrec.IP_Unspent_Criminal_Convictions__c;
        con.IP_CategoryOfWork__c = conrec.IP_CategoryOfWork__c;
        con.IP_Unspent_Criminal_Convictions_Details__c = conrec.IP_Unspent_Criminal_Convictions_Details__c;
        con.IP_ReasonForRegistration__c = conrec.IP_ReasonForRegistration__c;
        con.IP_Offence__c = conrec.IP_Offence__c;
        con.Candidate_Source__c = conrec.Candidate_Source__c;     
        con.IP_Conviction__c = conrec.IP_Conviction__c;
        con.IP_Rehabilitation_Period_End_Date__c = conrec.IP_Rehabilitation_Period_End_Date__c;     
        con.sirenum__National_Insurance__c = conrec.sirenum__National_Insurance__c;
        con.P45_Suppression_Reason__c = conrec.P45_Suppression_Reason__c;
        con.IP_Minimum_Pay_Rate_Ltd__c = conrec.IP_Minimum_Pay_Rate_Ltd__c;
        con.IP_AWRType__c = conrec.IP_AWRType__c;
        con.IP_Minimum_Pay_Rate_PAYE__c = conrec.IP_Minimum_Pay_Rate_PAYE__c;
        con.IP_WorkerStartDate__c =conrec.IP_WorkerStartDate__c;
        con.TR1__Current_Last_Salary__c = conrec.TR1__Current_Last_Salary__c;
        con.TR1__Desired_Salary__c = conrec.TR1__Desired_Salary__c;
        con.sirenum__Client_Password__c = conrec.sirenum__Client_Password__c;
        con.HasOptedOutOfEmail = conrec.HasOptedOutOfEmail;
        con.Active_Search__c = conrec.Active_Search__c;
     
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true; //Controlls bypass
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
                    Database.insert(con, dml);
                    String getLightning = getContextUserUiThemeDisplayed();
                    if(lightningTheme.equals(getLightning)){
                        //PageReference pageref = new PageReference('/apex/ContactAddressFinder?id='+con.id);
                        PageReference pageref = new PageReference('/'+con.id);
                        pageref.setRedirect(true);
                        return pageref;
                    }
                    else{
                        //PageReference pageref = new PageReference('/apex/pca__ContactAddressFinder?id='+con.id);
                        PageReference pageref = new PageReference('/'+con.id);
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
            Database.insert(con, dml);
            String getLightning = getContextUserUiThemeDisplayed();
            if(lightningTheme.equals(getLightning)){
                //PageReference pageref = new PageReference('/apex/ContactAddressFinder?id='+con.id);
                PageReference pageref = new PageReference('/'+con.id);
                pageref.setRedirect(true);
                return pageref;
            }
            else{
                //PageReference pageref = new PageReference('/apex/pca__ContactAddressFinder?id='+con.id);
                PageReference pageref = new PageReference('/'+con.id);
                pageref.setRedirect(true);
                return pageref;
            }
        }
        return null;
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