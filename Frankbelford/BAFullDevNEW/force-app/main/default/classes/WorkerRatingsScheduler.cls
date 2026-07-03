/**
 * Copyright Sirenum Ltd 2022
 * 
 * Invokes batch class to calculate Average Worker Rating for all Accounts
 * 
 */

global class WorkerRatingsScheduler implements sirenum.CustomScheduled {
    global void execute() {
        Integer batchSize = 200; //Default batch size

        try { //Attempt to set batch size from settings if they exist
            batchSize = (Integer)Worker_Rating_Setting__mdt.getInstance('Default').Batch_Size__c;
        } catch (Exception e) {}
        
        Database.executeBatch(new WorkerRatingsBatch(), batchSize);
    }
}