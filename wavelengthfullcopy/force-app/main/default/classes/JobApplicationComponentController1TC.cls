@isTest
public class JobApplicationComponentController1TC {
    private static AVTRRT__Job__c job;
    private static Contact candidate;
    private static AVTRRT__Job__c job1;
    private static Account account;
    private static List<AVTRRT__Survey_Question__c> surveyQuestions;
    
    private static void initData(Boolean isNewCandidate) {
        
        AVTRRT__Config__c duplicateDetectionRule = new AVTRRT__Config__c(
            AVTRRT__Name__c = 'Duplicates Detection Rule',
            AVTRRT__Value__c = 'LastName = \'{!LastName}\'');
        insert duplicateDetectionRule;
        
        TRGTFCMS__CustomSettingsComponent__c trgtCustomSettings = new TRGTFCMS__CustomSettingsComponent__c(
            Name = 'Default',
            TRGTFCMS__Job_Application_Ajax_Apply_Button__c = false,
            TRGTFCMS__ShowReferencesBlock__c = true,
            TRGTFCMS__IsShowButtonLinkedIn__c = true,
            TRGTFCMS__Job_Application_Resume_Required__c = 'false',
            TRGTFCMS__UploadResumeError__c = 'test',
            TRGTFCMS__PasswordError__c = 'test1',
            TRGTFCMS__ConfirmPasswordError__c = 'test2',
            TRGTFCMS__Safe_Stage_Field_From_JobApplicant__c = false,
            TRGTFCMS__ETCObject_field_source_value_from_Site__c = 'test3',
            TRGTFCMS__Display_thank_you_message_on_new_page__c = false,
            TRGTFCMS__JonApplicantionPageApplicationMsg__c = 'test',
            TRGTFCMS__JobApplicationPageProfileMsg__c = 'testwww',
            TRGTFCMS__JobApplication_UpdateExtendProfile__c = 'false',
            TRGTFCMS__Enable_Questionnaire__c = true
        );
        insert trgtCustomSettings;
        
        FCMS__CustomSettingsComponent__c linkedInSetting = new FCMS__CustomSettingsComponent__c(
            Name = 'Default',
            FCMS__LinkedIn_Redirect_Uri__c = 'https://fcms-developer-edition.ap1.force.com/',
            FCMS__LinkedIn_Client_Id__c = '75n4vp24esl36t',
            FCMS__LinkedIn_Client_Secret__c = 'IRh8mNKxg8RmMwDf',
            FCMS__ErrorsReceiver__c = 'rakesh.r@targetrecruit.net',
            FCMS__SessionTimeout__c = 60
        );
        insert linkedInSetting;
        
        AVTRRT__Config_Settings__c configSetting = new AVTRRT__Config_Settings__c(
            Name = 'Default',
            AVTRRT__Trigger_Disabled_Trigger_JobApplicants__c = true,
            AVTRRT__Trigger_Disabled_Contact__c = true,
            AVTRRT__Trigger_Placement__c = true
        );
        
        
        
        
        insert configSetting;
        
        FCMS__Page__c newPage = new FCMS__Page__c(
            Name = 'CMSDefaultProfilePage',
            FCMS__Name__c = 'CMSDefaultProfilePage',
            FCMS__Active__c = true
        );
        insert newPage;
        
        TRGTFCMS__Indeed_Custom_Setting__c indeedSettings = new TRGTFCMS__Indeed_Custom_Setting__c(
            SetupOwnerId = UserInfo.getOrganizationId(),
            TRGTFCMS__Employer_Email__c = 'test@test.com',
            TRGTFCMS__Enable_Apply_with_Indeed__c = true,
            TRGTFCMS__Indeed_Token__c = 'nbwdfhsdbvfhdsf',
            TRGTFCMS__Indeed_Secret_Key__c = 'qnsjSHBFJDVGBJDFBGJDFBFWED'
        );
        insert indeedSettings;
        
        //  FCMS__Page__c newPage = [SELECT Id FROM FCMS__Page__c WHERE Name = 'CMSDefaultProfilePage'];
        
        account = new Account(Name = 'CMSDefaultProfileAccount',Business_Entity__c='Wavelength International');
        insert account;
        
        FCMS__CMSProfile__c cmsProfile = new FCMS__CMSProfile__c(
            Name = 'Candidate',
            FCMS__Name__c = 'Candidate',
            FCMS__Profile_Manager__c = UserInfo.getUserId(),
            FCMS__Default_Home_Page__c = newPage.Id,
            FCMS__Profile_Account__c = account.Id,
            FCMS__CMSCss__c = 'CMSCssCustom1',
            FCMS__Portal_Enabled__c = true,
            FCMS__User_Registration__c = true
        );
        insert cmsProfile;
        
        //  FCMS__CMSProfile__c cmsProfile = [SELECT Id FROM FCMS__CMSProfile__c WHERE Name = 'Candidate'];
        
        /*CustomSettingsComponent__c customSettings = new CustomSettingsComponent__c(
Name ='Default',
ShowReferencesBlock__c = false,
Job_Application_Resume_Required__c = 'true' );
insert customSettings;*/
        
        /*insert new FCMS__CustomSettingsComponent__c(
Name = 'Default',
FCMS__SessionTimeout__c = 60,
FCMS__ErrorsReceiver__c = 'email@email.com');*/
        
        job = new AVTRRT__Job__c(
            AVTRRT__Job_Title__c = 'Test job1235',
            AVTRRT__Start_Date__c = Date.today(),
            AVTRRT__DealSheet_Hours_Per_Day__c = 10,
            AVTRRT__Deal_Sheet_Hours_Per_Week__c = 50,
            Business_Entity__c='Wavelength International'
        );
        insert job;
        
        job1 = new AVTRRT__Job__c(
            AVTRRT__Job_Title__c = 'Test job 4565',
            AVTRRT__Start_Date__c = Date.today(),
            AVTRRT__DealSheet_Hours_Per_Day__c = 10,
            AVTRRT__Deal_Sheet_Hours_Per_Week__c = 50,
            Business_Entity__c='Wavelength International'
        );
        insert job1;
        
        system.debug('@@@job@@@ '+ job +'@@'+ job1);
        
        PageReference pageRef = new PageReference('apex/JobApplicationPage?/');
        Test.setCurrentPageReference(pageRef);
        
        candidate = new Contact(
            LastName = 'Test123655',
            FirstName = 'Test1236555',
            Email = 'test12675@test.com',
            Phone = '111156',
            FCMS__CMSProfile__c = cmsProfile.Id,
            AVTRRT__Source__c = 'Blog',
            Business_Entity__c='Wavelength International',
            RecordTypeId = AVTRRT.RecordTypeUtilNew.getCandidateRecordTypeIdList()[0]
        );
        insert candidate;
        
        Contact refCont = new Contact(
            LastName = 'test1F5',
            FirstName = 'test2F5',
            Email = 'test2G5@test.com',
            FCMS__CMSProfile__c = cmsProfile.Id,
            AVTRRT__Source__c = 'Blog',
            AVTRRT__Phone__c = '9999009958',
             Business_Entity__c='Wavelength International',
            RecordTypeId = AVTRRT.RecordTypeUtilNew.getCandidateRecordTypeIdList()[0]
        );
        insert refCont;
        
        if (!isNewCandidate) {
            String sessionId = '62486944141904';
            Map<String, String> headerMap = System.currentPageReference().getHeaders();
            
            FCMS__Session__c session = new FCMS__Session__c(
                FCMS__Is_Valid__c = true,
                FCMS__IP_Address__c = headerMap.get('X-Salesforce-SIP'),
                FCMS__Session_For__c = candidate.Id,
                FCMS__User_Agent__c = headerMap.get('User-Agent'),
                FCMS__SessionId__c = sessionId
            );
            insert session;
            
            ApexPages.currentPage().getParameters().put('sessionId', sessionId);
            Cookie cookie = new Cookie(ApexPages.currentPage().getParameters().get('sessionId'), ApexPages.currentPage().getParameters().get('sessionId'), null, -1, false);
            ApexPages.currentPage().setCookies(new Cookie[] {cookie});
            
        }
        
        ApexPages.currentPage().getParameters().put('jobIds', job.Id + ';' + job1.Id);
        ApexPages.currentPage().getParameters().put('p', 'Candidate');
        ApexPages.currentPage().getParameters().put('jobSite', 'Default');
    }
     
