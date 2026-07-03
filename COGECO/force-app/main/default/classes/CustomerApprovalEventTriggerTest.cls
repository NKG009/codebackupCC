@isTest
public class CustomerApprovalEventTriggerTest {
    @testSetup
    static void setup() {
        insert new Customer_Approval__c();
    }
    
	@isTest
    static void testSetCustomerApprovalDetails() {
        Customer_Approval__c approvalRecord = [SELECT Id, Comments__c FROM Customer_Approval__c LIMIT 1];
        
        CustomerAppprovalEventDto approvalEventDto = new CustomerAppprovalEventDto();
        approvalEventDto.customerApprovalId = approvalRecord.Id;
        approvalEventDto.comments = 'testing';
        
        Test.startTest();
        
        CustomerApprovalEventTriggerHandler.setCustomerApprovalDetails(new List<Customer_Approval_Event__e>{new Customer_Approval_Event__e(Approval_Response__c = JSON.serialize(approvalEventDto))});
        
        Test.stopTest();
        
        Customer_Approval__c approvalResult = [SELECT Id, Comments__c FROM Customer_Approval__c LIMIT 1];
        
        System.assertEquals('testing', approvalResult.Comments__c);
    }
}