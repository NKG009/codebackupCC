/**
* Date: 20/12/2023
* Description: Queueable apex to overcome Future method cannot be called from a future or batch method from AVTRRT.DealSheetTrigger
* Case No. : UPP-61  
**/
public class UpdateDealSheetTemplateOnJobQueueable implements Queueable {
    
    List<AVTRRT__Job__c> jobs;
    
    public UpdateDealSheetTemplateOnJobQueueable(List<AVTRRT__Job__c> jobs){
        this.jobs = jobs;
    }
    
    public void execute(QueueableContext context) {
        for (AVTRRT__Job__c job : jobs) {
               job.AVTRRT__Deal_Sheet_Template__c = job.AVTRRT__Account_Job__r.Deal_Sheet_Template__c;             
        }
        try {
            update jobs;
        }
        catch (System.Exception ex) {
            System.debug('@@Ex'+ex.getStackTraceString());
        }
    }
}