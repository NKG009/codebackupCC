@isTest
public class ScheduleDeletionAction_Test {
   public static testMethod void testschedule(){
     
          Test.StartTest();
        ScheduleDeletionAction sh1 = new ScheduleDeletionAction();
        String sch = '0 23 22 29 * ?';
        system.schedule('Test GDPRDeletion', sch, sh1);
        Test.stopTest();

    }
}