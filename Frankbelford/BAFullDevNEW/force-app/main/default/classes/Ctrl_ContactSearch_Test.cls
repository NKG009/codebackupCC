/**
 * Created by mrahman on 2021-02-05.
 */

@IsTest
private class Ctrl_ContactSearch_Test {
    @IsTest
    static void contactsearchtest() {
        TestDataFactory.setupUserProfileCustomSettings();
        //TestDataFactory.loadJSFormData();

        Test.starttest();
        Account client = TestDataFactory.createClients(1)[0];
        Insert client;
        Account account = TestDataFactory.createAccounts(1)[0];
        Insert account;
        Account accountcan = TestDataFactory.createCandidateAccount(1)[0];
        Insert accountcan;
        TestDataFactory.setupCustomSettings(accountcan.Id);
        Contact cont = TestDataFactory.createContact(client.id, 1)[0];
        cont.Sirenum__National_Insurance__c='AB123456C';
        Insert cont;

        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        candidate.PORTW_Completed__c =true;
        candidate.Medical_Completed__c =true;
        candidate.Declaration_Completed__c=true;
        candidate.TOE_Completed__c =true;
        candidate.New_Starter_Form__c=true;
        candidate.Equal_Opportunity_Completed__c=true;


        Insert candidate;

        IP_TopazGlobalClientInformation__c createtopaz = new IP_TopazGlobalClientInformation__c();
        createtopaz.name = 'TestClient2';
        createtopaz.IP_StatusID__c = 1;
        createtopaz.IP_SalesLedgerNumber__c='123456';
        insert createtopaz;

        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
        IP_PayProfile__c payprofile2 = new IP_PayProfile__c();
        payprofile2.RecordTypeId = payRTId;

        PageReference pageRef = Page.Contact_Search;

        Test.setCurrentPage(pageRef);
        Ctrl_ContactSearch testAccPlan = new Ctrl_ContactSearch();
        testAccPlan.firstname = cont.FirstName;
        testAccPlan.lastname = cont.lastname;
        testAccPlan.ni_number= cont.Sirenum__National_Insurance__c;
        testAccPlan.searchContacts();
        testAccPlan.Clearfilter();

        Test.stopTest();
    }
}