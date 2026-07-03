@isTest
public class ScheduleCriminalConvictionDetails_Test {
   public static testMethod void testschedule(){
     
          Test.StartTest();
        ScheduleCriminalConvictionDetails sh1 = new ScheduleCriminalConvictionDetails();
        String sch = '0 30 * * * ?';
        system.schedule('Test Shop', sch, sh1);
        Test.stopTest();

    }
}