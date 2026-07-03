public class referenceDetailsAutoReminder{
    public id record_Id{get; set;}

    public string department;
    public Date referenceRequestSentDate{get; set;}
    public String branchphone{get;set;}

    public  String FullFormUrl{get;set;}
    public  string siteFullUrl;
    public Map<String,Id> jsformMap = new Map<String,Id>();
    public Map<String,Form__c> jsformNameMap = new Map<String,Form__c>();
    public String brand;

    public TR1__Reference__c referenceid{
        get {
            return generateName();
        }
        set;
    } 

    public TR1__Reference__c generateName() {
        if(record_Id != null){
            TR1__Reference__c rf = [SELECT id,Date_Reference_Request_Sent__c,TR1__Person_Placed__c,TR1__Person_Placed__r.IP_TempestDepartment__c,Name__c,Candidate_Name_Text__c,TR1__Person_Placed__r.Brand__c, TR1__Person_Placed__r.FirstName,Recordtype.Name FROM TR1__Reference__c WHERE Id = :record_Id];

            brand = String.isBlank(rf.TR1__Person_Placed__r.Brand__c)?'Blue Arrow':rf.TR1__Person_Placed__r.Brand__c;
            referenceRequestSentDate = date.newinstance(rf.Date_Reference_Request_Sent__c.year(), rf.Date_Reference_Request_Sent__c.month(), rf.Date_Reference_Request_Sent__c.day());
            department = rf.TR1__Person_Placed__r.IP_TempestDepartment__c;
            System.debug('check department'+department);

            IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department);
            branchphone = shiftemp.Phone__c;

            String FormIDprof= jsformNameMap.get(brand + ' Reference Survey - Professional').Encrypted_Id__c;
            String FormIDpersonal= jsformNameMap.get(brand + ' Reference Survey - Personal').Encrypted_Id__c;
            String FormIDAcedmic= jsformNameMap.get(brand + ' Reference Survey - Academic').Encrypted_Id__c;
            if(rf.Recordtype.Name == 'Professional'){
                FullFormUrl = siteFullUrl +FormIDprof+'&ContactId='+rf.TR1__Person_Placed__c+'&id='+record_Id ;
            } else if(rf.Recordtype.Name == 'Personal'){
                FullFormUrl = siteFullUrl +FormIDpersonal+'&ContactId='+rf.TR1__Person_Placed__c+'&id='+record_Id ;
            } else if(rf.Recordtype.Name == 'Academic'){
                FullFormUrl = siteFullUrl +FormIDAcedmic+'&ContactId='+rf.TR1__Person_Placed__c+'&id='+record_Id ;
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
        siteFullUrl += (org.IsSandbox || org.OrganizationType == 'Developer Edition' ? (org.InstanceName.toLowerCase() + '.') : '') + 'force.com/forminclude?formId=';

        List<Form__c> jsformList = [SELECT Id,Title__c, Encrypted_Id__c FROM Form__c];
        for(Form__c js: jsformList ){
            jsformMap.put(js.Title__c,js.id);
            jsformNameMap.put(js.Title__c,js);
        }
    }
}