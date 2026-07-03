global class Timesheetflagging extends batchjobsch.BatchJobBase implements Database.Batchable<sObject>{
//List<sirenum__Timesheet__c> timesheetlist = new List<sirenum__Timesheet__c>();
  /*  global Timesheetflagging(List<sirenum__Timesheet__c> timesheet)
{
    timesheetlist= timesheet;
    System.debug('@@ timesheetlist flaging '+timesheetlist);
}*/
public List<sirenum__Timesheet_Line__c> shiftlist = new List<sirenum__Timesheet_Line__c>();
public Map<sirenum__placement__c,id> placelist = new Map<sirenum__placement__c,id>();
public Map<sirenum__site__c,id> sitemap = new Map<sirenum__site__c,id>();
public Map<id,id> paymap = new Map<id,id>();
public Map<Contact,id> conmap = new Map<Contact,id>();
public Map<id,String> placeerrormap =  new Map<id,String>();
public Map<id,String> payerrormap =  new Map<id,String>();
public Map<id,String> siteerrormap =  new Map<id,String>();
public Map<id,String> conerrormap =  new Map<id,String>();
public List<sirenum__placement__c> placeupdate = new List<sirenum__placement__c>();
public List<sirenum__Timesheet__c> updatetimelist = new List<sirenum__Timesheet__c>();
public set<id> tsids = new Set<id>();
public List<sirenum__site__c> updatesitelist = new List<sirenum__site__c>();
public List<Contact> updatecontact = new List<Contact>();
public List<IP_PayProfile__c> updatepayprof = new List<IP_PayProfile__c>();
public Map<id,id> shiftime =  new Map<id,id>();
public List<sirenum__Timesheet__c> successtimelist = new List<sirenum__Timesheet__c>();
public Set<id> payids = new Set<id>();

  /*  global List<sirenum__Timesheet__c> start(Database.BatchableContext BC)
    {
           System.debug('Timesheet list from duplicate**'+timesheetlist);
           return timesheetlist;
    }*/
  global Database.QueryLocator start(Database.BatchableContext BC){

      String query ='Select id,IP_FlaggingCheck__c,IP_ErrorDetail__c,IP_Error__c,sirenum__site__c,IP_DuplicateCheckPassOK__c from sirenum__Timesheet__c where IP_DuplicateCheckPassOK__c = TRUE and IP_FlaggingCheck__c = FALSE and IP_Error__c = FALSE';
    return Database.getQueryLocator(query);
} 
  global void execute(Database.BatchableContext BC,List<sirenum__Timesheet__c> timelist){
       Database.SaveResult[] srList;
       Database.SaveResult[] srList1;
       Database.SaveResult[] srList2;
       Database.SaveResult[] srList3;
       System.debug('Timesheet size check'+timelist.size());
       for(sirenum__Timesheet_line__c sh: [Select id,sirenum__shift__c,sirenum__Timesheet__c from sirenum__Timesheet_line__c where sirenum__Timesheet__c in : timelist order by createddate DESC])
       {
           shiftime.put(sh.sirenum__Timesheet__c, sh.sirenum__shift__c);
       }
       
  System.debug('Shift Map check'+shiftime);
  
  shiftlist = [Select id,sirenum__shift__r.sirenum__Contact__r.IP_LastPassedToTempest2ndTier__c,sirenum__shift__c,sirenum__shift__r.sirenum__placement__c,sirenum__shift__r.sirenum__placement__r.IP_Consultant1LookupSplitShare__r.Name,sirenum__shift__r.sirenum__placement__r.IP_Consultant1LookupSplitShare__r.IP_TempestDepartment__c,sirenum__shift__r.sirenum__placement__r.IP_Consultant1LookupSplitShare__r.IP_TempestDivision__c,sirenum__shift__r.sirenum__placement__r.IP_Consultant1LookupSplitShare__r.IP_TempestID__c,sirenum__shift__r.sirenum__placement__r.IP_PassToTempest__c,sirenum__shift__r.sirenum__placement__r.IP_LastPassedToTempest__c,sirenum__shift__r.sirenum__site__c,sirenum__shift__r.sirenum__site__r.IP_PassClientToTempest__c,sirenum__shift__r.sirenum__site__r.IP_PassClientAddressToTempest__c,sirenum__shift__r.sirenum__site__r.IP_ClientAddressLastPassedToTempest__c,sirenum__shift__r.sirenum__site__r.IP_ClientLastPassedToTempest__c,sirenum__shift__r.sirenum__Contact__c,sirenum__shift__r.sirenum__Contact__r.RecordType.DeveloperName,sirenum__shift__r.sirenum__placement__r.IP_PayMethod__c,sirenum__shift__r.sirenum__placement__r.IP_PayMethod__r.IP_PassToTempest__c,sirenum__shift__r.sirenum__placement__r.IP_PayMethod__r.IP_LastPassedToTempest__c,sirenum__shift__r.sirenum__Contact__r.IP_Pass2ndTierToTempest__c,sirenum__Timesheet__c from  sirenum__Timesheet_line__c where sirenum__shift__c in :shiftime.values()];
  
  //shiftlist  = [Select id,sirenum__placement__c,sirenum__placement__r.IP_Consultant1LookupSplitShare__r.Name,sirenum__placement__r.IP_Consultant1LookupSplitShare__r.IP_TempestDepartment__c,sirenum__placement__r.IP_Consultant1LookupSplitShare__r.IP_TempestDivision__c,sirenum__placement__r.IP_Consultant1LookupSplitShare__r.IP_TempestID__c,sirenum__placement__r.IP_PassToTempest__c,sirenum__placement__r.IP_LastPassedToTempest__c,sirenum__site__c,sirenum__site__r.IP_PassClientToTempest__c,sirenum__site__r.IP_PassClientAddressToTempest__c,sirenum__site__r.IP_ClientAddressLastPassedToTempest__c,sirenum__site__r.IP_ClientLastPassedToTempest__c,sirenum__Contact__c,sirenum__Contact__r.RecordType.DeveloperName,sirenum__placement__r.IP_PayMethod__c,sirenum__placement__r.IP_PayMethod__r.IP_PassToTempest__c,sirenum__placement__r.IP_PayMethod__r.IP_LastPassedToTempest__c,sirenum__Contact__r.IP_Pass2ndTierToTempest__c,sirenum__Timesheet_summaries__c from  sirenum__shift__c where id in :shiftime.values()];
  System.debug('Shift List check'+shiftlist);
    for(integer i=0;i<shiftlist.size();i++)
    {
        
         paymap.put(shiftlist[i].sirenum__shift__r.sirenum__placement__r.IP_PayMethod__c,shiftlist[i].sirenum__Timesheet__c);
         payids.add(shiftlist[i].sirenum__shift__r.sirenum__placement__r.IP_PayMethod__c);
        if(shiftlist[i].sirenum__shift__r.sirenum__placement__r.IP_PassToTempest__c == FALSE && shiftlist[i].sirenum__shift__r.sirenum__placement__r.IP_LastPassedToTempest__c == null && shiftlist[i].sirenum__shift__r.sirenum__placement__r.IP_Consultant1LookupSplitShare__r.Name!=null && shiftlist[i].sirenum__shift__r.sirenum__placement__r.IP_Consultant1LookupSplitShare__r.IP_TempestID__c!=null && shiftlist[i].sirenum__shift__r.sirenum__placement__r.IP_Consultant1LookupSplitShare__r.IP_TempestDivision__c!=null && shiftlist[i].sirenum__shift__r.sirenum__placement__r.IP_Consultant1LookupSplitShare__r.IP_TempestDepartment__c!=null)
        {
            
            shiftlist[i].sirenum__shift__r.sirenum__placement__r.IP_PassToTempest__c = TRUE;
            placelist.put(shiftlist[i].sirenum__shift__r.sirenum__placement__r,shiftlist[i].sirenum__Timesheet__c);          
             System.debug('Place List check'+placelist);
             System.debug('Pay Profile ID'+payids);
             System.debug('Pay List check'+paymap);
        }
     /*   if(shiftlist[i].sirenum__contact__r.RecordType.DeveloperName!='IP_2ndTierCandidate' && shiftlist[i].sirenum__placement__r.IP_PayMethod__r.IP_PassToTempest__c == FALSE && shiftlist[i].sirenum__placement__r.IP_PayMethod__r.IP_LastPassedToTempest__c == null && shiftlist[i].sirenum__Timesheet_summaries__c!=null)
        {
            shiftlist[i].sirenum__placement__r.IP_PayMethod__r.IP_PassToTempest__c = TRUE;
            paymap.put(shiftlist[i].sirenum__placement__r.IP_PayMethod__r,shiftlist[i].sirenum__Timesheet_summaries__c);
              System.debug('Pay List check'+paymap);
        }*/
        if(shiftlist[i].sirenum__shift__r.sirenum__site__r.IP_PassClientToTempest__c == FALSE && shiftlist[i].sirenum__shift__r.sirenum__site__r.IP_ClientLastPassedToTempest__c == null)
        {
            shiftlist[i].sirenum__shift__r.sirenum__site__r.IP_PassClientToTempest__c = TRUE;
            shiftlist[i].sirenum__shift__r.sirenum__site__r.IP_PassClientAddressToTempest__c = TRUE;
            sitemap.put(shiftlist[i].sirenum__shift__r.sirenum__site__r,shiftlist[i].sirenum__Timesheet__c);
            System.debug('Site List check'+sitemap);
        }
        if(shiftlist[i].sirenum__shift__r.sirenum__Contact__r.RecordType.DeveloperName == 'IP_2ndTierCandidate' && shiftlist[i].sirenum__shift__r.sirenum__Contact__r.IP_LastPassedToTempest2ndTier__c == null && shiftlist[i].sirenum__shift__r.sirenum__Contact__r.IP_Pass2ndTierToTempest__c == FALSE && shiftlist[i].sirenum__Timesheet__c!=null)
        {
            shiftlist[i].sirenum__shift__r.sirenum__Contact__r.IP_Pass2ndTierToTempest__c = TRUE;
            conmap.put(shiftlist[i].sirenum__shift__r.sirenum__Contact__r,shiftlist[i].sirenum__Timesheet__c);
            System.debug('Con List check'+conmap);
        } 
    }
    
      updatepayprof = [Select id,IP_PassToTempest__c,IP_LastPassedToTempest__c from IP_PayProfile__c where id in:payids and IP_PassToTempest__c = FALSE and IP_LastPassedToTempest__c = null];
    
 
    placeupdate.addAll(placelist.Keyset());
    System.debug('PLace Update List'+placeupdate);
     srlist = Database.update(placeupdate,false);   
      for (integer i=0;i<placeupdate.size();i++) {
            Database.SaveResult s = srlist[i];
                sirenum__placement__c origRecord = placeupdate[i];
          if (s.isSuccess()) {
                      System.debug('Successfully updated ');
            } 
            else {
                      //errormsg = errormsg+'Failed to flag S-Placement,';
                      for(Database.Error err : s.getErrors()) {
                          placeerrormap.put(placelist.get(origRecord),err.getMessage());                          tsids.add(placelist.get(origRecord));
                       }
                      
                  }
      }
      
      System.debug('Check placement map'+placeerrormap);
   
    for(IP_PayProfile__c pp: updatepayprof)
      {
          pp.IP_PassToTempest__c = TRUE;      
      }    
       System.debug('pay prof Update List'+updatepayprof); 
     srlist1 = Database.update(updatepayprof,false);   
      for (integer i=0;i<updatepayprof.size();i++) {
            Database.SaveResult s = srlist1[i];
                IP_PayProfile__c origRecord = updatepayprof[i];
          if (s.isSuccess()) {
                      System.debug('Successfully updated ');
            } 
            else {
                     // errormsg = errormsg+'Failed to flag worker(Pay Profile),';
                      for(Database.Error err : s.getErrors()) {
                          payerrormap.put(paymap.get(origRecord.id),err.getMessage());                          tsids.add(paymap.get(origRecord.id));
                       }
                      
                  }
      }
       
        updatesitelist.addAll(sitemap.Keyset());
          System.debug('Site Update List'+updatesitelist); 
     srlist2 = Database.update(updatesitelist,false);   
      for (integer i=0;i<updatesitelist.size();i++) {
            Database.SaveResult s = srlist2[i];
                sirenum__site__c origRecord = updatesitelist[i];
          if (s.isSuccess()) {
                      System.debug('Successfully updated ');
            } 
            else {
                     // errormsg = errormsg+'Failed to flag Site,';
                      for(Database.Error err : s.getErrors()) {
                          siteerrormap.put(sitemap.get(origRecord),err.getMessage());
                            tsids.add(sitemap.get(origRecord));
                       }
                      
                  }
      }
         System.debug('Check Site map'+siteerrormap);
         
       updatecontact.addAll(conmap.Keyset());
        System.debug('Contact Update List'+updatecontact); 
     srlist3 = Database.update(updatecontact,false);   
      for (integer i=0;i<updatecontact.size();i++) {
            Database.SaveResult s = srlist3[i];
                Contact origRecord = updatecontact[i];
          if (s.isSuccess()) {
                      System.debug('Successfully updated ');
            } 
            else {
                    //  errormsg = errormsg+'Failed to flag worker(2nd Tier),';
                      for(Database.Error err : s.getErrors()) {
                          conerrormap.put(conmap.get(origRecord),err.getMessage());
                           tsids.add(conmap.get(origRecord));
                       }
                      
                  }
      }  
      
         System.debug('Check 2ndTier map'+conerrormap);
         
         updatetimelist = [Select id,IP_ErrorDetail__c,IP_Error__c from sirenum__Timesheet__c where id in:tsids];
         for(sirenum__Timesheet__c ts: updatetimelist)
         {
            ts.IP_ErrorDetail__c = '';
             if(placeerrormap.containskey(ts.id))
             {
                 ts.IP_Error__c = TRUE;                 ts.IP_ErrorDetail__c =  ts.IP_ErrorDetail__c+'Failed to flag S-placement-'+placeerrormap.get(ts.id)+',';
             }
            if(payerrormap.containsKey(ts.id))
            {
                ts.IP_Error__c = TRUE;                ts.IP_ErrorDetail__c = ts.IP_ErrorDetail__c+'Failed to flag worker(Pay profile)-'+payerrormap.get(ts.id)+',';
            }
            if(siteerrormap.containsKey(ts.id))
            {
                ts.IP_Error__c = TRUE;
                ts.IP_ErrorDetail__c = ts.IP_ErrorDetail__c+'Failed to flag site-'+siteerrormap.get(ts.id)+',';
            }
            if(conerrormap.containsKey(ts.id))
            {
                ts.IP_Error__c = TRUE;                ts.IP_ErrorDetail__c = ts.IP_ErrorDetail__c+'Failed to flag worker(2nd Tier)'+conerrormap.get(ts.id);
            }
         }
          successtimelist = [Select id,IP_FlaggingCheck__c from sirenum__Timesheet__c where id in:timelist and id not in:tsids];     

for(sirenum__Timesheet__c tl: successtimelist )
{
    tl.IP_FlaggingCheck__c = TRUE;
}

       
         Database.update(successtimelist,false);

      Database.update(updatetimelist,false);    
List<sirenum__Timesheet_Line__c> dummyupdate = [Select id from sirenum__Timesheet_Line__c where sirenum__Timesheet__c in:successtimelist and IP_SplitTimesheetLine__c = TRUE];
Database.update(dummyupdate,false);
     
  }
  
   global void finish(Database.BatchableContext BC){
           super.finishBatch(BC);

  
  
}
}