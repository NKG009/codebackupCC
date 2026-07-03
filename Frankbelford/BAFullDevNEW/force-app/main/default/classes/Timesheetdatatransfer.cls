public class Timesheetdatatransfer {
    
    public static void sendtldata(Set<id> tlset){
        System.debug('======================== tlset.size() : '+tlset.Size());
        IP_CompanyCode__c Ccode = IP_CompanyCode__c.getValues('CompanyCode');
        Set<String> branchset = new Set<String>();
        String emailid = IP_ImpellamGlobalSetting__c.getInstance().IP_OutboundErrorEmailAddress__c;
        Boolean sendMail = false;
        String errorFile = 'Id,Error\n';
        Map<id,String> errMessage2 = new Map<id,String>();
        List<Id> errorIds2 = new List<Id>();
        Map<String,String> errMessage1 = new Map<String,String>();
        List<String> errorIds1 = new List<String>();
        Map<id,String> errMessage3 = new Map<id,String>();
        List<Id> errorIds3 = new List<Id>();
        Map<id,String> errMessage4 = new Map<id,String>();
        List<Id> errorIds4 = new List<Id>();
        Map<id,String> errMessage5 = new Map<id,String>();
        List<Id> errorIds5 = new List<Id>();
        Date dt = system.today();
        Map<id,id> timemap = new Map<id,id>();
        IP_Parallel_Payroll_Check__c paycheck = IP_Parallel_Payroll_Check__c.getValues('RunParallelCheck');
        List<sirenum__Placement__c> splacelist = new List<sirenum__Placement__c>();
        List<Contact> externalworkerlist = new List<Contact>();
        List<IP_PayProfile__c> internalworkerlist = new List<IP_PayProfile__c>();
        Set<id> successids = new Set<id>();
        Set<id> checkids = new Set<id>();
        Set<id> Timesheetid = new Set<id>();
        Set<id> internalworkerset = new Set<id>();
        List<sirenum__Timesheet_Line__c> updatetimelist = new List<sirenum__Timesheet_Line__c>();   
        List<IP_OutboundDataTransfer__c> outboundList = new List<IP_OutboundDataTransfer__c>();
        List<IP_OutboundDataTransfer__c> UpdateoutboundList = new List<IP_OutboundDataTransfer__c>();
        List<IP_BranchStatus__c> branchlist = [Select id,IP_BranchID__c from IP_BranchStatus__c];
        for(IP_BranchStatus__c b:branchlist)
        {
            branchset.add(b.IP_BranchID__c);
        }     
        Long startTime = Limits.getCpuTime();
        System.debug('==================== Timesheetdatatransfer : '+ startTime + ' ms');
        List<sirenum__Timesheet_Line__c> timelist = [Select id,sirenum__Timesheet__r.IP_Mini_Payroll__c,sirenum__Timesheet__r.Emergency_Pull_User__c,sirenum__Timesheet__r.IP_EmergencyPull__c,IP_OutboundID__c,Sirenum__Shift__r.sirenum__Contact__r.IP_LastPassedToTempest2ndTier__c,Sirenum__Shift__r.sirenum__Contact__r.IP_TimesheetIDLink__c,Sirenum__Shift__r.sirenum__Contact__r.IP_FirstPassExternalWorker__c,Sirenum__Shift__r.sirenum__Contact__r.IP_Pass2ndTierToTempest__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__r.IP_LastPassedToTempest__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__r.IP_TimesheetIDLink__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__r.IP_FirstPass__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__r.IP_PassToTempest__c,sirenum__Timesheet__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_LastPassedToTempest__c,Sirenum__Shift__r.Sirenum__Placement__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_PassToTempest__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_FirstPass__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_TimesheetIDLink__c,Name,sirenum__Timesheet__r.sirenum__Lines__c,sirenum__Shift__r.sirenum__Placement__r.IP_AssignmentRef__c,sirenum__Overtime_Rate__c,sirenum__Timesheet__r.sirenum__Week_Ending__c,sirenum__Rate_Line__r.sirenum__Standard_Rate_Name__c,sirenum__Hours__c,sirenum__Shift__r.Approved_By__r.Name,IP_RateCodes__c,Adhoc_Formula__c,sirenum__Date__c,sirenum__Timesheet__r.sirenum__Worker__r.name,IP_EdiRateCode__c,IP_LastPassedToTempest__c,sirenum__Timesheet__r.sirenum__Client__r.Name,sirenum__Shift__r.sirenum__Contact__c,sirenum__Shift__r.sirenum__Contact__r.RecordType.Name,IP_PurchaseOrderNumber__c,Sirenum__Charge__c,Sirenum__Shift__r.Sirenum__Site__r.IP_ClientIDLegacy__c,Sirenum__Rate__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_Consultant2PercentageSplit__c,sirenum__Shift__r.Approved_Date_Time__c, Sirenum__Shift__r.sirenum__Site__r.IP_MainContact__r.Name,sirenum__Shift__r.Sirenum__Placement__r.IP_AssignmentRefForTempest__c,sirenum__Shift__r.sirenum__Placement__r.IP_Consultant1IDnumberSplitShare__c, sirenum__Timesheet__r.sirenum__Site__r.IP_Timesheet_Method__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_Consultant1PercentageSplit__c,sirenum__Shift__r.sirenum__Placement__r.IP_Consultant2IDnumberSplitShare__c,sirenum__Shift__r.sirenum__Placement__r.IP_TempestDepartment__c,sirenum__Shift__r.sirenum__Placement__r.IP_WorkerPayrollRef__c,sirenum__Shift__r.sirenum__Placement__r.sirenum__End_Date__c,sirenum__Shift__r.sirenum__Placement__r.sirenum__Start_Date__c,sirenum__Shift__r.sirenum__Site__r.Name,sirenum__Shift__r.sirenum__Team__r.sirenum__Job_Type__r.Name,IP_PresentedPayrollDateDateType__c,IP_PayrollPresentedTimesheetNumber__c,sirenum__Shift__r.sirenum__Placement__r.IP_TempestDivision__c,sirenum__Shift__r.sirenum__Placement__r.IP_AWRJobCat__c, sirenum__Shift__r.sirenum__Placement__r.IP_AWRCoreCat__c,Sirenum__Shift__r.Sirenum__Site__r.Unit_ID__c  from sirenum__Timesheet_Line__c where IP_TempestDepartment__c in :branchset and IP_RateCodes__c!='WT' and (IP_PayrollPresentedRateCode__c!='' OR IP_PayrollPresentedRateCode__c!=null) and id in: tlset];
        
        Long endTime = Limits.getCpuTime();
        System.debug('==================== Timesheetdatatransfer : '+ (endTime - startTime) + ' ms');
        
        for(sirenum__Timesheet_Line__c tl: timelist)
        {
            
            if(tl.IP_OutboundID__c != null)
            {
                System.debug('inside if');
                IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
                
                ob.id = tl.IP_OutboundID__c;
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
                //  ob.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;
                if(tl.sirenum__Timesheet__r.IP_EmergencyPull__c || tl.sirenum__Timesheet__r.IP_Mini_Payroll__c == true )
                {
                    ob.IP_EmergencyPull__c = TRUE;
                    Timesheetid.add(tl.sirenum__timesheet__c);
                    if(tl.sirenum__Timesheet__r.Emergency_Pull_User__c == 'Emergency_Payroll')
                    {
                        ob.IP_Passed__c = 'PASSING';
                    }
                }
                if(tl.sirenum__Overtime_Rate__c == True)
                {
                    ob.IP_RateDescription__c = 'Overtime Hours';
                }
                else if(tl.IP_RateCodes__c != null)
                {
                    String RCode = tl.IP_RateCodes__c;
                    List<String> rate = RCode.split('/');
                    ob.IP_RateDescription__c = rate[0];
                }
                else{
                    ob.IP_RateDescription__c = tl.sirenum__Rate_Line__r.sirenum__Standard_Rate_Name__c;
                }
                ob.IP_Unit__c = tl.sirenum__Hours__c;
                if(tl.sirenum__Shift__r.Approved_Date_Time__c == null ){
                    ob.IP_ApprovalStamp__c = tl.sirenum__Shift__r.Approved_By__r.Name;
                }
                else
                {
                    ob.IP_ApprovalStamp__c = tl.sirenum__Shift__r.Approved_By__r.Name +' '+tl.sirenum__Shift__r.Approved_Date_Time__c; 
                }
                UpdateoutboundList.add(ob);
                checkids.add(tl.id);
            }
            else
            {
                System.debug('inside else');
                IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
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
                // ob.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;
                if(tl.sirenum__Timesheet__r.IP_EmergencyPull__c ||  tl.sirenum__Timesheet__r.IP_Mini_Payroll__c == true)
                {
                    ob.IP_EmergencyPull__c = TRUE;
                    Timesheetid.add(tl.sirenum__timesheet__c);
                    if(tl.sirenum__Timesheet__r.Emergency_Pull_User__c == 'Emergency_Payroll')
                    {
                        ob.IP_Passed__c = 'PASSING';
                    }
                }
                if(tl.sirenum__Overtime_Rate__c == True)
                {
                    ob.IP_RateDescription__c = 'Overtime Hours';
                }
                else if(tl.IP_RateCodes__c != null)
                {
                    String RCode = tl.IP_RateCodes__c;
                    List<String> rate = RCode.split('/');
                    ob.IP_RateDescription__c = rate[0];
                }
                else{
                    ob.IP_RateDescription__c = tl.sirenum__Rate_Line__r.sirenum__Standard_Rate_Name__c;
                }
                ob.IP_Unit__c = tl.sirenum__Hours__c;
                if(tl.sirenum__Shift__r.Approved_Date_Time__c == null ){
                    ob.IP_ApprovalStamp__c = tl.sirenum__Shift__r.Approved_By__r.Name;
                }
                else
                {
                    ob.IP_ApprovalStamp__c = tl.sirenum__Shift__r.Approved_By__r.Name +' '+tl.sirenum__Shift__r.Approved_Date_Time__c; 
                }
                outboundList.add(ob);
            }
            
            if(tl.Sirenum__Shift__r.Sirenum__Placement__r.IP_LastPassedToTempest__c == null && tl.Sirenum__Shift__r.Sirenum__Placement__r.IP_TimesheetIDLink__c == null)
            {
                Sirenum__Placement__c sp = new Sirenum__Placement__c(id = tl.Sirenum__Shift__r.Sirenum__Placement__c,IP_TimesheetIDLink__c = tl.sirenum__Timesheet__c,IP_FirstPass__c = TRUE,IP_PassToTempest__c = TRUE);
                if(!splacelist.contains(sp))
                {
                    splacelist.add(sp);
                }
            }
            if(tl.sirenum__Timesheet__r.IP_Mini_Payroll__c!= true && tl.Sirenum__Shift__r.sirenum__Contact__r.IP_LastPassedToTempest2ndTier__c == null && tl.Sirenum__Shift__r.sirenum__Contact__r.IP_TimesheetIDLink__c ==null && tl.Sirenum__Shift__r.sirenum__Contact__r.RecordType.name == '2nd Tier Candidate')
            {
                Contact con = new Contact(id = tl.Sirenum__Shift__r.sirenum__Contact__c,IP_TimesheetIDLink__c = tl.sirenum__Timesheet__c,IP_FirstPassExternalWorker__c = TRUE,IP_Pass2ndTierToTempest__c = TRUE);
                if(!externalworkerlist.contains(con))
                {
                    externalworkerlist.add(con);
                }
            }
            if(tl.Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__c!= null && tl.Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__r.IP_LastPassedToTempest__c == null && tl.Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__r.IP_TimesheetIDLink__c == null)
            {
                System.debug('Check list'+internalworkerlist);
                IP_PayProfile__c payprof = new IP_PayProfile__c(id = tl.Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__c,IP_TimesheetIDLink__c = tl.sirenum__Timesheet__c,IP_FirstPass__c = TRUE,IP_PassToTempest__c = TRUE);
                if(!internalworkerlist.contains(payprof))
                {
                    internalworkerlist.add(payprof);
                }
            }
            
        }
        if(outboundlist.size()>0)
        {     
            Database.SaveResult[] srList = Database.insert(outboundlist,false);
            for (integer i=0; i<srList.size();i++) 
            {
                if(srList[i].isSuccess())
                {
                    successids.add(srList[i].id);
                }                        
            }
        }
        System.debug('Update outbound list'+UpdateoutboundList);
        if(UpdateoutboundList.size()>0)
        {
            Database.SaveResult[] srList1 = Database.update(UpdateoutboundList,false); 
            for (integer i=0; i<srList1.size();i++) 
            {
                if(srList1[i].isSuccess())
                {
                    system.debug('success');
                }
                else
                {
                    for(Database.Error err : srList1[i].getErrors())
                    {                             errorIds1.add(srList1[i].id);                             errMessage1.put(srList1[i].Id,err.getMessage());
                    } 
                }                       
            }
            if(!errorIds1.IsEmpty())
            {
                for(integer i=0;i<errorIds1.size();i++)
                {                    errorFile = errorFile + errorIds1[i]+','+ errMessage1.get(errorIds1[i]) + ',' +'\n';                       sendMail = true;                    
                }
                
            }  
        }
        if(splacelist.size()>0)
        {
            Database.SaveResult[] srList2 = Database.update(splacelist,false); 
            for (integer i=0; i<srList2.size();i++) 
            {
                if(srList2[i].isSuccess())
                {
                    system.debug('success');
                }
                else
                {
                    for(Database.Error err : srList2[i].getErrors())
                    {                             errorIds2.add(srList2[i].id);                             errMessage2.put(srList2[i].Id,err.getMessage());
                    } 
                }                       
            }
            if(!errorIds2.IsEmpty())
            {
                for(integer i=0;i<errorIds2.size();i++)
                {                    errorFile = errorFile + errorIds2[i]+','+ errMessage2.get(errorIds2[i]) + ',' +'\n';                     sendMail = true;                    
                }
                
            }   
        }
        if(externalworkerlist.size()>0)
        {
            Database.SaveResult[] srList3 = Database.update(externalworkerlist,false); 
            for (integer i=0; i<srList3.size();i++) 
            {
                if(srList3[i].isSuccess())
                {
                    system.debug('success');
                }
                else
                {
                    for(Database.Error err : srList3[i].getErrors())
                    {           errorIds3.add(srList3[i].id);                             errMessage3.put(srList3[i].Id,err.getMessage());
                    } 
                }                       
            }
            if(!errorIds3.IsEmpty())
            {
                for(integer i=0;i<errorIds3.size();i++)
                {    errorFile = errorFile + errorIds3[i]+','+ errMessage3.get(errorIds3[i]) + ',' +'\n';                      sendMail = true;                    
                }
                
            }   
        }
        if(internalworkerlist.size()>0)
        {
            Database.SaveResult[] srList4 = Database.update(internalworkerlist,false); 
            for (integer i=0; i<srList4.size();i++) 
            {
                if(srList4[i].isSuccess())
                {
                    system.debug('success');
                }
                else
                {
                    for(Database.Error err : srList4[i].getErrors())
                    {  errorIds4.add(srList4[i].id);                             errMessage4.put(srList4[i].Id,err.getMessage());
                    } 
                }                       
            }
            if(!errorIds4.IsEmpty())
            {
                for(integer i=0;i<errorIds4.size();i++)
                {   errorFile = errorFile + errorIds4[i]+','+ errMessage4.get(errorIds4[i]) + ',' +'\n';                       sendMail = true;                    
                }
                
            }   
        }
        
        
        if(!successids.isEmpty())
        {
            List<IP_OutboundDataTransfer__c> oblist = [Select id,IP_OriginRecordID__c,LastModifieddate,CreatedDate from IP_OutboundDataTransfer__c where id in:successids];
            for(IP_OutboundDataTransfer__c ol: oblist)
            {
                sirenum__Timesheet_Line__c tline = new sirenum__Timesheet_Line__c(id=ol.IP_OriginRecordID__c,IP_OutboundID__c= ol.id,IP_Outbounddatawrite__c = ol.CreatedDate,IP_InvokeTrigger__c = FALSE);
                updatetimelist.add(tline);
            }
            update updatetimelist;
        }
        
        
        if(!Timesheetid.isEmpty())
        {
            
            List<sirenum__Timesheet__c> timesheetupdate = [Select id,IP_EmergencyPull__c,Emergency_Pull_User__c from sirenum__Timesheet__c where id in:Timesheetid];
            for(sirenum__Timesheet__c ts:timesheetupdate)
            {
                if(!paycheck.Run_Parallel_Payroll__c)
                {
                    ts.IP_EmergencyPull__c = false;
                }
                // ts.Emergency_Pull_User__c = '';
            }
            update timesheetupdate;
        }
        
        
        
        if(!checkids.isEmpty())
        {
            List<sirenum__Timesheet_Line__c> tllistupdate = [Select id,IP_InvokeTrigger__c from sirenum__Timesheet_Line__c where id in:checkids];
            for(sirenum__Timesheet_Line__c t:tllistupdate)
            {       t.IP_InvokeTrigger__c = false;
            }
            update tllistupdate;
        }
        
        
        
        /*if(timelist.size()>updatetimelist.size())
{
System.debug('check updatelist'+updatetimelist);
System.debug('check checkids'+checkids);
for(integer i=0;i<timelist.size();i++)
{
if(!updatetimelist.contains(timelist[i]) && !checkids.contains(timelist[i].id))
{
errorIds5.add(timelist[i].id);
}
}
}*/
        
        if(!errorIds5.IsEmpty())
        {
            for(integer i=0;i<errorIds5.size();i++)
            {   
                errorFile = errorFile + errorIds5[i]+','+ 'Error inserting OutboundData' + ',' +'\n';                      
                sendMail = true;                    
            }
            
        }   
        
        if(sendMail == true)
        {
            Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();
            
            blob errBlob = blob.valueof(errorFile);               errAtt.setFileName('Timesheet Failed_Records.csv');            errAtt.setBody(errBlob);
            
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
            String subject ='Timesheet - Outbound Transfer Failure';            email.setSubject(subject);            String[] toAddresses = new String[] {emailid};
                email.setToAddresses(toAddresses);            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
            
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
}