    static testMethod void testJobApplicationComponentController1_newCandidate() {
        
        initData(true);
        
        
        AVTRRT__Talent_Plus_Config__c tpConfig = new AVTRRT__Talent_Plus_Config__c();
        
        tpConfig.AVTRRT__Enable_Talent_Plus__c = true;
        
        insert tpConfig;
        
        //References
        List<AVTRRT__References__c> referenceList = new List<AVTRRT__References__c>();
        AVTRRT__References__c reference = new AVTRRT__References__c();
        reference.AVTRRT__First_Name__c = 'test';
        reference.AVTRRT__Last_Name__c = 'test';
        reference.AVTRRT__Email__c = 'test@test.com';
        reference.AVTRRT__Phone__c = '999999999';
        reference.AVTRRT__Notes__c = 'test';
        referenceList.add(reference);
        
        surveyQuestions = new List<AVTRRT__Survey_Question__c>();
        
        System.debug('survey Questions:' + surveyQuestions);
        surveyQuestions.add(new AVTRRT__Survey_Question__c(
            Name = 'Testing Question 05',
            AVTRRT__Job__c = job.Id,
            AVTRRT__Type__c = 'Multi Select Vertical',
            AVTRRT__Choices__c = 'one\ntwo\nthree\n',
            AVTRRT__Question__c = 'Testing Question question 0',
            AVTRRT__OrderNumber__c = 0,
            AVTRRT__Required__c = true));
        
        surveyQuestions.add(new AVTRRT__Survey_Question__c(
            Name = 'Testing Question 15',
            AVTRRT__Job__c = job1.Id,
            AVTRRT__Type__c = 'Multi Select Vertical',
            AVTRRT__Choices__c = 'one\ntwo\nthree\n',
            AVTRRT__Question__c = 'Testing Question question 1',
            AVTRRT__OrderNumber__c = 1,
            AVTRRT__Required__c = true));
        
        insert surveyQuestions;
        
        Test.startTest();
        
        JobApplicationComponentController1 con1 = new JobApplicationComponentController1();
        con1.init();
        
        con1.referencesLoginList = referenceList;
        con1.referencesNoLoginList = referenceList;
        System.assertEquals(0, con1.getJobAppliedForList().size());
        System.assertEquals(job.Id, con1.getJobApplyingForList()[0].Id);
        
        con1.setPassword('TTThelloTT');
        con1.confirmPassword = 'TTThelloTT';
        
        Attachment attachment2 = con1.getAttachment();
        attachment2.Name = 'Resume.doc';
        attachment2.Body = Blob.valueOf('myString');
        attachment2.ParentId = candidate.Id;
        con1.setAttachmentName('resume.pdf');
        con1.setAttachment(attachment2);
        
        con1.getCmsCssCustom();
        con1.getSuccessMSG();
        con1.getAttachmentName();
        con1.getPageURL();
        
        con1.getJobList();
        
        con1.setContact(candidate);
        Contact cont = con1.getContact();
        cont = con1.getContactObject();
        //con1.setErrorMessage(false);
        con1.getErrorMessage();
        con1.setReApplyMessage(false);
        con1.getReApplyMessage();
        con1.setSuccessMessage(false);
        con1.getSuccessMessage();
        con1.getNumberOfJobs();
        con1.setPaste(false);
        con1.getPaste();
        con1.setUpload(true);
        con1.getUpload();
        con1.getNoJobSelected();
        con1.getIsFileError();
        con1.linkedInButtonBlockIsShow = true;
        PageReference result = con1.displayMessage();
      // con1.deleteStudent();
      //  con1.editStudent();
        //con1.getJobIDsWithQuestionnaire();
         
        con1.save();
         
        
        List<AVTRRT__Job_Applicant__c> jobApplicationList = [
            SELECT Id
            FROM AVTRRT__Job_Applicant__c
        ];
        System.debug('!!!!!!!!!!!!!!jobApplicationList=' + jobApplicationList.size());
        delete jobApplicationList;
        con1.reset();
        
        JobApplicationComponentController1 con = new JobApplicationComponentController1();
        con.init();
        con.setPassword('ThelloTT');
        con.getPassword();
        con.confirmPassword = 'ThelloT';
        String str = con.confirmPassword;
        
        Attachment attachment1 = con.getAttachment();
        attachment1.Name = 'Resume.doc';
        attachment1.Body = Blob.valueOf('myString');
        attachment1.ParentId = candidate.Id;
        con.setAttachmentName('ddd.doc');
        con.setAttachment(attachment1);
        
        attachment1 = con.getSecondAttachment();
        con.setSecondAttachment(attachment1);
        attachment1 = con.getThirdAttachment();
        con.setThirdAttachment(attachment1);
        attachment1 = con.getCoverLetterAttachment();
        con.setCoverLetterAttachment(attachment1);
        con.getResumeRequirement();
        
        con.newContactId = candidate.Id;
        con.updateWithAttachment();
        con.resumeErrorMessage();
        con.displayErrorMessage();
        //con.displayExcMessage();
        con.passwordErrorMessage();
        
        JobApplicationComponentController1.AdditionalParameters addlParam = new JobApplicationComponentController1.AdditionalParameters();
        addlParam.account = '';
        addlParam.confirmPassword = 'test';
        addlParam.jobIds = job.Id;
        addlParam.jobSite = 'Default';
        addlParam.profile = 'Candidate';
        addlParam.page = 'JobApplicationPage';
        addlParam.realContactId = null;
        JobApplicationComponentController1.saveNewContact(candidate, new List<AVTRRT__References__c>(), addlParam);
        
        
        
        /*        QuickApplicationComponentController con2 = new QuickApplicationComponentController();
con2.init();
con2.setPassword('TTThelloTT');
con2.confirmPassword = 'TTThelloTT';
con2.setContact(candidate);

Attachment attachment4 = con2.getAttachment();
attachment4.Name = 'Resume.doc';
attachment4.Body = Blob.valueOf('myString');
attachment4.ParentId = candidate.Id;
con2.setAttachmentName('ddd.doc');
con2.setAttachment(attachment4);

attachment4 = con2.getSecondAttachment();
con2.setSecondAttachment(attachment4);
attachment4 = con2.getThirdAttachment();
con2.setThirdAttachment(attachment4);
attachment4 = con2.getCoverLetterAttachment();
con2.setCoverLetterAttachment(attachment4);

con2.getResumeRequirement();

con2.save();
con2.saveContact();
con2.applyingFor = false;
con2.appliedFor = true;
con2.applyButton = true;
con2.linkedinParamsList = new List<String> {'test'};
con2.page = '';
con2.excMsg = '';
con2.applyNow();
con2.getMetaKeywords();
JobApplicationComponentController1.tstJobApplication();
con2.setErrorMessage(true);
con2.duplicateErrorMessage();
con2.displayExcMessage();
con2.prepareJobApplicants();

con2.getContactObject();
con2.getCmsCssCustom();
con2.getSuccessMSG();
con2.getAttachmentName();
con2.getPageURL();
con2.reset();
con2.resumeErrorMessage();
con2.displayErrorMessage();
con2.passwordErrorMessage();
con2.getJobApplyingForList();
con2.getJobAppliedForList();
con2.getJobList();
con2.getContact();
con2.getNumberOfJobs();
con2.getSuccessMessage();
con2.setSuccessMessage(true);

con2.getPassword();
con2.getReApplyMessage();
con2.setReApplyMessage(false);
con2.getErrorMessage();
con2.getNoJobSelected();
con2.getNoJobSelected();
con2.getPaste();
con2.setPaste(false);
con2.getUpload();
con2.setUpload(true);
con2.getIsFileError();

con2.testcoverage();

string p ='password';
QuickApplicationComponentController.tstJobApplication();
QuickApplicationComponentController.encryptCmsPassword(p);
QuickApplicationComponentController.getAesKey();

QuickApplicationComponentController.AdditionalParameters addlParamnew = new QuickApplicationComponentController.AdditionalParameters();
addlParamnew.account = '';
addlParamnew.confirmPassword = 'test';
addlParamnew.jobIds = job.Id;
addlParamnew.jobSite = 'Default';
addlParamnew.profile = 'Candidate';
addlParamnew.page = 'JobApplicationPage';
addlParamnew.realContactId = null;

QuickApplicationComponentController.saveNewContact(candidate, referenceList, addlParamnew);

*/      
        Test.stopTest();
    }
    
