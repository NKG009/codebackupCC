/** JIRA 1307 - Branch Manager Access to Competency Conditions **/
/** for Visual Force Page CompetencyConditionAgainstAccount **/
/** Date - 24-12-2018 **/

public class CompetencyConditionAccountController {
    
    public list<sirenum__Sirenum_Condition_Membership__c> competency{get;set;}
   // public list<sirenum__Sirenum_Condition_Membership__c> siteCompetency{get;set;}
    public sirenum__Sirenum_Condition_Membership__c newCompetency{get;set;}
  //  public List<competancyWrapper> displayWrapper{get;set;}
   // public Boolean causeValidationWarning {get; set;}
    public String validationWarning {get; set;}
    public boolean saveNew;
    public list<sirenum__Team__c> jobCategoryId = new list<sirenum__Team__c>();
    public list<sirenum__Team__c> sectorId = new list<sirenum__Team__c>();
    public Id AccountId;
    public set<Id> jobCategoryIdSet = new set<Id>();
    public set<Id> sectorIdSet = new set<Id>();
    public Boolean displayPage{get;set;}
    public Boolean displayalert{get;set;}
    public Id getAccountId{get;set;}
    sirenum__Team__c job;
    private static final string lightningTheme ='Theme4d';

    // Simple accessors for the System.UserInfo theme methods
    public String getContextUserUiThemeDisplayed() {
        return UserInfo.getUiThemeDisplayed();
    }
    
   // public List<competancyWrapper>  conpetancyWrapperToDisplay{get;set;}
    
    public CompetencyConditionAccountController(ApexPages.StandardController controller){
        
        AccountId= ApexPages.CurrentPage().getparameters().get('Id');
        getAccountId = AccountId;
        system.debug('Id--->'+AccountId );
        newCompetency = new sirenum__Sirenum_Condition_Membership__c ();
        saveNew=false;
        jobCategoryId = [select sirenum__Job_Type__r.id from sirenum__Team__c where sirenum__Account__r.sirenum__Client__c =:AccountId ];
        sectorId=[select sirenum__Rota__r.id from sirenum__Team__c where sirenum__Account__r.sirenum__Client__c =:AccountId ];
        for(sirenum__Team__c jobCatId :jobCategoryId )
        {
            jobCategoryIdSet.add(jobCatId.sirenum__Job_Type__r.id);
        }
        for(sirenum__Team__c secId :sectorId )
        {
            sectorIdSet.add(secId.sirenum__Rota__r.id);
        }
        system.debug('Lists ----->' +sectorIdSet);
       // map<Id,sirenum__Sirenum_Condition_Membership__c> competancyMap=new map<Id,sirenum__Sirenum_Condition_Membership__c>([Select Id,sirenum__Site__c ,sirenum__TicketType__c , sirenum__Severity__c ,sirenum__Team__c ,sirenum__Job_Type__c ,sirenum__Rota__c , sirenum__Client__c from sirenum__Sirenum_Condition_Membership__c where (sirenum__Site__r.sirenum__Operating_Company__c=:AccountId) or( sirenum__Team__r.sirenum__Account__r.sirenum__Client__c=:AccountId and sirenum__Site__r.sirenum__Operating_Company__c=:AccountId)  or (sirenum__Client__c =:AccountId) or (sirenum__Job_Type__c  In :jobCategoryIdSet and sirenum__Site__c = Null and sirenum__Client__c = Null and sirenum__Team__c = Null) or
                         //                                                                                                   (sirenum__Rota__c In :sectorIdSet and sirenum__Job_Type__c = Null and sirenum__Site__c = Null and sirenum__Client__c = Null and sirenum__Team__c = Null ) order  by sirenum__TicketType__c asc , sirenum__Severity__c asc ]); 
        competency= [Select Id,sirenum__Site__c ,sirenum__TicketType__c , sirenum__Severity__c ,sirenum__Team__c ,sirenum__Job_Type__c ,sirenum__Rota__c , sirenum__Client__c from sirenum__Sirenum_Condition_Membership__c where (sirenum__Site__r.sirenum__Operating_Company__c=:AccountId) or( sirenum__Team__r.sirenum__Account__r.sirenum__Client__c=:AccountId and sirenum__Site__r.sirenum__Operating_Company__c=:AccountId)  or (sirenum__Client__c =:AccountId) or (sirenum__Job_Type__c  In :jobCategoryIdSet and sirenum__Site__c = Null and sirenum__Client__c = Null and sirenum__Team__c = Null) or
                                                                                                                            (sirenum__Rota__c In :sectorIdSet and sirenum__Job_Type__c = Null and sirenum__Site__c = Null and sirenum__Client__c = Null and sirenum__Team__c = Null ) order  by sirenum__TicketType__c asc , sirenum__Severity__c asc ];
        List<sirenum__Site__c> accountSite=[Select name from sirenum__Site__c where sirenum__Operating_Company__c =:AccountId];
       // system.debug('Map------>' +competancyMap);
        system.debug('Map------>' +accountSite);
        
       // if(competancyMap.size()>0)
          //  displayWrapper=getWrapperToDisplay(competancyMap,accountSite);   
    }
    
