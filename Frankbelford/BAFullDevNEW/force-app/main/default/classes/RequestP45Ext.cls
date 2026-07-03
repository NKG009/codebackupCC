public class RequestP45Ext {
    
    private final Contact cont; //contact
    public List<wraperpp> ppList {get; set;} //pay profile
    
    
    public RequestP45Ext(ApexPages.StandardController stdController) 
    {
        this.cont = (Contact)stdController.getRecord();
    }
    
     
    /* this is payprofile section to display payprofile opration */  
    
    public List<wraperpp> getpps() 
    {
        ppList = new List<wraperpp>();
        for(IP_PayProfile__c p: [select id,
                                 RecordType.name, 
                                 Name, 
                                 IP_PrimaryPayMethod__c,
                                 P45_Initiated__c,
                                 IP_Status__c,
                                 Reason_for_P45_Internal__c,
                                 Reason_for_Leaving1__c ,Date_P45_Requested__c
                                 from  IP_PayProfile__c 
                                 where IP_Status__c='Active' and IP_Candidate__c=:this.cont.Id]){
                                     ppList.add(new wraperpp(p));
                                 }  
        return ppList; 
    } 
    
    public class wraperpp 
    {
        public IP_PayProfile__c conp {get; set;}
        public Boolean selected {get; set;}
        public wraperpp(IP_PayProfile__c p) 
        {
            conp = p;
            selected = false;
        }
    }
    /* this is payprofile section to display payprofile opration */  
    
    //manish
    
    public PageReference Finish()
    {
        List<IP_PayProfile__c> ppwrap = new List<IP_PayProfile__c>();
        List<IP_PayProfile__c> ppUpdate = new List<IP_PayProfile__c>();
        
        for(wraperpp pCon: ppList) 
        {  
            if(pCon.selected == true /*|| pCon.conp.RecordType.name=='PAYE'*/) 
            {
                ppwrap.add(pCon.conp);
            }
        }
        for(IP_PayProfile__c cons: ppwrap) {
            cons.P45_Initiated__c=true;
            //cons.IP_Status__c='Inactive';
            //cons.IP_PrimaryPayMethod__c=false;
            cons.Reason_for_P45_Internal__c=cont.Reason_for_P45__c;
            cons.Reason_for_Leaving1__c = cont.Reason_for_Leaving1__c;
            cons.P45_Requested__c=true;
            cons.Date_P45_Requested__c = system.today();
            ppUpdate.add(cons);
        }
        
        if(ppUpdate.size()>0)
        {   
            //cont.Reason_for_Leaving1__c='';
            //cont.Reason_for_P45__c='';
            cont.P45_Requested__c=true;
            cont.IP_WorkerLeavingDate__c=system.today();
            update cont;
            update ppUpdate;
            PageReference pageRef = new PageReference('/apex/RequestP45Page?id=' + cont.id+'&sx=1');
            return pageRef.setRedirect(true);
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'All fields are mandatory!'));
        }
        
        return null;
    }   
    
    public PageReference closeme() 
    {
        return null;
    }
    
    /*
public PageReference cancel() 
{
List<IP_PayProfile__c> ppwrap = new List<IP_PayProfile__c>();
List<IP_PayProfile__c> ppUpdate = new List<IP_PayProfile__c>();

for(wraperpp pCon: ppList) 
{ 
ppwrap.add(pCon.conp);
}
for(IP_PayProfile__c cons: ppwrap) {
cons.P45_Initiated__c=false;
//cons.IP_Status__c='Active';
cons.Reason_for_P45_Internal__c=null;
cons.Reason_for_Leaving1__c = null;
ppUpdate.add(cons);
}
system.debug('all deleted pp records--'+ppUpdate);
if(ppUpdate.size()>0)
{   
cont.Reason_for_Leaving1__c=null;
cont.Reason_for_P45__c=null;
cont.P45_Requested__c=false;
cont.IP_WorkerLeavingDate__c=null;
system.debug('all deleted contact records--'+cont);
update cont;
update ppUpdate;
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Records cancel!'));
}

return null;
}*/
    
}