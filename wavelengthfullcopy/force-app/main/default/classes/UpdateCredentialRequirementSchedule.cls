/*
 * Author: Kalpana
 * Date: 15th July 2024
 * Jira : https://targetrecruit.atlassian.net/browse/WAVE-323
*/
public class UpdateCredentialRequirementSchedule implements Schedulable{
    public void execute(SchedulableContext sc){
        UpdateCredentialRequirementBatch upCre = new UpdateCredentialRequirementBatch();
        Database.executeBatch(upCre, 10);
    }
}