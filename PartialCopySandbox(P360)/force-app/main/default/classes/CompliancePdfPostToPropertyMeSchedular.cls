public class CompliancePdfPostToPropertyMeSchedular implements Schedulable {
    
    public void execute(SchedulableContext sc){
        callingbatchclass();
    }


  public static void callingbatchclass(){
        set<id> AccParentidlist = new set<id>();
        for(WorkOrderId__c woid : [select name,AccountParentID__c from WorkOrderId__c]){
            
            AccParentidlist.add(woid.AccountParentID__c);
         } 
        system.debug('WorkOrderId__c data '+AccParentidlist);
        for( id accid : AccParentidlist ){
            Database.executeBatch(new CompliancePdfPostToPropertyMeBatch(accid),1);
        }
      // reschedulebatch();
    
}
   /*public static void reschedulebatch(){
      string batchJobName='CompliancePdfPostToPropertyMe';
        try {
             DateTime schddateandTime = system.now().addminutes(60);
            String batchSchedule = schddateandTime.second()+' ' + schddateandTime.minute() + ' ' + schddateandTime.hour() + ' ' + schddateandTime.day() + ' ' + schddateandTime.month() + ' ? ' + schddateandTime.year();
            System.schedule(batchJobName + ' at ' + +System.now().format(), batchSchedule, new CompliancePdfPostToPropertyMeSchedular());
            
            for( CronTrigger cronTriggerItem:[Select Id From CronTrigger where NextFireTime= null AND State='DELETED' Limit 100]) {
                System.abortJob(cronTriggerItem.id);
            }
        } catch(Exception ex) {
            insert ErrorLogUtil.createSampleErrorLog(
                        null, ex.getMessage(), 'Error while processing the request:'+ ex, 'BatchRefreshTokenPropertyMe', 'reschedulebatch', null, null);
        }
        
    }  */
}   
/*global class CompliancePdfPostToPropertyMeBatchParent implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string query='select name,AccountParentID__c from WorkOrderId__c';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, list<WorkOrderId__c> AllWOIds ) {
        set<id> AccParentidlist = new set<id>();
        for(WorkOrderId__c woid : AllWOIds){
            AccParentidlist.add(woid.AccountParentID__c);
         } 
        
        for( id accid : AccParentidlist ){
            
        }
       
    }
    global void finish(Database.BatchableContext BC){  
        
    }
}*/