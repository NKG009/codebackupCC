global class BeelineBatchHeaderClass extends batchjobsch.BatchJobBase implements Database.Batchable<sObject>,Database.Stateful{
    
    Set<Id> setBatchHeaderId = new Set<Id>();//Batch Header Id
    List<IP_Batchline__c> successlist = new  List<IP_Batchline__c>();
    List<IP_Batchline__c> errorlist  = new List<IP_Batchline__c>();
    Set<Id> errorid = new Set<Id>();
    Set<Id> setUpdatedBatchHeaderId = new Set<Id>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        //  String  query = 'select Id,IP_State__c,IP_Status__c,IP_BatchType__c from Batch_header__c where IP_BatchType__c=\'Capita\' And ((IP_State__c = \'Open\' And IP_Status__c = \'Approved\') OR (IP_State__c = \'Processing\' AND IP_Status__c = \'Errored\') OR (IP_State__c = \'Processing\' AND IP_Status__c = \'Partial Complete\') OR (IP_State__c = \'Processing\' AND IP_Status__c = \'Complete\')) ';
        //List<String> ff = new List<String>();
        //ff.add('a4d4J000000dftP');
        String query ='select id,name,IP_LinkField3__c,IP_DateField1__c,IP_BatchHeader__c,IP_BatchHeader__r.name,IP_BatchHeader__r.IP_BatchTitle__c,IP_ErrorReason__c,IP_LinkField5__c,IP_LinkField1__c,IP_LinkField4__c,IP_Status__c,IP_TextField2__c,IP_TextField3__c,IP_TextField1__c,IP_DateField2__c,IP_CurrencyField1__c,IP_CurrencyField2__c,IP_Number12d4Field1__c,IP_TextField4__c from IP_BatchLine__c where IP_Status__c = \'Open\' AND IP_BatchHeader__r.IP_BatchType__c=\'Beeline\' And ((IP_BatchHeader__r.IP_State__c = \'Closed\' And IP_BatchHeader__r.IP_Status__c = \'Approved\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Errored\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Partial Complete\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Complete\'))';
        system.debug('++++++++query+++++'+query);
        return Database.getQueryLocator(query);
    }
        
    global void execute(Database.BatchableContext BC,List<IP_BatchLine__c> batchLineList){
        
        Map<Id,String> mapBatchLineIdPayRollId = new Map<Id,String>();
        Map<Id,Date> mapBatchLineIdDateField = new Map<Id,Date>();
        Set<Date> setdate= new Set<Date>();
        //Set<Id> setContactId = new Set<Id>();
        system.debug('++++++++batchLineList+++++'+batchLineList);
        for(IP_BatchLine__c bline : batchLineList){
            setBatchHeaderId.add(bline.IP_BatchHeader__c); //put Batch Header Id
            mapBatchLineIdPayRollId.put(bline.Id,bline.IP_TextField2__c); // List of payroll Ids
            mapBatchLineIdDateField.put(bline.Id,bline.IP_DateField1__c);           
        }
        system.debug('++++++++setBatchHeaderId+++++'+setBatchHeaderId);
        // Map to eliminate repeated sirenum__Week_Ending__c which is coming from datefield2 of batchline so that we can create only those timesheet  
        Map<Date,Integer> elCount = new Map<Date,Integer>();

        for(Date key : mapBatchLineIdDateField.values()){
            setdate.add(key);
            if(!elCount.containsKey(key)){
                elCount.put(key,0);  }

            Integer currentInt=elCount.get(key)+1;
            elCount.put(key,currentInt);
        }
               
        System.debug('setdate -- '+setdate);
        System.debug('elCount -- '+elCount);
        system.debug('payprofile name'+mapBatchLineIdPayRollId);
        Map<String,IP_PayProfile__c> mapPayRollIdPayProfile = new Map<String,IP_PayProfile__c>();
                   
        if(!mapBatchLineIdPayRollId.isEmpty()){
            for(IP_PayProfile__c payProfile : [select id,name,IP_Candidate__c,IP_CompanyRegNo__c,IP_VATNumber__c,IP_PayrollID__c 
                                            from IP_PayProfile__c where IP_PayrollID__c IN :mapBatchLineIdPayRollId.values() and IP_PayrollID__c!=null]){
                mapPayRollIdPayProfile.put(payProfile.IP_PayrollID__c,payProfile);
            }
        }
        
        system.debug('pay profile map'+mapPayRollIdPayProfile);
        
        //Find Matching Pay Profile Id
        Map<String,String> mapBatchLineIdContactId = new Map<String,String>();
        
        for(IP_BatchLine__c batchLineContact : batchLineList){
            if(!mapPayRollIdPayProfile.isEmpty()){
                if(mapPayRollIdPayProfile.get(batchLineContact.IP_TextField2__c)==null){
                    batchLineContact.IP_Status__c = Label.BeeLineErrorStatus;
                    batchLineContact.IP_State__c = Label.BeeLineOpenStatus;                     
                    batchLineContact.IP_ErrorReason__c = Label.BeeLineContactNotFound;
                    errorid.add(batchLineContact.id);
                }
                else if(mapPayRollIdPayProfile.get(batchLineContact.IP_TextField2__c).IP_Candidate__c!=null){
                    batchLineContact.IP_LinkField1__c = mapPayRollIdPayProfile.get(batchLineContact.IP_TextField2__c).IP_Candidate__c;//mapContactIdBatchLineId.put(batchLineContact.IP_LinkField1__c+'-'+mapPayRollIdPayProfile.get(batchLineContact.IP_TextField2__c),batchLineContact.Id);                   
                    mapBatchLineIdContactId.put(batchLineContact.Id,batchLineContact.IP_LinkField1__c); 
                    batchLineContact.IP_Status__c = Label.BeeLineLinkingStatus;
                }
            }
            else{
                batchLineContact.IP_Status__c = Label.BeeLineErrorStatus;
                batchLineContact.IP_State__c = Label.BeeLineOpenStatus;                     
                batchLineContact.IP_ErrorReason__c = Label.BeeLineContactNotFound;
                errorid.add(batchLineContact.id);
            }
            system.debug('Line 65 batchLineList'+batchLineList);
        }
        
        //Find Matching S-Placement Id
        Set<String> beeLineAccountName = new Set<String>();
        Map<Id,sirenum__Placement__c> mapPlacementIdPlacementRecord = new Map<Id,sirenum__Placement__c>();
        Map<Id,List<sirenum__Placement__c>> mapCandidateIdPlacementList = new Map<Id,List<sirenum__Placement__c> >();
        List<sirenum__Placement__c> listSPlacementUpdate = new List<sirenum__Placement__c>();
        
        for(BeeLineAccountName__c beeLineAccount : BeeLineAccountName__c.getall().values()){
            beeLineAccountName.add(beeLineAccount.Name);
        }
        system.debug('beeLineAccountName'+beeLineAccountName);
        
        if(!mapBatchLineIdContactId.isEmpty()){
            list<sirenum__Placement__c> placementlist = [Select id,IP_PayrollStatus__c,sirenum__Site__r.sirenum__Operating_Company__c, sirenum__Site__r.sirenum__Operating_Company__r.Name,name,IP_PayMethod__r.IP_PayrollID__c,sirenum__Contact__c,sirenum__Start_Date__c,sirenum__End_Date__c,sirenum__Status__c,sirenum__Site__c,sirenum__Job_Role__c from sirenum__Placement__c where sirenum__Contact__c in : mapBatchLineIdContactId.values() and sirenum__Status__c ='Active' and IP_PayrollStatus__c=null and sirenum__Site__c != null and sirenum__Site__r.sirenum__Operating_Company__r.name IN: beeLineAccountName];
            for(sirenum__Placement__c placement : placementlist){
                mapPlacementIdPlacementRecord.put(placement.Id,placement);
                if(mapCandidateIdPlacementList.containsKey(placement.sirenum__Contact__c)){
                    List<sirenum__Placement__c> listSPlacement = mapCandidateIdPlacementList.get(placement.sirenum__Contact__c);
                    listSPlacement.add(placement);
                    mapCandidateIdPlacementList.put(placement.sirenum__Contact__c,listSPlacement);
                }
                else{
                    List<sirenum__Placement__c> listSPlacement = new List<sirenum__Placement__c>();
                    listSPlacement.add(placement);
                    mapCandidateIdPlacementList.put(placement.sirenum__Contact__c,listSPlacement);
                }
                
            }
            system.debug('mapCandidateIdPlacementList'+mapCandidateIdPlacementList);
            Set<ID> placeid = new Set<ID>();
            //Map<Id,Date> mapPlacementIdDateField = new Map<Id,Date>();
            for(IP_BatchLine__c batchLineSplacement : batchlinelist){
                if(batchLineSplacement.IP_LinkField1__c!=null){
                    if(!mapCandidateIdPlacementList.isEmpty() && mapCandidateIdPlacementList.get(batchLineSplacement.IP_LinkField1__c)!=null){
                        Integer counter = 0;
                        for(sirenum__Placement__c placement : mapCandidateIdPlacementList.get(batchLineSplacement.IP_LinkField1__c)){
                            if(batchLineSplacement.IP_DateField1__c >= placement.sirenum__Start_Date__c && batchLineSplacement.IP_DateField1__c <= placement.sirenum__End_Date__c){ 
                                if(counter == 0){
                                    batchLineSplacement.IP_LinkField3__c = placement.id;
                                    batchLineSplacement.IP_Status__c = Label.BeeLineLinkedStatus;
                                    counter++;
                                    placeid.add(placement.id);                                      
                                }
                                else{                                       
                                    batchLineSplacement.IP_Status__c = Label.BeeLineErrorStatus;                                      
                                    batchLineSplacement.IP_ErrorReason__c = Label.BeeLineSPlacementActiveError;
                                    batchLineSplacement.IP_LinkField3__c='';
                                    errorid.add(batchLineSplacement.id);
                                }
                            }
                        }
                        
                        if(batchLineSplacement.IP_Status__c != Label.BeeLineErrorStatus && batchLineSplacement.IP_LinkField3__c==null){ 
                            batchLineSplacement.IP_Status__c = Label.BeeLineErrorStatus;                                       
                            batchLineSplacement.IP_ErrorReason__c = Label.BeeLineSPlacementInactive;
                            batchLineSplacement.IP_LinkField3__c='';
                            errorid.add(batchLineSplacement.id);
                        }
                        /*else if(batchLineSplacement.IP_Status__c != Label.BeeLineErrorStatus && batchLineSplacement.IP_LinkField3__c!=null){
                            mapPlacementIdDateField.put(batchLineSplacement.IP_LinkField3__c,batchLineSplacement.IP_DateField1__c);
                        }*/
                        //system.debug('+++++mapPlacementIdDateField++++'+mapPlacementIdDateField);
                    }
                    else{
                        batchLineSplacement.IP_Status__c = Label.BeeLineErrorStatus;
                        batchLineSplacement.IP_State__c = Label.BeeLineOpenStatus;                  
                        batchLineSplacement.IP_ErrorReason__c = Label.BeeLineSPlacementInactive;
                        batchLineSplacement.IP_LinkField3__c='';
                        errorid.add(batchLineSplacement.id);
                    }
                }
                else{
                    batchLineSplacement.IP_Status__c = Label.BeeLineErrorStatus;
                    batchLineSplacement.IP_State__c = Label.BeeLineOpenStatus;                  
                    batchLineSplacement.IP_ErrorReason__c = Label.BeeLineContactNotFound;
                    errorid.add(batchLineSplacement.id);
                }
            }
            system.debug('Line 137'+batchLineList);
            Map<Id,String> Errmsg = new Map<Id,String>();
            Database.SaveResult[] sList;
            
            //Commented after Bash Comment
            /*if(!mapPlacementIdDateField.isEmpty()){
                for(sirenum__Placement__c placement : [Select id, sirenum__End_Date__c from 
                                                        sirenum__Placement__c where id IN : mapPlacementIdDateField.keyset()]){
                    if(mapPlacementIdDateField.get(placement.id)!=null && mapPlacementIdDateField.get(placement.id)>placement.sirenum__End_Date__c){                                        
                        placement.sirenum__End_Date__c  = mapPlacementIdDateField.get(placement.id);
                        listSPlacementUpdate.add(placement);
                    }
                }
            }            
            
            if(!listSPlacementUpdate.isEmpty()){
                try{ 
                    sList =  Database.update(listSPlacementUpdate,false);
                }
                catch(Exception DMLException){  }
                  
                for (Database.SaveResult sr : sList) {
                    if (sr.isSuccess()) {
                        System.debug('Successfully updated SPlacement: ' + sr.getId());
                        Errmsg.put(sr.getId(),'Success');
                    }
                    else {
                        for(Database.Error err : sr.getErrors()) {  Errmsg.put(sr.getId(),err.getMessage());
                        }
                    }
                }                   
            }*/
            
            System.debug('contactid ' +mapBatchLineIdContactId.values());
            Map<Id,String> timesheetmap = new Map<Id,String>();
            
            List<sirenum__Timesheet__c> tmsheet = [select id,name,sirenum__Worker__c,sirenum__Week_Ending__c,
                            sirenum__Site__r.sirenum__Operating_Company__r.name from sirenum__Timesheet__c 
                            where sirenum__Worker__c in : mapBatchLineIdContactId.values() 
                            and sirenum__Week_Ending__c in :setdate and Id NOT in (Select sirenum__Timesheet__c from sirenum__Timesheet_Line__c where IP_Locktimesheet__c = True) and 
                            sirenum__Site__r.sirenum__Operating_Company__r.name IN:beeLineAccountName];
            

            for(IP_BatchLine__c checkbatch : batchlinelist){
                if(tmsheet.size()>0){
                    for(sirenum__Timesheet__c timesheet1 :tmsheet ){
                        if(timesheet1.sirenum__Worker__c==checkbatch.IP_LinkField1__c  && timesheet1.sirenum__Week_Ending__c == checkbatch.IP_DateField1__c){
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
            
            list<sirenum__Timesheet__c> newtimesheet = new list<sirenum__Timesheet__c>();
            system.debug('timesheetmap'+timesheetmap);
             // Creation of timesheet
            for(Date dt :setdate){
                Boolean check=false;

                String bconId ='';
                for(IP_BatchLine__c batchuniq : batchlinelist){
                    if(placementlist.size()>0 && batchuniq.IP_LinkField3__c!='' ){
                        for(Integer i = 0;i<placementlist.size();i++){
                            if(batchuniq.IP_LinkField3__c==placementlist[i].id){
                                if(batchuniq.IP_Status__c != Label.BeeLineErrorStatus && batchuniq.IP_LinkField3__c!=null && timesheetmap.get(batchuniq.IP_LinkField1__c)=='No'){
                                    if(batchuniq.IP_DateField1__c==dt && bconId!= batchuniq.IP_LinkField1__c){
                                        sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
                                        newTimeSheet1.sirenum__Worker__c = batchuniq.IP_LinkField1__c;
                                        newTimesheet1.sirenum__Client__c=placementlist[i].sirenum__Site__r.sirenum__Operating_Company__c;
                                        newTimesheet1.sirenum__Team__c=placementlist[i].sirenum__Job_Role__c;
                                        newTimesheet1.sirenum__Site__c=placementlist[i].sirenum__Site__c;
                                        newTimesheet1.sirenum__Week_Ending__c =batchuniq.IP_DateField1__c;
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
                    Errmsg.put(sr.getId(),Label.BeeLineSuccessStatus);
                }
                else {
                    for(Database.Error err : sr.getErrors()) {  Errmsg.put(sr.getId(),err.getMessage());
                    }
                }
            }
                 
            system.debug('timesheet'+newtimesheet);
            // Mapping of timesheet on batchline
            for(IP_BatchLine__c batchtimesheet : batchlinelist){
                if(timesheetmap.get(batchtimesheet.IP_LinkField1__c)=='No'){
                    for(sirenum__Timesheet__c t : newtimesheet){
                        if(batchtimesheet.IP_Status__c!= Label.BeeLineErrorStatus && batchtimesheet.IP_DateField1__c==t.sirenum__Week_Ending__c && batchtimesheet.IP_LinkField1__c == t.sirenum__Worker__c ){
                            if(Errmsg.get(t.Id)!=Label.BeeLineSuccessStatus){
                                batchtimesheet.IP_Status__c= Label.BeeLineErrorStatus;    
                                batchtimesheet.IP_ErrorReason__c=Errmsg.get(t.Id);
                                errorid.add(batchtimesheet.id);
                            }
                            else{
                                batchtimesheet.IP_LinkField4__c = t.Id;
                            }
                        }
                    }
                }
                else{
                    for(sirenum__Timesheet__c stimesheet : tmsheet){
                        if(batchtimesheet.IP_Status__c != Label.BeeLineErrorStatus && batchtimesheet.IP_DateField1__c==stimesheet.sirenum__Week_Ending__c && batchtimesheet.IP_LinkField1__c == stimesheet.sirenum__Worker__c ){
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
            List<sirenum__Shift__c> shiftList = new List<sirenum__Shift__c>();
            
            List<sirenum__Placement__c> placement = [select id,sirenum__Site__r.sirenum__Operating_Company__c,sirenum__Job_Role__r.sirenum__Rota__c, sirenum__Site__r.sirenum__Operating_Company__r.name,name,sirenum__Contact__c,sirenum__Start_Date__c,sirenum__End_Date__c,sirenum__Status__c,sirenum__Site__c,sirenum__Job_Role__c from sirenum__Placement__c where id in : placeid limit 1];
            
            System.debug('@@ $$ '+sheetnumber);
            if(newtimesheet.size()>0 && placement.size()>0){
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
                    Errormsg1.put(sr.getId(),Label.BeeLineSuccessStatus);
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
            if(shiftmap.isEmpty()){
                for(sirenum__Shift__c sf : [select id,sirenum__Timesheet_summaries__r.id from sirenum__Shift__c where sirenum__Timesheet_summaries__c in: tmsheet and sirenum__Placement__c =:placeid]){ 
                    oldshiftmap.put(sf.sirenum__Timesheet_summaries__r.id, sf);
                    oldshift.add(sf);                          
                }
            }
                 
             //------------------ Mapping of shift on batchline
      
            for(IP_BatchLine__c batchshift : batchlinelist){
                if(shiftList.size()>0){
                    for(sirenum__Shift__c s : shiftList){
                        if(batchshift.IP_Status__c!=Label.BeeLineErrorStatus && batchshift.IP_LinkField4__c == s.sirenum__Timesheet_summaries__c){
                            if(Errormsg1.get(s.Id)!=Label.BeeLineSuccessStatus){
                                batchshift.IP_Status__c=Label.BeeLineErrorStatus;                               
                                batchshift.IP_ErrorReason__c=Errormsg1.get(s.Id);
                                errorid.add(batchshift.id);
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
                            if(batchshift.IP_Status__c != Label.BeeLineErrorStatus && batchshift.IP_LinkField4__c == s.sirenum__Timesheet_summaries__c){
                                batchshift.IP_LinkField2__c = s.Id;
                            }
                        }
                    }
                    else{
                        if(batchshift.IP_Status__c != Label.BeeLineErrorStatus){                      
                            batchshift.IP_Status__c = Label.BeeLineErrorStatus;
                            batchshift.IP_ErrorReason__c = Label.BeeLineShiftNotFound;
                            //  errorlist.add(batchshift);
                            errorid.add(batchshift.id);
                        }
                    }
                }
            }
              
                 //------------------             
                 
            // Get BeeLinePay rate Codes
            Map<String,BeeLinePayRateCodes__c> mapRateCodeNameRateCodes = new Map<String,BeeLinePayRateCodes__c>();
            for(BeeLinePayRateCodes__c beeLinePayRateCodes : BeeLinePayRateCodes__c.getall().values()){
                mapRateCodeNameRateCodes.put(beeLinePayRateCodes.Name,beeLinePayRateCodes);
            }
            system.debug('mapRateCodeNameRateCodes1111 '+mapRateCodeNameRateCodes);
            Map<Id,String> Errormsg = new Map<Id,String>();
            // creating timesheet line
            list<sirenum__Timesheet_Line__c> timesheetline = new list<sirenum__Timesheet_Line__c >(); 
            for(IP_BatchLine__c batchline5 : batchlinelist){
                if(timesheetmap.get(batchline5.IP_LinkField1__c)=='No'){
                    for(Integer i=0;i<newtimesheet.size();i++ ){
                        system.debug('newtimesheet '+newtimesheet[i]);
                        system.debug('mapRateCodeNameRateCodes '+mapRateCodeNameRateCodes);
                        system.debug('mapRateCodeNameRateCodes.get(batchline5.IP_TextField3__c) '+mapRateCodeNameRateCodes.get(batchline5.IP_TextField3__c));
                        system.debug('Testing '+batchline5.IP_ErrorReason__c+' '+batchline5.IP_Status__c +' '+batchline5.IP_DateField1__c +' '+ newtimesheet[i].sirenum__Week_Ending__c+' '+batchline5.IP_LinkField1__c +' '+newtimesheet[i].sirenum__Worker__c);
                        if(shiftmap.size()>0 && batchline5.IP_Status__c != Label.BeeLineErrorStatus && batchline5.IP_DateField1__c== newtimesheet[i].sirenum__Week_Ending__c && batchline5.IP_LinkField1__c==newtimesheet[i].sirenum__Worker__c){
                            if(!mapRateCodeNameRateCodes.isEmpty() && mapRateCodeNameRateCodes.get(batchline5.IP_TextField3__c)!=null){
                                system.debug('shiftmap.get(newtimesheet[i]) '+shiftmap.get(newtimesheet[i].id));
                                sirenum__Timesheet_Line__c timeSheetLine1 = new sirenum__Timesheet_Line__c();
                                timeSheetLine1.sirenum__Timesheet__c =  newtimesheet[i].id;  
                                timeSheetLine1.sirenum__Rate__c      =  batchline5.IP_CurrencyField1__c;
                                timeSheetLine1.sirenum__Hours__c     =  batchline5.IP_Number12d4Field1__c;
                                timeSheetLine1.IP_RateCodes__c   =  mapRateCodeNameRateCodes.get(batchline5.IP_TextField3__c).Job_Science_Pay_Rate_Code__c;
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
                            else{
                                batchline5.IP_Status__c=Label.BeeLineErrorStatus;                                  
                                batchline5.IP_ErrorReason__c=Label.BeeLinePayRateCodeNotFound;
                                errorid.add(batchline5.id);
                            }
                        }
                    }
                } 
                else{
                    system.debug('tmsheet.size() '+tmsheet.size());
                    for(Integer i=0;i<tmsheet.size();i++){
                        system.debug('tmsheet[i].sirenum__Week_Ending__c '+tmsheet[i].sirenum__Week_Ending__c);
                        if(oldshiftmap.size()>0 && batchline5.IP_Status__c != 'Errored' && batchline5.IP_DateField1__c== tmsheet[i].sirenum__Week_Ending__c && batchline5.IP_LinkField1__c==tmsheet[i].sirenum__Worker__c){
                            if(!mapRateCodeNameRateCodes.isEmpty() && mapRateCodeNameRateCodes.get(batchline5.IP_TextField3__c)!=null){
                                sirenum__Timesheet_Line__c timeSheetLine1 = new sirenum__Timesheet_Line__c();
                                timeSheetLine1.sirenum__Timesheet__c =  tmsheet[i].id;  
                                timeSheetLine1.sirenum__Rate__c      =  batchline5.IP_CurrencyField1__c;
                                timeSheetLine1.sirenum__Hours__c     =  batchline5.IP_Number12d4Field1__c; 
                                timeSheetLine1.IP_RateCodes__c   =  mapRateCodeNameRateCodes.get(batchline5.IP_TextField3__c).Job_Science_Pay_Rate_Code__c;
                                timeSheetLine1.For_BatchClass__c     =  true;
                                timeSheetLine1.sirenum__Charge__c    =  batchline5.IP_CurrencyField2__c;
                                timeSheetLine1.Batchvalue__c         =  batchline5.Name;
                                timeSheetLine1.sirenum__Date__c      =  batchline5.IP_DateField1__c;
                                timeSheetLine1.IP_PurchaseOrderNumber__c = batchline5.IP_TextField4__c;
                                timesheetLine1.sirenum__Shift__c = oldshiftmap.get(tmsheet[i].id).id;
                                timesheetline.add(timeSheetLine1);
                                break;
                            }
                            else{
                                batchline5.IP_Status__c=Label.BeeLineErrorStatus;                                  
                                batchline5.IP_ErrorReason__c=Label.BeeLinePayRateCodeNotFound;
                                errorid.add(batchline5.id);
                            }
                        }
                    }

                }

            }
                      
            try{
                srList =  Database.insert(timesheetline,false);     
            } catch(Exception DMLException){       }
             
            system.debug('timesheetline'+timesheetline);
        
            // checking for error messages which came at the time of Timesheetline creation
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    System.debug('Successfully inserted Timesheetline. Timesheetline ID: ' + sr.getId());
                    Errormsg.put(sr.getId(),Label.BeeLineSuccessStatus);
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
                    if(batchline6.IP_Status__c != Label.BeeLineErrorStatus && timeline.Batchvalue__c==batchline6.Name && timesheetmap.get(batchline6.IP_LinkField1__c) =='No'){
                        System.debug('IN IF batchline6.name -- '+batchline6.Name);
                        if(Errormsg.get(timeline.Id)!=Label.BeeLineSuccessStatus){
                            batchline6.IP_Status__c=Label.BeeLineErrorStatus;                                  
                            batchline6.IP_ErrorReason__c=Errormsg.get(timeline.Id);
                            errorid.add(batchline6.id);
                        }
                        else{
                            batchline6.IP_LinkField5__c = timeline.id; 
                            batchline6.IP_Status__c = Label.BeeLineProcessedStatus;
                            successlist.add(batchline6);
                        }

                    }
                    else{
                        for(sirenum__Timesheet__c stimesheet : tmsheet){
                            if( timeline.Batchvalue__c==batchline6.Name && batchline6.IP_Status__c != 'Errored' && batchline6.IP_DateField1__c==stimesheet.sirenum__Week_Ending__c && batchline6.IP_LinkField1__c == stimesheet.sirenum__Worker__c ){
                                if(Errormsg.get(timeline.Id)!=Label.BeeLineSuccessStatus){
                                    batchline6.IP_Status__c=Label.BeeLineErrorStatus;
                                    batchline6.IP_ErrorReason__c=Errormsg.get(timeline.Id);
                                    errorid.add(batchline6.id);
                                }
                                else{
                                    batchline6.IP_LinkField5__c = timeline.Id;
                                    batchline6.IP_Status__c = Label.BeeLineProcessedStatus;
                                    successlist.add(batchline6);
                                }
                            }
                        }

                    }
                }
            }
            
        }
        
        update batchLineList;
        
        List<Batch_header__c> batchheaderlist = new List<Batch_header__c>();
        
        for(Batch_header__c batchHeader : [Select id,IP_State__c,IP_Status__c,Check_Status__c from  Batch_header__c where id in: setBatchHeaderId and ID NOT IN : setUpdatedBatchHeaderId]){
            setUpdatedBatchHeaderId.add(batchHeader.id);
            batchHeader.Check_Status__c = 'true';               
            batchheaderlist.add(batchHeader);
        }

        if(!batchheaderlist.isEmpty()){
            update batchheaderlist;
        }
    }
    
    global void finish(Database.BatchableContext BC){
    
        Map<Id,Integer> mapUnprocessedBatchHeader = new Map<Id,Integer>();
        Map<Id,Integer> mapErroredBatchHeader = new Map<Id,Integer>();      
        
        List<IP_Batchline__c> errorlistfinal = [Select id,IP_Status__c,IP_BatchHeader__c,IP_BatchHeader__r.IP_BatchTitle__c,IP_BatchHeader__r.name,Name,IP_ErrorReason__c from IP_Batchline__c where id in:errorid];
        System.debug('errorlistfinal -- '+errorlistfinal);
        
        List<IP_Batchline__c> unprocesssed= [Select id,IP_Status__c from IP_Batchline__c where IP_batchheader__c =:setBatchHeaderId and IP_Status__c = 'Open'];
        System.debug('unprocesssed -- '+unprocesssed);
        
        for(Batch_header__c openStatusBatchHeader : [Select id,IP_Status__c,IP_State__c,Check_status__c,(Select id,IP_Status__c from Batch_Lines__r where IP_Status__c = 'Open') from Batch_header__c  where id=:setBatchHeaderId]){
            if(!openStatusBatchHeader.Batch_Lines__r.isEmpty() && openStatusBatchHeader.Batch_Lines__r.size()>0){
                mapUnprocessedBatchHeader.put(openStatusBatchHeader.id,openStatusBatchHeader.Batch_Lines__r.size());
            }           
        }
        System.debug('mapUnprocessedBatchHeader -- '+mapUnprocessedBatchHeader);
        
        for(Batch_header__c  erroredBatchHeader : [Select id,IP_Status__c,IP_State__c,Check_status__c,(Select id,IP_Status__c from Batch_Lines__r where IP_Status__c = 'Errored' Limit 1) from Batch_header__c  where id=:setBatchHeaderId]){
            if(!erroredBatchHeader.Batch_Lines__r.isEmpty() && erroredBatchHeader.Batch_Lines__r.size()>0){
                mapErroredBatchHeader.put(erroredBatchHeader.id,erroredBatchHeader.Batch_Lines__r.size());
            }           
        }
        System.debug('mapErroredBatchHeader -- '+mapErroredBatchHeader);
        
        List<Batch_header__c> listBatchHeaderUpdate = new List<Batch_header__c>();
        
        for(Batch_header__c  batchHeader : [Select id,IP_BatchTitle__c,Name,IP_Status__c,IP_State__c,Check_status__c 
                                                from Batch_header__c  where id=:setBatchHeaderId]){
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
        System.debug('updated listBatchHeaderUpdate -- '+listBatchHeaderUpdate);
        
        //Adding Sucess and Error Batch Header Name and Title
        Map<Id,Batch_header__c> mapSuccessBatchHeaders = new Map<Id,Batch_header__c>();
        Map<Id,Batch_header__c> mapErroredBatchHeaders = new Map<Id,Batch_header__c>();
        for(Batch_header__c  batchHeader : listBatchHeaderUpdate){
            if(batchHeader.IP_Status__c == 'Processed' && batchHeader.IP_State__c == 'Closed'){
                mapSuccessBatchHeaders.put(batchHeader.id,batchHeader);
            }
            if(batchHeader.IP_Status__c == 'Errored' && batchHeader.IP_State__c == 'Processing'){
                mapErroredBatchHeaders.put(batchHeader.id,batchHeader);
            }
        }        
        
        //Adding Email addressess
        String[] setEmailAddresses = new String[]{};        
        for(BeeLineEmailAddresses__c emailAddress : BeeLineEmailAddresses__c.getall().values()){            
            setEmailAddresses.add(emailAddress.Name);
        }
        System.debug('setEmailAddresses -- '+setEmailAddresses);
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();  
        
        if(!mapErroredBatchHeaders.isEmpty() && mapErroredBatchHeaders!=null){
            String htmlbody = 'Hello,<br/><br/>';
            String batchHeaderValue ='';
            
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
            
            email.setSubject(Label.BeeLineEmailErrorSubject);
            email.emailPriority = 'Highest';
            htmlBody+= 'Lloyds Beeline timesheets ';
            if(!mapErroredBatchHeaders.isEmpty()){
                for(Id batchHeaderId : mapErroredBatchHeaders.keySet()){
                    batchHeaderValue+= '' + mapErroredBatchHeaders.get(batchHeaderId).Name + '';
                    if(mapErroredBatchHeaders.get(batchHeaderId).IP_BatchTitle__c!=null){
                        batchHeaderValue+= ' ' + mapErroredBatchHeaders.get(batchHeaderId).IP_BatchTitle__c + '';
                    }
                    batchHeaderValue+=', ';
                }
            }
            htmlBody+= batchHeaderValue.removeEnd(', ');
            htmlBody+= ' have failed to load in Jobscience. ';
            htmlBody+= '<a href="'+Label.BABatchProcessingURL+'">Click here</a> ';
            htmlBody+= 'to view errored timesheet lines. Once all errors have been corrected in Jobscience and/or Beeline, please reprocess the errored timesheet lines.<br/><br/>';
            email.setHtmlBody(htmlBody);
            email.setToAddresses(setEmailAddresses);
            mails.add(email);
            //Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
        if(!mapSuccessBatchHeaders.isEmpty() && mapSuccessBatchHeaders!=null){
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            String htmlbody = 'Hello,<br/><br/>';
            String batchHeaderValue ='';
            
            email.setSubject(Label.BeeLineEmailSuccessSubject);
            htmlBody+= 'Lloyds Beeline timesheets ';
            if(!mapSuccessBatchHeaders.isEmpty()){
                for(Id batchHeaderId : mapSuccessBatchHeaders.keySet()){
                    batchHeaderValue+= '' + mapSuccessBatchHeaders.get(batchHeaderId).Name + '';
                    if(mapSuccessBatchHeaders.get(batchHeaderId).IP_BatchTitle__c!=null){
                        batchHeaderValue+= ' ' + mapSuccessBatchHeaders.get(batchHeaderId).IP_BatchTitle__c + ', ';
                    }
                }
            }
            htmlBody+= batchHeaderValue.removeEnd(', ');
            htmlBody+= ' have been successfully loaded in Jobscience. They will be sent to Tempest in the next payroll run.<br/><br/>';
            email.setHtmlBody(htmlBody);
            email.setToAddresses(setEmailAddresses);
            mails.add(email);
            //Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
        System.debug('mails -- '+mails);
        Messaging.sendEmail(mails,true);
         super.finishBatch(BC);
    }
}