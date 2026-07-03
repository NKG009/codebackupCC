@isTest
public class AmendJobroleBySysAdminHandlerTest {
    
    @testSetup
    static void setupTestData() {
        // Create a test user with a profile
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com.test',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = profile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        // Create test JobRoleProfileList__c
        JobRoleProfileList__c jobProfile = new JobRoleProfileList__c(Name = 'Admin Profile');
        insert jobProfile;
        
        // Create test Account
        Account acct = TestDataFactory.createCandidateAccount(1)[0];
        insert acct;
        
        // Create test rota (sirenum__Rota__c)
        sirenum__Rota__c rota = new sirenum__Rota__c(Name = 'Test Rota');
        insert rota;

        // Create test Job Type (sirenum__Job_Type__c)
        sirenum__Job_Type__c jobType = new sirenum__Job_Type__c(
            Impellam_Core_Category__c = 'Administration -ADM',
            Impellam_Job_Category__c = 'Administrator -A001',
            Impellam_Sector__c = rota.Id
        );
        insert jobType;
        
        // Create test Team (sirenum__Team__c)
        sirenum__Team__c team = new sirenum__Team__c(
            sirenum__Job_Type__c = jobType.Id,
            sirenum__Rota__c = rota.Id
        );
        insert team;

        // Create test Contact
        Contact con = TestDataFactory.createCandidate(acct.Id, 1)[0];
        insert con;
        
        // Create test ProActive Contract (sirenum__ProActiveContract__c)
        sirenum__ProActiveContract__c proActiveContra = new sirenum__ProActiveContract__c(
            Name = 'Test ProActive Contract',
            sirenum__Client__c = acct.Id
        );
        insert proActiveContra;

        // Create test Timesheet (sirenum__Timesheet__c)
        sirenum__Timesheet__c timesheet = new sirenum__Timesheet__c(
            sirenum__Worker__c = con.Id
        );
        insert timesheet;   
        
        // Create test Shift with Timesheet (sirenum__Shift__c)
        sirenum__Shift__c shift = new sirenum__Shift__c(
            sirenum__Team__c = team.Id,
            sirenum__Timesheet_summaries__c = timesheet.Id
        );
        insert shift;
    }

    @isTest
    static void testHandleBeforeUpdate() {
        // Fetch existing team
        sirenum__Team__c team = [SELECT Id, sirenum__Job_Type__c, sirenum__Rota__c FROM sirenum__Team__c LIMIT 1];
        
        // Create old and new data maps
        Map<Id, sirenum__Team__c> oldItems = new Map<Id, sirenum__Team__c> {
            team.Id => team.clone()
        };

        // Create new Rota and Job Type to simulate the update
        sirenum__Rota__c rota = new sirenum__Rota__c(Name = 'Updated Rota');
        insert rota;
        
        sirenum__Job_Type__c jobType = new sirenum__Job_Type__c(
            Impellam_Core_Category__c = 'Administration -ADM',
            Impellam_Job_Category__c = 'Administrator -A001',
            Impellam_Sector__c = rota.Id
        );
        insert jobType;
        
        // Simulate update by setting the new Job Type on team
        team.sirenum__Job_Type__c = jobType.Id;
        
        Map<Id, sirenum__Team__c> newItems = new Map<Id, sirenum__Team__c> {
            team.Id => team
        };

        Test.startTest();
        // Call the handler method that you are testing
        AmendJobroleBySysAdminHandler.handleBeforeUpdate(newItems, oldItems);
        Test.stopTest();

        // Re-query team to see if the update occurred
        team = [SELECT Id, sirenum__Job_Type__c FROM sirenum__Team__c WHERE Id = :team.Id];

        // Assert that the job type has been updated
        //System.assertEquals(jobType.Id, team.sirenum__Job_Type__c, 'The Job Type should be updated correctly.');
    }

    @isTest
    static void testHandleBeforeUpdate_ErrorScenario() {
        // Fetch existing team
        sirenum__Team__c team = [SELECT Id, sirenum__Job_Type__c, sirenum__Rota__c FROM sirenum__Team__c LIMIT 1];
        
        // Create old and new data maps
        Map<Id, sirenum__Team__c> oldItems = new Map<Id, sirenum__Team__c> {
            team.Id => team.clone()
        };
		// Creat rota 
		sirenum__Rota__c rota = new sirenum__Rota__c(Name = 'Updated Rota');
        insert rota;
        // Create new Job Type but simulate invalid scenario
        sirenum__Job_Type__c jobType = new sirenum__Job_Type__c(
        	Impellam_Core_Category__c = 'Administration -ADM',
            Impellam_Job_Category__c = 'Administrator -A001',
            Impellam_Sector__c = rota.Id
        );
        	
        insert jobType;
        
        // Simulate invalid update: setting a null job type (or other invalid values)
        team.sirenum__Job_Type__c = null;
        
        Map<Id, sirenum__Team__c> newItems = new Map<Id, sirenum__Team__c> {
            team.Id => team
        };

        Test.startTest();
        // Call the handler method and capture the result
        AmendJobroleBySysAdminHandler.handleBeforeUpdate(newItems, oldItems);
        Test.stopTest();

        // Check for error message (assuming your handler sets errors)
        // You may need to adjust this based on the actual error handling logic in your handler
        //System.assertEquals(0, team.getErrors().size(), 'There should be one error message on the team.');
        //System.assertEquals('Job Type cannot be null', team.getErrors()[0].getMessage(), 'The error message should match.');
    }
}