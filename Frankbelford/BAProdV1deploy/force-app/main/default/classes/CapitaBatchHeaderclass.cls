global class CapitaBatchHeaderclass extends batchjobsch.BatchJobBase implements Database.Batchable<sObject>,Database.Stateful{
    
    Set<ID> headerId = new Set<ID>();
    Set<Id> setUpdatedBatchHeaderId = new Set<Id>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    //  String  query = 'select Id,IP_State__c,IP_Status__c,IP_BatchType__c from Batch_header__c where IP_BatchType__c=\'Capita\' And ((IP_State__c = \'Open\' And IP_Status__c = \'Approved\') OR (IP_State__c = \'Processing\' AND IP_Status__c = \'Errored\') OR (IP_State__c = \'Processing\' AND IP_Status__c = \'Partial Complete\') OR (IP_State__c = \'Processing\' AND IP_Status__c = \'Complete\')) ';
        String query ='select id,name,IP_LinkField3__c,IP_DateField2__c,IP_BatchHeader__r.name,IP_LinkField5__c,IP_LinkField1__c,IP_LinkField4__c,IP_Status__c,IP_TextField2__c,IP_TextField3__c,IP_TextField1__c,IP_DateField1__c,IP_CurrencyField1__c,IP_CurrencyField2__c,IP_Number12d4Field1__c,IP_TextField4__c from IP_BatchLine__c where IP_Status__c = \'open\' AND IP_BatchHeader__r.IP_BatchType__c=\'Capita\' And ((IP_BatchHeader__r.IP_State__c = \'Closed\' And IP_BatchHeader__r.IP_Status__c = \'Approved\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Errored\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Partial Complete\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Complete\'))';
        return Database.getQueryLocator(query);
    }
        
    global void execute(Database.BatchableContext BC,List<IP_BatchLine__c> batchlinelist){
        
        String bheadername;
        for(IP_BatchLine__c bline : batchlinelist){
            headerId.add(bline.IP_BatchHeader__c);
        }
            
        //   system.debug('Batch Header list'+batchheaderlist);*/
        list<string> PayrollID = new list<string>();
        list<string> contactThirdPartyID = new list<string>();
        List<Date> datefield = new List<Date>();
        Set<Date> setdate= new Set<Date>();
        set<id> contactid = new set<id>();
        // list<IP_BatchLine__c> batchlinelist = [select id,name,IP_LinkField3__c,IP_DateField2__c,IP_BatchHeader__c,IP_LinkField5__c,IP_LinkField1__c,IP_LinkField4__c,IP_Status__c,IP_TextField2__c,IP_TextField3__c,IP_TextField1__c,IP_DateField1__c,IP_CurrencyField1__c,IP_CurrencyField2__c,IP_Number12d4Field1__c,IP_TextField4__c from IP_BatchLine__c where IP_BatchHeader__c in :batchheaderlist and IP_Status__c = :'open' limit 1000];

        system.debug('Batch line list'+batchlinelist);

        for(IP_BatchLine__c batchline1 : batchlinelist){
            PayrollID.add(batchline1.IP_TextField2__c);
            contactThirdPartyID.add(batchline1.IP_TextField1__c);
            datefield.add(batchline1.IP_DateField2__c);
        }
        
        // Map to eliminate repeated sirenum__Week_Ending__c which is coming from datefield2 of batchline so that we can create only those timesheet  
        Map<Date,Integer> elCount = new Map<Date,Integer>();

        for(date key : datefield){
            setdate.add(key);
            if(!elCount.containsKey(key)){
            elCount.put(key,0);  }

            Integer currentInt=elCount.get(key)+1;
            elCount.put(key,currentInt);
        }
               
        System.debug('setdate -- '+setdate);
        System.debug('elCount -- '+elCount);
        system.debug('payprofile name'+PayrollID);
        system.debug('contactpartyid'+contactThirdPartyID);
        list<contact> conlist = [select id ,IP_CandidateIDlegacy__c,IP_ThirdPartyID__c from contact 
                                where IP_ThirdPartyID__c in :contactThirdPartyID and IP_ThirdPartyID__c!=null];
        system.debug('contactlist'+conlist);
        Map<string,IP_PayProfile__c> payprofilemap = new Map<string,IP_PayProfile__c>();
                   
                  
        for(IP_PayProfile__c pay : [select id,name,IP_Candidate__c,IP_CompanyRegNo__c,IP_VATNumber__c,
                                    IP_PayrollID__c from IP_PayProfile__c where IP_PayrollID__c IN :PayrollID and IP_PayrollID__c!=null]){
            payprofilemap.put(pay.IP_PayrollID__c,pay);
        }
        system.debug('pay profile map'+payprofilemap);
             
        // finding contact id from pay profile  
        for(IP_BatchLine__c batchline2 : batchlinelist){
            if(payprofilemap.size()>0 && batchline2.IP_TextField2__c!=null && payprofilemap.containskey(batchline2.IP_TextField2__c)){
                //contactid.add(payprofilemap.get(batch2.id).IP_Candidate__c); 
                batchline2.IP_LinkField1__c = payprofilemap.get(batchline2.IP_TextField2__c).IP_Candidate__c; 
                contactid.add(payprofilemap.get(batchline2.IP_TextField2__c).IP_Candidate__c);
                batchline2.IP_Status__c ='Linking';
            }           
            // Search for contact thirdpartyid
            else IF(conlist.size()>0 && batchline2.IP_TextField1__c!=null){
                for(contact con :conlist){
                    System.debug('## '+batchline2.IP_TextField1__c);
                    System.debug('##@@ '+con.IP_ThirdPartyID__c);
                    if(batchline2.IP_TextField1__c == con.IP_ThirdPartyID__c){
                        batchline2.IP_LinkField1__c = con.id;
                        contactid.add(con.id); 
                        batchline2.IP_Status__c ='Linking'; 
                    }
                }
            }
            else{
                batchline2.IP_Status__c = 'Errored';   batchline2.IP_ErrorReason__c = 'contact Not found';
            }
        }
         
        // Finding S-placement from ContactId and mapping on Batchline linkfield3
        list<sirenum__Timesheet__c> newtimesheet = new list<sirenum__Timesheet__c>();
        list<sirenum__Placement__c> placementlist = [select id,IP_PayrollStatus__c,sirenum__Site__r.sirenum__Operating_Company__c, 
                                        sirenum__Site__r.sirenum__Operating_Company__r.name,name,sirenum__Contact__c,sirenum__Start_Date__c,
                                        sirenum__End_Date__c,sirenum__Status__c,sirenum__Site__c,sirenum__Job_Role__c 
                                        from sirenum__Placement__c where sirenum__Contact__c in : contactid  
                                        and IP_PayrollStatus__c=null and sirenum__Site__c != null];
        system.debug('placement list '+placementlist );
        Set<ID> placeid = new Set<ID>();
        List<Date> d = new List<Date>();
        for(IP_BatchLine__c batchline4 : batchlinelist){
            If(batchline4.IP_LinkField1__c!=null){
                If(placementlist.size()>0 ){
                    system.debug('Test '+placementlist );
                    integer counter = 0;

                    if(batchline4.IP_Status__c != 'Errored'){
                        for(Integer i = 0;i<placementlist.size();i++){
                            system.debug('batchline4.IP_LinkField1__ctest '+ batchline4.IP_LinkField1__c);
                            system.debug('placement.sirenum__Contact__c '+ placementlist[i].sirenum__Contact__c);
                              if(batchline4.IP_LinkField1__c == placementlist[i].sirenum__Contact__c && placementlist[i].sirenum__Status__c == 'Active'&& placementlist[i].sirenum__Site__r.sirenum__Operating_Company__r.name.contains('Capita')  && (placementlist[i].sirenum__Start_Date__c <= batchline4.IP_DateField1__c)  ){
                                if(counter == 0){
                                     if(placementlist[i].sirenum__End_Date__c<batchline4.IP_DateField1__c)
                                           {
                                            placementlist[i].sirenum__End_Date__c = batchline4.IP_DateField1__c;
                                           }
                                    batchline4.IP_LinkField3__c = placementlist[i].id;
                                    batchline4.IP_Status__c = 'linked';
                                    placeid.add(placementlist[i].id);
                                    counter++;
                                }
                                else{
                                    batchline4.IP_Status__c = 'Errored';     
                                    batchline4.IP_ErrorReason__c = 'There is more than one active placement for this candidate with capita for this payroll week';

                                }
                            }
                        }

                        If(batchline4.IP_Status__c != 'Errored' && batchline4.IP_LinkField3__c==null){
                            batchline4.IP_Status__c = 'Errored';                                       
                            batchline4.IP_ErrorReason__c = 'No active s-placement for this candidate with capita for this payroll week ';
                            batchline4.IP_LinkField3__c='';
                        }

                    } 
                }
                else{
                    batchline4.IP_Status__c = 'Errored';                                       
                    batchline4.IP_ErrorReason__c = 'No active s-placement for this candidate with capita for this payroll week ';
                    batchline4.IP_LinkField3__c='';
                } 
            }
            else{
                batchline4.IP_Status__c = 'Errored';   
                batchline4.IP_ErrorReason__c = 'contact Not found';
            }
        }
           update placementlist;
        Database.SaveResult[] sList;
        Map<Id,String> Errmsg = new Map<Id,String>();
        System.debug('contactid ' +contactid);
        List<sirenum__Timesheet__c> tmsheet = [select id,name,sirenum__Worker__c,sirenum__Week_Ending__c,sirenum__Site__r.sirenum__Operating_Company__r.name 
                                                from sirenum__Timesheet__c where sirenum__Worker__c in : contactid and sirenum__Week_Ending__c in :setdate 
                                                and Id NOT in (Select sirenum__Timesheet__c from sirenum__Timesheet_Line__c where IP_Locktimesheet__c = True)];
        Map<Id,String> timesheetmap = new Map<Id,String>();

        for(IP_BatchLine__c checkbatch : batchlinelist){
            if(tmsheet.size()>0){
                for(sirenum__Timesheet__c timesheet1 :tmsheet ){
                    if(timesheet1.sirenum__Worker__c==checkbatch.IP_LinkField1__c  && timesheet1.sirenum__Week_Ending__c == checkbatch.IP_DateField2__c 
                    && timesheet1.sirenum__Site__r.sirenum__Operating_Company__r.name.contains('Capita')){
                        timesheetmap.put(timesheet1.sirenum__Worker__c,'Yes');   
                        break;
                    }
                    else{
                        timesheetmap.put(timesheet1.sirenum__Worker__c,'No');  break;                                    
                    }
                }
            }
            else{
                timesheetmap.put(checkbatch.IP_LinkField1__c,'No');  
            }
        }
             
        system.debug('timesheetmap'+timesheetmap);
        // Creation of timesheet
        for(Date dt :setdate){
            Boolean check=false;
            String bconId ='';
            for(IP_BatchLine__c batchuniq : batchlinelist){
                If(placementlist.size()>0 && batchuniq.IP_LinkField3__c!='' ){
                    for(Integer i = 0;i<placementlist.size();i++){
                        If(batchuniq.IP_LinkField3__c==placementlist[i].id){
                            if(batchuniq.IP_Status__c != 'Errored' && batchuniq.IP_LinkField3__c!=null 
                                && timesheetmap.get(batchuniq.IP_LinkField1__c)=='No'){
                                if(batchuniq.IP_DateField2__c==dt && bconId!= batchuniq.IP_LinkField1__c){
                                    sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
                                    newTimeSheet1.sirenum__Worker__c = batchuniq.IP_LinkField1__c;
                                    newTimesheet1.sirenum__Client__c=placementlist[i].sirenum__Site__r.sirenum__Operating_Company__c;
                                    newTimesheet1.sirenum__Team__c=placementlist[i].sirenum__Job_Role__c;
                                    newTimesheet1.sirenum__Site__c=placementlist[i].sirenum__Site__c;
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
             
                  system.debug('timesheet'+newtimesheet);
        // Mapping of timesheet on batchline
        for(IP_BatchLine__c batchtimesheet : batchlinelist){
            If(timesheetmap.get(batchtimesheet.IP_LinkField1__c)=='No'){
                for(sirenum__Timesheet__c t : newtimesheet){
                    If(batchtimesheet.IP_Status__c!='Errored' && batchtimesheet.IP_DateField2__c==t.sirenum__Week_Ending__c 
                            && batchtimesheet.IP_LinkField1__c == t.sirenum__Worker__c ){
                        If(Errmsg.get(t.Id)!='Success'){
                            batchtimesheet.IP_Status__c='Errored';    
                            batchtimesheet.IP_ErrorReason__c=Errmsg.get(t.Id);
                        }
                        else{
                            batchtimesheet.IP_LinkField4__c = t.Id;
                        }
                    }
                }
            }
            else{
                for(sirenum__Timesheet__c stimesheet : tmsheet){
                    If(batchtimesheet.IP_Status__c != 'Errored' && batchtimesheet.IP_DateField2__c==stimesheet.sirenum__Week_Ending__c 
                        && batchtimesheet.IP_LinkField1__c == stimesheet.sirenum__Worker__c ){
                        batchtimesheet.IP_LinkField4__c = stimesheet.Id;
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
        List<sirenum__Placement__c> placement = [select id,sirenum__Site__r.sirenum__Operating_Company__c,sirenum__Job_Role__r.sirenum__Rota__c, 
                                            sirenum__Site__r.sirenum__Operating_Company__r.name,name,sirenum__Contact__c,sirenum__Start_Date__c,
                                            sirenum__End_Date__c,sirenum__Status__c,sirenum__Site__c,sirenum__Job_Role__c 
                                            from sirenum__Placement__c where id in : placeid limit 1];
        List<sirenum__Shift__c> shiftList = new List<sirenum__Shift__c>();
        System.debug('@@ $$ '+sheetnumber);
        If(newtimesheet.size()>0 && placement.size()>0){
            System.debug('@@ '+sheetnumber);
            for(sirenum__Timesheet__c timesheet2 :newtimesheet ){
                // if(sheetnumber!=timesheet2.Name)
                //  {
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
                //    sheetnumber = timesheet2.name;
                system.debug('sheetnumber '+sheetnumber);

                break;
            // }
            }

        }

        try{
            saveList =  Database.insert(shiftList,false);     
        } 
        catch(Exception DMLException){       }

        system.debug('shiftList'+shiftList);

        // checking for error messages which came at the time of Shift creation
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
              
        system.debug('@@ '+batchlinelist);
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
             
         //------------------ Mapping of shift on batchline
  
        for(IP_BatchLine__c batchshift : batchlinelist){
            If(shiftList.size()>0){
                for(sirenum__Shift__c s : shiftList){
                    If(batchshift.IP_Status__c!='Errored' && batchshift.IP_LinkField4__c == s.sirenum__Timesheet_summaries__c){
                        If(Errormsg1.get(s.Id)!='Success'){
                            batchshift.IP_Status__c='Errored';                               
                            batchshift.IP_ErrorReason__c=Errormsg1.get(s.Id);
                        }
                        else{
                            batchshift.IP_LinkField2__c = s.Id;
                        }
                    }
                }
            }
            else{
                if(oldshift.size()>0){
                    for(sirenum__Shift__c s : oldshift){
                        If(batchshift.IP_Status__c != 'Errored' && batchshift.IP_LinkField4__c == s.sirenum__Timesheet_summaries__c){
                            batchshift.IP_LinkField2__c = s.Id;
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
          
             //------------------             
             
             
        Map<Id,String> Errormsg = new Map<Id,String>();
        // creating timesheet line
        list<sirenum__Timesheet_Line__c> timesheetline = new list<sirenum__Timesheet_Line__c >(); 
        for(IP_BatchLine__c batchline5 : batchlinelist){
            If(timesheetmap.get(batchline5.IP_LinkField1__c)=='No'){
                for(Integer i=0;i<newtimesheet.size();i++ ){
                    system.debug('newtimesheet '+newtimesheet[i]);
                    system.debug('Testing '+batchline5.IP_ErrorReason__c+' '+batchline5.IP_Status__c +' '+batchline5.IP_DateField2__c +' '+ newtimesheet[i].sirenum__Week_Ending__c+' '+batchline5.IP_LinkField1__c +' '+newtimesheet[i].sirenum__Worker__c);
                    if(shiftmap.size()>0 && batchline5.IP_Status__c != 'Errored' && batchline5.IP_DateField2__c== newtimesheet[i].sirenum__Week_Ending__c && batchline5.IP_LinkField1__c==newtimesheet[i].sirenum__Worker__c){
                        system.debug('shiftmap.get(newtimesheet[i]) '+shiftmap.get(newtimesheet[i].id));
                        sirenum__Timesheet_Line__c timeSheetLine1 = new sirenum__Timesheet_Line__c();
                        timeSheetLine1.sirenum__Timesheet__c =  newtimesheet[i].id;  
                        timeSheetLine1.sirenum__Rate__c      =  batchline5.IP_CurrencyField1__c;
                        timeSheetLine1.sirenum__Hours__c     =  batchline5.IP_Number12d4Field1__c; 
                        timeSheetLine1.IP_RateCodes__c       =  batchline5.IP_TextField3__c;
                        timeSheetLine1.For_BatchClass__c     =  true;
                        timeSheetLine1.sirenum__Charge__c    =  batchline5.IP_CurrencyField2__c;
                        timeSheetLine1.Batchvalue__c         =  batchline5.Name;
                        timeSheetLine1.sirenum__Date__c      =  batchline5.IP_DateField1__c;
                        timeSheetLine1.IP_PurchaseOrderNumber__c = batchline5.IP_TextField4__c;
                        timesheetLine1.sirenum__Shift__c = shiftmap.get(newtimesheet[i].id).id;
                        timesheetline.add(timeSheetLine1);
                        // batchline5.IP_LinkField4__c = timesheet2.id;

                        break;
                    }
                }
            } 
            else{
                system.debug('tmsheet.size() '+tmsheet.size());
                for(Integer i=0;i<tmsheet.size();i++){
                    system.debug('tmsheet[i].sirenum__Week_Ending__c '+tmsheet[i].sirenum__Week_Ending__c);
                    if(oldshiftmap.size()>0 && batchline5.IP_Status__c != 'Errored' && 
                            batchline5.IP_DateField2__c== tmsheet[i].sirenum__Week_Ending__c && 
                            batchline5.IP_LinkField1__c==tmsheet[i].sirenum__Worker__c){
                        sirenum__Timesheet_Line__c timeSheetLine1 = new sirenum__Timesheet_Line__c();
                        timeSheetLine1.sirenum__Timesheet__c =  tmsheet[i].id;  
                        timeSheetLine1.sirenum__Rate__c      =  batchline5.IP_CurrencyField1__c;
                        timeSheetLine1.sirenum__Hours__c     =  batchline5.IP_Number12d4Field1__c; 
                        timeSheetLine1.IP_RateCodes__c       =  batchline5.IP_TextField3__c;
                        timeSheetLine1.For_BatchClass__c     =  true;
                        timeSheetLine1.sirenum__Charge__c    =  batchline5.IP_CurrencyField2__c;
                        timeSheetLine1.Batchvalue__c         =  batchline5.Name;
                        timeSheetLine1.sirenum__Date__c      =  batchline5.IP_DateField1__c;
                        timeSheetLine1.IP_PurchaseOrderNumber__c = batchline5.IP_TextField4__c;
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
        
              // checking for error messages which came at the time of Timesheetline creation
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
             
                System.debug('Errormsg -- '+Errormsg);   
             // mapping of timesheetline on Batchline field linkfield5
        for(sirenum__Timesheet_Line__c timeline : timesheetline){
            System.debug('timeline.Batchvalue__c -- '+timeline.Batchvalue__c);
            for(IP_BatchLine__c batchline6 : batchlinelist){
                System.debug('batchline6.name -- '+batchline6.Name);
                if( batchline6.IP_Status__c != 'Errored' && timeline.Batchvalue__c==batchline6.Name && 
                    timesheetmap.get(batchline6.IP_LinkField1__c) =='No'){
                    System.debug('IN IF batchline6.name -- '+batchline6.Name);
                    If(Errormsg.get(timeline.Id)!='Success'){
                        batchline6.IP_Status__c='Errored';                                  
                        batchline6.IP_ErrorReason__c=Errormsg.get(timeline.Id);
                    }
                    else{
                        batchline6.IP_LinkField5__c = timeline.id; 
                        batchline6.IP_Status__c = 'Processed';
                    }

                }
                else{
                    for(sirenum__Timesheet__c stimesheet : tmsheet){
                        If( timeline.Batchvalue__c==batchline6.Name && batchline6.IP_Status__c != 'Errored' && 
                            batchline6.IP_DateField2__c==stimesheet.sirenum__Week_Ending__c && 
                            batchline6.IP_LinkField1__c == stimesheet.sirenum__Worker__c ){
                            If(Errormsg.get(timeline.Id)!='Success'){
                                batchline6.IP_Status__c='Errored';
                                batchline6.IP_ErrorReason__c=Errormsg.get(timeline.Id);
                            }
                            else{
                                batchline6.IP_LinkField5__c = timeline.Id;
                                batchline6.IP_Status__c = 'Processed';
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
                //batchHeader.IP_Status__c = 'Complete';
                //batchHeader.IP_State__c = 'Processing';
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
        
         super.finishBatch(BC);
    }
}