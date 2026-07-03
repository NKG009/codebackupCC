global class ShopDirectlittlehultonclass implements Database.Batchable<sObject>,Database.Stateful{

global Boolean checkstatus = false;
Set<ID> headerId = new Set<ID>();
 List<IP_Batchline__c> successlist = new  List<IP_Batchline__c>();
  List<IP_Batchline__c> errorlist  = new List<IP_Batchline__c>();
    Set<id> errorid = new Set<id>();
global Database.QueryLocator start(Database.BatchableContext BC){
           
           String query ='select id,name,IP_LinkField3__c,IP_LinkField2__c,IP_TextField10__c,IP_TextField9__c,IP_BatchHeader__r.name,IP_LinkField5__c,IP_LinkField6__c,IP_LinkField7__c,IP_LinkField1__c,IP_LinkField4__c,IP_Status__c,IP_TextField2__c,IP_TextField1__c,IP_DateField1__c,IP_CurrencyField1__c,IP_CurrencyField2__c,IP_Number12d4Field1__c,IP_TextField4__c,IP_TextField5__c,IP_TextField7__c from IP_BatchLine__c where IP_Status__c = \'Open\' AND IP_BatchHeader__r.IP_BatchType__c=\'Shop Direct - Little Hulton\' And ((IP_BatchHeader__r.IP_Status__c = \'Approved\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Errored\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Partial Complete\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Processed\'))';
             return Database.getQueryLocator(query);          
        }
        global void execute(Database.BatchableContext BC,List<IP_BatchLine__c> batchlinelist){

        Set<String> jobrole = new Set<String>();
        Set<String> siteid = new Set<String>();
        Map<id,String> Contactname = new Map<id,String>();
        String jobcategory;
         List<sirenum__Placement__c> placeupdate = new List<sirenum__Placement__c>();
                 for(IP_BatchLine__c bline : batchlinelist){                    
                        headerId.add(bline.IP_BatchHeader__c);  
                        jobrole.add(bline.IP_TextField4__c);
                     //   siteid.add(bline.Batch_TYpe__c);
                    //    jobcategory = bline.Job_Category__c;
                 }
         
            list<string> PayrollID = new list<string>();
                //  list<string> contactThirdPartyID = new list<string>();
                    List<Date> datefield = new List<Date>();
                     Set<Date> setdate= new Set<Date>();
                          set<id> contactid = new set<id>();
                     system.debug('Batch line list'+batchlinelist);
                  
                  for(IP_BatchLine__c batchline1 : batchlinelist){                              
                              PayrollID.add(batchline1.IP_TextField2__c);
                            //  contactThirdPartyID.add(batchline1.IP_TextField3__c);
                              datefield.add(batchline1.IP_DateField1__c);
                      
                  }
  // Map to eliminate repeated sirenum__Week_Ending__c which is coming from datefield2 of batchline so that we can create only those timesheet  
        Map<Date,Integer> elCount = new Map<Date,Integer>();

        for(date key : datefield)
        {
              setdate.add(key);
               if(!elCount.containsKey(key)){
               elCount.put(key,0);  }
            
              Integer currentInt=elCount.get(key)+1;
                 elCount.put(key,currentInt);
        }
               
             System.debug('setdate -- '+setdate);
             System.debug('elCount -- '+elCount);
                  system.debug('payprofile name'+PayrollID);
                //  system.debug('contactpartyid'+contactThirdPartyID);
               list<contact> conlist = [select id ,IP_CandidateIDlegacy__c,Name from contact where IP_CandidateIDlegacy__c in :PayrollID and RecordType.developerName = 'IP_2ndTierCandidate'];
               //   system.debug('contactlist'+conlist);
                  Map<string,IP_PayProfile__c> payprofilemap = new Map<string,IP_PayProfile__c>();
                   
                  
                  for(IP_PayProfile__c pay : [select id,name,IP_Candidate__c,IP_MissingPayrollDetail__c,IP_Candidate__r.Name,IP_CompanyRegNo__c,IP_VATNumber__c,IP_PayrollID__c from IP_PayProfile__c where IP_PayrollID__c IN :PayrollID and IP_PayrollID__c!=null]){
                  
                      payprofilemap.put(pay.IP_PayrollID__c,pay);
                      Contactname.put(pay.id,pay.IP_Candidate__r.Name);
                  
                  }
                  system.debug('pay profile map'+payprofilemap);
             
                   // finding contact id from pay profile  
              for(IP_BatchLine__c batchline2 : batchlinelist){
                                 if(payprofilemap.size()>0 && batchline2.IP_TextField2__c!=null && payprofilemap.containskey(batchline2.IP_TextField2__c)){
                                         if(payprofilemap.get(batchline2.IP_TextField2__c).IP_MissingPayrollDetail__c == '' || payprofilemap.get(batchline2.IP_TextField2__c).IP_MissingPayrollDetail__c == null)
                                     {
                                          batchline2.IP_LinkField1__c = payprofilemap.get(batchline2.IP_TextField2__c).IP_Candidate__c; 
                                          contactid.add(payprofilemap.get(batchline2.IP_TextField2__c).IP_Candidate__c);
                                          batchline2.IP_Status__c ='Linking'; 
                                     }
                                     else
                                     {
                                            batchline2.IP_Status__c = 'Errored';   
                                            batchline2.IP_ErrorReason__c = 'Only pay profile compliant candidates can be assigned to shifts';
                                            errorid.add(batchline2.id);
                                     }
                                 
                        }
                  // Search for contact thirdpartyid
                      else IF(conlist.size()>0){
                      for(contact con :conlist){                        
                                       if(batchline2.IP_TextField2__c == con.IP_CandidateIDlegacy__c){
                                       
                                             batchline2.IP_LinkField1__c = con.id;
                                             Contactname.put(con.id,con.Name);
                                             contactid.add(con.id); 
                                             batchline2.IP_Status__c ='Linking'; 
                                       }
                                }
                          }
                               else{
                                              batchline2.IP_Status__c = 'Errored';   
                                              batchline2.IP_ErrorReason__c = 'contact Not found';
                                            //  errorlist.add(batchline2);
                                              errorid.add(batchline2.id);
                   
                                       }
                }
            //update batchlinelist;
              String searchjob = '%'+jobcategory;
           System.debug('Check job catgory'+searchjob);
            List<sirenum__Team__c> joblist = [Select id,name,sirenum__Account__c from sirenum__Team__c where Name =:jobrole and sirenum__AWR_Group__c LIKE '%IA223' LIMIT 1];
            LIst<sirenum__site__c> sitelist = [Select id,name from sirenum__site__c where Name ='Shop Direct - Little Hulton' LIMIT 1];
            for(IP_BatchLine__c bline1 : batchlinelist)
            {
             if(bline1.IP_Status__c != 'Errored')
               {
                if(joblist.size()>0)
                {
                bline1.IP_LinkField3__c  = joblist[0].id;
                }
                else
                {
                    bline1.IP_Status__c = 'Errored';
                    bline1.IP_ErrorReason__c  = 'Job Role not found';
                  //  errorlist.add(bline1);
                     errorid.add(bline1.id);
                }
                if(sitelist.size()>0)
                {
                bline1.IP_LinkField2__c= sitelist[0].id;
                }
                else
                {
                    bline1.IP_Status__c  = 'Errored';
                    bline1.IP_ErrorReason__c  = 'Site not found';
                    //errorlist.add(bline1);
                    errorid.add(bline1.id);
                }
                System.debug('Check 123'+bline1.IP_Status__c);
                }
            }
            
                 list<sirenum__Timesheet__c> newtimesheet = new list<sirenum__Timesheet__c>();
                 list<sirenum__Placement__c> placementlist = new list<sirenum__Placement__c>();
                   Set<ID> placeid = new Set<ID>();
                 if(joblist.size()>0 && sitelist.size()>0)
                 {
                   placementlist = [select id,IP_PayrollStatus__c,sirenum__Site__r.sirenum__Operating_Company__c, sirenum__Site__r.sirenum__Operating_Company__r.name,name,sirenum__Contact__c,sirenum__Start_Date__c,sirenum__End_Date__c,sirenum__Status__c,sirenum__Site__c,sirenum__Job_Role__c from sirenum__Placement__c where sirenum__Contact__c in : contactid  and sirenum__Job_Role__c =:joblist[0].id and sirenum__Site__c=:sitelist[0].id and sirenum__Status__c ='Active'];
                 }
                   system.debug('placement list '+placementlist );
               
                           for(IP_BatchLine__c batchline4 : batchlinelist){
                               System.debug('$$Batch line status before IF'+batchline4.IP_Status__c);
                               if(batchline4.IP_Status__c != 'Errored')
                               {
                                   System.debug('$$Inside Errored IF$$');
                                If(batchline4.IP_LinkField1__c!=null){
                               If(placementlist.size()>0 ){
                           system.debug('Test '+placementlist );
                               integer counter = 0;
                                  
                              
                               for(Integer i = 0;i<placementlist.size();i++){
                                   if(batchline4.IP_LinkField1__c == placementlist[i].sirenum__Contact__c){
                                       if(placementlist[i].IP_PayrollStatus__c!=null){
                                               batchline4.IP_Status__c = 'Errored';                                   
                                               batchline4.IP_ErrorReason__c = 'No active s-placement for this candidate because '+placementlist[i].IP_PayrollStatus__c+' is missing in s-placement';
                                           }
                                           else{
                                           if(counter == 0){
                                             if(placementlist[i].sirenum__End_Date__c<batchline4.IP_DateField1__c)
                                           {
                                            placementlist[i].sirenum__End_Date__c = batchline4.IP_DateField1__c;
                                           }
                                           batchline4.IP_LinkField5__c = placementlist[i].id;
                                           batchline4.IP_Status__c = 'linked';
                                           placeid.add(placementlist[i].id);
                                           counter++;
                                               
                                           }
                                           else{
                                               batchline4.IP_Status__c = 'Errored';                                   batchline4.IP_ErrorReason__c = 'There is more than one active placement for this candidate for this payroll week';
                                              // errorlist.add(batchline4);
                                               errorid.add(batchline4.id);
                                           }
                                        }
                                   }
                                update placementlist;
                                        
                               }                                  
                        
                               }
                              else{      
                                    System.debug('Inside Placement Creation');
                                    IP_PayProfile__c pay;
                                    Date checkdate = batchline4.IP_DateField1__c;
                                    Date Startdate = checkdate.addDays(-7);
                                    Contact con = [Select id,RecordType.developername from Contact where id =:batchline4.IP_LinkField1__c];
                                    if(con.RecordType.developername!='IP_2ndTierCandidate')
                                    {
                                    pay = [Select id from IP_PayProfile__c where IP_PayrollID__c =:batchline4.IP_TextField2__c];
                                    }   
                                    sirenum__Placement__c ps = new sirenum__Placement__c();
                                    ps.sirenum__Contact__c = batchline4.IP_LinkField1__c;
                                    ps.sirenum__site__c = batchline4.IP_LinkField2__c;
                                    ps.sirenum__Start_Date__c = Startdate;
                                    ps.sirenum__Status__c = 'Active';
                                    ps.sirenum__End_Date__c = batchline4.IP_DateField1__c;
                                    ps.sirenum__Job_Role__c = batchline4.IP_LinkField3__c;
                                    if(pay!=null)
                                    {
                                    ps.IP_PayMethod__c =  pay.id;
                                    ps.Name = joblist[0].name+'-'+Contactname.get(pay.id);
                                    }
                                    else
                                    {
                                    ps.Name = joblist[0].name+'-'+Contactname.get(con.id);  
                                    }
                                    ps.sirenum__Contract__c = joblist[0].sirenum__Account__c;
                                    insert ps;
                                    batchline4.IP_LinkField5__c = ps.id;
                                    placeid.add(ps.id);
                                   } 
                           }
             else
             {batchline4.IP_Status__c = 'Errored';   batchline4.IP_ErrorReason__c = 'Contact Not found';
       //  errorlist.add(batchline4);
             System.debug('Inside Else 1');
             }
                            } 
                            else
                            {
                                System.debug('Inside Else 2');
                                System.debug('Check site'+batchline4.IP_LinkField2__c);
                                System.debug('check job role'+batchline4.IP_LinkField3__c);
                                System.debug('check contact'+batchline4.IP_LinkField1__c);
                                batchline4.IP_Status__c = 'Errored';   
                             //  errorlist.add(batchline4);
                                    if(batchline4.IP_ErrorReason__c != 'Only pay profile compliant candidates can be assigned to shifts')
                             {
                                      if(batchline4.IP_LinkField1__c==null)
                                    {
                                    batchline4.IP_ErrorReason__c = 'Contact not found';                                 
                                    }
                                    else if(batchline4.IP_LinkField2__c==null)
                                    {
                                        batchline4.IP_ErrorReason__c = 'Site not found';
                                    }
                                    else
                                    batchline4.IP_ErrorReason__c = 'Job Role not found';
                             }
                             else
                             {
                                batchline4.IP_ErrorReason__c = 'Only pay profile compliant candidates can be assigned to shifts'; 
                             }
                               
                            }
                           }
                 
                     
            // update batchlinelist;
            Database.SaveResult[] sList;
          Map<Id,String> Errmsg = new Map<Id,String>();
          List<sirenum__Timesheet__c> tmsheet = new List<sirenum__Timesheet__c>();
             System.debug('contactid ' +contactid);
             if(joblist.size()>0 && sitelist.size()>0)
             {
             tmsheet = [select id,name,sirenum__Worker__c,sirenum__Week_Ending__c from sirenum__Timesheet__c where sirenum__Worker__c in : contactid and sirenum__Week_Ending__c in :setdate and Id NOT in (Select sirenum__Timesheet__c from sirenum__Timesheet_Line__c where IP_Locktimesheet__c = True) and sirenum__site__c =:sitelist[0].id and sirenum__team__c=:joblist[0].id];
             }
             System.debug('$$Timesheet Line list'+tmsheet);
             Map<Id,String> timesheetmap = new Map<Id,String>();

             for(IP_BatchLine__c checkbatch : batchlinelist)
             {
                 if(tmsheet.size()>0){
                                 for(sirenum__Timesheet__c timesheet1 :tmsheet ){
                                     if(timesheet1.sirenum__Worker__c==checkbatch.IP_LinkField1__c  && timesheet1.sirenum__Week_Ending__c == checkbatch.IP_DateField1__c)
                                     {
                                         timesheetmap.put(timesheet1.sirenum__Worker__c,'Yes');   break;}
                                 else
                                 {
                                     
                    timesheetmap.put(timesheet1.sirenum__Worker__c,'No');  break;                                    
                                 }
                                 }
                 }
                 else
                 {timesheetmap.put(checkbatch.IP_LinkField1__c,'No');  }
             }
             
             system.debug('timesheetmap'+timesheetmap);
             // Creation of timesheet
             list<sirenum__Placement__c> placelist = new list<sirenum__Placement__c>();
             if(joblist.size()>0 && sitelist.size()>0)
             {
               placelist = [select id,IP_PayrollStatus__c,sirenum__Site__r.sirenum__Operating_Company__c, sirenum__Site__r.sirenum__Operating_Company__r.name,name,sirenum__Contact__c,sirenum__Start_Date__c,sirenum__End_Date__c,sirenum__Status__c,sirenum__Site__c,sirenum__Job_Role__c from sirenum__Placement__c where sirenum__Contact__c in : contactid  and sirenum__Job_Role__c =:joblist[0].id and sirenum__Site__c=:sitelist[0].id and IP_PayrollStatus__c=null and sirenum__Status__c ='Active'];
                 
                 } for(Date dt :setdate)
                        {
                            Boolean check=false;
                         
                            String bconId ='';
                  for(IP_BatchLine__c batchuniq : batchlinelist)
                  {
                     If(placelist.size()>0 && batchuniq.IP_LinkField5__c!='' ){
                    for(Integer i = 0;i<placelist.size();i++){
                      If(batchuniq.IP_LinkField5__c==placelist[i].id)
                      {
                   if(batchuniq.IP_Status__c != 'Errored' && batchuniq.IP_LinkField5__c!=null && timesheetmap.get(batchuniq.IP_LinkField1__c)=='No'){
                                        if(batchuniq.IP_DateField1__c==dt && bconId!= batchuniq.IP_LinkField1__c)
                                        {
                                        sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
                                        newTimeSheet1.sirenum__Worker__c = batchuniq.IP_LinkField1__c;
                                        newTimesheet1.sirenum__Client__c=placelist[i].sirenum__Site__r.sirenum__Operating_Company__c;
                                        newTimesheet1.sirenum__Team__c=placelist[i].sirenum__Job_Role__c;
                                        newTimesheet1.sirenum__Site__c=placelist[i].sirenum__Site__c;
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
            
                  try{ sList=  Database.insert(newtimesheet,false);   }
                  
                  catch(Exception DMLException){  }
          
             for (Database.SaveResult sr : sList) {
          if (sr.isSuccess()) {
                System.debug('Successfully inserted Timesheet: ' + sr.getId());
                    Errmsg.put(sr.getId(),'Success');
            }
            else {
                      for(Database.Error err : sr.getErrors()) {  Errmsg.put(sr.getId(),err.getMessage());
                       }
                      
                  }
                  }
             
                  system.debug('timesheet'+newtimesheet);
             // Mapping of timesheet on batchline
              for(IP_BatchLine__c batchtimesheet : batchlinelist)
              {
                  If(timesheetmap.get(batchtimesheet.IP_LinkField1__c)=='No')
                  {
                  for(sirenum__Timesheet__c t : newtimesheet)
                  {
                     If(batchtimesheet.IP_Status__c!='Errored' && batchtimesheet.IP_DateField1__c==t.sirenum__Week_Ending__c && batchtimesheet.IP_LinkField1__c == t.sirenum__Worker__c )
                     {
                         If(Errmsg.get(t.Id)!='Success')
                         {
                             batchtimesheet.IP_Status__c='Errored';    batchtimesheet.IP_ErrorReason__c=Errmsg.get(t.Id);
                            // errorlist.add(batchtimesheet);
                             errorid.add(batchtimesheet.id);
                         }
                         else
                         {
                               batchtimesheet.IP_LinkField6__c = t.Id;
                         }
                         
                     }
                  }
                  }
                  else
                  {
                      for(sirenum__Timesheet__c stimesheet : tmsheet)
                      {
                          
                     If(batchtimesheet.IP_Status__c != 'Errored' && batchtimesheet.IP_DateField1__c==stimesheet.sirenum__Week_Ending__c && batchtimesheet.IP_LinkField1__c == stimesheet.sirenum__Worker__c )
                     {
                                batchtimesheet.IP_LinkField6__c = stimesheet.Id;
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
             List<sirenum__Placement__c> placement = [select id,sirenum__Site__r.sirenum__Operating_Company__c,sirenum__Job_Role__r.sirenum__Rota__c, sirenum__Site__r.sirenum__Operating_Company__r.name,name,sirenum__Contact__c,sirenum__Start_Date__c,sirenum__End_Date__c,sirenum__Status__c,sirenum__Site__c,sirenum__Job_Role__c from sirenum__Placement__c where id in : placeid limit 1];
             List<sirenum__Shift__c> shiftList = new List<sirenum__Shift__c>();
              System.debug('@@ $$ '+sheetnumber);
             If(newtimesheet.size()>0 && placement.size()>0)
            {
                   System.debug('@@ '+sheetnumber);
                    for(sirenum__Timesheet__c timesheet2 :newtimesheet )
                      {
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
                          system.debug('sheetnumber '+sheetnumber);            
                          break;
                      }                   
            }

              try{
                  saveList =  Database.insert(shiftList,false);     
                  } catch(Exception DMLException){       }
             
                  system.debug('shiftList'+shiftList);
        
              // checking for error messages which came at the time of Shift creation
                  for (Database.SaveResult sr : saveList) {
          if (sr.isSuccess()) {
                      System.debug('Successfully inserted Shift. Shift ID: ' + sr.getId());
                    Errormsg1.put(sr.getId(),'Success');
            }
            else {
                      for(Database.Error err : sr.getErrors()) 
                      {              Errormsg1.put(sr.getId(),err.getMessage());
                       }
                      
                  }
                  }
              
             system.debug('@@ '+batchlinelist);
              Database.SaveResult[] srList;
    // If shift is not available in shift then it will pick old created shifts and attach timesheetline to them        
             Map<Id,sirenum__Shift__c> oldshiftmap = new Map<Id,sirenum__Shift__c>();
             List<sirenum__Shift__c> oldshift = new List<sirenum__Shift__c>();
             if(shiftmap.size()==0)
             {
             for(sirenum__Shift__c sf : [select id,sirenum__Timesheet_summaries__r.id from sirenum__Shift__c where sirenum__Timesheet_summaries__c in: tmsheet])
             { 
               oldshiftmap.put(sf.sirenum__Timesheet_summaries__r.id, sf);               oldshift.add(sf);
             }
             }
             
         //------------------ Mapping of shift on batchline
  
      for(IP_BatchLine__c batchshift : batchlinelist)
              {
                  If(shiftList.size()>0)
                  {
                  for(sirenum__Shift__c s : shiftList)
                  {
                     If(batchshift.IP_Status__c!='Errored' && batchshift.IP_LinkField6__c == s.sirenum__Timesheet_summaries__c)
                     {
                         If(Errormsg1.get(s.Id)!='Success')
                         {
                             batchshift.IP_Status__c='Errored';                        batchshift.IP_ErrorReason__c=Errormsg1.get(s.Id);
                            // errorlist.add(batchshift);
                              errorid.add(batchshift.id);
                         }
                         else
                         {
                               batchshift.IP_LinkField4__c = s.Id;
                         }
                         
                     }
                  }
                  }
                     else
                  {
                     if(oldshift.size()>0)
                     {
                      for(sirenum__Shift__c s : oldshift)
                      {
                          
                     If(batchshift.IP_Status__c != 'Errored' && batchshift.IP_LinkField6__c == s.sirenum__Timesheet_summaries__c)
                     {
                                batchshift.IP_LinkField4__c = s.Id;
                       }
                      }
                      }
                      else
                      {
                      if(batchshift.IP_Status__c != 'Errored')
                      {
                      batchshift.IP_Status__c = 'Errored';                      batchshift.IP_ErrorReason__c = 'Shift not found';
                      // errorlist.add(batchshift);
                        errorid.add(batchshift.id);
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
                      for(Integer i=0;i<newtimesheet.size();i++ )
                      {
                          system.debug('newtimesheet '+newtimesheet[i]);
                       system.debug('Testing '+batchline5.IP_ErrorReason__c+' '+batchline5.IP_Status__c +' '+batchline5.IP_DateField1__c +' '+ newtimesheet[i].sirenum__Week_Ending__c+' '+batchline5.IP_LinkField1__c +' '+newtimesheet[i].sirenum__Worker__c);
                        if(shiftmap.size()>0 && batchline5.IP_Status__c != 'Errored' && batchline5.IP_DateField1__c== newtimesheet[i].sirenum__Week_Ending__c && batchline5.IP_LinkField1__c==newtimesheet[i].sirenum__Worker__c){
                                     system.debug('shiftmap.get(newtimesheet[i]) '+shiftmap.get(newtimesheet[i].id));
                                     sirenum__Timesheet_Line__c timeSheetLine1 = new sirenum__Timesheet_Line__c();
                                     timeSheetLine1.sirenum__Timesheet__c =  newtimesheet[i].id;  
                                     timeSheetLine1.sirenum__Rate__c      =  batchline5.IP_CurrencyField1__c;
                                     timeSheetLine1.sirenum__Hours__c     =  batchline5.IP_Number12d4Field1__c; 
                                     if(batchline5.IP_TextField9__c == 'P1')
                                     {
                                        timeSheetLine1.IP_RateCodes__c       =  'Standard Hours /P1';                                    
                                     }
                                     else if(batchline5.IP_TextField9__c == 'OF')
                                     {
                                        timeSheetLine1.IP_RateCodes__c       =  'Additional Hours/ OF'; 
                                     }
                                      else if(batchline5.IP_TextField9__c == 'BT')
                                     {
                                        timeSheetLine1.IP_RateCodes__c       =  'Time and a half/ BT'; 
                                     }
                                      else if(batchline5.IP_TextField9__c == 'WX')
                                     {
                                        timeSheetLine1.IP_RateCodes__c       =  'Double time/ WX'; 
                                     }
                                      else if(batchline5.IP_TextField9__c == 'SN')
                                     {
                                        timeSheetLine1.IP_RateCodes__c       =  'Shift Allowance Nights/ SN'; 
                                     }
                                      else if(batchline5.IP_TextField9__c == 'CB')
                                     {
                                        timeSheetLine1.IP_RateCodes__c       =  'Weekly Bonus/ CB'; 
                                     }
                                      else if(batchline5.IP_TextField9__c == 'MB')
                                     {
                                        timeSheetLine1.IP_RateCodes__c       =  'Holiday Bonus/ MB'; 
                                     }
                                      else if(batchline5.IP_TextField9__c == 'PP')
                                     {
                                        timeSheetLine1.IP_RateCodes__c       =  'Shift Allowance Weekends/ PP'; 
                                     }                                    
                                     else
                                     {
                                        timeSheetLine1.IP_RateCodes__c       =    batchline5.IP_TextField9__c;
                                     }
                                     timeSheetLine1.For_BatchClass__c     =  true;
                                     timeSheetLine1.IP_PurchaseOrderNumber__c   =  batchline5.IP_TextField10__c; 
                                     timeSheetLine1.sirenum__Charge__c    =  batchline5.IP_CurrencyField2__c;
                                     timeSheetLine1.Batchvalue__c         =  batchline5.Name;
                                     timeSheetLine1.sirenum__Date__c      =  batchline5.IP_DateField1__c;
                                   //  timeSheetLine1.IP_PurchaseOrderNumber__c = batchline5.IP_TextField4__c;
                                     timesheetLine1.sirenum__Shift__c = shiftmap.get(newtimesheet[i].id).id;
                                     timesheetline.add(timeSheetLine1);
                                   // batchline5.IP_LinkField4__c = timesheet2.id;
                               
                                    break;
                          }
                          }
                        } 
                        else
                          {
                              system.debug('tmsheet.size() '+tmsheet.size());
                                 for(Integer i=0;i<tmsheet.size();i++)
                      {
                            system.debug('tmsheet[i].sirenum__Week_Ending__c '+tmsheet[i].sirenum__Week_Ending__c);
                           if(oldshiftmap.size()>0 && batchline5.IP_Status__c != 'Errored' && batchline5.IP_DateField1__c== tmsheet[i].sirenum__Week_Ending__c && batchline5.IP_LinkField1__c==tmsheet[i].sirenum__Worker__c){
                          
                                   sirenum__Timesheet_Line__c timeSheetLine1 = new sirenum__Timesheet_Line__c();
                                    timeSheetLine1.sirenum__Timesheet__c =  tmsheet[i].id;  timeSheetLine1.sirenum__Rate__c      =  batchline5.IP_CurrencyField1__c;     timeSheetLine1.sirenum__Hours__c     =  batchline5.IP_Number12d4Field1__c; 
                                     if(batchline5.IP_TextField9__c == 'P1')
                                     {
                                        timeSheetLine1.IP_RateCodes__c       =  'Standard Hours /P1';                                    
                                     }
                                     else if(batchline5.IP_TextField9__c == 'OF')
                                     {
                                        timeSheetLine1.IP_RateCodes__c       =  'Additional Hours/ OF'; 
                                     }
                                      else if(batchline5.IP_TextField9__c == 'BT')
                                     {
                                        timeSheetLine1.IP_RateCodes__c       =  'Time and a half/ BT'; 
                                     }
                                      else if(batchline5.IP_TextField9__c == 'WX')
                                     {
                                        timeSheetLine1.IP_RateCodes__c       =  'Double time/ WX'; 
                                     }
                                      else if(batchline5.IP_TextField9__c == 'SN')
                                     {
                                        timeSheetLine1.IP_RateCodes__c       =  'Shift Allowance Nights/ SN'; 
                                     }
                                      else if(batchline5.IP_TextField9__c == 'CB')
                                     {
                                        timeSheetLine1.IP_RateCodes__c       =  'Weekly Bonus/ CB'; 
                                     }
                                      else if(batchline5.IP_TextField9__c == 'MB')
                                     {
                                        timeSheetLine1.IP_RateCodes__c       =  'Holiday Bonus/ MB'; 
                                     }
                                      else if(batchline5.IP_TextField9__c == 'PP')
                                     {
                                        timeSheetLine1.IP_RateCodes__c       =  'Shift Allowance Weekends/ PP'; 
                                     }                                     
                                     else
                                     {
                                        timeSheetLine1.IP_RateCodes__c       =    batchline5.IP_TextField9__c;
                                     }
                                     timeSheetLine1.IP_PurchaseOrderNumber__c   =  batchline5.IP_TextField10__c; 
                                    timeSheetLine1.For_BatchClass__c     =  true;             timeSheetLine1.sirenum__Charge__c    =  batchline5.IP_CurrencyField2__c;
                                    timeSheetLine1.Batchvalue__c         =  batchline5.Name;   timeSheetLine1.sirenum__Date__c      =  batchline5.IP_DateField1__c;
                                  //  timeSheetLine1.IP_PurchaseOrderNumber__c = batchline5.IP_TextField4__c;
                               timesheetLine1.sirenum__Shift__c = oldshiftmap.get(tmsheet[i].id).id;                                    timesheetline.add(timeSheetLine1);
                               break;
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
                    Errormsg.put(sr.getId(),'Success');
            } 
            else {
                      for(Database.Error err : sr.getErrors()) {                Errormsg.put(sr.getId(),err.getMessage());
                       }
                      
                  }
                  }
             
                System.debug('Errormsg -- '+Errormsg);   
             // mapping of timesheetline on Batchline field linkfield5
                  for(sirenum__Timesheet_Line__c timeline : timesheetline)
                  {
                    System.debug('timeline.Batchvalue__c -- '+timeline.Batchvalue__c);
                      for(IP_BatchLine__c batchline6 : batchlinelist){
                           System.debug('batchline6.name -- '+batchline6.Name);
                           if( batchline6.IP_Status__c != 'Errored' && timeline.Batchvalue__c==batchline6.Name && timesheetmap.get(batchline6.IP_LinkField1__c) =='No'){
                       System.debug('IN IF batchline6.name -- '+batchline6.Name);
                             
                               
                       If(Errormsg.get(timeline.Id)!='Success')
                             {
                                 
                                  batchline6.IP_Status__c='Errored';                           batchline6.IP_ErrorReason__c=Errormsg.get(timeline.Id);
                                   //errorlist.add(batchline6);
                                    errorid.add(batchline6.id);
                             }
                               else
                               {
                                    batchline6.IP_LinkField7__c = timeline.id; 
                                batchline6.IP_Status__c = 'Complete';
                                successlist.add(batchline6);
                               }
                                 
                           }
                          else
                          {
                               for(sirenum__Timesheet__c stimesheet : tmsheet)
                      {
                          
                     If( timeline.Batchvalue__c==batchline6.Name && batchline6.IP_Status__c != 'Errored' && batchline6.IP_DateField1__c==stimesheet.sirenum__Week_Ending__c && batchline6.IP_LinkField1__c == stimesheet.sirenum__Worker__c )
                     {
                          If(Errormsg.get(timeline.Id)!='Success')
                             {
                                 
                                  batchline6.IP_Status__c='Errored';                                  batchline6.IP_ErrorReason__c=Errormsg.get(timeline.Id);
                                 // errorlist.add(batchline6);
                                  errorid.add(batchline6.id);
                             }
                               else
                               {
                                batchline6.IP_LinkField7__c = timeline.Id;                          batchline6.IP_Status__c = 'Complete';
                                successlist.add(batchline6);
                               }
                       }
                      }
                              
                          }
                     }
                    }
             
                                    
                  update batchlinelist;
                  
                    Batch_header__c batchheaderlist = [Select id,IP_State__c,IP_Status__c,Check_Status__c from  Batch_header__c where id in: headerId];
             
                  
                   batchheaderlist.Check_Status__c = 'true';
                  update batchheaderlist;
                  
          /*   List<Batch_header__c> batchheaderlist = [Select id,IP_State__c,IP_Status__c,Check_Status__c from  Batch_header__c where id in: headerId];
             
                  system.debug('after update batchline'+batchlinelist);
                  
                   for(Batch_header__c batchheader1 : batchheaderlist){
                   batchheader1.Check_Status__c = 'true';
                       for(IP_BatchLine__c batchline7 : batchlinelist){
                   
                             if(batchline7.IP_Status__c == 'Complete' && batchline7.IP_BatchHeader__c == batchheader1.id && !checkstatus){
                             
                                 batchheader1.IP_Status__c = 'Processed';
                                 batchheader1.IP_State__c ='Processing';
                            
                              }
                              
                              else if(batchline7.IP_Status__c == 'Errored' && batchline7.IP_BatchHeader__c == batchheader1.id ){
                             
                                 batchheader1.IP_Status__c = 'Errored'; 
                                   batchheader1.IP_State__c ='Processing';
                                  checkstatus = TRUE;

                              //   break;  
                 
                              }
                              
                              else {
                                       if(batchline7.IP_Status__c == 'Open' && batchline7.IP_BatchHeader__c == batchheader1.id)
                                      {
                                      batchheader1.IP_Status__c = 'Partial Complete';                                    batchheader1.IP_State__c ='Processing';
                                      }
                              }
                         }
                   }
                  
                  update batchheaderlist;
                  system.debug('after update batch header'+batchheaderlist); */

        }
             global void finish(Database.BatchableContext BC){
            List<Batch_header__c > check123 = [Select id,Check_status__c from Batch_header__c where Check_status__c !=null];
             for(Batch_header__c   checkbatch123 : check123)
             {
              checkbatch123.Check_status__c = '';
             }
             update check123;
              //      List<IP_Batchline__c> successlist = [Select id,IP_Status__c from IP_Batchline__c where IP_batchheader__c =:headerId and IP_Status__c = 'Complete'];
         List<IP_Batchline__c> errorlistfinal = [Select id,IP_Status__c,Name,IP_ErrorReason__c from IP_Batchline__c where id in:errorid];
            List<IP_Batchline__c> unprocesssed= [Select id,IP_Status__c from IP_Batchline__c where IP_batchheader__c =:headerId and IP_Status__c = 'Open'];
           List<IP_Batchline__c> erroredlines= [Select id,IP_Status__c from IP_Batchline__c where IP_batchheader__c =:headerId and IP_Status__c = 'Errored'];
             Batch_header__c  bheader = [Select id,IP_Status__c,IP_State__c from Batch_header__c  where id=:headerId limit 1];
           
           if(unprocesssed.size()>0)
           {
              bheader.IP_Status__c = 'Pending Approval';
              bheader.IP_State__c = 'Open';
           }
           
           else if(erroredlines.size()>0)
           {
             bheader.IP_Status__c = 'Errored';
              bheader.IP_State__c = 'Processing';
           }
           else
           {
               bheader.IP_Status__c = 'Processed';
              bheader.IP_State__c = 'Closed';
           }
           update bheader;
           
           
           
           
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();         
            String subject ='Shop Direct - Little Hulton Processing Complete';
            email.setSubject(subject);
            String[] toAddress = new String[] {'shopdirect.shaw@bluearrow.co.uk'};
            email.setToAddresses(toAddress);
 String htmlbody = 'Hello,<br/><br/>';
        htmlbody+= 'Batch processing completed with '+ successlist.size() + ' success and ' + errorlistfinal.size() + ' errors and ' + unprocesssed.size() +' unprocessed lines.<br/><br/>';
    
    if(errorlistfinal.size()>0)
    {
    htmlBody+= '<table border="1" style="border-collapse: collapse" width:"100%" cellspacing="5" cellpadding="5"><tr ><th>Name</th><th>Status</th><th>Error</th></tr>';

    for(IP_Batchline__c l : errorlistfinal){

        String ID = l.Name; 
        String Status = l.IP_Status__c; 
        String Error = l.IP_ErrorReason__c;

        htmlBody+= '<tr><td>' + ID + '</td><td>' + Status + '</td><td>' + Error + '</td></tr>';

    }
    htmlBody+= '</table>';
    }
    email.setHtmlBody(htmlBody);
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
}