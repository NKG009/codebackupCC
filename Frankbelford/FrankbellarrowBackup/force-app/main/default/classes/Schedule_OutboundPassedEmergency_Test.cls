@isTest
public class Schedule_OutboundPassedEmergency_Test {
     
        public static testMethod void testschedule(){
            IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
                 setting.IP_OutboundWriteBatchsize__c =   2000;
                 insert setting;
                 
        Test.StartTest();
        Schedule_OutboundPassedEmergency sh1 = new Schedule_OutboundPassedEmergency();
        String sch = '0 23 22 29 * ?';
        system.schedule('Test outboundpass1', sch, sh1);
        Test.stopTest();
        
        
        }

}