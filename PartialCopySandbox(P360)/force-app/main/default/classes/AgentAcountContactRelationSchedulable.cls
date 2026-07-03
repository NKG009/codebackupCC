public class AgentAcountContactRelationSchedulable Implements Schedulable{
    public static String batchJobName = 'BatchUpdateAgentAcountContactRelation';
    //public Static List<String> batchState=new List<String>{'WAITING','ACQUIRED','EXECUTING'};
    public void execute(SchedulableContext sc){
        Database.executeBatch(new BatchUpdateAgentAcountContactRelation(),Integer.valueOf(System.label.BatchSchedulerTotal));
    } 
    public static void reschedulebatch(){
        try {
           
            DateTime schddateandTime = system.now().addminutes(Integer.valueOf(System.label.BatchSchedulerDuration));
             String batchSchedule = schddateandTime.second()+' ' + schddateandTime.minute() + ' ' + schddateandTime.hour() + ' ' + schddateandTime.day() + ' ' + schddateandTime.month() + ' ? ' + schddateandTime.year();
            System.schedule(batchJobName + ' at ' + +System.now().format(), batchSchedule, new AgentAcountContactRelationSchedulable());
            
            for( CronTrigger cronTriggerItem:[Select Id From CronTrigger where NextFireTime= null AND State='DELETED' Limit 100]) {
                System.abortJob(cronTriggerItem.id);
            }
           
        } catch(Exception ex) {
            insert ErrorLogUtil.createSampleErrorLog(
                        null, ex.getMessage(), 'Error while processing the request:'+ ex, 'AgentAcountContactRelationSchedulable', 'reschedulebatch', null, null);
        }
        
    }
}