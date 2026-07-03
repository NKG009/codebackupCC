global class VMSCandidateShiftPublishSchedular implements Schedulable {
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new VMSCandidateShiftPublishBatch(), 200);
    }
}