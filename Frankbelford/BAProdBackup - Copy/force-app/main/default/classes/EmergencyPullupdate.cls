global class EmergencyPullupdate{
   webservice static String updatedata(String timesheetid) {
         try {
         set<id> con = new set<id>();
         set<String> pay= new set<String>();
         set<String> siteset = new set<String>();
          sirenum__Timesheet__c sheet= [Select id,IP_EmergencyPull__c,sirenum__Site__c,sirenum__Worker__c,sirenum__Worker__r.Recordtype.developername,sirenum__Worker__r.IP_BorrowedTemp__c from sirenum__Timesheet__c where id=:timesheetid LIMIT 1];
          con.add(sheet.sirenum__Worker__c);
          List<sirenum__Timesheet_Line__c> lineid = [Select id,IP_PassToTempest__c from sirenum__Timesheet_Line__c where sirenum__Timesheet__c =:timesheetid];
          List<sirenum__Timesheet_Line__c> updateline = new List<sirenum__Timesheet_Line__c>();
          sirenum__Timesheet_Line__c tlshift = [Select id,sirenum__Shift__c from sirenum__Timesheet_Line__c where sirenum__Timesheet__c =:timesheetid order by createddate DESC limit 1];
          for (sirenum__Timesheet_Line__c t : lineid)
             {
                 t.IP_PassToTempest__c = TRUE;
                 updateline.add(t);}
                 sheet.IP_EmergencyPull__c  = TRUE;
                  update(updateline);
             update sheet;
             
             system.debug('checl TL shift in code'+tlshift.sirenum__shift__c);
          sirenum__Shift__c shiftid = [Select id,sirenum__Placement__c,sirenum__site__c from sirenum__Shift__c  where id=:tlshift.sirenum__Shift__c LIMIT 1];
          if(shiftid.sirenum__Placement__c !=null)
          {
          sirenum__Placement__c place = [Select id,IP_EmergencyPull__c,IP_PayMethod__c,IP_PayMethod__r.name,IP_PassToTempest__c,sirenum__site__c from sirenum__Placement__c where id=:shiftid.sirenum__Placement__c LIMIT 1];
          place.IP_PassToTempest__c = TRUE;
          place.IP_EmergencyPull__c = TRUE;
           update place;
           system.debug('$$$Pay Method'+place.IP_PayMethod__c);
           pay.add(place.IP_PayMethod__c);
           siteset.add(place.sirenum__site__c);
           }
           system.debug('Pay Profile^^'+pay);
           if(!siteset.contains(null))
             {
          sirenum__Site__c  site = [Select id,IP_EmergencyPullClientAddress__c,IP_EmergencyPullClient__c,IP_PassClientToTempest__c,IP_PassClientAddressToTempest__c from sirenum__Site__c  where id in :siteset LIMIT 1];
          site.IP_EmergencyPullClientAddress__c = TRUE;
          site.IP_EmergencyPullClient__c = TRUE;
          site.IP_PassClientToTempest__c = TRUE;
          site.IP_PassClientAddressToTempest__c = TRUE;
           update site;
           }
          if(sheet.sirenum__Worker__r.Recordtype.developername == 'IP_2ndTierCandidate')
          { 
            Contact tier = [select id,IP_Pass2ndTierToTempest__c from Contact where id in :con];
            tier.IP_Pass2ndTierToTempest__c = TRUE;
            tier.IP_EmergencyPull__c = True;
            update tier;
          }
          if(sheet.sirenum__Worker__r.IP_BorrowedTemp__c!='Yes' && sheet.sirenum__Worker__r.Recordtype.developername != 'IP_2ndTierCandidate' && !pay.contains(null))
          {       
         // system.debug('inseide if pay profile###'+pay.IsEmpty());
          IP_PayProfile__c payprof = [Select id,IP_EmergencyPull__c,IP_PassToTempest__c from IP_PayProfile__c where id in:pay];
          payprof.IP_EmergencyPull__c = TRUE;
          payprof.IP_PassToTempest__c  = TRUE;
          update payprof;
          }  
          } 
          
          catch (DmlException e) {
             return e.getMessage();
              system.debug('check exception'+e.getmessage());
          }
           return 'Records flagged successfully.';
   }
}