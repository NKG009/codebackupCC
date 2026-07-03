global class ProcessJobOffersBatch implements Database.Batchable<sObject>,Database.Stateful{
String query = 'SELECT Id, sirenum__Status__c FROM sirenum__Shift_Invitation__c';
Public List<String> selectedJOIdLst = new List<String>();
Public Set<Id> updatedJOSetId = new Set<Id>();
    
global ProcessJobOffersBatch(List<sirenum__Shift_Invitation__c> selectedRows){
        for(sirenum__Shift_Invitation__c eachJO:selectedRows){
               selectedJOIdLst.add(eachJO.Id);
        }
        if (!selectedJOIdLst.isEmpty()) {
            query += ' WHERE Id IN : selectedJOIdLst' ;
        }
}
    
global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sirenum__Shift_Invitation__c> scope) {
        
        for(sirenum__Shift_Invitation__c eachJO : scope) {
            eachJO.sirenum__Status__c = 'Complete';
            List<Database.SaveResult> srList = Database.update(scope,false);
             // Iterate through each returned result
        for(Database.SaveResult saveRes: srList) {
                if (saveRes.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                   updatedJOSetId.add(saveRes.getId());
                } else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : saveRes.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Job Offer fields that affected this error: ' + err.getFields());
                    }
                }
        }
        }
        
       
    }
    global void finish(Database.BatchableContext BC) {
        /*batchjobsch__Batch_Job_Log__c jobLog = new batchjobsch__Batch_Job_Log__c(batchjobsch__Batch_Job_Name__c='ProcessJobOffersBatch',
                                                                                batchjobsch__Execution_Result__c=String.valueOf(updatedJOSetId));
        insert jobLog;*/
    }
}