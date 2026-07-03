public class VFTemplateController {
    public Id recipient_Id{get;set;}
    public Id relatedTo_Id{get;set;}
    Public String startDateString{get;set;}
    Public String startTimeString{get;set;}
    Public String endDateString{get;set;}
    Public String endTimeString{get;set;}
    Public String startDateString1{get;set;}
    Public String startTimeString1{get;set;}
    Public String endDateString1{get;set;}
    Public String endTimeString1{get;set;}
    public Contact recipient {get;set;}
    public String ClientName {get;set;}
    public String JobRole {get;set;}
    public String JobTitle {get;set;}
    public String ConsultName {get;set;}
public String ConFirstName {get;set;}
    public String ConName {get;set;}

    public String SiteName {get;set;}
    public String Query {get;set;}
    public String PlacementCons {get;set;}

    //public string getRecipientId() {return recipient_Id; }
    private sirenum__Shift__c Shiftdetails {get;set;}
    
    public string linkdinurl{set;get;}
    public string facebookurl{set;get;}
    public string twitterurl{set;get;}
    public string youtube{set;get;}
    public string ipflaturl{set;get;}
    public string logourl{set;get;}
    public string backgroundurl{set;get;}
    public VFTemplateController()
    {   
        String instanceName = [select InstanceName from Organization limit 1].InstanceName;
        String orgId = UserInfo.getOrganizationId();
        string linkdindocid = [SELECT Id FROM Document where DeveloperName ='Link_1'].id;
        string facebookdocid = [SELECT Id FROM Document where DeveloperName ='Link_2'].id;
        string twitterdocid = [SELECT Id FROM Document where DeveloperName ='Link_3'].id;
        string youtubedocid = [SELECT Id FROM Document where DeveloperName ='Link_4'].id;
        string logodocid = [SELECT Id FROM Document where DeveloperName ='Logo'].id;
        string ipflatdocid = [SELECT Id FROM Document where DeveloperName ='IP_Flat_19_1'].id;
        string backgroungdocid = [SELECT Id FROM Document where DeveloperName ='largebackground'].id;
        linkdinurl='https://c.'+instanceName+'.content.force.com/servlet/servlet.ImageServer?id='+linkdindocid+'&oid='+orgId;
        facebookurl='https://c.'+instanceName+'.content.force.com/servlet/servlet.ImageServer?id='+facebookdocid+'&oid='+orgId;
        twitterurl='https://c.'+instanceName+'.content.force.com/servlet/servlet.ImageServer?id='+twitterdocid+'&oid='+orgId;
        youtube='https://c.'+instanceName+'.content.force.com/servlet/servlet.ImageServer?id='+youtubedocid+'&oid='+orgId;
        ipflaturl='https://c.'+instanceName+'.content.force.com/servlet/servlet.ImageServer?id='+ipflatdocid+'&oid='+orgId;
        logourl='https://c.'+instanceName+'.content.force.com/servlet/servlet.ImageServer?id='+logodocid+'&oid='+orgId;
        backgroundurl='https://c.'+instanceName+'.content.force.com/servlet/servlet.ImageServer?id='+backgroungdocid+'&oid='+orgId;
        
    }
    
    
    public  sirenum__Shift__c getShiftdetails()
    {
        Shiftdetails =[Select id,sirenum__Placement__r.IP_Consultant1LookupSplitShare__r.name,Description__c,sirenum__site__r.GlobalClientName__r.Name,sirenum__site__r.Name,
                       sirenum__Contact__r.FirstName,sirenum__Scheduled_Start_Time__c,sirenum__Scheduled_End_Time__c,
                       sirenum__Team__r.Name, sirenum__Contact__c,sirenum__Contact__r.Name,
                       sirenum__site__r.IP_MainContact__r.IP_JobTitle__c,sirenum__Contact__r.Owner.Name,
                       sirenum__Billable_Start_Time__c ,sirenum__Billable_End_Time__c from sirenum__Shift__c where id=:relatedTo_Id ];
        system.debug('shift in controller--->'+Shiftdetails.sirenum__Contact__r.Name);
    if(Shiftdetails.sirenum__Scheduled_Start_Time__c!=null && Shiftdetails.sirenum__Scheduled_End_Time__c!=null)
        {
        startDateString1 = Shiftdetails.sirenum__Scheduled_Start_Time__c.format('dd-MM-YYYY');
    startTimeString1 = Shiftdetails.sirenum__Scheduled_Start_Time__c.format('kk:mm:ss');
    endDateString1 = Shiftdetails.sirenum__Scheduled_End_Time__c.format('dd-MM-YYYY');
    endTimeString1 = Shiftdetails.sirenum__Scheduled_End_Time__c.format('kk:mm:ss');
        }
        if(Shiftdetails.sirenum__Billable_Start_Time__c!=null && Shiftdetails.sirenum__Billable_End_Time__c!=null)
        {
    startDateString = Shiftdetails.sirenum__Billable_Start_Time__c.format('dd-MM-YYYY');
    startTimeString = Shiftdetails.sirenum__Billable_Start_Time__c.format('kk:mm:ss');
    endDateString = Shiftdetails.sirenum__Billable_End_Time__c.format('dd-MM-YYYY');
    endTimeString = Shiftdetails.sirenum__Billable_End_Time__c.format('kk:mm:ss');
        }
        
        ClientName=Shiftdetails.sirenum__site__r.GlobalClientName__r.Name;
        JobRole=Shiftdetails.sirenum__Team__r.Name;
        JobTitle=Shiftdetails.sirenum__site__r.IP_MainContact__r.IP_JobTitle__c;
        ConsultName=Shiftdetails.sirenum__Contact__r.Owner.Name;
        ConFirstName=Shiftdetails.sirenum__Contact__r.FirstName;
        ConName=Shiftdetails.sirenum__Contact__r.name;
        SiteName=Shiftdetails.sirenum__site__r.Name;
        Query=Shiftdetails.Description__c;
        PlacementCons=Shiftdetails.sirenum__Placement__r.IP_Consultant1LookupSplitShare__r.name;
        return Shiftdetails;
    }
    
    Public String getcondetail ()
    {
        String conname ;
        Contact con=[select id ,name from contact where id=:recipient_Id];
        conname = con.name;
        return conname;
        
    }
}