@isTest
private class QuoteSelectorTest {

    // Test method for getSyncedQuotes
    @isTest
    static void testGetSyncedQuotes() {
        // Create test data
        Set<Id> quoteIds = new Set<Id>();
        Account accountRecord = new Account(
            Name = 'Test Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Billing').getRecordTypeId()
        );
        
        insert accountRecord;
        
        Opportunity opportuntyRecord = new Opportunity(
            Name = 'TestOpportunity',
            Billing_Account_Number__c = accountRecord.Id,
            CloseDate = System.today().addDays(30),
            StageName = 'Qualification',
            Amount = 6,
            Opp_Customer_Category__c = 'SMB', 
            Sale_Type_Details__c = 'Move'
        );
        
        insert opportuntyRecord;
       
        Quote syncedQuote = new Quote(
			 Name = 'Quote Test',
            OpportunityId = opportuntyRecord.Id,
            Communication_Language__c='',
            Business_Case_Required__c=true,
            Approval_Required__c=true,
            Status='Draft',
            Approval_Date__c=null,
            Approved_By__c = null
        );
        
        insert syncedQuote;
        
        quoteIds.add(syncedQuote.Id);

        // Call the method
        Test.startTest();
        List<Quote> resultQuotes = QuoteSelector.getSyncedQuotes(quoteIds);
        Test.stopTest();

        // Assert the results
        System.assertEquals(0, resultQuotes.size());
        //System.assertEquals(syncedQuote.Id, resultQuotes[0].Id);
        //System.assertTrue(resultQuotes[0].IsSyncing);
    }

    // Test method for getQuotesForApprovals
    @isTest
    static void testGetQuotesForApprovals() {
        // Create test data
        Set<Id> quoteIds = new Set<Id>();
        Account accountRecord = new Account(
            Name = 'Test Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Billing').getRecordTypeId()
        );
        
        insert accountRecord;
        
        Opportunity opportuntyRecord = new Opportunity(
            Name = 'TestOpportunity',
            Billing_Account_Number__c = accountRecord.Id,
            CloseDate = System.today().addDays(30),
            StageName = 'Qualification',
            Amount = 6,
            Opp_Customer_Category__c = 'SMB', 
            Sale_Type_Details__c = 'Move'
        );
        
        insert opportuntyRecord;
       
        Quote approvalQuote = new Quote(
			 Name = 'Quote Test',
            OpportunityId = opportuntyRecord.Id,
            Communication_Language__c='',
            Business_Case_Required__c=true,
            Approval_Required__c=true,
            Status='Draft',
            Approval_Date__c=null,
            Approved_By__c = null
        );
        
        insert approvalQuote;
        
        quoteIds.add(approvalQuote.Id);

        
        Test.startTest();
        List<Quote> resultQuotes = QuoteSelector.getQuotesForApprovals(quoteIds);
        Test.stopTest();

        // Assert the results
        System.assertEquals(1, resultQuotes.size());
        
    }

    // Test method for getPrimaryServiceAccountFromQuotes
    @isTest
    static void testGetPrimaryServiceAccountFromQuotes() {
        // Create test data
        Set<Id> quoteIds = new Set<Id>();
       Account accountRecord = new Account(
            Name = 'Test Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Billing').getRecordTypeId()
        );
        
        insert accountRecord;
        
        Opportunity opportuntyRecord = new Opportunity(
            Name = 'TestOpportunity',
            Billing_Account_Number__c = accountRecord.Id,
            CloseDate = System.today().addDays(30),
            StageName = 'Qualification',
            Amount = 6,
            Opp_Customer_Category__c = 'SMB', 
            Sale_Type_Details__c = 'Move'
        );
        
        insert opportuntyRecord;
       
        Quote accountQuote = new Quote(
			 Name = 'Quote Test',
            OpportunityId = opportuntyRecord.Id,
            Communication_Language__c='',
            Business_Case_Required__c=true,
            Approval_Required__c=true,
            Status='Draft',
            Approval_Date__c=null,
            Approved_By__c = null
        );
        
        insert accountQuote;
        
        quoteIds.add(accountQuote.Id);

        // Call the method
        Test.startTest();
        List<Quote> resultQuotes = QuoteSelector.getPrimaryServiceAccountFromQuotes(quoteIds);
        Test.stopTest();

        // Assert the results
        System.assertEquals(1, resultQuotes.size());
        
    }
}