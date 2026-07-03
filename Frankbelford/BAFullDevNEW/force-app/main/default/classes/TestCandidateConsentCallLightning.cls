@isTest

public class TestCandidateConsentCallLightning {
    @isTest static  void testGetCallout() {
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);

        // Contact candidate = [Select id from contact limit 1];
        Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert client;         
        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        Insert candidate;

        Test.setMock(HttpCalloutMock.class, new CandidateconsentCallMock1 ());

        Test.startTest();
        CandidateConsentCallLightning.sendcall(candidate.id);
        Test.stopTest();
        //   string s =    CandidateConsentcall.sendrequest1('tasdgw',candidate.id);
        // system.debug('string returned: ' + s);          
    }

    @isTest static  void testGetCallout1() {
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);

        // Contact candidate = [Select id from contact limit 1];
        Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert client;         
        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        Insert candidate;

        Test.setMock(HttpCalloutMock.class, new CandidateconsentCallMock1 ());

        Test.startTest();
        CandidateConsentCallLightning.updateContact(candidate.id);
        Test.stopTest();
        //   string s =    CandidateConsentcall.sendrequest1('tasdgw',candidate.id);
        // system.debug('string returned: ' + s);          
    }
    
    @isTest static  void testGetCallout2() {
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);

        // Contact candidate = [Select id from contact limit 1];
        Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert client;         
        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        Insert candidate;

        Test.setMock(HttpCalloutMock.class, new CandidateconsentCallMock1 ());

        Test.startTest();
        CandidateConsentCallLightning.getContact(candidate.id);
        Test.stopTest();
        //   string s =    CandidateConsentcall.sendrequest1('tasdgw',candidate.id);
        // system.debug('string returned: ' + s);          
    }
    
    @isTest static  void testGetCallout3() {
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);

        // Contact candidate = [Select id from contact limit 1];
        Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert client;         
        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        candidate.email = 'testuse@gmail.com';
        Insert candidate;

        Test.setMock(HttpCalloutMock.class, new CandidateconsentCallMock1 ());

        Test.startTest();
        CandidateConsentCallLightning.sendcall(candidate.id);
        Test.stopTest();
        //   string s =    CandidateConsentcall.sendrequest1('tasdgw',candidate.id);
        // system.debug('string returned: ' + s);          
    }
    
}