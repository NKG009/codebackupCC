//FR05,6,7,8 on hold parameteres - /services/apexrest/StandardInternalWorker/branchCode/1069
@RestResource(urlMapping='/emergency/v1/collect/internalworker/*/*')
global class InternalWorkerEmergencyrest 
{
    @HttpGet
    global static ResponseClass doGet()
    {
        
        String[] uriKeys = RestContext.request.requestURI.split('/');          
        String branchCode = uriKeys.get(uriKeys.size()-2);        
        String GUID = uriKeys.get(uriKeys.size()-1);    
        List<Contact> ccUpdate = New List<Contact>();
        Map<id,Contact> conmap = new Map<id,Contact>();
        List<IP_PayProfile__c> ppUpdate = New List<IP_PayProfile__c>();
        String errorFile = 'Id,Error\n'; 
        Map<id,String> errMessage = new Map<id,String>(); 
        Set<id> payid = new Set<id>();
        Impellam_Settings__c set1 = Impellam_Settings__c.getValues('InternalworkeremergencyRest'); 
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        system.debug('Limit Value@@@'+set1);
     /*    List<sirenum__Timesheet_Line__c> tsLine = [select id,sirenum__Shift__r.sirenum__Placement__r.IP_PayMethod__c from sirenum__Timesheet_Line__c where IP_PassToTempest__c=true and sirenum__Timesheet__r.sirenum__Week_Ending__c < Today];
         for(sirenum__Timesheet_Line__c tline: tsLine)
         {
             payid.add(tline.sirenum__Shift__r.sirenum__Placement__r.IP_PayMethod__c);
         }
         System.debug('%%Pay Profile ID'+payid);*/
        try{  
            List<IP_PayProfile__c> ppData = [select IP_BankAccountName__c,
                                             IP_AccountNumber__c,
                                             IP_BuildingSocietyNumber__c,
                                             IP_BusinessAddressCounty__c,
                                             IP_BusinessAddressLine1__c,
                                             IP_BusinessAddressLine2__c,
                                             IP_BusinessAddressPostcode__c,
                                             IP_BusinessAddressTown__c,
                                             IP_Candidate__r.Birthdate,
                                             IP_Candidate__r.IP_ConsultantsTempestID__c,
                                             IP_Candidate__r.Email,
                                             IP_Candidate__r.Firstname,
                                             IP_Candidate__r.IP_MailingAddressLine1__c,
                                             IP_Candidate__r.IP_MailingAddressLine2__c,
                                             IP_Candidate__r.IP_MailingAddressLine3__c,
                                             //IP_Candidate__r.IP_NewStartTaxStatus__c, modified at 22-8-17, Incidant-5764 
                                             IP_NewStarterTaxStatus__c,
                                             IP_Candidate__r.IP_TempestDepartment__c,
                                             IP_Candidate__r.IP_TempestDivision__c,
                                             IP_Candidate__r.IP_WorkerStartDate__c,
                                             //IP_Candidate__r.IP_WorkerLeavingDate__c, modified as per latest P45 spec Release 30
                                             Date_P45_Requested__c,
                                             IP_Candidate__r.Lastname,
                                             IP_Candidate__r.MailingCity,
                                             IP_Candidate__r.MailingCountry,
                                             IP_Candidate__r.MailingState,
                                             IP_Candidate__r.MailingPostalCode,
                                             IP_Candidate__r.Phone,
                                            // IP_Candidate__r.IP_PresentedP45ReasonCode__c, // added doc v9 29-8-2017,modified as per latest P45 spec Release 30
                                           //  IP_Candidate__r.Reason_for_P45__c,
                                            // Reason_for_P45_Internal__c, // modified as per latest P45 spec Release 30
                                             IP_Candidate__r.Salutation,
                                             IP_Candidate__r.EEO_Gender__c,
                                             IP_Candidate__r.Sirenum__National_Insurance__c,
                                             IP_Candidate__r.Student__c,
                                             IP_Candidate__r.Preferred_Name__c,
                                             IP_Candidate__r.WTR_Completed__c,  
                                             IP_Candidate__r.Suppression_Code__c, //p45
                                             IP_Candidate__c,
                                             IP_Candidate__r.IP_Nationality__c, //After defect 7931
                                             IP_CompanyName__c,
                                             IP_CompanyRegNo__c,
                                             IP_EmailPayslip__c,
                                             IP_PaymentType__c,
                                             IP_PayrollID__c,
                                             IP_SortCode__c,
                                             IP_VATNumber__c,
                                             RecordType.Name, 
                                             IP_PayFrequency__c,
                                             IP_Candidate__r.IP_Department__c, //added at 17-8-2017 doc v7
                                             IP_Status__c,  //p45
                                            // IP_Candidate__r.PayrollLeaver__c,  //p45 modified as per latest P45 spec Release 30
                                            IP_Payroll_Leaver__c, //modified as per latest P45 spec Release 30
                                           //  IP_Candidate__r.P45_Requested__c,  //p45 ,modified as per latest P45 spec Release 30
                                           P45_Requested__c,
                                             IP_SupplierReference__c,
                                             IP_StudentLoan__c,
                                             IP_LastPassedToTempest__c
                                             from IP_PayProfile__c
                                             where IP_EmergencyPull__c=true and IP_Candidate__r.IP_TempestDepartment__c=:branchCode
                                             and IP_Candidate__r.RecordType.DeveloperName ='Candidate' and (IP_GUID__c=null or IP_GUID__c!=:GUID) LIMIT :limit1 ];
                
            for(IP_PayProfile__c cnt: ppData)
            {   
                cnt.IP_GUID__c = GUID;
                if(cnt.RecordType.Name == 'PAYE' && cnt.IP_Status__c == 'Active' && cnt.P45_Requested__c  && cnt.IP_Payroll_Leaver__c==null)
                {
                cnt.IP_Payroll_Leaver__c= 'PL';
                }
              //  ccUpdate.add(cnt.IP_Candidate__r);                                             
            }  
            //conmap.putall(ccUpdate);  
             Database.SaveResult[] srList= Database.update(ppData,false);     
              // Database.SaveResult[] srList = Database.update(conmap.values(), false);   
           
            List<id> errorIds = new List<id>();
                 List<id> successIds = new List<id>();
                for (integer i=0; i<srList.size();i++) 
                {
                     String errMsgs = '';
                    if(srList[i].isSuccess())
                    {
                        successIds.add(ppData[i].id);
                    }
                    else
                    {
                        errorIds.add(ppData[i].id);
                        for(Database.Error err : srList[i].getErrors())
                        {errMsgs = errMsgs + '  ' + err.getMessage();       
                        }
                         errMessage.put(ppData[i].Id,errMsgs);errMsgs ='';   
                    }
                }
            if(errorIds.isEmpty())
           return new ResponseClass('true', 'Query executed successfully.',ppData);     
            else
            {
            for(integer i=0;i<errorIds.size();i++)
                { errorFile = errorFile + errorIds[i]+','+ errMessage.get(errorIds[i]) + ',' +'\n';
                 }
            Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();    
            blob errBlob = blob.valueof(errorFile); errAtt.setFileName('Failed_Records.csv'); errAtt.setBody(errBlob);
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
          /*  List<String>  toAddresses = new List<String>();
            List<User> userList = new List<User>();
            userList = [SELECT Id,Email,IsActive FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True] ; 
            for (User u : userList)
            {
            toAddresses.add(u.email);
            } */
            String subject ='Emergency API Collect Failure - Internal Worker';
            email.setSubject(subject);
            String[] toAddress = new String[] {System.Label.BASupportEmail};
            email.setToAddresses(toAddress);
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
           return new ResponseClass('false', 'Error in querying records',null);     
            }
        
        } catch (Exception e) { return new ResponseClass('false', e.getMessage(), null);
        }  
    }
    
    
    global class ResponseClass 
    {
        
        global String success;
        global String message;
        global List<IP_PayProfile__c> records;
        
        global ResponseClass(String success, String message, List<IP_PayProfile__c> records) 
        {
            this.success = success;
            this.message = message;
            this.records = records;
        }
    }
}