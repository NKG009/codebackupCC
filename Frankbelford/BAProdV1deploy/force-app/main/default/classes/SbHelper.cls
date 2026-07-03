//********************************************************************************************
//********************************************************************************************
//
//     Sourcebreaker Helper, central 'helper' class for lead and candidate parsing
//
//********************************************************************************************
//********************************************************************************************


public class SbHelper{
    
    //****************************************

    //Constants used throughout the code
    //****************************************
           
    //What object should the code look for in the JSON input?
    public final string inputResumeObject = 'StructuredXMLResume';
    public final string inputTextResumeObject = 'NonXMLResume';
    public final string inputContentType = 'application/json'; 

    public static final string nsTalentRover = 'TalentRover';
    public static final string nsBullhorn = 'Bullhorn'; 
    public static final string nsSalesforce = 'Salesforce'; 
    
    
    //****************************************
    //Variables used on code initialisation
    //****************************************
    
    //Candidate vs Lead Parsing variables 
    public string candidateParentID{get; set;}
    public string candidateRT{get; set;} 
    public string candidateSource {get; set;} 
    public string candidateSourceName {get; set;} 
    public string objectName {get;set;}
    public boolean updateFullCandidateRecord {get; set;}
    public Boolean isCandidateParsing {get; set;}
    public Boolean settingsFound {get;set;}
    public map<String,String> fieldMapping {get;set;}

    //debug variables, used if debug mode is turned on
    public boolean debugEmailEnabled {get; set;}
    public string debugEmailAddress {get; set;}
    
    //user varaiables, parsed back to SourceBreaker to use for modals
    public String userName {get; set;}
    public Boolean prefersLightning {get;set;}
       
    

    //****************************************
    // Constructor to be used when there is an 'inputSource', primarily used for Jobscience
    //****************************************
    public SbHelper (string inputSource, Boolean isCandidateParsing){
        this.candidateSourceName = inputSource;
        this.isCandidateParsing = isCandidateParsing;
        initalise();
    }

    //****************************************
    // Primary constructor when there is no 'inputSource'
    //****************************************
    public SbHelper(Boolean isCandidateParsing){
        this.candidateSourceName = 'SourceBreaker';
        this.isCandidateParsing = isCandidateParsing;
        initalise();
    }


