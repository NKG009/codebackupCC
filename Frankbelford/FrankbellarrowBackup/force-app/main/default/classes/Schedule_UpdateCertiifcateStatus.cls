global class Schedule_UpdateCertiifcateStatus implements Schedulable{

global void execute(SchedulableContext sc) {
UpdateCertificateStatus_Lapsed  batchInstance = new UpdateCertificateStatus_Lapsed (); 
database.executebatch(batchInstance,1);

}
}