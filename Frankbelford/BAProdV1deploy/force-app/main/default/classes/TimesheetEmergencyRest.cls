//field not found Sirenum_Hours__c
//FR13 /StandardTimesheet/branchCode/*
@RestResource(UrlMapping='/emergency/v1/collect/timesheet/*/*')
global class TimesheetEmergencyRest {
   
    @HttpGet
    global static ResponseClass doGet()
    {
        String[] uriKeys = RestContext.request.requestURI.split('/'); 
        String branchCode = uriKeys.get(uriKeys.size()-2);    
        String GUID= uriKeys.get(uriKeys.size()-1);
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');      
        List<sirenum__Timesheet_Line__c> tsUpdate = new List<sirenum__Timesheet_Line__c>();
        String errorFile = 'Id,Error\n'; 
        Map<id,String> errMessage = new Map<id,String>(); 
        Impellam_Settings__c set1 = Impellam_Settings__c.getValues('TimesheetEmergencyRest'); 
        Integer limit1 = Integer.Valueof(set1.Limit__c);
      try{  
            
     List<sirenum__Timesheet_Line__c > tsData = [select Adhoc_Formula__c,
                                                 //sirenum__Code__c,commented after Martin's email on 27-9-2017
                                                 //IP_PayrollPresentedRateCode__c,- Comented after the EDI Change-IP_EdiRateCode is used instead
                                                 IP_EdiRateCode__c,
                                                 IP_PurchaseOrderNumber__c,
                                                 Sirenum__Charge__c,
                                                 Sirenum__Shift__r.Sirenum__Site__r.IP_ClientIDLegacy__c,                                                 
                                                 Sirenum__Rate__c,
                                                 Sirenum__Shift__r.Sirenum__Placement__r.IP_Consultant2PercentageSplit__c,
                                                 Sirenum__Shift__r.sirenum__Site__r.IP_MainContact__r.Name,
                                                 /*Sirenum__Shift__r.Sirenum__Placement__r.Name,  commented on 14-9-2017 new field added */
                                                 sirenum__Shift__r.Sirenum__Placement__r.IP_AssignmentRefForTempest__c,
                                                 sirenum__Shift__r.sirenum__Placement__r.IP_Consultant1IDnumberSplitShare__c,
                                                 Sirenum__Shift__r.Sirenum__Placement__r.IP_Consultant1PercentageSplit__c,
                                                 sirenum__Shift__r.sirenum__Placement__r.IP_Consultant2IDnumberSplitShare__c,
                                               //  IP_TempestDepartment__c,
                                                 sirenum__Shift__r.sirenum__Placement__r.IP_TempestDepartment__c, 
                                                 //sirenum__Shift__r.sirenum__Placement__r.IP_PayMethod__r.IP_PayrollID__c,
                                                 sirenum__Shift__r.sirenum__Placement__r.IP_WorkerPayrollRef__c,
                                                 sirenum__Shift__r.sirenum__Placement__r.sirenum__End_Date__c,
                                                 sirenum__Shift__r.sirenum__Placement__r.sirenum__Start_Date__c,
                                                sirenum__Shift__r.sirenum__Site__r.Name,
                                               //  sirenum__Shift__r.sirenum__Team__r.Name,
                                                  sirenum__Shift__r.sirenum__Team__r.sirenum__Job_Type__r.Name, //After defect 7489 
                                                 IP_PresentedPayrollDateDateType__c,
                                                 //sirenum__Timesheet__r.IP_PresentedPayrollDateDateType__c,
                                                // sirenum__Timesheet__r.Timesheet_tempest_number__c, (Chnage after Martin's approval for automate timesheet 27/11/2017)
                                                // sirenum__Timesheet__r.IP_PayrollPresentedTimesheetNumber__c,
                                                IP_PayrollPresentedTimesheetNumber__c,
                                                 sirenum__Hours__c,
                                               //  IP_TempestDivision__c,
                                                 sirenum__Shift__r.sirenum__Placement__r.IP_TempestDivision__c, 
                                                 sirenum__Shift__r.sirenum__Placement__r.IP_AWRJobCat__c,
                                                 sirenum__Shift__r.sirenum__Placement__r.IP_AWRCoreCat__c
                                                 from sirenum__Timesheet_Line__c where sirenum__Timesheet__r.IP_EmergencyPull__c=true and IP_HoldTimeSheetLine__c=false and IP_PassToTempest__c = TRUE
                                                 and IP_TempestDepartment__c=:branchCode and IP_RateCodes__c!='WT' and  sirenum__Timesheet__r.IP_DuplicateCheckPassOK__c=true and sirenum__Timesheet__r.sirenum__Week_Ending__c < Today and (GUID_Timesheetline__c=null OR GUID_Timesheetline__c!=:GUID) and (IP_PayrollPresentedRateCode__c!='' OR IP_PayrollPresentedRateCode__c!=null) and (Sirenum__Shift__r.Sirenum__Placement__r.IP_LastPassedToTempest__c!=null OR Sirenum__Shift__r.Sirenum__Placement__r.IP_PassToTempest__c = TRUE) and ((Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__r.IP_LastPassedToTempest__c!=null OR Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__r.IP_PassToTempest__c = TRUE) OR (Sirenum__Shift__r.sirenum__Contact__r.IP_LastPassedToTempest2ndTier__c!=null OR Sirenum__Shift__r.sirenum__Contact__r.IP_Pass2ndTierToTempest__c = TRUE) OR Sirenum__Shift__r.sirenum__Contact__r.IP_BorrowedTemp__c = 'Yes') and (Sirenum__Shift__r.Sirenum__Placement__r.IP_Consultant1LookupSplitShare__r.IP_LastPassedToTempest__c!=null OR Sirenum__Shift__r.Sirenum__Placement__r.IP_Consultant1LookupSplitShare__r.IP_PassToTempest__c = TRUE) and (sirenum__Shift__r.sirenum__Site__r.IP_ClientAddressLastPassedToTempest__c!=null OR sirenum__Shift__r.sirenum__Site__r.IP_PassClientAddressToTempest__c = TRUE) and(sirenum__Shift__r.sirenum__Site__r.IP_ClientLastPassedToTempest__c!=null OR sirenum__Shift__r.sirenum__Site__r.IP_PassClientToTempest__c = TRUE) LIMIT :limit1];
           for(sirenum__Timesheet_Line__c  cnt: tsData)
           { cnt.GUID_Timesheetline__c = GUID;tsUpdate.add(cnt);                                               
                }       
          Database.SaveResult[] srList = Database.update(tsUpdate, false);
           List<id> errorIds = new List<id>();
                 List<id> successIds = new List<id>();
                for (integer i=0; i<srList.size();i++) 
                {
                     String errMsgs = '';
                    if(srList[i].isSuccess())
                    {
                        successIds.add(tsUpdate[i].id);
                    }
                    else
                    {
                        errorIds.add(tsUpdate[i].id);
                        for(Database.Error err : srList[i].getErrors())
                        {
                            errMsgs = errMsgs + '  ' + err.getMessage();       
                        }
                         errMessage.put(tsUpdate[i].Id,errMsgs);
                         errMsgs ='';   
                    }
                }
            if(errorIds.isEmpty())
           return new ResponseClass('true', 'Query executed successfully.',tsData);     
            else
            {
            for(integer i=0;i<errorIds.size();i++)
                {
                    errorFile = errorFile + errorIds[i]+','+ errMessage.get(errorIds[i]) + ',' +'\n';
                 }
            Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();    
            blob errBlob = blob.valueof(errorFile);    
            errAtt.setFileName('Failed_Records.csv');
            errAtt.setBody(errBlob);
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
          /*  List<String>  toAddresses = new List<String>();
            List<User> userList = new List<User>();
            userList = [SELECT Id,Email,IsActive FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True] ; 
            for (User u : userList)
            {
            toAddresses.add(u.email);
            } */
            String subject ='Emergency API Collect Failure - Timesheet';
            email.setSubject(subject);
            String[] toAddress = new String[] {System.Label.BASupportEmail};
            email.setToAddresses(toAddress);
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
           return new ResponseClass('false', 'Error in querying records',null);     
            }
        
        } catch (Exception e) {
            return new ResponseClass('false', e.getMessage(), null);
        }  
    }
    
    
    global class ResponseClass 
    {

        global String success;
        global String message;
        global List<sirenum__Timesheet_Line__c> records;

        global ResponseClass(String success, String message, List<sirenum__Timesheet_Line__c> records) 
        {
            this.success = success;
            this.message = message;
            this.records = records;
        }
    }
}