public class referenceDetailsAutoReminder{
    public id record_Id{get; set;}

    public string department;
    public Date referenceRequestSentDate{get; set;}
    public String branchphone{get;set;}

    public  String FullFormUrl{get;set;}
    public  string siteFullUrl;
    public Map<String,Id> jsformMap = new Map<String,Id>();
    public Map<String,JSForms__Form__c> jsformNameMap = new Map<String,JSForms__Form__c>();
    public String brand;

    public ts2__Reference__c referenceid{
        get {
            return generateName();
        }
        set;
    } 

    public ts2__Reference__c generateName() {
        if(record_Id != null){
            ts2__Reference__c rf = [SELECT id,Date_Reference_Request_Sent__c,ts2__Candidate__c,ts2__Candidate__r.IP_TempestDepartment__c,ts2__Name__c,Candidate_Name_Text__c,ts2__Candidate__r.Brand__c, ts2__Candidate__r.FirstName,Recordtype.Name FROM ts2__Reference__c WHERE Id = :record_Id];

            brand = String.isBlank(rf.ts2__Candidate__r.Brand__c)?'Blue Arrow':rf.ts2__Candidate__r.Brand__c;
            referenceRequestSentDate = date.newinstance(rf.Date_Reference_Request_Sent__c.year(), rf.Date_Reference_Request_Sent__c.month(), rf.Date_Reference_Request_Sent__c.day());
            department = rf.ts2__Candidate__r.IP_TempestDepartment__c;
            System.debug('check department'+department);

            IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department);
            branchphone = shiftemp.Phone__c;

            String FormIDprof= jsformNameMap.get(brand + ' Reference Survey - Professional').JSForms__Encrypted_Id__c;
            String FormIDpersonal= jsformNameMap.get(brand + ' Reference Survey - Personal').JSForms__Encrypted_Id__c;
            String FormIDAcedmic= jsformNameMap.get(brand + ' Reference Survey - Academic').JSForms__Encrypted_Id__c;
            if(rf.Recordtype.Name == 'Professional'){
                FullFormUrl = siteFullUrl +FormIDprof+'&ContactId='+rf.ts2__Candidate__c+'&id='+record_Id ;
            } else if(rf.Recordtype.Name == 'Personal'){
                FullFormUrl = siteFullUrl +FormIDpersonal+'&ContactId='+rf.ts2__Candidate__c+'&id='+record_Id ;
            } else if(rf.Recordtype.Name == 'Academic'){
                FullFormUrl = siteFullUrl +FormIDAcedmic+'&ContactId='+rf.ts2__Candidate__c+'&id='+record_Id ;
            }
            return rf;
        } else { return null; }
    }

    public referenceDetailsAutoReminder() {
        Site site = [SELECT GuestUserId, Name, Subdomain, UrlPathPrefix, Admin.Brand__c FROM Site WHERE Name = 'Inquiry'];
        brand = String.isBlank(site.Admin.Brand__c)?'Blue Arrow':site.Admin.Brand__c;

        Organization org = [SELECT InstanceName, IsSandbox, OrganizationType FROM Organization];
        siteFullUrl = 'https://' ;
        if(org.IsSandbox == true) {
            siteFullUrl += UserInfo.getUserName().substringAfterLast('.')+'-';
            siteFullUrl += site.Subdomain + '.';
        } else {
            siteFullUrl += site.Subdomain + '.secure.';
        }
        siteFullUrl += (org.IsSandbox || org.OrganizationType == 'Developer Edition' ? (org.InstanceName.toLowerCase() + '.') : '') + 'force.com/jsforms__forminclude?formId=';

        List<JSForms__Form__c> jsformList = [SELECT Id,JSForms__Title__c, JSForms__Encrypted_Id__c FROM JSForms__Form__c];
        for(JSForms__Form__c js: jsformList ){
            jsformMap.put(js.JSForms__Title__c,js.id);
            jsformNameMap.put(js.JSForms__Title__c,js);
        }
    }
}