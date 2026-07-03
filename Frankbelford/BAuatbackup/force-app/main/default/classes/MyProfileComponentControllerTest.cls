@isTest
public class MyProfileComponentControllerTest{
    
    @testSetup 
    static void shiftSetup() {
        
         
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
            TimeZoneSidKey='America/Chicago'
        );
        //Database.insert(portalAccountOwner1);
        TestDataFactory.insertUser(new List<String>{JSON.serialize(portalAccountOwner1)});
        Contact contact1 ;
        Contact contact2 ;
        Contact contact3 ;
        //System.runAs(portalAccountOwner1) {
            TestDataFactory.setupUserProfileCustomSettings();
            //custom setting data
            Payroll_Swtich__c objCustomPayrol = new Payroll_Swtich__c();
            objCustomPayrol.Batch_check__c = false;
            objCustomPayrol.Name = 'Stoppayroll';
            insert objCustomPayrol;
            
            //Create account
            Account portalAccount1 = TestDataFactory.createClients(1)[0];
            Account candidAccount = TestDataFactory.createCandidateAccount(1)[0];
            insert new List<Account>{portalAccount1, candidAccount};
            TestDataFactory.setupCustomSettings(candidAccount.Id);
            
            //Create contact
            contact1 = new Contact(
                FirstName = 'Test1',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                Email = System.now().millisecond() + 'test@test.com'
            );
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
            
             
        
        //}
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
            LanguageLocaleKey = 'en_US'
        );
        Database.insert(user1); 
        
    }
    
    
    @istest 
    static void testMethodOne() {

        Account acct1 = [SELECT Id, Name FROM Account WHERE RecordType.Name = 'Account' LIMIT 1];
        User u = [select id , contactId
                    from user
                    where ContactId IN (SELECT Id FROM Contact WHERE Account.Id =: acct1.Id) limit 1];
        Contact clientContact = [SELECT Id, Name FROM Contact WHERE Id =: u.ContactId];

        Account acct = [SELECT Id, Name FROM Account WHERE RecordType.Name = 'Candidate' LIMIT 1];
        Contact worker = TestDataFactory.createCandidate(acct.id, 1)[0];
        Insert worker;
        
        IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0];    
        Insert tgci;  
        
        sirenum__Site__c sites =  TestDataFactory.createSites(acct.id, tgci.id, 1)[0];     
        sites.ownerId = u.id;
        sites.sirenum__Operating_Company__c = acct1.Id;
        sites.IP_MainContact__c = clientContact.Id;
                                //[select  contactId from user where lastname = 'McTesty' limit 1][0].contactId;
        sites.IP_PassClientToTempest__c = false;
        Insert sites;
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(acct.id, worker.id,1)[0];
        insert pac;    
        
        sirenum__Rota__c rota = TestDataFactory.createSector(1)[0];
        Insert rota;
        
        sirenum__Job_Type__c job = TestDataFactory.createJobType(rota.id, 1)[0]; 
        Insert job;
        
        sirenum__Team__c tm = TestDataFactory.createJobRole(pac.id, job.id,1)[0];
        Insert tm;
      
       System.runAs(u) {
        Test.startTest();
           
           MyProfileComponentController.getSitesOfLoggedInUser();
           MyProfileComponentController.fetchUserInformation();
           MyProfileComponentController.updateUserInformation('UserFName','UserLastName','Mr.','test@test.com','9528229857',
                                           '9528229857','Test Street','Test Add 1','Street Test','Test City','UK','250001');
          
        Test.stopTest();     
                    
        }
      
      }
    
    
 }