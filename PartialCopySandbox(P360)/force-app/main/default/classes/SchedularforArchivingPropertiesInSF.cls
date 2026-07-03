public class SchedularforArchivingPropertiesInSF implements Schedulable {
     public static String batchJobName = 'BatchForArchivingPropertiesInSF';
   
  public void execute(SchedulableContext sc){
        Database.executeBatch(new BatchForArchivingPropertiesInSF(),1);
    } 
    public static void reschedulebatch(){
        try {
            //schedule next execution after 30 minutes
            DateTime schddateandTime = system.now().addminutes(30);
            String batchSchedule = schddateandTime.second()+' ' + schddateandTime.minute() + ' ' + schddateandTime.hour() + ' ' + schddateandTime.day() + ' ' + schddateandTime.month() + ' ? ' + schddateandTime.year();
            System.schedule(batchJobName + ' at ' + +System.now().format(), batchSchedule, new SchedularforArchivingPropertiesInSF());
            
            for( CronTrigger cronTriggerItem:[Select Id From CronTrigger where NextFireTime= null AND State='DELETED' Limit 100]) {
                System.abortJob(cronTriggerItem.id);
            }
        } catch(Exception ex) {
            insert ErrorLogUtil.createSampleErrorLog(
                null, ex.getMessage(), 'Error while processing the request:'+ ex, 'BatchForArchivingPropertiesInSF', 'reschedulebatch', null, null);
        }
    }

}