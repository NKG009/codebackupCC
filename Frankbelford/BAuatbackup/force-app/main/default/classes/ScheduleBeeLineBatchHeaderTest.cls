@istest
public class ScheduleBeeLineBatchHeaderTest {

     @istest static void testBeelineSchedule(){
        
        Test.StartTest();
        ScheduleBeeLineBatchHeaderClass sh1 = new ScheduleBeeLineBatchHeaderClass();
        String sch = '0 0 * ? * TUE-WED';
        String sch1 = '0 30 * ? * TUE-WED';
        system.schedule('Test Beeline'+System.now(), sch, sh1);
        system.schedule('Test Beeline1'+System.now(), sch1, sh1);
        Test.stopTest();
    }

}