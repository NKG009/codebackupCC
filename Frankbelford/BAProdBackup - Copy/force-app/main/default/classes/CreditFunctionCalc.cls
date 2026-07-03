public class CreditFunctionCalc {
    public String selectedpercentage {get;set;}
    public String selectedcreditreason {get;set;}
    public String selectedleavingreason {get;set;}
    public boolean flag1 {get;set;}
    public ts2__Placement__c ps;
    public integer weeks{get;set;}
    public double totalcc;
    public double salary;
    public String adminfee {get;set;}
    public String amountcredit{get;set;}
    public String temprsncredit{get;set;}
    public String temprsnpercent{get;set;}
    public String tempreasonleaving{get;set;}
    public double tempadminfee {get;set;}
    public double tempcreditamount {get;set;}
    public double tempactual {get;set;}
    private static final string lightningTheme ='Theme4d';
    
    public String getContextUserUiThemeDisplayed() {
        return UserInfo.getUiThemeDisplayed();
    }

    public CreditFunctionCalc(ApexPages.StandardController stdController) {
    
    
    
    this.ps = (ts2__Placement__c)stdController.getRecord();
    id psid =this.ps.id;
    Date dt = system.today();
    ts2__Placement__c p= [Select id,Missing_Details__c,sirenum_js__Site__c,ts2__Start_Date__c,IP_Number_of_Credits__c,ts2__Salary__c,ts2__Job__c,ts2__Employee__c,ts2__Filled_Pct__c,IP_Fixed_Fee__c from ts2__Placement__c where id =:psid ];
     Date dt1 = p.ts2__Start_Date__c;
    weeks = dt1.daysBetween(dt) / 7;
    System.debug('**Number of Weeks'+weeks);
    totalcc = p.IP_Number_of_Credits__c; 
    salary = p.IP_Fixed_Fee__c;
    adminfee = '250';
    }
     
       public List<selectOption> allcreditreason {
        get {
            List<selectOption> options = new List<selectOption>(); 
          Schema.DescribeFieldResult fieldDescribe = Schema.getGlobalDescribe().get('ts2__Placement__c').getDescribe().fields.getMap().get('IP_Reason_for_Credit__c').getDescribe();
          List <Schema.PicklistEntry> p = fieldDescribe.getPicklistValues();
          List<SelectOption> pick = new List<SelectOption>();
          options.add(new SelectOption('','-- None --'));
            
                for(Schema.PicklistEntry s : p)
                {
                    String label = s.getlabel();
                    String value = s.getvalue();
                    options.add(new SelectOption(value,label));
                }
                    return options;           
          }
        set;
    }
    public List<selectOption> allcreditpercent {
        get {
            List<selectOption> options = new List<selectOption>(); 
          Schema.DescribeFieldResult fieldDescribe = Schema.getGlobalDescribe().get('ts2__Placement__c').getDescribe().fields.getMap().get('IP_Reason_Code__c').getDescribe();
          List <Schema.PicklistEntry> p = fieldDescribe.getPicklistValues();
          List<SelectOption> pick = new List<SelectOption>();
          if(selectedcreditreason=='Wrong Client invoiced - branch error' || selectedcreditreason=='Wrong Client invoiced - sales error')
            {  
                String label = '100%';
                String value = '100%';
                options.add(new SelectOption(value,label));
            }       
        else
        {
            options.add(new SelectOption('','-- None --'));
                for(Schema.PicklistEntry s : p)
                {
                    String label = s.getlabel();
                    String value = s.getvalue();
                    options.add(new SelectOption(value,label));
                }
            
        }
            return options;
        }
        set;
    }  
    public List<selectOption> allleavingreason {
        get {
            List<selectOption> options = new List<selectOption>(); 
          Schema.DescribeFieldResult fieldDescribe = Schema.getGlobalDescribe().get('ts2__Placement__c').getDescribe().fields.getMap().get('IP_Reason_for_Leaving__c').getDescribe();
          List <Schema.PicklistEntry> p = fieldDescribe.getPicklistValues();
          List<SelectOption> pick = new List<SelectOption>();
         options.add(new SelectOption('','-- None --'));
            
                for(Schema.PicklistEntry s : p)
                {
                    String label = s.getlabel();
                    String value = s.getvalue();
                    options.add(new SelectOption(value,label));
                }
                    return options;           
          }
        set;                  
         } 
      public void setadminfee()
    {
        if(selectedleavingreason == 'Redundancy' || selectedpercentage == 'Amount £' || weeks>=3)
        {
            System.debug('***Inside IF Conditio****');
            adminfee = '0';flag1 = true;
        }
        else
        {
            System.debug('***Inside Else Conditio****');
            adminfee = '250';
            flag1 = false;
        }
    } 
    
    public pagereference calcrecord(){
     if(selectedcreditreason == null || selectedpercentage == null)
    {
           if(selectedcreditreason== null)
         {
      ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Reason for Credit');
      ApexPages.addMessage(myMsg1);
      }
      if(selectedpercentage ==null)
      {
      ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Reason Code');
      ApexPages.addMessage(myMsg1);
      }
       
    }
    else
    {
    try{
    temprsncredit = selectedcreditreason;
    temprsnpercent = selectedpercentage;
    tempreasonleaving = selectedleavingreason;
    tempadminfee = Double.valueOf(adminfee);
   
     if(selectedpercentage != 'Amount £')
    {
    String S1= selectedpercentage;
    Integer percent = Integer.ValueOf(S1.substringBefore('%'));
    System.debug('$$percent String'+percent);   
    tempcreditamount = (percent*salary)/100;
    if(weeks<3 && selectedleavingreason!='Redundancy')
    {
        if(totalcc==0)
        {
               tempactual =  tempcreditamount-tempadminfee; 
        }
        else
        {
            tempactual =  tempcreditamount;
        }
    }
    else
    {
        tempactual =  tempcreditamount;
    }
    }
    else
    {
         if(amountcredit=='' || Double.valueOf(amountcredit)== 0)
         {
         ApexPages.Message myMsg5 = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter Credit Amount');
             ApexPages.addMessage(myMsg5);
        }
        else
        {
           tempactual = Double.valueOf(amountcredit);
  
        }
    
    }
    }
    catch (Exception e) {
         ApexPages.addMessages(e);return null;
        } 
        }  
   PageReference pageRef = new PageReference('/apex/CreditCalculation?id=' + this.ps.id+'&sx=0');
    return pageRef.setRedirect(false);
    }

        public pagereference saverecord(){
            ts2__Placement__c p1= [Select id,ts2__Start_Date__c,ts2__Hiring_Manager__c,Status_PO_Number__c,ts2__Filled_By_2__c,ts2__Filled_Pct_2__c,ts2__Related_Application__c,ts2__Filled_By__c,ts2__Client__c,ts2__End_Date__c,ts2extams__Substatus__c,ts2__Salary__c,IP_Reason_for_Credit__c,ts2__Job__c,ts2__Employee__c,ts2__Filled_Pct__c,IP_FixedFeeValue__c,IP_PercentageFee__c from ts2__Placement__c where id =:this.ps.id ];
   
     if(selectedcreditreason== null || selectedpercentage ==null)
     {
         if(selectedcreditreason== null)
         {
      ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Reason for Credit');
      ApexPages.addMessage(myMsg1);
      }
      if(selectedpercentage ==null)
      {
      ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Reason Code');
      ApexPages.addMessage(myMsg1);
      }
       
     }
     else
    {
    try{
    RecordType rt= [SELECT id FROM RecordType WHERE Name='Perm Credits'];
    ts2__Placement__c pc = new  ts2__Placement__c();
    pc.RecordTypeId = rt.id;  
    pc.Placement__c = p1.id; 
    pc.ts2__Job__c = p1.ts2__Job__c;
    pc.ts2__Filled_Pct__c = p1.ts2__Filled_Pct__c;
    pc.ts2__Employee__c = p1.ts2__Employee__c;
    pc.ts2extams__Substatus__c = p1.ts2extams__Substatus__c;
    pc.ts2__Start_Date__c = p1.ts2__Start_Date__c;
    pc.ts2__Filled_By__c = p1.ts2__Filled_By__c;
    pc.ts2__End_Date__c = p1.ts2__End_Date__c;
    pc.ts2__Client__c = p1.ts2__Client__c;
    pc.IP_Reason_for_Credit__c = selectedcreditreason;   
    pc.IP_Reason_Code__c = selectedpercentage;
    pc.IP_Reason_for_Leaving__c = selectedleavingreason;
    pc.IP_Admin_Fee__c   = Double.valueOf(adminfee);
    pc.ts2__Hiring_Manager__c = p1.ts2__Hiring_Manager__c;
    pc.ts2__Related_Application__c = p1.ts2__Related_Application__c;
    pc.ts2__Salary__c = p1.ts2__Salary__c;
    pc.Status_PO_Number__c = p1.Status_PO_Number__c;
    pc.ts2__Filled_By_2__c = p1.ts2__Filled_By_2__c;
    pc.ts2__Filled_Pct_2__c = p1.ts2__Filled_Pct_2__c;
    pc.IP_PercentageFee__c = p1.IP_PercentageFee__c;
    pc.IP_FixedFeeValue__c = p1.IP_FixedFeeValue__c;
   pc.IP_PasstoTempest__c = TRUE;
     if(selectedpercentage != 'Amount £')
    {
    String S1= selectedpercentage;
    Integer percent = Integer.ValueOf(S1.substringBefore('%'));
    System.debug('$$percent String'+percent);   
    pc.Credit_Amount__c= (percent*salary)/100;
    if(weeks<3 && selectedleavingreason!='Redundancy')
    {
        if(totalcc==0)
        {
               pc.IP_Amount_to_Credit__c =  pc.Credit_Amount__c-pc.IP_Admin_Fee__c  ; 
        }
        else
        {
            pc.IP_Amount_to_Credit__c =  pc.Credit_Amount__c;
        }
    }
    else
    {
        pc.IP_Amount_to_Credit__c =  pc.Credit_Amount__c;
    }
    }
    else
    {
       if(amountcredit!='')
       {
        pc.IP_Amount_to_Credit__c = Double.valueOf(amountcredit);
        }
        else
        {
          ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter Amount to Credit');
          ApexPages.addMessage(myMsg1);  
        }
        
        
    }
    system.debug('&&Amount to Credit&&'+pc.IP_Amount_to_Credit__c);
    insert pc;
    List<ts2__Placement__c> calcplac = new List<ts2__Placement__c>();
    List<ts2__Placement__c> parentplace = new List<ts2__Placement__c>();
    Map<id,ts2__Placement__c> placemap = new Map<id,ts2__Placement__c>();
    calcplac = [Select id,IP_Amount_to_Credit__c,Placement__c,Placement__r.IP_Number_of_Credits__c,Placement__r.IP_Total_Credit_Amount__c from ts2__Placement__c where RecordType.name = 'Perm Credits' and Placement__c=:this.ps.id ORDER BY Createddate DESC];
    if(calcplac.size()>0 && calcplac[0].IP_Amount_to_Credit__c!=null)
    {
   
    calcplac[0].Placement__r.IP_Total_Credit_Amount__c = calcplac[0].Placement__r.IP_Total_Credit_Amount__c+calcplac[0].IP_Amount_to_Credit__c;
    
    integer i = calcplac.size();
    for(ts2__Placement__c pp:calcplac)
    {
        pp.Placement__r.IP_Number_of_Credits__c = i;              
        parentplace.add(pp.Placement__r);
    }
   placemap.putall(parentplace);
   System.debug('@@PlacementMap@@'+placemap);
  // update calcplac;
   update placemap.values();
    }
      PageReference pageRef;
       String getLightning = getContextUserUiThemeDisplayed();
                if(lightningTheme.equals(getLightning)){
    pageRef = new PageReference('/lightning/r/ts2__placement__c/'+this.ps.id+'/view');
    }
    else
    {
    pageRef = new PageReference('/apex/CreditCalculation?id=' + this.ps.id+'&sx=1');
    }
    return pageRef.setRedirect(true);
    }
    
    catch (Exception e) {
         ApexPages.addMessages(e);return null;
        }   
      } 
     
    return null;
    }
      public pagereference closepage(){
      PageReference pageRef;
      String getLightning = getContextUserUiThemeDisplayed();
      if(lightningTheme.equals(getLightning)){
    pageRef = new PageReference('/lightning/r/ts2__placement__c/'+this.ps.id+'/view');
    return pageRef.setRedirect(true);
    }
    else
    {
    return null;}
}
}