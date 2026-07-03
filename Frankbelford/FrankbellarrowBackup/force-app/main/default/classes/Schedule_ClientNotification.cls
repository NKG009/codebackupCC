global class Schedule_ClientNotification implements Schedulable{
 Impellam_Settings__c set1 = Impellam_Settings__c.getValues('ClientPortalNotification'); 
             Integer limit1 = Integer.Valueof(set1.Limit__c);
    global void execute(SchedulableContext sc) {
        ClientNotificationPortals batchInstance = new ClientNotificationPortals(); 
        database.executebatch(batchInstance,limit1);
    }
}