/*
* Author: Kalpana
* Date: 15th July 2024
* Jira : https://targetrecruit.atlassian.net/browse/WAVE-322
*/
public class AVTRRT_JobTriggerHandler {
    public static void updateCredentialsPack(List<AVTRRT__Job__c> jobList, Boolean isUpdate, Boolean isInsertafter) {
        if(!isInsertafter){
            List<String> jobStagesCs = new  List<String>();
            TR_CustomSettings__c cusSet = TR_CustomSettings__c.getInstance();
            if(cusSet.Job_Stages_to_Create_Credential_Requirem__c != null){
                String jobStages = cusSet.Job_Stages_to_Create_Credential_Requirem__c;
                jobStagesCs = jobStages.split(';');
            }
            
            Set<Id> accountIds = new Set<Id>();
            
            // Collect Account Ids from the Job records
            for (AVTRRT__Job__c job : jobList) {
                if (job.AVTRRT__Account_Job__c != null && jobStagesCs != null && jobStagesCs.contains(job.AVTRRT__Stage__c) ){
                    accountIds.add(job.AVTRRT__Account_Job__c);
                }
            }
            
            if(accountIds != null){
                
                // Query Custom Metadata
                List<Job_Credential_Requirement_Meatadata__mdt> metadataList = [
                    SELECT DeveloperName, Job_Field_API__c, Pack_Prefix__c, All_Jobs__c
                    FROM Job_Credential_Requirement_Meatadata__mdt
                ];
                
                // Query related Accounts
                Map<Id, Account> accountMap = new Map<Id, Account>([
                    SELECT Id, CRDNTLS__Credentials_Pack__c, Name
                    FROM Account
                    WHERE Id IN :accountIds AND CRDNTLS__Credentials_Pack__c != null
                ]);
                
                // Create a map to hold the metadata for quick access
                Map<String, Job_Credential_Requirement_Meatadata__mdt> metadataMap = new Map<String, Job_Credential_Requirement_Meatadata__mdt>();
                for (Job_Credential_Requirement_Meatadata__mdt metadata : metadataList) {
                    metadataMap.put(metadata.Pack_Prefix__c, metadata);
                }
                
                // Create a map to hold the picklist values for quick access
                Map<Id, Set<String>> accountPicklistMap = new Map<Id, Set<String>>();
                for (Account account : accountMap.values()) {
                    Set<String> picklistValuesSet = new Set<String>(account.CRDNTLS__Credentials_Pack__c.split(';'));
                    accountPicklistMap.put(account.Id, picklistValuesSet);
                }
                
                // Process each job record
                for (AVTRRT__Job__c job : jobList) {
                    // Initialize the result string
                    job.State_Seniority_Specialty__c = '';
                    
                    // Concatenate non-null fields with a delimiter
                    if (job.AVTRRT__Job_State__c != null) {
                        job.State_Seniority_Specialty__c += job.AVTRRT__Job_State__c;
                    }
                    
                    if (job.Seniority_NEW__c != null) {
                        
                        List<String> specialties = new List<String>();
                        for (String specialty : job.Seniority_NEW__c.split(';')) {
                            specialties.add(specialty.trim());
                        }
                        job.State_Seniority_Specialty__c += String.join(specialties, '');
                    }
                    
                    if (job.Specialty_NEW__c != null) {
                        
                        List<String> specialties = new List<String>();
                        for (String specialty : job.Specialty_NEW__c.split(';')) {
                            specialties.add(specialty.trim());
                        }
                        job.State_Seniority_Specialty__c += String.join(specialties, '');
                    } 
                    Set<String> allCredentials = new Set<String>();
                    if (job.AVTRRT__Account_Job__c != null) {
                        Account relatedAccount = accountMap.get(job.AVTRRT__Account_Job__c);
                        if (relatedAccount != null) {
                            Set<String> picklistValues = accountPicklistMap.get(relatedAccount.Id);
                            for (String picklistValue : picklistValues) {
                                String[] valueParts = picklistValue.split('-');
                                String picklistPrefix;
                                String fieldValue;
                                String accountNameValue;
                                if (valueParts.size() == 3) {
                                    picklistPrefix = valueParts[0];
                                    fieldValue = valueParts[1];
                                    accountNameValue = valueParts[2];
                                }
                                
                                if (valueParts.size() == 2) {
                                    picklistPrefix = valueParts[0];
                                    fieldValue = valueParts[1];
                                }
                                Job_Credential_Requirement_Meatadata__mdt metadata = metadataMap.get(picklistPrefix);
                                
                                if (metadata != null) {
                                    String jobFieldAPI = metadata.Job_Field_API__c;
                                    Boolean allJobs = metadata.All_Jobs__c;
                                    
                                    if (allJobs) {
                                        allCredentials.add(picklistValue);
                                    } else {
                                        Object fieldValueObj = job.get(jobFieldAPI);
                                        if(fieldValueObj != null){
                                            String fieldValue1 = (String) fieldValueObj;
                                           if (picklistPrefix == metadata.Pack_Prefix__c && fieldValue1.contains(fieldValue)) {
                                                allCredentials.add(picklistValue);
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                    /*  // <-- start commenting out - wil
                    if (allCredentials.size() > 0) {
                        // Convert allCredentials to a Set to remove duplicates
                        Set<String> uniqueCredentials = new Set<String>(allCredentials);
                        
                        // Check if Credential_Packs__c is not empty and append new values
                        if (job.Credential_Packs__c != null ) {
                            // Split existing Credential_Packs__c into a Set to handle duplicates
                            Set<String> existingCredentials = new Set<String>(job.Credential_Packs__c.split(';'));
                            
                            // Add uniqueCredentials to existingCredentials
                            existingCredentials.addAll(uniqueCredentials);
                            
                            // Update Credential_Packs__c by joining the unique set
                            job.Credential_Packs__c = String.join(new List<String>(existingCredentials), ';');
                        } else {
                            // If Credential_Packs__c is empty, simply join uniqueCredentials
                            job.Credential_Packs__c = String.join(new List<String>(uniqueCredentials), ';');
                        }
                    }
                    */  // <-- end commenting out - wil
                }
            }
            
            
        }
        
        if (isUpdate) {
                generateRequirements(jobList,isInsertafter);
            }
    }
    
    public static void generateRequirements(List<AVTRRT__Job__c> jobs, Boolean isInsertafter) {
        Set<String> allCredentials = new Set<String>();
        Map<Id, String> jobCredentials = new Map<Id, String>();
        
        List<String> jobStagesCs = new  List<String>();
        TR_CustomSettings__c cusSet = TR_CustomSettings__c.getInstance();
        if(cusSet.Job_Stages_to_Create_Credential_Requirem__c != null){
            String jobStages = cusSet.Job_Stages_to_Create_Credential_Requirem__c;
            jobStagesCs = jobStages.split(';');
        }
        
        
        // Collect all credentials and map them with job IDs
        for (AVTRRT__Job__c job : jobs) {
            if (String.isNotBlank(job.Credential_Packs__c) && jobStagesCs != null && jobStagesCs.contains(job.AVTRRT__Stage__c)) {
                allCredentials.addAll(job.Credential_Packs__c.split(';'));
                jobCredentials.put(job.Id, job.Credential_Packs__c);
            }
        }
        if(allCredentials.size()>0){
            
            String query = 'SELECT Id, CRDNTLS__Type__c, CRDNTLS__Question__c, CRDNTLS__IsActive__c ' +
                'FROM CRDNTLS__CredentialQuestion__c ' +
                'WHERE CRDNTLS__IsActive__c = true AND ' +
                'CRDNTLS__Type__c INCLUDES (';
            
            // Building the INCLUDES clause dynamically
            List<String> includesClauses = new List<String>();
            for (String cred : allCredentials) {
                includesClauses.add('\'' + String.escapeSingleQuotes(cred) + '\'');
            }
            query += String.join(includesClauses, ', ');
            query += ')';
            
            Map<Id, CRDNTLS__CredentialQuestion__c> questionMap = new Map<Id, CRDNTLS__CredentialQuestion__c>();
            for (CRDNTLS__CredentialQuestion__c question : Database.query(query)) {
                questionMap.put(question.Id, question);
            }
            
            Set<String> existingQuestions = new Set<String>();
            
            // Check existing Credential Requirements to prevent duplicates
            List<Credential_Requirement__c> existingQuestionslist = [SELECT Id, Credential_Master__r.Id, Job__c
                                                                     FROM Credential_Requirement__c
                                                                     WHERE Credential_Master__r.Id IN :questionMap.keySet() AND Job__c IN:jobCredentials.keySet()];
            
            for(Credential_Requirement__c cr:existingQuestionslist){
                existingQuestions.add(cr.Credential_Master__r.Id+'-'+cr.Job__c);
            }
            
            List<Credential_Requirement__c> newRequirements = new List<Credential_Requirement__c>();
            
            // Create new Credential Requirement records if they don't already exist
            for (AVTRRT__Job__c job : jobs) {
                if (jobCredentials.containsKey(job.Id)) {
                    List<String> jobCreds = jobCredentials.get(job.Id).split(';');
                    for (String cred : jobCreds) {
                        for (CRDNTLS__CredentialQuestion__c question : questionMap.values()) {
                            if (question.CRDNTLS__Type__c != null && question.CRDNTLS__Type__c.contains(cred) && !existingQuestions.contains(question.Id+'-'+job.Id)) {
                                newRequirements.add(new Credential_Requirement__c(
                                    Name = job.Name+'-'+question.CRDNTLS__Question__c,
                                    Job__c = job.Id,
                                    Credential_Master__c = question.Id
                                ));
                                existingQuestions.add(question.Id+'-'+job.Id); 
                            }
                        }
                    }
                }
            }
            
            
            // Insert the new Credential Requirement records
            if (!newRequirements.isEmpty()) {
                insert newRequirements;
                System.debug('isInsertafter: ' + isInsertafter);
                if(!isInsertafter){
                    
                    Map<Id, List<Credential_Requirement__c>> jobCredentialRequirementsMap = new Map<Id, List<Credential_Requirement__c>>();
                    for (Credential_Requirement__c requirement : [
                        SELECT Id, Name, Job__c, Credential_Master__c, Credential_Master__r.CRDNTLS__Question__c,Credential_Master__r.CRDNTLS__IsActive__c
                        FROM Credential_Requirement__c 
                        WHERE Id IN :newRequirements
                    ]) {
                        if (!jobCredentialRequirementsMap.containsKey(requirement.Job__c)) {
                            jobCredentialRequirementsMap.put(requirement.Job__c, new List<Credential_Requirement__c>());
                        }
                        jobCredentialRequirementsMap.get(requirement.Job__c).add(requirement);
                    }
                    
                    List<Credential_Requirement__c> newCredentialRequirements = new List<Credential_Requirement__c>();
                    List<Contact> contactsToUpdate = new List<Contact>();
                    
                    for (AVTRRT__Job_Applicant__c applicant : [
                        SELECT Id, Name, AVTRRT__Job__c, AVTRRT__Contact_Candidate__c,
                        AVTRRT__Job__r.Credential_Packs__c, 
                        AVTRRT__Contact_Candidate__r.CRDNTLS__Credential_Group__c
                        FROM AVTRRT__Job_Applicant__c
                        WHERE AVTRRT__Job__c IN :jobCredentialRequirementsMap.keySet()
                    ]) {
                        if (applicant.AVTRRT__Job__c != null && applicant.AVTRRT__Contact_Candidate__c != null) {
                            String jobCredentialsapp = jobCredentials.get(applicant.AVTRRT__Job__c);
                            String contactCredentialGroup = applicant.AVTRRT__Contact_Candidate__r.CRDNTLS__Credential_Group__c;
                            
                            if (String.isNotBlank(jobCredentialsapp)) {
                                Set<String> jobCredentialSet = new Set<String>(jobCredentialsapp.split(';'));
                                Set<String> contactCredentialGroupSet = new Set<String>();
                                if (String.isNotBlank(contactCredentialGroup)) {
                                    contactCredentialGroupSet = new Set<String>(contactCredentialGroup.split(';'));
                                }
                                
                                List<Credential_Requirement__c> jobRequirements = jobCredentialRequirementsMap.get(applicant.AVTRRT__Job__c);
                                if (jobRequirements != null) {
                                    for (Credential_Requirement__c jobRequirement : jobRequirements) {
                                        Credential_Requirement__c newRequirement = new Credential_Requirement__c();
                                        newRequirement.Name = applicant.Name + '-' + jobRequirement.Credential_Master__r.CRDNTLS__Question__c;
                                        newRequirement.Credential_Master__c = jobRequirement.Credential_Master__c;
                                        newRequirement.Job_Applicant__c = applicant.Id;
                                        newRequirement.Candidate__c = applicant.AVTRRT__Contact_Candidate__c;
                                        newCredentialRequirements.add(newRequirement);
                                    }
                                }
                                
                                if (!contactCredentialGroupSet.containsAll(jobCredentialSet)) {
                                    contactCredentialGroupSet.addAll(jobCredentialSet);
                                    applicant.AVTRRT__Contact_Candidate__r.CRDNTLS__Credential_Group__c = String.join(contactCredentialGroupSet, ';');
                                    contactsToUpdate.add(applicant.AVTRRT__Contact_Candidate__r);
                                }
                            }
                        }
                    }
                    
                    if (!newCredentialRequirements.isEmpty()) {
                        insert newCredentialRequirements;
                    }
                    
                    if (!contactsToUpdate.isEmpty()) {
                        update contactsToUpdate;
                    }
                }
            }
        }
    }
}