global class ScheduleShiftAutoApprovalMonday_5pm implements schedulable{
    
    global void execute(SchedulableContext sc){
        Impellam_Settings__c batchSize = Impellam_Settings__c.getValues('ShiftAutoApproval'); 
        Integer limit1 = Integer.Valueof(batchSize.Limit__c);
        ShiftAutoApprovalMonday_5pm CA = new ShiftAutoApprovalMonday_5pm();
        database.executebatch(CA,limit1);
        
    }
    
}