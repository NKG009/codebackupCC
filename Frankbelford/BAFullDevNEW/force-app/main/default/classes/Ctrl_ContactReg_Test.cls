@isTest
public class Ctrl_ContactReg_Test {
    @TestSetup
    static void prepareTest(){
        Account accountcan = TestDataFactory.createCandidateAccount(1)[0];
        Insert accountcan;
        TestDataFactory.setupCustomSettings(accountcan.Id);
        TestDataFactory.setupUserProfileCustomSettings();
        //TestDataFactory.loadJSFormData(); We dont have loadJSFormData method.
    }
    public static testmethod void contactsearchtest(){
        Test.starttest();
        Account client = TestDataFactory.createClients(1)[0]; 
        Insert client;
        Account account = TestDataFactory.createAccounts(1)[0];
        Insert account;
        Account accountcan = [SELECT Id, Name FROM Account WHERE Name='Candidates' AND RecordType.DeveloperName = 'Candidate' LIMIT 1];
        Contact cont = TestDataFactory.createContact(client.id, 1)[0]; 
        cont.MailingPostalCode='E1 2AA';
        Insert cont;

        Contact candidate = TestDataFactory.createCandidate(accountcan.id, 1)[0];
        candidate.PORTW_Completed__c =true;    
        candidate.Medical_Completed__c =true;    
        candidate.Declaration_Completed__c=true;    
        candidate.TOE_Completed__c =true;    
        candidate.New_Starter_Form__c=true;    
        candidate.Equal_Opportunity_Completed__c=true;
        candidate.MailingPostalCode='Q1 2UU';
        Insert candidate;
        
        IP_TopazGlobalClientInformation__c createtopaz = new IP_TopazGlobalClientInformation__c();
        createtopaz.name = 'TestClient2';
        createtopaz.IP_StatusID__c = 1;
        createtopaz.IP_SalesLedgerNumber__c='123456';
        insert createtopaz;

        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        
        IP_PayProfile__c payprofile2 = new IP_PayProfile__c();
        payprofile2.RecordTypeId = payRTId;

        PageReference pageRef = Page.Candidate_registration;
        Test.setCurrentPage(pageRef); 
        Ctrl_ContactReg testAccPlan = new Ctrl_ContactReg();
        testAccPlan.firstname = cont.FirstName;
        testAccPlan.lastname = cont.lastname;
        testAccPlan.dob = cont.Birthdate;
        testAccPlan.searchContacts();
        testAccPlan.Clearfilter();

        Test.stopTest();
    }
}