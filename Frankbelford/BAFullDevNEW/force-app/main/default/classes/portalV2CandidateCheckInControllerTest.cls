@IsTest
public with sharing class portalV2CandidateCheckInControllerTest {
    @TestSetup
    static void createData(){
        insert new Payroll_Swtich__c(Name = 'Stoppayroll', Batch_check__c = true);
        //create account for portal user
        Account clientAccount = TestDataFactory.createClients(1)[0];
        insert clientAccount;
        //create contact for portal user
        Contact clientContact = TestDataFactory.createContact(clientAccount.Id, 1)[0];
        clientContact.LastName = 'Client';
        insert clientContact;

       Profile p1 = [SELECT Name FROM Profile WHERE Name = 'System Administrator'];
        User clientPortalUser = new User(
        LastName = 'Test',
        FirstName = 'Client',
        Alias = 'tuser',
        Email = 'Test.Client@testuser.com',
        Username = 'Test.Client@testuser.com',
        ProfileId = p1.Id,
        TimeZoneSidKey = 'GMT',
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LocaleSidKey = 'en_US',
        IP_TempestDepartment__c = '1107',
        IP_TempestDivision__c = 'NTS',
        Brand__c = 'Blue Arrow',
        Department = '1107',
        ContactId = clientContact.Id
      );
      insert clientPortalUser;

        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0];
        insert sector;

        sirenum__Job_Type__c jobType = TestDataFactory.createJobType(sector.Id,1)[0];
        insert jobType;

        sirenum__ProActiveContract__c proActiveContract = TestDataFactory.sirenumProActiveContract(clientAccount.Id,clientContact.Id,1)[0];
        insert proActiveContract;

        sirenum__Team__c jobRole = TestDataFactory.createJobRole(proActiveContract.Id, jobType.Id,1)[0];
        insert jobRole;

        //create site
        IP_TopazGlobalClientInformation__c topazClientInfo = TestDataFactory.createTopaz(1)[0];
        insert topazClientInfo;
        sirenum__Site__c site1 = TestDataFactory.createSites(clientAccount.Id, topazClientInfo.Id, 1)[0];
        insert site1;

        Account candidateAccount = TestDataFactory.createCandidateAccount(1)[0];
        insert candidateAccount;
        Contact candidate = TestDataFactory.createCandidate(candidateAccount.Id, 1)[0];
        candidate.lastName = 'Candidate';
        insert candidate;

    }
    @IsTest
    static void dayShiftStartToday()
    {
        //create day shift start and end today 
        sirenum__Team__c jobRole = [SELECT Id FROM sirenum__Team__c LIMIT 1];
        Account clientAccount = [SELECT Id FROM Account LIMIT 1];
        
        sirenum__Site__c site = [SELECT Id FROM sirenum__Site__c LIMIT 1];
        sirenum__Shift__c shift = new sirenum__Shift__c();
        shift.sirenum__Contact__c = [SELECT Id FROM Contact WHERE LastName = 'Candidate' LIMIT 1].Id;
        shift.sirenum__Scheduled_Start_Time__c = DateTime.newInstance(System.Today(), Time.newInstance(6,0,0,0));
        shift.sirenum__Scheduled_End_Time__c = DateTime.newInstance(System.Today(), Time.newInstance(18,0,0,0));
        shift.sirenum__Site__c = site.Id;
        shift.IP_Account__c = clientAccount.Id;
        shift.sirenum__Published__c = true;
        insert shift;

        //Test execution
        User runningUser = [SELECT Id, ContactId FROM User WHERE Email='Test.Client@testuser.com' LIMIT 1];
        System.assertNotEquals(null, runningUser.ContactId, runningUser);
        List<sirenum__Shift__c> output = new List<sirenum__Shift__c>();
        System.runAs(runningUser){
            output = portalV2CandidateCheckInController.getShiftsForSite(new List<String>{site.Id});
        }
        //Assertion
        System.assertEquals(1, output.Size());
    }

    @IsTest
    static void nightShiftStartToday()
    {
        //create night shift starting today and ending tomorrow
        sirenum__Team__c jobRole = [SELECT Id FROM sirenum__Team__c LIMIT 1];
        Account clientAccount = [SELECT Id FROM Account LIMIT 1];
        
        sirenum__Site__c site = [SELECT Id FROM sirenum__Site__c LIMIT 1];
        sirenum__Shift__c shift = new sirenum__Shift__c();
        shift.sirenum__Contact__c = [SELECT Id FROM Contact WHERE LastName = 'Candidate' LIMIT 1].Id;
        shift.sirenum__Scheduled_Start_Time__c = DateTime.newInstance(System.Today(), Time.newInstance(18,0,0,0));
        shift.sirenum__Scheduled_End_Time__c = DateTime.newInstance(System.Today().addDays(1), Time.newInstance(6,0,0,0));
        shift.sirenum__Site__c = site.Id;
        shift.IP_Account__c = clientAccount.Id;
        shift.sirenum__Published__c = true;
        insert shift;

        //Test execution
        User runningUser = [SELECT Id, ContactId FROM User WHERE Email='Test.Client@testuser.com' LIMIT 1];
        System.assertNotEquals(null, runningUser.ContactId, runningUser);
        List<sirenum__Shift__c> output = new List<sirenum__Shift__c>();
        System.runAs(runningUser){
            output = portalV2CandidateCheckInController.getShiftsForSite(new List<String>{site.Id});
        }
        //Assertion
        System.assertEquals(1, output.Size());
    }

    @IsTest
    static void nightShiftEndToday()
    {
        //create night shift starting yesterday and ending today
        sirenum__Team__c jobRole = [SELECT Id FROM sirenum__Team__c LIMIT 1];
        Account clientAccount = [SELECT Id FROM Account LIMIT 1];
        
        sirenum__Site__c site = [SELECT Id FROM sirenum__Site__c LIMIT 1];
        sirenum__Shift__c shift = new sirenum__Shift__c();
        shift.sirenum__Contact__c = [SELECT Id FROM Contact WHERE LastName = 'Candidate' LIMIT 1].Id;
        shift.sirenum__Scheduled_Start_Time__c = DateTime.newInstance(System.Today().addDays(-1), Time.newInstance(18,0,0,0));
        shift.sirenum__Scheduled_End_Time__c = DateTime.newInstance(System.Today(), Time.newInstance(06,0,0,0));
        shift.sirenum__Site__c = site.Id;
        shift.IP_Account__c = clientAccount.Id;
        shift.sirenum__Published__c = true;
        insert shift;

        //Test execution
        User runningUser = [SELECT Id, ContactId FROM User WHERE Email='Test.Client@testuser.com' LIMIT 1];
        System.assertNotEquals(null, runningUser.ContactId, runningUser);
        List<sirenum__Shift__c> output = new List<sirenum__Shift__c>();
        System.runAs(runningUser){
            output = portalV2CandidateCheckInController.getShiftsForSite(new List<String>{site.Id});
        }
        //Assertion
        System.assertEquals(1, output.Size());
    }
    
}