/* Author : Priyanka
* Case link : https://targetrecruit.atlassian.net/browse/WAVE-303
*      https://targetrecruit.atlassian.net/browse/WAVE-302
* LWC : createSkilSetRecordsComponent
*/
public class CreateUpdateSkillSetRecordsController {
    
    public AVTRRT__JOB__C newJob { get; set; }
    public Contact newCon { get; set; }
    public Skill_Set__c newSkill { get; set; }
    public ID recordId { get; set; }
    public String recordType { get; set; }
    public List<Skill_Set__c> skillList { get; set; }
    public Map<Id, Skill_Set__c> skillMap;
    public List<Skill_Set__c> SkillL { get; set; }
    public String SelectedSkillId { get; set; }
    public Skill_Set__c skill { get; set; }
    public boolean show { get; set; }
    
    @AuraEnabled(cacheable=true)
    public static List<Skill_Set__c> getContactSkillSet(Id contactId) {
        List<Skill_Set__c> skillSetList = new List<Skill_Set__c>();
        Boolean startsWith003 = String.valueOf(contactId).startsWith('003');
        
        if (startsWith003) {
            skillSetList = [SELECT Id, Name, Contact__c, Category__c, Specialty__c, Sub_Specialty__c, Seniority__c, Employment_Preference__c 
                            FROM Skill_Set__c WHERE Contact__c = :contactId];
        } else {
            skillSetList = [SELECT Id, Name, Contact__c, Category__c, Specialty__c, Sub_Specialty__c, Seniority__c, Employment_Preference__c 
                            FROM Skill_Set__c WHERE Job__c = :contactId];
        }
        return skillSetList;
    }
    
    @AuraEnabled
    public static boolean saveSkillSet(Id ContactId, String name, String category, String specialty, String subSpecialty,
                                       String seniority, String employmentPreference)
    {
        Boolean startsWith003 = String.valueOf(ContactId).startsWith('003');
        Skill_Set__c skillSet = new Skill_Set__c(
            Category__c = category,
            Specialty__c = specialty,
            Sub_Specialty__c = subSpecialty != null ? subSpecialty : '',
            Seniority__c = seniority,
            Employment_Preference__c = employmentPreference
        );
        boolean skillSetExists;
        
        if (startsWith003) {
            skillSet.Contact__c = ContactId;
            skillSetExists = updateContactFields(skillSet);
            
            if (!skillSetExists) {
                insert skillSet;
                updateContactSkills(ContactId);
            }
            
        } else {
            skillSet.Job__c = ContactId;
            skillSetExists = updateJobFields(skillSet);
            
            if (!skillSetExists) {
                insert skillSet;
                updateJobSkills(ContactId);
            }
        }
        
        return skillSetExists;
    }
    
    public static boolean updateContactFields(Skill_Set__c skillSet) {
        Contact con = [SELECT Id, Category_New__c, Speciality__c, Sub_Specialty__c, Seniority_NEW__c, Job_Attribute__c, Employment_Preference__c
                       FROM Contact WHERE Id = :skillSet.Contact__c];
        
        boolean existingSkillSet = false;
        List<String> skillSetList = con.Job_Attribute__c != null ? con.Job_Attribute__c.split(';') : new List<String>();
        String newSkill = generateSkillString(skillSet);
        
        if (skillSetList.contains(newSkill)) {
            existingSkillSet = true;
        } else {
            skillSetList.add(newSkill);
            con.Job_Attribute__c = String.join(skillSetList, ';');
            update con;
        }
        
        updateContactSkills(con.Id);
        
        return existingSkillSet;
    }
    
    public static boolean updateJobFields(Skill_Set__c skillSet) {
        AVTRRT__Job__c job = [SELECT Id, Category__c, Specialty_NEW__c, Sub_Specialty_New__c, Seniority_NEW__c, Job_Attribute__c, Employment_Preference__c
                              FROM AVTRRT__Job__c WHERE Id = :skillSet.Job__c];
        boolean existingSkillSet = false;
        List<String> skillSetList = job.Job_Attribute__c != null ? job.Job_Attribute__c.split(';') : new List<String>();
        String newSkill = generateSkillString(skillSet);
        
        if (skillSetList.contains(newSkill)) {
            existingSkillSet = true;
        } else {
            skillSetList.add(newSkill);
            job.Job_Attribute__c = String.join(skillSetList, ';');
            update job;
        }
        
        updateJobSkills(job.Id);
        return existingSkillSet;
    }
    
