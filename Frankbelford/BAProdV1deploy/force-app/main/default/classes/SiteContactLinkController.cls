public with sharing class SiteContactLinkController {
    
    public String act{get;set;}
    public String myString {get; set;}
    public String createmyString {get; set;}
    public String hidvalue {get; set;}
    public String emailval{get;set;}
    public static Boolean hasemail{get;set;}
    public sirenum__site__c site;
    public string selectedcontact{get;set;}
    public Set<id> contactid = new Set<id>();
    public sirenum__site__c siterec;
    public  sirenum__site__c s{get;set;}
    public string fname{get;set;}
    public string SiteContact{get;set;}
    public string lname{get;set;}
    public Integer consize{get;set;}
    public boolean displayalert {get;set;}
    public List<String> selectedvalue = new List<String>();
    private static final string lightningTheme ='Theme4d';

    // Simple accessors for the System.UserInfo theme methods
    public String getContextUserUiThemeDisplayed() {
        return UserInfo.getUiThemeDisplayed();
    }
    
    public SiteContactLinkController(ApexPages.StandardController controller) {   
        system.debug('@@ fa '+hasemail);
        this.site =  (sirenum__site__c)controller.getRecord();
        s = [select id,sirenum__Operating_Company__c,Portal_Type_Test__c from sirenum__site__c where id=:this.site.id];
consize = 0;
        system.debug('check id'+site);
        //system.debug('act  @@ '+act );
    }
   
    public List<selectOption> allcontacts{
        get {
            List<selectOption> options = new List<selectOption>(); 
            List<id> removelist = new List<id>();
            List<Contact> allcon = new List<Contact>();
            System.debug('Check site id'+this.site.id);
            siterec = [Select id,sirenum__Operating_Company__c from sirenum__site__c where id=: this.site.id];
            List<Contact_Site_link__c> sitelink = [Select id, IP_Contact__c,IP_Site__c from Contact_Site_link__c where IP_Site__c =:this.site.id];
            List<Contact> conlist = [Select id,Name from Contact where Accountid =:siterec.sirenum__Operating_Company__c];
            system.debug('list contact'+conlist);
            system.debug('list contact1'+contactid);
            for(Contact c: conlist){
                contactid.add(c.id); 
            }
            
            for(Contact_Site_link__c abc:sitelink){
                if(contactid.contains(abc.IP_Contact__c)){
                    contactid.remove(abc.IP_Contact__c);
                }
            }
            allcon = [Select id,Name,firstname,lastname from Contact where id in:contactid ORDER BY Lastname];
            options.add(new SelectOption('','-- None --'));

            for(Contact c:allcon){
            consize ++;
                String label = c.Name;
                String value = c.id;
                options.add(new SelectOption(value,label));
            }
            return options;           
        }
        set;
    }
    
   /*    public pagereference linksite(){
  
        act=System.currentPageReference().getParameters().get('PortalType');
        System.debug('!!!!!!!!!!!!!!!!!'+act);

     
    if(selectedcontact == null)
    {
          ApexPages.Message myMsg5 = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a contact to link');
             ApexPages.addMessage(myMsg5);
    }
    else
    {
     try
    {
    
     system.debug('display act '+act);
    Contact_Site_link__c cs = new Contact_Site_link__c();
    cs.IP_Contact__c = selectedcontact;
    cs.IP_Site__c = this.site.id;
    cs.Account__c  = s.sirenum__Operating_Company__c ;  
   
    cs.IP_PortalType__c = act;
    insert cs;
    displayalert = true;
   PageReference pageRef = new PageReference('/apex/SiteContactLink?id=' + this.site.id+'&sx=1');
    return pageRef.setRedirect(true);
    
    }
    catch(Exception e)
    {
       displayalert = false; 
       ApexPages.addMessages(e);return null;

    }
    }
     system.debug('@@ return '+hasemail);
   return null;
    } */

    public pagereference linksite2(){
        System.debug('!!!!!!!!!!!!!!!!!'+myString);
        System.debug('!!!!!!!!!!!!!!!!!'+hidvalue);
        if(selectedcontact == null){
            ApexPages.Message myMsg5 = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a contact to link');
            ApexPages.addMessage(myMsg5);
        }
        else{
            Contact c = [Select email from Contact where id =: selectedcontact];
            if(hidvalue != ''){
                c.email =   hidvalue;
                update c;
            }
            
            system.debug('@@ '+myString+' ## '+c.email);
            if(c.email == null && myString.contains(';')){
                system.debug('@@ ');
                hasemail = true;
                ApexPages.Message testmsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Email cannot be blank if portal type is selected, please provide email');
                ApexPages.Message testmsg3 = new ApexPages.Message(ApexPages.Severity.ERROR,'You can not select Primary Hours Approver OR Secondary Hours Approver OR Escalation Hours Approver OR Viewer together');

                ApexPages.addMessage(testmsg);
                ApexPages.addMessage(testmsg3);
            }
            else if(myString != '' && c.email == null ){
                hasemail = true;
                ApexPages.Message testmsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Email cannot be blank if portal type is selected, please provide email');
                ApexPages.addMessage(testmsg);
            }
            else{
                try{
                    system.debug('display act '+act);
                    Contact_Site_link__c cs = new Contact_Site_link__c();
                    cs.IP_Contact__c = selectedcontact;
                    cs.IP_Site__c = this.site.id;
                    cs.Account__c  = s.sirenum__Operating_Company__c ;  

                    cs.IP_PortalType__c = myString;
                    insert cs;
                    displayalert = true;
                    PageReference pageRef = new PageReference('/apex/SiteContactLink?id=' + this.site.id+'&sx=1');
                    return pageRef.setRedirect(true);
                }
                catch(Exception e){
                    displayalert = false; 
                    ApexPages.addMessages(e);
                    return null;
                }
            }
        }
        system.debug('@@ return '+hasemail);
        return null;
    }
    
    public pagereference createlink(){
        System.debug('!!!!!!!!!!!fname '+fname + lname);
        System.debug('!!!!!!!!!!!!!!!!!'+hidvalue);
        System.debug('!!!!!!!!!!@@ '+createmyString);
        if(lname == '' || fname == ''){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'First Name and Last Name is mandatory');
            ApexPages.addMessage(myMsg); 
        }
        else if(hidvalue == '' && createmyString.contains(';')){
            system.debug('@@ ');
            //   hasemail = true;
            ApexPages.Message testmsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Email cannot be blank if portal type is selected, please provide email');
            ApexPages.Message testmsg3 = new ApexPages.Message(ApexPages.Severity.ERROR,'You can not select Primary Hours Approver OR Secondary Hours Approver OR Escalation Hours Approver OR Viewer together');

            ApexPages.addMessage(testmsg);
            ApexPages.addMessage(testmsg3);
        }
        else if(hidvalue == '' && createmyString != ''){
            system.debug('@@ ');

            ApexPages.Message testmsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Email cannot be blank if portal type is selected, please provide email');
            ApexPages.addMessage(testmsg);

        }
        else if(createmyString.contains(';')){
            ApexPages.Message testmsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,'You can not select Primary Hours Approver OR Secondary Hours Approver OR Escalation Hours Approver OR Viewer OR Consultant together');
            ApexPages.addMessage(testmsg2);
        }
        else{
            try{

                Recordtype rec = [Select id,name from Recordtype where name = 'Contact' and SobjectType ='Contact'];
                Contact c = new Contact();
                c.firstname = fname;
                c.lastname = lname;
                c.Accountid = s.sirenum__Operating_Company__c ;
                c.recordtypeid = rec.id;
                insert c;

                Contact_Site_link__c cs1 = new Contact_Site_link__c();
                cs1.IP_Contact__c = c.id;
                cs1.IP_Site__c = this.site.id;
                cs1.Account__c  = s.sirenum__Operating_Company__c ;
                cs1.IP_PortalType__c = createmyString;
                insert cs1;
                
                // PageReference pageRef = new PageReference('/' + c.id + '/e?retURL=' + c.id);
                // apex/CreateContactPage?recid=0120Y000000UW9k&accid=0010Y00001b5LZh
                
                SiteContact = 'True';
                //PageReference pageRef = new PageReference('/apex/CreateContactPage?recid=' + rec.id + '&accid=' + s.sirenum__Operating_Company__c+'&fname='+fname+'&lname='+lname+'&Sconlink='+SiteContact+'&siteId='+this.site.id+'&eml='+hidvalue+'&prole='+createmyString);
                String getLightning = getContextUserUiThemeDisplayed();
                if(lightningTheme.equals(getLightning)){
                    PageReference pageRef = new PageReference('/lightning/r/sirenum__Site__c/'+this.site.id+'/view');
                    return pageRef.setRedirect(true);
                }
                else{
                    PageReference pageRef = new PageReference('/'+this.site.id);
                    return pageRef.setRedirect(true);
                }

            }
            catch(Exception e){
                ApexPages.addMessages(e);
                return null;
            }
        }
        return null;
    }
    
    public pagereference closepage(){
        String getLightning = getContextUserUiThemeDisplayed();
        if(lightningTheme.equals(getLightning)){
            PageReference pageRef = new PageReference('/lightning/r/sirenum__Site__c/'+this.site.id+'/view');
            return pageRef.setRedirect(true);
        }
        else{
            PageReference pageRef = new PageReference('/'+this.site.id);
            return pageRef.setRedirect(true);
        }
    }
}