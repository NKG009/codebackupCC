global class Schedule_EscalationNotification implements Schedulable{
 Impellam_Settings__c set1 = Impellam_Settings__c.getValues('ClientEscNotification'); 
             Integer limit1 = Integer.Valueof(set1.Limit__c);
    global void execute(SchedulableContext sc) {
        ClientEscalarionNotificationPortals batchInstance = new ClientEscalarionNotificationPortals(); 
        database.executebatch(batchInstance,limit1);
    }
}