    @AuraEnabled
    public static Skill_Set__c updateSkillSetRecord(Skill_Set__c updateSkillSet) {
        Skill_Set__c skillSet = [SELECT Id, Category__c, Specialty__c, Sub_Specialty__c, Seniority__c, Contact__c, Employment_Preference__c, Job__c
                                 FROM Skill_Set__c WHERE Id = :updateSkillSet.Id];
        
        skillSet.Category__c = updateSkillSet.Category__c;
        skillSet.Specialty__c = updateSkillSet.Specialty__c;
        skillSet.Sub_Specialty__c = updateSkillSet.Sub_Specialty__c;
        skillSet.Seniority__c = updateSkillSet.Seniority__c;
        skillSet.Employment_Preference__c = updateSkillSet.Employment_Preference__c;
        
        update skillSet;
        
        if (skillSet.Job__c != null) {
            updateJobFields(skillSet);
        } else if (skillSet.Contact__c != null) {
            updateContactFields(skillSet);
        }
        
        return skillSet;
    }
    
    @AuraEnabled
    public static Skill_Set__c deleteSkillSetRecord(Skill_Set__c deleteSkillSet) {
        Skill_Set__c skillSet = [SELECT Id, Category__c, Specialty__c, Sub_Specialty__c, Seniority__c, Contact__c, Job__c, Employment_Preference__c
                                 FROM Skill_Set__c WHERE Id = :deleteSkillSet.Id];
        
        List<String> jobAttributeList;
        String jobAttributeValue = generateSkillString(skillSet);
        
        if (skillSet.Contact__c != null) {
            Contact con = [SELECT Id, Category_New__c, Speciality__c, Sub_Specialty__c, Seniority_NEW__c, Job_Attribute__c, Employment_Preference__c
                           FROM Contact WHERE Id = :skillSet.Contact__c];
            jobAttributeList = con.Job_Attribute__c != null ? con.Job_Attribute__c.split(';') : new List<String>();
            
            removeSkillFromAttributeList(jobAttributeList, jobAttributeValue);
            con.Job_Attribute__c = String.join(jobAttributeList, ';');
            
            delete skillSet;
            updateContactSkills(con.Id);
            
        } else if (skillSet.Job__c != null) {
            AVTRRT__Job__c job = [SELECT Id, Category__c, Specialty_NEW__c, Sub_Specialty_New__c, Seniority_NEW__c, Job_Attribute__c, Employment_Preference__c
                                  FROM AVTRRT__Job__c WHERE Id = :skillSet.Job__c];
            jobAttributeList = job.Job_Attribute__c != null ? job.Job_Attribute__c.split(';') : new List<String>();
            
            removeSkillFromAttributeList(jobAttributeList, jobAttributeValue);
            job.Job_Attribute__c = String.join(jobAttributeList, ';');
            
            delete skillSet;
            updateJobSkills(job.Id);
        }
        
        return skillSet;
    }
    
    // Helper Methods
    private static String generateSkillString(Skill_Set__c skillSet) {
        if (skillSet.Category__c.contains('Allied Health')) {
            return skillSet.Category__c + '-' + skillSet.Specialty__c;
        } else if (skillSet.Category__c.contains('Doctor')) {
            return skillSet.Category__c + '-' + skillSet.Specialty__c + '-' + skillSet.Sub_Specialty__c + '-' + skillSet.Seniority__c + '-' + skillSet.Employment_Preference__c;
        } else if (skillSet.Category__c.contains('Medical Administration') || skillSet.Category__c.contains('Nurse') || skillSet.Category__c.contains('Clinical Executive')) {
            return skillSet.Category__c + '-' + skillSet.Seniority__c + '-' + skillSet.Employment_Preference__c;
        } else {
            return skillSet.Category__c + '-' + skillSet.Seniority__c;
        }
    }
    
    private static void removeSkillFromAttributeList(List<String> jobAttributeList, String jobAttributeValue) {
        Integer index = jobAttributeList.indexOf(jobAttributeValue);
        if (index != -1) {
            jobAttributeList.remove(index);
        }
    }
    
