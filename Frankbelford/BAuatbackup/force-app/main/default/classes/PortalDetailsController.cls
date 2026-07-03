public class PortalDetailsController {
    public Id recipient_Id{get;set;}
    public Id relatedTo_Id{get;set;}
    Public String branchname{get;set;}
    Public String phonenumber{get;set;}
    Public String startDateString1{get;set;}
    Public String startEndString1{get;set;}
    Public String consultantName{get;set;}
    Public String Query{get;set;}
    private contact Condetails {get;set;}
    public string linkdinurl{set;get;}
    public string facebookurl{set;get;}
    public string twitterurl{set;get;}
    public string youtube{set;get;}
    public string ipflaturl{set;get;}
    public string logourl{set;get;}
    public string backgroundurl{set;get;}
    public PortalDetailsController()
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
    public  contact getConDetails()
    {
        Condetails = [Select id,owner.name,name, firstname,QueryDescription__c ,IP_TempestDepartment__c,HolidayStartDate__c,
                      HolidayEndDate__c from contact where id =:recipient_Id];
        String department = Condetails.IP_TempestDepartment__c;
        IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department);
        branchname = shiftemp.IP_Site_Name__c;
        phonenumber = shiftemp.Phone__c;
        startDateString1=Condetails.HolidayStartDate__c;
        startEndString1=Condetails.HolidayEndDate__c;
        Query=Condetails.QueryDescription__c;
        consultantName=Condetails.owner.name;
        return Condetails;
        
    }
}