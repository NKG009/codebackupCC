//********************************************************************************************
//********************************************************************************************
//
//  Sourcebreaker Candidate Import, creating a contact within the CRM
//
//********************************************************************************************
//********************************************************************************************


@restResource(urlMapping='/sbOpsJSON/*') 
global with sharing class SbCandidate{      
    
    //Variables relating to the input from the REST service
    private static RestRequest req {get; set;}
    private static RestResponse res {get; set;}
    private static string ContentType {get; set;}
    private static string inputSource {get; set;}
    private static string inputBody {get; set;}
    private static string inputFirstName {get; set;}
    private static string inputLastName {get; set;}
    private static string inputCurrency {get; set;}
    private static string inputSalaryCurrent {get; set;}
    private static string inputSalaryDesired {get; set;}
    private static string inputHourlyCurrent {get; set;}
    private static string inputHourlyDesired {get; set;}
    private static string inputJobType {get; set;}
    private static string inputLocationCity {get; set;}
    
    private static SbHelper helper {get; set;}
    public static responder sendResponse {get; set;}
    
    //variables for the creation of contact(s)
    private static SbJsonCandidate.resumeObject jsonResume {get; set;} 
    private static SObject jsonCandidate {get; set;}  
    
	//create a map of predefined string values, to replace from the REST Response body, before deserializing
    private static final map<String, String> stringToReplace = new map<string, string>{'@positionType' => 'positionType','@currentEmployer' => 'currentEmployer','@type' => 'x_type','#text' => 'x_text','sov:' => 'sov_'};
    
    //HTTP Response Codes
    private static final map<Integer, string> statusMessage = new map<Integer, string>{200 => 'Request: Completed Successfully.',202 => 'Request: Partially Completed.',302 => 'REST API Initialised.',400 => 'Request Failed: Client Side Error.',404 => 'Request Failed: Not Found.',406 => 'Request Failed: Content-Type specified in HTTP request is not supported.',500 => 'Request Failed: Salesforce exception found.'};
        
        
    
    //****************************************
    //REST POST Resource: When called, this parses the string to retrive the XML in the response body
    //****************************************
    @httpPost
    global static responder startHere(){
        
        req = RestContext.request;
        res = RestContext.response;
        sendResponse = new responder();
        
        
        //capture the REST request details from the Request Header:
        if (!string.isempty(req.headers.get('Content-Type'))) ContentType = req.headers.get('Content-Type');
        if (!string.isempty(req.headers.get('inputFirstName'))) inputFirstName = req.headers.get('inputFirstName');
        if (!string.isempty(req.headers.get('inputLastName'))) inputLastName = req.headers.get('inputLastName');
        if (!string.isempty(req.headers.get('inputSalaryCurrent'))) inputSalaryCurrent = req.headers.get('inputSalaryCurrent');
        if (!string.isempty(req.headers.get('inputSalaryDesired'))) inputSalaryDesired = req.headers.get('inputSalaryDesired');
        if (!string.isempty(req.headers.get('inputHourlyCurrent'))) inputHourlyCurrent = req.headers.get('inputHourlyCurrent');
        if (!string.isempty(req.headers.get('inputHourlyDesired'))) inputHourlyDesired = req.headers.get('inputHourlyDesired');
        if (!string.isempty(req.headers.get('inputLocationCity'))) inputLocationCity = req.headers.get('inputLocationCity'); 
        if (!string.isempty(req.headers.get('inputCurrency'))) inputCurrency = req.headers.get('inputCurrency'); 
        if (!string.isempty(req.headers.get('inputSource'))) inputSource = req.headers.get('inputSource');
        if (!string.isempty(req.headers.get('inputJobType'))) inputJobType = req.headers.get('inputJobType');
        
        helper = new SbHelper(inputSource, true); 
        sendResponse.userInLighting = helper.prefersLightning;
        if(!helper.settingsFound){
            sendResponse.statusCode = 404;
            sendResponse.message = 'Required Managed Package not found';
            return sendResponse;
        }
        

        if (ContentType.toUpperCase() != helper.inputContentType.toUpperCase()){ //using capitalize to avoid issues re: string case.
            sendResponse.statusCode = 406;
            sendResponse.message = 'Content-Type is not specifed as the expected "application/json" format.  Content-Type header received: ' + ContentType;
            return sendResponse;
        }
        
        //body of the request should include the JSON
        if(string.valueOf(req.requestBody) == null || string.valueOf(req.requestBody) == ''){
            sendResponse.statusCode = 400;
            sendResponse.message = 'No Rest Body found.';
            return sendResponse;
        }else if(req.requestBody != null) inputBody = req.requestBody.toString();

        //Now find & replace special characters in JSON
        //example from sample JSON:  "Affix": [{  "@type": "generation",  "#text": "III"  }]
        for (string loopString: stringToReplace.keySet()){
            inputBody = inputBody.replace(loopString, stringToReplace.get(loopString)); 
        }
            
        
        //extract and process the JSON input, testing it is valid
        processJsonObjectStructure(inputBody);

        //continue on to process the Candidate and related records
        if (sendResponse.statusCode < 400) 
            createCandidate(jsonResume);

        //now check for duplicates and either create/insert the candidate record
        if (sendResponse.statusCode < 400) 
            checkDuplicateCandidates();

        return sendResponse;
    }
    
    //Now attempt to loop through the input text, and process the Resume Object when found...
    public static responder processJsonObjectStructure(string inputBody){
        
        //declare the JSON Wrapper classes, and instantiate. 
        SbJsonCandidate.jsonWrapper jsonInput = new SbJsonCandidate.jsonWrapper();
        JSONParser parsedJsonResume;
        
        
        //First, attempt to deserialise the initial Sovren JSON input
        try{
            jsonInput = (SbJsonCandidate.jsonWrapper) JSON.deserialize(inputBody, SbJsonCandidate.jsonWrapper.class);
            sendResponse.message = 'JSON (Sovren) has been deserialized.';
            
            //now extract ParsedDocument, this should include the StructuredXMLResume, and createParser
            parsedJsonResume = JSON.createParser(string.valueOf(jsonInput.Value.ParsedDocument));
        }
        catch(Exception e){
            //if JSON exception, then throw error
            sendResponse.message = 'JSON Object: Issue deserializing JSON.';
            sendResponse.statusCode = SbHelper.errorHandler(e);
            helper.sendEmailNotification(sendResponse.statusCode, sendResponse.message, 'Candidate', e);
            return sendResponse;
        }  

        
        //JSON Input formatted and ready for processing...  Extract the Resume Object
        jsonResume = new SbJsonCandidate.resumeObject();
        
        //Loop through JSON tokens to populate the sbOperationsJSONResume object.
        parsedJsonResume.nextToken(); //move to next token and test it is starting object
        if (parsedJsonResume.getCurrentToken() == JSONToken.START_OBJECT){
            parsedJsonResume.nextToken(); //move forward twice to next object then start readValueAs
            parsedJsonResume.nextToken();
            
            try{ 
                jsonResume = (SbJsonCandidate.resumeObject)parsedJsonResume.readValueAs(SbJsonCandidate.resumeObject.class);
            }
            catch(Exception e){
                //if JSON exception, then throw error
                sendResponse.message = 'Error parsing resumeObject';
                sendResponse.statusCode = SbHelper.errorHandler(e);
                helper.sendEmailNotification(sendResponse.statusCode, sendResponse.message, 'Candidate', e);
                return sendResponse;
            }
        }
        
        //after looping through, if structuredResume still equals null, then report an error 
        if (jsonResume == null){
            sendResponse.statusCode = 404;
            sendResponse.message = 'JSON Object: StructuredXMLResume, not found in JSON Input.  (INPUT: ' + parsedJsonResume +')';
            return sendResponse;
        }else if (jsonResume != null){                
            //YAY resume is created and ready to be loaded into relevant objects for Salesforce. 
            sendResponse.message = 'StructuredResume is OK, attempting to create contact.';
        }
        return sendResponse;
        
    }
    
    //Transform the object/class to a candidate record for insert/update, based on field mappings
    public static responder createCandidate(SbJsonCandidate.resumeObject resume){ 

        //create a new dynamic sObject to update - objectName for candidate stored in Metadata
        jsonCandidate = Schema.getGlobalDescribe().get(helper.objectName).newSObject();

        //constant variables to be used for candidate creation
        if (helper.candidateRT != null) {
            jsonCandidate.put('RecordTypeID', helper.candidateRT);
        }
        if (helper.candidateParentID != null && helper.fieldMapping.containsKey('parentid')){
         	jsonCandidate.put(helper.fieldMapping.get('parentid'), helper.candidateParentID);
        }
        if (helper.candidateSource != null && helper.fieldMapping.containsKey('sourceid')) {
            jsonCandidate.put(helper.fieldMapping.get('sourceid'),helper.candidateSource);
        }
        if (helper.candidateSourceName != null && helper.fieldMapping.containsKey('sourcename')) {
            jsonCandidate.put(helper.fieldMapping.get('sourcename'),helper.candidateSourceName);
        }
        
        //add in the hourly/salary information if available (in REST Request Header) via dynamic field mapping
        if (inputSalaryCurrent != null && helper.fieldMapping.containsKey('salarycurrent')) {
            jsonCandidate.put(helper.fieldMapping.get('salarycurrent'), decimal.valueOf(inputSalaryCurrent).intValue()); 
        }
        if (inputSalaryDesired != null && helper.fieldMapping.containsKey('salarydesired')) {
            jsonCandidate.put(helper.fieldMapping.get('salarydesired'), decimal.valueOf(inputSalaryDesired).intValue());
        }
        if (inputHourlyCurrent != null && helper.fieldMapping.containsKey('hourlycurrent')) {
            jsonCandidate.put(helper.fieldMapping.get('hourlycurrent'), decimal.valueOf(inputHourlyCurrent).intValue());
        }
        if (inputHourlyDesired != null && helper.fieldMapping.containsKey('hourlydesired')) {
            jsonCandidate.put(helper.fieldMapping.get('hourlydesired'), decimal.valueOf(inputHourlyDesired).intValue());
        }

        //load in the job type, if available
        if (inputJobType != null && helper.fieldMapping.containsKey('jobtype')) {
            jsonCandidate.put(helper.fieldMapping.get('jobtype'), string.valueOf(inputJobType));
        }

        //determine if multi-currency is setup, and mapped           
        Map<String, Schema.SObjectField> fieldMap = SbHelper.getFields(helper.objectName);
        if (inputCurrency != null && fieldMap.containsKey('CurrencyIsoCode')) {          
            Boolean isMultiCurrencyEnabled = UserInfo.isMultiCurrencyOrganization();
            Boolean currencyMatch = false;

            System.debug('isMultiCurrencyEnabled: '+ isMultiCurrencyEnabled  + ', inputCurrency: ' + inputCurrency);

            //Use inputCurrency, if it matches the Default Currency (either the Users if multi-currency, or the Org if no multi-currency)
            if (inputCurrency == UserInfo.getDefaultCurrency()){
                jsonCandidate.put('CurrencyIsoCode', inputCurrency); 
                currencyMatch = true;
            }

            //When not matched, then try to find if requested currency is active/available
            else if (isMultiCurrencyEnabled && !currencyMatch){ 
                string currencyQuery = 'SELECT Id, IsoCode, ConversionRate, DecimalPlaces, IsCorporate FROM CurrencyType where IsActive = True';
                list<SObject> currencyQueryList = new List<SObject>();
                currencyQueryList = Database.query(currencyQuery); 
            
                if(!currencyQueryList.isEmpty()){
                    for (SObject ct : currencyQueryList){
                        //if IsoCode is found in loop, assign it to the 
                        if (ct.get('IsoCode') == inputCurrency) { 
                            jsonCandidate.put('CurrencyIsoCode', inputCurrency); 
                            currencyMatch = true; //match found, break from loop
                            break; 
                        }
                    }
                }
            }
        }
        
        

        //********************************  
        //Using the populated classes/objects from the JSON, now attempt to create the candidate to be inserted into SF 
        //********************************  
        if(resume == null || resume.StructuredXMLResume == null){
            sendResponse.statusCode = 404;
            sendResponse.message = 'JSON Object: StructuredXMLResume, not found in JSON Input';
            return sendResponse;
        }

        //if no mapping found for first/last name, throw error
        if(!helper.fieldMapping.containsKey('firstname') || !helper.fieldMapping.containsKey('lastname')){
            sendResponse.statusCode = 404;
            sendResponse.message = 'Exception: No field mapping for Candidate First/Last Name found.';
            return sendResponse;
        }

        if (resume.StructuredXMLResume != null){
            if (resume.StructuredXMLResume.ContactInfo != null){
                if (resume.StructuredXMLResume.ContactInfo.PersonName != null){
                    //First Name
                    if (resume.StructuredXMLResume.ContactInfo.PersonName.GivenName != null && helper.fieldMapping.containsKey('firstname')) {
                        jsonCandidate.put(helper.fieldMapping.get('firstname'), resume.StructuredXMLResume.ContactInfo.PersonName.GivenName);
                    }
                    //Last Name
                    if (resume.StructuredXMLResume.ContactInfo.PersonName.FamilyName != null) {
                        jsonCandidate.put(helper.fieldMapping.get('lastname'), resume.StructuredXMLResume.ContactInfo.PersonName.FamilyName);
                    }
                }
            }
        }

        
        //as a fallback, try and use the InputFirstName (if included)
        if((jsonCandidate.get(helper.fieldMapping.get('firstname')) == null || jsonCandidate.get(helper.fieldMapping.get('firstname')) == '') && inputFirstName != null){
            jsonCandidate.put(helper.fieldMapping.get('firstname'), inputFirstName);
        }
        
        //as a fallback, try and use the InputLastName (if included)
        if((jsonCandidate.get(helper.fieldMapping.get('lastname')) == null || jsonCandidate.get(helper.fieldMapping.get('lastname')) == '') && inputLastName != null){
            jsonCandidate.put(helper.fieldMapping.get('lastname'), inputLastName);
        }   

        //If there is still no first/last name, throw an error and stop processing
        if((jsonCandidate.get(helper.fieldMapping.get('firstname')) == null && jsonCandidate.get(helper.fieldMapping.get('lastname')) == null) || 
            (jsonCandidate.get(helper.fieldMapping.get('firstname')) == '' && jsonCandidate.get(helper.fieldMapping.get('lastname')) == '')){
            //set error message and stop processing
            sendResponse.statusCode = 400;
            sendResponse.message = 'Exception: No Candidate Name found in JSON or Rest Input.';
            return sendResponse;
        }
        
        
        ///////////////////////////////////////////////////
        // Node: Text Resume (stores the parsed CV in single text field, allowing for Salesforce search)
        ///////////////////////////////////////////////////        
        if(resume.NonXMLResume != null){
            if (resume.NonXMLResume.TextResume != null ){
                if(helper.fieldMapping.containsKey('textresume')) jsonCandidate.put(helper.fieldMapping.get('textresume'), string.valueOf(resume.NonXMLResume.TextResume).left(32000));
            }
            
            //update statusCode to partially complete
            sendResponse.statusCode = 202;
            sendResponse.message = 'Text Resume created.';
        }
        
        
        ///////////////////////////////////////////////////
        // Node: ContactMethod (stores things like Address and Contact Information)
        ///////////////////////////////////////////////////        
        if(resume.StructuredXMLResume != null){
            //Test is ContactMethod (and parent objects) exist
            if(resume.StructuredXMLResume.ContactInfo != null){
                if(resume.StructuredXMLResume.ContactInfo.ContactMethod != null){
                    //Now checks are completed, loop through the ContactMethod array and retrieve details as needed
                    Integer i = 0;
                    for (SbJsonCandidate.contactMethodObject cmethod : resume.StructuredXMLResume.ContactInfo.ContactMethod){
                        i++;
                        //Candidate variables definition 
                        string cmUse = cmethod.Use;
                        string cmLocation = cmethod.Location;
                        
                        //Postal Address (if available)
                        if(cmethod.PostalAddress != null){
                            //concatenate the mailing street address line
                            if(cmethod.PostalAddress.DeliveryAddress != null){
                                if(cmethod.PostalAddress.DeliveryAddress.AddressLine != null){
                                    if(cmethod.PostalAddress.DeliveryAddress.AddressLine[0] != null){
                                        string mailingStreet = '';
                                        for (string addressLine : cmethod.PostalAddress.DeliveryAddress.AddressLine){
                                            mailingStreet = addressLine + mailingStreet;
                                        }
                                        //assign street address to candidate record
                                        if(helper.fieldMapping.containsKey('mailingstreet')) jsonCandidate.put(helper.fieldMapping.get('mailingstreet'), mailingStreet);
                                    }
                                }
                            }
                            
                            if(cmethod.PostalAddress.Municipality != null){
                                if(helper.fieldMapping.containsKey('mailingcity')) jsonCandidate.put(helper.fieldMapping.get('mailingcity'), cmethod.PostalAddress.Municipality);
                            }
                            if(cmethod.PostalAddress.Region != null){    
                                if(cmethod.PostalAddress.Region[0] != null){    
                                    if(helper.fieldMapping.containsKey('mailingstate')) jsonCandidate.put(helper.fieldMapping.get('mailingstate'), cmethod.PostalAddress.Region[0]);
                                }
                            }
                            if(cmethod.PostalAddress.CountryCode != null){
                                if(helper.fieldMapping.containsKey('mailingcountry')) jsonCandidate.put(helper.fieldMapping.get('mailingcountry'), cmethod.PostalAddress.CountryCode);
                            }
                            if(cmethod.PostalAddress.PostalCode != null){
                                if(helper.fieldMapping.containsKey('mailingpostalcode')) jsonCandidate.put(helper.fieldMapping.get('mailingpostalcode'), cmethod.PostalAddress.PostalCode);
                            }
                            
                        }
                        else if (inputLocationCity != null && (jsonCandidate.get(helper.fieldMapping.get('mailingcity')) == '' || jsonCandidate.get(helper.fieldMapping.get('mailingcity')) == null)){
                            //else if PostalAddress is null, inputLocationCity has been provided and MailingCity on the contact is empty
                            if(helper.fieldMapping.containsKey('mailingcity')) jsonCandidate.put(helper.fieldMapping.get('mailingcity'), string.valueOf(inputLocationCity));
                        }
                        
                        //capture email address
                        if(cmethod.InternetEmailAddress != null && helper.fieldMapping.containsKey('candidateemail')){
                            if (string.isNotBlank(cmethod.InternetEmailAddress) && jsonCandidate.get(helper.fieldMapping.get('candidateemail')) == null){
                                jsonCandidate.put(helper.fieldMapping.get('candidateemail'), cmethod.InternetEmailAddress);
                            }
                        }
                        
                        //test the InternetWebAddress value, and see which (if any) social media account it is
                        if(cmethod.InternetWebAddress != null){
                            if (string.isNotBlank(cmethod.InternetWebAddress)){
                                string cmTempURL = cmethod.InternetWebAddress;
                                
                                //added support for dynamic field mapping for social media accounts
                                if (cmTempURL.toLowerCase().contains('linkedin') && helper.fieldMapping.containsKey('linkedin') && jsonCandidate.get(helper.fieldMapping.get('linkedin')) == null){
                                    jsonCandidate.put(helper.fieldMapping.get('linkedin'), cmTempURL);
                                }
                                if (cmTempURL.toLowerCase().contains('facebook') && helper.fieldMapping.containsKey('facebook') && jsonCandidate.get(helper.fieldMapping.get('facebook')) == null){
                                    jsonCandidate.put(helper.fieldMapping.get('facebook'), cmTempURL);
                                }
                                if (cmTempURL.toLowerCase().contains('twitter') && helper.fieldMapping.containsKey('twitter') && jsonCandidate.get(helper.fieldMapping.get('twitter')) == null){
                                    jsonCandidate.put(helper.fieldMapping.get('twitter'), cmTempURL);
                                }
                            }
                        }
                        
                        //test if the field is null and if so, populate the various phone numbers 
                        
                        if ((cmUse == 'personal' || cmUse == null) && cmethod.Telephone != null && helper.fieldMapping.containsKey('homephone')){
                            if(jsonCandidate.get(helper.fieldMapping.get('homephone')) == null){
                                jsonCandidate.put(helper.fieldMapping.get('homephone'), cmethod.Telephone.FormattedNumber);
                            }
                        } 
                        
                        if (cmethod.Mobile != null && helper.fieldMapping.containsKey('mobilephone')){
                            if(jsonCandidate.get(helper.fieldMapping.get('mobilephone')) == null) jsonCandidate.put(helper.fieldMapping.get('mobilephone'),  cmethod.Mobile.FormattedNumber);
                        } 
                        
                        if (cmethod.Fax != null && helper.fieldMapping.containsKey('fax')){
                            if(jsonCandidate.get(helper.fieldMapping.get('fax')) == null) jsonCandidate.put(helper.fieldMapping.get('fax'), cmethod.Fax.FormattedNumber);
                        } 
                        
                        if (cmUse == 'business' && helper.fieldMapping.containsKey('otherphone')){
                            if(jsonCandidate.get('otherphone') == null) jsonCandidate.put('otherphone', cmethod.Telephone.FormattedNumber);
                        } 
                    }
                }
            }
        }
        //update progress in SendResponse
        sendResponse.message = 'ContactInfo extracted, attempting Executive Summary.';
        
        
        /////////////////////   //////////////////////////////
        // Node: Executive Summary 
        ///////////////////////////////////////////////////
        if(resume.StructuredXMLResume.ExecutiveSummary != null){
            if (string.isNotBlank(resume.StructuredXMLResume.ExecutiveSummary) && helper.fieldMapping.containsKey('execsummary')){
                if(jsonCandidate.get(helper.fieldMapping.get('execsummary')) == null){
                    jsonCandidate.put(helper.fieldMapping.get('execsummary'), resume.StructuredXMLResume.ExecutiveSummary.left(32000));
                }
            }
        }

        //if proceed to process relevant Skills and/or Employment History
        findEmpyHistoryAndSkills(resume.StructuredXMLResume);
        
        return sendResponse;
        
    }
    
     
    ///////////////////////////////////////////////////
    // Node: Extract Employment History and Skills
    ///////////////////////////////////////////////////
    public static responder findEmpyHistoryAndSkills(SbJsonCandidate.structuredResumeObject structuredResume){

        list<string> listOfSkills = new list<string>();
        
        //Job title and other attributes worked out by comparing dates
        Date mostRecentDate;
        Date positionDate;
        string empHistoryTitle;
        string empHistoryResponsibilities;
        
        try{
            if(structuredResume.EmploymentHistory != null){    
                for (SbJsonCandidate.employerOrgObject empOrgHistory : structuredResume.EmploymentHistory.EmployerOrg){
                    //loop through each PositionHistory object to extract Emplymnt History and related Skills
                    for (SbJsonCandidate.positionHistoryObject posHistory : empOrgHistory.PositionHistory){                    
                        //if start date is empty, then try and extract it from the JSON object
                        if(posHistory.StartDate != null){
                            if (posHistory.StartDate.StringDate != null && positionDate == null) { //test StringDate object, to see if it contains date
                                string tempDateString = string.valueof(posHistory.StartDate.StringDate).toLowerCase(); //convert to lowercase string
                                if(tempDateString != 'current' && tempDateString != 'notapplicable' && tempDateString != 'notknown') {
                                    positionDate = date.valueOf(posHistory.StartDate.StringDate);
                                }
                            }
                            else if (posHistory.StartDate.AnyDate != null && positionDate == null) { //now test AnyDate instead of 
                                string tempDateString = string.valueof(posHistory.StartDate.AnyDate).toLowerCase(); //convert to lowercase string
                                if (tempDateString != 'current' && tempDateString != 'notapplicable' && tempDateString != 'notknown') {
                                    positionDate = date.valueOf(posHistory.StartDate.AnyDate);
                                }
                            }
                            
                            if(positionDate != null){ //if the start date has been extracted, then test if most recent
                                if (mostRecentDate < positionDate){ //test to see if most recent date is less than positionDate, if so extract Job Title
                                    mostRecentDate = positionDate;
                                    if (posHistory.Title != null  && helper.fieldMapping.containsKey('title')) jsonCandidate.put(helper.fieldMapping.get('title'), posHistory.Title.left(75));
                                    if (posHistory.Description != null) empHistoryResponsibilities = posHistory.Description.left(10000);
                                }
                                else if (mostRecentDate == null){ //if null, then it hasn't been assigned yet, so do so now...
                                    mostRecentDate = positionDate;
                                    if(posHistory.Title != null && helper.fieldMapping.containsKey('title')) jsonCandidate.put(helper.fieldMapping.get('title'), posHistory.Title.left(75));
                                    if (posHistory.Description != null) empHistoryResponsibilities = posHistory.Description.left(10000);
                                } 
                            
                            }
                        }
                        
                        
                        //Extract Skills for the role 
                        if (posHistory.JobCategory != null){
                            boolean hasJobLevel = false;
                            boolean hasTaxonomy = false;
                            
                            for(SbJsonCandidate.jobCatergoryObject skillSet : posHistory.JobCategory){
                                if (skillSet.TaxonomyName.toUpperCase() == 'SKILLS TAXONOMY'){
                                    
                                    //Skill name parsed from Sovren is in format 'Information Technology → Machine Learning'
                                    //split out the string components and then use the last element of the array for Skill na
                                    if (skillSet.CategoryCode.contains('→') || skillSet.CategoryCode.contains('?')) {
                                        String[] strSplit;
                                        if (skillSet.CategoryCode.contains('→')) strSplit = skillSet.CategoryCode.split('→');
                                        else if (skillSet.CategoryCode.contains('?')) strSplit = skillSet.CategoryCode.split('?');

                                        if (strSplit.size() > 0 && !strSplit.isEmpty()){
                                            Integer finalPosition = strSplit.size() -1; //get the array position of final entry
                                            string catCode = strSplit[finalPosition];
                                            listOfSkills.add(catCode.left(75));
                                        }
                                        hasTaxonomy = true;
                                    }
                                    
                                }
                                if (skillSet.TaxonomyName.toUpperCase() == 'JOB LEVEL'){
                                    //extract field values 
                                    hasJobLevel = true;
                                }
                                
                                //if JobLevel and Taxonomy has been extracted, then add record into list and reset
                                if(hasJobLevel & hasTaxonomy){
                                    hasTaxonomy = false;
                                    hasJobLevel = false;
                                }
                            }
                        }
                         
                    }
                    
                    //update progress in SendResponse
                    sendResponse.message = 'Employment History processed. Checking for \'Duplicate Contacts\' now';
                    
                }
            }
        }catch (Exception e){
            sendResponse.message = 'Exception while processing EmploymentHistory/Skills';
            sendResponse.statusCode = SbHelper.errorHandler(e);
            helper.sendEmailNotification(sendResponse.statusCode, sendResponse.message, 'Candidate', e);
            return sendResponse;
        }
        
        
        return sendResponse;
        
    }
    
    ///////////////////////////////////////////////////
    // Node: Duplicate Check of contact being parsed, and decision to update or create a new record
    ///////////////////////////////////////////////////
    public static responder checkDuplicateCandidates(){
        
        //***************************************
        //Duplicate check criteria and process 
        /*
        
        If the candidate:
        •	If the email is an exact match - this is a duplicate and a new record won't be added, it will be updated
        •	If there is no email or the email doesn’t match - we will compare by the last 10 digits of the phone number, exclude spacing and ignoring any non-numeric characters (e.g. + or () ).
        •	if the phone number matches - it is a duplicate
        •	if not - we will add it as a new record
        
        Notes:
        •	Checks should not be case sensitive
        •	we check all possible fields that may contain this information e.g. phone fields, home, mobile, work etc 
        
        */
        
        //SOSL Search
        string queryStringEmail = '';  //eg: FIND {mylogin@mycompany.com} IN EMAIL FIELDS
        string queryStringPhone = '';   //eg: FIND {808-8888-0000 or 808-8888-1111} IN PHONE FIELDS 
        string queryStringExtId = '';
        string returningString = '';
        List<SObject> candidateListEmail = new List<SObject>();
        List<SObject> candidateListPhone = new List<SObject>(); 
         
        List<SObject> listOfContactsAdd = new List<SObject>(); 
        List<SObject> listOfContactsUpdate = new List<SObject>(); 

        //The RETURNING attribute for the SOSL is the same for all queries run, and only want Candidate records on the Contact object
        if (helper.candidateRT != null && helper.candidateRT != ''){
            returningString = 'RETURNING CONTACT(ID, FirstName, LastName, Email, HomePhone, MobilePhone, OtherPhone WHERE RecordTypeID = \''+ helper.candidateRT +'\')';
        }else{
            returningString = 'RETURNING CONTACT(ID, FirstName, LastName, Email, HomePhone, MobilePhone, OtherPhone)';
        }
        
        
        if (helper.fieldMapping.containsKey('candidateemail') && jsonCandidate.get(helper.fieldMapping.get('candidateemail')) != null){
            string tempStr = (string) jsonCandidate.get(helper.fieldMapping.get('candidateemail'));
            string strEmail = (string) jsonCandidate.get('Email');
            queryStringEmail = 'FIND \'' + string.escapeSingleQuotes(strEmail.trim())+'\' IN EMAIL FIELDS ' + returningString;
            system.debug('DEBUG ===  queryStringEmail: ' + queryStringEmail);
        }
        if (helper.fieldMapping.containsKey('homephone') && jsonCandidate.get(helper.fieldMapping.get('homephone')) != null){
            string tempStr = (string) jsonCandidate.get(helper.fieldMapping.get('homephone'));
            tempStr = tempStr.replaceAll('\\D','').right(10); //regex to remove anything that is not a digit and get last 10digits
            queryStringPhone = queryStringPhone + ' OR ' +  string.escapeSingleQuotes(tempStr.trim());
            system.debug('DEBUG ===  queryStringPhone (HOME): ' + queryStringPhone);
        }
        if (helper.fieldMapping.containsKey('otherphone') && jsonCandidate.get(helper.fieldMapping.get('otherphone')) != null){
            string tempStr = (string) jsonCandidate.get(helper.fieldMapping.get('otherphone'));
            tempStr = tempStr.replaceAll('\\D','').right(10); //regex to remove anything that is not a digit and get last 10digits
            queryStringPhone = queryStringPhone + ' OR ' +  string.escapeSingleQuotes(tempStr.trim());
            system.debug('DEBUG ===  queryStringPhone (OTHER): ' + queryStringPhone);
        }
        if (helper.fieldMapping.containsKey('mobilephone') && jsonCandidate.get(helper.fieldMapping.get('mobilephone')) != null){
            string tempStr = (string) jsonCandidate.get(helper.fieldMapping.get('mobilephone'));
            tempStr = tempStr.replaceAll('\\D','').right(10); //regex to remove anything that is not a digit and get last 10digits
            queryStringPhone = queryStringPhone + ' OR ' +  string.escapeSingleQuotes(tempStr.trim());
            system.debug('DEBUG ===  queryStringPhone (MOBILE): ' + queryStringPhone);
        }

        //update sendResponse
        sendResponse.message = 'Dupe Check: Formatted email & phone numbers, now attempting to find dupes.';
        
        try{
            //If the QueryString is not Blank, then continue
            if (!String.isBlank(queryStringPhone) || !String.isBlank(queryStringEmail) || !String.isBlank(queryStringExtId)) {
                
                if (queryStringPhone.length() > 0 && queryStringPhone != null){
                    queryStringPhone = queryStringPhone.substring(3, queryStringPhone.length()) ; //removing extra 'or' before where condition
                    queryStringPhone = 'FIND \'' + queryStringPhone + '\' IN PHONE FIELDS ' + returningString;
                }
                
                List<List<SObject>> searchEmail;
                List<List<SObject>> searchPhone;
                
                //SOSL/SOQL duplicate checker
                if(!String.isBlank(queryStringEmail)){
                    searchEmail = search.query(queryStringEmail);
                    candidateListEmail = (List<SObject>)searchEmail[0]; 
                }
                if(!String.isBlank(queryStringPhone)){
                    searchPhone = search.query(queryStringPhone);
                    candidateListPhone = (List<SObject>)searchPhone[0];
                }
                
                sendResponse.message = 'Duplicate check run, Results of dupe check: # Email Match: ' + candidateListEmail.size() + ', # Phone Match: ' + candidateListPhone.size();
                
                //if no records found in query, then add to list to create contact
                if (candidateListPhone.isEmpty() && candidateListEmail.isEmpty()){
                    listOfContactsAdd.add(jsonCandidate);  
                }
                //else if records found, test what match is against and add the ID to JSONContact to update record
                else {
                    //combine the lists
                    Set<SObject> tempContactSet = new Set<SObject>(); //using a set here, to minimise duplicate values when combining the lists together
                    if (candidateListEmail.size() > 0) tempContactSet.addall(candidateListEmail);
                    if (candidateListPhone.size() > 0) tempContactSet.addall(candidateListPhone);
                    
                    //////////////////////////////////////////////
                    for (SObject contactMatch : tempContactSet){ 
                        if (helper.fieldMapping.containsKey('candidateemail')){
                            if(jsonCandidate.get(helper.fieldMapping.get('candidateemail')) != null && jsonCandidate.get(helper.fieldMapping.get('candidateemail')) == contactMatch.get('Email')) {
                                jsonCandidate.put('Id', contactMatch.get('Id'));
                                system.debug('DEBUG === Match on contact email, ' + jsonCandidate.get('Id'));
                            }
                        }
                        
                        string tempPhoneNumberSearch = ''; //create a string of phone numbers and then do a 'contains' test
                        if (contactMatch.get('MobilePhone') != null) tempPhoneNumberSearch = tempPhoneNumberSearch + ',' + string.valueOf(contactMatch.get('MobilePhone')).replaceAll('\\D','').right(10);
                        if (contactMatch.get('HomePhone') != null) tempPhoneNumberSearch = tempPhoneNumberSearch + ',' + string.valueOf(contactMatch.get('HomePhone')).replaceAll('\\D','').right(10);
                        if (contactMatch.get('OtherPhone') != null) tempPhoneNumberSearch = tempPhoneNumberSearch + ',' + string.valueOf(contactMatch.get('OtherPhone')).replaceAll('\\D','').right(10);
                        
                        if (helper.fieldMapping.containsKey('mobilephone')){
                            if (jsonCandidate.get(helper.fieldMapping.get('mobilephone')) != null && jsonCandidate.get('Id') == null){
                                string strMobile = string.valueOf(jsonCandidate.get('MobilePhone')).replaceAll('\\D','').right(10); //remove non-numerical chars
                                Boolean phoneContains = tempPhoneNumberSearch.contains(strMobile); //does the tempPhoneNumberSearch contain the mobile number?
                                if (phoneContains){
                                    jsonCandidate.put('Id', contactMatch.get('Id'));
                                    system.debug('DEBUG === Match on contact Mobile#, ' + jsonCandidate.get('Id'));
                                }
                            }
                        }
                        
                        if (helper.fieldMapping.containsKey('homephone')){
                            if (jsonCandidate.get(helper.fieldMapping.get('homephone')) != null && jsonCandidate.get('Id') == null){
                                string strHome = string.valueOf(jsonCandidate.get('HomePhone')).replaceAll('\\D','').right(10); //remove non-numerical chars
                                Boolean phoneContains = tempPhoneNumberSearch.contains(strHome); //does the tempPhoneNumberSearch contain the mobile number?
                                if (phoneContains){
                                    jsonCandidate.put('Id', contactMatch.get('Id'));
                                    system.debug('DEBUG === Match on contact HomePhone#, ' + jsonCandidate.get('Id'));
                                }
                            }
                        }

                        if (helper.fieldMapping.containsKey('otherphone')){
                            if (jsonCandidate.get(helper.fieldMapping.get('otherphone')) != null && jsonCandidate.get('Id') == null){
                                string strOther = string.valueOf(jsonCandidate.get('OtherPhone')).replaceAll('\\D','').right(10); //remove non-numerical chars
                                Boolean phoneContains = tempPhoneNumberSearch.contains(strOther); //does the tempPhoneNumberSearch contain the mobile number?
                                if (phoneContains){
                                    jsonCandidate.put('Id', contactMatch.get('Id'));
                                    system.debug('DEBUG === Match on contact OtherPhone#, ' + jsonCandidate.get('Id'));
                                }
                            }
                        }
                        
                        //test that the ID is not null, of length >= 15 chars and starts with '003' - break from the loop
                        if (jsonCandidate.get('Id') != null && string.valueOf(jsonCandidate.get('Id')).length() >= 15 && string.valueOf(jsonCandidate.get('Id')).left(3) == '003') {
                            break;
                        }
                    }
                    
                    //now add contact record to be updated, instead of created
                    if (jsonCandidate.get('Id') != null){
                        listOfContactsUpdate.add(jsonCandidate);
                    }
                }
            }
            
            if( String.isBlank(queryStringPhone) && String.isBlank(queryStringEmail) && String.isBlank(queryStringExtId)){
                listOfContactsAdd.add(jsonCandidate);  
                sendResponse.message = 'Dupe Check: No dupes found, attempting to add contact.';
            }
        }catch(Exception e){
            sendResponse.message = 'Issue found while dupe checking.';
            sendResponse.statusCode = SbHelper.errorHandler(e);
            helper.sendEmailNotification(sendResponse.statusCode, sendResponse.message, 'Candidate', e);
            return sendResponse;
        }
        
        
        //now create/update the candidate and related skills/employment history
        try{
            Boolean hasCompletedDML = false;
            
            //insert the list of contacts that has been generated  
            if(!listOfContactsAdd.isEmpty()){
                sendResponse.message = 'Attempting to insert ' + listOfContactsAdd.size() + ' contact record(s).'; 
                
                insert listOfContactsAdd;    
                hasCompletedDML = true;
                
            }
            
            //else, if contacts are to be updated 
            else if(!listOfContactsUpdate.isEmpty()){

                //if FULL CONTACT UPDATE is enabled - complete full update of all mapped fields
                if(helper.updateFullCandidateRecord){
                    system.debug('DEBUG === FULL CANDIDATE UPDATE');
                    sendResponse.message = 'Attempting to update ' + listOfContactsUpdate.size() + ' contact record(s).'; 
                    
                    //now update the Contact
                    update listOfContactsUpdate;   
                    hasCompletedDML = true;
                }


                //otherwise PARTIAL CONTACT update, only update the Source and return the record ID only, allowing for addition of the new CV document instead of a full update to the record
                else if(!helper.updateFullCandidateRecord){
                    system.debug('DEBUG === PARTIAL UPDATE OF CANDIDATE');
                    list<SObject> listOfContactsToPartiallyUpdate = new list<SObject>();  

                    for (SObject contactTemp : listOfContactsUpdate){

                        //create a new dynamic sObject to update - objectName for candidate stored in Metadata
                        SObject contactToPartiallyUpdate = Schema.getGlobalDescribe().get(helper.objectName).newSObject();

                        //Add in, fields to update, like Contact Id/Source/TextResume
                        contactToPartiallyUpdate.put('Id', contactTemp.get('Id'));
                        if (helper.candidateSource != null || helper.candidateSourceName != null){
                            if (helper.fieldMapping.containsKey('sourceid')) contactToPartiallyUpdate.put(helper.fieldMapping.get('sourceid'),helper.candidateSource);
                            if (helper.fieldMapping.containsKey('sourcename')) contactToPartiallyUpdate.put(helper.fieldMapping.get('sourcename'),helper.candidateSourceName);
                        }
                        if (helper.fieldMapping.containsKey('textresume')) contactToPartiallyUpdate.put(helper.fieldMapping.get('textresume'), contactTemp.get(helper.fieldMapping.get('textresume')));
                        
                        //add to list
                        listOfContactsToPartiallyUpdate.add(contactToPartiallyUpdate); 
                        
                    }   
                    
                    //reset jsonCandidate to only return the partially updated fields
                    jsonCandidate.clear();
                    jsonCandidate = (SObject) listOfContactsToPartiallyUpdate[0];

                    //now update the Contacts with only Source
                    update listOfContactsToPartiallyUpdate;   
                    hasCompletedDML = true;
                    
                }
            } 

            
            
            
            
        }catch(dmlException de){
            sendResponse.status = 'Exception'; 
            sendResponse.statusCode = 202;
            sendResponse.message = 'Error in inserting contacts: ' + de;
            return sendResponse;
        }
    
        //otherwise, successfully ran
        sendResponse.status = 'Success';
        sendResponse.statusCode = 200;
        if (listOfContactsAdd.size() >= 1 && listOfContactsUpdate.size() == 0){
            sendResponse.message = 'Contact(s) created.';
        }
        
        if (listOfContactsUpdate.size() >= 1 && listOfContactsAdd.size() == 0){
            if (helper.updateFullCandidateRecord){ //if FULL candidate update set to TRUE
                sendResponse.message = 'Candidate record updated fully.';
            }
            else
                sendResponse.message = 'Partial update, with Source.';
        }
        
        return sendResponse;
        
    }
    

    //**************************************
    // Responder Class: manages the status/http code response, storing any ContactID/list of contacts relevant
    //**************************************
    global class responder{
        
        //set and/or get code, ensure RestResponse StatusCode is aligned
        public Integer statusCode {
            get{
                return statusCode;
            } 
            set{ //Update the RestResponse StatusCode to the same value & set status
                this.status = statusMessage.get(value);
                system.debug('DEBUG === Responder, Code: ' + value + ' / Status: ' + this.status + ' / Message: ' + this.message);
                res.statusCode = value; //set the REST response code (to align with StatusCode of responder)
                statusCode = value;
            }  
        } 
        public String status {get;set;} 
        public SObject listData {
            get{ //when retrieving listData, extract the jsonCandidate and return as a list

                this.listData = jsonCandidate;
                return this.listData;
            }
            set;
        }  
        public String message {get;set;} 
        public Boolean userInLighting {get; set;}
        //constructor
        public responder() {
            //default all values
            this.statusCode = 302;
            this.message = 'Rest Service Initialised.';
        }
    }
    
    
}