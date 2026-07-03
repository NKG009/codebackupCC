public without sharing class CustomerAppprovalEventTriggerHandler {
    public static void setCustomerApprovalDetails(List<Customer_Approval_Event__e> customerApprovalEvents) {
        if (customerApprovalEvents == null || customerApprovalEvents.isEmpty()) {
            return;
        }
        
        List<Customer_Approval__c> approvals = new List<Customer_Approval__c>();
        for (Customer_Approval_Event__e customerApprovalEvent : customerApprovalEvents) {
            if (String.isBlank(customerApprovalEvent.Approval_Response__c)) {
                continue;
            }
            
            CustomerAppprovalEventDto customerApprovalDto = (CustomerAppprovalEventDto)JSON.deserialize(customerApprovalEvent.Approval_Response__c, CustomerAppprovalEventDto.class);
            approvals.add(new Customer_Approval__c(
            	Id = customerApprovalDto.customerApprovalId,
                Approved_By__c = customerApprovalDto.approvedBy,
                Approved_By_Email__c = customerApprovalDto.approvedByEmail,
                Comments__c = customerApprovalDto.comments,
                IP_Address__c = customerApprovalDto.ipAddress,
                Status__c = customerApprovalDto  .status,
                Approver_Id__c = customerApprovalDto.contactId,
                X911_Signed_By__c = customerApprovalDto.consentedBy,
                Term_And_Condition_Accepted__c = True,  //updates by vivek singh
                Approved_Decline_Date_Time__c = System.now() //updates by vivek singh
            ));
        }
        if (!approvals.isEmpty()) {
            update approvals;
        }
    }
}