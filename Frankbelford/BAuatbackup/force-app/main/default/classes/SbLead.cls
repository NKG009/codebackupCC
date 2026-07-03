//********************************************************************************************
//********************************************************************************************
//
//     Sourcebreaker Lead Import, creating a Job Lead within the CRM
//
//********************************************************************************************
//********************************************************************************************


@restResource(urlMapping='/sbOpsLead/*') 
global with sharing class SbLead{      
    
    //Variables relating to the input from the REST service
    private static RestRequest req {get; set;}
    private static RestResponse res {get; set;}
    private static string ContentType {get; set;}
    private static string inputSource {get; set;}
    private static boolean createAccount {get; set;}
    
    private static SbHelper helper {get; set;}
    private static responder sendResponse {get; set;}

    private static SbJsonLead.leadWrapper jsonInputWrapper {get; set;}
    private static SbJsonLead.dataObject jsonInput {get; set;}
    private static SObject jsonLead {get; set;}  //dynamic sObject for managing multi-currency (while also supporting non-MC orgs)
    
    //HTTP Response Codes
    private static final map<Integer, string> statusMessage = new map<Integer, string>{200 => 'Request: Completed Successfully.',202 => 'Request: Partially Completed.',206 => 'Manual Account selection required by users.',302 => 'REST API Initialised.',400 => 'Request Failed: Client Side Error.',404 => 'Request Failed: Not Found.',406 => 'Request Failed: Content-Type specified in HTTP request is not supported.',500 => 'Request Failed: Salesforce exception found.'};
        
        
    
    //****************************************
    //REST POST Resource: When called, this parses the string to retrive the XML in the response body
    //****************************************
    @httpPost
    global static responder leadHttpPost(){
        
        req = RestContext.request;
        res = RestContext.response;
        sendResponse = new responder();

        helper = new SbHelper(false); 
        sendResponse.userInLighting = helper.prefersLightning;

        if(!helper.settingsFound){
            sendResponse.statusCode = 404;
            sendResponse.message = 'Required settings/mappings not found';
            return sendResponse;
        }

        try{
            system.debug('req.headers: ' + String.valueOf(req.headers));
            //capture the REST request details from the Request Header:
            if (!String.isEmpty(req.headers.get('Content-Type'))) ContentType = req.headers.get('Content-Type');
            if (!String.isEmpty(req.headers.get('Input-Source'))) inputSource = req.headers.get('Input-Source');
            if (!String.isEmpty(req.headers.get('Create-Account'))){
                //added extra logic to handle parsing of 0, 1, true and false values
                String tempCreateAcct = req.headers.get('Create-Account');
                if (String.valueOf(tempCreateAcct) == '1' || String.valueOf(tempCreateAcct) == 'true'){
                	createAccount = true;
            	}
                else{
                    createAccount = false;
                }
            }       
        }
        catch(exception e){
            sendResponse.message = 'Error initialising Request Headers.';
            sendResponse.statusCode = SbHelper.errorHandler(e);
            helper.sendEmailNotification(sendResponse.statusCode, sendResponse.message, 'Lead', e);
            
            return sendResponse;
        }

        if (String.isNotBlank(ContentType) && ContentType.toUpperCase() != helper.inputContentType.toUpperCase()){ //using capitalize to avoid issues re: string case.
            sendResponse.statusCode = 406;
            sendResponse.message = 'Content-Type is not specifed as the expected "application/json" format.  Content-Type header received: ' + ContentType;
            return sendResponse;
        }
        //body of the request should include the JSON
        if(String.valueOf(req.requestBody) == NULL || String.valueOf(req.requestBody) == ''){
            sendResponse.statusCode = 400;
            sendResponse.message = 'No Rest Body found.';
            return sendResponse;
        }else if(req.requestBody != NULL) createJobLead(req.requestBody.toString()); //continue on to process the Contact and related records
        
        
        return sendResponse;
    }

    
    
    //**************************************
    // CreateContact method, as the JSON input isn't in the same format just to create, transform the object/class to a contact record for insert
    //**************************************
    public static responder createJobLead(string inputBody){ 

        try{
            
            //format JSON string
            if (inputBody.startsWith('[')) {
                inputBody = inputBody.removeStart('[').removeEnd(']').trim();
            }
            
            //test for unescaped " in the string if so, format summary and description text
            Integer summaryLocation = inputBody.lastIndexOf('\"summary\":');
            String str = inputBody.mid(summaryLocation, 7);
            Integer descriptionLocation = inputBody.lastIndexOf('\"description\":');
            Integer lengthString = inputBody.length();

            //Map<String,Object> jsonParsedMap = new Map<String,Object>();

            //now let's test how input in structured...  lead in data wrapper
            String wrapperTest = inputBody.replaceAll(' ', '').toLowerCase();
            if(wrapperTest.contains('"data":[')){
                jsonInputWrapper = (SbJsonLead.leadWrapper) JSON.deserialize(inputBody, SbJsonLead.leadWrapper.class);
                if(jsonInputWrapper.Data[0] != null){
                    jsonInput = jsonInputWrapper.Data[0];
                    system.debug('lead inputBody from data object: ' + inputBody);
                    sendResponse.message = 'JSON (Sovren) has been deserialized.';   
                    sendResponse.statusCode = 302;
                }
            }
            //otherwise the lead object is being parsed directly
            else {
                system.debug('lead inputBody from lead record: ' + inputBody);
                jsonInput = (SbJsonLead.dataObject) JSON.deserialize(inputBody, SbJsonLead.dataObject.class);
            }

            //now test, that we have jsonInput object
            if (jsonInput == null) {
                sendResponse.message = 'JSON Object: No data found in JSON Input, or unexpected format.';
                sendResponse.statusCode = 400;
                return sendResponse;
            }
            
        }
        catch(Exception e){
            //if JSON exception, then throw error
            sendResponse.message = 'JSON Object: Issue deserializing JSON.';
            sendResponse.statusCode = SbHelper.errorHandler(e);
            helper.sendEmailNotification(sendResponse.statusCode, sendResponse.message, 'Lead', e);
            
            return sendResponse;
        }  

        try{
            //create a new dynamic sObject to update the recored - allowing for environment specific fields like CurrencyISOCode where available.
            jsonLead = Schema.getGlobalDescribe().get(helper.objectName).newSObject(); //objectName for leads stored in Metadata
        }
        catch(Exception e){
            sendResponse.message = 'Error defining the object: ' + helper.objectName;
            sendResponse.statusCode = SbHelper.errorHandler(e);
            helper.sendEmailNotification(sendResponse.statusCode, sendResponse.message, 'Lead', e);
            
            return sendResponse;
        }
        
        String companyName = jsonInput.company;
        
        if(inputSource != NULL && helper.fieldMapping.containsKey('jobboard')){
        	jsonLead.put(helper.fieldMapping.get('jobboard'), inputSource);
        }
        if(string.isNotEmpty(companyName) && helper.fieldMapping.containsKey('leadlastname')){ 
            
            jsonLead.put(helper.fieldMapping.get('leadlastname'), companyName);
        }
        if(jsonInput.name != NULL && helper.fieldMapping.containsKey('jobname')) {
                jsonLead.put(helper.fieldMapping.get('jobname'), jsonInput.name);
        }
        if(jsonInput.jobBoard != NULL && helper.fieldMapping.containsKey('jobboard')){ 
            jsonLead.put(helper.fieldMapping.get('jobboard'), jsonInput.jobBoard);
        }
        if(jsonInput.summary != NULL && helper.fieldMapping.containsKey('description')) {
            jsonLead.put(helper.fieldMapping.get('description'), jsonInput.summary);
        }
        
        //update partially extracted Lead Info
        sendResponse.statusCode = 202;
        sendResponse.listData = jsonLead;
        
        system.debug('jsonInput: ' + jsonInput);
        if(jsonInput.details != NULL ){
            try{
                if(helper.fieldMapping.containsKey('leademail')){
                    if(!jsonInput.details.emails.isEmpty() && jsonInput.details.emails[0] != NULL ) {
                        jsonLead.put(helper.fieldMapping.get('leademail'), jsonInput.details.emails[0]);
                    }
                }

                if(helper.fieldMapping.containsKey('leadphone')){
                    if(!jsonInput.details.phones.isEmpty() && jsonInput.details.phones[0] != NULL) {
                        jsonLead.put(helper.fieldMapping.get('leadphone'), jsonInput.details.phones[0]);
                    }
                }
            }catch(ListException le){
                sendResponse.message = 'Error in processing Email/Phone information for Lead.';
                sendResponse.statusCode = 500;
                return sendResponse;
            }
        }
        
        //Add partially extracted job lead into response
        sendResponse.statusCode = 202;
        sendResponse.listData = jsonLead;

        list<SObject> foundRecords = new list<SObject>();
        SObject parentToUse; 

        if(companyName != null && companyName != '' && helper.fieldMapping.containsKey('leadparentobject')){
            String queryString = 'Select Id, Name From ' + helper.fieldMapping.get('leadparentobject') +' Where Name = \'' + companyName +'\' LIMIT 1';
            //check if account name already exists within Salesforce
            foundRecords = new list<SObject>();
            foundRecords = Database.query(queryString);
        }
            
        
        //if account match found
        if (!foundRecords.isEmpty() && !string.isBlank(companyName)) {
            parentToUse = foundRecords[0];
        }
        
        //else if no company name, use that account
        else if (string.isBlank(companyName) || createAccount == false){ 
            if(!string.isBlank(companyName) && helper.fieldMapping.containsKey('companyname')){
                jsonLead.put(helper.fieldMapping.get('companyname'), companyName);
            }
            sendResponse.statusCode = 202;
            sendResponse.message = 'Dupe Check: Manual Account selection required by users.';
            sendResponse.listData = jsonLead;
            return sendResponse;
        } 

        //finally, if other conditions fail try to createAccount
        else if (helper.fieldMapping.containsKey('leadparentobject')){
            parentToUse = Schema.getGlobalDescribe().get(helper.fieldMapping.get('leadparentobject')).newSObject();
            //create a new dynamic sObject to update - objectName for candidate stored in Metadata
            parentToUse.put('Name', companyName);

            try{
                insert parentToUse; //insert the parent record, to be used later for linking
            }
            catch(DMLException de){
                    sendResponse.status = 'Exception'; 
                    sendResponse.statusCode = 202;
                    sendResponse.message = 'Error in inserting Account record: ' + de;
                    return sendResponse;
            }
        }
        
        //now parentToUse has been defined, link to Job Lead
        if(helper.fieldMapping.containsKey('companyid')) {
            jsonLead.put(helper.fieldMapping.get('companyid'), parentToUse.get('Id'));
        }
        if(helper.fieldMapping.containsKey('companyname')) {
            jsonLead.put(helper.fieldMapping.get('companyname'), companyName);
        }
        sendResponse.listData = jsonLead;
            

        try{
            insert jsonLead;
            sendResponse.message = 'Completed insert.';
            sendResponse.statusCode = 200;
        }
        catch(Exception e){
            sendResponse.status = 'Exception'; 
            sendResponse.statusCode = 202;
            sendResponse.message = 'Error in inserting leads: ' + e;
        }

        return sendResponse;
    
    }

    
    //**************************************
    // CreateContact method, as the JSON input isn't in the same format just to create, transform the object/class to a contact record for insert
    //**************************************
    global class responder{
        
        //set and/or get code, ensure RestResponse StatusCode is aligned
        public Integer statusCode {
            get{
                return statusCode;
            } 
            set{//Update the RestResponse StatusCode to the same value & set status
                this.status = statusMessage.get(value);
                system.debug('DEBUG === Responder, Code: ' + value + ' / Status: ' + this.status + ' / Message: ' + this.message);
                res.statusCode = value; //set the REST response code (to align with StatusCode of responder)
                statusCode = value;
            }  
        } 
        public String status {get;set;} //status string
        public SObject listData {get;set;}  //list to store results
        public String message {get;set;} //message string
        public Boolean userInLighting {get; set;}
        
        //constructor
        public responder() {
            //default all values
            this.statusCode = 302;
            this.message = 'Rest Service Initialised.';
        }
    }
    
    
}