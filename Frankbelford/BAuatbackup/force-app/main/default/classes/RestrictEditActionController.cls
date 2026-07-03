public class RestrictEditActionController
{
public  String Iddel;

    public String urlparent;
    public String urlparent2;
    public string lightningTheme;
    public  String parentId;
    public String reportsURL{get; set; } 
    public String BackURL{get; set; } 
    public Boolean check{get; set;}
    public sirenum__Sirenum_Condition_Membership__c records {get; set;}

   
        public RestrictEditActionController(ApexPages.StandardController controller) {
    check = false;
    lightningTheme ='Theme4d';
    urlparent = Label.Instance_URL;
    urlparent2 =Label.Instance_URLLightning;
      parentId = ApexPages.currentPage().getParameters().get('retURL');
    
    Iddel = ApexPages.currentPage().getParameters().get('id');
  
    System.debug('ID '+Iddel );
    System.debug('parentId ID '+parentId ); 
    
      records = [Select name,sirenum__Client__c,sirenum__Team__c,sirenum__Site__c,sirenum__Rota__c,sirenum__Job_Type__c,sirenum__Severity__c,sirenum__TicketType__c,sirenum__Notification_Email__c from sirenum__Sirenum_Condition_Membership__c where id =: Iddel ];
        }
        
    public void deletemethod()
    { 
            
                Profile p = [Select id from Profile where name = 'System Administrator'];              
                if(UserInfo.getProfileId() == p.Id )
                {   
    //   List<String> recordID= parentId.split('/');
              //   https://cs106.salesforce.com/a3Y0D000000ZZBX/e?retURL=%2Fa3e0D0000008btm
      //              reportsURL = urlparent +'/'+Iddel +'/e?retURL=%2F'+recordID[1] ;      
                }
                else
                {
                    check = true;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You do not have permissions to edit this record. Please contact the system administrator if you wish to edit this record. Click on the back button to return to the previous page');
                    ApexPages.addMessage(myMsg);
                }
                
    }
     public PageReference move()
    {
    lightningTheme ='Theme4d';
    string completeUrl;
    System.debug('parentId ID '+parentId ); 
            if(lightningTheme.equals(UserInfo.getUiThemeDisplayed())){
           // sirenum__Sirenum_Condition_Membership__c sjobrole = [Select sirenum__Team__r.id from sirenum__Sirenum_Condition_Membership__c where id =: Iddel ];
          //  parentId = sjobrole.sirenum__Team__r.id;
            completeUrl = urlparent2+parentId;
            }
            else{completeUrl = urlparent+parentId;}
            PageReference pageRef = new PageReference( completeUrl ); 
            pageRef.setRedirect(true); 
            return pageRef;
    } 
     public PageReference Updaterecord()
    {
            update records;
             lightningTheme ='Theme4d';
    string completeUrl;
            if(lightningTheme.equals(UserInfo.getUiThemeDisplayed())){
            completeUrl = urlparent2+parentId;
            }
            else{completeUrl = urlparent+parentId;}
            PageReference pageRef = new PageReference( completeUrl ); 
            pageRef.setRedirect(true); 
            return pageRef;
    } 
   
    
}