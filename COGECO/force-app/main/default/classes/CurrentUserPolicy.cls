public without sharing class CurrentUserPolicy {
    public static Boolean runTriggers() {
        Run_Rules__c runRules = Run_Rules__c.getInstance();
        return runRules == null || runRules.Run_Triggers__c;
    }
}