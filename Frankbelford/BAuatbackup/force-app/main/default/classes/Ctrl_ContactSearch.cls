public with sharing class Ctrl_ContactSearch {

    public List<Contact> contacts { get; set; }
    public String firstname { get; set; }
    public String lastname { get; set; }
    public String ni_number {get; set;}
    public  string siteFullUrl;
    public Map<String,Id> jsformMap = new Map<String,Id>();
    public Map<String,JSForms__Form__c> jsformNameMap = new Map<String,JSForms__Form__c>();
    public string portw{get;set;}
    public string declaration{get;set;}
    public string wtr{get;set;}
    public string eeq{get;set;}
    public string newstarter{get;set;}
    public string bankdetails{get;set;}
    public string medical{get;set;}
    public string TOE{get;set;}

    public Ctrl_ContactSearch() {
        contacts = new List<Contact>();
    }

    public PageReference searchContacts()
    {
        contacts = [select Id from Contact where firstname = :firstname and lastname = :lastname and Sirenum__National_Insurance__c = :ni_number];
        if(contacts.size() >0){
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
            portw =siteFullUrl +jsformNameMap.get('Blue Arrow - Right To Work').JSForms__Encrypted_Id__c;
            declaration =siteFullUrl +jsformNameMap.get('Blue Arrow Declarations').JSForms__Encrypted_Id__c;
            wtr =siteFullUrl +jsformNameMap.get('Blue Arrow - Working Time Regulation').JSForms__Encrypted_Id__c;
        }
        return null;
    }
    public PageReference Clearfilter() {
        firstname = '';
        lastname = '';
        ni_number = '';
        contacts = null;
        return null;
    }
}