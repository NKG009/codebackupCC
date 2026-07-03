global class ScheduleUncontactedCandidateRemoval implements Schedulable{
    
    global void execute(SchedulableContext sc){
        
        UncontactedCandidateRemoval ucr = new UncontactedCandidateRemoval();
        Database.executeBatch(ucr,50);
        
    }


}