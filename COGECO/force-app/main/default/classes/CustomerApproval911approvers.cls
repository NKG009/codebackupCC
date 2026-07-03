public class CustomerApproval911approvers {

    public static void setDefaultValues(List<Customer_Approval__c> records) {
        System.debug('Input records = ' + records);
        if (records == null || records.isEmpty()) {
            return;
        }

        Map<Id, Customer_Approval__c> quoteIdToCustomerApprovals = new Map<Id, Customer_Approval__c>();
        System.debug('Initialized quoteIdToCustomerApprovals = ' + quoteIdToCustomerApprovals);

        // Map Customer Approvals by Account Id
        for (Customer_Approval__c approvalRecord : records) {
            quoteIdToCustomerApprovals.put(approvalRecord.Account__c, approvalRecord);
            System.debug('Added to map: ' + approvalRecord.Account__c + ' -> ' + approvalRecord);
        }

        quoteIdToCustomerApprovals.remove(null);
        System.debug('After removing null keys: ' + quoteIdToCustomerApprovals);

        if (!quoteIdToCustomerApprovals.isEmpty()) {
            for (Account accRecord : [SELECT Id FROM Account WHERE Id IN :quoteIdToCustomerApprovals.keySet()]) {
                quoteIdToCustomerApprovals.get(accRecord.Id).Account__c = accRecord.Id;
            }

            setApprovers(quoteIdToCustomerApprovals);
            System.debug('Final quoteIdToCustomerApprovals = ' + quoteIdToCustomerApprovals);
        }
    }

    private static void setApprovers(Map<Id, Customer_Approval__c> quoteIdToCustomerApprovals) {
        if (quoteIdToCustomerApprovals.isEmpty()) {
            return;
        }

        Set<Id> accountIds = new Set<Id>();
        Map<Id, List<CustomerApprovalApproversDto>> accountApproversMap = new Map<Id, List<CustomerApprovalApproversDto>>();

        // Collect all Account Ids
        for (Customer_Approval__c approvalRecord : quoteIdToCustomerApprovals.values()) {
            accountIds.add(approvalRecord.Account__c);
        }
        accountIds.remove(null);
        System.debug('AccountIds to process = ' + accountIds);

        if (!accountIds.isEmpty()) {
            // Fetch all Decision Maker contacts for these accounts
            for (Contact contactRole : [SELECT Id, Name, Email, Contact_Role__c, AccountId 
                                        FROM Contact 
                                        WHERE Contact_Role__c = 'Decision Maker' 
                                          AND AccountId IN :accountIds]) {
                
                System.debug('Processing Contact: ' + contactRole.Id + ' | ' + contactRole.Name);

                // Initialize list for this Account if not already present
                if (!accountApproversMap.containsKey(contactRole.AccountId)) {
                    accountApproversMap.put(contactRole.AccountId, new List<CustomerApprovalApproversDto>());
                    System.debug('Initialized empty list for Account: ' + contactRole.AccountId + ' -> ' 
                                 + accountApproversMap.get(contactRole.AccountId));
                }

                // Create DTO for Contact
                CustomerApprovalApproversDto approver = new CustomerApprovalApproversDto();
                approver.name = contactRole.Name;
                approver.emailAddress = contactRole.Email;
                approver.contactId = contactRole.Id;
                System.debug('Created DTO for Contact: ' + contactRole.Id + ' -> ' + JSON.serialize(approver));

                // Add DTO to map list by Account Id
                accountApproversMap.get(contactRole.AccountId).add(approver);
                System.debug('Updated list for Account: ' + contactRole.AccountId + ' -> ' 
                             + JSON.serialize(accountApproversMap.get(contactRole.AccountId)));
            }

            accountApproversMap.remove(null);

            // Assign serialized approvers to Customer Approval record
            for (Customer_Approval__c approvalRecord : quoteIdToCustomerApprovals.values()) {
                List<CustomerApprovalApproversDto> approvers = accountApproversMap.get(approvalRecord.Account__c);
                approvalRecord.X911_Approver__c = JSON.serialize(approvers);
                System.debug('Assigned X911_Approver__c for Account: ' + approvalRecord.Account__c 
                             + ' -> ' + approvalRecord.X911_Approver__c);
            }
        }
    }
}