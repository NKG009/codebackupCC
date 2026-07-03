public class SiteRecordCreationSchedulable Implements Schedulable {
    public static String batchJobName = 'SiteRecordCreationBatch';
    public datetime creddate;
    
    public SiteRecordCreationSchedulable( datetime batch){
        this.creddate=batch;
    }
    public void execute(SchedulableContext sc){
        Database.executeBatch(new SiteRecordCreationBatch(creddate));
    } 
    public static void reschedulebatch(datetime batchsrttme){
        try {
            //schedule next execution after a minute
            DateTime schddateandTime = system.now().addminutes(5);
            String batchSchedule = schddateandTime.second()+' ' + schddateandTime.minute() + ' ' + schddateandTime.hour() + ' ' + schddateandTime.day() + ' ' + schddateandTime.month() + ' ? ' + schddateandTime.year();
            System.schedule(batchJobName + ' at ' + +System.now().format(), batchSchedule, new SiteRecordCreationSchedulable(batchsrttme));
            
            for( CronTrigger cronTriggerItem:[Select Id From CronTrigger where NextFireTime= null AND State='DELETED' Limit 100]) {
                System.abortJob(cronTriggerItem.id);
            }
        } catch(Exception ex) {
            insert ErrorLogUtil.createSampleErrorLog(
                null, ex.getMessage(), 'Error while processing the request:'+ ex, 'SiteRecordCreationSchedulable', 'reschedulebatch', null, null);
        }
    }
}