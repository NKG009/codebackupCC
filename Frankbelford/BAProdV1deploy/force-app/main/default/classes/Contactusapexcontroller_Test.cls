@isTest
public class Contactusapexcontroller_Test {
    @istest
    static void contacttobeapproved() {
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
                UserRoleId = portalRole.Id,
                ProfileId = profile1.Id,
                Username = System.now().millisecond() + 'test2@test.com',
                Alias = 'batman',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                IP_TempestDepartment__c = '1062',
                Brand__c='Tate'
        );
        Database.insert(portalAccountOwner1);
        Contact contact1 ;
        Contact contact2 ;
        Contact contact3 ;
        System.runAs(portalAccountOwner1) {
            TestDataFactory.setupUserProfileCustomSettings();
            //Create account
            Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
            Insert candidateAcc;
            insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candidateAcc.Id);
            insert new IP_Shift_Template__c(name = '1062', Email__c = 'ignite.svc@impellam.com');

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
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE 'Customer Portal Manager Custom' Limit 1];
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
                Brand__c='Tate'
        );
        Database.insert(user1);

        Case c = new Case();
        System.runas(User1) {
            Contactusapexcontroller.updatecase('Test1','Test2');
        }
        Contactusapexcontroller.getselectOptionsClient(c,'Subject_Query__c');
    }

    @istest
    static void contacttobeapproved2() {
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
                UserRoleId = portalRole.Id,
                ProfileId = profile1.Id,
                Username = System.now().millisecond() + 'test2@test.com',
                Alias = 'batman',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                IP_TempestDepartment__c = '1062',
                Brand__c='Tate'
        );
        Database.insert(portalAccountOwner1);
        Contact contact1 ;
        Contact contact2 ;
        Contact contact3 ;
        System.runAs(portalAccountOwner1) {
            TestDataFactory.setupUserProfileCustomSettings();
            //Create account
            Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
            Insert candidateAcc;
            insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candidateAcc.Id);
            insert new IP_Shift_Template__c(name = '1062', Email__c = 'ignite.svc@impellam.com');

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
                    Email = System.now().millisecond() + 'test@test.com');

            insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
            Database.insert(contact1);
            //Create contact
            contact2 = new Contact(
                    FirstName = 'Test2',
                    Lastname = 'McTesty2',
                    AccountId = portalAccount1.Id,
                    Email = 'test2'+System.now().millisecond() + 'test2@test.com');

            Database.insert(contact2);
            //Create contact
            contact3 = new Contact(
                    FirstName = 'Test3',
                    Lastname = 'McTesty3',
                    AccountId = portalAccount1.Id,
                    Email = 'test3'+System.now().millisecond() + 'test3@test.com');

            Database.insert(contact3);
        }
        //Create user
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE 'User Portal' Limit 1];
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
                Brand__c='Tate'
        );

        Database.insert(user1);
        Case c = new Case();
        EmailTemplate et = TestDataFactory.getEmailTemplate();
        System.runas(User1) {
            Contactusapexcontroller.updatecase('Test1','Test2');
        }
        Contactusapexcontroller.getselectOptions(c,'Subject_Query__c');
    }

    @istest
    static void contacttobeapproved3() {
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
                UserRoleId = portalRole.Id,
                ProfileId = profile1.Id,
                Username = System.now().millisecond() + 'test2@test.com',
                Alias = 'batman',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                IP_TempestDepartment__c = '1062',
                Brand__c='Tate'
        );
        Database.insert(portalAccountOwner1);
        Contact contact1 ;
        Contact contact2 ;
        Contact contact3 ;
        System.runAs(portalAccountOwner1) {
            TestDataFactory.setupUserProfileCustomSettings();
            //Create account
            Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
            Insert candidateAcc;
            insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candidateAcc.Id);
            insert new IP_Shift_Template__c(name = '1062', Email__c = 'ignite.svc@impellam.com');

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
                    Email = System.now().millisecond() + 'test@test.com');

            insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
            Database.insert(contact1);
            //Create contact
            contact2 = new Contact(
                    FirstName = 'Test2',
                    Lastname = 'McTesty2',
                    AccountId = portalAccount1.Id,
                    Email = 'test2'+System.now().millisecond() + 'test2@test.com');

            Database.insert(contact2);
            //Create contact
            contact3 = new Contact(
                    FirstName = 'Test3',
                    Lastname = 'McTesty3',
                    AccountId = portalAccount1.Id,
                    Email = 'test3'+System.now().millisecond() + 'test3@test.com');

            Database.insert(contact3);
        }
        //Create user
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE 'Client Portal User' Limit 1];
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
                Brand__c='Tate'
        );

        Database.insert(user1);
        Case c = new Case();
        EmailTemplate et = TestDataFactory.getEmailTemplate();
        System.runas(User1) {
            Contactusapexcontroller.updatecase('Test1','Test2');
        }
        Contactusapexcontroller.getselectOptions(c,'Subject_Query__c');
    }
}