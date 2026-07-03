global class ScheduleGenericBatchHeaderclass implements Schedulable{

    global void execute(SchedulableContext sc) {
        GenericBatchHeaderclass batchInstance = new GenericBatchHeaderclass(); 
        database.executebatch(batchInstance,1);
    }
}