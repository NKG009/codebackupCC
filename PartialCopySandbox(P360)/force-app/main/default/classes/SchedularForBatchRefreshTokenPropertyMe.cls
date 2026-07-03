public class SchedularForBatchRefreshTokenPropertyMe Implements Schedulable{
      public static String batchJobName = 'BatchRefreshTokenPropertyMe';
  
    public void execute(SchedulableContext sc){
        Database.executeBatch(new BatchRefreshTokenPropertyMe(),1);
    } 
    public static void reschedulebatch(){
        try {
             DateTime schddateandTime = system.now().addminutes(30);
            String batchSchedule = schddateandTime.second()+' ' + schddateandTime.minute() + ' ' + schddateandTime.hour() + ' ' + schddateandTime.day() + ' ' + schddateandTime.month() + ' ? ' + schddateandTime.year();
            System.schedule(batchJobName + ' at ' + +System.now().format(), batchSchedule, new SchedularForBatchRefreshTokenPropertyMe());
            
            for( CronTrigger cronTriggerItem:[Select Id From CronTrigger where NextFireTime= null AND State='DELETED' Limit 100]) {
                System.abortJob(cronTriggerItem.id);
            }
        } catch(Exception ex) {
            insert ErrorLogUtil.createSampleErrorLog(
                        null, ex.getMessage(), 'Error while processing the request:'+ ex, 'BatchRefreshTokenPropertyMe', 'reschedulebatch', null, null);
        }
        
    }

}