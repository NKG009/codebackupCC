public without sharing class CustomerApprovalController {

    public class CustomerApprovalApproversDto {
        @AuraEnabled public String name;
        @AuraEnabled public Id contactId;
    }

    public class CustomerSignatureDto {
        @AuraEnabled public Customer_Approval__c customerApproval;
        @AuraEnabled public List<CustomerApprovalApproversDto> approvers = new List<CustomerApprovalApproversDto>();
    }

    @AuraEnabled(cacheable=true)
    public static String getCustomerApprovalToAction(String approvalRecordId) {
        if (String.isBlank(approvalRecordId)) {
            return JSON.serialize(new CustomerSignatureDto());
        }

        try {
            Customer_Approval__c approval = [
                SELECT Id, X911_Approver__c, Customer_Contract_Details__c
                FROM Customer_Approval__c
                WHERE Id = :approvalRecordId
                LIMIT 1
            ];

            CustomerSignatureDto dto = new CustomerSignatureDto();
            dto.customerApproval = approval;

            if (!String.isBlank(approval.X911_Approver__c)) {
                try {
                    dto.approvers = (List<CustomerApprovalApproversDto>)JSON.deserialize(
                        approval.X911_Approver__c, 
                        List<CustomerApprovalApproversDto>.class
                    );
                } catch (Exception e) {
                    System.debug('Deserialize X911_Approver__c error: ' + e.getMessage());
                    dto.approvers = new List<CustomerApprovalApproversDto>();
                }
            }

            return JSON.serialize(dto);

        } catch (Exception e) {
            System.debug('getCustomerApprovalToAction error: ' + e.getMessage());
            return JSON.serialize(new CustomerSignatureDto());
        }
    }

    @AuraEnabled
    public static Customer_Approval__c submitApproval(
        Id recordId, 
        String selectedContactId, 
        Boolean isAccepted, 
        String action
    ) {
        System.debug('submitApproval called with: recordId=' + recordId + 
                     ', selectedContactId=' + selectedContactId + 
                     ', isAccepted=' + isAccepted + 
                     ', action=' + action);

        if (recordId == null) {
            throw new AuraHandledException('Record Id is null.');
        }

        try {
            Customer_Approval__c approval = [
                SELECT Id, Term_And_Condition_Accepted__c, Status__c
                FROM Customer_Approval__c
                WHERE Id = :recordId
                LIMIT 1
            ];

            System.debug('Approval before update: ' + approval);

            approval.Term_And_Condition_Accepted__c = isAccepted;

            if (action == 'Approved') {
                approval.Status__c = 'Approved';
            } else if (action == 'Declined') {
                approval.Status__c = 'Rejected';
            } else {
                throw new AuraHandledException('Invalid action value: ' + action);
            }

            update approval;

            System.debug('Approval after update: ' + approval);

            return approval;

        } catch (DmlException e) {
            System.debug('DML Exception: ' + e.getMessage());
            throw new AuraHandledException('Unable to update approval: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('General Exception: ' + e.getMessage());
            throw new AuraHandledException('Error in submitApproval: ' + e.getMessage());
        }
    }
}