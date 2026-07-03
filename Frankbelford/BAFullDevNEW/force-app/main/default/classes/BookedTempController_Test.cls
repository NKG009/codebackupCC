@isTest
public class BookedTempController_Test {
    
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
            
             
        
        }
        //Create user
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'Client Portal User'];
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
    static void shiftToBeApproved1() {
        
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
        sites.IP_MainContact__c = [select  contactId from user where lastname = 'McTesty' limit 1][0].contactId;
        sites.IP_PassClientToTempest__c = false;
        Insert sites;
        
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
        List<contact> conId = [select id, name from contact where lastname like 'McTesty%' limit 5];
        shftList[0].sirenum__Contact__c =  conId[0].id;
        shftList[0].sirenum__Scheduled_Start_Time__c = System.now()+10;
        shftList[0].sirenum__Scheduled_End_Time__c = System.now()+15;
        shftList[0].sirenum__Placement__c = splacement.id;
        shftList[0].IP_CandidateApproved__c = true;
        shftList[0].StartTime__c = '10:30';
        shftList[0].EndTime__c = '18:30';
        shftList[1].sirenum__Contact__c =  conId[1].id;
        shftList[1].sirenum__Scheduled_Start_Time__c = System.now()+10;
        shftList[1].sirenum__Scheduled_End_Time__c = System.now()+15;
        shftList[1].sirenum__Actual_Start_Time__c = System.now()+10;
        shftList[1].sirenum__Actual_End_Time__c = System.now()+15;
        shftList[1].sirenum__Placement__c = splacement.id;
        shftList[1].IP_CandidateApproved__c = true;
        shftList[1].StartTime__c = '10:30';
        shftList[1].EndTime__c = '18:30';
        shftList[2].sirenum__Contact__c =  conId[0].id;
        shftList[2].sirenum__Scheduled_Start_Time__c = System.now()+10;
        shftList[2].sirenum__Scheduled_End_Time__c = System.now()+15;
        shftList[2].sirenum__Actual_Start_Time__c = System.now()+10;
        shftList[2].sirenum__Actual_End_Time__c = System.now()+15;
        shftList[2].sirenum__Placement__c = splacement.id;
        shftList[2].IP_CandidateApproved__c = true;
        shftList[2].sirenum__Cancelled__c  = false;
        insert shftList;
          insert new IP_Shift_Template__c(Name = '1062',Phone__c = '987654321');
        System.runAs(u) {
         test.StartTest();
            BookedTempController.getTempshifts(sites.id);
             BookedTempController.getPhoneDetails(shftList[0].id);
            BookedTempController.getSites();
            BookedTempController.getsiteContactMap();
            BookedTempController.getJobRoles();
            BookedTempController.getAllShifts(sites.id, cond.id, job.id, 'today');
           // BookedTempController.getAllShifts(sites.id, cond.id, job.id, 'tomorrow');
           // BookedTempController.getAllShifts(sites.id, cond.id, job.id, 'next7days');
           // BookedTempController.getAllShifts(sites.id, cond.id, job.id, 'next14days');
           // BookedTempController.getAllShifts(sites.id, cond.id, job.id, 'future');
           test.StopTest();
            
            
        }
       
      
       // BookedTempController.getPhoneDetails(shftList[0].id);
        
    }
    
       @istest 
    static void shiftToBeApproved2() {
        
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
        sites.IP_MainContact__c = [select  contactId from user where lastname = 'McTesty' limit 1][0].contactId;
        sites.IP_PassClientToTempest__c = false;
        Insert sites;
        
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
        List<contact> conId = [select id, name from contact where lastname like 'McTesty%' limit 5];
        shftList[0].sirenum__Contact__c =  conId[0].id;
        shftList[0].sirenum__Scheduled_Start_Time__c = System.now()+10;
        shftList[0].sirenum__Scheduled_End_Time__c = System.now()+15;
        shftList[0].sirenum__Placement__c = splacement.id;
        shftList[0].IP_CandidateApproved__c = true;
        shftList[0].StartTime__c = '10:30';
        shftList[0].EndTime__c = '18:30';
        shftList[1].sirenum__Contact__c =  conId[1].id;
        shftList[1].sirenum__Scheduled_Start_Time__c = System.now()+10;
        shftList[1].sirenum__Scheduled_End_Time__c = System.now()+15;
        shftList[1].sirenum__Actual_Start_Time__c = System.now()+10;
        shftList[1].sirenum__Actual_End_Time__c = System.now()+15;
        shftList[1].sirenum__Placement__c = splacement.id;
        shftList[1].IP_CandidateApproved__c = true;
        shftList[1].StartTime__c = '10:30';
        shftList[1].EndTime__c = '18:30';
        shftList[2].sirenum__Contact__c =  conId[0].id;
        shftList[2].sirenum__Scheduled_Start_Time__c = System.now()+10;
        shftList[2].sirenum__Scheduled_End_Time__c = System.now()+15;
        shftList[2].sirenum__Actual_Start_Time__c = System.now()+10;
        shftList[2].sirenum__Actual_End_Time__c = System.now()+15;
        shftList[2].sirenum__Placement__c = splacement.id;
        shftList[2].IP_CandidateApproved__c = true;
        shftList[2].sirenum__Cancelled__c  = false;
        insert shftList;
        
        System.runAs(u) {
           test.StartTest();
            BookedTempController.getAllShifts(sites.id, cond.id, job.id, 'tomorrow');
            BookedTempController.getAllShifts(sites.id, cond.id, job.id, 'next7days');
            BookedTempController.getAllShifts(sites.id, cond.id, job.id, 'next14days');
            BookedTempController.getAllShifts(sites.id, cond.id, job.id, 'future');
          test.StopTest();
        }
       
    }
}