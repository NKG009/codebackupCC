@istest
public class ScheduleShopDirectbatch_Test {

     @istest static void testcapitaschedule1(){
        
        Test.StartTest();
        ScheduleShopDirectbatch sh1 = new ScheduleShopDirectbatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test Shop', sch, sh1);
        Test.stopTest();
    }
    @istest static void testcapitaschedule2(){
        
        Test.StartTest();
        ScheduleShopDirectbatchflex sh1 = new ScheduleShopDirectbatchflex();
        String sch = '0 30 * * * ?';
        system.schedule('Test Shop1', sch, sh1);
        Test.stopTest();
    }
     @istest static void testcapitaschedule3(){
        
        Test.StartTest();
        ScheduleShopDirectravenmillbatch sh1 = new ScheduleShopDirectravenmillbatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test Shop2', sch, sh1);
        Test.stopTest();
    }
      @istest static void testcapitaschedule4(){
        
        Test.StartTest();
        ScheduleShopDirectravenmillamendbatch sh1 = new ScheduleShopDirectravenmillamendbatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test Shop2', sch, sh1);
        Test.stopTest();
    }
    @istest static void testcapitaschedule5(){
        
        Test.StartTest();
        ScheduleShopDirectspekebatch  sh1 = new ScheduleShopDirectspekebatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test Shop3', sch, sh1);
        Test.stopTest();
    }
      @istest static void testcapitaschedule6(){
        
        Test.StartTest();
        ScheduleShopDirectspekeamendbatch   sh1 = new ScheduleShopDirectspekeamendbatch ();
        String sch = '0 30 * * * ?';
        system.schedule('Test Shop4', sch, sh1);
        Test.stopTest();
    }
    @istest static void testcapitaschedule7(){
        
        Test.StartTest();
        ScheduleShopDirectlittlehultonbatch sh1 = new ScheduleShopDirectlittlehultonbatch  ();
        String sch = '0 30 * * * ?';
        system.schedule('Test Shop5', sch, sh1);
        Test.stopTest();
    }
    @istest static void testcapitaschedule8(){
        
        Test.StartTest();
        ScheduleShopDirectlittlehultonamendbatch sh1 = new ScheduleShopDirectlittlehultonamendbatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test Shop6', sch, sh1);
        Test.stopTest();
    }
    @istest static void testcapitaschedule9(){
        
        Test.StartTest();
        ScheduleShopDirectcroalmillbatch  sh1 = new ScheduleShopDirectcroalmillbatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test Shop7', sch, sh1);
        Test.stopTest();
    }
    @istest static void testcapitaschedule10(){
        
        Test.StartTest();
        ScheduleShopDirectcroalmillamendbatch sh1 = new ScheduleShopDirectcroalmillamendbatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test Shop8', sch, sh1);
        Test.stopTest();
    }
    @istest static void testcapitaschedule11(){
        
        Test.StartTest();
        ScheduleShopDirectfmbatch sh1 = new ScheduleShopDirectfmbatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test Shop9', sch, sh1);
        Test.stopTest();
    }
    @istest static void testcapitaschedule12(){
        
        Test.StartTest();
        ScheduleShopDirectfmamendbatch sh1 = new ScheduleShopDirectfmamendbatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test Shop10', sch, sh1);
        Test.stopTest();
    }
     @istest static void testcapitaschedule13(){
        
        Test.StartTest();
        ScheduleShopDirectinternalsbatch sh1 = new ScheduleShopDirectinternalsbatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test Shop11', sch, sh1);
        Test.stopTest();
    }
     @istest static void testcapitaschedule14(){
        
        Test.StartTest();
        ScheduleShopDirectinternalsamendbatch sh1 = new ScheduleShopDirectinternalsamendbatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test Shop11', sch, sh1);
        Test.stopTest();
    }
    
    
}