    public static void updateContactSkills(Id contactId) {
        Contact con = [SELECT Id, Category_New__c, Speciality__c, Sub_Specialty__c, Seniority_NEW__c, Job_Attribute__c, Employment_Preference__c
                       FROM Contact WHERE Id = :contactId];
        List<Skill_Set__c> skillSetList = [SELECT Id, Category__c, Specialty__c, Seniority__c, Sub_Specialty__c, Employment_Preference__c 
                                           FROM Skill_Set__c WHERE Contact__c = :con.Id ORDER BY CreatedDate DESC];
        Set<String> skillSetValuesList = new  Set<String>();
        Set<String> categorySet = new  Set<String>();
        Set<String> specialitySet = new  Set<String>();
        Set<String> subSpecialitySet = new  Set<String>();
        Set<String> senioritySet = new  Set<String>();
        Set<String> empoymentSet = new  Set<String>();
        if (!skillSetList.isEmpty()) {
            for(Skill_Set__c skill : skillSetList){
                Skill_Set__c latestSkillSet = skillSetList[0];
                specialitySet.add(skill.Specialty__c);
                subSpecialitySet.add(skill.Sub_Specialty__c);
                senioritySet.add(skill.Seniority__c);
                empoymentSet.add(skill.Employment_Preference__c);
                con.Category_New__c = latestSkillSet.Category__c;
                
                
                skillSetValuesList.add(generateSkillString(skill));
            }
            con.Speciality__c = String.join(specialitySet, ';');
            con.Sub_Specialty__c = String.join(subSpecialitySet, ';');
            con.Seniority_NEW__c =String.join(senioritySet, ';');
            con.Employment_Preference__c =String.join(empoymentSet, ';');
            con.Job_Attribute__c =String.join(skillSetValuesList, ';');
        } else {
            con.Category_New__c = '';
            con.Speciality__c = '';
            con.Sub_Specialty__c = '';
            con.Seniority_NEW__c = '';
            con.Employment_Preference__c = '';
            con.Job_Attribute__c = '';
        }
        
        update con;
    }
    
    public static void updateJobSkills(Id jobId) {
        AVTRRT__Job__c job = [SELECT Id, Category__c, Specialty_NEW__c, Sub_Specialty_New__c, Seniority_NEW__c, Job_Attribute__c, Employment_Preference__c
                              FROM AVTRRT__Job__c WHERE Id = :jobId];
        List<Skill_Set__c> skillSetList = [SELECT Id, Category__c, Specialty__c, Seniority__c, Sub_Specialty__c, Employment_Preference__c 
                                           FROM Skill_Set__c WHERE Job__c = :job.Id ORDER BY CreatedDate DESC];
        Set<String> categorySet = new  Set<String>();
        Set<String> specialitySet = new  Set<String>();
        Set<String> subSpecialitySet = new  Set<String>();
        Set<String> senioritySet = new  Set<String>();
        Set<String> empoymentSet = new  Set<String>();
        List<String> skillSetValuesList = new  List<String>();
        if (!skillSetList.isEmpty()) {
            for(Skill_Set__c skill : skillSetList){
                Skill_Set__c latestSkillSet = skillSetList[0];
                job.Category__c = latestSkillSet.Category__c;
                
                specialitySet.add(skill.Specialty__c);
                subSpecialitySet.add(skill.Sub_Specialty__c);
                senioritySet.add(skill.Seniority__c);
                empoymentSet.add(skill.Employment_Preference__c);
                
                skillSetValuesList.add(generateSkillString(skill));
            }
            job.Specialty_NEW__c = String.join(specialitySet, ';');
            job.Sub_Specialty_New__c = String.join(subSpecialitySet, ';');
            job.Seniority_NEW__c =String.join(senioritySet, ';');
            job.Employment_Preference__c =String.join(empoymentSet, ';');
            job.Job_Attribute__c =String.join(skillSetValuesList, ';');
        } else {
            job.Category__c = '';
            job.Specialty_NEW__c = '';
            job.Sub_Specialty_New__c = '';
            job.Seniority_NEW__c = '';
            job.Employment_Preference__c = '';
            job.Job_Attribute__c = '';
            
        }
        
        update job;
    }
}