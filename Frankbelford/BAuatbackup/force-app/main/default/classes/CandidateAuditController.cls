public class CandidateAuditController {
    
    @AuraEnabled
    public static string createCandidateAuditRecord(Id recordId, String auditTo, String note) {
        try {
            if (recordId != null) {
                // Create the audit record
                List<Candidate_Audit__c> CAlist = new List<Candidate_Audit__c>(); 
                Candidate_Audit__c canAu = new Candidate_Audit__c();
                canAu.Candidate__c = recordId;
                canAu.Name_of_auditor__c = UserInfo.getUserId();
                canAu.Date_of_audit__c = System.today();
                canAu.Audit_to__c = auditTo;
                canAu.Note__c = note;
                    CAlist.add(canAu);
                
                Contact candidate = [SELECT Id, Name_of_auditor__c, Date_of_audit__c FROM Contact WHERE Id = :recordId LIMIT 1];
                candidate.Name_of_auditor__c = UserInfo.getUserId();
                candidate.Date_of_audit__c = System.today();
                candidate.Note__c = note;

                insert CAlist;
                update candidate;

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