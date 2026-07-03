/**
* Date: Monday, 10th August 2020
* Author: Musaddekur Rahman
* Description: This scheduler class is used to create Schedule Task records.
*/
global class AddScheduleTaskToGenerateTimesheet implements Schedulable {
	global void execute(SchedulableContext ctx) {
        Boolean noPendingTask = true;
        Datetime scheduleTime = Datetime.now();

        Integer interval = Integer.valueOf(Impellam_Settings__c.getValues('AutoTimesheetInterval').Limit__c);
        if(IdentifyShiftForPayrollProcessing.scheduleTheTask()) {
            Map<String, String> configString = IdentifyShiftForPayrollProcessing.getConfiguration();
            System.debug('AddScheduleTaskToGenerateTimesheet - execute - configString.size - ' + configString.size());

            List<sirenum__Scheduled_Task__c> sTasks = new List<sirenum__Scheduled_Task__c>();
            List<sirenum__Scheduled_Task__c> existingTasks = [SELECT Name, sirenum__Task_Type__c, sirenum__Executing__c, sirenum__Configuration__c
                                                              FROM sirenum__Scheduled_Task__c WHERE sirenum__Task_Type__c = 'Timesheet Generation' AND
                                                              sirenum__Last_Run_Time__c = null AND sirenum__Scheduled_Time__c >=: scheduleTime];
            Integer i = 1;
            for(String configKey : configString.keySet()) {
                // This is to ensure that schedule tasks are not overlapping.
                if(i == 14) {
                    break;
                }
                i++;

                String siteName = configKey;
                Id ownerId = UserInfo.getUserId();
                if((configKey.split('>>>>')).size() > 0) {
                    siteName = configKey.split('>>>>')[0];
                    ownerId = (Id)configKey.split('>>>>')[1];
                }

                for(sirenum__Scheduled_Task__c st : existingTasks) {
                    if(st.Name == siteName) {
                        noPendingTask = false;
                        break;
                    }
                }

                if(noPendingTask) {
                    sTasks.add(new sirenum__Scheduled_Task__c(
                        Name = siteName.length() > 80 ? siteName.left(79) : siteName,
                        sirenum__Scheduled_Time__c = scheduleTime,
                        sirenum__Task_Type__c = 'Timesheet Generation',
                        sirenum__Configuration__c = configString.get(configKey),
                        OwnerId = ownerId,
                        CreatedById = ownerId
					));
                    scheduleTime = scheduleTime.addMinutes(interval);
                }
            }

            if(sTasks.size() > 0) {
                insert sTasks;
                System.debug('AddScheduleTaskToGenerateTimesheet - execute - sTasks.size - ' + sTasks.size());
            }
            else {
                System.debug('AddScheduleTaskToGenerateTimesheet - execute - No approved shift found to create scheduled tasks.');
            }
        }
        else {
            System.debug('AddScheduleTaskToGenerateTimesheet - execute - No new tasks was due to existing task is in execution.');
        }

        // Delete historical records older then 2 weeks.
        List<sirenum__Scheduled_Task__c> historicalScheduledTasks = [SELECT Name, sirenum__Task_Type__c, sirenum__Executing__c, sirenum__Configuration__c
                                                                     FROM sirenum__Scheduled_Task__c WHERE sirenum__Task_Type__c = 'Timesheet Generation' AND
                                                                     sirenum__Last_Run_Time__c != null AND CreatedDate <= LAST_N_WEEKS:2];
        delete historicalScheduledTasks;
    }
}