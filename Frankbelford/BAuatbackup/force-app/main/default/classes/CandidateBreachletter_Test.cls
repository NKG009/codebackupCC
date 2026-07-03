@isTest
public class CandidateBreachletter_Test {
   public static testmethod void sendcandidateemail1()
    {    
   Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert client;
        
        Account act = TestDataFactory.createAccounts(1)[0]; 
        insert act;
        
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
                  insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);

         Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        candidate.Firstname = 'RestCand1';
    	Insert candidate;
        Test.startTest();
        CandidateBreachletter.sendcandidateemail(candidate.id);
        pageReference pdfPage = Page.DrivingBreachLetter;
        pdfPage.getParameters().put('id',String.valueOf(candidate.id));

       // Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
    }
}