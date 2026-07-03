@istest
public class Test_ScheduleRemovebankdetails {

     @istest static void testrsschedule(){
        
        Test.StartTest();
        ScheduleRemovebankdetails sh1 = new ScheduleRemovebankdetails();
        String sch = '0 30 * * * ?';
        system.schedule('Test rs', sch, sh1);
        Test.stopTest();
    }
    
}