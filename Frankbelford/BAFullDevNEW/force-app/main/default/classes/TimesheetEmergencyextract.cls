public class TimesheetEmergencyextract {
      public static void createoutbounddata(Set<id> emergencytl){
          System.debug('check timelist set-->'+emergencytl);
            IP_CompanyCode__c Ccode = IP_CompanyCode__c.getValues('CompanyCode');
      List<sirenum__Timesheet_Line__c> updatetimelist = new List<sirenum__Timesheet_Line__c>();   
       Set<String> branchset = new Set<String>();
        boolean checkpassed = false;
        Set<id> updatetimesheet = new set<id>();
       Set<id> successids = new Set<id>();
      List<IP_OutboundDataTransfer__c> outboundList = new List<IP_OutboundDataTransfer__c>();
      List<IP_OutboundDataTransfer__c> UpdateoutboundList = new List<IP_OutboundDataTransfer__c>();
       IP_Parallel_Payroll_Check__c paycheck = IP_Parallel_Payroll_Check__c.getValues('RunParallelCheck');
      List<IP_BranchStatus__c> branchlist = [Select id,IP_BranchID__c from IP_BranchStatus__c];
 
        for(IP_BranchStatus__c b:branchlist)
        {
            branchset.add(b.IP_BranchID__c);
        }        
    List<sirenum__Timesheet_Line__c> timelist = [Select id,sirenum__Timesheet__r.Emergency_Pull_User__c,IP_OutboundID__c,Sirenum__Shift__r.sirenum__Contact__r.IP_LastPassedToTempest2ndTier__c,Sirenum__Shift__r.sirenum__Contact__r.IP_TimesheetIDLink__c,Sirenum__Shift__r.sirenum__Contact__r.IP_FirstPassExternalWorker__c,Sirenum__Shift__r.sirenum__Contact__r.IP_Pass2ndTierToTempest__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__r.IP_LastPassedToTempest__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__r.IP_TimesheetIDLink__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__r.IP_FirstPass__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__r.IP_PassToTempest__c,sirenum__Timesheet__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_LastPassedToTempest__c,Sirenum__Shift__r.Sirenum__Placement__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_PassToTempest__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_FirstPass__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_TimesheetIDLink__c,Name,sirenum__Timesheet__r.sirenum__Lines__c,sirenum__Shift__r.sirenum__Placement__r.IP_AssignmentRef__c,sirenum__Overtime_Rate__c,sirenum__Timesheet__r.sirenum__Week_Ending__c,sirenum__Rate_Line__r.sirenum__Standard_Rate_Name__c,sirenum__Hours__c,sirenum__Shift__r.Approved_By__r.Name,IP_RateCodes__c,Adhoc_Formula__c,sirenum__Date__c,sirenum__Timesheet__r.sirenum__Worker__r.name,IP_EdiRateCode__c,IP_LastPassedToTempest__c,sirenum__Timesheet__r.sirenum__Client__r.Name,sirenum__Shift__r.sirenum__Contact__c,sirenum__Shift__r.sirenum__Contact__r.RecordType.Name,IP_PurchaseOrderNumber__c,Sirenum__Charge__c,Sirenum__Shift__r.Sirenum__Site__r.IP_ClientIDLegacy__c,Sirenum__Rate__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_Consultant2PercentageSplit__c,sirenum__Shift__r.Approved_Date_Time__c, Sirenum__Shift__r.sirenum__Site__r.IP_MainContact__r.Name,sirenum__Shift__r.Sirenum__Placement__r.IP_AssignmentRefForTempest__c,sirenum__Shift__r.sirenum__Placement__r.IP_Consultant1IDnumberSplitShare__c, sirenum__Timesheet__r.sirenum__Site__r.IP_Timesheet_Method__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_Consultant1PercentageSplit__c,sirenum__Shift__r.sirenum__Placement__r.IP_Consultant2IDnumberSplitShare__c,sirenum__Shift__r.sirenum__Placement__r.IP_TempestDepartment__c,sirenum__Shift__r.sirenum__Placement__r.IP_WorkerPayrollRef__c,sirenum__Shift__r.sirenum__Placement__r.sirenum__End_Date__c,sirenum__Shift__r.sirenum__Placement__r.sirenum__Start_Date__c,sirenum__Shift__r.sirenum__Site__r.Name,sirenum__Shift__r.sirenum__Team__r.sirenum__Job_Type__r.Name,IP_PresentedPayrollDateDateType__c,IP_PayrollPresentedTimesheetNumber__c,sirenum__Shift__r.sirenum__Placement__r.IP_TempestDivision__c,sirenum__Shift__r.sirenum__Placement__r.IP_AWRJobCat__c, sirenum__Shift__r.sirenum__Placement__r.IP_AWRCoreCat__c from sirenum__Timesheet_Line__c where IP_TempestDepartment__c in :branchset and IP_RateCodes__c!='WT' and IP_HoldTimeSheetLine__c = false and (IP_PayrollPresentedRateCode__c!='' OR IP_PayrollPresentedRateCode__c!=null) and sirenum__Timesheet__c in: emergencytl];
    System.debug('check timelist-->'+timelist);
    for(sirenum__Timesheet_Line__c tl: timelist)
    {
        if(tl.IP_OutboundID__c != null)
        {
            IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
            ob.id= tl.IP_OutboundID__c;
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
        ob.IP_EmergencyPull__c = TRUE;
       
        if(tl.sirenum__Timesheet__r.Emergency_Pull_User__c == 'Emergency_Payroll')
        {
            ob.IP_Passed__c = 'PASSING';
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
             updateoutboundlist.add(ob);
              updatetimesheet.add(tl.sirenum__Timesheet__c);
        }
        else
        {
        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();        ob.IP_Rate__c = tl.Sirenum__Rate__c;        ob.IP_Consultant_2_Percentage_Split__c = String.valueOf(tl.Sirenum__Shift__r.Sirenum__Placement__r.IP_Consultant2PercentageSplit__c);
        ob.IP_Main_ContactName__c = tl.Sirenum__Shift__r.sirenum__Site__r.IP_MainContact__r.Name;        ob.IP_AssignmentRef__c = tl.sirenum__Shift__r.Sirenum__Placement__r.IP_AssignmentRefForTempest__c;        ob.IP_Consultant_1_ID_number__c = tl.sirenum__Shift__r.sirenum__Placement__r.IP_Consultant1IDnumberSplitShare__c;        ob.IP_Commission_Split__c = String.valueOf(tl.Sirenum__Shift__r.Sirenum__Placement__r.IP_Consultant1PercentageSplit__c);
        ob.IP_Consultant_2_ID_number__c = tl.sirenum__Shift__r.sirenum__Placement__r.IP_Consultant2IDnumberSplitShare__c;        ob.IP_Tempest_Department__c = tl.sirenum__Shift__r.sirenum__Placement__r.IP_TempestDepartment__c;        ob.IP_WorkerPayroll_Ref__c = tl.sirenum__Shift__r.sirenum__Placement__r.IP_WorkerPayrollRef__c;        ob.IP_Placement_End_Date__c = tl.sirenum__Shift__r.sirenum__Placement__r.sirenum__End_Date__c;
        ob.IP_Placement_Start_Date__c = tl.sirenum__Shift__r.sirenum__Placement__r.sirenum__Start_Date__c;        ob.IP_SiteName__c = tl.sirenum__Shift__r.sirenum__Site__r.Name;        ob.IP_Job_Type_Name__c = tl.sirenum__Shift__r.sirenum__Team__r.sirenum__Job_Type__r.Name;        ob.IP_Presented_payroll_date__c = tl.IP_PresentedPayrollDateDateType__c;
        ob.IP_Payroll_Presented_TimesheetNumber__c = tl.IP_PayrollPresentedTimesheetNumber__c;        ob.IP_Hours__c = tl.sirenum__Hours__c;        ob.IP_Tempest_Division__c = tl.sirenum__Shift__r.sirenum__Placement__r.IP_TempestDivision__c;        ob.IP_AWR_Job_Cat__c = tl.sirenum__Shift__r.sirenum__Placement__r.IP_AWRJobCat__c;
        ob.IP_AWR_Core_Cat__c = tl.sirenum__Shift__r.sirenum__Placement__r.IP_AWRCoreCat__c;        ob.IP_TransferType__c = 'Timesheet';        ob.IP_Adhoc_Formula__c = tl.Adhoc_Formula__c;        ob.IP_PayrollPresentedRateCode__c = tl.IP_EdiRateCode__c;
        ob.IP_Invoice_PO_Number__c = tl.IP_PurchaseOrderNumber__c;        ob.IP_Charge__c = tl.Sirenum__Charge__c;        ob.IP_Client_ID_Legacy__c = tl.Sirenum__Shift__r.Sirenum__Site__r.IP_ClientIDLegacy__c;         string assignment = tl.sirenum__Shift__r.sirenum__Placement__r.IP_AssignmentRef__c;
        ob.IP_AssignmentNumber__c = assignment.abbreviate(10);        ob.IP_OriginRecordID__c = tl.id;        ob.IP_RowCount__c = tl.sirenum__Timesheet__r.sirenum__Lines__c;         ob.IP_CandidateName__c = tl.sirenum__Timesheet__r.sirenum__Worker__r.name;
        ob.IP_ClientName__c = tl.sirenum__Timesheet__r.sirenum__Client__r.Name;        ob.IP_WeekendingDate__c = tl.sirenum__Timesheet__r.sirenum__Week_Ending__c;        ob.IP_CandidateID__c = tl.sirenum__Shift__r.sirenum__Placement__r.IP_WorkerPayrollRef__c;        ob.IP_PO__c = tl.IP_PurchaseOrderNumber__c;
        ob.IP_RateCode__c = tl.IP_EdiRateCode__c;        ob.IP_TimsheetID__c = tl.IP_PayrollPresentedTimesheetNumber__c;        ob.IP_PayrollMethod__c = tl.sirenum__Timesheet__r.sirenum__Site__r.IP_Timesheet_Method__c;        ob.IP_Date__c = tl.sirenum__Date__c;
        ob.IP_TimesheetID__c = tl.sirenum__Timesheet__c;
         // ob.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;
                ob.IP_EmergencyPull__c = TRUE;
       if(tl.sirenum__Timesheet__r.Emergency_Pull_User__c == 'Emergency_Payroll')
        {
            ob.IP_Passed__c = 'PASSING';
        }
        if(tl.sirenum__Overtime_Rate__c == True)
              {
                  ob.IP_RateDescription__c = 'Overtime Hours';
              }
              else if(tl.IP_RateCodes__c != null)
              {
                  String RCode = tl.IP_RateCodes__c;                  List<String> rate = RCode.split('/');                 ob.IP_RateDescription__c = rate[0];
              }
              else{
                 ob.IP_RateDescription__c = tl.sirenum__Rate_Line__r.sirenum__Standard_Rate_Name__c;
              }
              ob.IP_Unit__c = tl.sirenum__Hours__c;
              if(tl.sirenum__Shift__r.Approved_Date_Time__c == null ){               ob.IP_ApprovalStamp__c = tl.sirenum__Shift__r.Approved_By__r.Name;
              }
              else
              {
              ob.IP_ApprovalStamp__c = tl.sirenum__Shift__r.Approved_By__r.Name +' '+tl.sirenum__Shift__r.Approved_Date_Time__c; 
              }
            outboundList.add(ob);            updatetimesheet.add(tl.sirenum__Timesheet__c);
        }
    }
    if(outboundlist.size()>0)
    {     
    Database.SaveResult[] srList = Database.insert(outboundlist,false);
      for (integer i=0; i<srList.size();i++) 
            {                if(srList[i].isSuccess())
                    {
                        successids.add(srList[i].id);
                    }                        
            }
    } 
    if(UpdateoutboundList.size()>0)
    {
        Database.SaveResult[] srList = Database.update(UpdateoutboundList,false);
    }
    if(!successids.isEmpty())
{
    List<IP_OutboundDataTransfer__c> oblist = [Select id,IP_OriginRecordID__c,LastModifieddate from IP_OutboundDataTransfer__c where id in:successids];
    for(IP_OutboundDataTransfer__c ol: oblist)
    {        sirenum__Timesheet_Line__c tline = new sirenum__Timesheet_Line__c(id=ol.IP_OriginRecordID__c,IP_OutboundID__c= ol.id,IP_Outbounddatawrite__c = ol.LastModifieddate,IP_InvokeTrigger__c = FALSE);        updatetimelist.add(tline);
    }
    update updatetimelist;
} 

            list<sirenum__Timesheet__c> timeupdate = [Select id,IP_EmergencyPull__c,Emergency_Pull_User__c from sirenum__Timesheet__c where id in:updatetimesheet];
            for(sirenum__Timesheet__c t:timeupdate)
            {
               if(!paycheck.Run_Parallel_Payroll__c)
               {
                t.IP_EmergencyPull__c  = false;
                }
               // t.Emergency_Pull_User__c = '';
            }
            update timeupdate;
        }
        public static void test123()
        {
            Integer ab = 12;
            Integer ab1 = 12;
            Integer ab2 = 12;
            Integer ab3 = 12;
            Integer ab4 = 12;
            Integer ab5 = 12;
            Integer ab6 = 12;
            Integer ab7 = 12;
            Integer ab8 = 12;
            Integer ab9 = 12;
            Integer ab0 = 12;
            Integer ab12 = 12;
            Integer ab14 = 12;
            Integer abc = 12;
            Integer abc1 = 12;
            Integer abc2 = 12;
            Integer abc3 = 12;
            Integer abc4 = 12;
            Integer abc5 = 12;
            Integer abc6 = 12;
            Integer abc7 = 12;
            Integer abc8 = 12;
            Integer abc9 = 12;
            Integer abc0 = 12;
            Integer abc12 = 12;
            Integer abc14 = 12; 
            
        }
    }