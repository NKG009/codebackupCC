@isTest
public class ScheduleUnworkedCandidateRemoval_Test {
   @TestSetup static void setupData() {
 IP_ImpellamGDPRSettings__c obj = new IP_ImpellamGDPRSettings__c(Name = 'Impellam GDPR settings' ,IP_UnworkedCandidateDataRetentionPeriod__c=360);
  insert obj;
 }
   public static testMethod void testschedule(){
     
          Test.StartTest();
        ScheduleUnworkedCandidateRemoval sh1 = new ScheduleUnworkedCandidateRemoval();
        String sch = '0 47 21 29 * ?';
        system.schedule('Test GDPRUnworked', sch, sh1);
        Test.stopTest();

    }

}