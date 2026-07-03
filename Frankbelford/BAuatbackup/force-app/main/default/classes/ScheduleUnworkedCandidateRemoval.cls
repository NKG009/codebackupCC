global class ScheduleUnworkedCandidateRemoval implements schedulable{
    global void execute(SchedulableContext sc){
        
        UnworkedCandidateRemoval uw = new UnworkedCandidateRemoval();
        database.executebatch(uw,50);
        
    }

}