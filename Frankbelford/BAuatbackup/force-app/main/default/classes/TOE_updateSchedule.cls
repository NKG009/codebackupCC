global class TOE_updateSchedule implements Schedulable{

     global void execute(SchedulableContext sc) {
        TOE_Update_Batch batchInstance = new TOE_Update_Batch(); 
        database.executebatch(batchInstance,10);
    }
}