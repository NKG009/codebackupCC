global class GenericBatchHeaderclass implements Database.Batchable<sObject>,Database.Stateful{
    Set<ID> headerId = new Set<ID>();
    Set<Id> setUpdatedBatchHeaderId = new Set<Id>();
    String jobrole;
    String siteid;
    Date shiftDate;
     global Database.QueryLocator start(Database.BatchableContext BC){
        String query ='select id,name,IP_BatchHeader__c,IP_TextField1__c,IP_BatchHeader__r.IP_AccountID__c,IP_TextField2__c,IP_Number12d4Field1__c,IP_CurrencyField1__c,IP_CurrencyField2__c,IP_TextField3__c,IP_DateField1__c,IP_DateField2__c,IP_TextField4__c,IP_TextField5__c,IP_TextField6__c,IP_TextField7__c,IP_Status__c,IP_ErrorReason__c,IP_LinkField3__c,IP_LinkField2__c,IP_LinkField1__c,IP_LinkField4__c,IP_LinkField5__c,IP_LinkField6__c,IP_LinkField7__c from IP_BatchLine__c where IP_Status__c = \'open\' AND IP_BatchHeader__r.IP_BatchType__c=\'Generic\' And ((IP_BatchHeader__r.IP_State__c = \'Closed\' And IP_BatchHeader__r.IP_Status__c = \'Approved\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Errored\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Partial Complete\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Complete\'))';
        return Database.getQueryLocator(query);
     }
     global void execute(Database.BatchableContext BC,List<IP_BatchLine__c> batchlinelist){
        String bheadername;
        String AccountID;
        Map<id,String> Contactname = new Map<id,String>();
        for(IP_BatchLine__c bline : batchlinelist){
            headerId.add(bline.IP_BatchHeader__c);
            AccountID = bline.IP_BatchHeader__r.IP_AccountID__c;
            if(bline.IP_TextField5__c != null)
            {
                jobrole = bline.IP_TextField5__c;
            }
            if(bline.IP_TextField6__c != null)
            {
                siteid = bline.IP_TextField6__c;
            }
            if(bline.IP_DateField1__c  !=null)
            {
                shiftDate = bline.IP_DateField1__c;
            }
            
        }
        list<string> PayrollID = new list<string>();
        List<Date> datefield = new List<Date>();
        Set<Date> setdate= new Set<Date>();
        set<id> contactid = new set<id>();
        
        List<sirenum__Team__c> joblist = [Select id,name,sirenum__Account__r.sirenum__Client__c from sirenum__Team__c where Name =:jobrole and sirenum__Account__r.sirenum__Client__c =: AccountID and Name != '' and sirenum__Inactive__c = false];
        System.debug('check joblist'+joblist);
        LIst<sirenum__site__c> sitelist = [Select id,name,IP_ClientIDLegacy__c from sirenum__site__c where IP_ClientIDLegacy__c =:siteid and IP_ClientIDLegacy__c != ''];
            for(IP_BatchLine__c bline1 : batchlinelist)
            {              
               if(bline1.IP_Status__c != 'Errored' && (bline1.IP_TextField7__c == null || bline1.IP_TextField7__c == ''))
               {
                if(joblist.size()>0)
                { 
                    if(joblist.size()>1)
                    {
                        bline1.IP_Status__c = 'Errored';
                        bline1.IP_ErrorReason__c  = 'Multiple Job Roles found';
                    }
                    else
                    {
                        bline1.IP_LinkField3__c  = joblist[0].id;
                    }
                }
                else
                {
                    bline1.IP_Status__c = 'Errored';
                    bline1.IP_ErrorReason__c  = 'Job Role not found';
                }
                if(sitelist.size()>0)
                {
                bline1.IP_LinkField2__c= sitelist[0].id;
                }
                else
                {
                    bline1.IP_Status__c  = 'Errored';
                    bline1.IP_ErrorReason__c  = 'Site not found';

                }
                System.debug('Check 123'+bline1.IP_Status__c);
                }
                
            }
        
        
         for(IP_BatchLine__c batchline1 : batchlinelist){
            PayrollID.add(batchline1.IP_TextField2__c);
            datefield.add(batchline1.IP_DateField2__c);
        }
        Boolean ExternalIDcheck = false;
         Set<String> Assignmentref = new Set<String>();
        for(IP_BatchLine__c batchline3 : batchlinelist)
         {
             if(batchline3.IP_TextField7__c != null)
             {
                 ExternalIDcheck = true;
                 Assignmentref.add(batchline3.IP_TextField7__c);
             }
             else
             {
                 ExternalIDcheck = false;
             }
         }
        
        Map<Date,Integer> elCount = new Map<Date,Integer>();
        Map<String,String> placemap = new Map<String,String>();
        for(date key : datefield){
            setdate.add(key);
            if(!elCount.containsKey(key)){
            elCount.put(key,0);  }

            Integer currentInt=elCount.get(key)+1;
            elCount.put(key,currentInt);
        }
        Map<string,IP_PayProfile__c> payprofilemap = new Map<string,IP_PayProfile__c>();
        for(sirenum__placement__c pl: [Select id,sirenum__Contact__c,IP_ExternalAssignmentID__c from sirenum__placement__c where IP_ExternalAssignmentID__c IN:Assignmentref])
        {
            placemap.put(pl.IP_ExternalAssignmentID__c,pl.sirenum__Contact__c);
        }
        for(IP_PayProfile__c pay : [select id,name,IP_Candidate__c,IP_Candidate__r.Name,IP_CompanyRegNo__c,IP_VATNumber__c,
                                    IP_PayrollID__c,IP_MissingPayrollDetail__c,IP_Status__c from IP_PayProfile__c where IP_PayrollID__c IN :PayrollID and IP_PayrollID__c!=null]){
            payprofilemap.put(pay.IP_PayrollID__c,pay);
            Contactname.put(pay.id,pay.IP_Candidate__r.Name);
        }
        system.debug('pay profile map'+payprofilemap);
          for(IP_BatchLine__c batchline2 : batchlinelist){
              if(batchline2.IP_Status__c != 'Errored')
              {
            if(batchline2.IP_TextField2__c != '' && batchline2.IP_TextField2__c != null)
              {
                if(payprofilemap.size()>0 && batchline2.IP_TextField2__c!=null && payprofilemap.containskey(batchline2.IP_TextField2__c)){
                    if((payprofilemap.get(batchline2.IP_TextField2__c).IP_MissingPayrollDetail__c == '' || payprofilemap.get(batchline2.IP_TextField2__c).IP_MissingPayrollDetail__c == null) && payprofilemap.get(batchline2.IP_TextField2__c).IP_Status__c == 'Active')
                    {
                    batchline2.IP_LinkField1__c = payprofilemap.get(batchline2.IP_TextField2__c).IP_Candidate__c; 
                    contactid.add(payprofilemap.get(batchline2.IP_TextField2__c).IP_Candidate__c);
                    batchline2.IP_Status__c ='Linking';
                    }
                    else
                    {
                        batchline2.IP_Status__c = 'Errored';   
                        batchline2.IP_ErrorReason__c = 'Only pay profile compliant candidates can be assigned to shifts';
                    }
            }           
            // Search for contact thirdpartyid           
            else{
                batchline2.IP_Status__c = 'Errored';   batchline2.IP_ErrorReason__c = 'Contact not found';
                }
            }
              else if(batchline2.IP_TextField7__c != '' && batchline2.IP_TextField7__c != null)
              {
                 if(placemap.containsKey(batchline2.IP_TextField7__c))
                 {
                    batchline2.IP_LinkField1__c = placemap.get(batchline2.IP_TextField7__c); 
                    batchline2.IP_Status__c ='Linking';                 
                 }                   
              }
              else
              {
                batchline2.IP_Status__c = 'Errored';   batchline2.IP_ErrorReason__c = 'Candidate ID not provided for the Batch line';  
              }
        }
          }
         list<sirenum__Timesheet__c> newtimesheet = new list<sirenum__Timesheet__c>();
         list<sirenum__Placement__c> placementlist = new list<sirenum__Placement__c>();
         
         Set<ID> placeid = new Set<ID>();
         
         
         System.debug('ExternalIDcheck--->'+ExternalIDcheck);
         if(ExternalIDcheck == true)
         {
            placementlist = [select id,IP_PayrollStatus__c,sirenum__Site__r.sirenum__Operating_Company__c, sirenum__Site__r.sirenum__Operating_Company__r.name,name,sirenum__Contact__c,IP_ExternalAssignmentID__c,sirenum__Start_Date__c,sirenum__End_Date__c,sirenum__Status__c,sirenum__Site__c,sirenum__Job_Role__c from sirenum__Placement__c where IP_ExternalAssignmentID__c IN : Assignmentref and sirenum__Status__c = 'Active' and sirenum__Site__r.sirenum__Operating_Company__c =: AccountID and  IP_PayrollStatus__c=null];
            for(IP_BatchLine__c batchline4 : batchlinelist){
                if(batchline4.IP_Status__c != 'Errored')
                {
                    if(placementlist.size()>0)
                    {   
                        placeid.add(placementlist[0].id);
                        batchline4.IP_LinkField4__c = placementlist[0].id;
                        batchline4.IP_LinkField2__c = placementlist[0].sirenum__Site__c;
                        batchline4.IP_LinkField3__c = placementlist[0].sirenum__Job_Role__c;
                        batchline4.IP_Status__c = 'Linked';
                    }
                    else
                    {
                        batchline4.IP_Status__c = 'Errored';   batchline4.IP_ErrorReason__c = 'S-placement corresponding to External Ref not found';
                    }
                }
               /* else if(batchline4.IP_TextField2__c == null || batchline4.IP_TextField2__c == '')
                {
                    batchline4.IP_Status__c = 'Errored';
                    batchline4.IP_ErrorReason__c = 'Candidate ID not provided for the Batch line';
                }*/
                else
                {                    
                     if(batchline4.IP_LinkField1__c==null)
                        {
                           /* if(payprofilemap.get(batchline4.IP_TextField2__c).IP_MissingPayrollDetail__c != '' || payprofilemap.get(batchline4.IP_TextField2__c).IP_MissingPayrollDetail__c != null || payprofilemap.get(batchline4.IP_TextField2__c).IP_Status__c != 'Active')
                            {
                                batchline4.IP_ErrorReason__c = 'Only pay profile compliant candidates can be assigned to shifts';
                            }
                            else
                            {
                                batchline4.IP_ErrorReason__c = 'Contact not found';
                            }*/
                            system.debug('batchline4.IP_ErrorReason__c'+batchline4.IP_ErrorReason__c);
                            if(batchline4.IP_ErrorReason__c == 'Only pay profile compliant candidates can be assigned to shifts')
                            {
                                batchline4.IP_ErrorReason__c = 'Only pay profile compliant candidates can be assigned to shifts';                               
                            }
                            else
                            {
                                 batchline4.IP_ErrorReason__c = 'Contact not found';
                            }
                            
                            
                        }
                    else if(batchline4.IP_LinkField2__c==null)
                        {
                            batchline4.IP_ErrorReason__c = 'Site not found';
                        }
                    else
                    {    
                     if(batchline4.IP_ErrorReason__c == 'Multiple Job Roles found')
                            {
                                batchline4.IP_ErrorReason__c = 'Multiple Job Roles found';
                            }
                            else
                            {
                                batchline4.IP_ErrorReason__c = 'Job Role not found';
                            }
                    }
                }
            }

         }
         else
         {
            Boolean updateplace = false;
            String placename;
            
            placementlist = [select id,IP_PayrollStatus__c,sirenum__Site__r.sirenum__Operating_Company__c, sirenum__Site__r.sirenum__Operating_Company__r.name,name,sirenum__Contact__c,IP_AssignmentRef__c,sirenum__Start_Date__c,sirenum__End_Date__c,sirenum__Status__c,sirenum__Site__c,sirenum__Job_Role__c,sirenum__Job_Role__r.Name,sirenum__Site__r.IP_ClientIDLegacy__c from sirenum__Placement__c where sirenum__Status__c = 'Active' and IP_PayrollStatus__c=null and sirenum__Contact__c in : contactid and sirenum__Site__c =:sitelist and  sirenum__Job_Role__c =: joblist];
            system.debug('check placement list'+placementlist);
            for(IP_BatchLine__c batchline5 : batchlinelist)
            {
                if(batchline5.IP_Status__c != 'Errored')
                {
                If(placementlist.size()>0 ){
                    integer counter = 0;
                   // if(batchline5.IP_Status__c != 'Errored'){
                    for(Integer i = 0;i<placementlist.size();i++){
                        if(batchline5.IP_LinkField1__c == placementlist[i].sirenum__Contact__c && batchline5.IP_LinkField2__c  == placementlist[i].sirenum__Site__c && batchline5.IP_LinkField3__c == placementlist[i].sirenum__Job_Role__c)
                        {
                            if(counter == 0)
                            {
                            if(placementlist[i].sirenum__End_Date__c < batchline5.IP_DateField2__c)
                            {
                                placementlist[i].sirenum__End_Date__c = batchline5.IP_DateField2__c;
                                batchline5.IP_LinkField4__c = placementlist[i].id;
                                batchline5.IP_Status__c = 'linked';
                                placeid.add(placementlist[i].id);
                               // updateplace = true;
                                counter++;
                                System.debug('inside update if 1'+batchline5.IP_LinkField4__c);
                                System.debug('inside update if 2'+batchline5.IP_Status__c);
                                
                            }
                            else
                            {
                                batchline5.IP_LinkField4__c = placementlist[i].id;
                                batchline5.IP_Status__c = 'linked';
                                placeid.add(placementlist[i].id);
                                System.debug('check placeid set'+placeid);
                            }
                            }
                            else
                            {
                                batchline5.IP_Status__c = 'Errored'; 
                                batchline5.IP_ErrorReason__c = 'There is more than one active placement for this candidate';
                            }
                        }
                    //}
                    system.debug('check placement list before update'+placementlist);
                    update placementlist;
                    }
                }
                        else
                        {
                            System.debug('check inside Placement creation');
                            IP_PayProfile__c pay;
                            Contact con = [Select id,RecordType.developername from Contact where id =:batchline5.IP_LinkField1__c];
                                    if(con.RecordType.developername!='IP_2ndTierCandidate')
                                    {
                                    pay = [Select id from IP_PayProfile__c where IP_PayrollID__c =:batchline5.IP_TextField2__c];
                                    }   
                            sirenum__Placement__c ps = new sirenum__Placement__c();
                            ps.sirenum__Contact__c = batchline5.IP_LinkField1__c;
                            ps.sirenum__site__c = batchline5.IP_LinkField2__c;
                            ps.sirenum__Start_Date__c = batchline5.IP_DateField2__c;
                            ps.sirenum__Status__c = 'Active';
                            ps.sirenum__End_Date__c = batchline5.IP_DateField2__c;
                            ps.sirenum__Job_Role__c = batchline5.IP_LinkField3__c;
                            if(pay!=null)
                                {
                                    ps.IP_PayMethod__c =  pay.id;
                                    placename = joblist[0].name+'-'+Contactname.get(pay.id);
                                    if(placename.length()>80)
                                    {
                                        ps.Name = placename.substring(0,80);
                                    }
                                    else
                                    {
                                        ps.Name = joblist[0].name+'-'+Contactname.get(pay.id);
                                    }   
                                }
                            else
                                {
                                    placename = joblist[0].name+'-'+Contactname.get(pay.id);
                                    if(placename.length()>80)
                                    {
                                        ps.Name = placename.substring(0,80);
                                    }
                                    else
                                    {
                                        ps.Name = joblist[0].name+'-'+Contactname.get(pay.id);
                                    }     
                                }
                            ps.sirenum__Contract__c = joblist[0].sirenum__Account__c;
                            insert ps;
                            batchline5.IP_LinkField4__c = ps.id;
                            placeid.add(ps.id);
                            system.debug('check placement id'+placeid);
                        }
                    }                   
                else if(batchline5.IP_TextField2__c == null || batchline5.IP_TextField2__c == '')
                {
                    batchline5.IP_Status__c = 'Errored';
                    batchline5.IP_ErrorReason__c = 'Candidate ID not provided for the Batch line';
                }
                else
                {
                      if(batchline5.IP_LinkField2__c==null)
                        {
                            batchline5.IP_ErrorReason__c = 'Site not found';                                 
                        }
                    else if(batchline5.IP_LinkField3__c==null)
                        {
                            
                            if(batchline5.IP_ErrorReason__c == 'Multiple Job Roles found')
                            {
                                batchline5.IP_ErrorReason__c = 'Multiple Job Roles found';
                            }
                            else
                            {
                                batchline5.IP_ErrorReason__c = 'Job Role not found';
                            }
                        }
                    else
                        {
                            system.debug('batchline5.IP_ErrorReason__c'+batchline5.IP_ErrorReason__c);
                            if(batchline5.IP_ErrorReason__c == 'Only pay profile compliant candidates can be assigned to shifts')
                            {
                                batchline5.IP_ErrorReason__c = 'Only pay profile compliant candidates can be assigned to shifts';                               
                            }
                            else
                            {
                                 batchline5.IP_ErrorReason__c = 'Contact not found';
                            }
                        }
                }
            }
         }
            Database.SaveResult[] sList;
            Map<Id,String> Errmsg = new Map<Id,String>();
            List<sirenum__Timesheet__c> tmsheet = [select id,name,sirenum__Worker__c,sirenum__Week_Ending__c,sirenum__Site__r.sirenum__Operating_Company__r.name,sirenum__Team__c,sirenum__Site__c from sirenum__Timesheet__c where sirenum__Worker__c in : contactid and sirenum__Week_Ending__c in :setdate and Id NOT in (Select sirenum__Timesheet__c from sirenum__Timesheet_Line__c where IP_Locktimesheet__c = True)];
            Map<Id,String> timesheetmap = new Map<Id,String>();
            for(IP_BatchLine__c checkbatch : batchlinelist){
            if(tmsheet.size()>0){
                for(sirenum__Timesheet__c timesheet1 :tmsheet ){
                    if(timesheet1.sirenum__Worker__c==checkbatch.IP_LinkField1__c  && timesheet1.sirenum__Week_Ending__c == checkbatch.IP_DateField2__c && timesheet1.sirenum__Site__c == checkbatch.IP_LinkField2__c && timesheet1.sirenum__Team__c == checkbatch.IP_LinkField3__c){
                        timesheetmap.put(timesheet1.sirenum__Worker__c,'Yes');   
                        break;
                    }
                    else{
                        timesheetmap.put(timesheet1.sirenum__Worker__c,'No');  break;                                    
                    }
                }
            }
            else
            {
                timesheetmap.put(checkbatch.IP_LinkField1__c,'No');  
            }
            }
            System.debug('check timesheet map'+timesheetmap);
            for(Date dt :setdate){
            Boolean check=false;
            String bconId ='';
            List<sirenum__Placement__c> placementlist1 = [select id,sirenum__Site__r.sirenum__Operating_Company__c,sirenum__Job_Role__r.sirenum__Rota__c, sirenum__Site__r.sirenum__Operating_Company__r.name,name,sirenum__Contact__c,sirenum__Start_Date__c,sirenum__End_Date__c,sirenum__Status__c,sirenum__Site__c,sirenum__Job_Role__c from sirenum__Placement__c where id in : placeid limit 1];

            for(IP_BatchLine__c batchuniq : batchlinelist){
                If(placementlist1.size()>0 && batchuniq.IP_LinkField4__c!='' ){
                    for(Integer i = 0;i<placementlist1.size();i++){
                        If(batchuniq.IP_LinkField4__c==placementlist1[i].id){
                            if(batchuniq.IP_Status__c != 'Errored' && batchuniq.IP_LinkField4__c!=null 
                                && timesheetmap.get(batchuniq.IP_LinkField1__c)=='No'){
                                if(batchuniq.IP_DateField2__c==dt && bconId!= batchuniq.IP_LinkField1__c){
                                    sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
                                    newTimeSheet1.sirenum__Worker__c = batchuniq.IP_LinkField1__c;
                                    newTimesheet1.sirenum__Client__c=placementlist1[i].sirenum__Site__r.sirenum__Operating_Company__c;
                                    newTimesheet1.sirenum__Team__c=placementlist1[i].sirenum__Job_Role__c;
                                    newTimesheet1.sirenum__Site__c=placementlist1[i].sirenum__Site__c;
                                    newTimesheet1.sirenum__Week_Ending__c =batchuniq.IP_DateField2__c;
                                    bconId = batchuniq.IP_LinkField1__c;
                                    newtimesheet.add(newTimeSheet1); 
                                    check=true;
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
         try{ 
            sList=  Database.insert(newtimesheet,false);
        }
                  
        catch(Exception DMLException){  }
        for (Database.SaveResult sr : sList) {
            if (sr.isSuccess()) {
                System.debug('Successfully inserted Timesheet: ' + sr.getId());
                Errmsg.put(sr.getId(),'Success');
            }
            else {
                for(Database.Error err : sr.getErrors()) {  
                    Errmsg.put(sr.getId(),err.getMessage());
                }
            }
        }
         for(IP_BatchLine__c batchtimesheet : batchlinelist){
            If(timesheetmap.get(batchtimesheet.IP_LinkField1__c)=='No'){
                for(sirenum__Timesheet__c t : newtimesheet){
                    If(batchtimesheet.IP_Status__c!='Errored' && batchtimesheet.IP_DateField2__c==t.sirenum__Week_Ending__c 
                            && batchtimesheet.IP_LinkField1__c == t.sirenum__Worker__c ){
                        If(Errmsg.get(t.Id)!='Success'){
                            batchtimesheet.IP_Status__c='Errored';  
                            if(Errmsg.get(t.Id).length()>255)
                            {
                                batchtimesheet.IP_ErrorReason__c=Errmsg.get(t.Id).SubString(0,255);
                            }
                            else
                            {
                                batchtimesheet.IP_ErrorReason__c=Errmsg.get(t.Id);
                            }
                        }
                        else{
                            batchtimesheet.IP_LinkField5__c = t.Id;
                        }
                    }
                }
            }
            else{
                for(sirenum__Timesheet__c stimesheet : tmsheet){
                    If(batchtimesheet.IP_Status__c != 'Errored' && batchtimesheet.IP_DateField2__c==stimesheet.sirenum__Week_Ending__c && batchtimesheet.IP_LinkField1__c == stimesheet.sirenum__Worker__c ){
                        batchtimesheet.IP_LinkField5__c = stimesheet.Id;
                    }
                }
            }
        }
        
         // Creation of Shift--------
        Database.SaveResult[] saveList;
        Map<Id,sirenum__Shift__c> shiftmap = new Map<Id,sirenum__Shift__c>();
        String sheetnumber;
        Map<Id,String> Errormsg1 = new Map<Id,String>();
        Map<Id,String> suique = new Map<Id,String>();
        system.debug('check placement id'+placeid);
        List<sirenum__Placement__c> placement = [select id,sirenum__Site__r.sirenum__Operating_Company__c,sirenum__Job_Role__r.sirenum__Rota__c,sirenum__Site__r.sirenum__Operating_Company__r.name,name,sirenum__Contact__c,sirenum__Start_Date__c,sirenum__End_Date__c,sirenum__Status__c,sirenum__Site__c,sirenum__Job_Role__c from sirenum__Placement__c where id in : placeid limit 1];
        List<sirenum__Shift__c> shiftList = new List<sirenum__Shift__c>();
        System.debug('@@ $$ '+newtimesheet);
        System.debug('@@ $$ '+placement);
        If(newtimesheet.size()>0 && placement.size()>0){
            System.debug('@@ '+sheetnumber);
            for(sirenum__Timesheet__c timesheet2 :newtimesheet ){
                sirenum__Shift__c shift = new sirenum__Shift__c();
                shift.sirenum__Site__c = placement[0].sirenum__Site__c;
                shift.sirenum__Placement__c = placement[0].Id;
                shift.sirenum__Team__c = placement[0].sirenum__Job_Role__c;
                shift.sirenum__Contact__c = placement[0].sirenum__Contact__c;
                shift.sirenum__Timesheet_summaries__c = timesheet2.Id;               
                shift.sirenum__Scheduled_Start_Time__c = timesheet2.sirenum__Week_Ending__c;
                shift.sirenum__Scheduled_End_Time__c = timesheet2.sirenum__Week_Ending__c;                
                shift.sirenum__Rota__c = placement[0].sirenum__Job_Role__r.sirenum__Rota__c;
                shiftList.add(shift);
                shiftmap.put(timesheet2.id, shift);
                system.debug('sheetnumber '+sheetnumber);

                break;
            // }
            }

        }

        try{
            saveList =  Database.insert(shiftList,false);     
        } 
        catch(Exception DMLException){       }
         for (Database.SaveResult sr : saveList) {
            if (sr.isSuccess()) {
                System.debug('Successfully inserted Shift. Shift ID: ' + sr.getId());
                Errormsg1.put(sr.getId(),'Success');
            }
            else {
                for(Database.Error err : sr.getErrors()) {     
                    Errormsg1.put(sr.getId(),err.getMessage());
                }
            }
        }
        Database.SaveResult[] srList;
        // If shift is not available in shift then it will pick old created shifts and attach timesheetline to them        
        Map<Id,sirenum__Shift__c> oldshiftmap = new Map<Id,sirenum__Shift__c>();
        List<sirenum__Shift__c> oldshift = new List<sirenum__Shift__c>();
        if(shiftmap.size()==0){
            for(sirenum__Shift__c sf : [select id,sirenum__Timesheet_summaries__r.id from sirenum__Shift__c where sirenum__Timesheet_summaries__c 
                                in: tmsheet and sirenum__Placement__c =:placeid]){ 
                oldshiftmap.put(sf.sirenum__Timesheet_summaries__r.id, sf);
                oldshift.add(sf);                          
            }
        }
        system.debug('oldshift list'+oldshift);
             for(IP_BatchLine__c batchshift : batchlinelist){
            If(shiftList.size()>0){
                for(sirenum__Shift__c s : shiftList){
                    If(batchshift.IP_Status__c!='Errored' && batchshift.IP_LinkField5__c == s.sirenum__Timesheet_summaries__c){
                        If(Errormsg1.get(s.Id)!='Success'){
                            batchshift.IP_Status__c='Errored'; 
                            if(Errormsg1.get(s.Id).length()>255)
                            {
                                batchshift.IP_ErrorReason__c=Errormsg1.get(s.Id).SubString(0,255);
                            }
                            else
                            {
                                batchshift.IP_ErrorReason__c=Errormsg1.get(s.Id);
                            }
                        }
                        else{
                            batchshift.IP_LinkField6__c = s.Id;
                        }
                    }
                }
            }
            else{
                if(oldshift.size()>0){
                    for(sirenum__Shift__c s : oldshift){
                        If(batchshift.IP_Status__c != 'Errored' && batchshift.IP_LinkField5__c == s.sirenum__Timesheet_summaries__c){
                            batchshift.IP_LinkField6__c = s.Id;
                        }
                    }
                }
                else{
                    if(batchshift.IP_Status__c != 'Errored'){
                        batchshift.IP_Status__c = 'Errored';
                        batchshift.IP_ErrorReason__c = 'Shift not found';
                        //  errorlist.add(batchshift);
                        // errorid.add(batchshift.id);
                    }
                }
            }
        }
         Map<Id,String> Errormsg = new Map<Id,String>();
        // creating timesheet line
        list<sirenum__Timesheet_Line__c> timesheetline = new list<sirenum__Timesheet_Line__c >(); 
        for(IP_BatchLine__c batchline6 : batchlinelist){
            If(timesheetmap.get(batchline6.IP_LinkField1__c)=='No'){
                for(Integer i=0;i<newtimesheet.size();i++ ){
                    if(shiftmap.size()>0 && batchline6.IP_Status__c != 'Errored' && batchline6.IP_DateField2__c== newtimesheet[i].sirenum__Week_Ending__c && batchline6.IP_LinkField1__c==newtimesheet[i].sirenum__Worker__c){
                        sirenum__Timesheet_Line__c timeSheetLine1 = new sirenum__Timesheet_Line__c();
                        timeSheetLine1.sirenum__Timesheet__c =  newtimesheet[i].id;  
                        timeSheetLine1.sirenum__Rate__c      =  batchline6.IP_CurrencyField1__c;
                        timeSheetLine1.sirenum__Hours__c     =  batchline6.IP_Number12d4Field1__c; 
                        timeSheetLine1.IP_RateCodes__c       =  batchline6.IP_TextField3__c;
                        timeSheetLine1.For_BatchClass__c     =  true;
                        timeSheetLine1.sirenum__Charge__c    =  batchline6.IP_CurrencyField2__c;
                        timeSheetLine1.Batchvalue__c         =  batchline6.Name;
                        if(batchline6.IP_DateField1__c != null)
                        {
                            timeSheetLine1.sirenum__Date__c      =  batchline6.IP_DateField1__c;
                        }
                        else
                        {
                            timeSheetLine1.sirenum__Date__c      =  batchline6.IP_DateField2__c;
                        }
                        timeSheetLine1.IP_PurchaseOrderNumber__c = batchline6.IP_TextField4__c;
                        timesheetLine1.sirenum__Shift__c = shiftmap.get(newtimesheet[i].id).id;
                        timesheetline.add(timeSheetLine1);

                        break;
                    }
                }
            } 
            else{
                system.debug('tmsheet.size() '+tmsheet.size());
                for(Integer i=0;i<tmsheet.size();i++){
                    system.debug('tmsheet[i].sirenum__Week_Ending__c '+tmsheet[i].sirenum__Week_Ending__c);
                    if(oldshiftmap.size()>0 && batchline6.IP_Status__c != 'Errored' && 
                            batchline6.IP_DateField2__c== tmsheet[i].sirenum__Week_Ending__c && 
                            batchline6.IP_LinkField1__c==tmsheet[i].sirenum__Worker__c){
                        sirenum__Timesheet_Line__c timeSheetLine1 = new sirenum__Timesheet_Line__c();
                        timeSheetLine1.sirenum__Timesheet__c =  tmsheet[i].id;  
                        timeSheetLine1.sirenum__Rate__c      =  batchline6.IP_CurrencyField1__c;
                        timeSheetLine1.sirenum__Hours__c     =  batchline6.IP_Number12d4Field1__c; 
                        timeSheetLine1.IP_RateCodes__c       =  batchline6.IP_TextField3__c;
                        timeSheetLine1.For_BatchClass__c     =  true;
                        timeSheetLine1.sirenum__Charge__c    =  batchline6.IP_CurrencyField2__c;
                        timeSheetLine1.Batchvalue__c         =  batchline6.Name;
                        if(batchline6.IP_DateField1__c != null)
                        {
                            timeSheetLine1.sirenum__Date__c      =  batchline6.IP_DateField1__c;
                        }
                        else
                        {
                            timeSheetLine1.sirenum__Date__c      =  batchline6.IP_DateField2__c;
                        }
                        timeSheetLine1.IP_PurchaseOrderNumber__c = batchline6.IP_TextField4__c;
                        timesheetLine1.sirenum__Shift__c = oldshiftmap.get(tmsheet[i].id).id;
                        timesheetline.add(timeSheetLine1);
                        break;
                    }

                }
                              
            }

        }
                  
        try{
            srList =  Database.insert(timesheetline,false);     
        } 
        catch(Exception DMLException){       }
        system.debug('timesheetline'+timesheetline);
        
        for (Database.SaveResult sr : srList) {
        if (sr.isSuccess()) {
            System.debug('Successfully inserted Timesheetline. Timesheetline ID: ' + sr.getId());
             Errormsg.put(sr.getId(),'Success');
          } 
        else {
               for(Database.Error err : sr.getErrors()) {
               Errormsg.put(sr.getId(),err.getMessage());
              }         
            }
        }
        // mapping of timesheetline on Batchline field linkfield5
        for(sirenum__Timesheet_Line__c timeline : timesheetline){
            for(IP_BatchLine__c batchline7: batchlinelist){
                if( batchline7.IP_Status__c != 'Errored' && timeline.Batchvalue__c==batchline7.Name && 
                    timesheetmap.get(batchline7.IP_LinkField1__c) =='No'){
                    System.debug('IN IF batchline7.name -- '+batchline7.Name);
                    If(Errormsg.get(timeline.Id)!='Success'){
                        batchline7.IP_Status__c='Errored'; 
                            if(Errormsg.get(timeline.Id).length()>255)
                            {
                                batchline7.IP_ErrorReason__c=Errormsg.get(timeline.Id).subString(0,255);
                            }
                            else
                            {
                                batchline7.IP_ErrorReason__c=Errormsg.get(timeline.Id);
                            }
                    }
                    else{
                        batchline7.IP_LinkField7__c = timeline.id; 
                        batchline7.IP_Status__c = 'Processed';
                    }

                }
                else{
                    for(sirenum__Timesheet__c stimesheet : tmsheet){
                        If( timeline.Batchvalue__c==batchline7.Name && batchline7.IP_Status__c != 'Errored' && 
                            batchline7.IP_DateField2__c==stimesheet.sirenum__Week_Ending__c && 
                            batchline7.IP_LinkField1__c == stimesheet.sirenum__Worker__c ){
                            If(Errormsg.get(timeline.Id)!='Success'){
                                batchline7.IP_Status__c='Errored';
                                if(Errormsg.get(timeline.Id).length()>255)
                            {
                                batchline7.IP_ErrorReason__c=Errormsg.get(timeline.Id).subString(0,255);
                            }
                            else
                            {
                                batchline7.IP_ErrorReason__c=Errormsg.get(timeline.Id);
                            }
                            }
                            else{
                                batchline7.IP_LinkField7__c = timeline.Id;
                                batchline7.IP_Status__c = 'Processed';
                            }
                        }
                    }
                }
            }
        }                        
        update batchlinelist;
     
      List<Batch_header__c> batchheaderlist = new List<Batch_header__c>();
        
        for(Batch_header__c batchHeader : [Select id,IP_State__c,IP_Status__c,Check_Status__c from  Batch_header__c 
                                            where id in: headerId and ID NOT IN : setUpdatedBatchHeaderId]){
            setUpdatedBatchHeaderId.add(batchHeader.id);
            batchHeader.Check_Status__c = 'true';               
            batchheaderlist.add(batchHeader);
        }

        if(!batchheaderlist.isEmpty()){
            update batchheaderlist;
        }
        joblist.clear();
        sitelist.clear();

        //Batch_header__c batchheaderlist = [Select id,IP_State__c,IP_Status__c,Check_Status__c from  Batch_header__c where id in: headerId];
        //batchheaderlist.Check_Status__c = 'true';
        //update batchheaderlist;
    }
    
    global void finish(Database.BatchableContext BC){
        Map<Id,Integer> mapUnprocessedBatchHeader = new Map<Id,Integer>();
        Map<Id,Integer> mapErroredBatchHeader = new Map<Id,Integer>();      
        
        /*Batch_header__c  bheader = [Select id,IP_Status__c,IP_State__c,Check_status__c from Batch_header__c  where id=:headerId limit 1];

        List<IP_Batchline__c> unprocesssed= [Select id,IP_Status__c from IP_Batchline__c where IP_batchheader__c =:headerId and IP_Status__c = 'Open'];
        List<IP_Batchline__c> erroredlines= [Select id,IP_Status__c from IP_Batchline__c where IP_batchheader__c =:headerId and IP_Status__c = 'Errored'];
        
        if(unprocesssed.size()>0){
            bheader.IP_Status__c = 'Partial Complete';
            bheader.IP_State__c = 'Processing';
        }
        else if(erroredlines.size()>0){
            bheader.IP_Status__c = 'Errored';
            bheader.IP_State__c = 'Processing';
        }
        else        {
            //bheader.IP_Status__c = 'Complete';
            //bheader.IP_State__c = 'Processing';
            //[10918]:Update status to Processed on Close Batch button
            bheader.IP_Status__c = 'Processed';
            bheader.IP_State__c = 'Closed';
        }
        bheader.Check_status__c = '';
        update bheader;*/
        
        for(Batch_header__c openStatusBatchHeader : [Select id,IP_Status__c,IP_State__c,Check_status__c,(Select id,IP_Status__c from Batch_Lines__r 
                                                    where IP_Status__c = 'Open') from Batch_header__c  where id=:headerId]){
            if(!openStatusBatchHeader.Batch_Lines__r.isEmpty() && openStatusBatchHeader.Batch_Lines__r.size()>0){
                mapUnprocessedBatchHeader.put(openStatusBatchHeader.id,openStatusBatchHeader.Batch_Lines__r.size());
            }           
        }
        System.debug('mapUnprocessedBatchHeader -- '+mapUnprocessedBatchHeader);
        
        for(Batch_header__c  erroredBatchHeader : [Select id,IP_Status__c,IP_State__c,Check_status__c,(Select id,IP_Status__c from Batch_Lines__r 
                                                    where IP_Status__c = 'Errored' Limit 1) from Batch_header__c  where id=:headerId]){
            if(!erroredBatchHeader.Batch_Lines__r.isEmpty() && erroredBatchHeader.Batch_Lines__r.size()>0){
                mapErroredBatchHeader.put(erroredBatchHeader.id,erroredBatchHeader.Batch_Lines__r.size());
            }           
        }
        System.debug('mapErroredBatchHeader -- '+mapErroredBatchHeader);
        
        List<Batch_header__c> listBatchHeaderUpdate = new List<Batch_header__c>();
        
        for(Batch_header__c  batchHeader : [Select id,IP_BatchTitle__c,Name,IP_Status__c,IP_State__c,Check_status__c 
                                                from Batch_header__c  where id=:headerId]){
            if(!mapUnprocessedBatchHeader.isEmpty() && mapUnprocessedBatchHeader.get(batchHeader.id)>0){
                batchHeader.IP_Status__c = 'Partial Complete';
                batchHeader.IP_State__c = 'Processing';
            }
            else if(!mapErroredBatchHeader.isEmpty() && mapErroredBatchHeader.get(batchHeader.id)>0){
                batchHeader.IP_Status__c = 'Errored';
                batchHeader.IP_State__c = 'Processing';
            }
            else{
                //[10918]:Update status to Processed on Close Batch button
                  batchHeader.IP_Status__c = 'Processed';
                  batchHeader.IP_State__c = 'Closed';
            }
            batchHeader.Check_status__c = '';
            listBatchHeaderUpdate.add(batchHeader);
        }
        System.debug('listBatchHeaderUpdate -- '+listBatchHeaderUpdate);        
        
        if(!listBatchHeaderUpdate.isEmpty()){
            update listBatchHeaderUpdate;
        }
    }
}