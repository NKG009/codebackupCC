public class CustomerApprovalTriggerHandler {
    /**
* @description  Sets default values on all new Customer_Approval__c records
*/
    public static void setDefaultValues(List<Customer_Approval__c> records) {
        if (records == null || records.isEmpty()) {
            return;
        }
        
        Map<Id, Customer_Approval__c> quoteIdToCustomerApprovals = new Map<Id, Customer_Approval__c>();
        
        for (Customer_Approval__c approvalRecord : records) {
            approvalRecord.Verification_Code__c = Request.getCurrent().getRequestId().replace(ApexConstants.COLON, '');
            
            quoteIdToCustomerApprovals.put(approvalRecord.Quote__c, approvalRecord);
        }
        
        quoteIdToCustomerApprovals.remove(null);
        
        if (!quoteIdToCustomerApprovals.isEmpty()) {
            for (Quote quoteRecord : [SELECT Id, OpportunityId FROM Quote WHERE Id IN :quoteIdToCustomerApprovals.keySet()]) {
                quoteIdToCustomerApprovals.get(quoteRecord.Id).Opportunity__c = quoteRecord.OpportunityId;
            }
            
            setApprovers(quoteIdToCustomerApprovals);
        }
    }
    
    private static void setApprovers(Map<Id, Customer_Approval__c> quoteIdToCustomerApprovals) {
        if (quoteIdToCustomerApprovals.isEmpty()) {
            return;
        }
        
        Set<Id> opportunityIds = new Set<Id>();
        Map<Id, List<CustomerApprovalApproversDto>> opportunityContactRoleDtoMap = new Map<Id, List<CustomerApprovalApproversDto>>();
        
        for (Customer_Approval__c approvalRecord : quoteIdToCustomerApprovals.values()) {
            opportunityIds.add(approvalRecord.Opportunity__c);
        }
        
        opportunityIds.remove(null);
        
        if (!opportunityIds.isEmpty()) {
            for (OpportunityContactRole contactRole : [SELECT Id, OpportunityId, Contact.Name, Contact.Email FROM OpportunityContactRole WHERE OpportunityId IN :opportunityIds]) {
                CustomerApprovalApproversDto approver = new CustomerApprovalApproversDto();
                
                approver.name = contactRole.Contact.Name;
                approver.emailAddress = contactRole.Contact.Email;
                approver.contactId = contactRole.Contact.Id;
                
                if (!opportunityContactRoleDtoMap.containsKey(contactRole.OpportunityId)) {
                    opportunityContactRoleDtoMap.put(contactRole.OpportunityId, new List<CustomerApprovalApproversDto>());
                }
                
                opportunityContactRoleDtoMap.get(contactRole.OpportunityId).add(approver);
            }
            
            opportunityContactRoleDtoMap.remove(null);
            
            for (Customer_Approval__c approvalRecord : quoteIdToCustomerApprovals.values()) {
                List<CustomerApprovalApproversDto> approvers = opportunityContactRoleDtoMap.get(approvalRecord.Opportunity__c);
                approvalRecord.Approvers__c = JSON.serialize(approvers);
            }
        }
    }
    

/*----------------------------------------------------------------------------------------
* Class : CPQC-368
* Created By : Praneeth /Shubham Joge
------------------------------------------------------------------------------------------
* @description : When additional attachments are sent with the contract, provide
				visibility into the names of what documents have been attached with 
				the contract.
------------------------------------------------------------------------------------------
* Version History:Enhancement
* Date          Developer Name      		Detail Features
* 06/02/2024    Praneeth /Shubham Joge      Enhancement Development

*****************************************************************************************/
    public static void updateAttachmentsAndLanguage(List<Customer_Approval__c> approvalsToUpdate) {
        
        Set<Id> quoteIds = new Set<Id>();
        
        Map<Id, String> quoteToAttachmentsMap = new Map<Id, String>();
        
        for (Customer_Approval__c approval : approvalsToUpdate) {
            if (approval.Quote__c != null) {
                quoteIds.add(approval.Quote__c);
            }
        }
        Map<Id, Quote> quoteMap = new Map<Id, Quote>([SELECT Id, Communication_Language__c, Selected_Attachments__c FROM Quote WHERE Id IN :quoteIds]);
        
        for (Quote quoteRecord : quoteMap.values()) {
            quoteToAttachmentsMap.put(quoteRecord.Id, quoteRecord.Selected_Attachments__c);
        }
			
        for (Customer_Approval__c approval : approvalsToUpdate) {
            Id quoteId = approval.Quote__c;
            if (quoteToAttachmentsMap.containsKey(quoteId)) {
                String attachmentIds = quoteToAttachmentsMap.get(quoteId);
                String attachmentNames = '';
                if(attachmentIds != null && String.isNotBlank(attachmentIds)){
                List<ContentDocument> contentDocumentName = [SELECT Id,Title FROM ContentDocument WHERE Id IN :attachmentIds.split(';')];
                
                for (ContentDocument name : contentDocumentName) {
                    attachmentNames += name.Title + '\n';
                }
                }
                approval.Attachments__c = attachmentNames;
                
                approval.Communication_Language__c = quoteMap.get(quoteId).Communication_Language__c;
            }
        }
    }
}