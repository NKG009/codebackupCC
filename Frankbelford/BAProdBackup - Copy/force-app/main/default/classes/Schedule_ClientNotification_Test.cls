@isTest
public class Schedule_ClientNotification_Test {
     
        public static testMethod void testschedule(){
          Impellam_Settings__c set1 =  new Impellam_Settings__c(name = 'ClientPortalNotification', Limit__c = '50');
        insert set1;
        Test.StartTest();
        Schedule_ClientNotification sh1 = new Schedule_ClientNotification();
        String sch = '0 23 22 29 * ?';
        system.schedule('Test Notification', sch, sh1);
        Test.stopTest();
        
        
        }

}