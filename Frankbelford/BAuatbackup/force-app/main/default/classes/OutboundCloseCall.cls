global class OutboundCloseCall implements Database.Batchable<sObject>,Database.Stateful{
  global Boolean sendMail = false;
  String errorFile = 'Id,Error\n';
     Map<Id,String> Errmsg = new Map<Id,String>();
IP_ImpellamGlobalSetting__c imp = IP_ImpellamGlobalSetting__c.getOrgDefaults();
Date dt = System.Today() ;
Map<id,Datetime> AssignmentMap = new Map<id,Datetime>();
Map<id,Datetime> InternalworkerMap = new Map<id,Datetime>();
Map<id,Datetime> ExternalWorkerMap = new Map<id,Datetime>();
List<sirenum__placement__c> placeupdate = new List<sirenum__placement__c>();
List<Contact> contactupdate = new List<Contact>();
         IP_Parallel_Payroll_Check__c paycheck = IP_Parallel_Payroll_Check__c.getValues('RunParallelCheck');
List<IP_PayProfile__c> payprofileupdate = new List<IP_PayProfile__c>();

 global Database.QueryLocator start(Database.BatchableContext BC){
         string query = 'Select id,IP_OriginRecordID__c,LastModifiedDate,IP_TransferType__c from IP_OutboundDataTransfer__c where IP_Passed__c != null and LastModifiedDate>= :dt and (IP_TimesheetID__c != null OR IP_EmergencyPull__c = TRUE) and IP_TransferType__c  != \'Timesheet\'';
         return Database.getQueryLocator(query);
     }
     global void execute(Database.BatchableContext BC,List<IP_OutboundDataTransfer__c> scope){
       
         for(IP_OutboundDataTransfer__c ob: scope)
         {
             if(ob.IP_TransferType__c == 'Assignment')
             {
                AssignmentMap.put(ob.IP_OriginRecordID__c,ob.LastModifiedDate); 
             }
             if(ob.IP_TransferType__c == 'Internal Worker')             {                InternalworkerMap.put(ob.IP_OriginRecordID__c,ob.LastModifiedDate);  
             }
             if(ob.IP_TransferType__c == 'External Worker') 
             {
                ExternalWorkerMap.put(ob.IP_OriginRecordID__c,ob.LastModifiedDate); 
             }
         }
        placeupdate = [Select id,IP_LastPassedToTempest__c,IP_TimesheetIDLink__c from sirenum__placement__c where id in:AssignmentMap.keySet() and IP_TimesheetIDLink__c!=null];
        for(sirenum__placement__c p:placeupdate)
        {
            if(!paycheck.Run_Parallel_Payroll__c)
            {
            p.IP_LastPassedToTempest__c = AssignmentMap.get(p.id);
            }
            p.IP_TimesheetIDLink__c = '';
        }
        contactupdate = [Select id,IP_LastPassedToTempest2ndTier__c,IP_TimesheetIDLink__c from Contact where id in:ExternalWorkerMap.keyset() and IP_TimesheetIDLink__c!=null];
        for(Contact p:contactupdate)
        {
             if(!paycheck.Run_Parallel_Payroll__c)
             {
            p.IP_LastPassedToTempest2ndTier__c = ExternalWorkerMap.get(p.id);
            }
            p.IP_TimesheetIDLink__c = '';
        }
        payprofileupdate = [Select id,IP_LastPassedToTempest__c,IP_TimesheetIDLink__c from IP_PayProfile__c where id in:InternalworkerMap.keySet() and IP_TimesheetIDLink__c!=null];
        for(IP_PayProfile__c p:payprofileupdate)
        {             if(!paycheck.Run_Parallel_Payroll__c)             {            p.IP_LastPassedToTempest__c = InternalworkerMap.get(p.id);
            }
            p.IP_TimesheetIDLink__c = '';
        }
         
         // Placement Update
         if(placeupdate.size()>0)
         {
          Database.SaveResult[] sList = Database.update(placeupdate,false);
         List<Id> errorIds = new List<Id>();
            for (Database.SaveResult sr : sList) {
              if (sr.isSuccess()) {
                    System.debug('Successfully update Data' ); 
                }
                else {
                          for(Database.Error err : sr.getErrors()) {                            errorIds.add(sr.id);                          Errmsg.put(sr.id,err.getMessage());
                           }
                          
                     }
            }
              if(!errorIds.IsEmpty())
              {
                 for(integer i=0;i<errorIds.size();i++)
                   {
                        errorFile = errorFile + errorIds[i]+','+ Errmsg.get(errorIds[i]) + ',' +'\n';                                sendMail = true;
                    }
               }
         }
         
         //  External Update
         if(contactupdate.size()>0)
         {
          Database.SaveResult[] sList = Database.update(contactupdate,false);
         List<Id> errorIds = new List<Id>();
            for (Database.SaveResult sr : sList) {
              if (sr.isSuccess()) {
                    System.debug('Successfully update Data' ); 
                }
                else {
                          for(Database.Error err : sr.getErrors()) {                            errorIds.add(sr.id);                          Errmsg.put(sr.id,err.getMessage());
                           }
                          
                     }
            }
              if(!errorIds.IsEmpty())
              {
                 for(integer i=0;i<errorIds.size();i++)
                   {                        errorFile = errorFile + errorIds[i]+','+ Errmsg.get(errorIds[i]) + ',' +'\n';                      sendMail = true;
                    }
               }
         }
         // Internal Worker
            if(payprofileupdate.size()>0)
         {
          Database.SaveResult[] sList = Database.update(payprofileupdate,false);
         List<Id> errorIds = new List<Id>();
            for (Database.SaveResult sr : sList) {              if (sr.isSuccess()) {
                    System.debug('Successfully update Data' ); 
                }
                else {
                          for(Database.Error err : sr.getErrors()) {                            errorIds.add(sr.id);                          Errmsg.put(sr.id,err.getMessage());
                               
                           }
                          
                     }
            }
              if(!errorIds.IsEmpty())
              {
                 for(integer i=0;i<errorIds.size();i++)
                   {            errorFile = errorFile + errorIds[i]+','+ Errmsg.get(errorIds[i]) + ',' +'\n';                  sendMail = true;
                    }
               }
         }
         
         
     }
     global void finish(Database.BatchableContext BC){
          if(sendMail == true)
         {
             String emailid = IP_ImpellamGlobalSetting__c.getInstance().IP_OutboundErrorEmailAddress__c;
             Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();
                
            blob errBlob = blob.valueof(errorFile);    
            errAtt.setFileName('CloseCall Failed_Records.csv');
            errAtt.setBody(errBlob);
    
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
            String subject ='CloseCall - Outbound Transfer Failure';
            email.setSubject(subject);
           String[] toAddresses = new String[] {emailid};
            email.setToAddresses(toAddresses);
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
         }
         IP_ImpellamGlobalSetting__c imp = IP_ImpellamGlobalSetting__c.getOrgDefaults();
             Integer limit1 = Integer.valueOf(imp.IP_UnlockTimesheetBatchSize__c);
         
         Database.executeBatch(new UnLockTimesheetLines(),limit1);
        }
}