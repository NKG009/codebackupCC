@isTest
public class ConsentCallTest {
 @isTest static  void testGetCallout() {
        
      // Contact candidate = [Select id from contact limit 1];
        Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert client;         
         Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
     Insert candidate;
     
       Test.setMock(HttpCalloutMock.class, new CandidateconsentCallMock1 ());

        Test.startTest();
        CandidateConsentcall.sendcall(candidate.id);
     Test.stopTest();
     //   string s =    CandidateConsentcall.sendrequest1('tasdgw',candidate.id);
    // system.debug('string returned: ' + s);          
    }   
    
}