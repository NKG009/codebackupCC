@istest
public class Test_Schedule_EscalationNotification {
 @istest static void testescalation(){
          Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'ClientEscNotification', Limit__c = '50');
        insert set1;
        Test.StartTest();
        Schedule_EscalationNotification sh1 = new Schedule_EscalationNotification();
        String sch = '0 23 22 29 * ?';
        system.schedule('Test Notification', sch, sh1);
        Test.stopTest();
    }
}