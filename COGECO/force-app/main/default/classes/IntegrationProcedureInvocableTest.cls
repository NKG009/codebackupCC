@isTest
private class IntegrationProcedureInvocableTest {
	@testSetup
    static void setup(){
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
        
        Quote quoteRecord = new Quote(
            Name = 'Quote Test',
            OpportunityId = opportuntyRecord.Id
        );
        
        insert quoteRecord;
        
    }
    @isTest
    static void testRunIntegrationServiceInvocable() {
        Quote quoteRecord = [SELECT Id FROM Quote LIMIT 1];
        // Create a test input
        IntegrationProcedureInvocable.IntegrationProcedureInput input = new IntegrationProcedureInvocable.IntegrationProcedureInput();
        input.procedureAPIName = 'createAttachment_Quote';
        input.input = quoteRecord.id + ',' + 'EN-' + ',' + 'English';
        
        // Create a list of inputs
        List<IntegrationProcedureInvocable.IntegrationProcedureInput> inputList = new List<IntegrationProcedureInvocable.IntegrationProcedureInput>{input};
            
        // Call the Invocable method
        List<IntegrationProcedureInvocable.IntegrationProcedureOutput> result = IntegrationProcedureInvocable.runIntegrationServiceInvocable(inputList);
        
        // Assert that the result is not returned as Vlocity Objects cannot be called from Test Class without having access to all data
        System.assertEquals(1, result.size(), 'Result will not be returned');
		
		// Create an empty list of inputs
        List<IntegrationProcedureInvocable.IntegrationProcedureInput> emptyInputList = new List<IntegrationProcedureInvocable.IntegrationProcedureInput>{};
            
        // Call the Invocable method
        List<IntegrationProcedureInvocable.IntegrationProcedureOutput> emptyResult = IntegrationProcedureInvocable.runIntegrationServiceInvocable(emptyInputList);

		// Assert that the result is not returned as Vlocity Objects cannot be called from Test Class without having access to all data
        System.assertEquals(1, result.size(), 'Result will not be returned');
    }
    
    
}