    //****************************************
    // Starting 'util' method, which loads initial shared variables/etc used in main classes
    //****************************************
    public void initalise(){

        
        //Determine if the running user is in Lightning or not, for which modals to present if error
        //Done via SOQL as UI methods not reliable enough at time of coding
        User runningUser = [SELECT Id, UserType, Profile.PermissionsLightningExperienceUser, 
                                    UserPreferencesLightningExperiencePreferred 
                            FROM User 
                            WHERE username =: UserInfo.getUsername()];
        if(runningUser.Profile.PermissionsLightningExperienceUser != null ){ 
            this.prefersLightning = (runningUser.Profile.PermissionsLightningExperienceUser && runningUser.UserPreferencesLightningExperiencePreferred) ? true : false;
        }
        System.debug('User Prefers Lightning: ' + this.prefersLightning);
        

        //set variable defaults to false
        this.userName = UserInfo.getName();        
        this.updateFullCandidateRecord = false;
        this.debugEmailEnabled = false;

        //now try and extract map of field mappings/settings
        fieldMapping = new map<String,String>();
        string whereAmI = whichEnviron(); //which environment is the code running in
        fieldMapping = findSettings(whereAmI); //find settings/field mappings
        

        //if list is empty/0 then create initial custom metadata record, setting all to default FALSE
        if(!fieldMapping.isEmpty()){
            settingsFound = true;
            if(fieldMapping.containsKey('fullcandidateupdate')) {
                this.updateFullCandidateRecord = Boolean.valueOf(fieldMapping.get('fullcandidateupdate'));
            }
            
            if(fieldMapping.containsKey('sendemail')) {
                this.debugEmailEnabled = Boolean.valueOf(fieldMapping.get('sendemail'));
            }
            if(fieldMapping.containsKey('supportemail')) {
                this.debugEmailAddress = fieldMapping.get('supportemail');
            }
        }
        else{
            settingsFound = false;
            return;
        }
        

        if(isCandidateParsing && fieldMapping.containsKey('candidateobject')){
            this.objectName = fieldMapping.get('candidateobject'); 
           
            //attempt to find relevant recordtype
            try{
                if(fieldMapping.containsKey('candidaterecordtype')){
                    
                    SObjectType candidateType = Schema.getGlobalDescribe().get(this.objectName);
                    string recordType = fieldMapping.get('candidaterecordtype');
                    
                    this.candidateRT = candidateType.getDescribe().getRecordTypeInfosByName().get(recordType).getRecordTypeId();

                }
            }catch (Exception e){
                system.debug('DEBUG === Error: CandidateRT not found: '+ e);
            }

            //attempt to find a parent record to link candidate to
            if (fieldMapping.containsKey('parentid') && fieldMapping.containsKey('candidateparentobject') && fieldMapping.containsKey('candidateparentrecord')){

                string candidateParentObject = fieldMapping.get('candidateparentobject'); //Typically populated if candidate is a contact object
                string parentQuery = 'SELECT ID FROM ' + candidateParentObject + ' WHERE NAME LIKE \'' + fieldMapping.get('candidateparentrecord') + '\' ORDER BY LastModifiedDate Desc LIMIT 1';
                system.debug('parentQuery ' + parentQuery);
                
                List<SObject> candidateParentRecord = new List<SObject>(); 
                candidateParentRecord = Database.query(parentQuery);
                system.debug('candidateParentRecord ' + candidateParentRecord);

                if (!candidateParentRecord.isEmpty()){
                    this.candidateParentID = candidateParentRecord[0].Id;
                } 
                else if(candidateParentRecord.isEmpty()){
                    this.candidateParentID = NULL;
                }
            }

            //if seperate 'Source' object, then try and find the related Source record
            if (fieldMapping.containsKey('sourceobject') && fieldMapping.containsKey('sourceid')){ 
                string sourceObject = fieldMapping.get('sourceobject'); //Typically populated if Jobscience/Bullhorn 
                string queryString = 'Select ID, Name From ' + sourceObject + ' Where Name = : ' + this.candidateSourceName + ' Limit 1';
                list<SObject> queryResult = new list<sObject>();
                queryResult = Database.query(queryString);
                
                if(!queryResult.isEmpty()){ //if record is found, then use that record to link the candidate to
                    this.candidateSource = (string) queryResult[0].get('Id');
                }
                else if (queryResult.isEmpty()){ //else nothing found, create the record and use

                    sObject sourceRecord = Schema.getGlobalDescribe().get(sourceObject).newSObject();
                
                    if (fieldMapping.containsKey('sourcename')) sourceRecord.put(fieldMapping.get('sourcename'), this.candidateSourceName); //inputSource in fieldmap
                    if (fieldMapping.containsKey('sourceactive')) sourceRecord.put(fieldMapping.get('sourceactive'), TRUE);
                    if (fieldMapping.containsKey('sourcetype')) sourceRecord.put(fieldMapping.get('sourcetype'), 'Sourcing');                    
                    
                    try{
                        //insert the sobject 
                        Database.insert(sourceRecord);
                        this.candidateSource = (string) sourceRecord.get('Id');
                    }catch(DmlException e){
                        system.debug('DEBUG === Error inserting Source record');
                    }
                    
                }
            }
        }
        else if (!isCandidateParsing && fieldMapping.containsKey('leadobject')){
            objectName = fieldMapping.get('leadobject'); 
        }
        else{
            throw new SbException('Unable to load required field mapping for Candidate/Lead.');    
        }
    }


    //****************************************
    // Method to determine what managed package might be installed in org
    //****************************************
    public static String whichEnviron(){

        String whichEnvironment = '';

        //find out if we are in a jobscience environment or a talentrover environment
        if (Type.forName('ts2__Skill__c') != null) {
            whichEnvironment = nsBullhorn; //Jobscience/Bullhorn for Salesforce is installed
        }
        else if (Type.forName('TR1__EmploymentHistory__c') != null) { 
            whichEnvironment = nsTalentRover; //TalentRover is installed
        }
        else {
            whichEnvironment = nsSalesforce;
            //set to default Salesforce, then test if any FieldMappings added for SF value
        }

        return whichEnvironment;
    }


    //****************************************
    // Find and setup the pre-defined settings, like field mappings, sb callout URL and debug settings
    //****************************************
    public static map<String,String> findSettings (string whichEnvironment){

        //get initial information re: environment and a list of all custom metadata fields
        String environment = whichEnviron();
        system.debug('findSettings | Environment: '+ environment);
        String settingsType = 'SourceBreakerSettings__mdt'; //API name of custom metadata: SourceBreaker Settings
        

        //prepare a list of field names, allowing dynamic SOQL to essentially 'select *' from mapping record
        List<String> mappingFields = new List<String>();
        mappingFields.addAll(getFields(settingsType).keySet());

        //now run the 'select *'' query 
        list<SourceBreakerSettings__mdt> querySettings = new list<SourceBreakerSettings__mdt>();
        String queryString = 'select ' + string.join(mappingFields, ',') + ' from ' + settingsType + ' where Environment__c = \'' + environment + '\'';
        querySettings = (list<SourceBreakerSettings__mdt>) Database.query(queryString);
        
        if(querySettings.isEmpty()){
            system.debug('findSettings | No settings found.');
            return null;
        }

        //copy the found result into an Sobject record, so we can loop through and prepare 'settings map'
        Sobject environmentSetting = querySettings[0];
        
        //now for each field in custom settings, prepare a map to be reference later on
        Map<String,String> settingsMap = new Map<String,String>();
        for(String fieldMapping : mappingFields){
            
            //if there is a mapping/setting value, then add it to the map
            String settingValue = string.valueOf(environmentSetting.get(fieldMapping));
            
            //format the setting name to make code easier to read in candidate/lead parsing
            String formatFieldName = fieldMapping.removeEnd('__c').toLowerCase(); 
            
            if(string.isNotBlank(settingValue)){
                //add to settingsMap 
                settingsMap.put(formatFieldName, settingValue);
            }
            else{
                system.debug('Skipping ' + formatFieldName + ', as no mapping value');
            }
        }

        return settingsMap;
        
    }
    
