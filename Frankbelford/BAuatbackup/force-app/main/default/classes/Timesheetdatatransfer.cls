public class Timesheetdatatransfer {
    
    public static void createOutboundRecords(List<sirenum__Timesheet_Line__c> lstTimesheetLines){
        System.debug('=============Timesheetdatatransfer ');
        String errorMessage = 'Id,Error\n';
        
        Set<Id> setTimesheetIds = new Set<Id>();
        Set<Id> setSuccessIds = new Set<Id>();        
        
        List<IP_OutboundDataTransfer__c> lstExistingOutbound = new List<IP_OutboundDataTransfer__c>();
        List<IP_OutboundDataTransfer__c> lstNewOutbound = new List<IP_OutboundDataTransfer__c>();
        List<sirenum__Placement__c> lstSPlacement = new List<sirenum__Placement__c>();
        List<Contact> lstExternalWorkerList = new List<Contact>();
        List<IP_PayProfile__c> lstInternalWorkerList = new List<IP_PayProfile__c>();
        List<sirenum__Timesheet_Line__c> lstUpdateTimesheetLines = new List<sirenum__Timesheet_Line__c>();
        
        for(sirenum__Timesheet_Line__c tl : lstTimesheetLines){
            if(tl.IP_OutboundID__c != null){
                tl.IP_InvokeTrigger__c = false;
                
                lstExistingOutbound.add(createIPOutboundDataTransfer(tl));
                lstUpdateTimesheetLines.add(tl);
            }else{
                lstNewOutbound.add(createIPOutboundDataTransfer(tl));
            }
            
            if(tl.Sirenum__Shift__r.Sirenum__Placement__r.IP_LastPassedToTempest__c == NULL && tl.Sirenum__Shift__r.Sirenum__Placement__r.IP_TimesheetIDLink__c == NULL){
                lstSPlacement.add(new Sirenum__Placement__c(Id = tl.Sirenum__Shift__r.Sirenum__Placement__c, IP_TimesheetIDLink__c = tl.sirenum__Timesheet__c, IP_FirstPass__c = TRUE, IP_PassToTempest__c = TRUE));
            }
            
            if(tl.sirenum__Timesheet__r.IP_Mini_Payroll__c != TRUE && tl.Sirenum__Shift__r.sirenum__Contact__r.IP_LastPassedToTempest2ndTier__c == NULL && tl.Sirenum__Shift__r.sirenum__Contact__r.IP_TimesheetIDLink__c == NULL && tl.Sirenum__Shift__r.sirenum__Contact__r.RecordType.name == '2nd Tier Candidate'){
                lstExternalWorkerList.add(new Contact(Id = tl.Sirenum__Shift__r.sirenum__Contact__c, IP_TimesheetIDLink__c = tl.sirenum__Timesheet__c, IP_FirstPassExternalWorker__c = TRUE, IP_Pass2ndTierToTempest__c = TRUE));
            }
            
            if(tl.Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__c!= NULL && tl.Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__r.IP_LastPassedToTempest__c == NULL && tl.Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__r.IP_TimesheetIDLink__c == NULL){
                lstInternalWorkerList.add(new IP_PayProfile__c(Id = tl.Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__c, IP_TimesheetIDLink__c = tl.sirenum__Timesheet__c, IP_FirstPass__c = TRUE, IP_PassToTempest__c = TRUE));
            }
            
            if(tl.sirenum__timesheet__c != null && (tl.sirenum__Timesheet__r.IP_EmergencyPull__c || tl.sirenum__Timesheet__r.IP_Mini_Payroll__c == true)){
                setTimesheetIds.add(tl.sirenum__timesheet__c);
            }
        }
        
        if(lstNewOutbound.size() > 0){     
            Database.SaveResult[] srList = Database.insert(lstNewOutbound, false);
            for (integer i=0; i < srList.size(); i++) {
                if(srList[i].isSuccess()){
                    setSuccessIds.add(srList[i].Id);
                }                        
            }
            
            if(!setSuccessIds.isEmpty()){
                List<sirenum__Timesheet_Line__c> lstNewTimesheetLines = new List<sirenum__Timesheet_Line__c>();
                for(IP_OutboundDataTransfer__c ol: [SELECT Id, IP_OriginRecordID__c, LastModifieddate, CreatedDate FROM IP_OutboundDataTransfer__c WHERE Id IN : setSuccessIds]){
                    lstNewTimesheetLines.add(new sirenum__Timesheet_Line__c(Id = ol.IP_OriginRecordID__c, IP_OutboundID__c = ol.Id, IP_Outbounddatawrite__c = ol.CreatedDate, IP_InvokeTrigger__c = FALSE));
                }
                if(lstNewTimesheetLines.size() > 0){
                    update lstNewTimesheetLines;
                }
            }
        }
        
        if(lstExistingOutbound.size() > 0){
            errorMessage += handleUpdate(lstExistingOutbound, errorMessage);
        }
        
        if(lstSPlacement.size() > 0){
            errorMessage += handleUpdate(lstSPlacement, errorMessage);
        }
        
        if(lstExternalWorkerList.size() > 0){
            errorMessage += handleUpdate(lstExternalWorkerList, errorMessage);
        }
        
        if(lstInternalWorkerList.size() > 0){
            errorMessage += handleUpdate(lstInternalWorkerList, errorMessage);
        }
        
        if(!setTimesheetIds.isEmpty()){
            List<sirenum__Timesheet__c> lstTimesheet = new List<sirenum__Timesheet__c>();
            IP_Parallel_Payroll_Check__c payrollCheck = IP_Parallel_Payroll_Check__c.getValues('RunParallelCheck');
            for(sirenum__Timesheet__c ts : [SELECT Id, IP_EmergencyPull__c, Emergency_Pull_User__c FROM sirenum__Timesheet__c WHERE Id IN : setTimesheetIds]){
                if(!payrollCheck.Run_Parallel_Payroll__c){
                    ts.IP_EmergencyPull__c = false;
                    lstTimesheet.add(ts);
                }
            }
            if(lstTimesheet.size() > 0){
                update lstTimesheet;    
            }
        }
        
        if(lstUpdateTimesheetLines.size() > 0){
            update lstUpdateTimesheetLines;
        }
        
        if(String.isNotBlank(errorMessage) && errorMessage != 'Id,Error\n'){
            sendEmail(errorMessage);
        }
    }
    
    public static IP_OutboundDataTransfer__c createIPOutboundDataTransfer(sirenum__Timesheet_Line__c tl){
        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
        
        if(tl.IP_OutboundID__c != null){
            ob.Id = tl.IP_OutboundID__c;    
        }
        
        ob.IP_Rate__c = tl.Sirenum__Rate__c;
        ob.IP_Consultant_2_Percentage_Split__c = String.valueOf(tl.Sirenum__Shift__r.Sirenum__Placement__r.IP_Consultant2PercentageSplit__c);
        ob.IP_Main_ContactName__c = tl.Sirenum__Shift__r.sirenum__Site__r.IP_MainContact__r.Name;
        ob.IP_AssignmentRef__c = tl.sirenum__Shift__r.Sirenum__Placement__r.IP_AssignmentRefForTempest__c;
        ob.IP_Consultant_1_ID_number__c = tl.sirenum__Shift__r.sirenum__Placement__r.IP_Consultant1IDnumberSplitShare__c;
        ob.IP_Commission_Split__c = String.valueOf(tl.Sirenum__Shift__r.Sirenum__Placement__r.IP_Consultant1PercentageSplit__c);
        ob.IP_Consultant_2_ID_number__c = tl.sirenum__Shift__r.sirenum__Placement__r.IP_Consultant2IDnumberSplitShare__c;
        ob.IP_Tempest_Department__c = tl.sirenum__Shift__r.sirenum__Placement__r.IP_TempestDepartment__c;
        ob.IP_WorkerPayroll_Ref__c = tl.sirenum__Shift__r.sirenum__Placement__r.IP_WorkerPayrollRef__c;
        ob.IP_Placement_End_Date__c = tl.sirenum__Shift__r.sirenum__Placement__r.sirenum__End_Date__c;
        ob.IP_Placement_Start_Date__c = tl.sirenum__Shift__r.sirenum__Placement__r.sirenum__Start_Date__c;
        ob.IP_SiteName__c = tl.sirenum__Shift__r.sirenum__Site__r.Name;
        ob.IP_Job_Type_Name__c = tl.sirenum__Shift__r.sirenum__Team__r.sirenum__Job_Type__r.Name;
        ob.IP_Presented_payroll_date__c = tl.IP_PresentedPayrollDateDateType__c;
        ob.IP_Payroll_Presented_TimesheetNumber__c = tl.IP_PayrollPresentedTimesheetNumber__c;
        ob.IP_Hours__c = tl.sirenum__Hours__c;
        ob.IP_Tempest_Division__c = tl.sirenum__Shift__r.sirenum__Placement__r.IP_TempestDivision__c;
        ob.IP_AWR_Job_Cat__c = tl.sirenum__Shift__r.sirenum__Placement__r.IP_AWRJobCat__c;
        ob.IP_AWR_Core_Cat__c = tl.sirenum__Shift__r.sirenum__Placement__r.IP_AWRCoreCat__c;
        ob.IP_TransferType__c = 'Timesheet';
        ob.IP_Adhoc_Formula__c = tl.Adhoc_Formula__c;
        ob.IP_PayrollPresentedRateCode__c = tl.IP_EdiRateCode__c;
        ob.IP_Invoice_PO_Number__c = tl.IP_PurchaseOrderNumber__c;
        ob.Unit_Id__c = tl.Sirenum__Shift__r.Sirenum__Site__r.Unit_ID__c;
        ob.IP_Charge__c = tl.Sirenum__Charge__c;
        ob.IP_Client_ID_Legacy__c = tl.Sirenum__Shift__r.Sirenum__Site__r.IP_ClientIDLegacy__c; 
        string assignment = tl.sirenum__Shift__r.sirenum__Placement__r.IP_AssignmentRef__c;
        ob.IP_AssignmentNumber__c = assignment.abbreviate(10);
        ob.IP_OriginRecordID__c = tl.id;
        ob.IP_RowCount__c = tl.sirenum__Timesheet__r.sirenum__Lines__c; 
        ob.IP_CandidateName__c = tl.sirenum__Timesheet__r.sirenum__Worker__r.name;
        ob.IP_ClientName__c = tl.sirenum__Timesheet__r.sirenum__Client__r.Name;
        ob.IP_WeekendingDate__c = tl.sirenum__Timesheet__r.sirenum__Week_Ending__c;
        ob.IP_CandidateID__c = tl.sirenum__Shift__r.sirenum__Placement__r.IP_WorkerPayrollRef__c;
        ob.IP_PO__c = tl.IP_PurchaseOrderNumber__c;
        ob.IP_RateCode__c = tl.IP_EdiRateCode__c;
        ob.IP_TimsheetID__c = tl.IP_PayrollPresentedTimesheetNumber__c;
        ob.IP_PayrollMethod__c = tl.sirenum__Timesheet__r.sirenum__Site__r.IP_Timesheet_Method__c;
        ob.IP_Date__c = tl.sirenum__Date__c;
        ob.IP_TimesheetID__c = tl.sirenum__Timesheet__c;
        
        if(tl.sirenum__Timesheet__r.IP_EmergencyPull__c || tl.sirenum__Timesheet__r.IP_Mini_Payroll__c == true ){
            ob.IP_EmergencyPull__c = TRUE;
            if(tl.sirenum__Timesheet__r.Emergency_Pull_User__c == 'Emergency_Payroll'){
                ob.IP_Passed__c = 'PASSING';
            }
        }
        
        if(tl.sirenum__Overtime_Rate__c == True){
            ob.IP_RateDescription__c = 'Overtime Hours';
        }else if(tl.IP_RateCodes__c != null){
            ob.IP_RateDescription__c = tl.IP_RateCodes__c.split('/')[0];
        }else{
            ob.IP_RateDescription__c = tl.sirenum__Rate_Line__r.sirenum__Standard_Rate_Name__c;
        }
        
        ob.IP_Unit__c = tl.sirenum__Hours__c;
        if(tl.sirenum__Shift__r.Approved_Date_Time__c == null ){
            ob.IP_ApprovalStamp__c = tl.sirenum__Shift__r.Approved_By__r.Name;
        }else{
            ob.IP_ApprovalStamp__c = tl.sirenum__Shift__r.Approved_By__r.Name +' '+tl.sirenum__Shift__r.Approved_Date_Time__c; 
        }
        
        return ob;
    }
    
    public static String handleUpdate(List<sObject> updatedRecords, String errorMessage){
        List<String> lstErrorIds = new List<String>();
        
        Map<String, String> errorMessages = new Map<String, String>();
        
        Database.SaveResult[] saveResult = Database.update(updatedRecords, false); 
        for (Integer i=0; i < saveResult.size(); i++){
            if(!saveResult[i].isSuccess()){
                for(Database.Error err : saveResult[i].getErrors()){                          
                    lstErrorIds.add(saveResult[i].Id);          
                    errorMessages.put(saveResult[i].Id, err.getMessage());
                }
            }                       
        }
        
        if(!lstErrorIds.IsEmpty()){
            for(Integer i=0; i < lstErrorIds.size(); i++){                 
                errorMessage = errorMessage + lstErrorIds[i]+','+ errorMessages.get(lstErrorIds[i]) + ',' +'\n';    
            }
        } 
        
        return errorMessage;
    }    
    
    public static void sendEmail(String errorMessage){
        String errorEmailAddress = IP_ImpellamGlobalSetting__c.getInstance().IP_OutboundErrorEmailAddress__c;
        
        Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();
        errAtt.setFileName('Timesheet Failed_Records.csv');    
        errAtt.setBody(blob.valueof(errorMessage));
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        email.setSubject('Timesheet - Outbound Transfer Failure');     
        email.setToAddresses(new String[] {errorEmailAddress});    
        email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');     
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
        Messaging.SendEmailResult[] saveResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}