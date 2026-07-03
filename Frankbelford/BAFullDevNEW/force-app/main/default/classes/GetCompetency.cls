public class GetCompetency {
    public Id userid;
    public String validationWarning {get; set;}
     public Boolean check{get; set;}
    public list<sirenum__Sirenum_Condition_Membership__c> cmp{get;set;}
    public sirenum__Sirenum_Condition_Membership__c  newcomp{get; set;}
    public list<sirenum__Sirenum_Condition_Membership__c> Competency{get;set;}
    public Id siteId;
    public Id accountId;
    public boolean saveNew;
    public list<sirenum__Team__c> jobCategoryId = new list<sirenum__Team__c>();
    public list<sirenum__Team__c> sectorId = new list<sirenum__Team__c>();
    public set<Id> jobCategoryIdSet = new set<Id>();
    public set<Id> sectorIdSet = new set<Id>();
    sirenum__Site__c site;
    public sirenum__Site__c st;
   // public Id userid;
    public Boolean displayPage{get;set;}
    public Boolean displayalert{get;set;}
    public Id getSiteId{get;set;}
    public List<sirenum__Team__c> jobRoleForAccount =new List<sirenum__Team__c> ();
    private static final string lightningTheme ='Theme4d';

    // Simple accessors for the System.UserInfo theme methods
    public String getContextUserUiThemeDisplayed() {
        return UserInfo.getUiThemeDisplayed();
    }
    
    public GetCompetency(ApexPages.StandardController controller){
       
          userid = UserInfo.getUserId();
      
        siteId = ApexPages.CurrentPage().getparameters().get('Id');
        getSiteId = siteId;
        system.debug('siteId'+siteId);
        system.debug('siteId2'+ApexPages.CurrentPage());
        system.debug('siteId3'+ApexPages.CurrentPage().getparameters().get('Id'));
        newcomp = new sirenum__Sirenum_Condition_Membership__c ();
        saveNew=false;
        displayPageCallFunction();
        jobCategoryId = [select sirenum__Job_Type__r.id from sirenum__Team__c where sirenum__Account__r.sirenum__Client__c =:accountId ];
        sectorId=[select sirenum__Rota__r.id from sirenum__Team__c where sirenum__Account__r.sirenum__Client__c =:accountId ];
    
        for(sirenum__Team__c jobCatId :jobCategoryId )
        {
            jobCategoryIdSet.add(jobCatId.sirenum__Job_Type__r.id);
        }
        for(sirenum__Team__c secId :sectorId )
        {
            sectorIdSet.add(secId.sirenum__Rota__r.id);
        }
        st=[select id, sirenum__Operating_Company__r.id from sirenum__Site__c where id = :siteId ];
        accountId = st.sirenum__Operating_Company__r.id;
        jobRoleForAccount =[select id from sirenum__Team__c where sirenum__Account__r.sirenum__Client__c =:accountId];
        
        List<Account> nationalAccount = [select IP_CompetencyRestriction__c from Account where id =: accountId ];
        List<PermissionSetAssignment> AssignmentId = [SELECT Id,PermissionSet.Name FROM PermissionSetAssignment WHERE PermissionSet.Name= 'Branch_Managers' AND AssigneeId =:userid]; 
       system.debug('Test IN IF AssignmentId  '+AssignmentId );
       if((nationalAccount[0].IP_CompetencyRestriction__c==true) && (AssignmentId.size() > 0))
        {
        system.debug('Test IN IF ');
            check = true;
        }  
        
        getdata();
        getdata1();
        
    }
    
    public void displayPageCallFunction(){
        Id profileId = [Select id from Profile where Name='System Administrator'].id;
        
        List<PermissionSetAssignment> permissionSet = new List<PermissionSetAssignment>();
        Set<String> permissionSetStrings = new Set<String>{'National_Regional_Managers', 'Branch_Managers'};
        
        try{
            permissionSet = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSet.Name IN:permissionSetStrings AND AssigneeId = :UserInfo.getUserId()];
            displayPage = false;
            displayalert = false;
            if(!permissionSet.isEmpty() || profileId==Userinfo.getProfileId()){ 
                displayPage = true;
            }
            else{
                displayPage = false;
                displayalert = true;
            }
        }
        Catch(Exception e){
            displayalert = true;
        }
    }
    
    public list<sirenum__Sirenum_Condition_Membership__c> getdata(){
        cmp= [Select id, sirenum__Client__c, sirenum__TicketType__c, sirenum__Team__c, sirenum__Rota__c,sirenum__Severity__c,sirenum__Site__c,sirenum__Job_Type__c from sirenum__Sirenum_Condition_Membership__c where sirenum__Site__c =:siteId or (sirenum__Client__c =:accountId and sirenum__Site__c=NULL) order  by sirenum__TicketType__r.name asc , sirenum__Severity__c asc];
        return cmp;
        
    }
    
    public list<sirenum__Sirenum_Condition_Membership__c> getdata1(){
        Competency= [Select id, sirenum__TicketType__c, sirenum__Rota__c, sirenum__Job_Type__c,sirenum__Team__c,sirenum__Client__c, sirenum__Severity__c,sirenum__Site__c from sirenum__Sirenum_Condition_Membership__c where (sirenum__Site__c != :siteId and sirenum__Client__c != :accountId and sirenum__Team__r.sirenum__Account__r.sirenum__Client__c =:accountId) OR (sirenum__Job_Type__c  In :jobCategoryIdSet and sirenum__Site__c = Null and sirenum__Client__c = Null and sirenum__Team__c = Null) OR (sirenum__Rota__c In :sectorIdSet and sirenum__Job_Type__c = Null and sirenum__Site__c = Null and sirenum__Client__c = Null and sirenum__Team__c = Null )  order  by sirenum__TicketType__r.name asc , sirenum__Severity__c asc];
        return Competency;
    }
    public void clearvalidationWarning(){
        
        validationWarning = '';
        
    }
    public pageReference validateRecord(){
       userid = UserInfo.getUserId();
        system.debug('user Id------>' +userid);
        set<Id> accountJobRoleSet = new set<Id>();
        for(sirenum__Team__c relatedJobRole :jobRoleForAccount )
        {
            accountJobRoleSet.add(relatedJobRole.id);
        }
        newcomp.sirenum__Site__c=siteId;
        sirenum__Sirenum_Condition_Membership__c[] alreadyexisting = [Select id,sirenum__TicketType__r.name ,sirenum__Severity__c,sirenum__Client__r.name from sirenum__Sirenum_Condition_Membership__c where sirenum__Client__c =:accountId   and sirenum__TicketType__c =:newcomp.sirenum__TicketType__c and sirenum__Severity__c =:newcomp.sirenum__Severity__c];
        sirenum__Sirenum_Condition_Membership__c[] alreadyexists = [Select id, sirenum__TicketType__c, sirenum__Site__c,sirenum__Severity__c from sirenum__Sirenum_Condition_Membership__c where sirenum__Site__r.id =:newcomp.sirenum__Site__c and sirenum__TicketType__c =:newcomp.sirenum__TicketType__c and sirenum__Severity__c =:newcomp.sirenum__Severity__c];
        List<Account> nationalAccount = [select IP_CompetencyRestriction__c from Account where id =: accountId ];
        List<PermissionSetAssignment> AssignmentId = [SELECT Id FROM PermissionSetAssignment WHERE  PermissionSet.Name= 'Branch_Managers' AND AssigneeId =:userid]; 
        system.debug('Assignment Id------>' +AssignmentId.size());
        system.debug('sirenum__Site__c------>' +newcomp.sirenum__Site__c);
        
        if((nationalAccount[0].IP_CompetencyRestriction__c==true) && (AssignmentId.size() > 0))
        {
            if(newcomp.sirenum__Team__c == null)
            {
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, 'Job Role cannot be blank for National Account') );
                return null; 
                
            }
            else
            {
                if(accountJobRoleSet.contains(newcomp.sirenum__Team__c)==false)
                {
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, ' Selected Job Role should be against the Account related to the Site ') );
                    return null; 
                    
                }
                
                
            }
            
        }
        if(alreadyexists.size() > 0)
        {
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, 'Competency Condition already exists') );
            return null;
        }
       if(alreadyexisting.size() > 0)
        {
            // if(alreadyexisting[0].sirenum__Client__r.name==Null)
            validationWarning = 'The Competency Condition you’re creating is already fulfilled by the following existing competencies. Are you sure you want to continue?'+'\\n\\n'+'Competency: '+alreadyexisting[0].sirenum__TicketType__r.name+'\\n'+'Severity:  '+alreadyexisting[0].sirenum__Severity__c+'\\n'+'Applied Level:  '+alreadyexisting[0].sirenum__Client__r.name;
            /*else if(alreadyexisting[0].sirenum__Team__r.name==Null)
validationWarning = 'The Competency Condition you’re creating is already fulfilled by the following existing competencies. Are you sure you want to continue?'+'\\n\\n'+'Competency: '+alreadyexisting[0].sirenum__TicketType__r.name+'\\n'+'Severity:  '+alreadyexisting[0].sirenum__Severity__c+'\\n'+'Applied Level:  '+alreadyexisting[0].sirenum__Client__r.name;
else
validationWarning = 'The Competency Condition you’re creating is already fulfilled by the following existing competencies. Are you sure you want to continue?'+'\\n\\n'+'Competency: '+alreadyexisting[0].sirenum__TicketType__r.name+'\\n'+'Severity:  '+alreadyexisting[0].sirenum__Severity__c+'\\n'+'Applied Level:  '+alreadyexisting[0].sirenum__Client__r.name+','+alreadyexisting[0].sirenum__Team__r.name;
*/
            return null;
            
        }
        
        
        else
        {
            clearvalidationWarning();
            PageReference pg=save(); 
            return pg;
        }
    }
    
   public void onaction()
  {
             
  
  }  
    
    
    public PageReference Save(){
        try{
            newcomp.sirenum__Site__c=siteId;
              newcomp.RedirectField__c = siteId;
            insert newcomp;
            system.debug('siteId'+siteId);
            PageReference pageRef;
            if(!saveNew){                
                String getLightning = getContextUserUiThemeDisplayed();
                if(lightningTheme.equals(getLightning)){
                    pageRef = new pageReference('/lightning/r/sirenum__Site__c/'+siteId+'/view');
                 }
                 else{
                     pageRef = new pageReference('/'+siteId); 
                 } 
                system.debug('pageRef'+pageRef);
                pageRef.setRedirect(true);
            }
            else if(saveNew){
                pageRef = new pageReference('/apex/SiteCompetency?id='+siteId); 
                system.debug('pageRef'+pageRef);
                pageRef.setRedirect(true);
            }
            return pageRef;
        }
        
        catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, e.getMessage());
            ApexPages.addMessage(msg);
            return null;
        }
    }
    public PageReference SaveAndNew() 
    {
        saveNew=true;
        pageReference pg=validateRecord();
        return pg;
    }
}