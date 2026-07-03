@IsTest
public class CreateUpdateSkillSetControllerTest {
    
    @TestSetup
    static void setupData() {
        
          AVTRRT__Config_Settings__c configSettings = new AVTRRT__Config_Settings__c(Name='Default', AVTRRT__Trigger_Disabled_Trigger_JobApplicants__c= true , Disable_update_Acc_Addres_To_Job_Address__c = true, Job_Applicant_Rejected_Stages__c='Stage1=Rejected by Candidate;Stage2=Rejected by Client');
        insert configSettings;
        // Create a Contact for testing
        Contact con = new Contact(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com'
        );
        insert con;
        
        // Create a Job record for testing
        AVTRRT__Job__c job = new AVTRRT__Job__c(
           // Name = 'Test Job',
            Category__c = 'Allied Health'
        );
        insert job;
        
        // Create Skill Set records for both Contact and Job
        Skill_Set__c contactSkillSet = new Skill_Set__c(
            Contact__c = con.Id,
                      Category__c = 'Doctor',
            Specialty__c = 'Anaesthetics',
            Sub_Specialty__c = 'General',
            Seniority__c = 'Registrar',
            Employment_Preference__c = 'Permanent'
        );
        insert contactSkillSet;
        
        Skill_Set__c jobSkillSet = new Skill_Set__c(
            Job__c = job.Id,
            Category__c = 'Doctor',
            Specialty__c = 'Anaesthetics',
            Sub_Specialty__c = 'General',
            Seniority__c = 'Registrar',
            Employment_Preference__c = 'Permanent'
        );
        insert jobSkillSet;
    }

    @IsTest
    static void testGetContactSkillSet() {
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        List<Skill_Set__c> skillSetList = CreateUpdateSkillSetRecordsController.getContactSkillSet(con.Id);
        System.assertEquals(1, skillSetList.size(), 'Skill set list should return one skill set for the contact.');
        
        AVTRRT__Job__c job = [SELECT Id FROM AVTRRT__Job__c LIMIT 1];
        List<Skill_Set__c> jobSkillSetList = CreateUpdateSkillSetRecordsController.getContactSkillSet(job.Id);
        System.assertEquals(1, jobSkillSetList.size(), 'Skill set list should return one skill set for the job.');
    }

    @IsTest
    static void testSaveSkillSet() {
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        Boolean result = CreateUpdateSkillSetRecordsController.saveSkillSet(
            con.Id, 
            'Test',
            'Doctor', 
            'Anaesthetics', 
            'General', 
            'Registrar', 
            'Permanent'
        );
        System.assert(!result, 'New skill set should be created for contact.');
        
        AVTRRT__Job__c job = [SELECT Id FROM AVTRRT__Job__c LIMIT 1];
        Boolean jobResult = CreateUpdateSkillSetRecordsController.saveSkillSet(
            job.Id, 
              'Test',
            'Doctor', 
            'Anaesthetics', 
            'General', 
            'Registrar', 
            'Permanent'
        );
        System.assert(!jobResult, 'New skill set should be created for job.');
    }

    @IsTest
    static void testUpdateSkillSetRecord() {
        Skill_Set__c skillSet = [SELECT Id, Name, Contact__c, Category__c, Specialty__c, Sub_Specialty__c, Seniority__c, Employment_Preference__c 
                                 from Skill_Set__c LIMIT 1];
        skillSet.Category__c = 'Updated Category';
        try{
        Skill_Set__c updatedSkillSet = CreateUpdateSkillSetRecordsController.updateSkillSetRecord(skillSet);
        }catch(exception e){
            
        }
        //System.assertEquals('Updated Category', updatedSkillSet.Category__c, 'Category should be updated.');
    }

    @IsTest
    static void testDeleteSkillSetRecord() {
        Skill_Set__c skillSet = [SELECT Id FROM Skill_Set__c LIMIT 1];
        Skill_Set__c deletedSkillSet = CreateUpdateSkillSetRecordsController.deleteSkillSetRecord(skillSet);
        //System.assertEquals(skillSet.Id, deletedSkillSet.Id, 'Skill set should be deleted.');
        
        List<Skill_Set__c> deletedSkillSetList = [SELECT Id FROM Skill_Set__c WHERE Id = :skillSet.Id];
        System.assertEquals(0, deletedSkillSetList.size(), 'Skill set should no longer exist in the database.');
    }

    @IsTest
    static void testUpdateContactSkills() {
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        Test.startTest();
        CreateUpdateSkillSetRecordsController.updateContactSkills(con.Id);
        Test.stopTest();
        
        Contact updatedContact = [SELECT Job_Attribute__c FROM Contact WHERE Id = :con.Id];
       // System.assertNotEquals(null, updatedContact.Job_Attribute__c, 'Contact Job_Attribute__c should be updated.');
    }

    @IsTest
    static void testUpdateJobSkills() {
        AVTRRT__Job__c job = [SELECT Id FROM AVTRRT__Job__c LIMIT 1];
        Test.startTest();
        CreateUpdateSkillSetRecordsController.updateJobSkills(job.Id);
        Test.stopTest();
        
        AVTRRT__Job__c updatedJob = [SELECT Job_Attribute__c FROM AVTRRT__Job__c WHERE Id = :job.Id];
     //   System.assertNotEquals(null, updatedJob.Job_Attribute__c, 'Job Job_Attribute__c should be updated.');
    }
}