public inherited sharing class CustomerApprovalSelector {
    public static List<Customer_Approval__c> getSingleCustomerApprovalFromId(Id recordId) {
        return [SELECT Id, Name, Verification_Code__c, Status__c, Approved_By__c, Approved_By_Email__c, Customer_Contract_Details__c, Approvers__c FROM Customer_Approval__c WHERE Id = :recordId LIMIT 1];
    }
    
    public static List<Customer_Approval__c> getSingleCustomerApprovalFromIdAndVerificationCode(Id recordId, String verificationCode) {
        return [SELECT Id, Name, Verification_Code__c, Status__c, Approved_By__c, Approved_By_Email__c FROM Customer_Approval__c WHERE Id = :recordId AND Verification_Code__c = :verificationCode LIMIT 1];
    }
}