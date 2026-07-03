@isTest
private class Temp_Hours_CntTest{
    
    @testSetup 
    static void shiftSetup() {
        
         
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test23@test.com',
            Alias = 'batman',
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
            //custom setting data
            Payroll_Swtich__c objCustomPayrol = new Payroll_Swtich__c();
            objCustomPayrol.Batch_check__c = false;
            objCustomPayrol.Name = 'Stoppayroll';
            insert objCustomPayrol;
            
            //Create account
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
                IP_IsInvoicecontact__c=true,
                IP_ContactType__c='Invoice Contact',
                Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact1);
            //Create contact
      /*      contact2 = new Contact(
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
            Database.insert(contact3);*/
            
             
        
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
            LanguageLocaleKey = 'en_US'
        );
        Database.insert(user1); 
        
    }
    
   @istest 
    static void testMethodOne() {
          
     User u1 = [select id , contactId,contact.AccountId from user where lastname = 'McTesty' limit 1];
      ID ConTID = u1.contactId;
        ID accDID = u1.Contact.AccountId;
        
        User u = [select id , contactId from user where lastname = 'McTesty' limit 1];
        Account acct1 = TestDataFactory.createAccounts(3)[2]; 
        insert acct1;
        Account acct = TestDataFactory.createCandidateAccount(1)[0];
        insert acct;
        Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];    
        Insert cond;  
        
        IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0];    
        Insert tgci;  
        
        sirenum__Site__c sites =  TestDataFactory.createSites(acct.id, tgci.id, 1)[0];     
        sites.ownerId = u.id;
        sites.sirenum__Operating_Company__c = [select id,name from Account where name = 'TestAccount' limit 1][0].id;
        //sites.IP_MainContact__c = [select  contactId from user where lastname = 'McTesty' limit 1][0].contactId;
        sites.IP_MainContact__c = ConTID;
        sites.IP_PassClientToTempest__c = false;
        sites.IP_InvoiceContact__c= ConTID;
        Insert sites;
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(acct.id, cond.id,1)[0];
        insert pac;    
        
        sirenum__Rota__c rota = TestDataFactory.createSector(1)[0];
        Insert rota;
        
        sirenum__Job_Type__c job = TestDataFactory.createJobType(rota.id, 1)[0]; 
        Insert job;
        
        sirenum__Team__c tm = TestDataFactory.createJobRole(pac.id, job.id,1)[0];
        Insert tm;
        
        DateTime dt = System.Today();
       System.runAs(u) {
        Test.startTest();
            Temp_Hours_Cnt.getAllShifts('today', sites.id);
            Temp_Hours_Cnt.getAllShiftsHoursData(sites.id);
            Temp_Hours_Cnt.getStringMonth(1);
            Temp_Hours_Cnt.getStringMonth(2);
            Temp_Hours_Cnt.getStringMonth(3);
            Temp_Hours_Cnt.getStringMonth(4);
            Temp_Hours_Cnt.getStringMonth(5);
            Temp_Hours_Cnt.getStringMonth(6);
            Temp_Hours_Cnt.getStringMonth(7);
            Temp_Hours_Cnt.getStringMonth(8);
            Temp_Hours_Cnt.getStringMonth(9);
            Temp_Hours_Cnt.getStringMonth(10);
            Temp_Hours_Cnt.getStringMonth(11);
            Temp_Hours_Cnt.getStringMonth(12);
            
       Test.stopTest();     
                    
      }
    }
 }