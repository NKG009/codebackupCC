@istest
public class Test_Schedulecheckduplicate {
     @istest static void testduplicate(){
        
        Test.StartTest();
        Schedulecheckduplicate sh1 = new Schedulecheckduplicate();
        String sch = '0 30 * * * ?';
        system.schedule('Test duplicate', sch, sh1);
        Test.stopTest();
    }
}