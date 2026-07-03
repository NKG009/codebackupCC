/*
 * Author: Theertha
 * Date: 22nd August 2024
 * Jira : https://targetrecruit.atlassian.net/issues/WAVE-371
*/
global class CredentialStatusUpdateScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        CredentialStatusUpdateBatch batch = new CredentialStatusUpdateBatch();
        Database.executeBatch(batch);
    }
}