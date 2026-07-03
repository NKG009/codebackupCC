public class CaptureReasonforLeavingcontroller{

   public String selectedleavingreason{get;set;}
   public String leavingreason{get;set;}
   public String currentRecordId {get;set;}
   List<IP_PayProfile__c> paylist = new List<IP_PayProfile__c>();
   List<IP_PayProfile__c> paylist1 = new List<IP_PayProfile__c>();
    List<Contact> conupdate= new List<Contact>();
    public string check1 {get;set;}
    public string check2 {get;set;}
    public CaptureReasonforLeavingcontroller() {
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        System.debug('Check id'+currentRecordId  );
        check1 = null;
        check2 = null;
    }

   
     public List<selectOption> allleavingreason{
        get {
          List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('Pay - Not Enough','Pay - Not Enough')); 
        options.add(new SelectOption('Pay - Incorrect','Pay - Incorrect')); 
        options.add(new SelectOption('Unsuitable Work','Unsuitable Work')); 
        options.add(new SelectOption('Not Enough Work','Not Enough Work')); 
        options.add(new SelectOption('Work Break','Work Break')); 
        options.add(new SelectOption('Better Opportunity','Better Opportunity')); 
        options.add(new SelectOption('Worker Performance/Compliance Issue','Worker Performance/Compliance Issue')); 
        options.add(new SelectOption('Employed by Client','Employed by Client')); 
        options.add(new SelectOption('Dismissal','Dismissal')); 
        
        return options;        
          }
        set;
    }
    public pagereference processprofiles()
    {
        if(selectedleavingreason == null)
        {
             ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.P45B2Ferror10);
             ApexPages.addMessage(myMsg1);
        }
        else
        {
    paylist = [select id,IP_Status__c,P45_Requested__c,Date_P45_Requested__c,RecordType.name,IP_LastPassedToTempest__c,Reason_for_Leaving1__c,IP_PasstoTempest__c  from IP_PayProfile__c where IP_Status__c = 'Active' and IP_Candidate__c =:currentRecordId];
    
    for(IP_PayProfile__c pay : paylist)
    {
        if(pay.IP_LastPassedToTempest__c == null)
        {
            pay.IP_Status__c = 'Inactive';
            pay.Reason_for_Leaving1__c = selectedleavingreason;
            pay.P45_Requested__c = TRUE;
            pay.Date_P45_Requested__c = System.today();
            check2 = 'false';
            
        }
        else
        {
            if(pay.RecordType.Name == 'PAYE')
            {
                pay.Reason_for_Leaving1__c = selectedleavingreason;
                pay.P45_Requested__c = TRUE;
                pay.Date_P45_Requested__c = System.today();
                pay.IP_PasstoTempest__c = TRUE;
                check1 = 'true';
                
            }
            else
            {
                pay.IP_Status__c = 'Inactive';
                pay.Reason_for_Leaving1__c = selectedleavingreason;
                pay.P45_Requested__c = TRUE;
                pay.Date_P45_Requested__c = System.today();
                check2 = 'false';
            }
        }
    }
    try{
    update paylist;
    }
    catch(DmlException e)
    {
        ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
        ApexPages.addMessage(myMsg1);
        system.debug('Inside Exception'+e.getMessage());
        check1 = null;
    }
    
    
    Contact con = [Select id,IP_Allpayprofiles__c,IP_UmbCount__c,IP_LTDPayProfileCount__c,IP_ActivePAYEPayProfiles__c  from Contact where id =:currentRecordId];
    system.debug('**Check count**'+con.IP_Allpayprofiles__c);
    if(con.IP_Allpayprofiles__c == 0)
    {
        con.Person_Status__c = 'Inactive';
        conupdate.add(con);
    }
    update conupdate;
    system.debug('check 1 value'+ check1);
    system.debug('check 2 value'+ check2);
    if(check1 == 'true')
    {
         ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.CONFIRM,System.Label.P45B2Ferror9);
         ApexPages.addMessage(myMsg1);
    }
    if(check2 == 'false' && check1 == null)
    {
        ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.CONFIRM,System.Label.P45B2Ferror8);
         ApexPages.addMessage(myMsg1);
    }
        }
     return null;
    }
}