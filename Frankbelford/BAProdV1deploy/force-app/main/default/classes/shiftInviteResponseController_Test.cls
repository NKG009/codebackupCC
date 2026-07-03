@IsTest
public with sharing class shiftInviteResponseController_Test {

	public static List<Id> jobIdSet = new List<Id>();
    
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
            TimeZoneSidKey='America/Chicago',
            IP_TempestDepartment__c ='1233'
        );
        insert portalAccountOwner1;   
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
            insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=true);
            
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


    @isTest
    static void RetrieveShiftInvites() 
    {
        User u = [select id , contactId, accountId from user where email='bruce.wayne@wayneenterprises.com' limit 1];
        List<contact> conId1 = [select id, name from contact where lastname like 'McTesty%' limit 5];
        
        Account acct1 = TestDataFactory.createAccounts(3)[2]; 
        insert acct1;
        Account acct = TestDataFactory.createCandidateAccount(1)[0];
        insert acct;
        Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];    
        Insert cond;  
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=true);
        RecordType accRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        Account acct11 = new Account(IP_Business_Type__c ='Catering', Name = 'Account Name', RecordTypeId=accRec.id, IP_BusinessIncorporationNumber__c='12345678');    
        Database.insert(acct11);

        
        IP_TopazGlobalClientInformation__c tgci = new IP_TopazGlobalClientInformation__c(name = 'MyClient', IP_StatusID__c = 1,IP_SalesLedgerNumber__c='1234567890');                
        Database.insert(tgci);    
    
        sirenum__Site__c sites = new sirenum__Site__c( Name='my site', IP_InvoiceAddressCity__c='ballia', IP_InvoiceAddressStreet__c='street1',
                                                      sirenum__Operating_Company__c=acct.Id,  GlobalClientName__c = tgci.Id, IP_ClientIDLegacy__c='eww3',  IP_Clientinvoicename__c='invoice name',
                                                      IP_InvoiceAddressCountry__c='ind', IP_InvoiceAddressCounty__c='cnt', IP_InvoiceAddressPostcode__c='23d fdd',
                                                      IP_PublicSector__c='No', IP_PassClientToTempest__c=false, IP_ClientLastPassedToTempest__c=date.today(), Credit_Status__c='Credit Approved',
                                                      IP_PassClientAddressToTempest__c=true,IP_ClientAddressLastPassedToTempest__c=date.today());            
        Database.insert(sites);

        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(acct.id, cond.id,1)[0];
        insert pac;    
        
        sirenum__Rota__c rota = TestDataFactory.createSector(1)[0];
        Insert rota;
        
        sirenum__Job_Type__c job = TestDataFactory.createJobType(rota.id, 1)[0]; 
        Insert job;
        
        sirenum__Team__c tm = TestDataFactory.createJobRole(pac.id, job.id,1)[0];
        Insert tm;

		test.startTest();
        sirenum__shift__c shftrec = TestDataFactory.createShift(null, sites.id,1)[0];
        shftrec.sirenum__Scheduled_Start_Time__c = System.now().addDays(1);
        shftrec.sirenum__Scheduled_End_Time__c = System.now().addDays(2);
        shftrec.sirenum__Published__c = false;
        shftrec.sirenum__Cancelled__c = false;
        shftrec.sirenum__Team__c = tm.Id;
        // shftrec.IP_Status__c = 
        insert shftrec;

        sirenum__shift__c shftrec2 = TestDataFactory.createShift(null, sites.id,1)[0];
        shftrec.sirenum__Scheduled_Start_Time__c = System.now().addDays(1);
        shftrec.sirenum__Scheduled_End_Time__c = System.now().addDays(2);
        shftrec.sirenum__Published__c = false;
        shftrec.sirenum__Cancelled__c = true;
        shftrec.sirenum__CancellationReason__c = 'Cancelled by Client';
        shftrec.sirenum__Team__c = tm.Id;
        // shftrec.IP_Status__c = 
        insert shftrec2;

        sirenum__shift__c shftrec3 = TestDataFactory.createShift(null, sites.id,1)[0];
        shftrec.sirenum__Scheduled_Start_Time__c = System.now().addDays(1);
        shftrec.sirenum__Contact__c = cond.id;
        shftrec.sirenum__Scheduled_End_Time__c = System.now().addDays(2);
        shftrec.sirenum__Published__c = true;
        shftrec.sirenum__Cancelled__c = false;
        shftrec.sirenum__Team__c = tm.Id;
        // shftrec.IP_Status__c = 
        insert shftrec3;
        test.stopTest();

        sirenum__Shift_Invitation__c invitation1 = new sirenum__Shift_Invitation__c(Name='Test1', sirenum__Shift__c = shftrec.Id, sirenum__Contact__c = conId1[0].Id, sirenum__Status__c = 'Accepted');
        insert invitation1;
        sirenum__Shift_Invitation__c invitation2 = new sirenum__Shift_Invitation__c(Name='Test2', sirenum__Shift__c = shftrec2.Id, sirenum__Contact__c = conId1[1].Id, sirenum__Status__c = 'Accepted');
        insert invitation2;
        sirenum__Shift_Invitation__c invitation3 = new sirenum__Shift_Invitation__c(Name='Test3', sirenum__Shift__c = shftrec3.Id, sirenum__Contact__c = conId1[2].Id, sirenum__Status__c = 'Accepted');
        insert invitation3;


        System.debug('Sirenum team ' + shftrec.sirenum__Team__c);
        System.debug('Client matches acct: ' + pac.sirenum__Client__c);
        System.runAs(u)
        {
            List<sirenum__Shift_Invitation__c> output = shiftInviteResponseController.getUnfilledShiftShiftInvitations();
            jobIdSet.add(invitation1.Id);
            jobIdSet.add(invitation2.Id);
            //shiftInviteResponseController.checkValidations(new List<Id>{invitation1.Id,invitation2.Id});
            System.assert(!output.isEmpty());
        }
    }
    @isTest
    public static void testRejectReasons(){
        shiftInviteResponseController.getRejectReasons();
    }
    
    @isTest
    public static void testCheckValidations(){
        
        List<contact> conId1 = [select id, name from contact where lastname like 'McTesty%' limit 5];
        
        Account acct = TestDataFactory.createCandidateAccount(1)[0];
        insert acct;
        Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];    
        Insert cond;  
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=true);
        
        IP_TopazGlobalClientInformation__c tgci = new IP_TopazGlobalClientInformation__c(name = 'MyClient', IP_StatusID__c = 1,IP_SalesLedgerNumber__c='1234567890');                
        Database.insert(tgci);    
    
        sirenum__Site__c sites = new sirenum__Site__c( Name='my site', IP_InvoiceAddressCity__c='ballia', IP_InvoiceAddressStreet__c='street1',
                                                      sirenum__Operating_Company__c=acct.Id,  GlobalClientName__c = tgci.Id, IP_ClientIDLegacy__c='eww3',  IP_Clientinvoicename__c='invoice name',
                                                      IP_InvoiceAddressCountry__c='ind', IP_InvoiceAddressCounty__c='cnt', IP_InvoiceAddressPostcode__c='23d fdd',
                                                      IP_PublicSector__c='No', IP_PassClientToTempest__c=false, IP_ClientLastPassedToTempest__c=date.today(), Credit_Status__c='Credit Approved',
                                                      IP_PassClientAddressToTempest__c=true,IP_ClientAddressLastPassedToTempest__c=date.today());            
        Database.insert(sites);

		test.startTest();
        sirenum__shift__c shftrec = TestDataFactory.createShift(null, sites.id,1)[0];
        shftrec.sirenum__Scheduled_Start_Time__c = System.now().addDays(1);
        shftrec.sirenum__Scheduled_End_Time__c = System.now().addDays(2);
        shftrec.sirenum__Published__c = false;
        shftrec.sirenum__Cancelled__c = false;
        
        insert shftrec;
        test.stopTest();
        sirenum__Shift_Invitation__c invitation1 = new sirenum__Shift_Invitation__c(Name='Test1', sirenum__Shift__c = shftrec.Id, sirenum__Contact__c = conId1[0].Id, sirenum__Status__c = 'Accepted');
        insert invitation1;
        sirenum__Shift_Invitation__c invitation2 = new sirenum__Shift_Invitation__c(Name='Test2', sirenum__Shift__c = shftrec.Id, sirenum__Contact__c = conId1[1].Id, sirenum__Status__c = 'Accepted');
        insert invitation2;
        shiftInviteResponseController.checkValidations(new List<Id>{invitation1.Id,invitation2.Id});
    }
}