    public void displayPageCallFunction(){
        Id profileId = [Select id from Profile where Name='System Administrator'].id;
        
        List<PermissionSetAssignment> permissionSet = new List<PermissionSetAssignment>();
        
        try{
            permissionSet = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSet.Name = 'National_Regional_Managers' AND AssigneeId = :UserInfo.getUserId()];
            
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
    } */
    public void clearvalidationWarning(){
        
        validationWarning = '';
        
    }
    //
    /** Validates record if it consists of any related Competency **/
    //
    public pageReference validateRecord(){
        newCompetency.sirenum__Client__c = AccountId;
        //List<sirenum__Sirenum_Condition_Membership__c> relatedExistingCompetency = [select id , sirenum__TicketType__r.name ,sirenum__Severity__c , sirenum__Client__r.name ,sirenum__Job_Type__r.name ,sirenum__Site__r.name ,sirenum__Team__r.name from sirenum__Sirenum_Condition_Membership__c where ( sirenum__Site__r.sirenum__Operating_Company__c=:AccountId or sirenum__Team__r.sirenum__Account__r.sirenum__Client__c=:AccountId ) and sirenum__TicketType__c =:newCompetency.sirenum__TicketType__c and sirenum__Severity__c  =:newCompetency.sirenum__Severity__c ] ;
        List<sirenum__Sirenum_Condition_Membership__c> existingCompetency = [select id , sirenum__TicketType__c ,sirenum__Client__r.id ,sirenum__Severity__c  from sirenum__Sirenum_Condition_Membership__c where sirenum__Client__r.id =:newCompetency.sirenum__Client__c and sirenum__TicketType__c =:newCompetency.sirenum__TicketType__c and sirenum__Severity__c =:newCompetency.sirenum__Severity__c];            
        if(existingCompetency.size() > 0)
        {
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, 'Competency Condition already exists') );
            return null;
        }
        /*
        else if(relatedExistingCompetency.size() > 0)
        {
            if(relatedExistingCompetency[0].sirenum__Site__r.name==Null) 
                validationWarning = 'The Competency Condition you’re creating is already fulfilled by the following existing competencies. Are you sure you want to continue?'+'\\n\\n'+'Competency: '+relatedExistingCompetency[0].sirenum__TicketType__r.name+'\\n'+'Severity:  '+relatedExistingCompetency[0].sirenum__Severity__c+'\\n'+'Applied Level:  '+relatedExistingCompetency[0].sirenum__Team__r.name;
            if(relatedExistingCompetency[0].sirenum__Team__r.name==Null )
                validationWarning = 'The Competency Condition you’re creating is already fulfilled by the following existing competencies. Are you sure you want to continue?'+'\\n\\n'+'Competency: '+relatedExistingCompetency[0].sirenum__TicketType__r.name+'\\n'+'Severity:  '+relatedExistingCompetency[0].sirenum__Severity__c+'\\n'+'Applied Level:  '+relatedExistingCompetency[0].sirenum__Site__r.name;
            else
                validationWarning = 'The Competency Condition you’re creating is already fulfilled by the following existing competencies. Are you sure you want to continue?'+'\\n\\n'+'Competency: '+relatedExistingCompetency[0].sirenum__TicketType__r.name+'\\n'+'Severity:  '+relatedExistingCompetency[0].sirenum__Severity__c+'\\n'+'Applied Level:  '+relatedExistingCompetency[0].sirenum__Team__r.name+','+relatedExistingCompetency[0].sirenum__Site__r.name;
            return null;    
            
        }*/
        else{
            clearvalidationWarning();
            PageReference pg=save(); 
            return pg;
        }           
        
        
    }
    //
    /** Save record after validation **/
    //
    Public pageReference Save()
    {
        try{  
            newCompetency.sirenum__Client__c = AccountId;
            newCompetency.RedirectField__c = AccountId;
            system.debug('New Competency ----->' +newCompetency);   
            insert newCompetency;
            System.debug('insert successful');
            PageReference pageRef;
            if(!saveNew){
                String getLightning = getContextUserUiThemeDisplayed();
                if(lightningTheme.equals(getLightning)){
                    pageRef = new pageReference('/lightning/r/Account/'+AccountId+'/view');
                 }
                 else{
                     pageRef = new pageReference('/'+AccountId); 
                 }
                system.debug('pageRef'+pageRef);
                pageRef.setRedirect(true);
            }
            else if(saveNew){
                pageRef = new pageReference('/apex/CompetencyConditionsAgainstAccount?id='+AccountId); 
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