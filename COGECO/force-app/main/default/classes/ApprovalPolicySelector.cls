public inherited sharing class ApprovalPolicySelector {
    public static List<Approval_Policy__c> getActiveApprovalPoliciesByKey(Set<String> policyKeys) {
        return [SELECT Id, Policy_Key__c, Type__c, Rules__c, Threshold__c, Applicable_Province__c FROM Approval_Policy__c WHERE Policy_Key__c IN :policyKeys AND Active__c = TRUE];
    }
}