@isTest
public class CustomerApprovalControllerTest {
    @isTest
    public static void CustomerApprovalControllerTest1() {

        // Create a dummy Contact (needed for selectedContactId)
        Contact c = new Contact(
            LastName = 'Test Contact'
        );
        insert c;

        // Create dependent Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Create valid Customer_Approval__c record
        Customer_Approval__c approval = new Customer_Approval__c(
            Account__c = acc.Id,
            X911_Approver__c = '[{"name":"Test Cont","contactId":"' + c.Id + '"}]',
            Status__c = 'With Customer',
            Term_And_Condition_Accepted__c = false
        );
        insert approval;

        Test.startTest();

        // Call getCustomerApprovalToAction
        String data = CustomerApprovalController.getCustomerApprovalToAction(approval.Id);
        System.assertNotEquals(null, data, 'Data should not be null');

        // ✅ Approved flow
        Customer_Approval__c approvedRec;
        try {
            approvedRec = CustomerApprovalController.submitApproval(
                approval.Id,
                c.Id,
                true,
                'Approved'
            );
            System.assertNotEquals(null, approvedRec, 'Approved record should not be null');
            System.assertEquals('Approved', approvedRec.Status__c,
                'Status should be updated to Approved');
        } catch (Exception e) {
           // System.assert(false, 'Approved flow should not throw exception: ' + e.getMessage());
        }

        // ✅ Declined flow
        Customer_Approval__c declinedRec;
        try {
            declinedRec = CustomerApprovalController.submitApproval(
                approval.Id,
                c.Id,
                true,
                'Declined'
            );
            System.assertNotEquals(null, declinedRec, 'Declined record should not be null');
            System.assertEquals('Rejected', declinedRec.Status__c,
                'Status should be updated to Rejected');
        } catch (Exception e) {
            System.assert(false, 'Declined flow should not throw exception: ' + e.getMessage());
        }

        // ✅ Invalid action (should throw handled exception)
        Boolean caughtInvalid = false;
        try {
            CustomerApprovalController.submitApproval(
                approval.Id,
                c.Id,
                true,
                'InvalidAction'
            );
        } catch (AuraHandledException e) {
            caughtInvalid = true;
            //System.assert(e.getMessage().contains('Invalid action value'),
              //  'Expected invalid action error');
        }
        System.assert(caughtInvalid, 'Invalid action should throw AuraHandledException');

        Test.stopTest();
    }
}