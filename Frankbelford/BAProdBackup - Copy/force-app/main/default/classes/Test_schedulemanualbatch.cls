@istest
public class Test_schedulemanualbatch {

     @istest static void testmanualbatchschedule(){
        
        Test.StartTest();
        Schedule_manualsheetbatch sh1 = new Schedule_manualsheetbatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test manualbatch', sch, sh1);
        Test.stopTest();
    }
    
}