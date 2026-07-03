/**
* UPDATED by Musaddekur Rahman on 23/09/2020 for 2nd Tier Pay Rate calculation
* ADDED: TimesheetLineTriggerHandler.apply2ndTierPayRate(trigger.new)
* */

trigger TriggerOnTimesheetLine on sirenum__Timesheet_Line__c (before insert,after insert,after update,before update) {

    Set<id> tlset = new Set<id>();
    Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll');

    if(!Payroll.Batch_check__c) {
        if(Trigger.isInsert && Trigger.isBefore){
			// JIRA Ticket # PTI-576.
            TimesheetLineTriggerHandler.updateHoursOnRateTypeChange(trigger.new, trigger.oldMap, true);

            TimesheetLineTriggerHandler.handleBeforeInsert(trigger.new);
            System.debug('trigger.new:: ' + trigger.new);
            TimesheetLineTriggerHandler.apply2ndTierPayRate(trigger.new);
            System.debug('trigger.new:: ' + trigger.new);
        }

        if(Trigger.isInsert && Trigger.isAfter && Util.stopQueueableRunAgain){
            Set<id> Timesheetset = new Set<id>();
            List<sirenum__Timesheet_line__c> tllist = new List<sirenum__Timesheet_line__c>();
            for(sirenum__Timesheet_Line__c tl:Trigger.new) {
                Timesheetset.add(tl.sirenum__Timesheet__c);
            }
            if(!Timesheetset.isEmpty()){
                tllist = [Select id,IP_OutboundID__c,sirenum__Timesheet__r.sirenum__Lines__c from sirenum__Timesheet_line__c where sirenum__Timesheet__c in:Timesheetset and IP_OutboundID__c != null and IP_Locktimesheet__c = false];
            }
            if(tllist.size()>0){
                UpdateTimesheetrowcount.updatedata(tllist);
            }
            Util.stopQueueableRunAgain = false;
            System.enqueueJob(new QueableSplitTimesheetLine(Trigger.newMap.keySet()));
        }
        
        /**** Before Delete Trigger Merged- Payroll Performance ****/
        if(Trigger.isUpdate && Trigger.isAfter){
            
            List<sirenum__Timesheet_Line__c> lstTimesheetLine = new List<sirenum__Timesheet_Line__c>();
            for(sirenum__Timesheet_Line__c tl : trigger.new){
                if(tl.IP_InvokeTrigger__c == TRUE && tl.IP_Locktimesheet__c == FALSE && tl.IP_RateCodes__c != 'WT' && (tl.IP_PayrollPresentedRateCode__c !='' || tl.IP_PayrollPresentedRateCode__c != NULL) ){
                    lstTimesheetLine.add(tl);
                }
            }
            
            if(lstTimesheetLine.size() > 0){
                List<sirenum__Timesheet_Line__c> lstUpdatedTimesheetLine = new List<sirenum__Timesheet_Line__c>();
                Set<String> setBranchId = new Set<String>();
                for(IP_BranchStatus__c b : [SELECT Id, IP_BranchID__c FROM IP_BranchStatus__c]){
                    setBranchId.add(b.IP_BranchID__c);
                } 
                
                for(sirenum__Timesheet_Line__c tl : [SELECT Id, sirenum__Timesheet__r.IP_Mini_Payroll__c,sirenum__Timesheet__r.Emergency_Pull_User__c,sirenum__Timesheet__r.IP_EmergencyPull__c,IP_OutboundID__c,
                                                     Sirenum__Shift__r.sirenum__Contact__r.IP_LastPassedToTempest2ndTier__c,Sirenum__Shift__r.sirenum__Contact__r.IP_TimesheetIDLink__c,
                                                     Sirenum__Shift__r.sirenum__Contact__r.IP_FirstPassExternalWorker__c,Sirenum__Shift__r.sirenum__Contact__r.IP_Pass2ndTierToTempest__c,
                                                     Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__r.IP_LastPassedToTempest__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__c,
                                                     Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__r.IP_TimesheetIDLink__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__r.IP_FirstPass__c,
                                                     Sirenum__Shift__r.Sirenum__Placement__r.IP_PayMethod__r.IP_PassToTempest__c,sirenum__Timesheet__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_LastPassedToTempest__c,
                                                     Sirenum__Shift__r.Sirenum__Placement__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_PassToTempest__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_FirstPass__c,
                                                     Sirenum__Shift__r.Sirenum__Placement__r.IP_TimesheetIDLink__c,Name,sirenum__Timesheet__r.sirenum__Lines__c,sirenum__Shift__r.sirenum__Placement__r.IP_AssignmentRef__c,
                                                     sirenum__Overtime_Rate__c,sirenum__Timesheet__r.sirenum__Week_Ending__c,sirenum__Rate_Line__r.sirenum__Standard_Rate_Name__c,sirenum__Hours__c,sirenum__Shift__r.Approved_By__r.Name,
                                                     IP_RateCodes__c,Adhoc_Formula__c,sirenum__Date__c,sirenum__Timesheet__r.sirenum__Worker__r.name,IP_EdiRateCode__c,IP_LastPassedToTempest__c,sirenum__Timesheet__r.sirenum__Client__r.Name,
                                                     sirenum__Shift__r.sirenum__Contact__c,sirenum__Shift__r.sirenum__Contact__r.RecordType.Name,IP_PurchaseOrderNumber__c,Sirenum__Charge__c,Sirenum__Shift__r.Sirenum__Site__r.IP_ClientIDLegacy__c,
                                                     Sirenum__Rate__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_Consultant2PercentageSplit__c,sirenum__Shift__r.Approved_Date_Time__c, Sirenum__Shift__r.sirenum__Site__r.IP_MainContact__r.Name,
                                                     sirenum__Shift__r.Sirenum__Placement__r.IP_AssignmentRefForTempest__c,sirenum__Shift__r.sirenum__Placement__r.IP_Consultant1IDnumberSplitShare__c, 
                                                     sirenum__Timesheet__r.sirenum__Site__r.IP_Timesheet_Method__c,Sirenum__Shift__r.Sirenum__Placement__r.IP_Consultant1PercentageSplit__c,
                                                     sirenum__Shift__r.sirenum__Placement__r.IP_Consultant2IDnumberSplitShare__c,sirenum__Shift__r.sirenum__Placement__r.IP_TempestDepartment__c,
                                                     sirenum__Shift__r.sirenum__Placement__r.IP_WorkerPayrollRef__c,sirenum__Shift__r.sirenum__Placement__r.sirenum__End_Date__c,sirenum__Shift__r.sirenum__Placement__r.sirenum__Start_Date__c,
                                                     sirenum__Shift__r.sirenum__Site__r.Name,sirenum__Shift__r.sirenum__Team__r.sirenum__Job_Type__r.Name,IP_PresentedPayrollDateDateType__c,IP_PayrollPresentedTimesheetNumber__c,
                                                     sirenum__Shift__r.sirenum__Placement__r.IP_TempestDivision__c,sirenum__Shift__r.sirenum__Placement__r.IP_AWRJobCat__c, 
                                                     sirenum__Shift__r.sirenum__Placement__r.IP_AWRCoreCat__c,Sirenum__Shift__r.Sirenum__Site__r.Unit_ID__c, IP_TimesheetSplitCheck__c, IP_TempestRateCode__c, sirenum__Timesheet__r.IP_FlaggingCheck__c,
                                                     IP_InvokeTrigger__c, sirenum__Timesheet__r.IP_DuplicateCheckPassOK__c, IP_Locktimesheet__c,
                                                     sirenum__Timesheet__r.sirenum__Site__r.sirenum__Operating_Company__r.IP_InvoicingMethod__c 
                                                     FROM sirenum__Timesheet_Line__c 
                                                     WHERE IP_TempestDepartment__c IN : setBranchId 
                                                     AND Id IN : lstTimesheetLine]){
                                                         if((tl.IP_TimesheetSplitCheck__c == TRUE 
                                                             && tl.sirenum__Timesheet__r.IP_FlaggingCheck__c == TRUE 
                                                             && tl.sirenum__Timesheet__r.sirenum__Site__r.sirenum__Operating_Company__r.IP_InvoicingMethod__c == 'Standard')
                                                            || (tl.sirenum__Timesheet__r.IP_FlaggingCheck__c == TRUE
                                                                && tl.sirenum__Timesheet__r.IP_DuplicateCheckPassOK__c == TRUE 
                                                                && tl.sirenum__Timesheet__r.sirenum__Site__r.sirenum__Operating_Company__r.IP_InvoicingMethod__c != 'Standard')){
                                                                    lstUpdatedTimesheetLine.add(tl);
                                                                }                               
                                                     }
                if(lstUpdatedTimesheetLine.size() > 0){
                    Timesheetdatatransfer.createOutboundRecords(lstUpdatedTimesheetLine);                    
                }
            } 
        }
        
        if(Trigger.isUpdate && Trigger.isBefore){
			// JIRA Ticket # PTI-576.
            TimesheetLineTriggerHandler.updateHoursOnRateTypeChange(trigger.new, trigger.oldMap, false);

            TimesheetLineTriggerHandler.handleupdatesplitting(trigger.new, trigger.oldMap);
            Profile adminId = [SELECT Id from Profile where Name='System Administrator' LIMIT 1];
            Set<id> tlset = new Set<id>();
            Set<id> Timeset= new Set<id>();
            for(sirenum__Timesheet_Line__c tl :Trigger.new){
                tlset.add(tl.id);
            }
            List<IP_OutboundDataTransfer__c> outlist = [Select id,IP_OriginRecordID__c,IP_Passed__c
                                                          from IP_OutboundDataTransfer__c
                                                         where IP_Passed__c != null
                                                           and IP_OriginRecordID__c in :tlset];
            for(IP_OutboundDataTransfer__c ot:outlist){
                Timeset.add(ot.IP_OriginRecordID__c);
            }
            for(integer i=0;i<trigger.new.size();i++){
                if(Timeset.contains(trigger.new[i].id) && UserInfo.getProfileId() != adminId.id){
                    trigger.new[i].adderror('Timesheet is locked, data is passed to Payroll');
                }
            }
        }
    }
}