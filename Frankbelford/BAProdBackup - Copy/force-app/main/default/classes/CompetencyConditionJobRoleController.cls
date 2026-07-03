/** JIRA 1307 - Branch Manager Access to Competency Conditions **/
/** for Visual Force Page CompetencyConditionAgainstJobRole **/
/** Date - 24-12-2018 **/

public class CompetencyConditionJobRoleController {
    
    public Boolean causeValidationWarning {get; set;}
    public String validationWarning {get; set;}
    public Boolean result{get; set;}
     public Boolean check{get; set;}
    //
    public list<sirenum__Sirenum_Condition_Membership__c> competency{get;set;}
    public list<sirenum__Sirenum_Condition_Membership__c> siteCompetency{get;set;}
    public sirenum__Sirenum_Condition_Membership__c newCompetency{get;set;}
    //public List<competancyWrapper> displayWrapper{get;set;}
    public Id jobRoleId;
    public Id accountId;
    public Id sectorId;
    public Id jobCategory;
    public boolean saveNew;
     public Boolean displayalert{get;set;}
    public sirenum__Team__c job;
     public Boolean displayPage{get;set;}
      public Id getjobroleId{get;set;}
    public List<sirenum__Site__c> accountSite =new List<sirenum__Site__c> ();
    
   // public List<competancyWrapper>  conpetancyWrapperToDisplay{get;set;}
    private static final string lightningTheme ='Theme4d';

// Simple accessors for the System.UserInfo theme methods
    public String getContextUserUiThemeDisplayed() {
        return UserInfo.getUiThemeDisplayed();
    }

    public CompetencyConditionJobRoleController(ApexPages.StandardController controller){
        check = false;
        jobRoleId= ApexPages.CurrentPage().getparameters().get('Id');
        getjobroleId = jobRoleId;
        system.debug('Id--->'+jobRoleId );
        newCompetency = new sirenum__Sirenum_Condition_Membership__c ();
        saveNew=false;
        
        sirenum__Team__c jobRole = [select id, sirenum__Account__r.sirenum__Client__c , sirenum__Rota__c , sirenum__Job_Type__c from sirenum__Team__c where id = :jobRoleId];
        accountId = jobRole.sirenum__Account__r.sirenum__Client__c;
        sectorId = jobRole.sirenum__Rota__c;
        jobCategory = jobRole.sirenum__Job_Type__c;
        competency =[Select Id,sirenum__Site__c ,sirenum__TicketType__c , sirenum__Severity__c ,sirenum__Team__c ,sirenum__Job_Type__c ,sirenum__Rota__c , sirenum__Client__c from sirenum__Sirenum_Condition_Membership__c where (sirenum__Team__c =:jobRoleId) or (sirenum__Job_Type__c=:jobCategory AND sirenum__Team__c = Null) or (sirenum__Rota__c=:sectorId AND sirenum__Team__c = NULL AND sirenum__Job_Type__c = NULL) or (sirenum__Client__c=:accountId AND  sirenum__Rota__c = NULL AND sirenum__Team__c = NULL AND sirenum__Job_Type__c = NULL) order  by sirenum__TicketType__r.name asc , sirenum__Severity__c asc] ;
        //map<Id,sirenum__Sirenum_Condition_Membership__c> competancyMap=new map<Id,sirenum__Sirenum_Condition_Membership__c>([Select Id,sirenum__Site__c ,sirenum__TicketType__c , sirenum__Severity__c ,sirenum__Team__c ,sirenum__Job_Type__c ,sirenum__Rota__c , sirenum__Client__c from sirenum__Sirenum_Condition_Membership__c where (sirenum__Team__c =:jobRoleId) or (sirenum__Job_Type__c=:jobCategory AND sirenum__Team__c = Null) or (sirenum__Rota__c=:sectorId AND sirenum__Team__c = NULL AND sirenum__Job_Type__c = NULL) or (sirenum__Client__c=:accountId AND  sirenum__Rota__c = NULL AND sirenum__Team__c = NULL AND sirenum__Job_Type__c = NULL) order  by sirenum__TicketType__r.name asc , sirenum__Severity__c asc ]); 
        siteCompetency =[Select id, sirenum__Site__c ,sirenum__TicketType__c , sirenum__Severity__c ,sirenum__Team__c ,sirenum__Job_Type__c ,sirenum__Rota__c , sirenum__Client__c from sirenum__Sirenum_Condition_Membership__c where sirenum__Site__r.sirenum__Operating_Company__c =:accountId AND sirenum__Team__c = Null AND sirenum__Job_Type__c = Null AND sirenum__Rota__c = Null AND sirenum__Client__c = Null order  by sirenum__TicketType__r.name asc , sirenum__Severity__c asc];
        accountSite=[Select id , name from sirenum__Site__c where sirenum__Operating_Company__c =:accountId];
        system.debug('accountSite'+accountSite);
        displayPageCallFunction();
        
            }
           // displayWrapper=getWrapperToDisplay(competancyMap,accountSite);   
    
