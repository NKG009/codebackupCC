@isTest
public class PassTempController_Test {


    @testSetup
    static void shiftSetup() {
        User runningUser = [SELECT Id, Brand__c FROM User WHERE Id =: UserInfo.getUserId()];
        System.debug('RunningUser Brand >> ' + runningUser.Brand__c);
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
                UserRoleId = portalRole.Id,
                ProfileId = profile1.Id,
                Username = 'test'+System.now().millisecond() + 'test2@test.com',
                Alias = 'batman',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                Brand__c = runningUser.Brand__c
        );
        Database.insert(portalAccountOwner1);
        Contact contact1 ;
        Contact contact2 ;
        Contact contact3 ;
        System.runAs(portalAccountOwner1) {
            TestDataFactory.setupUserProfileCustomSettings();
            Account candidateAccount = TestDataFactory.createCandidateAccount(1)[0];
            insert candidateAccount;
            TestDataFactory.setupCustomSettings(candidateAccount.Id);
            //custom setting data
            /*Payroll_Swtich__c objCustomPayrol = new Payroll_Swtich__c();
            objCustomPayrol.Batch_check__c = false;
            objCustomPayrol.Name = 'Stoppayroll';
            insert objCustomPayrol;*/

            //Create account
            Account portalAccount1 = new Account(
                    Name = 'TestAccount',
                    OwnerId = portalAccountOwner1.Id
            );
            Database.insert(portalAccount1);
            Contact clientContact = TestDataFactory.createContact(portalAccount1.Id,1)[0];
            Database.insert(clientContact);

            //Create contact
            List<Contact> candidates = TestDataFactory.createCandidate(candidateAccount.Id,3);
            contact1 = candidates[0];
            contact1.FirstName = 'Test1';
            contact1.Lastname = 'McTesty';
            contact1.Email = System.now().millisecond() + 'test@test.com';

            //Create contact
            contact2 = candidates[1];
            contact2.FirstName = 'Test2';
            contact2.Lastname = 'McTesty2';
            contact2.Email = 'test2'+System.now().millisecond() + 'test2@test.com';

            //Create contact
            contact3 = candidates[2];
            contact3.FirstName = 'Test3';
            contact3.Lastname = 'McTesty3';
            contact3.Email = 'test3'+System.now().millisecond() + 'test3@test.com';
            Database.insert(candidates);
        }
        //Create user
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Customer Community User%' Limit 1];
        User user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'amit.kohli@espire.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                Brand__c = runningUser.Brand__c
        );
        Database.insert(user1);
    }


    @istest
    static void shiftToBeApproved1() {

        User u = [select id , contactId, Brand__c from user where lastname = 'McTesty' limit 1];

        System.debug('Site owner brand >> ' + u.Brand__c);
        User runningUser = [SELECT Id, Brand__c FROM User WHERE Id =: UserInfo.getUserId()];
        System.debug('RunningUser Brand >> ' + runningUser.Brand__c);

        Account acct1 = [SELECT Id, Name, (SELECT Id, FirstName, LastName, Email FROM Contacts) FROM Account WHERE RecordType.Name = 'Account' LIMIT 1]; /*TestDataFactory.createAccounts(3)[2];
        insert acct1;*/
        Account acct = [SELECT Id, Name FROM Account WHERE RecordType.Name='Candidate' LIMIT 1]; /*TestDataFactory.createCandidateAccount(1)[0];
        insert acct;*/
        Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];
        Insert cond;

        IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0];
        Insert tgci;

        sirenum__Site__c sites =  TestDataFactory.createSites(acct.id, tgci.id, 1)[0];
        sites.ownerId = u.id;
        sites.sirenum__Operating_Company__c = acct1.id;
        sites.IP_MainContact__c = acct1.Contacts[0].Id; //[select  contactId from user where Contact.RecordType.Name = 'Contact' limit 1][0].contactId;
        sites.IP_PassClientToTempest__c = false;
        Insert sites;

        Contact_Site_link__c siteLink = new Contact_Site_link__c(Account__c=sites.sirenum__Operating_Company__c
                ,IP_Contact__c = acct1.Contacts[0].Id
                ,IP_PortalType__c='Primary Hours Approver'
                ,IP_Site__c = sites.Id);
        Database.insert(siteLink);

        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(acct.id, cond.id,1)[0];
        insert pac;

        sirenum__Rota__c rota = TestDataFactory.createSector(1)[0];
        Insert rota;

        sirenum__Job_Type__c job = TestDataFactory.createJobType(rota.id, 1)[0];
        Insert job;

        sirenum__Team__c tm = TestDataFactory.createJobRole(pac.id, job.id,1)[0];
        Insert tm;

        sirenum__Placement__c splacement = TestDataFactory.createSPlacement1(cond.id, pac.id, tm.id, u.id,1)[0];
        splacement.sirenum__Site__c = sites.id;
        splacement.IP_Consultant1LookupSplitShare__c = u.id;
        Insert splacement;

        List<sirenum__Shift__c> shftList = TestDataFactory.createShift(splacement.id, sites.id,5);
        List<contact> conId = [select id, name, Brand__c from contact where lastname like 'McTesty%' limit 5];
        System.debug('candidate brand = ' + conId[0].Brand__c);

        shftList[0].sirenum__Contact__c =  conId[0].id;
        shftList[0].sirenum__Scheduled_Start_Time__c = System.now()-10;
        shftList[0].sirenum__Scheduled_End_Time__c = System.now()-1;
        shftList[0].sirenum__Placement__c = splacement.id;
        shftList[0].IP_CandidateApproved__c = true;
        shftList[0].StartTime__c = '10:30';
        shftList[0].EndTime__c = '18:30';
        shftList[1].sirenum__Contact__c =  conId[1].id;
        shftList[1].sirenum__Scheduled_Start_Time__c = System.now()-10;
        shftList[1].sirenum__Scheduled_End_Time__c = System.now()-1;
        shftList[1].sirenum__Actual_Start_Time__c = System.now()-10;
        shftList[1].sirenum__Actual_End_Time__c = System.now()-1;
        shftList[1].sirenum__Placement__c = splacement.id;
        shftList[1].IP_CandidateApproved__c = true;
        shftList[1].StartTime__c = '10:30';
        shftList[1].EndTime__c = '18:30';
        shftList[2].sirenum__Contact__c =  conId[0].id;
        shftList[2].sirenum__Scheduled_Start_Time__c = System.now()-10;
        shftList[2].sirenum__Scheduled_End_Time__c = System.now()-1;
        shftList[2].sirenum__Actual_Start_Time__c = System.now()-10;
        shftList[2].sirenum__Actual_End_Time__c = System.now()-1;
        shftList[2].sirenum__Placement__c = splacement.id;
        shftList[2].IP_CandidateApproved__c = true;
        shftList[2].sirenum__Cancelled__c  = false;
        insert shftList;

        System.runAs(u) {
            Test.startTest();
            PassTempsApexController.echo('echo');
            PassTempsApexController.getSitesOfLoggedInUser();
            PassTempsApexController.fetchUserInformation();
            PassTempsApexController.getCandidateListLoggedInUser(sites.id);
            PassTempsApexController.getJobRoleList(sites.id);
            PassTempsApexController.getAllPastShifts(sites.id, job.id, cond.id, 'Mon, 6 May 15 - Thu, 6 Jun 19');
            PassTempsApexController.getAllPastShifts(sites.id, job.id, cond.id, 'Mon, 6 May 15');
            PassTempsApexController.getAllPastShifts(sites.id, job.id, cond.id, 'lastmonth');
            PassTempsApexController.submitRatings(shftList[0].id,'1',sites.id, job.id, cond.id, 'lastmonth');
            PassTempsApexController.submitRatings(shftList[0].id,'2',sites.id, job.id, cond.id, 'lastmonth');
            PassTempsApexController.submitRatings(shftList[0].id,'3',sites.id, job.id, cond.id, 'lastmonth');
            PassTempsApexController.submitRatings(shftList[0].id,'4',sites.id, job.id, cond.id, 'lastmonth');
            PassTempsApexController.submitRatings(shftList[0].id,'5',sites.id, job.id, cond.id, 'lastmonth');

            Test.stopTest();

        }


    }


}