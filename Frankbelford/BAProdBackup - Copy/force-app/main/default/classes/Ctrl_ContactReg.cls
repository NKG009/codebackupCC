public with sharing class Ctrl_ContactReg {
    public List<Contact> contacts { get; set; }
    public  string siteFullUrl;
    public Map<String,Id> jsformMap = new Map<String,Id>();
    public Map<String,JSForms__Form__c> jsformNameMap = new Map<String,JSForms__Form__c>();
    public String firstname { get; set; }
    public String lastname { get; set; }
    public String ni_number {get; set;}
    public date dob {get; set;}
    public string urlPORTW{get;set;}
    public string UrliPadcontact{get;set;}
    public string UrleqlOpps{get;set;}
    public string UrlGDPR{get;set;}
    public string UrlDeclarations{get;set;}
    public string UrlWTR{get;set;}
    public string UrlTOE{get;set;}
    public string UrlMedical{get;set;}
    public string UrlNSF{get;set;}
    public string UrlBank{get;set;}
    public string UrlRReq{get;set;}
    public string UrlPerm{get;set;}
    public string UrlDriving{get;set;}
    public string UrlWTRT{get;set;}
    public string UrlIreland{get;set;}

    public Ctrl_ContactReg() {
        contacts = new List<Contact>();
    }

    public PageReference searchContacts() {
        contacts = [select Id from Contact where firstname = :firstname and lastname = :lastname and birthdate = :dob];
        if(contacts.size()>0) {
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

            urlPORTW =siteFullUrl +jsformNameMap.get('Blue Arrow - Right To Work').JSForms__Encrypted_Id__c;
            UrliPadcontact =siteFullUrl +jsformNameMap.get('Contact Details').JSForms__Encrypted_Id__c;
            UrleqlOpps =siteFullUrl +jsformNameMap.get('Blue Arrow Equal Opportunities Questionnaire').JSForms__Encrypted_Id__c;
            UrlGDPR =siteFullUrl +jsformNameMap.get('Data Protection Consent Form').JSForms__Encrypted_Id__c;
            UrlDeclarations =siteFullUrl +jsformNameMap.get('Blue Arrow Declarations').JSForms__Encrypted_Id__c;
            UrlWTR =siteFullUrl +jsformNameMap.get('Blue Arrow - Working Time Regulation').JSForms__Encrypted_Id__c;
            UrlTOE =siteFullUrl +jsformNameMap.get('Blue Arrow Terms of Employment').JSForms__Encrypted_Id__c;
            UrlMedical =siteFullUrl +jsformNameMap.get('Blue Arrow - Medical Form').JSForms__Encrypted_Id__c;
            UrlNSF =siteFullUrl +jsformNameMap.get('Blue Arrow - New Starter Form').JSForms__Encrypted_Id__c;
            UrlBank =siteFullUrl +jsformNameMap.get('Bank Details Form (PAYE)').JSForms__Encrypted_Id__c;
            UrlRReq =siteFullUrl +jsformNameMap.get('Blue Arrow Referee Request').JSForms__Encrypted_Id__c;
            UrlPerm =siteFullUrl +jsformNameMap.get('Permanent Work Seekers Consent Form').JSForms__Encrypted_Id__c;
            UrlDriving =siteFullUrl +jsformNameMap.get('Driving Licence').JSForms__Encrypted_Id__c;
            UrlWTRT =siteFullUrl +jsformNameMap.get('Driver Declaration of Hours worked at Registration').JSForms__Encrypted_Id__c;
            UrlIreland =siteFullUrl +jsformNameMap.get('Fair Employment Monitoring Questionnaire').JSForms__Encrypted_Id__c;
        }
        return null;
    }

    public PageReference Clearfilter() {
        firstname = '';
        lastname = '';
        dob = null;
        contacts = null;
        return null;
    }
}