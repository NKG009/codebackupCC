public class DynamicUrl{
    public Id record_Id{get;set;}
    public Id refrecord_Id{get;set;}

    public  string siteFullUrl;
    public Map<String,Id> jsformMap = new Map<String,Id>();
    public Map<String,JSForms__Form__c> jsformNameMap = new Map<String,JSForms__Form__c>();

    //Constructor
    public DynamicUrl(){
        Site site = [SELECT GuestUserId, Name, Subdomain, UrlPathPrefix FROM Site WHERE Name = 'Inquiry'];
        Organization org = [SELECT InstanceName, IsSandbox, OrganizationType FROM Organization];

        siteFullUrl = 'https://' ;
        if(org.IsSandbox == true) {
            siteFullUrl += UserInfo.getUserName().substringAfterLast('.')+'-';
        }
        if(org.IsSandbox == true){
            siteFullUrl += site.Subdomain + '.';
        }
        else{
            siteFullUrl += site.Subdomain + '.secure.';
        }
        siteFullUrl += (org.IsSandbox || org.OrganizationType == 'Developer Edition' ? (org.InstanceName.toLowerCase() + '.') : '') + 'force.com/jsforms__forminclude?formId=';

        List<JSForms__Form__c> jsformList = [SELECT Id,JSForms__Title__c, JSForms__Encrypted_Id__c FROM JSForms__Form__c];

        for(JSForms__Form__c js: jsformList ){
            jsformMap.put(js.JSForms__Title__c,js.id);
            jsformNameMap.put(js.JSForms__Title__c,js);
        }
    }

    public DynamicUrl(FairEmploymentQuestionnaireController controller){
        Site site = [SELECT GuestUserId, Name, Subdomain, UrlPathPrefix FROM Site WHERE Name = 'Inquiry'];
        Organization org = [SELECT InstanceName, IsSandbox, OrganizationType FROM Organization];
        siteFullUrl = 'https://' ;
        if(org.IsSandbox == true) {
            siteFullUrl += UserInfo.getUserName().substringAfterLast('.')+'-';
        }
        if(org.IsSandbox == true){
            siteFullUrl += site.Subdomain + '.';
        }
        else{
            siteFullUrl += site.Subdomain + '.secure.';
        }
        siteFullUrl += (org.IsSandbox || org.OrganizationType == 'Developer Edition' ? (org.InstanceName.toLowerCase() + '.') : '') + 'force.com/jsforms__forminclude?formId=';

        List<JSForms__Form__c> jsformList = [SELECT Id,JSForms__Title__c, JSForms__Encrypted_Id__c FROM JSForms__Form__c];

        for(JSForms__Form__c js: jsformList ){
            jsformMap.put(js.JSForms__Title__c,js.id);
            jsformNameMap.put(js.JSForms__Title__c,js);
        }
    }

    public DynamicUrl(Reinstatedtemplatedata controller){
        Site site = [SELECT GuestUserId, Name, Subdomain, UrlPathPrefix FROM Site WHERE Name = 'Inquiry'];
        Organization org = [SELECT InstanceName, IsSandbox, OrganizationType FROM Organization];

        siteFullUrl = 'https://' ;
        if(org.IsSandbox == true) {
            siteFullUrl += UserInfo.getUserName().substringAfterLast('.')+'-';
        }
        if(org.IsSandbox == true){
            siteFullUrl += site.Subdomain + '.';
        }
        else{
            siteFullUrl += site.Subdomain + '.secure.';
        }
        siteFullUrl += (org.IsSandbox || org.OrganizationType == 'Developer Edition' ? (org.InstanceName.toLowerCase() + '.') : '') + 'force.com/jsforms__forminclude?formId=';

        List<JSForms__Form__c> jsformList = [SELECT Id,JSForms__Title__c, JSForms__Encrypted_Id__c FROM JSForms__Form__c];

        for(JSForms__Form__c js: jsformList ){
            jsformMap.put(js.JSForms__Title__c,js.id);
            jsformNameMap.put(js.JSForms__Title__c,js);
        }
    }

    public DynamicUrl(RefereeRequest_Controller controller){
        Site site = [SELECT GuestUserId, Name, Subdomain, UrlPathPrefix FROM Site WHERE Name = 'Inquiry'];
        Organization org = [SELECT InstanceName, IsSandbox, OrganizationType FROM Organization];
        siteFullUrl = 'https://' ;
        if(org.IsSandbox == true) {
            siteFullUrl += UserInfo.getUserName().substringAfterLast('.')+'-';
        }
        if(org.IsSandbox == true){
            siteFullUrl += site.Subdomain + '.';
        }
        else{
            siteFullUrl += site.Subdomain + '.secure.';
        }
        siteFullUrl += (org.IsSandbox || org.OrganizationType == 'Developer Edition' ? (org.InstanceName.toLowerCase() + '.') : '') + 'force.com/jsforms__forminclude?formId=';

        List<JSForms__Form__c> jsformList = [SELECT Id,JSForms__Title__c, JSForms__Encrypted_Id__c FROM JSForms__Form__c];

        for(JSForms__Form__c js: jsformList ){
            jsformMap.put(js.JSForms__Title__c,js.id);
            jsformNameMap.put(js.JSForms__Title__c,js);
        }
    }

    //Medical
    public String FullMedical {
        get {
            return generateMedicalURL();
        }
        set;
    }
    public String generateMedicalURL() {
        String MedicalID= jsformNameMap.get(getBrand() + ' - Medical Form').JSForms__Encrypted_Id__c;
        String FullMedUrl = siteFullUrl +MedicalID+'&ContactId='+record_Id +'&ts2__Contact__c='+record_Id;
        return FullMedUrl;
    }

    //NSD
    public String NSD{
        get {
            return generateNSDURL();
        }
        set;
    }
    public String generateNSDURL() {
        String NSDID= jsformNameMap.get(getBrand() + ' - New Starter Form').JSForms__Encrypted_Id__c;
        String FullNSDUrl = siteFullUrl +NSDID+'&ContactId='+record_Id +'&ts2__Contact__c='+record_Id;
        return FullNSDUrl;
    }

    //TOE
    public String TOEURL{
        get {
            return generateTOEURL();
        }
        set;
    }
    public String generateTOEURL() {
        String TOEID= jsformNameMap.get(getBrand() + ' Terms of Employment').JSForms__Encrypted_Id__c;
        String FullTOEUrl = siteFullUrl +TOEID+'&ContactId='+record_Id +'&ts2__Contact__c='+record_Id;
        return FullTOEUrl;
    }

    //TemporaryCOB
    public String TempCOBURL{
        get {
            return generateTempCOBURL();
        }
        set;
    }
    public String generateTempCOBURL() {
        Contact c = [Select accountid from Contact where id =:record_Id];
        String TempCOBID= jsformNameMap.get('Conditions of Business for the Supply of Flexible Workers').JSForms__Encrypted_Id__c;
        String FullTempCOBURL = siteFullUrl +TempCOBID+'&ClientId='+c.accountid+'&ContactId='+record_Id;
        return FullTempCOBURL;
    }

    //PermanentCOB
    public String PermCOBURL{
        get {
            return generatePermCOBURL();
        }
        set;
    }
    public String generatePermCOBURL() {
        Contact c = [Select accountid from Contact where id =:record_Id];
        String PermCOBID= jsformNameMap.get('Conditions of Business for the Supply of Permanent and Fixed Term Workers').JSForms__Encrypted_Id__c;
        String FullPermCOBURL = siteFullUrl +PermCOBID+'&ClientId='+c.accountid+'&ContactId='+record_Id;
        return FullPermCOBURL;
    }

    //EOQ
    public String EOQ{
        get {
            return generateEOQURL();
        }
        set;
    }
    public String generateEOQURL() {
        String EOQID= jsformNameMap.get(getBrand() + ' Equal Opportunities Questionnaire').JSForms__Encrypted_Id__c;
        String FullEOQUrl = siteFullUrl +EOQID+'&ContactId='+record_Id +'&ts2__Contact__c='+record_Id;
        return FullEOQUrl;
    }

    //Consent
    public String ConsentFormURL{
        get {
            return generateConsentFormURL();
        }
        set;
    }
    public String generateConsentFormURL() {
        String consentID= jsformNameMap.get('Permanent Work Seekers Consent Form').JSForms__Encrypted_Id__c;
        String FullConsentUrl = siteFullUrl +consentID+'&ContactId='+record_Id +'&ts2__Contact__c='+record_Id;
        return FullConsentUrl;
    }

    //StudyTimeTable
    public String StudyTimeTable{
        get {
            return generatetimetable();
        }
        set;
    }
    public String generatetimetable() {
        String StudyID= jsformNameMap.get(getBrand() + ' - Study Timetable').JSForms__Encrypted_Id__c;
        String FullStudyUrl = siteFullUrl +StudyID+'&ContactId='+record_Id +'&ts2__Contact__c='+record_Id;
        return FullStudyUrl;
    }

    //BankDetails
    public String BankDetailsURL{
        get {
            return generateBankDetailsURL();
        }
        set;
    }
    public String generateBankDetailsURL() {
        String BankDTID= jsformNameMap.get('Bank Details Form (PAYE)').JSForms__Encrypted_Id__c;
        String FullBankDTUrl = siteFullUrl +BankDTID+'&ContactId='+record_Id +'&ts2__Contact__c='+record_Id;
        return FullBankDTUrl;
    }

    //Refree Request
    public String RefereeRequest{
        get {
            return generateRefereeRequestURL();
        }
        set;
    }
    public String generateRefereeRequestURL() {
        String RefereeRequestID= jsformNameMap.get(getBrand() + ' Referee Request').JSForms__Encrypted_Id__c;
        String FullRefereeRequestUrl = siteFullUrl +RefereeRequestID+'&ContactId='+record_Id +'&ts2__Contact__c='+record_Id;
        return FullRefereeRequestUrl ;
    }

    //Fair Employment Monitoring Questionnaire
    public String FairEmploymentMonitoringQuestionnaire{
        get {
            return generateFairEmploymentQuestionnaireURL();
        }
        set;
    }
    public String generateFairEmploymentQuestionnaireURL() {
        String FairEmploymentQuestionnaireID= jsformNameMap.get('Fair Employment Monitoring Questionnaire').JSForms__Encrypted_Id__c;
        String FairEmploymentQuestionnaireUrl = siteFullUrl +FairEmploymentQuestionnaireID+'&ContactId='+record_Id +'&ts2__Contact__c='+record_Id;
        return FairEmploymentQuestionnaireUrl ;
    }

    //RightToWork
    public String RightToWork{
        get {
            return generateRightToWorkURL();
        }
        set;
    }
    public String generateRightToWorkURL() {
        String FormID= jsformNameMap.get(getBrand() + ' - Right To Work').JSForms__Encrypted_Id__c;
        String FullFormUrl = siteFullUrl +FormID+'&ContactId='+record_Id +'&ts2__Contact__c='+record_Id;
        return FullFormUrl ;
    }

    //Decalartion
    public String Decalartion{
        get {
            return generateDecURL();
        }
        set;
    }
    public String generateDecURL() {
        String FormID= jsformNameMap.get(getBrand() + ' Declarations').JSForms__Encrypted_Id__c;
        String FullFormUrl = siteFullUrl +FormID+'&ContactId='+record_Id +'&ts2__Contact__c='+record_Id;
        return FullFormUrl ;
    }

    //WTR
    public String WTRURL{
        get {
            return generateWTRURL();
        }
        set;
    }
    public String generateWTRURL() {
        String FormID= jsformNameMap.get(getBrand() + ' - Working Time Regulation').JSForms__Encrypted_Id__c;
        String FullFormUrl = siteFullUrl +FormID+'&ContactId='+record_Id +'&ts2__Contact__c='+record_Id;
        return FullFormUrl ;
    }

    //Driver-Declaration
    public String DriverDecURL{
        get {
            return generateDriverDecURL();
        }
        set;
    }
    public String generateDriverDecURL() {
        String FormID= jsformNameMap.get('Driver Declaration of Hours worked at Registration').JSForms__Encrypted_Id__c;
        String FullFormUrl = siteFullUrl +FormID+'&ContactId='+record_Id +'&ts2__Contact__c='+record_Id;
        return FullFormUrl ;
    }

    //Driver-License
    public String DriverLicense{
        get {
            return generateDriverLicenseURL();
        }
        set;
    }
    public String generateDriverLicenseURL() {
        String FormID= jsformNameMap.get('Driving Licence').JSForms__Encrypted_Id__c;
        String FullFormUrl = siteFullUrl +FormID+'&ContactId='+record_Id +'&ts2__Contact__c='+record_Id;
        return FullFormUrl ;
    }

    //Reference
    public String Ref{
        get {
            return generateReferenceURL();
        }
        set;
    }
    public String generateReferenceURL() {
        String FormID= jsformNameMap.get(getBrand() + ' - Reference').JSForms__Encrypted_Id__c;
        String FullFormUrl = siteFullUrl +FormID+'&ContactId='+record_Id +'&ts2__Contact__c='+record_Id;
        return FullFormUrl ;
    }

    //DataConsent
    public String DataConsent{
        get {
            return generateDataConsentURL();
        }
        set;
    }
    public String generateDataConsentURL() {
        String FormID= jsformNameMap.get('Data Protection Consent Form').JSForms__Encrypted_Id__c;
        String FullFormUrl = siteFullUrl +FormID+'&ContactId='+record_Id +'&id='+record_Id;
        return FullFormUrl ;
    }

    public String getBrand(){
        String brand;
        if(String.isNotBlank(record_Id)) {
            brand = [SELECT Id, Brand__c FROM Contact WHERE Id=: record_Id].Brand__c;
        } else {
            brand = [SELECT Id, Brand__c FROM User WHERE Id=: UserInfo.getUserId()].Brand__c;
        }
        return brand;
    }
}