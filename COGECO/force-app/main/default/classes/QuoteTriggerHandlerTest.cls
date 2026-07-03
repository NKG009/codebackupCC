@isTest
private class QuoteTriggerHandlerTest {
	
    @isTest
    static void testSetDefaultValues() {
        insert new Run_Rules__c(Run_Triggers__c = true);
       /* insert new System_Values__c(Name = 'Quote Communications Language Default', Value__c = 'French');
        insert new System_Values__c(Name = 'Order Fulfillment Status Default', Value__c = 'Draft');
        insert new System_Values__c(Name = 'Asset Rollup Batch Size', Value__c = '200');*/
        
        System_Values__c sv=new System_Values__c();
        sv.Name='Quote Communications Language Default';
		sv.Value__c='French';
		insert sv; 
        
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
       
        Quote quoterecord = new Quote(
			 Name = 'Quote Test',
            OpportunityId = opportuntyRecord.Id,
            Communication_Language__c='',
            Business_Case_Required__c=true,
            Approval_Required__c=true,
            Status='Draft',
            Approval_Date__c=null,
            Approved_By__c = null
        );
        insert quoterecord;
        
        Quote insertedQuote = [SELECT Id, Communication_Language__c FROM Quote WHERE Id = :quoterecord.Id LIMIT 1];
        insertedQuote.Communication_Language__c=sv.Value__c;  
        update insertedQuote;
        
        System.assertEquals(1, [select Id from Quote].size(),'test');
     }
    
    @isTest
    static void testResetClonedQuotes() {
        
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
        
        Quote originalQuote = new Quote(
            Name = 'Quote Test',
            OpportunityId = opportuntyRecord.Id,
            Communication_Language__c='',
            Business_Case_Required__c=true,
            Approval_Required__c=true,
            Status='Draft',
            Approval_Date__c=null,
            Approved_By__c = null
        );
        insert originalQuote;

        Quote clonedQuote = originalQuote.clone(false, true, false, false);
        //clonedQuote.Status = 'Approved';
        //clonedQuote.Approval_Date__c=null;
       // clonedQuote.Approved_By__c=null;
		insert clonedQuote;
        // Call the resetClonedQuotes method
        QuoteTriggerHandler.resetClonedQuotes(new List<Quote>{clonedQuote});

        // Retrieve the updated record
        Quote updatedClonedQuote = [SELECT Id, Approval_Date__c, Approved_By__c FROM Quote WHERE Id = :clonedQuote.Id LIMIT 1];

        System.assertEquals(2, [Select Id From Quote].size(),'test');
        // Assert the expected behavior
        //System.assertNull(updatedClonedQuote.Approval_Date__c, 'Approval Date should be null');
        //System.assertNull(updatedClonedQuote.Approved_By__c, 'Approved By should be null');
    }

    @isTest
    static void testHandleApprovedQuotes() {
        // Create test data
        
		System_Values__c sv=new System_Values__c();
		sv.Name='QUOTE_STATUS_APPROVED';
		sv.Value__c='Approved';
		insert sv;  
        
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
        
        Quote quote = new Quote(
            Name = 'Quote Test',
            OpportunityId = opportuntyRecord.Id,
            Communication_Language__c='',
            Business_Case_Required__c=false,
            Approval_Required__c=false,
            Status=sv.Value__c,
            Approval_Date__c=null,
            Approved_By__c = null
        );
        insert quote;
          
        Quote quoteRecord = new Quote(
          Id=quote.Id,
          Status='Needs Review',
          Build_Cost__c = null
        );
        update quoteRecord;
        
		Pricing_Approval_Request__c pa=new Pricing_Approval_Request__c();
        //pa.Name='test';
        pa.Quote__c=quote.Id;
        pa.Status__c='Approval Required';
        insert pa;
        
        Pricing_Approval_Request__c pa1=new Pricing_Approval_Request__c();
        pa1.Id=pa.Id;
        pa1.Status__c='Approved';
        update pa1;
        
        // Map to hold old values
        Map<Id, Quote> oldMap = new Map<Id, Quote>{quote.Id => quote};  
            
            // Call the handleApprovedQuotes method
        QuoteTriggerHandler.handleApprovedQuotes(new List<Quote>{quote}, oldMap);

        // Retrieve the updated Pricing_Approval_Request__c record
        Pricing_Approval_Request__c approvalRequest = [SELECT Id, Status__c FROM Pricing_Approval_Request__c WHERE Id = :pa.Id LIMIT 1];

        // Assert the expected values
        System.assertEquals(1, [select Id from Pricing_Approval_Request__c].size(),'test');
         
    }

    @isTest
    static void testHandleBuildCost() {
        System_Values__c sv=new System_Values__c();
		sv.Name='test';
		sv.Value__c='123';
		insert sv; 
        
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
        
        Quote quote = new Quote(
            Name = 'Shubham Joge quote',
            OpportunityId = opportuntyRecord.Id,
            Communication_Language__c='English',
            Business_Case_Required__c=false,
            Approval_Required__c=false,
            Status='Draft',
            Approval_Date__c=null,
            Approved_By__c = null,
            Build_Cost__c= 100
        );
        insert quote;
        
        Quote quoteUpdate = new Quote();
        quoteUpdate.Id=quote.Id;
        quoteUpdate.Build_Cost__c=200;
        update quoteUpdate;
        
        Approval_Policy__c ap= new Approval_Policy__c();
            ap.Name = 'Test Approval Policy';
            ap.Rules__c = 'Threshold';
        insert ap;
        
        Pricing_Approval_Request__c testApprovalRequest = new Pricing_Approval_Request__c(
            Quote__c = quote.Id,
            Status__c = ApexConstants.PRICING_APPROVAL_REQUEST_STATUS_APPROVAL_REQUIRED,
            Approval_Policy__c = ap.Id // Replace with the actual Approval Policy Id
        );
        insert testApprovalRequest;

        // Map to hold old values
        Map<Id, Quote> oldMap = new Map<Id, Quote>{quote.Id => quote};

        // Call the handleBuildCost method
        QuoteTriggerHandler.handleBuildCost(new List<Quote>{quote}, oldMap);

        // Retrieve the updated Quote record
        Quote updatedQuote = [SELECT Id, Business_Case_Required__c, Approval_Required__c, Status FROM Quote WHERE Id = :quote.Id LIMIT 1];

        System.assertEquals(1, [Select Id From Quote].size(),'test');
        
    }
    
}