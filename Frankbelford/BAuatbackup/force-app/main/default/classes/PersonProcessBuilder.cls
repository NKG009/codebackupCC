public class PersonProcessBuilder {
    @future 
    public static void updatePass2ndtiertoTempest(Set<id> Personid){
        
        List<Contact> con =[Select id, IP_LastPassedToTempest2ndTier__c,IP_TimesheetIDLink__c ,IP_TempestDepartment__c,Person_Status__c,IP_Pass2ndTierToTempest__c from Contact where id in :Personid];
        List<Contact> conlist = new List<Contact>();
        for(Contact c:con)
        {
            system.debug('DD:'+c.IP_LastPassedToTempest2ndTier__c+'::'+c.Person_Status__c+'::'+c.IP_TempestDepartment__c);
            if( c.IP_LastPassedToTempest2ndTier__c != null && (c.Person_Status__c =='Active' || c.Person_Status__c =='Pending') && c.IP_TempestDepartment__c!='0000'){    //jyothi
            //if( c.IP_LastPassedToTempest2ndTier__c != null && c.Person_Status__c =='Active' && c.IP_TempestDepartment__c!='0000'){                //jyothi
                c.IP_Pass2ndTierToTempest__c =true;
               // c.IP_FirstPassExternalWorker__c = true;
                conlist.add(c);
            }
            //else if( c.IP_LastPassedToTempest2ndTier__c == null && c.IP_TimesheetIDLink__c != null &&c.Person_Status__c =='Active' && c.IP_TempestDepartment__c!='0000'){     //jyothi   
            else if( c.IP_LastPassedToTempest2ndTier__c == null && c.IP_TimesheetIDLink__c != null && (c.Person_Status__c == 'Active' || c.Person_Status__c == 'Pending')  && c.IP_TempestDepartment__c!='0000'){     //jyothi              
                c.IP_Pass2ndTierToTempest__c =true;                c.IP_FirstPassExternalWorker__c = true;                conlist.add(c);
            }
        }
        if(conlist.size()>0){
            
         
        /*    Database.SaveResult[] srList = Database.update(conlist, false); 
                       for (Database.SaveResult sr : srList) {           
                         if (sr.isSuccess()) {
                    System.debug('Successfully updated contact. contact ID: ' + sr.getId());
                }
            } */   
      
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.AllowSave = true;
          
            
                Database.SaveResult[] sr2 = Database.update(conlist, dml);            
                     for (Database.SaveResult sr3 : sr2) {    
                                     if (sr3.isSuccess()) 
                       {                            System.debug('Duplicate contact has been updated!');
                        }
                    }
            
           
        }
    }
    
    
    
  /*  public static void UpdateSiteClientFlags(Set<id> Sirenumsiteid)
    {
        
        List<sirenum__Site__c> updatesite = [select id,IP_PassClientAddressToTempest__c,IP_PassClientToTempest__c from sirenum__Site__c where id in:Sirenumsiteid];
        List<sirenum__Site__c> updatesite1 = new List<sirenum__Site__c>();
        
        
        
        for(sirenum__Site__c siteData : updatesite)
        {   
            System.debug('check Swati testclass12' + siteData.IP_PassClientAddressToTempest__c );
            System.debug('check Swati testclass13' + siteData.IP_PassClientToTempest__c);
            
            
            siteData.IP_PassClientAddressToTempest__c =true;
            siteData.IP_PassClientToTempest__c =true;
            updatesite1.add(siteData);            
        }   
        if(updatesite1.size()>0){
            update updatesite1;
            
        }
    }*/
    
    public static void UpdatepayProfile(Set<id> candidateId){
        
        List<IP_PayProfile__c> updatepayprofilelist = [select id,IP_FirstPass__c,IP_TimesheetIDLink__c,IP_Candidate__r.IP_TempestDepartment__c,IP_LastPassedToTempest__c,IP_Status__c,IP_PassToTempest__c from IP_PayProfile__c where IP_Candidate__c in :candidateId];
       // List<Contact> contactlist = [select id,Sync_Pay_Profile__c from Contact where id in :candidateId];
       Set<id> Contactset = new Set<id>();
        List<IP_PayProfile__c> updatepayprofilelist1 = new List<IP_PayProfile__c>();
        List<IP_PayProfile__c> updatepayprofilelist2 = new List<IP_PayProfile__c>();
        String abc;
        for(IP_PayProfile__c payprofile : updatepayprofilelist){
            System.debug('check Swati testclass' + payprofile.IP_LastPassedToTempest__c );
            System.debug('check Swati testclass1' + payprofile.IP_Status__c);
           
             If(payprofile.IP_Candidate__r.IP_TempestDepartment__c=='0000')
             {
               payprofile.IP_MissingPayrollDetail__c='Owner not a branch staff';
                    system.debug('tempestdepart---'+payprofile);
                    updatepayprofilelist2.add(payprofile);   
             }
             else if(payprofile.IP_LastPassedToTempest__c!=null && payprofile.IP_Status__c=='Active') {
                payprofile.IP_PassToTempest__c = true;
                system.debug('IN PASS TO tempest');
                updatepayprofilelist1.add(payprofile);            
            }
              else if(payprofile.IP_LastPassedToTempest__c==null && payprofile.IP_TimesheetIDLink__c!=null &&  payprofile.IP_Status__c=='Active') {
                payprofile.IP_PassToTempest__c = true;                payprofile.IP_FirstPass__c = true;
                system.debug('IN PASS TO tempest');
                updatepayprofilelist1.add(payprofile);            
            }
            else{ 
                if(payprofile.IP_LastPassedToTempest__c==null){
                    system.debug('i n my area');
                    payprofile.IP_MissingPayrollDetail__c='Pay Profile not qualified to be flagged';
                    system.debug('i n my area---'+payprofile);
                    updatepayprofilelist2.add(payprofile);   
                }
            }       
            
            
        
      /*  if(updatepayprofilelist1.size()>0){
            //update updatepayprofilelist1;  ///////// duplicate check bypass 
              Database.SaveResult[] srList = Database.update(updatepayprofilelist1, false); 
              for (Database.SaveResult sr : srList) { 
              if (sr.isSuccess()) {
                    Contactset.add(sr.getId());
                    System.debug('Successfully updated contact. contact ID: ' + sr.getId());
                                        
                }
            }  */
        /*    if(updatepayprofilelist2.size()>0)
            {
                List<Database.SaveResult> res1 = Database.update(updatepayprofilelist2,false); 
            }
            system.debug('Pay profile to udpate on department change'+updatepayprofilelist2);
            if(updatepayprofilelist1.size()>0){
            List<Database.SaveResult> res = Database.update(updatepayprofilelist1,false); 
            
            for (Integer i=0;i<updatepayprofilelist1.size();i++){
                Database.SaveResult s = res[i];
                IP_PayProfile__c origRecord =updatepayprofilelist1[i];
                if (s.isSuccess()) {
                    system.debug(s.getId()); // I get null here
                    system.debug(origRecord.Id); //This should be the Id you're looking for
                    Contactset.add(origRecord.IP_Candidate__c);
                 } 
            
            } 
            } */ 
            List<Contact> contactlist = [select id,Sync_Pay_Profile__c from Contact where id in :Contactset];
        //  List<Contact> updatecontactlist = new List<Contact>();
            for(Contact c:contactlist)
            {                c.Sync_Pay_Profile__c = TRUE;
                
            }
            if(contactlist.size()>0)  {  Database.SaveResult[] sr4 = Database.update(contactlist, false); }
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.AllowSave = true;
            Database.SaveResult[] sr5 = Database.update(contactlist, dml);
            System.debug('&&Contact List Updated'+sr5);

            Database.DMLOptions dml2 = new Database.DMLOptions(); 
            dml2.DuplicateRuleHeader.AllowSave = true;
            Database.SaveResult[] sr2 = Database.update(updatepayprofilelist1, dml2);
            for (Database.SaveResult sr3 : sr2) { 
            if (sr3.isSuccess()) {
                    System.debug('Duplicate contact has been updated!');
                }
            }
            
            Database.DMLOptions dml3 = new Database.DMLOptions(); 
            dml2.DuplicateRuleHeader.AllowSave = true;
            Database.SaveResult[] sr6 = Database.update(updatepayprofilelist2, dml3);
            for (Database.SaveResult sr7 : sr6) { 
            if (sr7.isSuccess()) {
                    System.debug('Duplicate fixed pay profile has been updated!');
                }
            }
        } 
    }
      public static void UpdatepayepayProfile(Set<id> candidateId){
           
        List<IP_PayProfile__c> updatelist = [select id,IP_FirstPass__c,IP_TimesheetIDLink__c,IP_Candidate__r.IP_TempestDepartment__c,IP_LastPassedToTempest__c,IP_Status__c,IP_PassToTempest__c from IP_PayProfile__c where IP_Candidate__c in :candidateId and RecordType.Name = 'PAYE'];
       // List<Contact> contactlist = [select id,Sync_Pay_Profile__c from Contact where id in :candidateId];
       Set<id> Contactset = new Set<id>();
        List<IP_PayProfile__c> updatepayprofilelist3 = new List<IP_PayProfile__c>();
        List<IP_PayProfile__c> updatepayprofilelist4 = new List<IP_PayProfile__c>();
        String abc;
        for(IP_PayProfile__c payprofile : updatelist){
           
             If(payprofile.IP_Candidate__r.IP_TempestDepartment__c=='0000')
             {
               payprofile.IP_MissingPayrollDetail__c='Test';  updatepayprofilelist4.add(payprofile);   
             }
             else if(payprofile.IP_LastPassedToTempest__c!=null && payprofile.IP_Status__c=='Active') {
                payprofile.IP_PassToTempest__c = true;
                system.debug('IN PASS TO tempest');
                updatepayprofilelist3.add(payprofile);            
            }
            else if(payprofile.IP_LastPassedToTempest__c==null && payprofile.IP_TimesheetIDLink__c!=null &&  payprofile.IP_Status__c=='Active') {
                payprofile.IP_PassToTempest__c = true;                payprofile.IP_FirstPass__c = true;                system.debug('IN PASS TO tempest');
                updatepayprofilelist3.add(payprofile);            
            }
            else{ 
                if(payprofile.IP_LastPassedToTempest__c==null){
                    system.debug('i n my area');
                    payprofile.IP_MissingPayrollDetail__c='Test';
                    system.debug('i n my area---'+payprofile);
                    updatepayprofilelist4.add(payprofile);   
                }
            }       
            
            }
        
            if(updatepayprofilelist4.size()>0)
            {
                List<Database.SaveResult> res1 = Database.update(updatepayprofilelist4,false); 
            }
            system.debug('Pay profile to udpate on department change'+updatepayprofilelist4);
            if(updatepayprofilelist3.size()>0){  List<Database.SaveResult> res = Database.update(updatepayprofilelist3,false); 
            
            for (Integer i=0;i<updatepayprofilelist3.size();i++){
                Database.SaveResult s = res[i]; IP_PayProfile__c origRecord =updatepayprofilelist3[i];
                if (s.isSuccess()) {
                    system.debug(s.getId()); // I get null here
                    system.debug(origRecord.Id); //This should be the Id you're looking for
                    Contactset.add(origRecord.IP_Candidate__c);
                 } 
            
            } 
            }  
            List<Contact> contactlist = [select id,Sync_Pay_Profile__c from Contact where id in :Contactset];
        //  List<Contact> updatecontactlist = new List<Contact>();
            for(Contact c:contactlist) { c.Sync_Pay_Profile__c = TRUE; }
          
            if(contactlist.size()>0) { Database.SaveResult[] sr4 = Database.update(contactlist, false); }
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.AllowSave = true;
            Database.SaveResult[] sr5 = Database.update(contactlist, dml);
            System.debug('&&Contact List Updated'+sr5);

            Database.DMLOptions dml2 = new Database.DMLOptions(); 
            dml2.DuplicateRuleHeader.AllowSave = true;
            Database.SaveResult[] sr2 = Database.update(updatepayprofilelist3, dml2);
            for (Database.SaveResult sr3 : sr2) { 
            if (sr3.isSuccess()) {
                    System.debug('Duplicate contact has been updated!');
                }
            }
            
            Database.DMLOptions dml3 = new Database.DMLOptions(); 
            dml2.DuplicateRuleHeader.AllowSave = true;
            Database.SaveResult[] sr6 = Database.update(updatepayprofilelist4, dml3);
          
        } 
}