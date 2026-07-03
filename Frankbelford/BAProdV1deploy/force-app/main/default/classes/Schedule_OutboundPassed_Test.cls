@isTest
public class Schedule_OutboundPassed_Test {
     
        public static testMethod void testschedule(){
            IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
                 setting.IP_OutboundWriteBatchsize__c =   2000;
                 insert setting;
                 
        Test.StartTest();
        Schedule_OutboundPassed sh1 = new Schedule_OutboundPassed();
        String sch = '0 23 22 29 * ?';
        system.schedule('Test outboundpass', sch, sh1);
        Test.stopTest();
        
        
        }

}