public class CredentialStatusUpdateBatchController {
    
   @AuraEnabled
    public static String runBatch(){

		List<AsyncApexJob> jobs = new List<AsyncApexJob>();
        
        jobs = [ SELECT Id, Status
        FROM AsyncApexJob
        WHERE JobType = 'BatchApex'
        AND ApexClass.Name ='CredentialStatusUpdateBatch'
        AND Status IN ('Queued', 'Preparing', 'Processing')
    ];
        if(jobs.isEmpty()){
            CredentialStatusUpdateBatch batch = new CredentialStatusUpdateBatch();
        	Database.executeBatch(batch);
            return 'Batch initiated successfully';
        }
        else{
            return 'Batch is already running,Kindly try after sometime.Thank you!!';
        }
        
    }

}