    static testMethod void testJobApplicationComponentController1_updateCandidate() {
        
        initData(false);
        AVTRRT__Talent_Plus_Config__c tpConfig = new AVTRRT__Talent_Plus_Config__c();
        
        tpConfig.AVTRRT__Enable_Talent_Plus__c = true;
        
        insert tpConfig;
        // ApexPages.currentPage().getParameters().put('jobIds', null);
        //added by Rakesh
        FCMS__CMSProfile__c cmsProfile = [
            SELECT Id
            FROM FCMS__CMSProfile__c
            WHERE Name = 'Candidate'
        ];
        Contact newCandidate = new Contact(
            LastName = 'Test123op5',
            FirstName = 'Test123op5',
            Email = 'test125op3@test.com',
            Phone = '11871',
            FCMS__CMSProfile__c = cmsProfile.Id,
            AVTRRT__Source__c = 'Blog',
            Business_Entity__c = 'Ccentric',
            RecordTypeId = AVTRRT.RecordTypeUtilNew.getCandidateRecordTypeIdList()[0]
        );
        
        AVTRRT__Employment_History__c empHis = new AVTRRT__Employment_History__c();
       
        empHis.AVTRRT__Candidate__c = candidate.Id;
        empHis.AVTRRT__EmployerOrgName__c = 'TRTest';
       // empHis.From__c = System.today();
        //empHis.To__c = system.today();
        empHis.AVTRRT__City__c = 'Vancouver';
        empHis.AVTRRT__StateProvince__c = 'WA';
        empHis.AVTRRT__Position_Title__c = 'PSG';
        empHis.AVTRRT__Position_Type__c = 'PSG';
        
        insert empHis;
        
        AVTRRT__Employment_History__c empHisGap = new AVTRRT__Employment_History__c();
        //empHisGap.Gap_Reason__c = 'TBD';
        empHisGap.AVTRRT__Candidate__c = candidate.Id;
       
        insert empHisGap;
        
        Test.startTest();
        
        Attachment attach = new Attachment(
            Name = 'Resume.doc',
            Body = Blob.valueOf('myString'),
            ParentId = candidate.Id
        );
        insert attach;
        
        JobApplicationComponentController1 con1 = new JobApplicationComponentController1();
        
        con1.init();
        con1.setPassword('TTThelloTT');
        con1.confirmPassword = 'TTThelloTT';
        con1.setContact(newCandidate);
        
        Attachment attachment1 = con1.getAttachment();
        attachment1.Name = 'Resume.doc';
        attachment1.Body = Blob.valueOf('myString');
        attachment1.ParentId = candidate.Id;
        con1.setAttachmentName('ddd.doc');
        con1.setAttachment(attachment1);
        
        attachment1 = con1.getSecondAttachment();
        con1.setSecondAttachment(attachment1);
        attachment1 = con1.getThirdAttachment();
        con1.setThirdAttachment(attachment1);
        attachment1 = con1.getCoverLetterAttachment();
        con1.setCoverLetterAttachment(attachment1);
        
      //  con1.getResumeRequirement();
        
        con1.save();
        con1.saveContact();
        con1.applyingFor = false;
        con1.appliedFor = true;
        con1.applyButton = true;
        con1.linkedinParamsList = new List<String> {'test'};
            con1.page = '';
        con1.excMsg = '';
        con1.applyNow();
        con1.getMetaKeywords();
        JobApplicationComponentController1.tstJobApplication();
        con1.setErrorMessage(true);
        con1.duplicateErrorMessage();
        con1.displayExcMessage();
      //  con1.prepareJobApplicants();
        //  con1.displayMessage();  
        //con1.insertReferences();
        con1.loadEmpData();
        //con1.editEmployment();
        //con1.editEmploymentGap();
        //con1.saveEdu();
        //con1.saveEmployment();
        
        //con1.addNewEmployment();
       // con1.addNewEducation();
        //con1.addNewEmploymentGap();
        //con1.cancelEmp();
       // con1.cancelEmpGap();
        con1.codeCoverage();
        try{
           con1.deleteReference();
        }catch(exception e){
            
        }
         con1.editReference();
        try{
           con1.saveReference();
        }catch(exception e){
            
        }
         try{
           con1.cancelReference();
        }catch(exception e){
            
        }
        
        
        
        
        ApexPages.currentPage().getParameters().put('jobIds', null);
      //  con1.updateWithAttachment();
        /*con1.deleteEducation(); 
        con1.deleteEmpGap();
        con1.saveEmploymentGap();*/
        //con1.cancelEdu(); 
       // con1.editStudent();
      //  con1.editReference();
        List<AVTRRT__Job_Applicant__c> jobApplicationList = [
            SELECT Id
            FROM AVTRRT__Job_Applicant__c
        ];
        System.debug('!!!!!!!!!!!!!!jobApplicationList=' + jobApplicationList.size());
        
        CRDNTLS__CredentialQuestion__c cddd= new CRDNTLS__CredentialQuestion__c();
        cddd.CRDNTLS__Question__c = 'Sid';
        insert cddd;
        
        AVTRRT__Candidate_Presentation__c cs = new AVTRRT__Candidate_Presentation__c();
        
        
        
        insert cs;
        
        CRDNTLS__CredentialsCustomSettings__c crd = new CRDNTLS__CredentialsCustomSettings__c();
        crd.Name = 'Default';
        crd.CRDNTLS__Disable_CredentialsAnswerTrigger__c = true;
        insert crd;
        
        /*ApexPages.currentPage().getParameters().put('CanId',candidate.id);

DisclaimerController cd =new DisclaimerController();
cd.init();
cd.save();
cd.save();*/
        
        delete jobApplicationList;
        
        ApexPages.currentPage().getParameters().put('id',candidate.id);
        ApexPages.currentPage().getParameters().put('signedDate',system.today().format());
      //  DeclarationPageController dec = new DeclarationPageController(); 
   //     candidate.Date_signed__c = system.today();
     //   DeslarationAttachmentCreaterClass dec1 = new DeslarationAttachmentCreaterClass();
    //    dec1.attachDesclaimer(candidate, candidate);
       
        

        
        Test.stopTest();
    }
}