    /*
    public List<competancyWrapper> getWrapperToDisplay(map<Id,sirenum__Sirenum_Condition_Membership__c> competancyMap,List<sirenum__Site__c> accountSite){
        List<competancyWrapper> wrapperToDisplay=new List<competancyWrapper>();
        if(competancyMap!=null && accountSite!=null){
            Integer competancyMapSize=competancyMap.size();
            Integer accountSiteListSize=accountSite.size();
            Integer count=0;
            if(competancyMapSize>accountSiteListSize){
                for(sirenum__Sirenum_Condition_Membership__c comp:competancyMap.values()){
                    competancyWrapper tempWrapper=new competancyWrapper();   
                    tempWrapper.competancy=comp;
                    if(count<accountSiteListSize){
                        tempWrapper.siteName=accountSite[count].Name;
                    }
                    wrapperToDisplay.add(tempWrapper);
                    count++;
                }
            }
            else if(competancyMapSize<accountSiteListSize){
                List<sirenum__Sirenum_Condition_Membership__c> competancyList=competancyMap.values();
                for(sirenum__Site__c site :accountSite){                    
                    competancyWrapper tempWrapper=new competancyWrapper();   
                    tempWrapper.siteName= site.name;
                    if(count<competancyMapSize){
                        tempWrapper.competancy=competancyList[count];
                    }
                    wrapperToDisplay.add(tempWrapper);
                    count++;                       
                }
                
            }
            else if(competancyMapSize==accountSiteListSize){
                for(sirenum__Sirenum_Condition_Membership__c comp:competancyMap.values()){
                    competancyWrapper tempWrapper=new competancyWrapper();   
                    tempWrapper.competancy=comp;
                    tempWrapper.siteName=accountSite[count].Name;                    
                    wrapperToDisplay.add(tempWrapper);
                    count++;
                }    
            }
            return wrapperToDisplay;
        }  
        else if(accountSite==null){
            for(sirenum__Sirenum_Condition_Membership__c comp:competancyMap.values()){
                competancyWrapper tempWrapper=new competancyWrapper();   
                tempWrapper.competancy=comp;
                wrapperToDisplay.add(tempWrapper);
            }
            return wrapperToDisplay;
        }
        return wrapperToDisplay;
    }    
    */
      public void displayPageCallFunction(){
       system.debug('@@ '+accountId );   
       Id profileId = [Select id from Profile where Name='System Administrator'].id;
        
        List<PermissionSetAssignment> permissionSet = new List<PermissionSetAssignment>();
           List<Account> nationalAccount = [select IP_CompetencyRestriction__c from Account where id =: accountId ];
         try{
            permissionSet = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSet.Name IN ('National_Regional_Managers','Branch_Managers') AND AssigneeId = :UserInfo.getUserId()];
     //  permissionSet = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSet.Name IN ('Branch_Managers') AND AssigneeId = :UserInfo.getUserId()];     
            displayPage = false;
            displayalert = false;
            if( nationalAccount[0].IP_CompetencyRestriction__c==true){
              if (!permissionSet.isEmpty() || profileId==Userinfo.getProfileId()){
                displayPage = true;
            }
            else{
                displayPage = false;
                displayalert = true;
            }
            }else{    displayPage = true;}
        }
        Catch(Exception e){
            displayalert = true;
        }
        System.debug('@@ displayalert '+displayalert); 
        
        
        
    }
    public void clearvalidationWarning(){
        
        validationWarning = '';
        
    }
    //
    /** Validates record if it consists of any related Competency **/
    //
  public void onloadaction()
  {
   System.debug('IN of onload ');
       Id userid = UserInfo.getUserId();
     List<Account> nationalAccount = [select IP_CompetencyRestriction__c from Account where id =: accountId ];
        List<PermissionSetAssignment> AssignmentId = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Branch_Managers' AND AssigneeId =:userid]; 
       
      
       if((nationalAccount[0].IP_CompetencyRestriction__c==true) && (AssignmentId.size() > 0))
        {
        System.debug('IN IF of onload ');
            check = true;
        }           
  
  }  
    public pageReference validateRecord(){
        Id userid = UserInfo.getUserId();
        system.debug('user Id------>' +userid);
        set<Id> accountSiteSet = new set<Id>();
        for(sirenum__Site__c relatedSite :accountSite )
        {
            accountSiteSet.add(relatedSite.id);
        }
        newCompetency.sirenum__Team__c = jobRoleId;
        sirenum__Sirenum_Condition_Membership__c[] relatedExistingCompetency = [select id , sirenum__TicketType__r.name ,sirenum__Severity__c,sirenum__Job_Type__r.name ,sirenum__Rota__r.name from sirenum__Sirenum_Condition_Membership__c where  ( sirenum__Job_Type__c=:jobCategory or sirenum__Rota__c=:sectorId ) and sirenum__TicketType__c =:newCompetency.sirenum__TicketType__c and sirenum__Severity__c  =:newCompetency.sirenum__Severity__c ] ;
        sirenum__Sirenum_Condition_Membership__c[] existingCompetency = [select id , sirenum__TicketType__c ,sirenum__Team__r.id ,sirenum__Severity__c  from sirenum__Sirenum_Condition_Membership__c where sirenum__Team__r.id =:newCompetency.sirenum__Team__c and sirenum__TicketType__c =:newCompetency.sirenum__TicketType__c and sirenum__Severity__c =:newCompetency.sirenum__Severity__c];            
        List<Account> nationalAccount = [select IP_CompetencyRestriction__c from Account where id =: accountId ];
        List<PermissionSetAssignment> AssignmentId = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Branch_Managers' AND AssigneeId =:userid]; 
        system.debug('Assignment Id------>' +AssignmentId.size());
        system.debug('sirenum__Site__c------>' +newCompetency.sirenum__Site__c);
        
        if((nationalAccount[0].IP_CompetencyRestriction__c==true) && (AssignmentId.size() > 0))
        {
       
            if(newCompetency.sirenum__Site__c == null)
            {
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, 'Site cannot be blank for National Account') );
                return null; 
                
            }
            else
            {
                if(accountSiteSet.contains(newCompetency.sirenum__Site__c)==false)
                {
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, ' Selected Site should be against the Account related to the Job Role ') );
                    return null; 
                    
                }
                
            }
            
        }
        if(existingCompetency.size() > 0)
        {
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, 'Competency Condition already exists') );
            return null;
        }
        else if(relatedExistingCompetency.size() > 0)
        {
            if(relatedExistingCompetency[0].sirenum__Job_Type__r.name==Null )
                validationWarning = 'The Competency Condition you’re creating is already fulfilled by the following existing competencies. Are you sure you want to continue?'+'\\n\\n'+'Competency: '+relatedExistingCompetency[0].sirenum__TicketType__r.name+'\\n'+'Severity:  '+relatedExistingCompetency[0].sirenum__Severity__c+'\\n'+'Applied Level:  '+relatedExistingCompetency[0].sirenum__Rota__r.name;
            else if(relatedExistingCompetency[0].sirenum__Rota__r.name==Null)
                validationWarning = 'The Competency Condition you’re creating is already fulfilled by the following existing competencies. Are you sure you want to continue?'+'\\n\\n'+'Competency: '+relatedExistingCompetency[0].sirenum__TicketType__r.name+'\\n'+'Severity:  '+relatedExistingCompetency[0].sirenum__Severity__c+'\\n'+'Applied Level:  '+relatedExistingCompetency[0].sirenum__Job_Type__r.name;
            else 
                validationWarning = 'The Competency Condition you’re creating is already fulfilled by the following existing competencies. Are you sure you want to continue?'+'\\n\\n'+'Competency: '+relatedExistingCompetency[0].sirenum__TicketType__r.name+'\\n'+'Severity:  '+relatedExistingCompetency[0].sirenum__Severity__c+'\\n'+'Applied Level:  '+relatedExistingCompetency[0].sirenum__Rota__r.name+','+relatedExistingCompetency[0].sirenum__Job_Type__r.name;
            
            return null;    
            
        } 
        else{
            clearvalidationWarning();
            PageReference pg=save(); 
            return pg;
        }
    }
    //
    /** Save record after validation **/
    //
    
    Public pageReference save()
    {
        try{  
            newCompetency.sirenum__Team__c = jobRoleId;
            newCompetency.RedirectField__c = jobRoleId;
            system.debug('New Competency ----->' +newCompetency);   
            insert newCompetency;
            System.debug('insert successful');
            PageReference pageRef;
            if(!saveNew){
                        String getLightning = getContextUserUiThemeDisplayed();
            if(lightningTheme.equals(getLightning)){
             pageRef = new pageReference('/lightning/r/sirenum__Team__c/'+jobRoleId+'/view'); 
                        }
                        else{
                         pageRef = new pageReference('/'+jobRoleId); 
                        }
            
            
               //
                pageRef.setRedirect(true);
                //system.debug('pageRef'+pageRef);
               
            }
            else if(saveNew){
                pageRef = new pageReference('/apex/CompetencyConditionsAgainstJobRole?id='+jobRoleId); 
                system.debug('pageRef'+pageRef);
                pageRef.setRedirect(true);
                
            }
            
            return pageRef;
        }
        
        
        
        catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()); ApexPages.addMessage(msg);   return null;
           
         
        }
    }
    public pageReference saveNew()
    {
        saveNew=true;
        pageReference pg=validateRecord();
        return pg;
    }
    /*
    public class competancyWrapper{
        public sirenum__Sirenum_Condition_Membership__c competancy{get;set;}
        public String siteName{get;set;}
        public competancyWrapper(){
            competancy=new sirenum__Sirenum_Condition_Membership__c();
        }
    }*/
}