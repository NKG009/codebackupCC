@isTest
public class Test_UpdateDataStore  {
 @isTest static  void testGetCallout() {
        Set<id> conid = new Set<id>();
        Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert client;   
                insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
      
         Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
     Insert candidate;
     conid.add(candidate.id);
       Test.setMock(HttpCalloutMock.class, new CandidateconsentCallMock1 ());

        Test.startTest();
        UpdateDataStore.sendconsentdata(conid);
     Test.stopTest();
     //   string s =    CandidateConsentcall.sendrequest1('tasdgw',candidate.id);
    // system.debug('string returned: ' + s);          
    }   
    
}