public class ManualPDFgenerate{

public sirenum__Placement__c ps;
public List<sirenum__Placement__c> splacement = new List<sirenum__Placement__c>();
public List<sirenum__Placement__c> splacement1 = new List<sirenum__Placement__c>();
public String Category;
public ManualPDFgenerate(ApexPages.StandardController stdController) 
    {
        this.ps = (sirenum__Placement__c)stdController.getRecord();
        id psid =this.ps.id; 
        sirenum__Placement__c p =[Select id,sirenum__Job_Role__r.sirenum__Rota__r.Name,sirenum__Contact__r.HasOptedOutOfEmail,sirenum__Contact__r.Email from sirenum__Placement__c where id =:psid];
        Category = p.sirenum__Job_Role__r.sirenum__Rota__r.Name;
    }
    public String selectedpayrollweek
        {
           get
            {
               splacement = [Select id,Current_week__c from sirenum__Placement__c where id =:this.ps.id];
               for (sirenum__Placement__c s :splacement )
               {
               if(selectedpayrollweek==null)
               {
                   selectedpayrollweek= String.valueof(s.Current_week__c );
                   
                   }
                  
            }
             return selectedpayrollweek;
            }
        set;
        }
 
    public List<SelectOption> getpayrollweek() {
     List<SelectOption> options = new List<SelectOption>();
     options.add(new SelectOption('01','01'));
    options.add(new SelectOption('02','02'));
    options.add(new SelectOption('03','03'));
    options.add(new SelectOption('04','04'));
    options.add(new SelectOption('05','05'));
    options.add(new SelectOption('06','06'));
    options.add(new SelectOption('07','07'));
    options.add(new SelectOption('08','08'));
    options.add(new SelectOption('09','09'));
         for(integer i=10;i<=53;i++) {
             options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
         }
       return options;
    }
    public String selectedpayrollyear
        {
           get
            {
               splacement1 = [Select id,Current_year__c from sirenum__Placement__c where id =:this.ps.id];
               for (sirenum__Placement__c s :splacement1 )
               {
               if(selectedpayrollyear==null)
               {
                   selectedpayrollyear= String.valueof(s.Current_year__c);
                   
                   }
                  
            }
             return selectedpayrollyear;
            }
        set;
        }
     public List<SelectOption> getpayrollyear() {
     List<SelectOption> options = new List<SelectOption>();
     Integer currentyear = system.today().year();
     Integer nextYear = system.today().year() + 1;
     Integer previousYear = system.today().year() - 1;
     options.add(new SelectOption(String.valueOf(previousYear),String.valueOf(previousyear)));
     options.add(new SelectOption(String.valueOf(currentyear),String.valueof(currentyear)));
     options.add(new SelectOption(String.valueOf(nextYear) ,String.valueOf(nextYear)));

       return options;
    }
    public pagereference saverecord(){
    
    
    List<sirenum__Placement__c> splace = new List<sirenum__Placement__c> ();
    sirenum__Placement__c splace1 = [Select id,sirenum__Contact__r.HasOptedOutOfEmail,sirenum__Contact__r.Email from sirenum__Placement__c where id =:this.ps.id];
    if(splace1.sirenum__Contact__r.HasOptedOutOfEmail!=true && splace1.sirenum__Contact__r.Email!=null)
    {
    splace = [Select id,Payroll_week__c, Payroll_year__c,sirenum__Contact__r.HasOptedOutOfEmail,sirenum__Contact__r.Email from sirenum__Placement__c where id =:this.ps.id];
    List<sirenum__Placement__c> updateplace = new List<sirenum__Placement__c> ();
    for (sirenum__Placement__c sp :splace)
    {
        sp.Payroll_week__c = selectedpayrollweek;  sp.Payroll_year__c = selectedpayrollyear;
        system.debug('&&Record'+sp);
        updateplace.add(sp);
    }

    update updateplace; 
         if(!test.isrunningtest())
        {
    sendemail.sendemailtimseheet(this.ps.id);
        }
        ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Email sent succesfully.');
       ApexPages.addMessage(myMsg1);   return null;
     
    }
    
    else
    {
       ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Candidate does not have an email address or has opted out of Email');
       ApexPages.addMessage(myMsg1);
       return null;
    
    }
    }
    public pagereference closepage(){ return null;}
    
    public pagereference printt(){
   List<sirenum__Placement__c> splace = new List<sirenum__Placement__c> ();
    splace = [Select id,Payroll_week__c,Payroll_year__c from sirenum__Placement__c where id =:this.ps.id];
    List<sirenum__Placement__c> updateplace = new List<sirenum__Placement__c> ();
    for (sirenum__Placement__c sp :splace)
    {
        sp.Payroll_week__c = selectedpayrollweek;
        sp.Payroll_year__c = selectedpayrollyear;
        system.debug('&&Record'+sp);
        updateplace.add(sp);
    }

    update updateplace; 
    if(Category == 'driving')
    {
    PageReference pageRef = new PageReference('/apex/Manual_Timesheet_Design?id=' + this.ps.id+'&sx=1');
    return pageRef.setRedirect(true);   
    }
    else
    {
    PageReference pageRef = new PageReference('/apex/Manual_TimeSheet_Design_2?id=' + this.ps.id+'&sx=1');
    return pageRef.setRedirect(true);
    } 
     
    }
}