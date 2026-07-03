global class ScheduleBatchHeaderP45sync implements Schedulable{

    global void execute(SchedulableContext sc) {
        P45SyncB2F batchInstance = new P45SyncB2F(); 
        database.executebatch(batchInstance,1);
    }
}