@isTest
public class UpdateUserFromContactClass_Test {

    @isTest
    static void userSetup() {
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];

        User portalAccountOwner1 = new User(
                UserRoleId = portalRole.Id,
                ProfileId = profile1.Id,
                Username = System.now().millisecond() + 'test267@test.com',
                Alias = 'bat',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
        );

        Database.insert(portalAccountOwner1);
        Contact contact1 ;
        Contact contact2 ;
        Contact contact3 ;

        System.runAs(portalAccountOwner1) {
            //Create account
            Account portalAccount1 = new Account(
                    Name = 'TestAccount',
                    OwnerId = portalAccountOwner1.Id
            );
            Database.insert(portalAccount1);

            TestDataFactory.setupUserProfileCustomSettings();
            Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
            Insert candidateAcc;
            insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candidateAcc.Id);
            insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
            //Create contact
            contact1 = new Contact(
                    FirstName = 'Test1',
                    Lastname = 'McTesty',
                    AccountId = portalAccount1.Id,
                    MailingStreet = 'test6874',
                    Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact1);

            //Database.update(contact1);

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
        //Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%User Portal%' Limit 1];
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name ='Customer Portal Manager Custom' Limit 1];
        User user1 = new User(
                 //Username = System.now().millisecond() + 'test12345@test.com',
                Username = 'amit.kohli@espire.com',
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'amit.kohli@espire.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
        );
        Set<ID> conset = new Set<ID>();
        Database.insert(user1);
        List<Contact> lstContact = new List<Contact>();
        System.runAs(portalAccountOwner1){
            contact1.MailingStreet = 'test6874';
            contact3.Email = 'amit.kohli@espire.com';
            lstContact.add(contact1);
            Database.update(lstContact);
            conset.add(contact1.id);
            UpdateUserFromContactClass.updateUser(conset);
        }
    }

    @isTest
    static void testMethodOne() {
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
                UserRoleId = portalRole.Id,
                ProfileId = profile1.Id,
                Username = System.now().millisecond() + 'test267@test.com',
                Alias = 'bat',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
        );

        Database.insert(portalAccountOwner1);
        Contact contact1 ;
        Contact contact2 ;
        Contact contact3 ;

        System.runAs(portalAccountOwner1) {
            //Create account
            Account portalAccount1 = new Account(
                    Name = 'TestAccount',
                    OwnerId = portalAccountOwner1.Id
            );
            Database.insert(portalAccount1);

            TestDataFactory.setupUserProfileCustomSettings();
            Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
            Insert candidateAcc;
            insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candidateAcc.Id);
            insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
            //Create contact
            contact1 = new Contact(
                    FirstName = 'Test1',
                    Lastname = 'McTesty',
                    AccountId = portalAccount1.Id,
                    Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact1);
            contact1.Email = 'test@gmail.com';
            Database.update(contact1);

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
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Customer Portal Manager Custom%' Limit 1];
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
                LanguageLocaleKey = 'en_US'
        );
        Set<ID> conset = new Set<ID>();
        Database.insert(user1);

        System.runAs(portalAccountOwner1){
            contact1.MailingStreet = 'test6874';
            Database.update(contact1);
            conset.add(contact1.id);
            UpdateUserFromContactClass.updateUser(conset);
        }
    }

    public static testmethod void ContactUpdateEmail(){
        TestDataFactory.setupUserProfileCustomSettings();
        Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
        Insert candidateAcc;
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candidateAcc.Id);

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client'];
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account'];
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact',
                AccountID=acc.id,Email = System.now().millisecond() + 'test@test.com');
        insert maincon;
        system.debug('maincon>>>>>'+maincon.email);
        //CheckRecursionTOE.run2 = false;
        maincon.Email = System.now().millisecond() +'sd12342@gmail.com';
        system.debug('maincon2>>>>>'+maincon.email);
        update maincon;
        system.debug('maincon3>>>>>'+maincon.email);
        //Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        //insert account1;
    }
}