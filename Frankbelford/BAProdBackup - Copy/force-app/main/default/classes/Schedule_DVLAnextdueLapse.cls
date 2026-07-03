global class Schedule_DVLAnextdueLapse implements schedulable{
    
global void execute(SchedulableContext sc) {
DVLAnextdueLapse  batchInstance = new DVLAnextdueLapse (); 
database.executebatch(batchInstance,1);
}
}