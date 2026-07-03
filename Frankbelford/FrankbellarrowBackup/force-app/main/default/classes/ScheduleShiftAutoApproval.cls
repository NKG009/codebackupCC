global class ScheduleShiftAutoApproval implements schedulable{
    
    global void execute(SchedulableContext sc){
        Impellam_Settings__c batchSize = Impellam_Settings__c.getValues('ShiftAutoApproval'); 
        Integer limit1 = Integer.Valueof(batchSize.Limit__c);
        ShiftAutoApproval CA = new ShiftAutoApproval();
        database.executebatch(CA,limit1);
        
    }
    
}