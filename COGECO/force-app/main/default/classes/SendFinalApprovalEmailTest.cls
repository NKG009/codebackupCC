@isTest
public  class SendFinalApprovalEmailTest {
    @isTest
    public static void test(){

        

        General_Settings__c setting = new General_Settings__c();
        setting.Name = 'Internal Contract Delivery Email';
        setting.Internal_Contract_Delivery_Email__c = 'test@test.com';
        insert setting;

        Account acc = TestHelper_Account.createAccount('Test Account', true);
        Opportunity opp = TestHelper_Opportunity.createOpportunity('Test Opportunity', acc.id, true);
        Contact cont = TestHelper_Contact.createContact('Job', 'Tester', 'McTester', '12341234123', '12344112123', '12121212121', 'test@test.com', acc.Id, true);
        OpportunityContactRole contactRole = new OpportunityContactRole();
        contactRole.ContactId = cont.Id;
        contactRole.IsPrimary = true;
        contactRole.Role = 'Decision Maker';
        contactRole.OpportunityId = opp.Id;
        insert contactRole;


        ContentVersion contentVersion = new ContentVersion(
                    Title          = 'EN-123',
                    PathOnClient   = 'Pic.jpg',
                    VersionData    = Blob.valueOf('Test Content'),
                    IsMajorVersion = true);
        insert contentVersion;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

    //create ContentDocumentLink  record
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = opp.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
       // EmailTemplate temp = new EmailTemplate();

       StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
       mock.setStaticResource('mockResponse');
       mock.setStatusCode(200);
       mock.setHeader('Content-Type', 'application/json');
       Test.setMock(HttpCalloutMock.class, mock);

       Test.startTest();

        opp.StageName='Customer Approved';
        update opp;

       Test.stopTest();

    }
}