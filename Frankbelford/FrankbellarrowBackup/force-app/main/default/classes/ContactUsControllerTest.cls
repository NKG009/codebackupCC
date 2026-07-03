@isTest
public class ContactUsControllerTest{
    @istest 
    static void testMethodOne() {
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
                                            UserRoleId = portalRole.Id,
                                            ProfileId = profile1.Id,
                                            Username = 'test123'+System.now().millisecond() + 'test12345@test234.com',
                                            Alias = 'batman',
                                            Email='test123'+System.now().millisecond() + 'test12345@test234.com',
                                            EmailEncodingKey='UTF-8',
                                            Firstname='Bruce',
                                            Lastname='Wayne',
                                            LanguageLocaleKey='en_US',
                                            LocaleSidKey='en_US',
                                            TimeZoneSidKey='America/Chicago',
                                            IP_TempestDepartment__c = '1062'
                                            );
        Database.insert(portalAccountOwner1);
        Contact contact1 ;
        Contact contact2 ;
        Contact contact3 ;
        System.runAs(portalAccountOwner1) {
            //Create account
            Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
            Insert candidateAcc;
            TestDataFactory.setupUserProfileCustomSettings();
            TestDataFactory.getEmailTemplate();
            insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candidateAcc.Id);
            insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
            insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
            insert new IP_Shift_Template__c(name = '1062', Email__c = 'singh.taji26@gmail.com');

            Account portalAccount1 = new Account(
                                                Name = 'TestAccount',
                                                OwnerId = portalAccountOwner1.Id
                                                );
            Database.insert(portalAccount1);

            //Create contact
            contact1 = new Contact(
                                    FirstName = 'Test1',
                                    Lastname = 'McTesty',
                                    AccountId = portalAccount1.Id,
                                    Email = System.now().millisecond() + 'test@test.com'
                                    );
            insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
            Database.insert(contact1);
            //Create contact
            contact2 = new Contact(
                                    FirstName = 'Test2',
                                    Lastname = 'McTesty2',
                                    AccountId = portalAccount1.Id,
                                    Email = 'test2'+System.now().millisecond() + 'test2@test.com'
                                    );
            Database.insert(contact2);
            //Create contact
            contact3 = new Contact(
                                    FirstName = 'Test3',
                                    Lastname = 'McTesty3',
                                    AccountId = portalAccount1.Id,
                                    Email = 'test3'+System.now().millisecond() + 'test3@test.com'
                                    );
            Database.insert(contact3);
        }
        //Create user
        String userPortal = System.Label.Candidate_Portal_User_Portal;
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name =: userPortal Limit 1];
        User user1 = new User(
                                Username = 'test124'+System.now().millisecond() + 'test12345@test4234.com',
                                ContactId = contact1.Id,
                                ProfileId = portalProfile.Id,
                                Alias = 'test123',
                                Email = 'test124'+System.now().millisecond() + 'test12345@test4234.com',
                                EmailEncodingKey = 'UTF-8',
                                LastName = 'McTesty',
                                CommunityNickname = 'test12345',
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US'
                                );
        Database.insert(user1);
        Case c = new Case();
        System.runas(User1){
        ContactUsController.getSitesOfLoggedInUser();
        ContactUsController.getUserInformation();
        ContactUsController.getselectOptionsClient(c,'Subject_Query__c');
        ContactUsController.fetchUser();
        ContactUsController.caseInsertSendEmail('General Query', 'Test Mail',null);
        }
       
    }
    
    @istest 
    static void testMethodTwo() {
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
                                            UserRoleId = portalRole.Id,
                                            ProfileId = profile1.Id,
                                            Username = 'test125'+System.now().millisecond() + 'test12345@test4234.com',
                                            Alias = 'batman',
                                            Email='test125'+System.now().millisecond() + 'test12345@test4234.com',
                                            EmailEncodingKey='UTF-8',
                                            Firstname='Bruce',
                                            Lastname='Wayne',
                                            LanguageLocaleKey='en_US',
                                            LocaleSidKey='en_US',
                                            TimeZoneSidKey='America/Chicago',
                                            IP_TempestDepartment__c = '1062'
                                            );
        Database.insert(portalAccountOwner1);
        Contact contact1 ;
        Contact contact2 ;
        Contact contact3 ;
        System.runAs(portalAccountOwner1) {
            //Create account
            Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
            Insert candidateAcc;
            TestDataFactory.setupUserProfileCustomSettings();
            TestDataFactory.getEmailTemplate();
            insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candidateAcc.Id);
            insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
            insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
            insert new IP_Shift_Template__c(name = '1062', Email__c = 'singh.taji26@gmail.com');

            Account portalAccount1 = new Account(
                                                    Name = 'TestAccount',
                                                    OwnerId = portalAccountOwner1.Id
                                                    );
            Database.insert(portalAccount1);

            //Create contact
            contact1 = new Contact(
                                    FirstName = 'Test1',
                                    Lastname = 'McTesty',
                                    AccountId = portalAccount1.Id,
                                    Email = System.now().millisecond() + 'test@test.com'
                                    );
            insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
            Database.insert(contact1);
            //Create contact
            contact2 = new Contact(
                                    FirstName = 'Test2',
                                    Lastname = 'McTesty2',
                                    AccountId = portalAccount1.Id,
                                    Email = 'test2'+System.now().millisecond() + 'test2@test.com'
                                    );
            Database.insert(contact2);
            //Create contact
            contact3 = new Contact(
                                    FirstName = 'Test3',
                                    Lastname = 'McTesty3',
                                    AccountId = portalAccount1.Id,
                                    Email = 'test3'+System.now().millisecond() + 'test3@test.com'
                                    );
            Database.insert(contact3);
        }
        //Create user
        String clientPortalUserProfile = System.Label.Client_Portal_User_Profile;
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name =: clientPortalUserProfile Limit 1];
        User user1 = new User(
                                Username = 'test126'+System.now().millisecond() + 'test12345@test4234.com',
                                ContactId = contact1.Id,
                                ProfileId = portalProfile.Id,
                                Alias = 'test123',
                                Email = 'test126'+System.now().millisecond() + 'test12345@test4234.com',
                                EmailEncodingKey = 'UTF-8',
                                LastName = 'McTesty',
                                CommunityNickname = 'test12345',
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US'
                                );
        Database.insert(user1);
        Case c = new Case();
        System.runas(User1){
        ContactUsController.getSitesOfLoggedInUser();
        ContactUsController.getUserInformation();
        ContactUsController.getselectOptionsClient(c,'Subject_Query__c');
        ContactUsController.fetchUser();
        ContactUsController.caseInsertSendEmail('General Query', 'Test Mail',null);
        }
    }
}