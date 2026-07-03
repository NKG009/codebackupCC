@isTest
private class ShiftApprovalController_Test {
    @testSetup 
    static void shiftSetup() {
        
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner11 = new User(
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
        Database.insert(portalAccountOwner11);
        Contact contact1 ;
        Contact contact2 ;
        Contact contact3 ;
        System.runAs(portalAccountOwner11) {
            //Create account
            Account portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner11.Id
            );
            Database.insert(portalAccount1);
            
            //Create contact
            insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
            
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
    @istest 
    static void shiftToBeApproved1() {
        insert new IP_Shift_Template__c(name = '1233', Email__c = 'singh.taji26@gmail.com');  
        User u = [select id , contactId from user where lastname = 'McTesty' limit 1];
        
        Account acct1 = TestDataFactory.createAccounts(3)[2]; 
        insert acct1;
        Account acct = TestDataFactory.createCandidateAccount(1)[0];
        insert acct;
        Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];  
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
        
        Insert cond;  
        
        
        
        IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0]; 
        tgci.IP_SalesLedgerNumber__c = '1112244';   
        Insert tgci;  
        
        sirenum__Site__c sites =  TestDataFactory.createSites(acct.id, tgci.id, 1)[0];     
        sites.ownerId = u.id;
        sites.sirenum__Operating_Company__c = [select id,name from Account where name = 'TestAccount' limit 1][0].id;
        sites.IP_MainContact__c = [select  contactId from user where lastname = 'McTesty' limit 1][0].contactId;
        sites.sirenum__Postal_Code__c = '10234';
        sites.sirenum__Street_Address__c = '1231';
        sites.IP_PassClientToTempest__c=false;
    //    sites.IP_InvoiceContact__c = [select  contactId from user where lastname = 'McTesty' limit 1][0].contactId;
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
        splacement.IP_Costcode__c = '1233';
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
        // shftList[0].sirenum__Published__c=True;
        // shftList[1].sirenum__Published__c=True;
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
        shftList[2].StartTime__c = '10:30';
        shftList[2].EndTime__c = '18:30';
        // shftList[2].sirenum__Published__c=True;
        insert shftList;
         test.startTest();
        ShiftApprovalController.SendRejectionToOwner(shftList[0].Id, 'abc', 'String combinedComment');
        String Jsonshift = JSON.serialize(shftList);
        ShiftApprovalController.getshift(Jsonshift);
       
        System.runAs(u) {
            ShiftApprovalController.getSites();
            ShiftApprovalController.getsiteContactMap();
            ShiftApprovalController.getAllShifts(sites.id, cond.id, System.now()-12, System.now());
            
        }
        test.stoptest();
        
    }
}