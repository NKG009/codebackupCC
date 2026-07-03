global class ScheduleRefreshCompliance implements Schedulable{

global void execute(SchedulableContext sc) {
RefreshComplianceForActiveCandidate  batchInstance = new RefreshComplianceForActiveCandidate (); 
database.executebatch(batchInstance,5);

}
}