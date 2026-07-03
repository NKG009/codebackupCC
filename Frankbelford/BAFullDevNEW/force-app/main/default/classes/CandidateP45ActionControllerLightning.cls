public class CandidateP45ActionControllerLightning {

    @AuraEnabled public string flag {get;set;}
    @AuraEnabled public string flag1 {get;set;}
    public CandidateP45ActionControllerLightning() {
        flag = null;
        flag1 = null;
    }
    
    @AuraEnabled
    public Static String buttonsDisplayed(){
        string buttonDisplayed = '';
        CandidateP45ActionControllerLightning obj = new CandidateP45ActionControllerLightning();
        
        if(obj.flag == null && obj.flag1 == null){
            buttonDisplayed = 'Both Null';
        }
        else if(obj.flag !=null || obj.flag1 !=null){
            buttonDisplayed = 'Both Not Null';
        }
        
        return buttonDisplayed;
    }
   

    public string leavingoptions =null;
    public string payprofileoptions =null;
    
    public class wraperpp{
    
        @AuraEnabled public IP_PayProfile__c conp {get; set;}
        @AuraEnabled public Boolean selected {get; set;}
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
                    
    public void setleavingoptions(String leavingoptions){ 
         this.leavingoptions= leavingoptions;
    }  
     
    public List<wraperpp> getpps(){
        /*ppList = new List<wraperpp>();
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
        return ppList; */
        return null;
    } 
     
      public List<SelectOption> getpayitems() {
        /*List<SelectOption> options = new List<SelectOption>(); 
        List<IP_PayProfile__c> paylist = [Select id,RecordType.name,IP_Candidate__c from IP_PayProfile__c where IP_Status__c='Active' and IP_Candidate__c=:currentRecordId];
        for(IP_PayProfile__c p:paylist)
        {
        options.add(new SelectOption(p.id,p.RecordType.name)); 
        }
        return options; */
        return null;
    }
             
    public String getpayprofileoptions() {
        return payprofileoptions;
    }
                    
    public void setpayprofileoptions(String payprofileoptions){ 
        this.payprofileoptions= payprofileoptions;
    }  
    
    public Pagereference selectOnClick(){
        if(leavingoptions == 'Switching Pay Profile (e.g. PAYE transferring to LTD Co)'){             
           system.debug('**OK**');
        }
         return null;
    }
        
    @AuraEnabled
    public Static List<wraperpp> checkSelectedValue(String leavingoptions , String contactId){
        List<wraperpp> ppList = new List<wraperpp>();
        
        if(leavingoptions == 'Switching Pay Profile (e.g. PAYE transferring to LTD Co)'){
            for(IP_PayProfile__c p: [select id,
                                 RecordType.Name, 
                                 Name, 
                                 IP_PrimaryPayMethod__c,
                                 P45_Initiated__c,
                                 IP_Status__c,
                                 Reason_for_P45_Internal__c,
                                 Reason_for_Leaving1__c ,Date_P45_Requested__c,IP_Candidate__c
                                 from  IP_PayProfile__c 
                                 where IP_Status__c='Active' and IP_Candidate__c=:contactId]){                                    ppList.add(new wraperpp(p));
                                }  
                                 System.debug('Check list 1'+ppList);
            return ppList;                   
        }
        else return null;
    }       
    
    @AuraEnabled
    public Static string checkandproceed(String payProfileRecords, String leavingoptions , String contactId){
        
        @TestVisible List<IP_PayProfile__c> ppwrap = new List<IP_PayProfile__c>();
        Set<id> ppset = new Set<id>();      
        List<sirenum__Placement__c> placeid  = new List<sirenum__Placement__c>();
        List<sirenum__shift__c> shiftlist1 = new List<sirenum__shift__c>();
        List<sirenum__Timesheet_line__c> tlines = new List<sirenum__Timesheet_line__c>();
        set<String> shiftnames = new Set<String>();
        set<String> timesheetnames = new Set<String>();
        List<String> displaytimename1 = new List<String>();
        String displaytimename='';
        List<String> displayshiftname1 = new List<String>();
        String displayshiftname='';
        CandidateP45ActionControllerLightning obj = new CandidateP45ActionControllerLightning();
        date dt= System.today();
        integer shiftframe = Integer.valueOf(System.Label.ShiftTimeframestart);
        integer shiftframe1 = Integer.valueOf(System.Label.ShiftTimeframeend);
        String message = '';
        
        List<sirenum__Timesheet_Line__c> timesheetlist =  new List<sirenum__Timesheet_Line__c>();
        if(leavingoptions == 'Switching Pay Profile (e.g. PAYE transferring to LTD Co)'){
            
            if(!string.isBlank(payProfileRecords)){
                
                
                System.debug('payProfileRecords 1'+payProfileRecords);
                List<wraperpp> listPayProfilerecords = (List<wraperpp>)System.JSON.deserialize(payProfileRecords,List<wraperpp>.class);
                System.debug('listPayProfilerecords 1'+listPayProfilerecords);
                
                System.debug('Inside if1');
                for(wraperpp pCon: listPayProfilerecords){
                 System.debug('****Inside for pcon***'+pCon);  
                    if(pCon.selected ){      
                        System.debug('****Inside If***');                   
                        ppwrap.add(pCon.conp);
                        System.debug('****ppwrap***'+ppwrap);
                    }
                }
                
                if(ppwrap.size()>0){           
                    for(IP_Payprofile__c pp:ppwrap){                        ppset.add(pp.id);    
                    } System.debug('****ppset***'+ppset);
                    placeid = [Select id from sirenum__placement__c where IP_PayMethod__c in :ppset];
                    system.debug('PLacementlist'+placeid);
                    
                    if(placeid.size()>0){                        shiftlist1 = [Select id,sirenum__Placement__c from sirenum__shift__c  where sirenum__Placement__c in:placeid];
                    }
                
                    system.debug('Shiftlist'+shiftlist1 );
                    if(shiftlist1.size()>0){                        tlines = [Select id,IP_LastPassedtoTempest__c,IP_Locktimesheet__c,sirenum__Timesheet__r.IP_StandardWeeklyNumberID__c,IP_PassToTempest__c  from sirenum__Timesheet_line__c where sirenum__shift__c in:shiftlist1 and ((IP_LastPassedToTempest__c=null and IP_PassToTempest__c = TRUE and IP_Locktimesheet__c = FALSE) OR (IP_PassToTempest__c = TRUE and IP_Locktimesheet__c = FALSE))];
                    }
                    system.debug('timesheetlist'+tlines);
                    if(tlines.size()>0){
                    
                        for(sirenum__Timesheet_Line__c t: tlines){                            timesheetnames.add(t.sirenum__Timesheet__r.IP_StandardWeeklyNumberID__c);
                        }
                        
                        List<sirenum__Timesheet__c> printlist = [Select IP_StandardWeeklyNumberID__c from sirenum__Timesheet__c where IP_StandardWeeklyNumberID__c in : timesheetnames];
                        for(sirenum__Timesheet__c t: printlist){                            displaytimename1.add(t.IP_StandardWeeklyNumberID__c);
                        }
                        
                        displaytimename = string.join(displaytimename1,',');                        message = 'Error : '+System.Label.P45ActionError2 +'<br/> Timesheet ID:'+ displaytimename;                        obj.flag = 'false';
                    }
                    else{
                  //  System.debug('check value in ppid'+pp.id);
                        List<IP_PayProfile__c> paylist = [Select id,RecordType.Name,IP_OkToSupply__c from IP_PayProfile__c where id not in:ppset and IP_Candidate__c=:contactId];

                        system.debug('paylist size check'+paylist);
                        for(integer i=0;i<paylist.size();i++){
                            system.debug('paylist type check'+paylist[i].RecordType.Name);
                            if(paylist[i].RecordType.Name == 'LTD'){
                                if(paylist[i].IP_OkToSupply__c == 0){                                    message = 'Error : '+System.Label.P45B2Ferror5;                                    obj.flag = 'false';
                                }                    
                            }
                        }
                        if(obj.flag == null){
                            List<sirenum__placement__c> place1 = [Select id,sirenum__Status__c,sirenum__End_Date__c from sirenum__placement__c where IP_PayMethod__c in:ppset and sirenum__End_Date__c>:dt];
                            if(place1.size()>0){                                message = System.Label.P45B2Ferror6;
                                //ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.INFO,System.Label.P45B2Ferror6);
                                //ApexPages.addMessage(myMsg1);
                                System.debug('Flag value check1'+obj.flag);
                                obj.flag = 'true';
                            }
                            else{
                                if(obj.flag == null){                                    obj.flag = 'true';
                                    System.debug('Flag value check2'+obj.flag);
                                }
                            }
                        }
                    }  
                    
                    if(obj.flag == null){                        obj.flag = 'true';
                    }
                    System.debug('Flag value check4'+obj.flag);
                    if(obj.flag == 'true'){
                        system.debug('**check flag value abcd**');
                        List<IP_PayProfile__c> payproflist = [Select id,Reason_for_Leaving1__c,IP_Passtotempest__c,P45_Requested__c ,IP_LastPassedToTempest__c,IP_Status__c,IP_Candidate__c,IP_Candidate__r.Person_Status__c,RecordType.name from IP_PayProfile__c where id in:ppset];
                        for(IP_PayProfile__c paylistloop:payproflist ){
                            if(paylistloop.IP_LastPassedToTempest__c==null){
                                paylistloop.IP_Status__c = 'Inactive';                                paylistloop.P45_Requested__c = true;                                paylistloop.Date_P45_Requested__c = System.today();                                paylistloop.Reason_for_Leaving1__c ='Transfer Pay Profile';                                obj.flag1 = 'true';
                                 //update paylistloop;
                            }
                            else{
                                if(paylistloop.RecordType.name == 'PAYE'){
                                    paylistloop.P45_Requested__c = true;                                    paylistloop.Date_P45_Requested__c = System.today();                                    paylistloop.Reason_for_Leaving1__c ='Transfer Pay Profile';                                    paylistloop.IP_Passtotempest__c = true;                                    obj.flag1 = 'false';
                                    // update paylistloop;
                                }
                                else{
                                    paylistloop.IP_Status__c = 'Inactive';                                    paylistloop.P45_Requested__c = true;                                    paylistloop.Date_P45_Requested__c = System.today();                                    paylistloop.Reason_for_Leaving1__c ='Transfer Pay Profile';                                    obj.flag1 = 'true';
                                   //  update paylistloop;
                                }
                            }
                        }
                        try{
                            update payproflist;
                        }
                        catch(DMLException e){
                            message = 'Error : '+e.getMessage();
                            //ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                            //ApexPages.addMessage(myMsg1);
                            obj.flag1= null;
                        }
                    
                    }
                    if(obj.flag1 == 'true'){                        message = System.Label.P45B2Ferror8;
                        //ApexPages.Message myMsg1 = new //ApexPages.Message(ApexPages.Severity.CONFIRM,System.Label.P45B2Ferror8);ApexPages.addMessage(myMsg1);
                    }
                    if(obj.flag1 == 'false'){                        message = System.Label.P45B2Ferror9;
                       system.debug('check flag1 value before error');
                        //ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.CONFIRM,System.Label.P45B2Ferror9);                
                        //ApexPages.addMessage(myMsg1);
                    }
                }           
                else{
                    message = System.Label.P45B2Ferror7;
                    //ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.P45B2Ferror7);
                    //ApexPages.addMessage(myMsg1);
                }
            }
            
            
        }       
        else{
            system.debug('OK');
            String querydata = 'Select id,sirenum__Billable_Calculated_Start_Time__c,name,sirenum__Contact__c,sirenum__Published__c,sirenum__Timesheet_summaries__c from sirenum__shift__c where (sirenum__Timesheet_summaries__c = \'\' and sirenum__Cancelled__c = false) and sirenum__Published__c = TRUE  and (sirenum__Billable_Calculated_Start_Time__c = LAST_N_DAYS:'+shiftframe + ' OR sirenum__Billable_Calculated_Start_Time__c = NEXT_N_DAYS:'+shiftframe1 +' OR sirenum__Billable_Calculated_Start_Time__c = null  ) and sirenum__Contact__c =: contactId ';
            System.debug('querydata->'+querydata);
            
            //String querydata = 'Select id,sirenum__Billable_Calculated_Start_Time__c,name,sirenum__Contact__c,sirenum__Published__c,sirenum__Timesheet_summaries__c from sirenum__shift__c where (sirenum__Timesheet_summaries__c = \'\' and sirenum__Cancelled__c = false) and sirenum__Published__c = TRUE  and sirenum__Contact__c =: contactId ';
            System.debug('querydata->'+querydata);

            List<sirenum__Shift__c> shiftList = Database.query(querydata);
            system.debug('check shiftlist'+shiftlist);
            timesheetlist = [Select id,IP_LastPassedToTempest__c,sirenum__Timesheet__r.IP_StandardWeeklyNumberID__c,IP_PassToTempest__c,sirenum__Timesheet__r.Name  from sirenum__Timesheet_Line__c where ((IP_LastPassedToTempest__c=null and IP_PassToTempest__c = TRUE and IP_Locktimesheet__c = FALSE) OR (IP_PassToTempest__c = TRUE and IP_Locktimesheet__c = FALSE)) and sirenum__Timesheet__r.sirenum__Worker__c=:contactId]; 

            if(shiftList.size()>0 || timesheetlist.size()>0){
         
                if(shiftlist.size()>0 && timesheetlist.size()>0){
                    for(sirenum__Shift__c s: shiftList){
                        shiftnames.add(s.Name);
                    }
                    
                    for(sirenum__Timesheet_Line__c t: timesheetlist){
                        timesheetnames.add(t.sirenum__Timesheet__r.IP_StandardWeeklyNumberID__c);
                    }
                    
                    List<sirenum__Timesheet__c> printlist = [Select IP_StandardWeeklyNumberID__c from sirenum__Timesheet__c where IP_StandardWeeklyNumberID__c in : timesheetnames];
                    for(sirenum__Timesheet__c t: printlist){
                        displaytimename1.add(t.IP_StandardWeeklyNumberID__c);
                    }
                    displaytimename = string.join(displaytimename1,',');
                    
                    List<sirenum__Shift__c> printshiftlist = [Select name from sirenum__Shift__c where name in : shiftnames];
                    for(sirenum__Shift__c t: printshiftlist){
                        displayshiftname1.add(t.name);
                    }
                    displayshiftname = string.join(displayshiftname1,',');
                    message = 'Error : '+System.Label.P45ActionError1 +'<br/>'+ displayshiftname;
                    //ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.P45ActionError1 +'<br/>'+ displayshiftname);  
                    //ApexPages.addMessage(myMsg1);
                    obj.flag = 'false';
                    
                    message = message+'<br/>'+'Error : '+System.Label.P45ActionError2 +'<br/>'+ displayshiftname;
                    //ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.P45ActionError2 +'<br/> Timesheet ID:'+ displaytimename);
                    //ApexPages.addMessage(myMsg2);            
                    obj.flag = 'false';
                }
                else if(shiftlist.size()>0){
                    for(sirenum__Shift__c s: shiftList){
                        shiftnames.add(s.Name);
                    }
                    List<sirenum__Shift__c> printshiftlist = [Select name from sirenum__Shift__c where name in : shiftnames];
                    for(sirenum__Shift__c t: printshiftlist){
                        displayshiftname1.add(t.name);
                    }
                    displayshiftname = string.join(displayshiftname1,',');
                    message = 'Error : '+System.Label.P45ActionError1 +'<br/>'+ displayshiftname;
                    //ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.P45ActionError1 +'<br/>'+ displayshiftname);
                    //ApexPages.addMessage(myMsg1);          
                    obj.flag = 'false';
                }
                else{
                    for(sirenum__Timesheet_Line__c t: timesheetlist){
                        timesheetnames.add(t.sirenum__Timesheet__r.IP_StandardWeeklyNumberID__c);
                    }
                    List<sirenum__Timesheet__c> printlist = [Select IP_StandardWeeklyNumberID__c from sirenum__Timesheet__c where IP_StandardWeeklyNumberID__c in : timesheetnames];
                    for(sirenum__Timesheet__c  t : printlist){
                        displaytimename1.add(t.IP_StandardWeeklyNumberID__c);
                    }
                    displaytimename = string.join(displaytimename1,',');
                    message = 'Error : '+System.Label.P45ActionError2 +'<br/> Timesheet ID:'+ displaytimename;
                    //ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.P45ActionError2 +'<br/> Timesheet ID:'+ displaytimename);
                    //ApexPages.addMessage(myMsg1);              
                    obj.flag = 'false'; 
                }
            }   
            else{
                System.debug('inside else');
                message = 'openCaptureReasonforLeaving';
                //PageReference pageRef = new PageReference('/apex/CaptureReasonforLeaving?id='+contactId);               
                //return null;
            }
        }
        return message; 
    }
        
         
}