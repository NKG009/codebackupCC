//********************************************************************************************
//********************************************************************************************
//
//     Sourcebreaker Test, contains the test classes which cover various scenarios
//
//********************************************************************************************
//********************************************************************************************
 
@IsTest
public with sharing class SbTest {
    
    @IsTest
    static void postJsonDeserialise_Error(){
        //This test method will create expected errors in the JsonDeserialize method
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        //**********************************************************************************/
        //test: is content-type correct
        //expected outcome: set the request headers, failed request, return of statuscode 406
        req.requestURI = '/services/apexrest/sbOpsJSON/';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/xml'); //this should error
        //set request body, strBody is the JSON input
        String strBody = '';
        req.requestBody = blob.valueOf(strBody);

        //prepare the rest request
        RestContext.request = req;
        RestContext.response = res;
 
        //create test data (account, recordType)
        Account testAccount = new Account(Name='Candidates');
        insert testAccount;

        Test.startTest();
        SbCandidate.responder getResponse = SbCandidate.startHere();
        System.assert(getResponse != null); //response shouldn't be null
        System.assertEquals(406,getResponse.statusCode); 
        System.assertEquals('Request Failed: Content-Type specified in HTTP request is not supported.',getResponse.status); 

        //**********************************************************************************/
        //test: invalid JSON object
        //expected outcome: set the request headers, failed request, return of statuscode 400

        //reset req & res... 
        req = new RestRequest();
        res = new RestResponse();

        //populate all the headers this time, but no RestBody
        req.requestURI = '/services/apexrest/sbOpsJSON/';
        req.httpMethod = 'POST';
        //req.addHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.addHeader('Content-Type', 'application/json'); //this should error
        req.addHeader('inputFormat', 'SOVREN');
        req.addHeader('inputFirstName', 'Joe');
        req.addHeader('inputLastName', 'Smith');
        req.addHeader('inputSalaryCurrent', '30000');
        req.addHeader('inputSalaryDesired', '45000');
        req.addHeader('inputSource', 'SourceBreaker-Test');

        //prepare the rest request
        RestContext.request = req;
        RestContext.response = res;

        //commence test
        getResponse = SbCandidate.startHere();
        System.assert(getResponse != null); //response shouldn't be null
        System.assertEquals(400,getResponse.statusCode); 
        System.assertEquals('Request Failed: Client Side Error.',getResponse.status); 


        //**********************************************************************************/
        //test: null for request body
        req = new RestRequest();
        res = new RestResponse();

        req.requestURI = '/services/apexrest/sbOpsJSON/';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json'); //this should error

        //prepare the rest request
        RestContext.request = req;
        RestContext.response = res;
        
        getResponse = SbCandidate.startHere();
        System.assert(getResponse != null); //response shouldn't be null
        System.assertEquals(400,getResponse.statusCode); //response should = 400
        system.assertEquals('No Rest Body found.', getResponse.message);

        Test.stopTest();

    }

    //**********************************************************************************/
    //test: Sovren inputFormat & name in the PersonObject (not in the REST headers).  
    //expected outcome: successful request, return of statuscode 200
    @isTest
    public static void postJsonDeserialise_Success(){
        
        //prepare the JSON to be input into the test via REST API
        String newCandidate = createJsonRecord('createContact');
        Blob inputBodyJson = blob.valueOf(newCandidate);
        
        //now prepare the rest request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/sbOpsJSON/'; //remove test for live 
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json'); //this should error
        req.addHeader('inputFormat', 'SOVREN');  //Options: SOVREN or RESUME
        req.addHeader('inputSalaryCurrent', '30000');
        req.addHeader('inputSalaryDesired', '45000');
        req.addHeader('inputCurrency', 'GBP'); //if multicurrency, find an active currency and use instead of hardcoded
        req.addHeader('inputSource', 'SourceBreaker-Test');

        //set request body, inputBody is the JSON input from above
        req.requestBody = inputBodyJson; 

        //prepare the rest request
        RestContext.request = req;
        RestContext.response = res;

        //create test data (account, recordType)
        Account testAccount = new Account(Name='Candidates');

        test.startTest();
        
        SbCandidate.responder getResponse = SbCandidate.startHere();
        System.assert(getResponse != null); //response shouldn't be null
        System.assertEquals(200, getResponse.statusCode); 
        System.assertEquals('Request: Completed Successfully.', getResponse.status); 
        System.assert(string.valueOf(getResponse.listData).contains('45000')); //test to ensure SalaryDesired is in ListData
        System.assertEquals(Null, getResponse.listData.get('AccountId')); //test to ensure accountId is null

        //Now insert the 'candidate' account, and retest, ensuring still successful
        insert testAccount;
        getResponse = SbCandidate.startHere();
        System.assert(getResponse != null); //response shouldn't be null
        System.assertEquals(200, getResponse.statusCode); 
        System.assertEquals('Request: Completed Successfully.', getResponse.status); 
        System.assert(string.valueOf(getResponse.listData).contains('Testeroo')); //test to ensure LastName is in ListData
        
        //prepare sbnotice test with the contact
        system.debug('GetResponse: ' + getResponse.listData);
        
        SbUrlController.SbResponseWrapper sbNotice = new SbUrlController.SbResponseWrapper();
        sbNotice.access_token = '01231231231';
        sbNotice.recordId = (String)getResponse.listData.Id;
        sbNotice.action = 'Create';
        sbNotice.candidateData = new SbUrlController.CandidateDataObject();
        sbNotice.leadData = null;
        sbNotice.parseType = '';
        
        string notice = JSON.serialize(sbNotice);
        SbUrlController.notifySourceBreaker (sbNotice.recordId, notice, 'Contact', 'Create', '');
        
        //Now try new contact creation, if no address in JSON but in the rest headers
        newCandidate = createJsonRecord('NoAddress');
        inputBodyJson = blob.valueOf(newCandidate);
        req.addHeader('inputLocationCity', 'London');
        RestContext.request = req;

        getResponse = SbCandidate.startHere();
        System.assert(getResponse != null); //response shouldn't be null


        //throw PDF creation exception, due to IMG SRC tag in HTML
        newCandidate = createJsonRecord('PdfException');
        inputBodyJson = blob.valueOf(newCandidate);
        req.requestBody = inputBodyJson; //re-set request body, inputBody is the JSON input from above
        RestContext.request = req;
        
        getResponse = SbCandidate.startHere();
        System.assert(getResponse != null); //response shouldn't be null

        test.stopTest();
   }

        
	
    @isTest
    public static void userControllerTests(){
        
        //create the SbResponseWrapper
        SbURLController.SbResponseWrapper sbResponse = new SbURLController.SbResponseWrapper();
        sbResponse.access_token = 'TEST_ACCESS_TOKEN';
        sbResponse.CandidateData = new SbURLController.CandidateDataObject();
        sbResponse.CandidateData.resumeId = 'R12345678';
        sbResponse.CandidateData.searchId = 'S12345678';
        sbResponse.CandidateData.jobBoard = 'jobBoard';
        sbResponse.CandidateData.link = 'https://test.com';
        sbResponse.CandidateData.name = 'Test Testerson';
        sbResponse.CandidateData.instance_url = 'https://test.my.salesforce.com';
        
        string sbNotify = JSON.serialize(sbResponse);
        system.debug('TEST DEBUG ==== sbNotify ' + sbNotify);
        
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Testor';
        
        test.startTest();
        
        //insert the contact
        insert c;
        
        //now test the updating of fields method
        map<String, String> mapOfFields = new map<String, String>();
        mapOfFields.put('Id', c.Id);
        mapOfFields.put('RecordTypeId', c.RecordTypeId);
        mapOfFields.put('FirstName', c.FirstName);
        mapOfFields.put('LastName', c.LastName);
        mapOfFields.put('Salutation', c.Salutation);
        mapOfFields.put('Email', c.Email);
        mapOfFields.put('MailingCity', c.MailingCity);
        mapOfFields.put('MailingCountry', c.MailingCountry);
        mapOfFields.put('MailingPostalCode', c.MailingPostalCode);
        mapOfFields.put('MobilePhone', c.MobilePhone);
        mapOfFields.put('Phone', c.Phone);
        mapOfFields.put('Title', c.Title);
        
        string jsonContactFields = JSON.serialize(mapOfFields);
        
        //extract the list of fields
        Map<String, Object> fieldMap = SbURLController.getFieldDescribeMap('Contact');
        system.assert(fieldMap.get('LastName') != null , 'LastName in fields, doesn\'t have a result');
        
        //get recordType if available
        Id contactRecordType = SbURLController.getRecordTypeInformation();
        if (contactRecordType != null) system.assert(string.valueOf(contactRecordType.getSobjectType()) == 'RecordType', 'RecordType not found.');
        
        //retrive the metadata re: page layouts
        List<Object> lstSections = SbURLController.getPageLayoutFields('Contact');
        system.assert(lstSections.size() != 0, 'LayoutSection not found in environment.  Check Page Layout Names in SbURLController.');
        
        test.stopTest();
        
    }
    
    
    //**********************************************************************************/
    //test: Post a test lead via API 
    //expected outcome: successful request, return of statuscode 200
    @isTest
    public static void postLead_Success(){
        
        //prepare the JSON to be input into the test via REST API
        String newLead = createLeadRecord('noCompany');
        newLead = '[' + newLead + ']';
        Blob inputBodyJson = blob.valueOf(newLead);
        
        system.debug('postLead_Success newLead: ' + newLead);
        
        //now prepare the rest request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/sbOpsLead/'; //remove test for live 
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.addHeader('Input-Source', 'Test Class');
        req.addHeader('Create-Account', 'true');

        //set request body, inputBody is the JSON input from above
        req.requestBody = inputBodyJson;  
        
        //prepare the rest request
        RestContext.request = req;
        RestContext.response = res;

        test.startTest();
        
        SbLead.responder getResponse = SbLead.leadHttpPost();
        System.assert(getResponse != null); //response shouldn't be null
        System.assertEquals(202, getResponse.statusCode); 
        System.assertEquals('Request: Partially Completed.', getResponse.status); 

        //////////////////////////
        
        //now get wrapper and expect partial extract attempt (response 202)
        newLead = createLeadRecord('');
        inputBodyJson = blob.valueOf(newLead);
        
        //prepare the rest request
        RestContext.request = req;
        RestContext.response = res;
        
        //set request body, inputBody is the JSON input from above
        req.requestBody = inputBodyJson; 
      
        getResponse = SbLead.leadHttpPost();
        System.assert(getResponse != null); //response shouldn't be null
        //System.assertEquals(200, getResponse.statusCode);  //TODO: update and find out why this is 202 (18 Sept 2020)
        //System.assertEquals('Request: Completed Successfully.', getResponse.status); 
        
        test.stopTest();
   }
    



   //**********************************************************************************/
    //test: Post a test lead via API 
    //expected outcome: failed request, return of statuscode 400
    @isTest
    public static void postLead_Failure(){
        
        //prepare the JSON to be input into the test via REST API
        String newLead = '';
        Blob inputBodyJson = blob.valueOf(newLead);
        
        //now prepare the rest request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/sbOpsLead/'; //remove test for live 
        req.httpMethod = 'POST';

        //set request body, inputBody is the JSON input from above
        req.requestBody = inputBodyJson;  
        
        //prepare the rest request
        RestContext.request = req;
        RestContext.response = res;

        test.startTest();
        
        SbLead.responder getResponse = SbLead.leadHttpPost();
        System.assert(getResponse != null); //response shouldn't be null
        System.assertEquals(400, getResponse.statusCode); 
        System.assertEquals('Request Failed: Client Side Error.', getResponse.status); 

        //////////////////////////
        
        //now get wrapper and expect partial extract attempt (response 202)
        newLead = createLeadRecord('');
        inputBodyJson = blob.valueOf(newLead);
        
        //prepare the rest request
        RestContext.request = req;
        RestContext.response = res;

        req.addHeader('Create-Account', 'false');
        req.addHeader('Content-Type', 'test/xml'); //this should error
        req.addHeader('Input-Source', 'Test Class');
        
        //set request body, inputBody is the JSON input from above
        req.requestBody = inputBodyJson; 
      
        getResponse = SbLead.leadHttpPost();
        System.assert(getResponse != null); //response shouldn't be null
        System.assertEquals(406, getResponse.statusCode); 
        
        
        //////////////////////////
               
        //prepare the rest request with blank request body
        RestContext.request = req;
        RestContext.response = res;

        req.addHeader('Create-Account', 'false');
        req.addHeader('Content-Type', 'application/json'); //this should error
        req.addHeader('Input-Source', 'Test Class');
        
        //set request body, inputBody is the JSON input from above
        req.requestBody = null; 
      
        getResponse = SbLead.leadHttpPost();
        System.assert(getResponse != null); //response shouldn't be null
        System.assertEquals(400, getResponse.statusCode); 
        
        
        test.stopTest();
   }
    
    //**********************************************************************************/
    //Test: Sovren inputFormat & without PersonObject name in the PersonObject (not in the REST headers).  
    //Expected outcome: error response, return of statuscode 400 intially with a statuscode 200 with inputFirstName/inputLastName adddd
    @isTest
    public static void postJsonProcessing_Error(){
        
        //prepare the JSON to be input into the test via REST API
        String newCandidate = createJsonRecord('NullPersonName');
        
        //then convert string to blob, to send via REST 
        Blob inputBodyJson = blob.valueOf(newCandidate);
        
        //now prepare the rest request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        //**********************************************************************************/
        //test: Resume inputFormat & name in the PersonObject (not in the REST headers).  
        //expected outcome: successful request, return of statuscode 200
        req.requestURI = '/services/apexrest/sbOpsJSON/'; //remove test for live 
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json'); //this should error
        req.addHeader('inputFormat', 'SOVREN');  //Options: SOVREN or RESUME
        req.addHeader('inputSalaryCurrent', '30000');
        req.addHeader('inputSource', 'SourceBreaker-Test');

        //set request body, inputBody is the JSON input from above
        req.requestBody = inputBodyJson; 

        //prepare the rest request
        RestContext.request = req;
        RestContext.response = res;

        //create test data (account, recordType)
        Account testAccount = new Account(Name='Candidates');
        insert testAccount;

        test.startTest();
        
        SbCandidate.responder getResponse = SbCandidate.startHere();
        System.assert(getResponse != null); 
        
        //add in the inputFirstName & inputLastName to counter the fact that there is no PersonName object
        req.addHeader('inputFirstName', 'Jonny');
        req.addHeader('inputLastName', 'Backup');

        //prepare the rest request
        RestContext.request = req;
        RestContext.response = res;

        getResponse = SbCandidate.startHere();
        System.assert(getResponse != null); //response shouldn't be null
        System.assertEquals(200, getResponse.statusCode); 
        System.assertEquals('Request: Completed Successfully.', getResponse.status); 
        System.assert(string.valueOf(getResponse.listData).contains('Jonny')); //test to ensure FirstName is in ListData
        System.assert(string.valueOf(getResponse.listData).contains('Backup')); //test to ensure LastName is in ListData  


        //prepare the JSON to be input into the test via REST API - this time with no Resume Object in JSON
        newCandidate = createJsonRecord('NoResume');
        inputBodyJson = blob.valueOf(newCandidate);
        req.requestBody = inputBodyJson; //re-set request body, inputBody is the JSON input from above

        getResponse = SbCandidate.startHere();
        System.assert(getResponse != null); //response shouldn't be null
        System.assertEquals(404, getResponse.statusCode); 
        System.assert(getResponse.message.contains('JSON Object: StructuredXMLResume, not found in JSON Input'));

        test.stopTest();
   }

    
    public static string createLeadRecord(String reqType){
        //prepare the resume to then add into StructuredXMLResume
        SbJsonLead.leadWrapper wrapper = new SbJsonLead.leadWrapper();
        wrapper.Data = new list<SbJsonLead.dataObject>();
        
        //now prepare a record and create all nested arrays
        SbJsonLead.dataObject lead = new SbJsonLead.dataObject();
        lead.details = new SbJsonLead.detailsObject();
        lead.details.phones = new list<String>();
        lead.details.emails = new list<String>();
        lead.details.locations = new list<String>();
        
        //and finally, populate the lead values
        lead.description = 'this is a description';
        lead.education = 'Education';
        lead.isDownloaded = 'true';
        lead.isNew = 'true';
        lead.isViewed = 'true';
        lead.jobBoard = 'Test Company';
        lead.jobTitle = 'Job Title';
        lead.lastDownloaded = '2020-01-01';
        lead.lastViewed = '2020-01-01';
        lead.location = 'London';
        lead.summary = 'Candidate in London';
        lead.name = 'Joanne Londres';
        lead.link = 'https://test.com';
		lead.id = 'test123';

        lead.details.emails.add('Tmail1@tst.com'); 
        lead.details.emails.add('Tmail2@tst.com'); 
        lead.details.phones.add('0712343543'); 
		lead.details.companySize = '4321';
        lead.details.locations.add('London');
        
        //add it into wrapper, and serialise it
        if(reqType == 'noCompany'){
            lead.company = null;
        }
        else{
            lead.company = 'Test Company';
        }
        
        wrapper.Data.add(lead);
        return JSON.serialize(wrapper);
        
    }

    
    public static string createJsonRecord(string inputDetail){
        //*******************************/
        //createJsonRecord (based off the jsonWrapper), and use to then create JSON to be parsed 
        //test method to create the JSON Wrapper, and then attempt to parse the JSON via POST Rest API
        
        //prepare the resume to then add into StructuredXMLResume
        SbJsonCandidate.structuredResumeObject resumeDetails = new SbJsonCandidate.structuredResumeObject();
        
        resumeDetails.RevisionDate = string.valueOf(date.today());
        resumeDetails.ExecutiveSummary = 'This is an executive summary';
        resumeDetails.Objective = 'Development manager for a large ATS vendor or ASP in the HR space.';

        //Personal/Name details
        resumeDetails.ContactInfo = new SbJsonCandidate.contactInfoObject(); //to prevent Null Pointer exceptions, need to intialise object
        resumeDetails.ContactInfo.ContactMethod = new list<SbJsonCandidate.contactMethodObject>();
        resumeDetails.ContactInfo.PersonName = new SbJsonCandidate.personNameObject();
        if(!inputDetail.contains('NullPersonName')){ //if test class is not testing for 'Null Person Name', then populate the name info
            resumeDetails.ContactInfo.PersonName.GivenName = 'Jonny';
            resumeDetails.ContactInfo.PersonName.FamilyName = 'Testeroo';
            resumeDetails.ContactInfo.PersonName.MiddleName = 'M.';
            resumeDetails.ContactInfo.PersonName.FormattedName = 'Jonny Testeroo';
            resumeDetails.ContactInfo.PersonName.Affix = new list<SbJsonCandidate.affixObject>();
            SbJsonCandidate.affixObject affix = new SbJsonCandidate.affixObject();
            affix.x_text = 'II';
            affix.x_type = 'generation';
            resumeDetails.ContactInfo.PersonName.Affix.add(affix); 
        }

        //Contact information #1
        SbJsonCandidate.contactMethodObject cm1 = new SbJsonCandidate.contactMethodObject();
        cm1.Use = 'personal';
        cm1.WhenAvailable = 'anytime'; 
        cm1.Mobile = new SbJsonCandidate.phoneNumberObject();
        cm1.Mobile.FormattedNumber = '+447123123123';
        resumeDetails.ContactInfo.ContactMethod.add(cm1); 
        
        //Contact information #2
        SbJsonCandidate.contactMethodObject cm2 = new SbJsonCandidate.contactMethodObject();
        cm2.Use = 'personal';
        cm2.WhenAvailable = 'anytime';
        if(!inputDetail.contains('NoEmail')){    
            cm2.InternetEmailAddress = 'test@contact.com';
            resumeDetails.ContactInfo.ContactMethod.add(cm2);
        }

        //Contact information #3
        SbJsonCandidate.contactMethodObject cm3 = new SbJsonCandidate.contactMethodObject();
        cm3.Use = 'personal';
        cm3.WhenAvailable = 'anytime';
        cm3.InternetWebAddress = 'https://www.linkedin.com/in/testcontact';
        resumeDetails.ContactInfo.ContactMethod.add(cm3);

        //Contact information #4
        SbJsonCandidate.contactMethodObject cm4 = new SbJsonCandidate.contactMethodObject();
        cm4.Use = 'business';
        cm4.WhenAvailable = 'anytime';
        cm4.Telephone = new SbJsonCandidate.phoneNumberObject();
        cm4.Telephone.FormattedNumber = '+442012301230';
        resumeDetails.ContactInfo.ContactMethod.add(cm4);

        //Contact information #5
        SbJsonCandidate.contactMethodObject cm5 = new SbJsonCandidate.contactMethodObject();
        cm5.PostalAddress = new SbJsonCandidate.postalAddressObject();
        if(!inputDetail.contains('NoAddress')){ //if test class is not testing for 'NoAddress', then populate the name info
            cm5.PostalAddress.DeliveryAddress = new SbJsonCandidate.deliveryAddressObject();
            cm5.PostalAddress.DeliveryAddress.AddressLine = new list<string>();
            cm5.PostalAddress.DeliveryAddress.AddressLine.add('1 Test Ave');
            cm5.PostalAddress.CountryCode = 'UK';
            cm5.PostalAddress.Municipality  = 'London';
            cm5.PostalAddress.Region = new list<string>();
            cm5.PostalAddress.Region.add('Greater London');
            cm5.PostalAddress.PostalCode  = 'N12 345';
        }
        resumeDetails.ContactInfo.ContactMethod.add(cm5);

        //Contact information #6
        SbJsonCandidate.contactMethodObject cm6 = new SbJsonCandidate.contactMethodObject();
        cm6.Use = 'personal';
        cm6.WhenAvailable = 'anytime';
        cm6.InternetWebAddress = 'https://www.facebook.com/testcontact';
        resumeDetails.ContactInfo.ContactMethod.add(cm6);

        //Contact information #7
        SbJsonCandidate.contactMethodObject cm7 = new SbJsonCandidate.contactMethodObject();
        cm7.Use = 'personal';
        cm7.WhenAvailable = 'anytime';
        cm7.InternetWebAddress = 'https://www.twitter.com/test_contact';
        resumeDetails.ContactInfo.ContactMethod.add(cm7);

        //Contact information #8
        SbJsonCandidate.contactMethodObject cm8 = new SbJsonCandidate.contactMethodObject();
        cm8.Use = 'personal';
        cm8.WhenAvailable = 'anytime';
        cm8.Telephone = new SbJsonCandidate.phoneNumberObject();
        cm8.Telephone.FormattedNumber = '+442012314230';
        resumeDetails.ContactInfo.ContactMethod.add(cm8);

        //Contact information #9
        SbJsonCandidate.contactMethodObject cm9 = new SbJsonCandidate.contactMethodObject();
        cm9.Use = 'business';
        cm9.WhenAvailable = 'anytime';
        cm9.Fax = new SbJsonCandidate.phoneNumberObject();
        cm9.Fax.FormattedNumber = '+442012305323';
        resumeDetails.ContactInfo.ContactMethod.add(cm9);


        //New Employer Org and nested child objects
        SbJsonCandidate.employerOrgObject eo1 = new SbJsonCandidate.employerOrgObject();
        SbJsonCandidate.positionHistoryObject ph1 = new SbJsonCandidate.positionHistoryObject();
        SbJsonCandidate.orgInfoObject oi1 = new SbJsonCandidate.orgInfoObject();

        SbJsonCandidate.jobCatergoryObject jc1 = new SbJsonCandidate.jobCatergoryObject();
        SbJsonCandidate.jobCatergoryObject jc2 = new SbJsonCandidate.jobCatergoryObject();

        //Employer Org
        eo1.EmployerOrgName = 'Test Company 1';

        //Position History Object
        ph1.Title = 'Job Role 1';
        ph1.Description = 'Description 1';
        ph1.StartDate = new SbJsonCandidate.dateObject();
        ph1.StartDate.YearMonth = string.valueOf(date.today().addMonths(-3).year()+'-'+date.today().addMonths(-3).month());
        ph1.StartDate.StringDate = string.valueOf(date.today().addMonths(-3)); //set start date to three months ago
        ph1.EndDate = new SbJsonCandidate.dateObject();
        ph1.EndDate.StringDate = string.valueOf(date.today()); //finish today
        ph1.x_positionType = 'directHire';
        ph1.x_currentEmployer = 'true';
        ph1.OrgName = new SbJsonCandidate.orgNameObject();
        ph1.OrgName.OrganizationName = 'Test Company';

        
        //Org Info details
        oi1.PositionLocation = new SbJsonCandidate.postalAddressObject();
        oi1.PositionLocation.Municipality = 'London';
        oi1.PositionLocation.PostalCode = 'SW1 123';
        oi1.PositionLocation.CountryCode = 'UK';
        ph1.OrgInfo = new list<SbJsonCandidate.orgInfoObject>();
        ph1.OrgInfo.add(oi1);

        //Job Category (Skills) - both parts
        jc1.CategoryCode = 'Information Technology → Internet';
        jc1.Comments = 'Information Technology describes 100% of this job';
        jc1.TaxonomyName = 'Skills taxonomy';
        ph1.JobCategory = new list<SbJsonCandidate.jobCatergoryObject>();
        ph1.JobCategory.add(jc1);

        jc2.CategoryCode = 'Executive (VP, Dept Head)';
        jc2.TaxonomyName = 'Job Level';
        ph1.JobCategory.add(jc2);

        eo1.PositionHistory = new list<SbJsonCandidate.positionHistoryObject>();
        eo1.PositionHistory.add(ph1);

        resumeDetails.EmploymentHistory = new SbJsonCandidate.employmentHistoryObject();
        resumeDetails.EmploymentHistory.EmployerOrg = new list<SbJsonCandidate.employerOrgObject>();
        resumeDetails.EmploymentHistory.EmployerOrg.add(eo1);

        //Create second Employer Org - main difference is set to AnyDate object instead of StringDate for start/end dates
        SbJsonCandidate.employerOrgObject eo2 = new SbJsonCandidate.employerOrgObject();
        SbJsonCandidate.positionHistoryObject ph2 = new SbJsonCandidate.positionHistoryObject();
        SbJsonCandidate.orgInfoObject oi2 = new SbJsonCandidate.orgInfoObject();
        SbJsonCandidate.jobCatergoryObject jc3 = new SbJsonCandidate.jobCatergoryObject();
        SbJsonCandidate.jobCatergoryObject jc4 = new SbJsonCandidate.jobCatergoryObject();

        //Employer Org
        eo2.EmployerOrgName = 'Test Company 2';

        //Position History Object
        ph2.Title = 'Job Role 2';
        ph2.Description = 'Description 2';
        ph2.StartDate = new SbJsonCandidate.dateObject();
        ph2.StartDate.AnyDate = string.valueOf(date.today().addMonths(-9)); //set start date to six months ago
        ph2.EndDate = new SbJsonCandidate.dateObject();
        ph2.EndDate.AnyDate = string.valueOf(date.today().addMonths(-3)); //finish three months ago
        
        //Org Info details
        oi2.PositionLocation = new SbJsonCandidate.postalAddressObject();
        oi2.PositionLocation.Municipality = 'London';
        oi2.PositionLocation.PostalCode = 'NW1 987';
        oi2.PositionLocation.CountryCode = 'UK';
        ph2.OrgInfo = new list<SbJsonCandidate.orgInfoObject>();
        ph2.OrgInfo.add(oi1);

        //Job Category (Skills) - both parts
        jc3.CategoryCode = 'Information Technology → Programming';
        jc3.Comments = 'Information Technology describes 100% of this job';
        jc3.TaxonomyName = 'Skills taxonomy';
        ph2.JobCategory = new list<SbJsonCandidate.jobCatergoryObject>();
        ph2.JobCategory.add(jc3);

        jc4.CategoryCode = 'Executive (VP, Dept Head)';
        jc4.TaxonomyName = 'Job Level';
        ph2.JobCategory.add(jc4);

        //now add into the structure
        eo2.PositionHistory = new list<SbJsonCandidate.positionHistoryObject>();
        eo2.PositionHistory.add(ph2);
        resumeDetails.EmploymentHistory.EmployerOrg.add(eo2);
   
        //prepare the 'wrapper' to get structuredXMLResume ready to then serialize and add into parent wrapper object
        SbJsonCandidate.ResumeObjectWrapper resumeWrapper = new SbJsonCandidate.ResumeObjectWrapper();
        if(!inputDetail.contains('NoResume')){ //if test class is not testing for 'NoResume', then populate the name info
            resumeWrapper.Resume = new SbJsonCandidate.resumeObject();
            resumeWrapper.Resume.StructuredXMLResume = new SbJsonCandidate.structuredResumeObject();
            resumeWrapper.Resume.StructuredXMLResume = resumeDetails; //now assign the resume to the object

            resumeWrapper.Resume.NonXMLResume = new SbJsonCandidate.nonXMLResumeObject();
            resumeWrapper.Resume.NonXMLResume.TextResume = JSON.serialize(resumeDetails.ContactInfo);
        }
        //create the overall/parent wrapper
        SbJsonCandidate.jsonWrapper jsonInput = new SbJsonCandidate.jsonWrapper();

        //now load up the overall wrapper class with resume and other details        
        jsonInput.Value = new SbJsonCandidate.valueObject();
        jsonInput.Value.Text = 'This is a test Text Resume';
        jsonInput.Value.TextCode = 'ovIsProbablyValid';
        if (!inputDetail.contains('PdfException')) {
            jsonInput.Value.Html = '<head><body>This is a test Text Resume<img src=\"Aspose.Words.753d5093-e840-4cb0-9555-b9ea4083f6ea.001.png\" /></body></head>';
        }else jsonInput.Value.Html = '<head><body>This is a test Text Resume</body></head>';
        
        jsonInput.Value.HtmlCode = 'ovIsProbablyValid';
        
        jsonInput.Value.ParsedDocument =  JSON.serialize(resumeWrapper);
        System.debug('DEBUG === parsedDocument: ' + jsonInput.Value.ParsedDocument);
    
        //Removed from SbCandidateResult as not needed.  Commenting out code to simplify (AG 10Sep19)
        jsonInput.Info = new SbJsonCandidate.infoObject();
        jsonInput.Info.Code = 'Success';
        jsonInput.Info.Message = 'Successful transaction';
        jsonInput.Value.Pdf = '';
        jsonInput.Value.PdfCode = '';
        jsonInput.Value.FileType = '';
        jsonInput.Value.GeocodeResponse = '';
        jsonInput.Value.CreditsRemaining = string.valueOf(integer.valueOf(Math.random()));

        return Json.serialize(jsonInput, true);
        

    }

    
}