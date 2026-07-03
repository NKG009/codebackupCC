global class ScheduleDrivinghoursbreachBatch implements schedulable{
    
global void execute(SchedulableContext sc) {
DrivinghoursbreachBatch  batchInstance = new DrivinghoursbreachBatch (); 
database.executebatch(batchInstance,1);
}

}