public class RestrictDeleteActionController
{
public  String Iddel;
public  String parentId;
public String reportsURL{get; set; } 
public String BackURL{get; set; } 
public String urlparent;
public String urlparent2;
public Boolean check{get; set;}
public String JObroleID{get; set; } 
 private static final string lightningTheme ='Theme4d';

    public RestrictDeleteActionController(ApexPages.StandardController controller) {
check = false;
System.debug('URL2 '+ApexPages.currentPage().getParameters().get('retURL'));
System.debug('URLID '+ApexPages.currentPage().getParameters().get('ID'));


Iddel = ApexPages.currentPage().getParameters().get('id');
parentId = ApexPages.currentPage().getParameters().get('retURL');

urlparent = Label.Instance_URL;
 urlparent2 =Label.Instance_URLLightning;
System.debug('@@Iddel  '+Iddel );
system.debug('urlparent '+urlparent );
    }
    
    public void deletemethod()
    { 
     String startId;
     String getLightning = getContextUserUiThemeDisplayed();
    system.debug('parentId '+parentId );
     List<String> jobId;
    
      if(String.isEmpty(parentId)){
      List<sirenum__Sirenum_Condition_Membership__c> complist = [Select id,RedirectField__c,sirenum__Client__c,sirenum__Site__c,sirenum__Team__c from sirenum__Sirenum_Condition_Membership__c where id =: Iddel];
      System.debug('@@complist   '+complist );
          if(String.isEmpty(complist[0].RedirectField__c)){
                if(!String.isEmpty(complist[0].sirenum__Client__c)){
                    JObroleID = complist[0].sirenum__Client__c;
                }
                else if(String.isEmpty(complist[0].sirenum__Client__c) && !String.isEmpty(complist[0].sirenum__Site__c) && String.isEmpty(complist[0].sirenum__Team__c)){
                    JObroleID = complist[0].sirenum__Site__c;
                }
                else if(!String.isEmpty(complist[0].sirenum__Team__c)){                    JObroleID = complist[0].sirenum__Team__c;
                }
            }
            else{
                JObroleID= String.ValueOf(complist[0].RedirectField__c );
            }
      }else{system.debug('@@parentId'+parentId);
      if(parentId.contains('/')){
            jobId = parentId.split('/'); JObroleID = jobId[1];
        }
      else{JObroleID = parentId;}}
     system.debug('@@jobId '+jobId);
       system.debug('JObroleID '+JObroleID );
 List<PermissionSetAssignment> perm = [SELECT Id,PermissionSetId,PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId =: UserInfo.getUserId() and (PermissionSet.Name = 'Branch_Managers' OR PermissionSet.Name = 'National_Regional_Managers')];
 List<sirenum__Team__c> jobrole = [Select id,name,sirenum__Account__r.sirenum__Client__r.IP_CompetencyRestriction__c from sirenum__Team__c where id =: JObroleID  Limit 1];
    system.debug('jobrole '+jobrole );
  
  startId = JObroleID.substring(0,3);
     system.debug('startId '+startId );   
  Profile p = [Select id from Profile where name = 'System Administrator'];   
  System.debug('@@ '+UserInfo.getProfileId());   
  sirenum__Sirenum_Condition_Membership__c sc = [Select id,sirenum__Team__c,sirenum__Site__c from sirenum__Sirenum_Condition_Membership__c where id =: Iddel limit 1];

   if((startId == 'a3I' || startId == 'a2w') && UserInfo.getProfileId() == p.Id)
   {
       //Sector and category
       delete sc;  
        if(lightningTheme.equals(getLightning)){         reportsURL = urlparent2+JObroleID;}         else{   reportsURL = urlparent+JObroleID;}


    }
 
   else if((startId == 'a3j' || startId == 'a3e') && (UserInfo.getProfileId() == p.Id || (perm.size()>0 && (perm[0].PermissionSet.Name== 'National_Regional_Managers' || perm[0].PermissionSet.Name== 'Branch_Managers') )) ) 
   {
   //JobRole and Sector
   if(jobrole.size()>0 && jobrole[0].sirenum__Account__r.sirenum__Client__r.IP_CompetencyRestriction__c == True )
   {
       if(perm.size()>0 && perm[0].PermissionSet.Name== 'Branch_Managers' )
       {
            if(sc.sirenum__Team__c!=null && sc.sirenum__Site__c !=null)
            {
            delete sc;          if(lightningTheme.equals(getLightning)){         reportsURL = urlparent2+JObroleID;}
         else{   reportsURL = urlparent+JObroleID;}

             }
              else
               {
                    check = true;                    BackURL= urlparent+JObroleID;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You do not have permissions to delete this record. Please contact the system administrator if you wish to delete this record. Click on the back button to return to the previous page');                    ApexPages.addMessage(myMsg);
    
               }
       }
       else 
       {
              delete sc;
           
                 if(lightningTheme.equals(getLightning)){         reportsURL = urlparent2+JObroleID;}
         else{   reportsURL = urlparent+JObroleID;}

       }
      
   }
   else
   {
            delete sc;     if(lightningTheme.equals(getLightning)){         reportsURL = urlparent2+JObroleID;}         else{   reportsURL = urlparent+JObroleID;}
            
            
   }
       
   }
   else if(startId == '001' && (UserInfo.getProfileId() == p.Id || (perm.size()>0 && perm[0].PermissionSet.Name== 'National_Regional_Managers' )) )
   {
   //Account
            delete sc;
           if(lightningTheme.equals(getLightning)){
         reportsURL = urlparent2+JObroleID;}
         else{   reportsURL = urlparent+JObroleID;}   
   }
    else
    {
            check = true;
            BackURL= urlparent+parentId ;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You do not have permissions to delete this record. Please contact the system administrator if you wish to delete this record. Click on the back button to return to the previous page');
            ApexPages.addMessage(myMsg);
    }
            
    }
      public String getContextUserUiThemeDisplayed() {
        return UserInfo.getUiThemeDisplayed();
    }
     public PageReference move()
    {
      PageReference pageRef;
     String getLightning = getContextUserUiThemeDisplayed();
            if(lightningTheme.equals(getLightning)){
             pageRef = new pageReference('/lightning/r/sirenum__Team__c/'+jobRoleId+'/view'); 
                        }
                        else{
                         pageRef = new pageReference('/'+jobRoleId); 
                        }
       // PageReference pageRef = new PageReference( urlparent+parentId ); 
        pageRef.setRedirect(true); 
        return pageRef;
    } 
   
    
}