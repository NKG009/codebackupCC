/*
* Class Name: ScheduleSendAutoReminderToRefree.
* Description: This is to schedule the batch class- SendAutoReminderToRefree
* Test Class: 
* Date : 5th June 2019
*/

global class ScheduleSendAutoReminderToRefree implements Schedulable{
    
    /*
    Run at 8 am everyday.
    */
    public static final String CRON_EXPR = '0 0 8 * * ? *';
    public static final String JOBNAME = 'Send Auto Reminder to Refree';
    
    /*
    * Method Name: execute.
    * Description: to execute the batch class- SendAutoReminderToRefree
    * Parameters : SchedulableContext
    * Return Type: Void
    * Date : 5th June 2019
    */
    global void execute(SchedulableContext sc) {
        SendAutoReminderToRefree batchInstance = new SendAutoReminderToRefree(); 
        database.executebatch(batchInstance,200);
    }
    
    /*
    * Method Name: scheduleIt.
    * Description: Schedule the job at 8 Am everyday
    * Parameters : SchedulableContext
    * Return Type: Void
    * Date : 5th June 2019
    */
    global static String scheduleIt() {
        ScheduleSendAutoReminderToRefree job = new ScheduleSendAutoReminderToRefree();
        return System.schedule(JOBNAME+system.now(), CRON_EXPR, job);
    }
}