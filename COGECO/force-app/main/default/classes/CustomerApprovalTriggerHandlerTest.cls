@isTest
public class CustomerApprovalTriggerHandlerTest {

    @testSetup
    static void setTestData() {
        insert new Run_Rules__c(Run_Triggers__c = true);
        
        // Create test data for Accounts
        List<Account> testAccounts = new List<Account>();
        testAccounts.add(new Account(Name = 'Test Account 1'));
        testAccounts.add(new Account(Name = 'Test Account 2'));
        insert testAccounts;
        
         System_Values__c customSetting = new System_Values__c(
            Name = 'Quote Communications Language Default',
            Value__c = 'English'
        );
        
        insert customSetting;
        
        Contact testContact = new Contact(
        	FirstName = 'Test',
            LastName = 'Contact',
            AccountId = testAccounts[0].Id,
            Email = 'testcogeco@example.com.apextest'
        );
        
        insert testContact;

        // Create test data for Opportunities
        List<Opportunity> testOpportunities = new List<Opportunity>();
        testOpportunities.add(new Opportunity(Name = 'Test Opportunity 1', AccountId = testAccounts[0].Id, StageName = 'Qualification', CloseDate = Date.today(), Opp_Customer_Category__c = 'Large'));
        testOpportunities.add(new Opportunity(Name = 'Test Opportunity 2', AccountId = testAccounts[1].Id, StageName = 'Qualification', CloseDate = Date.today().addDays(30), Opp_Customer_Category__c = 'Large'));
        insert testOpportunities;
        
        OpportunityContactRole contactRole = new OpportunityContactRole(
        	OpportunityId = testOpportunities[0].Id,
            ContactId = testContact.Id,
            Role = 'Decision Maker'
        );
        
        insert contactRole;

        // Create test data for Quotes
        List<Quote> testQuotes = new List<Quote>();
        testQuotes.add(new Quote(Name = 'Test Quote 1', OpportunityId = testOpportunities[0].Id));
        testQuotes.add(new Quote(Name = 'Test Quote 2', OpportunityId = testOpportunities[1].Id));
        insert testQuotes;

        // Create test data for Customer_Approval__c records
        List<Customer_Approval__c> testApprovals = new List<Customer_Approval__c>();
        testApprovals.add(new Customer_Approval__c(Quote__c = testQuotes[0].Id));
        testApprovals.add(new Customer_Approval__c(Quote__c = testQuotes[1].Id));
        // Insert the test Customer_Approval__c records
        insert testApprovals;
    }

    @isTest
    static void testSetDefaultValues() {
		List<Customer_Approval__c> testApprovals = [SELECT Id, Quote__c, Verification_Code__c FROM Customer_Approval__c];
        
        Test.startTest();
        CustomerApprovalTriggerHandler.setDefaultValues(testApprovals);
        Test.stopTest();
        
        for (Customer_Approval__c approval : testApprovals) {
            System.assertEquals(Request.getCurrent().getRequestId(), approval.Verification_Code__c);
        }
    }
    
    @isTest
    static void testSetDefaultValuesEmpty() {
		List<Customer_Approval__c> testApprovals = new List<Customer_Approval__c>();
        
        Test.startTest();
        CustomerApprovalTriggerHandler.setDefaultValues(testApprovals);
        Test.stopTest();
        
        for (Customer_Approval__c approval : testApprovals) {
            System.assertEquals(Request.getCurrent().getRequestId(), approval.Verification_Code__c);
        }
    }
}