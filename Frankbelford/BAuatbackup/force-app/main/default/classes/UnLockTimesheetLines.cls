global class UnLockTimesheetLines implements Database.Batchable<sObject>{
  global Database.QueryLocator start(Database.BatchableContext BC){
           
            String query ='select id,IP_OriginRecordID__c from IP_OutboundDataTransfer__c where IP_Passed__c = null and IP_TransferType__c = \'Timesheet\' ';
             return Database.getQueryLocator(query);
            
        }
    
    global void execute(Database.BatchableContext BC,List<IP_OutboundDataTransfer__c> scope){
		Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll'); 
		Payroll.Batch_check__c = True;
		update Payroll;
		List<sirenum__Timesheet_Line__c> updateTimeLine = new List<sirenum__Timesheet_Line__c>();
		set<Id> timelineId = new set<Id>();
		for(IP_OutboundDataTransfer__c outbound: scope)
		{
			timelineId.add(outbound.IP_OriginRecordID__c);
			
		}
		List<sirenum__Timesheet_Line__c> timeline = [Select id,IP_Outbounddatawrite__c from sirenum__Timesheet_Line__c where id in: timelineId];
		for(sirenum__Timesheet_Line__c tmline : timeline){
			tmline.IP_Outbounddatawrite__c = System.now();
			updateTimeLine.add(tmline);
		}
		
		Database.update(updateTimeLine,false);
	}
    global void finish(Database.BatchableContext BC){
		Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll'); 
		Payroll.Batch_check__c = False;
		update Payroll;
		
	}
}