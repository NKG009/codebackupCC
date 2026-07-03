@isTest
private class GuidanceInstructionsControllerTest {

    @isTest
    static void testGetGuidanceInstructions() {
        // Fetch or create an existing RecordType with DeveloperName 'SMB'
        RecordType recordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'SMB' LIMIT 1];
        System.assertNotEquals(null, recordType, 'The RecordType with DeveloperName SMB should exist in the org.');

        Account testAccount = new Account(
            Name = 'Test Account',
            RecordTypeId = recordType.Id
        );
        insert testAccount;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = System.today().addDays(30),
            AccountId = testAccount.Id
        );
        insert testOpportunity;

        Quote testQuote = new Quote(
            Name = 'Test Quote',
            OpportunityId = testOpportunity.Id, 
            Status = 'Draft'
        );
        insert testQuote;

        Guided_Instruction__c guidanceInstruction = new Guided_Instruction__c(
            Object__c = 'Account',  
            Target_Audience__c = 'SMB',
            Instructions__c = '<p>Instructions for Test Quote</p>',
            Language__c = UserInfo.getLanguage()
        );
        insert guidanceInstruction;

        Test.startTest();
        String result = GuidanceInstructionsController.getGuidanceInstructions(
            testQuote.Id,
            'Account',
            'Account.RecordType.DeveloperName'
        );
        Test.stopTest();

        // Assert the result
        System.assertEquals('<p>Instructions for Test Quote</p>', result, 'The returned guidance instructions should match the input data.');
    }
}