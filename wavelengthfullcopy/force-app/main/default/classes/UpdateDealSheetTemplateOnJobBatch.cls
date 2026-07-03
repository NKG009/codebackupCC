/**
* Author: Ranjith
* Date: 20/12/2023
* Description: Batch apex to update DealSheet Template from Account to Job
* Case No. : UPP-61  
**/
public class UpdateDealSheetTemplateOnJobBatch implements Database.Batchable <sObject> {
    
    public Database.QueryLocator start (Database.BatchableContext bc) {
        String query = 'SELECT Id, AVTRRT__Deal_Sheet_Template__c, AVTRRT__Account_Job__r.Deal_Sheet_Template__c '+
            'FROM AVTRRT__Job__c WHERE AVTRRT__Deal_Sheet_Template__c = null AND AVTRRT__Account_Job__r.Deal_Sheet_Template__c != null AND '+
            'AVTRRT__Bill_Rate__c != null AND AVTRRT__Start_Date__c != null AND AVTRRT__Closed__c = false AND'+ 
            ' AVTRRT__End_Date__c != null AND AVTRRT__State__c != null AND AVTRRT__Job_Postal_Code__c != null';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<AVTRRT__Job__c> jobs) {
        Id jobID = System.enqueueJob(new UpdateDealSheetTemplateOnJobQueueable(jobs));
    }
    
    public void finish(Database.BatchableContext BC) { }
}