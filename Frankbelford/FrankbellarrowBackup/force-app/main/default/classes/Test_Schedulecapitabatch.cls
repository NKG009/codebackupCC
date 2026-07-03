@istest
public class Test_Schedulecapitabatch {

     @istest static void testcapitaschedule(){
        
        Test.StartTest();
        Schedulecapitabatch sh1 = new Schedulecapitabatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test capita', sch, sh1);
        Test.stopTest();
    }
    
}