@isTest
public class Test_ConsentRecieve{
 @isTest static  void testGetCallout1() {
        
        Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert client;     
                insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
    
         Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
     candidate.IP_Last_Consent_Requested__c = System.now();
       Insert candidate;
     
      
   
      Test.startTest();
      Test.setMock(HttpCalloutMock.class, new CandidateconsentCallMock(candidate.id));
        ScheduleConsentReceivedate sh1 = new ScheduleConsentReceivedate();
        
        String sch = '0 31 * * * ?'; 
        system.schedule('Test Shift batch', sch, sh1); 
     Test.stopTest();          
    }
    
}