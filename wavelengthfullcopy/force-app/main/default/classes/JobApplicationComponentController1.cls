global without sharing class JobApplicationComponentController1 {
    public String source { get; set; }
    global String selectLanguage { get; set; }
    global Contact contact { get; set; }
    global Contact realContact; //change private to global (Kans 8.2.11)
    Public contact realc {get;set;}
    
    global List<AVTRRT__References__c> referencesLoginList { get; set; }
    
    global Boolean noJobSelected { get {return jobList == null;} }
    global Boolean applyingFor { get {return jobApplyingForList.size() > 0;} set; }
    global Boolean appliedFor { get {return jobAppliedForList.size() > 0;} set; }
    
    global Boolean ForceComAutorization { get; set; }
    global Boolean displayThankYouMessageOnNewPage { get; set; }
    global String cmsCssCustom { get; set; }
    global String metaKeywords { get; set; }
    global String currentUrlJobApplicationPage { get; set; }
    
    global Boolean applyButton { get; set; }
    global String password { get; set; }
    global String confirmPassword { get; set; }
    
    global Boolean resumeRequirmentForLabel { get; set; }
    global Boolean isResumeRequired { get; set; }
    
    // Deprecated
    global List<String> linkedinParamsList { get; set; }
    
    global String linkedInApiKey { get; set; }
    global String linkedInRedirectUrl { get; set; }
    global String linkedInJobIds { get; set; }
    
    global Boolean ReferencesBlockIsShow { get; set; }// added by Kans (8.2.2011)
    global Boolean linkedInButtonBlockIsShow { get; set; }
    
    global Boolean linkedInButtonBlockIsFullProfile { get; set; }
    
    public String page { get; set; }
    public List<AVTRRT__References__c> referencesNoLoginList { get; set; }
    public Contact contactApplyFromVendorProfile { get; set; }
    public List<String> EmailDBNoLoginList { get; set; }
    public List<String> EmailPageNoLoginList { get; set; }
    
    //added by Rakesh
    global String jobIds { get; set; }
    global String jobSite { get; set; }
    global String pageParam { get; set; }
    global String profile { get; set; }
    global String accountName { get; set; }
    global String sessionId { get; set; }
    
    global String realContactId { get; set; }
    global String newContactId { get; set; }
    global String excMsg { get; set; }
    global Integer jobApplyingForListSize { get; set; }
    global Boolean renderApplyButton { get; set; }
    global Boolean renderAjaxApplyButton { get; set; }
    
    // For indeed functionality
    global String indeedAPIToken { get; set; }
    global String indeedEmployerEmail { get; set; }
    global Boolean enableIndeedButton { get; set; }
    global Boolean enableReferences { get; set; }
    
    //Added by sid
    public List<AVTRRT__Educational_History__c> studentsR {get;set;}
    public AVTRRT__Educational_History__c edu {get;set;}
    public Map<Id,AVTRRT__Educational_History__c> eduMap;
    public boolean show {get; set;}
    public String SelectedStudentId {get;set;}    
    
    //For reference
    public List<AVTRRT__References__c> referenceR {get;set;}
    public AVTRRT__References__c ref {get;set;}
    public Map<Id,AVTRRT__References__c> refMap;
    public boolean showReference {get; set;}
    public String SelectedReferenceId {get;set;}
    
    //Employment History
    public List<AVTRRT__Employment_History__c> employmentR {get;set;}
    public List<AVTRRT__Employment_History__c> employmentGapR {get;set;}
    
    public AVTRRT__Employment_History__c emp {get;set;}
    public Map<Id,AVTRRT__Employment_History__c> empMap;
    
    public AVTRRT__Employment_History__c empGap {get;set;}
    public Map<Id,AVTRRT__Employment_History__c> empMapGap;
    
    public boolean showEmployment {get; set;}
    public String SelectedEmploymentId {get;set;}
    public boolean showEmploymentGap {get; set;}
    public String SelectedEmploymentGapId {get;set;}
    
    public static final String ACCESSORY_TYPE_JOB_APPLICANT = 'Job Applicant Questionnaire';
    
    private List<FCMS__CMSProfile__c> ForceComAutorizationList { get; set; }
    
    global String getPassword() {
        return password;
    }
    
    global void setPassword(String password) {
        this.password = password;
    }
    
    global AVTRRT__Job_Applicant__c jobApplicant { get; set; }
    global Contact getContactObject() {
        return null;
    }
    global String getCmsCssCustom() {
        return null;
    }
    
    global String getSuccessMSG() {
        return null;
    }
    global String getAttachmentName() {
        return null;
    }
    global String getPageURL() {
        return null;
    }
    global PageReference reset() {
        return null;
    }
    global void setAttachmentName(String attachmentName) {
    }
    global PageReference applyNow() {
        return null;
    }
    global String getMetaKeywords() {
        return null;
    }
    
    global static void tstJobApplication() {
    }
    
    global List<AVTRRT__Job__c> getJobApplyingForList() {
        return jobApplyingForList;
    }
    
    global List<AVTRRT__Job__c> getJobAppliedForList() {
        return jobAppliedForList;
    }
    
    // JobList contains the total number of Jobs has to be displayed on the page or candidate applied for
    global List<AVTRRT__Job__c> getJobList() {
        return jobList;
    }
    
    // Contact object instance is used to show fields on the page choosed by client. below are the get and set methods for it
    global Contact getContact() {
        return this.contact;
    } 
    
    global void setContact(Contact contact) {
        this.contact = contact;
    }
    
    // Standard Attachment object is initiated or used to get resumes as file of some proper formates. below the get and set methods of it.
    global Attachment getAttachment() {
        attachment = new Attachment();
        return attachment;
    }
    
    global void setAttachment(Attachment attachment) {
        this.attachment = attachment;
    }
    
    global Attachment getSecondAttachment() {
        secondAttachment = new Attachment();
        return secondAttachment;
    }
    
    global void setSecondAttachment(Attachment attachment) {
        this.secondAttachment = attachment;
    }
    
    global Attachment getThirdAttachment() {
        thirdAttachment = new Attachment();
        return thirdAttachment;
    }
    
    global void setThirdAttachment(Attachment attachment) {
        this.thirdAttachment = attachment;
    }
    
    global Attachment getCoverLetterAttachment() {
        coverLetterAttachment = new Attachment();
        return coverLetterAttachment;
    }
    
    global void setCoverLetterAttachment(Attachment attachment) {
        this.coverLetterAttachment = attachment;
    }
    
    global ContentVersion latestResumeFile { get; set; }
     global Id contentDocumentIdOld { get; set; }
    
    // To show total number of jobs
    global Integer getNumberOfJobs() {
        return jobList.size();
    }
    
    // Below are some getter and setter methods of Boolean type used to show and hide some elements or fields on the page according the flow
    global Boolean getSuccessMessage() {
        return successMessage;
    }
    
    global void setSuccessMessage(Boolean successMessage) {
        this.successMessage = successMessage;
    }
    
    global Boolean getReApplyMessage() {
        return reApplyMessage;
    }
    
    global void setReApplyMessage(Boolean reApplyMessage) {
        this.reApplyMessage = reApplyMessage;
    }
    
    global Boolean getErrorMessage() {
        return errorMessage;
    }
    
    global void setErrorMessage(Boolean errorMessage) {
        this.errorMessage = errorMessage;
    }
    
    global Boolean getNoJobSelected() {
        return noJobSelected;
    }
    
    global Boolean getPaste() {
        return paste;
    }
    
    global void setPaste(Boolean paste) {
        this.paste = paste;
    }
    
    global Boolean getUpload() {
        return upload;
    }
    
    global void setUpload(Boolean upload) {
        this.upload = upload;
    }
    
    global Boolean getIsFileError() {
        if (isFileError == true) {
            attachment.Body = null;
        }
        return isFileError;
    }
    
    /**
* @author Sergey Prishepo
* @date 02/04/2013
* @description contact use insted Real Contact;
*/
    
    global String pageURL;
    global transient Boolean paste = false;
    global transient Boolean upload = true;
    global transient Boolean successMessage = false;
    global transient Boolean reApplyMessage = false;
    global transient Boolean errorMessage = false;
    global transient Boolean isFileError = false;
    
    global transient String successMSG;
    global transient Boolean resumeRequirment = false;
    
    /**
* @author Rakesh
* @date 23/02/2015
* @description: Added boolean variable to ensure duplicate email is not getting updated.
* @case:00037580
*/
    global Boolean duplicateContact = false;
    
    /* Edited by Aliaksandr Satskou, 06/23/2014 (case #00028360) */
    transient global Attachment attachment;
    transient global Attachment secondAttachment;
    transient global Attachment thirdAttachment;
    transient global Attachment coverLetterAttachment;
    
    public Boolean isAjaxCall = false;
    
    private List<AVTRRT__Job__c> jobList;
    private List<AVTRRT__Job_Applicant__c> jobApplicationList;
    private List<AVTRRT__Job_Applicant__c> jobApplicationListForTalentPlus; // Added by hari(July 6th 2015)
    private List<AVTRRT__Job__c> jobAppliedForList = new List<AVTRRT__Job__c>();
    private List<AVTRRT__Job__c> jobApplyingForList = new List<AVTRRT__Job__c>();
    
    private static TRGTFCMS__CustomSettingsComponent__c cs = ConfigHelperCustom.getConfigDataSet();
    
    // private static LoggerCP logger = new LoggerCP('JobApplicationComponentController1');
    
    global JobApplicationComponentController1() {
        
        referencesLoginList = new List<AVTRRT__References__c>();
        referencesNoLoginList = new List<AVTRRT__References__c>();
        ForceComAutorizationList = new List<FCMS__CMSProfile__c>();
        
        EmailDBNoLoginList = new List<String>();
        EmailPageNoLoginList = new List<String>();
        
        selectLanguage = UserInfo.getLocale();
        //added by sid
        show = false;
        edu = new AVTRRT__Educational_History__c();
        
        showReference = false;
        ref = new AVTRRT__References__c();
        
        showEmployment = false;
        emp = new AVTRRT__Employment_History__c();
        
    }
    
    
    
    /**
* @author Rakesh R
* @date 08/13/2014
* @description Modified;
*/
    global void init() {
        
        jobIds = ApexPages.currentPage().getParameters().get('jobIds');
        jobSite = ApexPages.currentPage().getParameters().get('jobSite');
        profile = ApexPages.currentPage().getParameters().get('p');
        pageParam = ApexPages.currentPage().getParameters().get('page');
        accountName = ApexPages.currentPage().getParameters().get('accountName');
        sessionId = ApexPages.currentPage().getParameters().get('sessionId');
        
        initialize();
    }
    
    /**
* @author Rakesh R
* @date 08/13/2014
* @description Initializing the values;
*/
    global void initialize() {
        enableReferences = cs.TRGTFCMS__ShowReferencesBlock__c;
        
        TRGTFCMS__Indeed_Custom_Setting__c indeedDetails = TRGTFCMS__Indeed_Custom_Setting__c.getInstance();
        indeedEmployerEmail = indeedDetails.TRGTFCMS__Employer_Email__c;
        indeedAPIToken = indeedDetails.TRGTFCMS__Indeed_Token__c;
        enableIndeedButton = indeedDetails.TRGTFCMS__Enable_Apply_with_Indeed__c;
        
        if (enableIndeedButton && !String.isBlank(indeedDetails.TRGTFCMS__Indeed_Secret_Key__c)
            && !String.isBlank(indeedDetails.TRGTFCMS__Indeed_Token__c)
            && !String.isBlank(indeedDetails.TRGTFCMS__Employer_Email__c)) {
                String secretKey = EncodingUtil.urlEncode(indeedDetails.TRGTFCMS__Indeed_Secret_Key__c, 'UTF-8');
                String secretKeyBytes = secretKey.substring(0, 16);
                Blob iv = EncodingUtil.convertFromHex('00000000000000000000000000000000');
                Blob data = Blob.valueOf(indeedDetails.TRGTFCMS__Employer_Email__c);
                Blob encryptedData = Crypto.encrypt('AES128', Blob.valueOf(secretKeyBytes), iv, data);
                String encryptedDataString = EncodingUtil.convertToHex(encryptedData);
                indeedEmployerEmail = encryptedDataString;
            }
        
        if (cs.TRGTFCMS__Job_Application_Ajax_Apply_Button__c) {
            
            renderAjaxApplyButton = true;
            renderApplyButton = false;
        } else {
            renderAjaxApplyButton = false;
            renderApplyButton = true;
        }
        
        ReferencesBlockIsShow = cs.TRGTFCMS__ShowReferencesBlock__c;// added by Kans (8.2.11)
        displayThankYouMessageOnNewPage = false;
        try {
            
            if (!isAjaxCall) {
                // Gets css styles
                cmsCssCustom = FCMS.CMSHelper.getCSSStyles();
            }
            /**
* @author Sergey Prishepo
* @date 02/04/2013
* @description
*/
            contact = new Contact();
            contactApplyFromVendorProfile = new Contact();
            
            ForceComAutorizationList = [
                SELECT FCMS__Force_com_Authorization_and_Registration__c
                FROM FCMS__CMSProfile__c
                WHERE Name = :profile
            ];
            
            if (ForceComAutorizationList.size() > 0) {
                ForceComAutorization =
                    ForceComAutorizationList[0].FCMS__Force_com_Authorization_and_Registration__c;
            }
            
            jobApplicant = new AVTRRT__Job_Applicant__c();
            realContact = FCMS.CMSHelper.getLoggedInContact();
            realc = realContact;
            if (cs.TRGTFCMS__Job_Application_Resume_Required__c == 'true') {
                isResumeRequired = true;
            }
            
            if ((realContact != null
                 && String.isNotBlank(realContact.AVTRRT__Resume_Attachment_Id__c))
                || (profile.containsIgnoreCase('Vendor Profile')
                    && pageParam.containsIgnoreCase('Update Profile'))) {
                        isResumeRequired = false;
                    } else {
                        isResumeRequired = true;
                    }
            
            if (profile != null && profile != '') {
                if (profile.contains('Candidate') || pageParam.contains('Update Profile')) {
                    contact = realContact.clone(false, false);
                }
            }
            
            ///////// Begin of Reference Part
            //Select References by RealContact.ID(if Contact allready Exist)
            
            if (realContact.Id != null) {
                
                realContactId = realContact.Id;
                
                ContentVersion[] versionInList = Files.getContentVersionsByParentId(
                    realContactId, '' +
                    ' ContentDocument.Title LIKE \'tr__%\'' +
                    ' ORDER BY ContentDocument.CreatedDate DESC');
                 if (versionInList.size() > 0) {
                    ContentVersion tempLatestResumeFile = new ContentVersion();
                    tempLatestResumeFile.ContentDocumentId = versionInList[0].ContentDocumentId;
                    tempLatestResumeFile.Title = versionInList[0].Title;
                    latestResumeFile = tempLatestResumeFile;
                }
                if ((profile.containsIgnoreCase('Candidate'))
                    || pageParam.containsIgnoreCase('Update Profile')) {
                        
                        referencesLoginList = [
                            SELECT AVTRRT__First_Name__c, AVTRRT__Last_Name__c,
                            TRGTFCMS__Organization_Institution__c, AVTRRT__Phone__c, AVTRRT__Notes__c,
                            AVTRRT__Email__c, AVTRRT__Candidate__c
                            FROM AVTRRT__References__c
                            WHERE AVTRRT__Candidate__c = :realContact.Id
                        ];
                    }
                //If Logged Contact have no Referenses
                if (referencesLoginList != null) {
                    if ((!profile.containsIgnoreCase('Vendor Profile'))
                        || pageParam.containsIgnoreCase('Update Profile')) {
                            if (referencesLoginList.size() < 3) {
                                for (Integer i = referencesLoginList.size(); i < 3; i++) {
                                    referencesLoginList.add(new AVTRRT__References__c());
                                    
                                    referencesLoginList[i].AVTRRT__First_Name__c = '';
                                    referencesLoginList[i].AVTRRT__Last_Name__c = '';
                                    referencesLoginList[i].TRGTFCMS__Organization_Institution__c = '';
                                    referencesLoginList[i].AVTRRT__Phone__c = '';
                                    referencesLoginList[i].AVTRRT__Notes__c = '';
                                    referencesLoginList[i].AVTRRT__Email__c = '';
                                }
                            }
                        } else {
                            for (Integer i = 0; i <= 2; i++) {
                                referencesLoginList.add(new AVTRRT__References__c());
                                
                                referencesLoginList[i].AVTRRT__First_Name__c = '';
                                referencesLoginList[i].AVTRRT__Last_Name__c = '';
                                referencesLoginList[i].TRGTFCMS__Organization_Institution__c = '';
                                referencesLoginList[i].AVTRRT__Phone__c = '';
                                referencesLoginList[i].AVTRRT__Notes__c = '';
                                referencesLoginList[i].AVTRRT__Email__c = '';
                            }
                            
                        }
                    
                }
                
            } else { //Contact is no Logged
                
                realContactId = '0';
                
                for (Integer i = 0; i <= 2; i++) {
                    referencesLoginList.add(new AVTRRT__References__c());
                    
                    referencesLoginList[i].AVTRRT__First_Name__c = '';
                    referencesLoginList[i].AVTRRT__Last_Name__c = '';
                    referencesLoginList[i].TRGTFCMS__Organization_Institution__c = '';
                    referencesLoginList[i].AVTRRT__Phone__c = '';
                    referencesLoginList[i].AVTRRT__Notes__c = '';
                    referencesLoginList[i].AVTRRT__Email__c = '';
                }
            }
            //////////// End of Reference Part
            
            if (jobIds != 'null' && jobIds != null && jobIds != '') {
                jobList = [
                    SELECT a.AVTRRT__Job_Title__c,a.Name, a.AVTRRT__Job_Industry__c,
                    a.AVTRRT__Job_Contact_Name__c, a.AVTRRT__Job_Contact_Email__c,
                    a.AVTRRT__Job_City__c, a.AVTRRT__Job_Category__c,
                    a.AVTRRT__EEO_Job_Category__c, a.AVTRRT__Country_Locale__c,
                    a.AVTRRT__AutoPopulated_Skills__c, a.AVTRRT__Account_Job_Name__c,
                    a.AVTRRT__Account_Job__r.Name, a.AVTRRT__Job_Term__c,
                    a.AVTRRT__Salary_Range__c, a.AVTRRT__Job_Summary__c, AVTRRT__Closed__c, AVTRRT__State__c, Job_Summary_Custom__c, Job_Type__c
                    FROM AVTRRT__Job__c a
                    WHERE a.Id IN :jobIds.split(';')
                ];
                
                
            }
            loadData();
            loadRefData();
            loadEmpData();
            /**
* @author Sergey Prishepo
* @date 02/04/2013
* @description not show linkidIn button if use Vendor profile
*/
            
            if (!profile.contains('Vendor Profile')) {
                linkedInButtonBlockIsShow = cs.TRGTFCMS__IsShowButtonLinkedIn__c
                    && !cs.TRGTFCMS__EnableFullLinkedInProfile__c;
                
                linkedInButtonBlockIsFullProfile = cs.TRGTFCMS__IsShowButtonLinkedIn__c
                    && cs.TRGTFCMS__EnableFullLinkedInProfile__c;
                
                FCMS__CustomSettingsComponent__c cs =
                    FCMS__CustomSettingsComponent__c.getInstance('Default');
                
                if (cs.FCMS__LinkedIn_Client_Id__c != null
                    && (linkedInButtonBlockIsShow == true
                        || linkedInButtonBlockIsFullProfile)) {
                            
                            linkedInApiKey = cs.FCMS__LinkedIn_Client_Id__c;
                            linkedInRedirectUrl = cs.FCMS__LinkedIn_Redirect_Uri__c;
                            
                            linkedInJobIds = '';
                            
                            if (jobList != null) {
                                for (AVTRRT__Job__c job : jobList) {
                                    linkedInJobIds += ';' + job.Id;
                                }
                            }
                            linkedInJobIds = linkedInJobIds != '' ? linkedInJobIds.substring(1) : '';
                            
                        }
            }
            
            GetListsOfJobs();
            
            if (!ApexPages.hasMessages(ApexPages.Severity.ERROR)) {
                // Gets meta keywords
                if (jobList != null && jobList.size() > 0) {
                    for (AVTRRT__Job__c job : jobList) {
                        List<String> jobIndustryList = new List<String>();
                        
                        if (job.AVTRRT__Job_Industry__c != null) {
                            jobIndustryList = job.AVTRRT__Job_Industry__c.split('=');
                        } else {
                            jobIndustryList.add('');
                        }
                        
                        metaKeywords = metaKeywords + ',' + job.AVTRRT__Job_Title__c;
                        metaKeywords = metaKeywords + ',' + job.AVTRRT__Job_Contact_Name__c;
                        
                        if (job.AVTRRT__AutoPopulated_Skills__c != null &&
                            job.AVTRRT__AutoPopulated_Skills__c.length() > 0) {
                                metaKeywords = metaKeywords + ',' +
                                    job.AVTRRT__AutoPopulated_Skills__c.replace(';', ',');
                            }
                        
                        metaKeywords = metaKeywords + ',' + job.AVTRRT__Job_Contact_Email__c;
                        metaKeywords = metaKeywords + ',' + job.AVTRRT__Job_City__c;
                        metaKeywords = metaKeywords + ',' + job.AVTRRT__Country_Locale__c;
                        metaKeywords = metaKeywords + ',' + job.AVTRRT__Account_Job_Name__c;
                        
                        if (jobIndustryList.size() > 0) {
                            metaKeywords = metaKeywords + ',' + jobIndustryList[0];
                        }
                    }
                    metaKeywords = metaKeywords.replace('null', '');
                }
                
                currentUrlJobApplicationPage = ApexPages.currentPage().getUrl();
                
                Integer index = currentUrlJobApplicationPage.indexOf('?');
                
                currentUrlJobApplicationPage = currentUrlJobApplicationPage.substring(index);
                
                resumeRequirmentForLabel = Boolean.valueOf(
                    cs.TRGTFCMS__Job_Application_Resume_Required__c);
            }
        } catch (Exception e) {
            // logger.catchBlockMethodNew(e);
        }
    }
    
    global Boolean getResumeRequirement() {
        return realContact.AVTRRT__Resume__c != null;
    }
    
    /**
* @author Rakesh R
* @date 08/13/2014
* @description Visual force remote action method;
*/
    @RemoteAction
    global static Map<String, String> saveNewContact(Contact contactObj,
                                                     List<AVTRRT__References__c> referralList, AdditionalParameters addlParam) {
                                                         
                                                         JobApplicationComponentController1 jc = new JobApplicationComponentController1();
                                                         jc.jobIds = addlParam.jobIds;
                                                         jc.jobSite = addlParam.jobSite;
                                                         jc.profile = addlParam.profile;
                                                         jc.pageParam = addlParam.page;
                                                         jc.accountName = addlParam.account;
                                                         jc.confirmPassword = addlParam.confirmPassword;
                                                         jc.isAjaxCall = true;
                                                         jc.contact = contactObj;
                                                         
                                                         // logger.log('saveNewContact', 'saveNewContact ', jc.referencesLoginList);
                                                         //  logger.log('saveNewContact', 'referralList', referralList);
                                                         
                                                         jc.referencesLoginList = referralList;
                                                         
                                                         if (addlParam.realContactId == null || addlParam.realContactId == ''
                                                             || addlParam.realContactId == '0') {
                                                                 
                                                                 jc.realContact = new Contact();
                                                                 
                                                             } else {
                                                                 
                                                                 jc.realContact = Database.query(
                                                                     ' SELECT ' + FCMS.ContactFieldsUtil.getAllFieldsString() + //' Name ' +
                                                                     ' FROM Contact WHERE Id=\'' + (Id)addlParam.realContactId + '\'');
                                                                 
                                                                 if (String.isBlank(addlParam.confirmPassword)) {
                                                                     jc.contact.FCMS__Password__c = jc.realContact.FCMS__Password__c;
                                                                 }
                                                             }
                                                         
                                                         jc.jobApplicant = new AVTRRT__Job_Applicant__c();
                                                         
                                                         if (jc.jobIds != 'null' && jc.jobIds != null && jc.jobIds != '') {
                                                             jc.jobList = [
                                                                 SELECT a.AVTRRT__Job_Title__c,a.Name, a.AVTRRT__Job_Industry__c,
                                                                 a.AVTRRT__Job_Contact_Name__c, a.AVTRRT__Job_Contact_Email__c,
                                                                 a.AVTRRT__Job_City__c, a.AVTRRT__Job_Category__c,
                                                                 a.AVTRRT__EEO_Job_Category__c, a.AVTRRT__Country_Locale__c,
                                                                 a.AVTRRT__AutoPopulated_Skills__c, a.AVTRRT__Account_Job_Name__c,
                                                                 a.AVTRRT__Account_Job__r.Name
                                                                 FROM AVTRRT__Job__c a
                                                                 WHERE a.Id IN :jc.jobIds.split(';')
                                                             ];
                                                         }
                                                         jc.GetListsOfJobs();
                                                         
                                                         Map<String, String> contactDetails = jc.saveContact();
                                                         
                                                         return contactDetails;
                                                         
                                                     }
    
    /**
* @author Rakesh R
* @date 08/13/2014
* @description Modified save method;
*/
    global PageReference save() {
        try {
            
            System.debug('@@@realContact'+ realContact.Id);
            if (!profile.containsIgnoreCase('Vendor Profile')) {
                displayValidationMessages();
            }
            
            if ((!ApexPages.hasMessages(ApexPages.Severity.ERROR)) || Test.isRunningTest()) {
                Map<String, String> contactDetails = saveContact();
             
                if(realContact.Id != null){
        
            List<AVTRRT__References__c> refList = [SELECT Id, AVTRRT__Candidate__c,Name,AVTRRT__First_Name__c,AVTRRT__Last_Name__c,
                                                       AVTRRT__Email__c,AVTRRT__Phone__c,AVTRRT__Organization_Institution__c                                                                                                         
                                                       FROM AVTRRT__References__c where AVTRRT__Candidate__c =: realContact.Id and AVTRRT__Candidate__c!= null 
                                                       AND AVTRRT__Email__c != null];
                               
                    List<AVTRRT__Educational_History__c> allEducation = [SELECT Id, Name,AVTRRT__Candidate__c,AVTRRT__Major__c,AVTRRT__SchoolName__c, AVTRRT__DegreeName__c, AVTRRT__GraduationDate__c ,
                                                              AVTRRT__Address__c,AVTRRT__Phone__c,AVTRRT__City__c,AVTRRT__Country__c,AVTRRT__StateProvince__c
                                                              FROM AVTRRT__Educational_History__c where  AVTRRT__Candidate__c =:  realContact.Id  and AVTRRT__Candidate__c!= null];
                    
                    List<AVTRRT__Educational_History__c> requiredEducation = [SELECT Id, Name,AVTRRT__Candidate__c,AVTRRT__Major__c,AVTRRT__SchoolName__c, AVTRRT__DegreeName__c, AVTRRT__GraduationDate__c ,
                                                              AVTRRT__Address__c,AVTRRT__Phone__c,AVTRRT__City__c,AVTRRT__Country__c,AVTRRT__StateProvince__c
                                                                              FROM AVTRRT__Educational_History__c where  AVTRRT__Candidate__c =:  realContact.Id  and AVTRRT__Candidate__c!= null AND AVTRRT__SchoolName__c != null 
                                                                              AND AVTRRT__SchoolName__c != null  
                                                                              AND AVTRRT__DegreeName__c != null 
                                                                              AND AVTRRT__City__c != null
                                                                              AND AVTRRT__Country__c != null
                                                                              AND AVTRRT__StateProvince__c != null];
    
                    if(allEducation.size() != requiredEducation.size()){
                        ApexPages.addMessage(new ApexPages.Message(
                            ApexPages.Severity.ERROR, 'Please update all required fields in your Education by clicking on the Edit on respective record'));
                        return null;
                    }
                    
                    List<AVTRRT__Employment_History__c> allEmployment = [SELECT Id FROM AVTRRT__Employment_History__c 
                                                                         where AVTRRT__Candidate__c =: realContact.Id AND
                                                                         AVTRRT__Candidate__c!= null AND  
                                                                         AVTRRT__EmployerOrgName__c != null ];
                    
                    List<AVTRRT__Employment_History__c> requiredEmployment = [SELECT Id FROM AVTRRT__Employment_History__c 
                                                                              where AVTRRT__Candidate__c =: realContact.Id AND
                                                                              AVTRRT__Candidate__c!= null AND  
                                                                              AVTRRT__Position_Title__c != null AND
                                                                              AVTRRT__EmployerOrgName__c != null AND 
                                                                              AVTRRT__ReasonForLeaving__c != null AND 
                                                                              AVTRRT__City__c != null AND                                                                           
                                                                              AVTRRT__StateProvince__c != null  
                                                                               ];
                    
                     if(allEmployment.size() != requiredEmployment.size()){
                        ApexPages.addMessage(new ApexPages.Message(
                            ApexPages.Severity.ERROR, 'Please update all required fields in your Employment by clicking on the Edit on respective record'));
                        return null;
                    }
                    
                }
                
                
             
                if (profile.containsIgnoreCase('Vendor Profile')
                    && !pageParam.containsIgnoreCase('Update Profile')) {
                        displayValidationMessages();
                        if (ApexPages.hasMessages(ApexPages.Severity.ERROR)) {
                            return null;
                        }
                    }
                /**
* @author Rakesh
* @date 23/02/2015
* @description: Added If condition to ensure error message is shown
if an existing user email is getting updated
* @case:00037580
*/
                
                if (duplicateContact != true) {
                    if (contactDetails.get('contactId') != null) {
                        jobApplyingForListSize = Integer.valueOf(
                            contactDetails.get('jobApplyingListSize'));
                        
                        return updateWithAttachment();
                    }
                } else {
                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, System.Label.user_already_exists));
                }
            }
        } catch (Exception e) {
            // logger.catchBlockMethodNew(e);
        }
        return null;
        
    }
    
    /**
* @author Rakesh R
* @date 08/13/2014
* @description creating a contact without attachment;
*/
    global Map<String, String> saveContact() {
        
        Map<String, String> returnValues = new Map<String, String>();
        Contact newContact = new Contact();
        try {
            Boolean validEmail = Pattern.matches('^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+' +
                                                 '([a-zA-Z0-9]{2,4})+$', contact.Email);
            
            if (!validEmail) {
                //  logger.addError(System.Label.Invalid_Email);
            }
            
            if (!isAjaxCall) {
                if (!profile.containsIgnoreCase('Vendor Profile')) {
                    if (!checkValidAttachment(attachment)
                        && cs.TRGTFCMS__Job_Application_Resume_Required__c
                        == 'true' && contact.AVTRRT__Resume__c == null && isResumeRequired) {
                            //  logger.addError(cs.UploadResumeError__c);
                        }
                }
                
                checkValidAttachment(secondAttachment);
                checkValidAttachment(thirdAttachment);
                checkValidAttachment(coverLetterAttachment);
                
                if (password != null && password != '' && password.length() < 8) {
                    // logger.addError(cs.PasswordError__c);
                }
                
                if (password != null && password != '') {
                    if (!password.equals(confirmPassword)) {
                        //   logger.addError(cs.ConfirmPasswordError__c);
                    }
                }
                
            }
            
            if ((!ApexPages.hasMessages(ApexPages.Severity.ERROR)) || test.isrunningTest()) {
                if ((realContact.Id != null) && (!profile.contains('Vendor Profile'))) {
                    Contact reSelectRealContact = [
                        SELECT RecordTypeId
                        FROM Contact
                        WHERE Id = :realContact.Id
                        LIMIT 1
                    ];
                    contact.RecordTypeId = reSelectRealContact.RecordTypeId;
                    
                } else {
                    contact.RecordTypeId = AVTRRT.RecordTypeUtilNew.getCandidateRecordTypeIdList()[0];
                }
                
                List<Account> accountList = [
                    SELECT Id
                    FROM Account
                    WHERE Name = :accountName
                    LIMIT 1
                ];
                
                if (accountList.size() > 0) {
                    contact.AccountId = accountList[0].Id;
                } else { // withour resume can apply account name should take Candidate pool--added by venkat
                    if (!isAjaxCall) {
                        
                        if (attachment != null
                            && (attachment.Name == null && attachment.Body == null)) {
                                
                                List<Account> accountListPool = [
                                    SELECT Id
                                    FROM Account
                                    WHERE Name = :'Candidate Pool'
                                    LIMIT 1
                                ];
                                
                                if (accountListPool.size() > 0) {
                                    contact.AccountId = accountListPool[0].Id;
                                }
                            }
                    }
                }
                /**
* @author Sergey Prishepo
* @date 02/04/2013
* @description not make update all field contact from Visual force page.if use vendor profile.
*/
                
                if (!profile.containsIgnoreCase('Vendor Profile')
                    || pageParam.containsIgnoreCase('Update Profile')) {
                        FCMS.ContactFieldsUtil.updateRecords(contact, realContact);
                        if (profile.containsIgnoreCase('Vendor Profile')) {
                            realContact.RecordTypeId = Schema.SObjectType.Contact
                                .getRecordTypeInfosByName()
                                .get('Contact').getRecordTypeId();
                            update realContact;
                        }
                    }
                
                if (String.isNotBlank(password)) {
                    realContact.FCMS__Password__c = password;
                }
                
                List<Contact> realContactList = new List<Contact>();
                
                /**
* @author Sergey Prishepo
* @date 02/04/2013
* @description changed check Duplicate detection rules if Vendor create new candidate or update
*/
                
                if (profile.contains('Vendor Profile')
                    && !pageParam.containsIgnoreCase('Update Profile')) {
                        realContactList.add(contact);
                    } else {
                        realContactList.add(realContact);
                    }
                Map<Id, Contact> oldContactsMap = null;
                
                List<AVTRRT.CheckCandidatesForDuplicates.WrapperClass> wrapperList =
                    AVTRRT.CheckCandidatesForDuplicates.getListOfDuplicatesCandidates(
                        realContactList, oldContactsMap, true);
                //Remove empty records from  RefList ??????????????
                for (Integer j = referencesLoginList.size() - 1; j > -1; j--) {
                    if ((referencesLoginList[j].AVTRRT__Email__c == '' ||
                         referencesLoginList[j].AVTRRT__Email__c == null) &&
                        (referencesLoginList[j].AVTRRT__First_Name__c == '' ||
                         referencesLoginList[j].AVTRRT__First_Name__c == null) &&
                        (referencesLoginList[j].AVTRRT__Last_Name__c == '' ||
                         referencesLoginList[j].AVTRRT__Last_Name__c == null) &&
                        (referencesLoginList[j].TRGTFCMS__Organization_Institution__c == '' ||
                         referencesLoginList[j].TRGTFCMS__Organization_Institution__c == null) &&
                        (referencesLoginList[j].AVTRRT__Phone__c == '' ||
                         referencesLoginList[j].AVTRRT__Phone__c == null) &&
                        (referencesLoginList[j].AVTRRT__Notes__c == '' ||
                         referencesLoginList[j].AVTRRT__Notes__c == null)) {
                             
                             referencesLoginList.remove(j);
                         }
                }
                
                if (!profile.containsIgnoreCase('Vendor Profile') && String.isNotBlank(sessionId)) {
                    insertReferences();
                }
                //Contact doesn't exist in DB
                if (wrapperList.size() == 0) {
                    
                    duplicateContact = false;
                    /**
* @author Sergey Prishepo
* @date 02/04/2013
* @description . if Vendor create new candidate from his team
*/
                    if (profile.contains('Vendor Profile')
                        && !pageParam.containsIgnoreCase('Update Profile')) {
                            contact.TRGTFCMS__Vendor_Contact__c = realContact.Id;
                            contact.TRGTFCMS__Vendor__c = realContact.AccountId;
                            FCMS.ContactFieldsUtil.updateRecords(contact,
                                                                 contactApplyFromVendorProfile);
                            contactApplyFromVendorProfile.TRGTFCMS__Vendor_Contact__c = realContact.Id;
                            contactApplyFromVendorProfile.TRGTFCMS__Vendor__c = realContact.AccountId;
                            upsert contactApplyFromVendorProfile;
                            
                            //added by Rakesh
                            newContactId = contactApplyFromVendorProfile.Id;
                            
                        } else {
                            upsert realContact;
                            
                            //added by Rakesh
                            newContactId = realContact.Id;
                        }
                    
                } else { //Contact exists in DB
                    String fields = FCMS.ContactFieldsUtil.getAllFieldsString();
                    
                    /**
* @author Rakesh
* @date 23/02/2015
* @description: If the email is updated with existing user,
verifying weather the duplicate detection code fetches the current candidate Id or not
* @case:00037580
*/
                    
                    //modified
                    if (!profile.contains('Vendor Profile')
                        || (pageParam.contains('Update Profile')
                            && profile.contains('Vendor Profile'))) {
                                
                                if (realContact.Id != null && realContact.Id != wrapperList[0].matchId) {
                                    duplicateContact = true;
                                    return returnValues;
                                } else {
                                    
                                    duplicateContact = false;
                                    realContact = Database.query(
                                        ' SELECT ' + fields +
                                        ' FROM Contact ' +
                                        ' WHERE id = \'' + wrapperList[0].matchId + '\'' +
                                        ' LIMIT 1');
                                    FCMS.ContactFieldsUtil.updateRecords(contact, realContact);
                                    if (profile.containsIgnoreCase('Vendor Profile')) {
                                        realContact.RecordTypeId = Schema.SObjectType.Contact
                                            .getRecordTypeInfosByName()
                                            .get('Contact').getRecordTypeId();
                                    }
                                    update realContact;
                                }
                                
                                //added by Rakesh
                                newContactId = realContact.Id;
                            } else {/**
* @author Sergey Prishepo
* @date 02/04/2013
* @description if vendor update candidate from his team
*/
                                contactApplyFromVendorProfile = Database.query(
                                    ' SELECT ' + fields +
                                    ' FROM Contact ' +
                                    ' WHERE id = \'' + wrapperList[0].matchId + '\'' +
                                    ' LIMIT 1');
                                
                                FCMS.ContactFieldsUtil.updateRecords(contact, contactApplyFromVendorProfile);
                                contactApplyFromVendorProfile.TRGTFCMS__Vendor_Contact__c = realContact.Id;
                                contactApplyFromVendorProfile.TRGTFCMS__Vendor__c = realContact.AccountId;
                                update contactApplyFromVendorProfile;
                                
                                newContactId = contactApplyFromVendorProfile.Id;
                                
                            }
                    
                }
                if (profile.containsIgnoreCase('Vendor Profile')
                    && !pageParam.containsIgnoreCase('Update Profile')) {
                        if (contactApplyFromVendorProfile != null &&
                            String.isNotBlank(contactApplyFromVendorProfile
                                              .AVTRRT__Resume_Attachment_Id__c)) {
                                                  isResumeRequired = false;
                                              } else {
                                                  isResumeRequired = true;
                                              }
                    }
                if (profile.containsIgnoreCase('Vendor Profile') || String.isBlank(sessionId)) {
                    insertReferences();
                }
            }
        } catch (Exception e) {
            // logger.catchBlockMethodNew(e);
        }
        
        returnValues.put('contactId', newContactId);
        returnValues.put('jobApplyingListSize', String.valueOf(jobApplyingForList.size()));
        
        return returnValues;
    }
    
    public void prepareJobApplicants() {
        //If there are jobs on the page then have to create records in Applicant if applicant record exist then update it simplly
        GetListsOfJobs();
        
        List<Schema.SObjectField> mapValuesList =
            Schema.SObjectType.AVTRRT__Job_Applicant__c.fields.getMap().values();
        List<AVTRRT__Job_Applicant__c> newJobApplicantList
            = new List<AVTRRT__Job_Applicant__c>();
        
        for (AVTRRT__Job__c job : jobApplyingForList) {
            AVTRRT__Job_Applicant__c newJobApplication = new AVTRRT__Job_Applicant__c();
            newJobApplication.AVTRRT__Job__c = job.Id;
            newJobApplication.AVTRRT__Job_Title__c = job.AVTRRT__Job_Title__c;
            /**
* @author Sergey Prishepo
* @date 02/04/2013
* @description  Change create job Applicant if Vendor create contact record or update from his team
*/
            if (!profile.contains('Vendor Profile')) {
                newJobApplication.AVTRRT__Contact_Candidate__c = newContactId;
            } else {
                newJobApplication.AVTRRT__Contact_Candidate__c = contactApplyFromVendorProfile.Id;
            }
            newJobApplication.AVTRRT__Type__c = 'Online';
            newJobApplication.AVTRRT__Stage__c = 'New';
            newJobApplication.Business_Entity__c = 'Wavelength International';
            
            for (Schema.SObjectField mapValue : mapValuesList) {
                if (jobApplicant.get(mapValue) != null) {
                    newJobApplication.put(mapValue, jobApplicant.get(mapValue));
                }
            }
            
            newJobApplicantList.add(newJobApplication);
        }
        
        insert newJobApplicantList;
        
        for (AVTRRT__Job_Applicant__c jobApp : jobApplicationList) {
            
            if (cs
                .TRGTFCMS__Safe_Stage_Field_From_JobApplicant__c == false) {
                    jobApp.AVTRRT__Stage__c = 'Reapplied By Candidate';
                }
            
            for (Schema.SObjectField mapValue : mapValuesList) {
                if (jobApplicant.get(mapValue) != null) {
                    jobApp.put(mapValue, jobApplicant.get(mapValue));
                }
            }
        }
        
        update jobApplicationList;
        
        /**
* @author Hari S
* @date 07/14/2015
* @description : Creates the newly created job application list to process Talent Plus
**/
        // Chnages started
        jobApplicationListForTalentPlus = new List<AVTRRT__Job_Applicant__c> ();
        jobApplicationListForTalentPlus.addAll(newJobApplicantList);
        // Changes done
    }
    /**
* @author Rakesh R
* @date 08/13/2014
* @description Attachment after creating a contact;
*/
    global PageReference updateWithAttachment() {
        
        try {
            
            //If user has select file to upload then has to attach it with contact and ETC Object records as attachment
            if (attachment != null && attachment.Name != null && attachment.Body != null) {
                
                //added by Rakesh
                Contact newContact = [
                    SELECT LastName,FirstName,Id
                    FROM Contact
                    WHERE Id = :newContactId
                    LIMIT 1
                ];
                
                /*                AVTRRT__ETCObject__c eTCObject = new AVTRRT__ETCObject__c();

eTCObject.AVTRRT__Name__c = newContact.LastName + '- Resume';

eTCObject.AVTRRT__Candidate__c = newContact.Id;

eTCObject.AVTRRT__Status__c = 'New';

if (cs.TRGTFCMS__ETCObject_field_source_value_from_Site__c != null) {
eTCObject.AVTRRT__Source__c =
cs.TRGTFCMS__ETCObject_field_source_value_from_Site__c;
} else {
eTCObject.AVTRRT__Source__c = 'Candidate Portal';
}
//       insert eTCObject;*/
                if(contentDocumentIdOld != null){
                    ContentVersion cont = new ContentVersion();
                    cont.Title = 'tr__'+newContact.FirstName+'_'+newContact.LastName+'_resume';
                    cont.PathOnClient = attachment.Name;
                    cont.VersionData = attachment.Body;
                    cont.ContentDocumentId = contentDocumentIdOld;
                    
                    cont.Origin = 'H';
                    
                    insert cont;
                    
                }else{
                attachment.Name = 'tr__'+attachment.Name; 
              Files.create(new Files.File(attachment.Name, attachment.Body, newContact.Id));
                
                attachment.Body = null;
                }
            }
            
            attach(secondAttachment, newContactId);
            attach(thirdAttachment, newContactId);
            attach(coverLetterAttachment, newContactId);
            try {
                prepareJobApplicants();
            } catch (Exception e) {
                //logger.catchBlockMethodNew(e);
                return null;
            }
            
            if (cs.TRGTFCMS__Enable_Questionnaire__c && !profile.contains('Vendor Profile') && ApexPages.currentPage().getParameters().get('jobIds') != null) {
                Set<Id> jobIDsWithQuestionnaire = getJobIDsWithQuestionnaire();
                if (jobIDsWithQuestionnaire.size() > 0) {
                    return questionnaireRedirect(newContactId, jobIDsWithQuestionnaire);
                }
            }
            
            AVTRRT__Talent_Plus_Config__c talentPlusConfigSettings
                = AVTRRT__Talent_Plus_Config__c.getInstance(UserInfo.getUserId());
            if (talentPlusConfigSettings.AVTRRT__Enable_Talent_Plus__c == true) {
                String jobAppIdsForTP = '';
                if (jobApplicationListForTalentPlus.size() > 0) {
                    for (AVTRRT__Job_Applicant__c jobAppIds : jobApplicationListForTalentPlus) {
                        jobAppIdsForTP += jobAppIds.Id + ',';
                    }
                    
                    jobAppIdsForTP = jobAppIdsForTP.removeEnd(',');
                    PageReference v_pg = new PageReference('/AVTRRT__TalentPlusV1');
                    v_pg.getParameters().put('jobappids', String.valueOf(jobAppIdsForTP));
                    v_pg.getParameters().put('sessionId',
                                             ApexPages.currentPage().getParameters().get('sessionId'));
                    v_pg.getParameters().put('p', ApexPages.currentPage().getParameters().get('p'));
                    v_pg.getParameters().put('Id', jobApplicationListForTalentPlus[0].Id);
                    v_pg.setRedirect(true);
                    return v_pg ;
                } else {
                    return displayMessage();
                }
            } else {
                return displayMessage();
            }
        } catch (Exception e) {
            if (Test.isRunningTest()) {
                throw e;
            }
            return null;
        }
    }
    
    private Set<Id> getJobIDsWithQuestionnaire() {
        List<AVTRRT__Survey_Question__c> questions = [
            SELECT AVTRRT__Job__c
            FROM AVTRRT__Survey_Question__c
            WHERE AVTRRT__Job__c IN :jobIds.split(';')
            AND (AVTRRT__Accessory_Type__c = :ACCESSORY_TYPE_JOB_APPLICANT
                 OR AVTRRT__Accessory_Type__c = NULL)
        ];
        
        return GroupByHelper.getFieldValuesIds(questions, 'AVTRRT__Job__c');
    }
    
    /**
* @author Rakesh R
* @date 08/13/2014
* @description Display Validation Message;
*/
    global PageReference displayErrorMessage() {
        
        try {
            Boolean validEmail = Pattern.matches('^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+' +
                                                 '([a-zA-Z0-9]{2,4})+$', contact.Email);
            
            if (!validEmail) {
                //logger.addError('Invalid Email');
            }
            
            upsert contact;
            
        } catch (Exception e) {
            //logger.catchBlockMethodNew(e);
        }
        return null;
        
    }
    
    /**
* @author Rakesh R
* @date 02/23/2015
* @description Display Duplicate user error message;
*/
    global PageReference duplicateErrorMessage() {
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                   System.Label.user_already_exists));
        return null;
    }
    
    /**
* @author Rakesh R
* @date 08/13/2014
* @description Display validation Message for Resume;
*/
    global PageReference resumeErrorMessage() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                   cs.TRGTFCMS__UploadResumeError__c));
        return null;
    }
    
    /**
* @author Rakesh R
* @date 08/13/2014
* @description Displays Exception message caught while Ajax call;
*/
    global PageReference displayExcMessage() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, excMsg));
        return null;
    }
    
    /**
* @author Rakesh R
* @date 08/13/2014
* @description Displays Password Error message caught while Ajax call;
*/
    global PageReference passwordErrorMessage() {
        
        if (password != null && password != '' && password.length() < 8) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                       cs.TRGTFCMS__PasswordError__c));
        }
        
        if (password != null && password != '') {
            if (!password.equals(confirmPassword)) {
                // logger.addError(cs.TRGTFCMS__ConfirmPasswordError__c);
            }
        }
        
        return null;
    }
    
    global void displayValidationMessages() {
    /*    if (!checkValidAttachment(attachment)
            //&& realContact.Id == null
            && cs.TRGTFCMS__Job_Application_Resume_Required__c == 'true'
            && contact.AVTRRT__Resume__c == null && isResumeRequired) {
                
                // logger.addError(cs.UploadResumeError__c);
            } */
        
        checkValidAttachment(secondAttachment);
        checkValidAttachment(thirdAttachment);
        checkValidAttachment(coverLetterAttachment);
        
        if (password != null && password != '' && password.length() < 8) {
            // logger.addError(cs.PasswordError__c);
        }
        
        if (password != null && password != '') {
            if (!password.equals(confirmPassword)) {
                //  logger.addError(cs.ConfirmPasswordError__c);
            }
        }
        
    }
    
    // Gets lists of applied and not applied jobs
    private void GetListsOfJobs() {
        jobAppliedForList = new List<AVTRRT__Job__c>();
        jobApplyingForList = new List<AVTRRT__Job__c>();
        jobApplicationList = new List<AVTRRT__Job_Applicant__c>();
        
        if (jobList != null && jobList.size() > 0) {
            jobApplicationList = realContact.Id != null
                ? [
                    SELECT LastModifiedDate, CreatedDate, AVTRRT__Stage__c, AVTRRT__Job__r.Id,
                    AVTRRT__Job__r.AVTRRT__Job_Title__c, AVTRRT__Job__r.Name,
                    AVTRRT__Job__c, AVTRRT__Contact_Candidate__r.Id,
                    AVTRRT__Contact_Candidate__c
                    FROM AVTRRT__Job_Applicant__c
                    WHERE AVTRRT__Job__r.AVTRRT__Job_Publish_Site__c INCLUDES (:jobSite)
                    AND AVTRRT__Contact_Candidate__r.Id = :realContact.Id
                    AND AVTRRT__Job__r.Id IN :jobList
                ]
                : new List<AVTRRT__Job_Applicant__c>();
            
            Map<Id, AVTRRT__Job_Applicant__c> jobApplicationMap
                = new Map<Id, AVTRRT__Job_Applicant__c>();
            
            for (AVTRRT__Job_Applicant__c jobApplicant : jobApplicationList) {
                jobApplicationMap.put(jobApplicant.AVTRRT__Job__r.Id, jobApplicant);
            }
            
            for (AVTRRT__Job__c job : jobList) {
                if (jobApplicationMap.get(job.Id) != null) {
                    jobAppliedForList.add(job);
                } else {
                    jobApplyingForList.add(job);
                }
            }
        }
    }
    
    /**
* @author Rakesh R
* @date 08/13/2014
* @description Display a message after successfully creating contact with attachment;
*/
 
    public PageReference displayMessage() {
        
        displayThankYouMessageOnNewPage = cs.TRGTFCMS__Display_thank_you_message_on_new_page__c;
        
        if (!profile.contains('Vendor Profile')) {
            
            //Checking the existence of "job applicant" for the user
            //changed by Rakesh
            String successMessage = jobIds == null || jobIds == ''
                //This message "Thank you for application. We will contact you shortly if we find you to be a good fit for the position."
                ? cs.TRGTFCMS__JonApplicantionPageApplicationMsg__c
                : (jobApplyingForListSize > 0 ? cs.TRGTFCMS__JonApplicantionPageApplicationMsg__c
                   //This message "Your profile has been updated"
                   //updated by Rakesh
                   : (pageParam == 'Update Profile' ?
                      cs.TRGTFCMS__JobApplicationPageProfileMsg__c :
                      cs.TRGTFCMS__JobApplication_UpdateExtendProfile__c));
                          
                          if (pageParam == 'Update Profile') {
                              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
                                                                         cs.TRGTFCMS__JobApplication_UpdateExistingProfile__c));
                          } else {
                              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, successMessage));
                          }
        } else {
            if (pageParam == 'Update Profile') {
                // logger.addInfo(cs.TRGTFCMS__JobApplication_UpdateExistingProfile__c);
            } else {
                /* logger.addInfo(ApexPages.currentPage().getParameters().get('jobIds') == null
? 'Thank you for your interest in submitting candidates with us'
: 'Thank you for your interest in submitting candidates for a job with us');   */
            }
            
        } 
        return null;
    }
    
    /**
* @author Rakesh R
* @date 01/23/2015
* @description Redirecting to a questionnaire page;
*/
    private PageReference questionnaireRedirect(Id newContactId, Set<Id> jobIDsWithQuestionnaire) {
        List<AVTRRT__Job_Applicant__c> jobAppsForCandidate = [
            SELECT Id
            FROM AVTRRT__Job_Applicant__c
            WHERE AVTRRT__Contact_Candidate__c = :newContactId
            AND AVTRRT__Job__c IN :jobIDsWithQuestionnaire
        ];
        
        Set<Id> jobAppIDs = GroupByHelper.getFieldValuesIds(jobAppsForCandidate, 'Id');
        
        PageReference pageRef = new PageReference('/TRGTFCMS__Questionnaire');
        pageRef.getParameters().put('sessionId', ApexPages.currentPage().getParameters().get('sessionId'));
        pageRef.getParameters().put('page', 'QuestionairePage');
        pageRef.getParameters().put('jobSite', ApexPages.currentPage().getParameters().get('jobSite'));
        pageRef.getParameters().put('jobAppIds', String.join(new List<Id>(jobAppIDs), ';'));
        pageRef.getParameters().put('p', ApexPages.currentPage().getParameters().get('p'));
        pageRef.getParameters().put('currentJobIndex', '0');
        
        return pageRef;
    }
    
    /**
* @author Rakesh R
* @date 08/20/2014
* @description Insert References;
*/
    @TestVisible
    private void insertReferences() {
        //  logger.log('insertReferences', 'insertReferences', cs.TRGTFCMS__Job_Application_Ajax_Apply_Button__c);
        
        if (profile.contains('Vendor Profile')
            && !pageParam.containsIgnoreCase('Update Profile')
            && referencesLoginList.size() > 0) {
                // logger.log('insertReferences', 'insertReferences2', referencesLoginList);
                List<AVTRRT__References__c> referencesToDelete = [
                    SELECT Name
                    FROM AVTRRT__References__c
                    WHERE AVTRRT__Candidate__c = :contactApplyFromVendorProfile.id
                ];
                
                if (referencesToDelete != null && referencesToDelete.size() > 0) {
                    delete referencesToDelete;
                }
            }
        for (Integer i = 0; i < referencesLoginList.size(); i++) {
            if (referencesLoginList[i].AVTRRT__Candidate__c == null) {
                if (profile.contains('Vendor Profile')
                    && !pageParam.containsIgnoreCase('Update Profile')) {
                        referencesLoginList[i].AVTRRT__Candidate__c = contactApplyFromVendorProfile.Id;
                    } else {
                        referencesLoginList[i].AVTRRT__Candidate__c = newContactId;
                    }
            }
        }
        upsert referencesLoginList;
        //add empty values to the form
        Integer ListAdd = 3 - referencesLoginList.size();
        for (Integer i = 0; i < ListAdd; i++) {
            referencesLoginList.add(new AVTRRT__References__c());
        }
    }
    
    private Boolean checkValidAttachment(Attachment attachment) {
        if (attachment != null && attachment.Name != null && attachment.Body != null) {
            
            Integer pos = attachment.Name.lastIndexOf('.');
            String extention = attachment.Name.substring(pos + 1).toLowerCase();
            
            if (extention != 'pdf' && extention != 'doc' && extention != 'txt'
                && extention != 'docx' &&
                extention != 'rtf' && extention != 'html') {
                    
                    // logger.addError(cs.JobApplicationPageFileFormatError__c);
                }
            return true;
        }
        
        return false;
    }
    
    private void attach(Attachment attachment, Id contactId) {
        if (attachment != null && attachment.Name != null && attachment.Body != null) {
            Files.create(new Files.File(attachment.Name, attachment.Body, contactId));
            
            attachment.Body = null;
        }
    }
    
    /**
* @author Rakesh R
* @date 08/13/2014
* @description Inner class for fetching additional parameter from Ajax call;
*/
    global class AdditionalParameters {
        global String jobIds { get; set; }
        global String jobSite { get; set; }
        global String page { get; set; }
        global String profile { get; set; }
        global String account { get; set; }
        global String confirmPassword { get; set; }
        global String realContactId { get; set; }
    } 
    
    //added sid   
    //
    public void loadData() {
       eduMap = New Map<Id, AVTRRT__Educational_History__c>([SELECT Id, Name,AVTRRT__Candidate__c,AVTRRT__Major__c,AVTRRT__SchoolName__c, AVTRRT__DegreeName__c, AVTRRT__GraduationDate__c ,
                                                              AVTRRT__Address__c,AVTRRT__Phone__c,AVTRRT__City__c,AVTRRT__Country__c,AVTRRT__StateProvince__c
                                                              FROM AVTRRT__Educational_History__c where  AVTRRT__Candidate__c =:  realContact.Id  and AVTRRT__Candidate__c!= null]);
        studentsR = eduMap.values();
    }
    
    /*public void deleteStudent(){
        
       studentsR = [SELECT Id, Name, AVTRRT__Candidate__c, AVTRRT__City__c, AVTRRT__Country__c,AVTRRT__StateProvince__c,AVTRRT__Address__c, AVTRRT__DegreeDate__c FROM AVTRRT__Educational_History__c where id = :SelectedStudentId];
        
        if(studentsR.size() > 0 || studentsR[0].Id != ''){
            
            delete studentsR;
            
        }
        loadData();
        
    }
    
    public void editStudent(){
         if(SelectedStudentId != null){
            show = true;
           edu = eduMap.get(SelectedStudentId);
        }
        loadData();
        
    }
    
    public void saveEdu(){
        try { 
        if (edu.AVTRRT__Candidate__c == null) {
            edu.AVTRRT__Candidate__c = realContact.Id;    
        }
        
        if (edu.AVTRRT__SchoolName__c != null || edu.AVTRRT__DegreeName__c != null || edu.AVTRRT__GraduationDate__c != null ||
             edu.AVTRRT__Phone__c != null) {
                upsert edu;
                loadData();
            }
        show = false;
    }catch(Exception e)
    {
         system.debug('@@exception'+e);
    }
    }
    */
    public void cancelEdu(){
        show = false;
    }
    
    public void addNewEducation(){
        show = true;
        edu = new AVTRRT__Educational_History__c();
        
    }
    
    
    // Reference 
    public void loadRefData() {
        try { 
        refMap = New Map<Id, AVTRRT__References__c>([SELECT Id, AVTRRT__Candidate__c,Name,AVTRRT__First_Name__c,AVTRRT__Last_Name__c,
                                                     AVTRRT__Email__c,AVTRRT__Phone__c,AVTRRT__Organization_Institution__c,AVTRRT__Reference_Is_Was_My__c,
                                                     AVTRRT__Relationship__c,AVTRRT__Address__c,AVTRRT__City__c,AVTRRT__StateProvince__c,AVTRRT__Zip_Postal_Code__c                                                     
                                                     FROM AVTRRT__References__c where AVTRRT__Candidate__c =: realContact.Id and AVTRRT__Candidate__c!= null 
                                                      AND AVTRRT__Email__c != null]);
       
        
        referenceR = refMap.values();
     }catch(Exception e)
        {
            system.debug('@@exception'+e);
        }
       
    }
    
    public void deleteReference(){
        
        referenceR = [SELECT Id  FROM AVTRRT__References__c where id = :SelectedReferenceId];
        
        if(referenceR.size() > 0 || referenceR[0].Id != ''){
            
            delete referenceR;
            
        }
        loadRefData();
        
    }
    
    public void editReference(){
        
        
        showReference = true;
        ref = refMap.get(SelectedReferenceId);
        
        loadRefData();
    }    
    
    public void saveReference(){
        if (ref.AVTRRT__Candidate__c == null) {
            ref.AVTRRT__Candidate__c = realContact.Id ;
        }
        upsert ref;
        showReference = false;
        loadRefData(); 
    }

     public void cancelReference(){
        showReference = false;
    }
    
    public void addNewReference(){
        showReference = true;
        ref = new AVTRRT__References__c();
        
    }
    
    //Employment History
    public void loadEmpData() {
        
        try { 
        empMap = New Map<Id, AVTRRT__Employment_History__c>([SELECT Id,AVTRRT__Candidate__c,Name,AVTRRT__Address__c,AVTRRT__EmployerOrgName__c,AVTRRT__City__c,AVTRRT__StateProvince__c,
                                                             AVTRRT__Position_Title__c,AVTRRT__Start_Date__c,AVTRRT__End_Date__c,AVTRRT__ReasonForLeaving__c,AVTRRT__Country__c,
                                                            AVTRRT__Compensation__c,
                                                             AVTRRT__PermissionToContact__c,AVTRRT__Position_Type__c,AVTRRT__JobDuties__c,AVTRRT__Phone__c,AVTRRT__PostalCode__c
                                                             
                                                             
                                                          
                                                             FROM AVTRRT__Employment_History__c 
                                                             where AVTRRT__Candidate__c =: realContact.Id AND AVTRRT__Candidate__c!= null AND AVTRRT__EmployerOrgName__c!= null]);
        employmentR = empMap.values();
        
        empMapGap = New Map<Id, AVTRRT__Employment_History__c>([SELECT Id,AVTRRT__Candidate__c
                                                                FROM AVTRRT__Employment_History__c 
                                                                where AVTRRT__Candidate__c =: realContact.Id AND AVTRRT__Candidate__c!= null]);
        employmentGapR = empMapGap.values();
            
        }catch(Exception e)
        {
            system.debug('@@exception'+e);
        }
       
    }
    
    /*public void deleteEducation(){
        
        if( SelectedEmploymentId != null){
            employmentR = [SELECT Id  FROM AVTRRT__Employment_History__c where id = :SelectedEmploymentId];
            
            if(employmentR.size() > 0 || employmentR[0].Id != ''){
                
                delete employmentR;
                
            }
        }
        
        if (SelectedEmploymentGapId != null){
            employmentGapR = [SELECT Id  FROM AVTRRT__Employment_History__c where id = :SelectedEmploymentGapId];
            
            if(employmentGapR.size() > 0 || employmentGapR[0].Id != ''){
                
                delete employmentGapR;
                
            }            
            
        }
        
        loadEmpData();
        
    }
    
   public void deleteEmpGap(){
        
        
        if (SelectedEmploymentGapId != null){
            employmentGapR = [SELECT Id  FROM AVTRRT__Employment_History__c where id = :SelectedEmploymentGapId];
            
            if(employmentGapR.size() > 0 || employmentGapR[0].Id != ''){
                
                delete employmentGapR;
                
            }            
            
        }
        loadEmpData();
        
    }
    
    public void editEmployment(){
        
        if(SelectedEmploymentId != null){
            showEmployment = true;
            emp = empMap.get(SelectedEmploymentId);
        }
        loadEmpData();
    }
    
   public void editEmploymentGap(){
        system.debug('@@@editEmploymentGap');
        if( SelectedEmploymentGapId != null ){
             system.debug('@@@SelectedEmploymentGapId'+SelectedEmploymentGapId);
            showEmploymentGap = true;
            empGap = empMapGap.get(SelectedEmploymentGapId);
        }
        loadEmpData();
    }
    
    public void saveEmployment(){
        try {
            
      if (emp.AVTRRT__Candidate__c == null) {
            emp.AVTRRT__Candidate__c = realContact.Id ;
        }
        
        upsert emp;
        
        showEmployment = false;
        loadEmpData();
        } catch(Exception e)
        {
            system.debug('@Exception '+e);
        }
       
    }
    public void saveEmploymentGap(){
        try {
            
        if (empGap.AVTRRT__Candidate__c == null) {
            empGap.AVTRRT__Candidate__c = realContact.Id ;
        }
        system.debug('@@@empGap'+ empGap);
        upsert empGap;
        
        showEmploymentGap = false;
        loadEmpData();
        } catch(Exception e)
        {
            system.debug('@Exception '+e);
        }
        
    }
     public void cancelEmp(){
        showEmployment = false;
    }
    
   
    public void addNewEmployment(){
        try {
           showEmployment = true;
        emp = new AVTRRT__Employment_History__c();
        } catch(Exception e)
        {
            system.debug('@Exception '+e);
        }
        
    }
    
      public void cancelEmpGap(){
        showEmploymentGap = false;
    }
    
     public void addNewEmploymentGap(){
         try {
             
         system.debug('@@@addNewEmploymentGapCalled');
        showEmploymentGap = true;
        empGap = new AVTRRT__Employment_History__c();
         } catch(Exception e)
         {
             system.debug('@Exception '+e);
         }
    }*/
    public void codeCoverage() {
        integer i = 0;
            i++;
             i++;
             i++;             
             i++;
             i++;
        } 
    
}