    //****************************************
    // Used to get a list of fields and their DescribeFieldResults, input is sinlge sObject name (or Custom Metadata name) 
    //****************************************
    public static Map<String,Schema.DescribeFieldResult> describeObject(String inputObject){
        
        //take input variable and add to a list
        List<string> objectName = new List<string>{inputObject};

        //Describe the metadata, to enable us to extract all fields and settings
        Schema.DescribeSobjectResult objectToDescribe = Schema.describeSObjects(objectName)[0].getSObjectType().getDescribe();
        Map<String,Schema.DescribeFieldResult> finalMap = new Map<String, Schema.DescribeFieldResult>();

        // map of all fields in the object
        Map<String, Schema.SObjectField> objectFields = objectToDescribe.fields.getMap();

        // iterate over the requested fields and get the describe info for each one. 
        // add it to a map with field name as key
        for(String field : objectFields.keySet()){
            // skip fields that are not part of the object
            if (objectFields.containsKey(field)) {
                Schema.DescribeFieldResult dr = objectFields.get(field).getDescribe();
                // add the results to the map to be returned
                finalMap.put(field, dr); 
            }
        }
        return finalMap;
    } 


    //****************************************
    // Simple utility method to get a list of fields on an sObject (or Custom Metadata name)  
    //****************************************
    public static Map<String,Schema.SObjectField> getFields(String inputObject){

        SObjectType objectType = Schema.getGlobalDescribe().get(inputObject);
        Map<String,Schema.SObjectField> objectFields = objectType.getDescribe().fields.getMap();
        
        return objectFields;
    }
    

    //**************************************
    // errorHandler Class: manages any exceptions that are thrown, and updated Responder
    //**************************************
    public static Integer errorHandler(Exception exceptInfo){

        Integer statusCode; 

        //format the stackTrace to get the class/method (and not all classes/etc)
        string stackTrace = exceptInfo.getStackTraceString().substringAfter('\n');
        if (stackTrace.startsWith('Class.')){
            stackTrace = stackTrace.substringAfter('Class.').substringBefore(':');
        }
        
        //if JSON or NULL Pointer, then throw error as 400 status code
        if (exceptInfo.getTypeName().contains('JSONException') || exceptInfo.getTypeName().contains('NullPointerException')){
            statusCode = 400;  
        }
        else if(exceptInfo.getTypeName().contains('DmlException')){
            statusCode = 202;  
        }
        else { //else, set statusCode to 500 for all other exceptions
            statusCode = 500;  
        }

        //send email debug
        return statusCode; 

    }


    //Allows us to throw a new exception anywhere in code
    public virtual class SbException extends Exception {}


    //method is used to send the email notification
    public void sendEmailNotification(Integer statusCode, String statusMessage, String apiInvoked, Exception errorInfo){ 
        
        //initialise the variables to send debug email
        String userName = UserInfo.getName();
        list<string> userDetails = new list<string>();  

        userDetails.add('ORG INFO === userEmail:' + UserInfo.getUserEmail());
        userDetails.add('orgName:' + UserInfo.getOrganizationName());
        userDetails.add('defaultCurrency:' + UserInfo.getDefaultCurrency());
        userDetails.add('multiCurrency:' + UserInfo.isMultiCurrencyOrganization());
        
        //extract custom metadata settings
        Boolean sendDebugEmail = false;
        string sendTo = '';
        
        if ( this.debugEmailEnabled != NULL ) sendDebugEmail = this.debugEmailEnabled;
        if ( this.debugEmailAddress != NULL ) sendTo = this.debugEmailAddress;
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();        
        if (sendDebugEmail == TRUE) { //if sendEmail = True, then send the email
            message.toAddresses = new String[] { sendTo };                   
                message.subject = apiInvoked + ' Parsing Exception from User: '+ userName;
            message.plainTextBody =  'Exception: ' + statusCode + ' | ' + statusMessage + '\n\n';
            message.plainTextBody += userDetails + '\n\n';
            message.plainTextBody += 'Details: ' + errorInfo;
            
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
        }
        
    }


}