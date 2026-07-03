public class AccountAuditController {
    
    @AuraEnabled
    public static string createCandidateAuditRecord(Id recordId, String auditTo, String note) {
        try {
            if (recordId != null) {
                List<Account_Audit__c> AAlist = new List<Account_Audit__c>(); 
                Account_Audit__c canAu = new Account_Audit__c();
                canAu.Account__c = recordId;
                canAu.Name_of_auditor__c = UserInfo.getUserId();
                canAu.Date_of_audit__c = System.today();
                canAu.Audit_to__c = auditTo;
                canAu.Note__c = note;
                    AAlist.add(canAu);
                insert AAlist;
                
                Account acc = [SELECT Id, Name_of_auditor__c, Date_of_audit__c FROM Account WHERE Id = :recordId LIMIT 1];
                acc.Name_of_auditor__c = UserInfo.getUserId();
                acc.Date_of_audit__c = System.today();

                
                update acc;

                return 'Audited successfully';
            } else {
                return 'Audit failed: Record ID is null';
            }
        } catch (Exception e) {
            System.debug('Audit failed: ' + e.getMessage());
            return 'Audit failed: ' + e.getMessage();
        }
    }
    
}