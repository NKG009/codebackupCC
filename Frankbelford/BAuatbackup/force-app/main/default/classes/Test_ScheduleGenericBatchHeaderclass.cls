@istest
public class Test_ScheduleGenericBatchHeaderclass {

     @istest static void testgenericschedule(){
        
        Test.StartTest();
        ScheduleGenericBatchHeaderclass sh1 = new ScheduleGenericBatchHeaderclass();
        String sch = '0 30 * * * ?';
        system.schedule('Test generic', sch, sh1);
        Test.stopTest();
    }
    
}