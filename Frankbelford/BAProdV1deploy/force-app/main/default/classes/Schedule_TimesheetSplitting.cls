global class Schedule_TimesheetSplitting implements Schedulable{
 global void execute(SchedulableContext SC) {
     TimesheetSplittingBatch timesplit = new TimesheetSplittingBatch(); 
      database.executebatch(timesplit,1);
 }
}