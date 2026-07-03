@isTest
public class Test_DynamicUrl {

    @TestSetup
    static void setupTestData(){
        Account acc1 = TestDataFactory.createCandidateAccount(1)[0];
        insert acc1;
        TestDataFactory.setupCustomSettings(acc1.Id);
        TestDataFactory.setupUserProfileCustomSettings();

        User baConsutant = [SELECT Id FROM User WHERE Brand__c = 'Blue Arrow' LIMIT 1];
        User tateConsutant = [SELECT Id FROM User WHERE Brand__c = 'Tate' LIMIT 1];

        List<Contact> candidates = TestDataFactory.createCandidate(acc1.Id,2);
        candidates[0].IP_CategoryOfWork__c='Catering';
        candidates[0].OwnerId = tateConsutant.Id;
        candidates[1].IP_CategoryOfWork__c='Catering';

        Contact con = new Contact(AccountID = acc1.Id, 
                RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId(), //condRec.id,
                FirstName ='Manish',
                Salutation ='Mr',
                MailingCity='ggn',
                MailingCountry='india',
                MailingPostalCode='110092',
                MailingState='Haryana',
                LastName ='candidate',
                sirenum__National_Insurance__c='AA323232A',
                IP_CandidateIDlegacy__c='dsdsdsdd',
                MailingStreet='abc',
                P45_Requested__c=true,
                PayrollLeaver__c=null,
                Title = 'TestLastName',
                Initials__c = 'TestLastName',
                Birthdate = Date.valueOf('1990-02-20'),
                Phone = '9879879877',
                IP_WorkerStartDate__c=Date.valueOf('2017-02-20'),
                EEO_Gender__c = 'M',
                IP_CategoryOfWork__c='Catering',
                IP_ThirdPartyID__c='testpay12',
                IP_IsInvoicecontact__c=true,
                OwnerId=baConsutant.Id
        );
        candidates.add(con);
        insert candidates;

        List<Form__c> forms = new List<Form__c>();
        Form__c js0 = new Form__c();
        js0.Title__c = 'Blue Arrow - New Starter Form';
        forms.add(js0);
        Form__c js1 = new Form__c();
        js1.Title__c = 'Blue Arrow - Medical Form';
        forms.add(js1);
        Form__c js2 = new Form__c();
        js2.Title__c = 'Blue Arrow Terms of Employment';
        forms.add(js2);
        Form__c js3 = new Form__c();
        js3.Title__c = 'Conditions of Business for the Supply of Flexible Workers';
        forms.add(js3);
        Form__c js4 = new Form__c();
        js4.Title__c = 'Conditions of Business for the Supply of Permanent and Fixed Term Workers';
        forms.add(js4);
        Form__c js5 = new Form__c();
        js5.Title__c = 'Blue Arrow Equal Opportunities Questionnaire';
        forms.add(js5);
        Form__c js6 = new Form__c();
        js6.Title__c = 'Permanent Work Seekers Consent Form';
        forms.add(js6);
        Form__c js7 = new Form__c();
        js7.Title__c = 'Blue Arrow - Study Timetable';
        forms.add(js7);
        Form__c js8 = new Form__c();
        js8.Title__c = 'Bank Details Form (PAYE)';
        forms.add(js8);
        Form__c js9 = new Form__c();
        js9.Title__c = 'Blue Arrow Referee Request';
        forms.add(js9);
        Form__c js10 = new Form__c();
        js10.Title__c = 'Blue Arrow - Right To Work';
        forms.add(js10);
        Form__c js11 = new Form__c();
        js11.Title__c = 'Blue Arrow Declarations';
        forms.add(js11);
        Form__c js12 = new Form__c();
        js12.Title__c = 'Blue Arrow - Working Time Regulation';
        forms.add(js12);
        Form__c js12a = new Form__c();
        js12a.Title__c = 'Tate - Working Time Regulation';
        forms.add(js12a);
        Form__c js13 = new Form__c();
        js13.Title__c = 'Driver Declaration of Hours worked at Registration';
        forms.add(js13);
        Form__c js14 = new Form__c();
        js14.Title__c = 'Driving Licence';
        forms.add(js14);
        Form__c js15 = new Form__c();
        js15.Title__c = 'Blue Arrow - Reference';
        forms.add(js15);
        Form__c js15t = new Form__c();
        js15t.Title__c = 'Tate - Reference';
        forms.add(js15t);
        Form__c js16 = new Form__c();
        js16.Title__c = 'Data Protection Consent Form';
        forms.add(js16);
        Form__c js17 = new Form__c();
        js17.Title__c = 'Fair Employment Monitoring Questionnaire';
        forms.add(js17);
        insert forms;

    }

    @isTest
    static void testAllLinks(){
        Contact con; 
        Contact conTate; //= [SELECT Id, FirstName, LastName, Email FROM Contact WHERE RecordType.Name = 'Candidate' AND Brand__c = 'Tate' LIMIT 1];
        Contact noBrandCon;
        for(Contact c : [SELECT Id, FirstName, LastName, Email, Brand__c FROM Contact WHERE RecordType.Name = 'Candidate']){
            if(c.Brand__c == 'Blue Arrow'){
                con = c;
            } else if(c.Brand__c == 'Tate') {
                conTate = c;
            } else {
                noBrandCon = c;
            }
        }

        DynamicUrl dm = new DynamicUrl();
        dm.record_Id = con.id;
        dm.FullMedical  = dm.generateMedicalURL();
        dm.NSD = dm.generateNSDURL();
        dm.TOEURL = dm.generateTOEURL();
        dm.TempCOBURL  = dm.generateTempCOBURL();
        dm.PermCOBURL = dm.generatePermCOBURL();
        dm.EOQ = dm.generateEOQURL();
        dm.ConsentFormURL = dm.generateConsentFormURL();
        dm.StudyTimeTable = dm.generatetimetable();
        dm.BankDetailsURL = dm.generateBankDetailsURL();
        dm.RefereeRequest = dm.generateRefereeRequestURL();
        dm.RightToWork = dm.generateRightToWorkURL();
        dm.Decalartion = dm.generateDecURL();
        dm.WTRURL = dm.generateWTRURL();
        dm.DriverDecURL = dm.generateDriverDecURL();
        dm.DriverLicense = dm.generateDriverLicenseURL();
        dm.Ref = dm.generateReferenceURL();
        dm.DataConsent = dm.generateDataConsentURL();
        dm.FairEmploymentMonitoringQuestionnaire = dm.generateFairEmploymentQuestionnaireURL();

        dm.record_Id = conTate.Id;
        dm.Ref = dm.generateBankDetailsURL();

        Reinstatedtemplatedata rmt = new Reinstatedtemplatedata();
        RefereeRequest_Controller rrt = new RefereeRequest_Controller();

        DynamicUrl dm1 = new DynamicUrl(rmt);
        DynamicUrl dm2 = new DynamicUrl(rrt);

        FairEmploymentQuestionnaireController controller = new FairEmploymentQuestionnaireController();
        DynamicUrl dm3 = new DynamicUrl(controller);
    }
}