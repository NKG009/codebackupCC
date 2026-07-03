@isTest
public class ScheduleUncontactedCandidateRemoval_Test {
     @TestSetup static void setupData() {
  IP_ImpellamGDPRSettings__c obj = new IP_ImpellamGDPRSettings__c (Name='Impellam GDPR settings',IP_ActivityTypesThatQualifyAsContact__c='Visit,Registration,General Call ,Send Email ,Send Contract',IP_UncontactedCandidateRetentionPeriod__c=-10); 
   insert obj;
 }
   public static testMethod void testschedule(){
     
          Test.StartTest();
        ScheduleUncontactedCandidateRemoval sh1 = new ScheduleUncontactedCandidateRemoval();
        String sch = '0 47 21 29 * ?';
        system.schedule('Test GDPRUncontacted', sch, sh1);
        Test.stopTest();

    }
}