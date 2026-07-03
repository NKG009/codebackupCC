public class PassInternalWorker {
    
    
    public static void passpayroll(SObject so,string branchcode)
    {
      IP_CompanyCode__c Ccode = IP_CompanyCode__c.getValues('CompanyCode');
         Boolean sendMail = false;
         String errorFile = 'Id,Error\n';
         String recordname = '';
         Database.SaveResult[] sList;
         List<sirenum__Timesheet__c> listtime = new List<sirenum__Timesheet__c>();
         IP_PayProfile__c tl = (IP_PayProfile__c) so;
         List<IP_PayProfile__c> tllist = [select id,IP_LastPassedToTempest__c,IP_EmergencyPull__c ,IP_FirstPass__c ,IP_TimesheetIDLink__c,IP_PassToTempest__c,RecordType.Name,IP_Candidate__r.WTR_Completed__c,IP_Candidate__r.MailingCountry,IP_Candidate__r.IP_Department__c,IP_Candidate__r.IP_Nationality__c,IP_Candidate__c,IP_Candidate__r.Suppression_Code__c,IP_Candidate__r.TS2__Preferred_Name__c,IP_Candidate__r.Student__c,IP_Candidate__r.Sirenum__National_Insurance__c,IP_Candidate__r.ts2__EEO_Gender__c,IP_Candidate__r.Salutation,IP_Candidate__r.Phone,IP_Candidate__r.MailingPostalCode,IP_Candidate__r.MailingState,IP_Candidate__r.MailingCity,IP_Candidate__r.Lastname,IP_Candidate__r.IP_WorkerStartDate__c,IP_Candidate__r.IP_TempestDivision__c,IP_Candidate__r.IP_TempestDepartment__c,IP_Candidate__r.IP_MailingAddressLine3__c,IP_Candidate__r.IP_MailingAddressLine2__c,IP_Candidate__r.IP_MailingAddressLine1__c,IP_Candidate__r.Firstname,IP_Candidate__r.Birthdate,IP_Candidate__r.IP_ConsultantsTempestID__c,IP_Candidate__r.Email from IP_PayProfile__c where id =: tl.id];
         if(tl.IP_TimesheetIDLink__c != null){
         listtime = [Select id from sirenum__Timesheet__c where id=: tl.IP_TimesheetIDLink__c];}
         
         
         List<IP_OutboundDataTransfer__c> existoutbound = [Select id,IP_TimesheetID__c,IP_Passed__c,IP_Student__c,IP_Preferred_Name__c,IP_WTR__c,IP_Suppression_Code__c,IP_Candidate__c,IP_Nationality__c,IP_Company_Name__c,IP_Company_Registration_No__c,
        IP_Email_Payslip__c,IP_Payment_Type__c,IP_Payroll_ID__c,IP_Sort_Code__c,IP_VAT_Number__c,IP_Contact_Record_Type__c,IP_Pay_Frequency__c,IP_Department__c,IP_Status__c,IP_Payroll_Leaver__c,IP_Leaver__c,IP_Supplier_Reference__c,IP_Student_Loan__c,IP_TransferType__c,IP_Mailing_State__c,IP_Mailing_PostalCode__c,IP_Phone__c,IP_Salutation__c,IP_EEO_Gender__c,IP_National_Insurance__c,IP_Mailing_Country__c,IP_Mailing_City__c,IP_Last_Name__c,IP_Leaver_Requested_Date__c,IP_Start_Date__c,IP_Tempest_Division__c,IP_Tempest_Department__c,IP_New_Starter_Tax_Status__c,IP_Mailing_Address_Line_3__c,IP_Mailing_Address_Line_2__c,IP_Mailing_Address_Line_1__c,IP_First_Name__c,IP_Email__c,IP_Consultants_Tempest_ID__c,IP_Birthdate__c,IP_Business_Address_Town__c,IP_Business_Address_Postcode__c,IP_Business_Address_Line_2__c,IP_Business_Address_Line_1__c,IP_Business_Address_County__c,IP_Building_Society_Roll_No__c,IP_Account_Number__c,IP_Account_Name__c,IP_OriginRecordID__c from IP_OutboundDataTransfer__c where IP_OriginRecordID__c =: tl.id and IP_TimesheetID__c =: tl.IP_TimesheetIDLink__c and IP_Passed__c = Null];
         
         List<IP_OutboundDataTransfer__c> outbound = new List<IP_OutboundDataTransfer__c>();
         Map<Id,String> Errmsg = new Map<Id,String>();
        
        List<IP_BranchStatus__c> branchlist = [select id from IP_BranchStatus__c where IP_BranchID__c=: branchcode];
        if(branchlist.size()>0)
        {
        for(IP_PayProfile__c tl2: tllist ){
            recordname = tl2.RecordType.Name;
        
        if(tl.IP_PassToTempest__c == True && tl.IP_LastPassedToTempest__c == Null && tl.IP_FirstPass__c == True && existoutbound.size()>0 && tl.IP_EmergencyPull__c == false)
        {
            for(IP_OutboundDataTransfer__c ob : existoutbound)
            {
                if(ob.IP_TimesheetID__c == tl.IP_TimesheetIDLink__c)
                {
                ob.IP_OriginRecordID__c = tl.Id;
        //ob.IP_TimesheetID__c = tl.IP_TimesheetIDLink__c;
        ob.IP_Account_Name__c = tl.IP_BankAccountName__c;
        ob.IP_Account_Number__c = tl.IP_AccountNumber__c;
        ob.IP_Building_Society_Roll_No__c = tl.IP_BuildingSocietyNumber__c;
        ob.IP_Business_Address_County__c = tl.IP_BusinessAddressCounty__c;
        ob.IP_Business_Address_Line_1__c = tl.IP_BusinessAddressLine1__c;
        ob.IP_Business_Address_Line_2__c = tl.IP_BusinessAddressLine2__c;
        ob.IP_Business_Address_Postcode__c = tl.IP_BusinessAddressPostcode__c;
        ob.IP_Business_Address_Town__c = tl.IP_BusinessAddressTown__c;
        ob.IP_Birthdate__c = tl2.IP_Candidate__r.Birthdate;
        ob.IP_Consultants_Tempest_ID__c = tl2.IP_Candidate__r.IP_ConsultantsTempestID__c;
        ob.IP_Email__c = tl2.IP_Candidate__r.Email;
        ob.IP_First_Name__c = tl2.IP_Candidate__r.Firstname;
        ob.IP_Mailing_Address_Line_1__c = tl2.IP_Candidate__r.IP_MailingAddressLine1__c;
        ob.IP_Mailing_Address_Line_2__c = tl2.IP_Candidate__r.IP_MailingAddressLine2__c;
        ob.IP_Mailing_Address_Line_3__c = tl2.IP_Candidate__r.IP_MailingAddressLine3__c;
        ob.IP_New_Starter_Tax_Status__c = tl.IP_NewStarterTaxStatus__c;
        ob.IP_Tempest_Department__c = branchcode;
        ob.IP_Tempest_Division__c = tl2.IP_Candidate__r.IP_TempestDivision__c;
        ob.IP_Start_Date__c = tl2.IP_Candidate__r.IP_WorkerStartDate__c;
        ob.IP_Leaver_Requested_Date__c = tl.Date_P45_Requested__c;
        ob.IP_Last_Name__c = tl2.IP_Candidate__r.Lastname;
        ob.IP_Mailing_City__c = tl2.IP_Candidate__r.MailingCity;
        ob.IP_Mailing_Country__c = tl2.IP_Candidate__r.MailingCountry;       
        ob.IP_Mailing_State__c = tl2.IP_Candidate__r.MailingState;
        ob.IP_Mailing_PostalCode__c = tl2.IP_Candidate__r.MailingPostalCode;
        ob.IP_Phone__c = tl2.IP_Candidate__r.Phone;
        ob.IP_Salutation__c = tl2.IP_Candidate__r.Salutation;
        ob.IP_EEO_Gender__c = tl2.IP_Candidate__r.ts2__EEO_Gender__c;       
        ob.IP_National_Insurance__c = tl2.IP_Candidate__r.Sirenum__National_Insurance__c;
       // ob.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;
        if(tl2.IP_Candidate__r.Student__c == True){        ob.IP_Student__c = 'True';}
        else{ob.IP_Student__c = 'False';}
        
        
        ob.IP_Preferred_Name__c = tl2.IP_Candidate__r.TS2__Preferred_Name__c;
        if(tl2.IP_Candidate__r.WTR_Completed__c == True){        ob.IP_WTR__c = 'True';}
        else{ob.IP_WTR__c = 'False';}
        ob.IP_Suppression_Code__c = String.ValueOf(tl2.IP_Candidate__r.Suppression_Code__c);       
        ob.IP_Candidate__c = tl.IP_Candidate__c;
        ob.IP_Nationality__c = tl2.IP_Candidate__r.IP_Nationality__c;
        ob.IP_Company_Name__c = tl.IP_CompanyName__c;
        ob.IP_Company_Registration_No__c = tl.IP_CompanyRegNo__c;
     
        if(tl.IP_EmailPayslip__c == True){        ob.IP_Email_Payslip__c = 'True';}
        else{ob.IP_Email_Payslip__c = 'False';}
        ob.IP_Payment_Type__c = tl.IP_PaymentType__c;
        ob.IP_Payroll_ID__c = tl.IP_PayrollID__c;
        ob.IP_Sort_Code__c = tl.IP_SortCode__c;
        ob.IP_VAT_Number__c = tl.IP_VATNumber__c;
        ob.IP_Contact_Record_Type__c = tl2.RecordType.Name;
        ob.IP_Pay_Frequency__c = tl.IP_PayFrequency__c;
        //ob.IP_Department__c = st.IP_Department__c; - JIRA - 2459
         IP_Shift_Template__c shiftcode = IP_Shift_Template__c.getValues(branchcode);
        if(shiftcode != NULL){
        ob.IP_Department__c = shiftcode.IP_Site_Name__c;}
        ob.IP_Status__c = tl.IP_Status__c;
          if(tl2.RecordType.Name == 'PAYE' && tl.IP_Status__c == 'Active' && tl.P45_Requested__c  && tl.IP_Payroll_Leaver__c==null)
                {
                ob.IP_Payroll_Leaver__c= 'PL';
                }
       
       // ob.IP_Payroll_Leaver__c = tl.IP_Payroll_Leaver__c;
        if(tl.P45_Requested__c == True){        ob.IP_Leaver__c = 'True';}
        else{ob.IP_Leaver__c = 'False';}
        ob.IP_Supplier_Reference__c = tl.IP_SupplierReference__c;
        ob.IP_Student_Loan__c = tl.IP_StudentLoan__c;
        
        
        ob.IP_TransferType__c = 'Internal Worker';
            }
            }
            
        }
        else if(tl.IP_PassToTempest__c == True && tl.IP_EmergencyPull__c == false && ( (listtime != Null && listtime.size()>0 && tl.IP_TimesheetIDLink__c != NULL) || (tl.IP_TimesheetIDLink__c == NULL && tl.IP_LastPassedToTempest__c != Null)))
        {
        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
        ob.IP_OriginRecordID__c = tl.Id;
        if(tl.IP_PassToTempest__c == True && tl.IP_LastPassedToTempest__c == Null && tl.IP_FirstPass__c == True )
        {
        system.debug('@@##');
        ob.IP_TimesheetID__c = tl.IP_TimesheetIDLink__c;}
        if(tl.IP_PassToTempest__c == True && tl.IP_LastPassedToTempest__c != Null && tl.IP_FirstPass__c == False && tl.IP_EmergencyPull__c == false)
        {  ob.IP_Passed__c ='PASSING';}
        ob.IP_Account_Name__c = tl.IP_BankAccountName__c;
        ob.IP_Account_Number__c = tl.IP_AccountNumber__c;
        ob.IP_Building_Society_Roll_No__c = tl.IP_BuildingSocietyNumber__c;
        ob.IP_Business_Address_County__c = tl.IP_BusinessAddressCounty__c;
        ob.IP_Business_Address_Line_1__c = tl.IP_BusinessAddressLine1__c;
        ob.IP_Business_Address_Line_2__c = tl.IP_BusinessAddressLine2__c;
        ob.IP_Business_Address_Postcode__c = tl.IP_BusinessAddressPostcode__c;
        ob.IP_Business_Address_Town__c = tl.IP_BusinessAddressTown__c;
        ob.IP_Birthdate__c = tl2.IP_Candidate__r.Birthdate;
        ob.IP_Consultants_Tempest_ID__c = tl2.IP_Candidate__r.IP_ConsultantsTempestID__c;
        ob.IP_Email__c = tl2.IP_Candidate__r.Email;
        ob.IP_First_Name__c = tl2.IP_Candidate__r.Firstname;
        ob.IP_Mailing_Address_Line_1__c = tl2.IP_Candidate__r.IP_MailingAddressLine1__c;
        ob.IP_Mailing_Address_Line_2__c = tl2.IP_Candidate__r.IP_MailingAddressLine2__c;
        ob.IP_Mailing_Address_Line_3__c = tl2.IP_Candidate__r.IP_MailingAddressLine3__c;
        ob.IP_New_Starter_Tax_Status__c = tl.IP_NewStarterTaxStatus__c;
        ob.IP_Tempest_Department__c = branchcode;
        ob.IP_Tempest_Division__c = tl2.IP_Candidate__r.IP_TempestDivision__c;
        ob.IP_Start_Date__c = tl2.IP_Candidate__r.IP_WorkerStartDate__c;
        ob.IP_Leaver_Requested_Date__c = tl.Date_P45_Requested__c;
        ob.IP_Last_Name__c = tl2.IP_Candidate__r.Lastname;
        ob.IP_Mailing_City__c = tl2.IP_Candidate__r.MailingCity;
        ob.IP_Mailing_Country__c = tl2.IP_Candidate__r.MailingCountry;       
        ob.IP_Mailing_State__c = tl2.IP_Candidate__r.MailingState;
        ob.IP_Mailing_PostalCode__c = tl2.IP_Candidate__r.MailingPostalCode;
        ob.IP_Phone__c = tl2.IP_Candidate__r.Phone;
        ob.IP_Salutation__c = tl2.IP_Candidate__r.Salutation;
        ob.IP_EEO_Gender__c = tl2.IP_Candidate__r.ts2__EEO_Gender__c;       
        ob.IP_National_Insurance__c = tl2.IP_Candidate__r.Sirenum__National_Insurance__c;
       // ob.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;
        if(tl2.IP_Candidate__r.Student__c == True){        ob.IP_Student__c = 'True';}
        else{ob.IP_Student__c = 'False';}
        
        
        ob.IP_Preferred_Name__c = tl2.IP_Candidate__r.TS2__Preferred_Name__c;
        if(tl2.IP_Candidate__r.WTR_Completed__c == True){        ob.IP_WTR__c = 'True';}
        else{ob.IP_WTR__c = 'False';}
        ob.IP_Suppression_Code__c = String.ValueOf(tl2.IP_Candidate__r.Suppression_Code__c);       
        ob.IP_Candidate__c = tl.IP_Candidate__c;
        ob.IP_Nationality__c = tl2.IP_Candidate__r.IP_Nationality__c;
        ob.IP_Company_Name__c = tl.IP_CompanyName__c;
        ob.IP_Company_Registration_No__c = tl.IP_CompanyRegNo__c;
     
        if(tl.IP_EmailPayslip__c == True){        ob.IP_Email_Payslip__c = 'True';}
        else{ob.IP_Email_Payslip__c = 'False';}
        ob.IP_Payment_Type__c = tl.IP_PaymentType__c;
        ob.IP_Payroll_ID__c = tl.IP_PayrollID__c;
        ob.IP_Sort_Code__c = tl.IP_SortCode__c;
        ob.IP_VAT_Number__c = tl.IP_VATNumber__c;
        ob.IP_Contact_Record_Type__c = tl2.RecordType.Name;
        ob.IP_Pay_Frequency__c = tl.IP_PayFrequency__c;
         //ob.IP_Department__c = st.IP_Department__c; - JIRA - 2459
         IP_Shift_Template__c shiftcode = IP_Shift_Template__c.getValues(branchcode);
        if(shiftcode != NULL){
        ob.IP_Department__c = shiftcode.IP_Site_Name__c;}
        ob.IP_Status__c = tl.IP_Status__c;
           if(tl2.RecordType.Name == 'PAYE' && tl.IP_Status__c == 'Active' && tl.P45_Requested__c  && tl.IP_Payroll_Leaver__c==null)
                {
                ob.IP_Payroll_Leaver__c= 'PL';
                }
        //ob.IP_Payroll_Leaver__c = tl.IP_Payroll_Leaver__c;
        if(tl.P45_Requested__c == True){
        ob.IP_Leaver__c = 'True';}
        else{ob.IP_Leaver__c = 'False';}
        ob.IP_Supplier_Reference__c = tl.IP_SupplierReference__c;
        ob.IP_Student_Loan__c = tl.IP_StudentLoan__c;
       
        
        ob.IP_TransferType__c = 'Internal Worker';
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
                    IP_Parallel_Payroll_Check__c parallelcheck = IP_Parallel_Payroll_Check__c.getValues('RunParallelCheck'); 
                   
                    if(parallelcheck.Run_Parallel_Payroll__c == false)
                    {
                       
                    if(recordname == 'PAYE' && tl.IP_Status__c == 'Active' && tl.P45_Requested__c  && tl.IP_Payroll_Leaver__c==null)
                            {
                            tl.IP_Payroll_Leaver__c= 'PL';
                            }
                     tl.IP_PassToTempest__c = false;
                  
                    }
                     if(tl.IP_LastPassedToTempest__c != Null && tl.IP_FirstPass__c == False)
                   {
                   tl.IP_LastPassedToTempest__c = System.now();
                   }
                   else{
                   tl.IP_FirstPass__c = false;}
                  
                    
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
                    IP_Parallel_Payroll_Check__c parallelcheck = IP_Parallel_Payroll_Check__c.getValues('RunParallelCheck'); 
                    if(parallelcheck.Run_Parallel_Payroll__c == false)
                    {
                    if(recordname == 'PAYE' && tl.IP_Status__c == 'Active' && tl.P45_Requested__c  && tl.IP_Payroll_Leaver__c==null)
                            {
                            tl.IP_Payroll_Leaver__c= 'PL';
                            }
                   tl.IP_PassToTempest__c = false;
                  
                    }
                     tl.IP_FirstPass__c = false;
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
              String[] toAddresses = new String[] {emailid,System.Label.BASupportEmail};// 'jyothi.hale@impellam.com', 'martin.jones@impellam.com'};
            email.setToAddresses(toAddresses);
           // String[] toAddresses = new String[]{'tajinder.singh@espire.com'};
            email.setToAddresses(toAddresses);
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            
            }  
              
          }
      
             
    }
    
    
    public static void passEmergency(SObject so,string branchcode)
    {
      IP_CompanyCode__c Ccode = IP_CompanyCode__c.getValues('CompanyCode');
         Boolean sendMail = false;
         String errorFile = 'Id,Error\n';
         boolean checkpassed = false;
         String recordname1 = '';
         IP_Parallel_Payroll_Check__c parallelcheck = IP_Parallel_Payroll_Check__c.getValues('RunParallelCheck'); 

         Database.SaveResult[] sList;
         List<sirenum__Timesheet__c> listtime = new List<sirenum__Timesheet__c>();
         IP_PayProfile__c tl = (IP_PayProfile__c) so;
         List<IP_PayProfile__c> tllist = [select id,IP_LastPassedToTempest__c,IP_FirstPass__c ,IP_TimesheetIDLink__c,IP_PassToTempest__c,RecordType.Name,IP_Candidate__r.WTR_Completed__c,IP_Candidate__r.MailingCountry,IP_Candidate__r.IP_Department__c,IP_Candidate__r.IP_Nationality__c,IP_Candidate__c,IP_Candidate__r.Suppression_Code__c,IP_Candidate__r.TS2__Preferred_Name__c,IP_Candidate__r.Student__c,IP_Candidate__r.Sirenum__National_Insurance__c,IP_Candidate__r.ts2__EEO_Gender__c,IP_Candidate__r.Salutation,IP_Candidate__r.Phone,IP_Candidate__r.MailingPostalCode,IP_Candidate__r.MailingState,IP_Candidate__r.MailingCity,IP_Candidate__r.Lastname,IP_Candidate__r.IP_WorkerStartDate__c,IP_Candidate__r.IP_TempestDivision__c,IP_Candidate__r.IP_TempestDepartment__c,IP_Candidate__r.IP_MailingAddressLine3__c,IP_Candidate__r.IP_MailingAddressLine2__c,IP_Candidate__r.IP_MailingAddressLine1__c,IP_Candidate__r.Firstname,IP_Candidate__r.Birthdate,IP_Candidate__r.IP_ConsultantsTempestID__c,IP_Candidate__r.Email from IP_PayProfile__c where id =: tl.id];
         if(tl.IP_TimesheetIDLink__c != null){
         listtime = [Select id from sirenum__Timesheet__c where id=: tl.IP_TimesheetIDLink__c];}
         
         
         List<IP_OutboundDataTransfer__c> existoutbound = [Select id,IP_EmergencyPull__c,IP_TimesheetID__c,IP_Passed__c,IP_Student__c,IP_Preferred_Name__c,IP_WTR__c,IP_Suppression_Code__c,IP_Candidate__c,IP_Nationality__c,IP_Company_Name__c,IP_Company_Registration_No__c,
        IP_Email_Payslip__c,IP_Payment_Type__c,IP_Payroll_ID__c,IP_Sort_Code__c,IP_VAT_Number__c,IP_Contact_Record_Type__c,IP_Pay_Frequency__c,IP_Department__c,IP_Status__c,IP_Payroll_Leaver__c,IP_Leaver__c,IP_Supplier_Reference__c,IP_Student_Loan__c,IP_TransferType__c,IP_Mailing_State__c,IP_Mailing_PostalCode__c,IP_Phone__c,IP_Salutation__c,IP_EEO_Gender__c,IP_National_Insurance__c,IP_Mailing_Country__c,IP_Mailing_City__c,IP_Last_Name__c,IP_Leaver_Requested_Date__c,IP_Start_Date__c,IP_Tempest_Division__c,IP_Tempest_Department__c,IP_New_Starter_Tax_Status__c,IP_Mailing_Address_Line_3__c,IP_Mailing_Address_Line_2__c,IP_Mailing_Address_Line_1__c,IP_First_Name__c,IP_Email__c,IP_Consultants_Tempest_ID__c,IP_Birthdate__c,IP_Business_Address_Town__c,IP_Business_Address_Postcode__c,IP_Business_Address_Line_2__c,IP_Business_Address_Line_1__c,IP_Business_Address_County__c,IP_Building_Society_Roll_No__c,IP_Account_Number__c,IP_Account_Name__c,IP_OriginRecordID__c from IP_OutboundDataTransfer__c where IP_OriginRecordID__c =: tl.id and IP_Passed__c = Null ];
        
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
        
        List<IP_BranchStatus__c> branchlist = [select id from IP_BranchStatus__c where IP_BranchID__c=: branchcode];
        if(branchlist.size()>0)
        {
        for(IP_PayProfile__c tl2: tllist ){
        recordname1 = tl2.recordtype.name;
        if(tl.IP_PassToTempest__c == True && tl.IP_EmergencyPull__c == true && existoutbound.size()>0)
        {
            for(IP_OutboundDataTransfer__c ob : existoutbound)
            {
                if(ob.IP_TimesheetID__c == tl.IP_TimesheetIDLink__c)
                {
                ob.IP_OriginRecordID__c = tl.Id;
        ob.IP_EmergencyPull__c= tl.IP_EmergencyPull__c;
        ob.IP_Account_Name__c = tl.IP_BankAccountName__c;
        ob.IP_Account_Number__c = tl.IP_AccountNumber__c;
        ob.IP_Building_Society_Roll_No__c = tl.IP_BuildingSocietyNumber__c;
        ob.IP_Business_Address_County__c = tl.IP_BusinessAddressCounty__c;
        ob.IP_Business_Address_Line_1__c = tl.IP_BusinessAddressLine1__c;
        ob.IP_Business_Address_Line_2__c = tl.IP_BusinessAddressLine2__c;
        ob.IP_Business_Address_Postcode__c = tl.IP_BusinessAddressPostcode__c;
        ob.IP_Business_Address_Town__c = tl.IP_BusinessAddressTown__c;
        ob.IP_Birthdate__c = tl2.IP_Candidate__r.Birthdate;
        ob.IP_Consultants_Tempest_ID__c = tl2.IP_Candidate__r.IP_ConsultantsTempestID__c;
        ob.IP_Email__c = tl2.IP_Candidate__r.Email;
        ob.IP_First_Name__c = tl2.IP_Candidate__r.Firstname;
        ob.IP_Mailing_Address_Line_1__c = tl2.IP_Candidate__r.IP_MailingAddressLine1__c;
        ob.IP_Mailing_Address_Line_2__c = tl2.IP_Candidate__r.IP_MailingAddressLine2__c;
        ob.IP_Mailing_Address_Line_3__c = tl2.IP_Candidate__r.IP_MailingAddressLine3__c;
        ob.IP_New_Starter_Tax_Status__c = tl.IP_NewStarterTaxStatus__c;
        ob.IP_Tempest_Department__c = branchcode;
        ob.IP_Tempest_Division__c = tl2.IP_Candidate__r.IP_TempestDivision__c;
        ob.IP_Start_Date__c = tl2.IP_Candidate__r.IP_WorkerStartDate__c;
        ob.IP_Leaver_Requested_Date__c = tl.Date_P45_Requested__c;
        ob.IP_Last_Name__c = tl2.IP_Candidate__r.Lastname;
        ob.IP_Mailing_City__c = tl2.IP_Candidate__r.MailingCity;
        ob.IP_Mailing_Country__c = tl2.IP_Candidate__r.MailingCountry;       
        ob.IP_Mailing_State__c = tl2.IP_Candidate__r.MailingState;
        ob.IP_Mailing_PostalCode__c = tl2.IP_Candidate__r.MailingPostalCode;
        ob.IP_Phone__c = tl2.IP_Candidate__r.Phone;
        ob.IP_Salutation__c = tl2.IP_Candidate__r.Salutation;
        ob.IP_EEO_Gender__c = tl2.IP_Candidate__r.ts2__EEO_Gender__c;       
        ob.IP_National_Insurance__c = tl2.IP_Candidate__r.Sirenum__National_Insurance__c;
      
        if(tl2.IP_Candidate__r.Student__c == True){        ob.IP_Student__c = 'True';}
        else{ob.IP_Student__c = 'False';}
        
         // ob.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;
        ob.IP_Preferred_Name__c = tl2.IP_Candidate__r.TS2__Preferred_Name__c;
        if(tl2.IP_Candidate__r.WTR_Completed__c == True){        ob.IP_WTR__c = 'True';}
        else{ob.IP_WTR__c = 'False';}
        ob.IP_Suppression_Code__c = String.ValueOf(tl2.IP_Candidate__r.Suppression_Code__c);       
        ob.IP_Candidate__c = tl.IP_Candidate__c;
        ob.IP_Nationality__c = tl2.IP_Candidate__r.IP_Nationality__c;
        ob.IP_Company_Name__c = tl.IP_CompanyName__c;
        ob.IP_Company_Registration_No__c = tl.IP_CompanyRegNo__c;
     
        if(tl.IP_EmailPayslip__c == True){        ob.IP_Email_Payslip__c = 'True';}
        else{ob.IP_Email_Payslip__c = 'False';}
        ob.IP_Payment_Type__c = tl.IP_PaymentType__c;
        ob.IP_Payroll_ID__c = tl.IP_PayrollID__c;
        ob.IP_Sort_Code__c = tl.IP_SortCode__c;
        ob.IP_VAT_Number__c = tl.IP_VATNumber__c;
        ob.IP_Contact_Record_Type__c = tl2.RecordType.Name;
        ob.IP_Pay_Frequency__c = tl.IP_PayFrequency__c;
          //ob.IP_Department__c = st.IP_Department__c; - JIRA - 2459
         IP_Shift_Template__c shiftcode = IP_Shift_Template__c.getValues(branchcode);
        if(shiftcode != NULL){
        ob.IP_Department__c = shiftcode.IP_Site_Name__c;}
        ob.IP_Status__c = tl.IP_Status__c;
        ob.IP_Payroll_Leaver__c = tl.IP_Payroll_Leaver__c;
        if(tl.P45_Requested__c == True){        ob.IP_Leaver__c = 'True';}
        else{ob.IP_Leaver__c = 'False';}
        ob.IP_Supplier_Reference__c = tl.IP_SupplierReference__c;
        ob.IP_Student_Loan__c = tl.IP_StudentLoan__c;
         if(checkpassed == true)
        {
            ob.IP_Passed__c = 'PASSING';
            if(parallelcheck.Run_Parallel_Payroll__c == false)
            {
                tl.IP_LastPassedToTempest__c = System.now();
            }
        }
        
        ob.IP_TransferType__c = 'Internal Worker';
            }
            }
            
        }
        else if(tl.IP_PassToTempest__c == True && tl.IP_EmergencyPull__c == True)
        {
        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
        ob.IP_OriginRecordID__c = tl.Id;
        ob.IP_TimesheetID__c = tl.IP_TimesheetIDLink__c;     
        ob.IP_EmergencyPull__c= tl.IP_EmergencyPull__c;
        ob.IP_Account_Name__c = tl.IP_BankAccountName__c;
        ob.IP_Account_Number__c = tl.IP_AccountNumber__c;
        ob.IP_Building_Society_Roll_No__c = tl.IP_BuildingSocietyNumber__c;
        ob.IP_Business_Address_County__c = tl.IP_BusinessAddressCounty__c;
        ob.IP_Business_Address_Line_1__c = tl.IP_BusinessAddressLine1__c;
        ob.IP_Business_Address_Line_2__c = tl.IP_BusinessAddressLine2__c;
        ob.IP_Business_Address_Postcode__c = tl.IP_BusinessAddressPostcode__c;
        ob.IP_Business_Address_Town__c = tl.IP_BusinessAddressTown__c;
        ob.IP_Birthdate__c = tl2.IP_Candidate__r.Birthdate;
        ob.IP_Consultants_Tempest_ID__c = tl2.IP_Candidate__r.IP_ConsultantsTempestID__c;
        ob.IP_Email__c = tl2.IP_Candidate__r.Email;
        ob.IP_First_Name__c = tl2.IP_Candidate__r.Firstname;
        ob.IP_Mailing_Address_Line_1__c = tl2.IP_Candidate__r.IP_MailingAddressLine1__c;
        ob.IP_Mailing_Address_Line_2__c = tl2.IP_Candidate__r.IP_MailingAddressLine2__c;
        ob.IP_Mailing_Address_Line_3__c = tl2.IP_Candidate__r.IP_MailingAddressLine3__c;
        ob.IP_New_Starter_Tax_Status__c = tl.IP_NewStarterTaxStatus__c;
        ob.IP_Tempest_Department__c = branchcode;
        ob.IP_Tempest_Division__c = tl2.IP_Candidate__r.IP_TempestDivision__c;
        ob.IP_Start_Date__c = tl2.IP_Candidate__r.IP_WorkerStartDate__c;
        ob.IP_Leaver_Requested_Date__c = tl.Date_P45_Requested__c;
        ob.IP_Last_Name__c = tl2.IP_Candidate__r.Lastname;
        ob.IP_Mailing_City__c = tl2.IP_Candidate__r.MailingCity;
        ob.IP_Mailing_Country__c = tl2.IP_Candidate__r.MailingCountry;       
        ob.IP_Mailing_State__c = tl2.IP_Candidate__r.MailingState;
        ob.IP_Mailing_PostalCode__c = tl2.IP_Candidate__r.MailingPostalCode;
        ob.IP_Phone__c = tl2.IP_Candidate__r.Phone;
        ob.IP_Salutation__c = tl2.IP_Candidate__r.Salutation;
        ob.IP_EEO_Gender__c = tl2.IP_Candidate__r.ts2__EEO_Gender__c;       
        ob.IP_National_Insurance__c = tl2.IP_Candidate__r.Sirenum__National_Insurance__c;
      
        if(tl2.IP_Candidate__r.Student__c == True){        ob.IP_Student__c = 'True';}
        else{ob.IP_Student__c = 'False';}
        
        
        ob.IP_Preferred_Name__c = tl2.IP_Candidate__r.TS2__Preferred_Name__c;
        if(tl2.IP_Candidate__r.WTR_Completed__c == True){        ob.IP_WTR__c = 'True';}
        else{ob.IP_WTR__c = 'False';}
        ob.IP_Suppression_Code__c = String.ValueOf(tl2.IP_Candidate__r.Suppression_Code__c);       
        ob.IP_Candidate__c = tl.IP_Candidate__c;
        ob.IP_Nationality__c = tl2.IP_Candidate__r.IP_Nationality__c;
        ob.IP_Company_Name__c = tl.IP_CompanyName__c;
        ob.IP_Company_Registration_No__c = tl.IP_CompanyRegNo__c;
      // ob.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;
        if(tl.IP_EmailPayslip__c == True){        ob.IP_Email_Payslip__c = 'True';}
        else{ob.IP_Email_Payslip__c = 'False';}
        ob.IP_Payment_Type__c = tl.IP_PaymentType__c;
        ob.IP_Payroll_ID__c = tl.IP_PayrollID__c;
        ob.IP_Sort_Code__c = tl.IP_SortCode__c;
        ob.IP_VAT_Number__c = tl.IP_VATNumber__c;
        ob.IP_Contact_Record_Type__c = tl2.RecordType.Name;
        ob.IP_Pay_Frequency__c = tl.IP_PayFrequency__c;
       //ob.IP_Department__c = st.IP_Department__c; - JIRA - 2459
         IP_Shift_Template__c shiftcode = IP_Shift_Template__c.getValues(branchcode);
        if(shiftcode != NULL){
        ob.IP_Department__c = shiftcode.IP_Site_Name__c;}
        ob.IP_Status__c = tl.IP_Status__c;
         if(tl2.RecordType.Name == 'PAYE' && tl.IP_Status__c == 'Active' && tl.P45_Requested__c  && tl.IP_Payroll_Leaver__c==null)
                {
                ob.IP_Payroll_Leaver__c= 'PL';
                }
        
        //ob.IP_Payroll_Leaver__c = tl.IP_Payroll_Leaver__c;
        if(tl.P45_Requested__c == True){
        ob.IP_Leaver__c = 'True';}
        else{ob.IP_Leaver__c = 'False';}
        ob.IP_Supplier_Reference__c = tl.IP_SupplierReference__c;
        ob.IP_Student_Loan__c = tl.IP_StudentLoan__c;
        if(checkpassed == true)
        {
            ob.IP_Passed__c = 'PASSING';
            if(parallelcheck.Run_Parallel_Payroll__c == false)
            {
                tl.IP_LastPassedToTempest__c = System.now();
            }
        }
        
        ob.IP_TransferType__c = 'Internal Worker';
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
                         if(recordname1 == 'PAYE' && tl.IP_Status__c == 'Active' && tl.P45_Requested__c  && tl.IP_Payroll_Leaver__c==null)
                            {
                            tl.IP_Payroll_Leaver__c= 'PL';
                            }
                     tl.IP_PassToTempest__c = false;
                     tl.IP_EmergencyPull__c = false;
                  
                    }
                    if(tl.IP_FirstPass__c == true)
                    {
                        tl.IP_FirstPass__c = false;
                    }
                     if(tl.IP_LastPassedToTempest__c != Null)
                   {
                   tl.IP_LastPassedToTempest__c = System.now();
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
                       
                         if(recordname1 == 'PAYE' && tl.IP_Status__c == 'Active' && tl.P45_Requested__c  && tl.IP_Payroll_Leaver__c==null)
                            {
                            tl.IP_Payroll_Leaver__c= 'PL';
                            }
                       
                       tl.IP_PassToTempest__c = false;
                       tl.IP_EmergencyPull__c = false;
                    }
                    if(tl.IP_FirstPass__c == true)
                    {
                        tl.IP_FirstPass__c = false;
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
              String[] toAddresses = new String[] {emailid,System.Label.BASupportEmail};//'jyothi.hale@impellam.com', 'martin.jones@impellam.com'};
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