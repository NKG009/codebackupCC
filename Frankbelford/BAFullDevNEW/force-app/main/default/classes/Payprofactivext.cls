public class Payprofactivext{
    
    private final Contact cont; //contact
   private Apexpages.StandardController stdController;
    public List<wraperpp> ppList {get; set;} 
   public  Boolean status;
    
   public Payprofactivext(ApexPages.StandardController stdController) 
   {
       this.stdController=stdController;
        this.cont = (Contact)stdController.getRecord();
   }
    
    
/* this is payprofile section to display payprofile opration */  
    
   public List<wraperpp> getpayprofile() 
    {
      
            ppList = new List<wraperpp>();
            for(IP_PayProfile__c paylist: [select id,IP_Candidate__r.New_Starter_Form__c,IP_Candidate__r.TOE_Completed__c,IP_Candidate__r.IP_StudentLoan__c,IP_Candidate__r.IP_WorkerStartDate__c,IP_Candidate__r.Reason_for_P45__c,IP_Candidate__r.IP_WorkerLeavingDate__c,IP_Candidate__r.P45_Date_by_Head_Office__c,IP_Candidate__r.Reason_for_Leaving1__c,IP_Candidate__r.P45_Requested__c,RecordType.name, Name, IP_PrimaryPayMethod__c from  IP_PayProfile__c 
                                      WHERE IP_Status__c='InActive' AND IP_Candidate__c=:this.cont.Id]){
                ppList.add(new wraperpp(paylist));
            }  
        If(ppList.size()>0)
        {
            status = true;
            return ppList; 
        }
        else
        {
            if(status ==false)
            {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'There is no Inactive Pay Profile for this Candidate, Please close the window'));
            
            }return ppList;
        }
    } 
    
   public class wraperpp 
    {
        public IP_PayProfile__c conp {get; set;}
        public Boolean selected {get; set;}
        public wraperpp(IP_PayProfile__c paylist) 
        {
            conp = paylist;
            selected = false;
        }
    }
/* this is payprofile section to display payprofile opration */  
    
    public PageReference Finish(){

       List<IP_PayProfile__c> paywrap = new List<IP_PayProfile__c>();
       List<IP_PayProfile__c> payUpdate = new List<IP_PayProfile__c>();
       
        for(wraperpp pCon: ppList) 
        {
           System.debug('## '+pCon.selected);   
            if(pCon.selected == true ) 
            {
            
                paywrap.add(pCon.conp);
            }
             
        }
        Set<Id> cont = new Set<Id>();
        List<Contact> conlist = new List<Contact>();
               for(IP_PayProfile__c cons: paywrap) {
            cons.IP_Status__c='Active';
            cons.P45_Date_by_Head_Office__c=null;
            cons.P45_Requested__c=false;
            cons.Date_P45_Requested__c=null;
            cons.Reason_for_P45_Internal__c=null;
            cons.Reason_for_Leaving1__c = null;
            cons.P45_Initiated__c=false;
            cons.IP_PassToTempest__c=false;
            cons.IP_NewStarterTaxStatus__c =null;
            cons.IP_StudentLoan__c =null; 
            cons.IP_LastPassedToTempest__c=null; 
            payUpdate.add(cons);
            cont.add(cons.IP_Candidate__c);
        }
        
        
         for(Contact con : [Select id, P45_Requested__c,Sync_Pay_Profile__c,Sync_Pay_Profile2__c, Reason_for_Leaving1__c,P45_Date_by_Head_Office__c,IP_WorkerLeavingDate__c,Reason_for_P45__c,IP_WorkerStartDate__c,IP_StudentLoan__c,New_Starter_Form__c,TOE_Completed__c from Contact where id in : cont])
         {
            con.P45_Requested__c = false;
            con.Reason_for_Leaving1__c=null;
            con.P45_Date_by_Head_Office__c=null;
            con.IP_WorkerLeavingDate__c=null;
            con.Reason_for_P45__c=null;
            con.IP_WorkerStartDate__c=null;
            con.Student__c=false;
            con.TOE_Completed__c=false;
            con.New_Starter_Form__c=false;
            con.Sync_Pay_Profile__c = false; 
            con.Sync_Pay_Profile2__c = false;
             conlist.add(con);
         }

   
        If(pplist.size()>0)
        {
        if(payUpdate.size()>0)
        {
              update payUpdate;
            update conlist;
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Successfully Activated'));
           
           status =true;
              system.debug('@@## '+status);
        }else{
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please choose one option'));
        }
        }
            else 
            {
                system.debug('@@ '+status);
              
                {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'There is no Inactive Pay Profile for this Candidate, Please close the window'));
                }
            }
        
        return null;
    }
    
    public PageReference closeme() 
    {
       
        return null;
    }
    
}