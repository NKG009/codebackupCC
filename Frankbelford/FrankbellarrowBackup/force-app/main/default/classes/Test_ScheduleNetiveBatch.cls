@isTest

public class Test_ScheduleNetiveBatch {
 @istest static void testNetive(){
        
        Test.StartTest();
        ScheduleNetivebatch sh1 = new ScheduleNetivebatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test Netive', sch, sh1);
        Test.stopTest();
    }
}