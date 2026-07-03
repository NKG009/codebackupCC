public class CandidateP45ActionController {

   

public string leavingoptions =null;
public string payprofileoptions =null;
public String currentRecordId {get;set;}
//List<sirenum__shift__c> shiftlist =  new List<sirenum__shift__c>();
List<sirenum__Timesheet_Line__c> timesheetlist =  new List<sirenum__Timesheet_Line__c>();
List<sirenum__Placement__c> placeid  = new List<sirenum__Placement__c>();
List<sirenum__shift__c> shiftlist1 = new List<sirenum__shift__c>();
List<sirenum__Timesheet_line__c> tlines = new List<sirenum__Timesheet_line__c>();
public String flag {get;set;}
public String flag1 {get;set;}
public date dt= System.today();
public Set<id> ppset = new Set<id>();
public set<String> shiftnames = new Set<String>();
public set<String> timesheetnames = new Set<String>();
List<String> displaytimename1 = new List<String>();
public String displaytimename;
List<String> displayshiftname1 = new List<String>();
public String displayshiftname;
    public List<wraperpp> ppList{get;set;} //pay profile
    public integer shiftframe = Integer.valueOf(System.Label.ShiftTimeframestart);
    public integer shiftframe1 = Integer.valueOf(System.Label.ShiftTimeframeend);



 public CandidateP45ActionController() {
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        System.debug('Check id'+currentRecordId  );      
        flag = null;
        flag1=null;
        leavingoptions = 'Leaving'; 
         ppList = new List<wraperpp>();
        for(IP_PayProfile__c p: [select id,
                                 RecordType.name, 
                                 Name, 
                                 IP_PrimaryPayMethod__c,
                                 P45_Initiated__c,
                                 IP_Status__c,
                                 Reason_for_P45_Internal__c,
                                 Reason_for_Leaving1__c ,Date_P45_Requested__c,IP_Candidate__c
                                 from  IP_PayProfile__c 
                                 where IP_Status__c='Active' and IP_Candidate__c=:currentRecordId]){
                                     ppList.add(new wraperpp(p));
                                 }  
                                 System.debug('Check list 1'+ppList);
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

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Leaving','Leaving')); 
        options.add(new SelectOption('Switching Pay Profile (e.g. PAYE transferring to LTD Co)','Switching Pay Profile (e.g. PAYE transferring to LTD Co)')); return options; 
    }
         
    public String getleavingoptions() {
        return leavingoptions;
    }
                    
    public void setleavingoptions(String leavingoptions)
     { 
         this.leavingoptions= leavingoptions;
     }  
     
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
                                 Reason_for_Leaving1__c ,Date_P45_Requested__c,IP_Candidate__c
                                 from  IP_PayProfile__c 
                                 where IP_Status__c='Active' and IP_Candidate__c=:currentRecordId]){
                                     ppList.add(new wraperpp(p));
                                 }  
                                 System.debug('Check list 1'+ppList);
        return ppList; 
        
    } 
     
      public List<SelectOption> getpayitems() {
        List<SelectOption> options = new List<SelectOption>(); 
        List<IP_PayProfile__c> paylist = [Select id,RecordType.name,IP_Candidate__c from IP_PayProfile__c where IP_Status__c='Active' and IP_Candidate__c=:currentRecordId];
        for(IP_PayProfile__c p:paylist)
        {
        options.add(new SelectOption(p.id,p.RecordType.name)); 
        }
        return options; 
    }
             
    public String getpayprofileoptions() {
        return payprofileoptions;
    }
                    
    public void setpayprofileoptions(String payprofileoptions)
     { 
         this.payprofileoptions= payprofileoptions;
     }  
    
     public Pagereference selectOnClick()
     {
         if(leavingoptions == 'Switching Pay Profile (e.g. PAYE transferring to LTD Co)')
         {             
           system.debug('**OK**');
         }
         return null;
     }
         List<IP_PayProfile__c> ppwrap = new List<IP_PayProfile__c>();    
     public Pagereference checkandproceed()
     {
        if(leavingoptions == 'Switching Pay Profile (e.g. PAYE transferring to LTD Co)')
        {
           System.debug('Inside if1');
           for(wraperpp pCon: ppList)
           {
                  if(pCon.selected == true) 
            {
               System.debug('****Inside if***');
                ppwrap.add(pCon.conp);
            }
           }
           if(ppwrap.size()>0)
           {           for(IP_Payprofile__c pp:ppwrap)
           {
                ppset.add(pp.id);    
           } 
             placeid = [Select id from sirenum__placement__c where IP_PayMethod__c in :ppset];
             system.debug('PLacementlist'+placeid);
           if(placeid.size()>0)
           {
            shiftlist1 = [Select id,sirenum__Placement__c from sirenum__shift__c  where sirenum__Placement__c in:placeid];
            }
            system.debug('Shiftlist'+shiftlist1 );
            if(shiftlist1.size()>0)
            {
            tlines = [Select id,IP_LastPassedtoTempest__c,IP_Locktimesheet__c,sirenum__Timesheet__r.IP_StandardWeeklyNumberID__c,IP_PassToTempest__c  from sirenum__Timesheet_line__c where sirenum__shift__c in:shiftlist1 and ((IP_LastPassedToTempest__c=null and IP_PassToTempest__c = TRUE and IP_Locktimesheet__c = FALSE) OR (IP_PassToTempest__c = TRUE and IP_Locktimesheet__c = FALSE))];
            }
            system.debug('timesheetlist'+tlines);
            if(tlines.size()>0)
            {
                
                 for(sirenum__Timesheet_Line__c t: tlines)
                  {
                      timesheetnames.add(t.sirenum__Timesheet__r.IP_StandardWeeklyNumberID__c);
                  }
                List<sirenum__Timesheet__c> printlist = [Select IP_StandardWeeklyNumberID__c from sirenum__Timesheet__c where IP_StandardWeeklyNumberID__c in : timesheetnames];
                for(sirenum__Timesheet__c t: printlist)
                {
                    displaytimename1.add(t.IP_StandardWeeklyNumberID__c);
                }
                displaytimename = string.join(displaytimename1,',');
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.P45ActionError2 +'<br/> Timesheet ID:'+ displaytimename);
                ApexPages.addMessage(myMsg1);                flag = 'false';
            }
            else
            {
              //  System.debug('check value in ppid'+pp.id);
                List<IP_PayProfile__c> paylist = [Select id,RecordType.Name,IP_OkToSupply__c from IP_PayProfile__c where id not in:ppset and IP_Candidate__c=:currentRecordId];

                system.debug('paylist size check'+paylist);
                for(integer i=0;i<paylist.size();i++)
                {
                system.debug('paylist type check'+paylist[i].RecordType.Name);
                if(paylist[i].RecordType.Name == 'LTD')
                {
                    if(paylist[i].IP_OkToSupply__c == 0)
                    {
                        ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.P45B2Ferror5);
                        ApexPages.addMessage(myMsg1);                        flag = 'false';
                    }                    
                }
                }
                if(flag == null)
                {
                    List<sirenum__placement__c> place1 = [Select id,sirenum__Status__c,sirenum__End_Date__c from sirenum__placement__c where IP_PayMethod__c in:ppset and sirenum__End_Date__c>:dt];
                        if(place1.size()>0)
                        {
                           ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.INFO,System.Label.P45B2Ferror6);
                            ApexPages.addMessage(myMsg1);
                            System.debug('Flag value check1'+flag);
                            flag = 'true';
                        }
                        else
                        {
                            if(flag == null)
                            {
                            flag = 'true';
                            System.debug('Flag value check2'+flag);
                            }
                        }
                }
                }  
            
            if(flag == null)
            {
                flag = 'true';
            }
            System.debug('Flag value check4'+flag);
            if(flag == 'true')
            {
                system.debug('**check flag value abcd**');
             List<IP_PayProfile__c> payproflist = [Select id,Reason_for_Leaving1__c,IP_Passtotempest__c,P45_Requested__c ,IP_LastPassedToTempest__c,IP_Status__c,IP_Candidate__c,IP_Candidate__r.Person_Status__c,RecordType.name from IP_PayProfile__c where id in:ppset];
            for(IP_PayProfile__c paylistloop:payproflist )
            {
            if(paylistloop.IP_LastPassedToTempest__c==null)
            {
                paylistloop.IP_Status__c = 'Inactive';
                paylistloop.P45_Requested__c = true;
                paylistloop.Date_P45_Requested__c = System.today();
                paylistloop.Reason_for_Leaving1__c ='Transfer Pay Profile';
                flag1 = 'true';
                 //update paylistloop;
            }
            else
            {
                if(paylistloop.RecordType.name == 'PAYE')
                {
                    paylistloop.P45_Requested__c = true;
                    paylistloop.Date_P45_Requested__c = System.today();
                    paylistloop.Reason_for_Leaving1__c ='Transfer Pay Profile';
                    paylistloop.IP_Passtotempest__c = true;
                     flag1 = 'false';
                    // update paylistloop;
                }
               else
                {
                    paylistloop.IP_Status__c = 'Inactive';
                    paylistloop.P45_Requested__c = true;
                    paylistloop.Date_P45_Requested__c = System.today();
                    paylistloop.Reason_for_Leaving1__c ='Transfer Pay Profile';
                     flag1 = 'true';
                   //  update paylistloop;
                }
            }
           
            }
            try{
            update payproflist;
            }
            catch(DMLException e)
            {
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg1);
            flag1= null;
            }
            
            }
            if(flag1 == 'true')
            {
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.CONFIRM,System.Label.P45B2Ferror8);                ApexPages.addMessage(myMsg1);
            }
            if(flag1 == 'false')
            {
               system.debug('check flag1 value before error');
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.CONFIRM,System.Label.P45B2Ferror9);                ApexPages.addMessage(myMsg1);
            }
           }
           
            else
            {
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.P45B2Ferror7);                ApexPages.addMessage(myMsg1);
            }
            
        } 
        
        else
        {
        system.debug('OK');
      // shiftlist = [Select id,sirenum__Cancelled__c,sirenum__Published__c,sirenum_schedule_time__c from sirenum__shift__c where sirenum__Contact__c =:currentRecordId and sirenum__Published__c = TRUE and ( sirenum__Timesheet_summaries__c = '' OR sirenum__Cancelled__c = false) and sirenum__Scheduled_Start_Time__c = LAST_N_DAYS:shiftframe]];
      
       String querydata = 'Select id,sirenum__Billable_Calculated_Start_Time__c,name,sirenum__Contact__c,sirenum__Published__c,sirenum__Timesheet_summaries__c from sirenum__shift__c where (sirenum__Timesheet_summaries__c = \'\' and sirenum__Cancelled__c = false) and sirenum__Published__c = TRUE  and (sirenum__Billable_Calculated_Start_Time__c = LAST_N_DAYS:'+shiftframe + ' OR sirenum__Billable_Calculated_Start_Time__c = NEXT_N_DAYS:'+shiftframe1 +' OR sirenum__Billable_Calculated_Start_Time__c = null  ) and sirenum__Contact__c =: currentRecordId ';
    System.debug('querydata->'+querydata);
    
    List<sirenum__Shift__c> shiftList = Database.query(querydata);
    system.debug('check shiftlist'+shiftlist);
    timesheetlist = [Select id,IP_LastPassedToTempest__c,sirenum__Timesheet__r.IP_StandardWeeklyNumberID__c,IP_PassToTempest__c,sirenum__Timesheet__r.Name,IP_Locktimesheet__c  from sirenum__Timesheet_Line__c where ((IP_LastPassedToTempest__c=null and IP_PassToTempest__c = TRUE and IP_Locktimesheet__c = FALSE) OR (IP_PassToTempest__c = TRUE and IP_Locktimesheet__c = FALSE)) and sirenum__Timesheet__r.sirenum__Worker__c=:currentRecordId]; 

       if(shiftList.size()>0 || timesheetlist.size()>0)
       { 
         
          if(shiftlist.size()>0 && timesheetlist.size()>0)
          {
              for(sirenum__Shift__c s: shiftList)
          {
              shiftnames.add(s.Name);
          }
          for(sirenum__Timesheet_Line__c t: timesheetlist)
                  {
                      timesheetnames.add(t.sirenum__Timesheet__r.IP_StandardWeeklyNumberID__c);
                  }
                  List<sirenum__Timesheet__c> printlist = [Select IP_StandardWeeklyNumberID__c from sirenum__Timesheet__c where IP_StandardWeeklyNumberID__c in : timesheetnames];
                for(sirenum__Timesheet__c t: printlist)
                {
                    displaytimename1.add(t.IP_StandardWeeklyNumberID__c);
                }
                displaytimename = string.join(displaytimename1,',');
               List<sirenum__Shift__c> printshiftlist = [Select name from sirenum__Shift__c where name in : shiftnames];
                for(sirenum__Shift__c t: printshiftlist)
                {
                    displayshiftname1.add(t.name);
                }
                displayshiftname = string.join(displayshiftname1,',');
              ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.P45ActionError1 +'<br/>'+ displayshiftname);  
          ApexPages.addMessage(myMsg1);
          flag = 'false';
          
           ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.P45ActionError2 +'<br/> Timesheet ID:'+ displaytimename);
           ApexPages.addMessage(myMsg2);            flag = 'false';
          }
          else if(shiftlist.size()>0)
          {
                for(sirenum__Shift__c s: shiftList)
          {
              shiftnames.add(s.Name);
          }
           List<sirenum__Shift__c> printshiftlist = [Select name from sirenum__Shift__c where name in : shiftnames];
                for(sirenum__Shift__c t: printshiftlist)
                {
                    displayshiftname1.add(t.name);
                }
                displayshiftname = string.join(displayshiftname1,',');
              ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.P45ActionError1 +'<br/>'+ displayshiftname);
          ApexPages.addMessage(myMsg1);          flag = 'false';
          }
          else 
          {
              for(sirenum__Timesheet_Line__c t: timesheetlist)
                  {
                      timesheetnames.add(t.sirenum__Timesheet__r.IP_StandardWeeklyNumberID__c);
                  }
                  List<sirenum__Timesheet__c> printlist = [Select IP_StandardWeeklyNumberID__c from sirenum__Timesheet__c where IP_StandardWeeklyNumberID__c in : timesheetnames];
                for(sirenum__Timesheet__c t: printlist)
                {
                    displaytimename1.add(t.IP_StandardWeeklyNumberID__c);
                }
                displaytimename = string.join(displaytimename1,',');
             ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.P45ActionError2 +'<br/> Timesheet ID:'+ displaytimename);
             ApexPages.addMessage(myMsg1);              flag = 'false'; 
          }
        }    
           else
           {
              System.debug('inside else');
               PageReference pageRef = new PageReference('/apex/CaptureReasonforLeaving?id='+currentRecordId);               return pageRef;
           }
       }
        return null; 
        }
        
         
     }