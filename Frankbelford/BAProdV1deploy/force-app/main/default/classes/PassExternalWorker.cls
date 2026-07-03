public class PassExternalWorker {
    
    public static void passexternal(SObject so)
    {
         Boolean sendMail = false;
         String errorFile = 'Id,Error\n';
         Database.SaveResult[] sList;
         Contact tl = (Contact) so;
         List<Contact> supply = [select Account.IP_SupplierReference__c from Contact where Id=:tl.id];
         List<IP_OutboundDataTransfer__c> outbound = new List<IP_OutboundDataTransfer__c>();
         Map<Id,String> Errmsg = new Map<Id,String>();
        IP_CompanyCode__c Ccode = IP_CompanyCode__c.getValues('CompanyCode'); 
      List<IP_OutboundDataTransfer__c> existoutbound = [Select id,IP_TimesheetID__c ,IP_First_Name__c,IP_Last_Name__c,IP_Mailing_Address_Line_1__c,IP_Department__c,IP_Pay_Frequency__c,IP_WTR__c,IP_National_Insurance__c,IP_Salutation__c,IP_Phone__c,IP_Mailing_PostalCode__c,IP_Mailing_State__c,IP_Mailing_Country__c,IP_Mailing_City__c,IP_CandidateIDLegacy__c,IP_Start_Date__c,IP_Tempest_Division__c,IP_Tempest_Department__c,IP_Mailing_Address_Line_2__c,IP_Mailing_Address_Line_3__c,IP_Email__c,IP_Consultants_Tempest_ID__c,IP_Birthdate__c,IP_2ndTierSupplier_Reference__c from IP_OutboundDataTransfer__c where IP_OriginRecordID__c =: tl.id and IP_TimesheetID__c =: tl.IP_TimesheetIDLink__c and IP_Passed__c = Null];
   
        List<sirenum__Timesheet__c> listtime = [Select id from sirenum__Timesheet__c where id=: tl.IP_TimesheetIDLink__c];
         
        List<IP_BranchStatus__c> branchlist = [select id from IP_BranchStatus__c where IP_BranchID__c=: tl.IP_TempestDepartment__c];
        if(branchlist.size()>0)
        {      
       for(Contact c: supply){
          if(tl.IP_Pass2ndTierToTempest__c == True && tl.IP_LastPassedToTempest2ndTier__c == Null && tl.IP_FirstPassExternalWorker__c== True && existoutbound.size()>0)
        {
            for(IP_OutboundDataTransfer__c ob : existoutbound)
            {
             if(ob.IP_TimesheetID__c == tl.IP_TimesheetIDLink__c)
                {
      //  ob.IP_OriginRecordID__c = tl.Id;
        ob.IP_2ndTierSupplier_Reference__c = c.Account.IP_SupplierReference__c;
        ob.IP_Birthdate__c = tl.Birthdate;
        ob.IP_Consultants_Tempest_ID__c = tl.IP_ConsultantsTempestID__c;
        ob.IP_Email__c = tl.Email;
        ob.IP_First_Name__c = tl.FirstName;
        ob.IP_Last_Name__c   = tl.LastName;
        ob.IP_Mailing_Address_Line_1__c = tl.IP_MailingAddressLine1__c;
        ob.IP_Mailing_Address_Line_2__c = tl.IP_MailingAddressLine2__c;
        ob.IP_Mailing_Address_Line_3__c = tl.IP_MailingAddressLine3__c;
        ob.IP_Tempest_Department__c = tl.IP_TempestDepartment__c;
        ob.IP_Tempest_Division__c = tl.IP_TempestDivision__c;
        ob.IP_Start_Date__c = tl.IP_WorkerStartDate__c;
        ob.IP_CandidateIDLegacy__c = tl.IP_CandidateIDlegacy__c;   
        ob.IP_Mailing_City__c = tl.MailingCity;
        ob.IP_Mailing_Country__c = tl.MailingCountry;       
        ob.IP_Mailing_State__c = tl.MailingState;
        ob.IP_Mailing_PostalCode__c = tl.MailingPostalCode;
        ob.IP_Phone__c = tl.Phone;
        // ob.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;
        ob.IP_Salutation__c = tl.Salutation;      
        ob.IP_National_Insurance__c = tl.Sirenum__National_Insurance__c;     
        if(tl.WTR_Completed__c == True){        ob.IP_WTR__c = 'True';}        else{ob.IP_WTR__c = 'False';}       
        ob.IP_Pay_Frequency__c = String.valueOf(tl.IP_PayFrequency__c);
        ob.IP_Department__c = tl.IP_Department__c;

            }
            }
        
        
        }
        else if(tl.IP_Pass2ndTierToTempest__c == True && ( (listtime != Null && listtime.size()>0 && tl.IP_TimesheetIDLink__c != NULL) || (tl.IP_TimesheetIDLink__c == NULL && tl.IP_LastPassedToTempest2ndTier__c  != Null)))
       {      
       
       
        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
        
        if(tl.IP_Pass2ndTierToTempest__c == True && tl.IP_LastPassedToTempest2ndTier__c  == Null && tl.IP_FirstPassExternalWorker__c == True )
        {
        system.debug('@@##');
        ob.IP_TimesheetID__c = tl.IP_TimesheetIDLink__c;}
        if(tl.IP_Pass2ndTierToTempest__c == True && tl.IP_LastPassedToTempest2ndTier__c != Null && tl.IP_FirstPassExternalWorker__c == False )
        {  ob.IP_Passed__c ='PASSING';}
        ob.IP_OriginRecordID__c = tl.Id;
        ob.IP_2ndTierSupplier_Reference__c = c.Account.IP_SupplierReference__c;
        ob.IP_Birthdate__c = tl.Birthdate;
        ob.IP_Consultants_Tempest_ID__c = tl.IP_ConsultantsTempestID__c;
        ob.IP_Email__c = tl.Email;
        ob.IP_First_Name__c = tl.FirstName;
        ob.IP_Last_Name__c   = tl.LastName;
        ob.IP_Mailing_Address_Line_1__c = tl.IP_MailingAddressLine1__c;
        ob.IP_Mailing_Address_Line_2__c = tl.IP_MailingAddressLine2__c;
        ob.IP_Mailing_Address_Line_3__c = tl.IP_MailingAddressLine3__c;
        ob.IP_Tempest_Department__c = tl.IP_TempestDepartment__c;
        ob.IP_Tempest_Division__c = tl.IP_TempestDivision__c;
        ob.IP_Start_Date__c = tl.IP_WorkerStartDate__c;
        ob.IP_CandidateIDLegacy__c = tl.IP_CandidateIDlegacy__c;   
        ob.IP_Mailing_City__c = tl.MailingCity;
        ob.IP_Mailing_Country__c = tl.MailingCountry;       
        ob.IP_Mailing_State__c = tl.MailingState;
        ob.IP_Mailing_PostalCode__c = tl.MailingPostalCode;
        ob.IP_Phone__c = tl.Phone;
        // ob.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;
        ob.IP_Salutation__c = tl.Salutation;      
        ob.IP_National_Insurance__c = tl.Sirenum__National_Insurance__c;     
        if(tl.WTR_Completed__c == True){        ob.IP_WTR__c = 'True';}        else{ob.IP_WTR__c = 'False';}       
        ob.IP_Pay_Frequency__c = String.valueOf(tl.IP_PayFrequency__c);
        ob.IP_Department__c = tl.IP_Department__c;
       
        
        
        ob.IP_TransferType__c = 'External Worker';
          outbound.add(ob);        
          }      
       }
              
    }
        if(outbound.size()>0)
        {
           sList = Database.insert(outbound,false);
           
        
          List<Id> errorIds = new List<Id>();
        for (Database.SaveResult sr : sList) {
          if (sr.isSuccess()) {
                System.debug('Successfully inserted Data' );
                 
                    
            }
            else {
                      for(Database.Error err : sr.getErrors()) { 
                     errorIds.add(tl.id);                      Errmsg.put(tl.id,err.getMessage());
                       }
                      
                 }
                 }
           if(!errorIds.IsEmpty())
              {
                 for(integer i=0;i<errorIds.size();i++)
                   {
                        errorFile = errorFile + errorIds[i]+','+ Errmsg.get(errorIds[i]) + ',' +'\n';                            sendMail = true;
                    }
               }
               else
               {
               try{
                    IP_Parallel_Payroll_Check__c parallelcheck = IP_Parallel_Payroll_Check__c.getValues('RunParallelCheck'); 
                    if(parallelcheck.Run_Parallel_Payroll__c == false)
                    {
                     tl.IP_Pass2ndTierToTempest__c = false;
                  
                    }
                     if(tl.IP_LastPassedToTempest2ndTier__c != Null && tl.IP_FirstPassExternalWorker__c == False)
                   {
                   tl.IP_LastPassedToTempest2ndTier__c = System.now();
                   }
                   else{
                   tl.IP_FirstPassExternalWorker__c = false;}
                   }
                   catch(Exception e)
                   {
                   errorFile = errorFile + tl +',' +e +','+'\n';                   sendMail = true;
                   } 
               }
                  
                
          }
          else if(existoutbound.size()>0)
        {
           sList = Database.update(existoutbound,false);
           
        
          List<Id> errorIds = new List<Id>();
        for (Database.SaveResult sr : sList) {
          if (sr.isSuccess()) {
                System.debug('Successfully updated Data' );
                 
                    
            }
            else {
                      for(Database.Error err : sr.getErrors()) { 
                     errorIds.add(sr.id);                      Errmsg.put(sr.id,err.getMessage());
                       }
                      
                 }
                 }
           if(!errorIds.IsEmpty())
              {
                 for(integer i=0;i<errorIds.size();i++)
                   {
                        errorFile = errorFile + errorIds[i]+','+ Errmsg.get(errorIds[i]) + ',' +'\n';                        
                        sendMail = true;
                    }
               }
               else
               {
               try{
                    IP_Parallel_Payroll_Check__c parallelcheck = IP_Parallel_Payroll_Check__c.getValues('RunParallelCheck'); 
                   if(parallelcheck.Run_Parallel_Payroll__c == false){
                   tl.IP_Pass2ndTierToTempest__c = false;
                    
                   }
                   tl.IP_FirstPassExternalWorker__c = false;
                   }
                   catch(Exception e)
                   {
                   errorFile = errorFile + tl +',' +e +','+'\n';                   sendMail = true;
                   } 
               }
                  
   
          }
                   
             if(existoutbound.size()>0 || outbound.size()>0 ){
          /* Send email for error Ids */
           if(sendMail == true)
        {          
              String emailid = IP_ImpellamGlobalSetting__c.getInstance().IP_OutboundErrorEmailAddress__c;
            Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();                
            blob errBlob = blob.valueof(errorFile);    
            errAtt.setFileName('Failed_Records.csv');
            errAtt.setBody(errBlob);    
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
            String subject ='Outbound Data Failure - Internal Worker';
            email.setSubject(subject);
           // String[] toAddresses = new String[]{'tajinder.singh@espire.com'};
             String[] toAddresses = new String[] {emailid};
            email.setToAddresses(toAddresses);
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            
            }    
             }
             
    }
    
    
    public static void passExternalEmergency(SObject so)
    {
         Boolean sendMail = false;
         String errorFile = 'Id,Error\n';
         boolean checkpassed = false;
         IP_Parallel_Payroll_Check__c parallelcheck = IP_Parallel_Payroll_Check__c.getValues('RunParallelCheck'); 
         IP_CompanyCode__c Ccode = IP_CompanyCode__c.getValues('CompanyCode');
         Database.SaveResult[] sList;
         List<sirenum__Timesheet__c> listtime = new List<sirenum__Timesheet__c>();
          Contact tl = (Contact) so;
         List<Contact> supply = [select Account.IP_SupplierReference__c from Contact where Id=:tl.id];
        if(tl.IP_TimesheetIDLink__c != null){
         listtime = [Select id from sirenum__Timesheet__c where id=: tl.IP_TimesheetIDLink__c];}
         
         
     List<IP_OutboundDataTransfer__c> existoutbound = [Select id,IP_EmergencyPull__c,IP_TimesheetID__c ,IP_First_Name__c,IP_Last_Name__c,IP_Mailing_Address_Line_1__c,IP_Department__c,IP_Pay_Frequency__c,IP_WTR__c,IP_National_Insurance__c,IP_Salutation__c,IP_Phone__c,IP_Mailing_PostalCode__c,IP_Mailing_State__c,IP_Mailing_Country__c,IP_Mailing_City__c,IP_CandidateIDLegacy__c,IP_Start_Date__c,IP_Tempest_Division__c,IP_Tempest_Department__c,IP_Mailing_Address_Line_2__c,IP_Mailing_Address_Line_3__c,IP_Email__c,IP_Consultants_Tempest_ID__c,IP_Birthdate__c,IP_2ndTierSupplier_Reference__c from IP_OutboundDataTransfer__c where IP_OriginRecordID__c =: tl.id and IP_TimesheetID__c =: tl.IP_TimesheetIDLink__c and IP_Passed__c = Null];
       
         List<PermissionSetAssignment> checkpermission =  [SELECT Id, PermissionSet.Name,AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :Userinfo.getUserId()]; 
                                                                
   system.debug('check permission'+checkpermission);
    if(checkpermission.size()>0)
    {
        for(PermissionSetAssignment ps:checkpermission)
        {
            if(ps.PermissionSet.Name == 'Emergency_Payroll')
            {
                checkpassed = true;
            }
        }
    }
         
         List<IP_OutboundDataTransfer__c> outbound = new List<IP_OutboundDataTransfer__c>();
         Map<Id,String> Errmsg = new Map<Id,String>();
        
        List<IP_BranchStatus__c> branchlist = [select id from IP_BranchStatus__c where IP_BranchID__c=: tl.IP_TempestDepartment__c];
        if(branchlist.size()>0)
        {
         for(Contact c: supply){
        system.debug('tl.IP_Pass2ndTierToTempest__c'+tl.IP_Pass2ndTierToTempest__c);
             system.debug('tl.IP_EmergencyPull__c'+tl.IP_EmergencyPull__c);
             system.debug('existoutbound'+existoutbound);
        if(tl.IP_Pass2ndTierToTempest__c == True && tl.IP_EmergencyPull__c == true && existoutbound.size()>0)
        {
            for(IP_OutboundDataTransfer__c ob : existoutbound)
            {
                if(ob.IP_TimesheetID__c == tl.IP_TimesheetIDLink__c)
                {
                ob.IP_EmergencyPull__c = True;
                ob.IP_2ndTierSupplier_Reference__c = c.Account.IP_SupplierReference__c;
                ob.IP_Birthdate__c = tl.Birthdate;
                ob.IP_Consultants_Tempest_ID__c = tl.IP_ConsultantsTempestID__c;
                ob.IP_Email__c = tl.Email;
                ob.IP_First_Name__c = tl.FirstName;
                ob.IP_Last_Name__c   = tl.LastName;
                ob.IP_Mailing_Address_Line_1__c = tl.IP_MailingAddressLine1__c;
                ob.IP_Mailing_Address_Line_2__c = tl.IP_MailingAddressLine2__c;
                ob.IP_Mailing_Address_Line_3__c = tl.IP_MailingAddressLine3__c;
                ob.IP_Tempest_Department__c = tl.IP_TempestDepartment__c;
                ob.IP_Tempest_Division__c = tl.IP_TempestDivision__c;
                ob.IP_Start_Date__c = tl.IP_WorkerStartDate__c;
                ob.IP_CandidateIDLegacy__c = tl.IP_CandidateIDlegacy__c;   
                ob.IP_Mailing_City__c = tl.MailingCity;
                ob.IP_Mailing_Country__c = tl.MailingCountry;       
                ob.IP_Mailing_State__c = tl.MailingState;
                ob.IP_Mailing_PostalCode__c = tl.MailingPostalCode;
                ob.IP_Phone__c = tl.Phone;
                // ob.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;
                ob.IP_Salutation__c = tl.Salutation;      
                ob.IP_National_Insurance__c = tl.Sirenum__National_Insurance__c;     
                    if(tl.WTR_Completed__c == True){        ob.IP_WTR__c = 'True';}        else{ob.IP_WTR__c = 'False';}       
                ob.IP_Pay_Frequency__c = String.valueOf(tl.IP_PayFrequency__c);
                ob.IP_Department__c = tl.IP_Department__c;
            
                 if(checkpassed == true)
                {
                    ob.IP_Passed__c = 'PASSING';
                    if(parallelcheck.Run_Parallel_Payroll__c == false)
                    {
                        tl.IP_LastPassedToTempest2ndTier__c = System.now();
                    }
                }
            
                ob.IP_TransferType__c = 'External Worker';
                }   
            }
            
        }
        else if(tl.IP_Pass2ndTierToTempest__c == True && tl.IP_EmergencyPull__c == True)
        {
         IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
         ob.IP_EmergencyPull__c = True;
                ob.IP_OriginRecordID__c = tl.Id;
                ob.IP_2ndTierSupplier_Reference__c = c.Account.IP_SupplierReference__c;
                ob.IP_Birthdate__c = tl.Birthdate;
                ob.IP_Consultants_Tempest_ID__c = tl.IP_ConsultantsTempestID__c;
                ob.IP_Email__c = tl.Email;
                ob.IP_First_Name__c = tl.FirstName;
                ob.IP_Last_Name__c   = tl.LastName;
                ob.IP_Mailing_Address_Line_1__c = tl.IP_MailingAddressLine1__c;
                ob.IP_Mailing_Address_Line_2__c = tl.IP_MailingAddressLine2__c;
                ob.IP_Mailing_Address_Line_3__c = tl.IP_MailingAddressLine3__c;
                ob.IP_Tempest_Department__c = tl.IP_TempestDepartment__c;
                ob.IP_Tempest_Division__c = tl.IP_TempestDivision__c;
                ob.IP_Start_Date__c = tl.IP_WorkerStartDate__c;
                ob.IP_CandidateIDLegacy__c = tl.IP_CandidateIDlegacy__c;   
                ob.IP_Mailing_City__c = tl.MailingCity;
                ob.IP_Mailing_Country__c = tl.MailingCountry;       
                ob.IP_Mailing_State__c = tl.MailingState;
                ob.IP_Mailing_PostalCode__c = tl.MailingPostalCode;
                ob.IP_Phone__c = tl.Phone;
                // ob.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;
                ob.IP_Salutation__c = tl.Salutation;      
                ob.IP_National_Insurance__c = tl.Sirenum__National_Insurance__c;     
                if(tl.WTR_Completed__c == True){        ob.IP_WTR__c = 'True';}        else{ob.IP_WTR__c = 'False';}       
                ob.IP_Pay_Frequency__c = String.valueOf(tl.IP_PayFrequency__c);
                ob.IP_Department__c = tl.IP_Department__c;
                if(checkpassed == true)
                {
                    ob.IP_Passed__c = 'PASSING';
                    if(parallelcheck.Run_Parallel_Payroll__c == false)
                    {
                        tl.IP_LastPassedToTempest2ndTier__c = System.now();
                    }
                }
        
                ob.IP_TransferType__c = 'External Worker';
                outbound.add(ob);        
        
          
        
        }
        }    
    }
        if(outbound.size()>0)
        {
           sList = Database.insert(outbound,false);
           
        
          List<Id> errorIds = new List<Id>();
        for (Database.SaveResult sr : sList) {
          if (sr.isSuccess()) {
                System.debug('Successfully inserted Data' );
                 
                    
            }
            else {
                      for(Database.Error err : sr.getErrors()) {                       errorIds.add(tl.id);                      Errmsg.put(tl.id,err.getMessage());
                       }
                      
                 }
        }
           if(!errorIds.IsEmpty())
              {
                 for(integer i=0;i<errorIds.size();i++)
                   {
                        errorFile = errorFile + errorIds[i]+','+ Errmsg.get(errorIds[i]) + ',' +'\n';                        
                        sendMail = true;
                    }
               }
               else
               {
               try{
                   
                    if(parallelcheck.Run_Parallel_Payroll__c == false)
                    {
                     tl.IP_Pass2ndTierToTempest__c = false;
                     tl.IP_EmergencyPull__c = false;
                  
                    }
                    if(tl.IP_FirstPassExternalWorker__c == true)
                    {
                        tl.IP_FirstPassExternalWorker__c = false;
                    }
                     if(tl.IP_LastPassedToTempest2ndTier__c != Null)
                   {
                        tl.IP_LastPassedToTempest2ndTier__c = System.now();
                   }
                
                  
                    
                   }
                   catch(Exception e)
                   {
                   errorFile = errorFile + tl +',' +e +','+'\n';                   sendMail = true;
                   } 
               }
                  
          
           
          /* Send email for error Ids */
          
          }
          else if(existoutbound.size()>0)
          {
        sList = Database.update(existoutbound,false);
            
           
        
          List<Id> errorIds = new List<Id>();
        for (Database.SaveResult sr : sList) {
          if (sr.isSuccess()) {
                System.debug('Successfully updated Data' );
                 
                    
            }
            else {
                      for(Database.Error err : sr.getErrors()) { 
                      errorIds.add(sr.id);
                      Errmsg.put(sr.id,err.getMessage());
                       }
                      
                 }
                 }
           if(!errorIds.IsEmpty())
              {
                 for(integer i=0;i<errorIds.size();i++)
                   {
                        errorFile = errorFile + errorIds[i]+','+ Errmsg.get(errorIds[i]) + ',' +'\n';                        
                        sendMail = true;
                    }
               }
               else
               {
               try{
                    if(parallelcheck.Run_Parallel_Payroll__c == false)
                    {
                       tl.IP_Pass2ndTierToTempest__c = false;
                       tl.IP_EmergencyPull__c = false;
                    }
                    if(tl.IP_FirstPassExternalWorker__c == true)
                    {
                        tl.IP_FirstPassExternalWorker__c = false;
                    }
                  
                   }
                   catch(Exception e)
                   {
                   errorFile = errorFile + tl +',' +e +','+'\n';                   sendMail = true;
                   } 
               }
                  
          
           
       
          }
          
          if(existoutbound.size()>0 || outbound.size()>0 ){
              
                      /* Send email for error Ids */
           if(sendMail == true)
        {    
             String emailid = IP_ImpellamGlobalSetting__c.getInstance().IP_OutboundErrorEmailAddress__c;
            Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();                
            blob errBlob = blob.valueof(errorFile);    
            errAtt.setFileName('Failed_Records.csv');
            errAtt.setBody(errBlob);    
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
            String subject ='Outbound Data Failure - Internal Worker';
            email.setSubject(subject);
              String[] toAddresses = new String[] {emailid};
            email.setToAddresses(toAddresses);
           // String[] toAddresses = new String[]{'tajinder.singh@espire.com'};
            email.setToAddresses(toAddresses);
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            
            }  
              
          }
      
             
    }

}