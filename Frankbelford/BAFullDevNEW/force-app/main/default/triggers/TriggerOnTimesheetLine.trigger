/**
* UPDATED by Musaddekur Rahman on 23/09/2020 for 2nd Tier Pay Rate calculation
* ADDED: TimesheetLineTriggerHandler.apply2ndTierPayRate(trigger.new)
* */

trigger TriggerOnTimesheetLine on sirenum__Timesheet_Line__c (before insert,after insert,after update,before update) {

    Set<id> tlset = new Set<id>();
    Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll');

    if(!Payroll.Batch_check__c) {
        if(Trigger.isInsert && Trigger.isBefore){
            Long startTime = Limits.getCpuTime();
			// JIRA Ticket # PTI-576.
            TimesheetLineTriggerHandler.updateHoursOnRateTypeChange(trigger.new, trigger.oldMap, true);

            TimesheetLineTriggerHandler.handleBeforeInsert(trigger.new);
            System.debug('trigger.new:: ' + trigger.new);
            TimesheetLineTriggerHandler.apply2ndTierPayRate(trigger.new);
            System.debug('trigger.new:: ' + trigger.new);
            Long endTime = Limits.getCpuTime();
            System.debug('==================== Before insert CPU Consume time : '+ (endTime - startTime) + ' ms');
        }

        if(Trigger.isInsert && Trigger.isAfter && Util.stopQueueableRunAgain){
            
            Long startTime = Limits.getCpuTime();
            
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
            
            Long endTime = Limits.getCpuTime();
            System.debug('==================== After Insert CPU Consume time : '+ (endTime - startTime) + ' ms');
        }

        /**** Before Delete Trigger Merged- Payroll Performance ****/
        if(Trigger.isUpdate && Trigger.isAfter){
            System.debug('===================== After Update');
            Long startTime = Limits.getCpuTime();
            
            boolean ratecodechange = false;
            List<sirenum__Timesheet_Line__c> tlist = [Select id,IP_TimesheetSplitCheck__c,IP_TempestRateCode__c,sirenum__Timesheet__r.IP_FlaggingCheck__c,IP_InvokeTrigger__c,sirenum__Timesheet__r.IP_DuplicateCheckPassOK__c,IP_Locktimesheet__c,sirenum__Timesheet__r.sirenum__Site__r.sirenum__Operating_Company__r.IP_InvoicingMethod__c  from sirenum__Timesheet_Line__c where id in: Trigger.new];

            for(sirenum__Timesheet_Line__c tl:tlist){
                sirenum__Timesheet_Line__c tlold =  Trigger.oldMap.get(tl.Id);
                if(tlold.IP_TempestRateCode__c != tl.IP_TempestRateCode__c){
                    ratecodechange = true;
                }
                System.debug('============== ratecodechange :'+ratecodechange);
                System.debug('============== tl.IP_TimesheetSplitCheck__c :'+tl.IP_TimesheetSplitCheck__c);
                System.debug('============== tl.sirenum__Timesheet__r.IP_FlaggingCheck__c :'+tl.sirenum__Timesheet__r.IP_FlaggingCheck__c);
                System.debug('============== IP_DuplicateCheckPassOK__c :'+tl.sirenum__Timesheet__r.IP_DuplicateCheckPassOK__c);
                System.debug('============== IP_Locktimesheet__c :'+tl.IP_Locktimesheet__c);
                if(tl.IP_InvokeTrigger__c == TRUE){
                    system.debug('check site value'+tl.sirenum__Timesheet__r.sirenum__Site__r.sirenum__Operating_Company__r.IP_InvoicingMethod__c);
                    if((tl.IP_TimesheetSplitCheck__c == TRUE
                            && tl.sirenum__Timesheet__r.IP_FlaggingCheck__c == TRUE
                            && tl.sirenum__Timesheet__r.IP_DuplicateCheckPassOK__c == TRUE
                            && tl.IP_Locktimesheet__c == FALSE
                            && tl.sirenum__Timesheet__r.sirenum__Site__r.sirenum__Operating_Company__r.IP_InvoicingMethod__c == 'Standard')
                            || (tl.sirenum__Timesheet__r.IP_FlaggingCheck__c == TRUE
                                && tl.sirenum__Timesheet__r.IP_DuplicateCheckPassOK__c == TRUE
                                && tl.IP_Locktimesheet__c == FALSE
                                && tl.sirenum__Timesheet__r.sirenum__Site__r.sirenum__Operating_Company__r.IP_InvoicingMethod__c != 'Standard')){
                        tlset.add(tl.id);
                    }
                    System.debug('check tlset'+tl);
                }
            }
            System.debug('============== tlset :'+tlset.size());
            if(!tlset.isEmpty()){
                if(checkRecurTimesheetline.runOnce() || ratecodechange == true){
                    Timesheetdatatransfer.sendtldata(tlset);
                }
            }
            Long endTime = Limits.getCpuTime();
            System.debug('==================== After Update CPU Consume time : '+ (endTime - startTime) + ' ms');
        }
        if(Trigger.isUpdate && Trigger.isBefore){
            System.debug('===================== Before Update');
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