global class P45DailyProfileProcessor implements Schedulable {

    global void execute(SchedulableContext ctx) {
      Database.executeBatch(new P45DailyProfileProcessorBatch (), 1);

        
        }
    
}