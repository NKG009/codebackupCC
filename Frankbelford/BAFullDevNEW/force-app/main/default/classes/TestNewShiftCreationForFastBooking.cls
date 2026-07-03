@isTest
Private class TestNewShiftCreationForFastBooking{
  
    @testsetup
    public static void setUp(){
    
        String randstr = String.valueOf(Math.abs(Crypto.getRandomInteger()));
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
        System.runAs(portalAccountOwner1){
            //Create Candidate Account
            Account candidateAccount = TestDataFactory.createCandidateAccount(1)[0];
            insert candidateAccount;
            TestDataFactory.setupCustomSettings(candidateAccount.Id);
            TestDataFactory.setupUserProfileCustomSettings();
            //Create account
            Account portalAccount1 = new Account(
                Name = 'TestAccount'+randstr ,
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
            Database.insert(contact1) ; 
        }       
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Customer Community User%' Limit 1];
        System.debug(' >>>>> ' + IP_Shift_Template__c.getValues('1010'));
        User user1 = new User(
            Username = System.now().millisecond() + 'test12345@test.com',
            ContactId = contact1.Id,
            ProfileId = portalProfile.Id,
            Alias = 'test123',
            Email = 'amit.kohli@espire.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345'+randstr,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
                IP_TempestDepartment__c='1010'
        );
        Database.insert(user1);
    }
    
    @isTest
    Static void  testTimeSheetFilters(){
    
        User u = [select id , contactId from user where lastname = 'McTesty' limit 1];
        
        Account acct1 = TestDataFactory.createAccounts(3)[2]; 
        insert acct1;
        Account acct = [SELECT Id, Name FROM Account WHERE RecordType.Name='Candidate' LIMIT 1];

        Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];    
        Insert cond;


        
        IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0];    
        Insert tgci;  
        
        sirenum__Site__c sites =  TestDataFactory.createSites(acct.id, tgci.id, 1)[0];     
        sites.ownerId = u.id;
        sites.sirenum__Operating_Company__c = [select id,name from Account where name LIKE 'TestAccount%' limit 1][0].id;
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
        //splacement.IP_Consultant1IDnumberSplitShare__c
        Insert splacement;
        
        List<sirenum__Shift__c> shftList = TestDataFactory.createShift(splacement.id, sites.id,5); 
        List<contact> conId = [select id, name from contact where lastname like 'McTesty%' limit 5];
        shftList[0].sirenum__Contact__c =  conId[0].id;
        shftList[0].sirenum__Scheduled_Start_Time__c = System.now()-10;
        shftList[0].sirenum__Scheduled_End_Time__c = System.now()-1;
        shftList[0].sirenum__Placement__c = splacement.id;
        shftList[0].IP_CandidateApproved__c = true;
        shftList[0].StartTime__c = '10:30';
        shftList[0].EndTime__c = '18:30';
        insert shftList;
        
        sirenum__Timesheet__c sts = new sirenum__Timesheet__c(
            sirenum__Client__c=acct1.id,
            sirenum__Worker__c=cond.id,
            sirenum__Week_Ending__c=system.today(),
            sirenum__Non_Taxed_Expenses__c=34.2,
            sirenum__Taxed_Expenses__c=22.2,
            sirenum__Non_Taxed_Deductions__c=22.0,
            sirenum__Taxed_Deductions__c=22.1,
            sirenum__Site__c = sites.id
            
        );
        insert sts;
        
        List<sirenum__Rota__c> sectors = TestDataFactory.createSector(1);
        insert sectors;
        List<sirenum__Job_Type__c> jobcats = TestDataFactory.createJobType(sectors[0].id,1);
        insert jobcats;
        List<sirenum__ProActiveContract__c> contracts = TestDataFactory.sirenumProActiveContract(acct.id, cond.id, 1);
        insert contracts; 
        List<sirenum__Team__c> jobroles = TestDataFactory.createJobRole(contracts[0].id,jobcats[0].id,1);
        insert jobroles;
    
        System.runAs(u){
            Test.startTest();
                NewShiftCreationForFastBooking.getsitesList();
                NewShiftCreationForFastBooking.getJobRoleList();
                NewShiftCreationForFastBooking.CreateNewShift(String.ValueOf(sites.id),String.ValueOf(jobroles[0].id),'11:04','11:05',String.valueOf(Datetime.now().format('dd/MM/yy')),String.ValueOf(Datetime.now().addDays(1).format('dd/MM/yy')),'8','');
                NewShiftCreationForFastBooking.CreateNewShiftForFastBooking(String.ValueOf(sites.id),String.ValueOf(jobroles[0].id),String.valueOf(Datetime.now()),String.ValueOf(Datetime.now().addDays(1)),'5');
        }
    }
}