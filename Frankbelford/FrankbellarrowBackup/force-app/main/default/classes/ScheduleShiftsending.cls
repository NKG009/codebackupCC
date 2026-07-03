global class ScheduleShiftsending implements Schedulable{

    global void execute(SchedulableContext sc) {
        ShiftdetailsendingBatch shiftdetail = new ShiftdetailsendingBatch(); 
        database.executebatch(shiftdetail,1);
    }

}