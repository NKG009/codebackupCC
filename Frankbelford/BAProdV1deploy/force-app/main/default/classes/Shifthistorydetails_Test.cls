@isTest
public class Shifthistorydetails_Test {
    @testSetup
    static void shiftSetup() {
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Customer Community User%' Limit 1];
        Id urId = [SELECT Id FROM UserRole WHERE Name='Impellam IT'].Id;
        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = new User(LastName = 'LIVESTON',FirstName='JASON',Alias = 'jliv',Email = 'mm.sf@outlook123.com',
                Username = 'dummydcwecweEmail6786367@email.com', ProfileId = p.id, UserRoleId=urId, TimeZoneSidKey = 'GMT',
                LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',IP_TempestDepartment__c='1062',
                IP_TempestDivision__c='NTS',Department='1062',IP_PassToTempest__c=true, Brand__c='Blue Arrow');

        insert u;

        Contact contact1 ;
        Contact contact2 ;
        Contact contact3 ;
        System.runAs(u) {
            TestDataFactory.setupUserProfileCustomSettings();
            Account candidateAccount = TestDataFactory.createCandidateAccount(1)[0];
            insert candidateAccount;

            TestDataFactory.setupCustomSettings(candidateAccount.Id);
            List<Contact> workers = TestDataFactory.createCandidate(candidateAccount.Id, 5);
            insert workers;

            //Create account
            Account portalAccount1 = TestDataFactory.createAccounts(1)[0];
            Database.insert(portalAccount1);

            //Create contact
            List<Contact> clientcContacts = TestDataFactory.createContact(portalAccount1.Id,3);
            contact1 = clientcContacts[0];
            contact2 = clientcContacts[1];
            contact3 = clientcContacts[2];
            Database.insert(clientcContacts);

        }
        //Create user
        User user1 = TestDataFactory.createCommunityUser(contact1, portalProfile.Id);
        User user2 = TestDataFactory.createCommunityUser(contact2, portalProfile.Id);
        User user3 = TestDataFactory.createCommunityUser(contact3, portalProfile.Id);
        TestDataFactory.insertUser(new List<String>{JSON.serialize(user1),JSON.serialize(user2),JSON.serialize(user3)});
    }

    @istest
    static void shifthistory1() {
        User u = [select id , contactId from user where Email = 'mm.sf@outlook123.com' limit 1];

        Account acct1 = [SELECT Id, Name, (SELECT Id FROM Contacts) FROM Account WHERE RecordType.Name != 'Candidate'];
        User ccUser = [SELECT Id, ContactId, Contact.AccountId FROM User WHERE Contact.Account.Id =: acct1.Id LIMIT 1];

        Account acct = [SELECT Id, Name, (SELECT Id FROM Contacts) FROM Account WHERE RecordType.Name = 'Candidate'];
        List<Contact> conId1 = acct.Contacts;
        Contact cond = conId1[0];

        IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0];
        Insert tgci;

        sirenum__Site__c sites =  TestDataFactory.createSites(acct.id, tgci.id, 1)[0];
        sites.ownerId = u.id;
        sites.sirenum__Operating_Company__c = ccUser.Contact.AccountId;
        sites.IP_MainContact__c = ccUser.ContactId;
        sites.IP_InvoiceContact__c = ccUser.ContactId;
        sites.Emergency_Contact__c = ccUser.ContactId;
        sites.IP_PassClientToTempest__c = false;
        Insert sites;

        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(acct.id, cond.id,1)[0];
        pac.sirenum__Client__c = acct1.Id;
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

        List<sirenum__Shift__c> shftListhistory = TestDataFactory.createShift(splacement.id, sites.id,9);
        //List<contact> conId1 = [select id, name from contact where lastname like 'McTesty%' limit 5];
        shftListhistory[0].sirenum__Contact__c =  conId1[0].id;
        shftListhistory[0].sirenum__Scheduled_Start_Time__c = System.now()-28;
        shftListhistory[0].sirenum__Scheduled_End_Time__c = System.now()-24;
        shftListhistory[0].sirenum__Placement__c = splacement.id;
        shftListhistory[0].IP_CandidateApproved__c = true;
        shftListhistory[0].StartTime__c = '10:30';
        shftListhistory[0].EndTime__c = '18:30';
        shftListhistory[0].sirenum__site__c = sites.Id;
        shftListhistory[0].sirenum__Team__c = tm.id;
        shftListhistory[0].sirenum__Published__c = true;
        shftListhistory[1].sirenum__Contact__c =  conId1[1].id;
        shftListhistory[1].sirenum__Scheduled_Start_Time__c = System.now()-34;
        shftListhistory[1].sirenum__Scheduled_End_Time__c = System.now()-30;
        shftListhistory[1].sirenum__Actual_Start_Time__c = System.now()-34;
        shftListhistory[1].sirenum__Actual_End_Time__c = System.now()-30;
        shftListhistory[1].sirenum__Placement__c = splacement.id;
        shftListhistory[1].IP_CandidateApproved__c = true;
        shftListhistory[1].StartTime__c = '10:30';
        shftListhistory[1].EndTime__c = '18:30';
        shftListhistory[1].sirenum__site__c = sites.Id;
        shftListhistory[1].sirenum__Team__c = tm.id;
        shftListhistory[1].sirenum__Published__c = true;
        shftListhistory[2].sirenum__Contact__c =  conId1[0].id;
        shftListhistory[2].sirenum__Scheduled_Start_Time__c = System.now()-2;
        shftListhistory[2].sirenum__Scheduled_End_Time__c = System.now()-1;
        shftListhistory[2].sirenum__Actual_Start_Time__c = System.now()-2;
        shftListhistory[2].sirenum__Actual_End_Time__c = System.now()-1;
        shftListhistory[2].sirenum__Placement__c = splacement.id;
        shftListhistory[2].IP_CandidateApproved__c = true;
        shftListhistory[2].sirenum__Cancelled__c  = false;
        shftListhistory[2].sirenum__site__c = sites.Id;
        shftListhistory[2].sirenum__Team__c = tm.id;
        shftListhistory[2].sirenum__Published__c = true;
        shftListhistory[3].sirenum__Contact__c =  conId1[0].id;
        shftListhistory[3].sirenum__Scheduled_Start_Time__c = System.now()-4;
        shftListhistory[3].sirenum__Scheduled_End_Time__c = System.now()-3;
        shftListhistory[3].sirenum__Actual_Start_Time__c = System.now()-4;
        shftListhistory[3].sirenum__Actual_End_Time__c = System.now()-3;
        shftListhistory[3].sirenum__Placement__c = splacement.id;
        shftListhistory[3].IP_CandidateApproved__c = true;
        shftListhistory[3].sirenum__Cancelled__c  = false;
        shftListhistory[3].sirenum__site__c = sites.Id;
        shftListhistory[3].sirenum__Team__c = tm.id;
        shftListhistory[3].sirenum__Published__c = true;
        shftListhistory[4].sirenum__Contact__c =  conId1[0].id;
        shftListhistory[4].sirenum__Scheduled_Start_Time__c = System.now()-21;
        shftListhistory[4].sirenum__Scheduled_End_Time__c = System.now()-20;
        shftListhistory[4].sirenum__Actual_Start_Time__c = System.now()-21;
        shftListhistory[4].sirenum__Actual_End_Time__c = System.now()-20;
        shftListhistory[4].sirenum__Placement__c = splacement.id;
        shftListhistory[4].IP_CandidateApproved__c = true;
        shftListhistory[4].sirenum__Cancelled__c  = false;
        shftListhistory[4].sirenum__site__c = sites.Id;
        shftListhistory[4].sirenum__Team__c = tm.id;
        shftListhistory[4].sirenum__Published__c = true;
        shftListhistory[5].sirenum__Contact__c =  null;
        shftListhistory[5].sirenum__Scheduled_Start_Time__c = System.now()-21;
        shftListhistory[5].sirenum__Scheduled_End_Time__c = System.now()-20;
        shftListhistory[5].sirenum__Actual_Start_Time__c = System.now()-21;
        shftListhistory[5].sirenum__Actual_End_Time__c = System.now()-20;
        shftListhistory[5].sirenum__Placement__c = splacement.id;
        shftListhistory[5].IP_CandidateApproved__c = true;
        shftListhistory[5].sirenum__Cancelled__c  = false;
        shftListhistory[5].sirenum__Broadcasts__c = 2;
        shftListhistory[5].sirenum__site__c = sites.Id;
        shftListhistory[5].sirenum__Team__c = tm.id;
        shftListhistory[5].sirenum__Published__c = true;
        shftListhistory[6].sirenum__Contact__c =  null;
        shftListhistory[6].sirenum__Scheduled_Start_Time__c = System.now()-21;
        shftListhistory[6].sirenum__Scheduled_End_Time__c = System.now()-20;
        shftListhistory[6].sirenum__Actual_Start_Time__c = System.now()-21;
        shftListhistory[6].sirenum__Actual_End_Time__c = System.now()-20;
        shftListhistory[6].sirenum__Placement__c = splacement.id;
        shftListhistory[6].IP_CandidateApproved__c = true;
        shftListhistory[6].sirenum__Cancelled__c  = false;
        shftListhistory[6].sirenum__site__c = sites.Id;
        shftListhistory[6].sirenum__Team__c = tm.id;
        shftListhistory[6].sirenum__Published__c = true;
        shftListhistory[7].sirenum__Contact__c =  conId1[0].id;
        shftListhistory[7].sirenum__Scheduled_Start_Time__c = System.now()-2;
        shftListhistory[7].sirenum__Scheduled_End_Time__c = System.now()-1;
        shftListhistory[7].sirenum__Actual_Start_Time__c = System.now()-2;
        shftListhistory[7].sirenum__Actual_End_Time__c = System.now()-1;
        shftListhistory[7].sirenum__Placement__c = splacement.id;
        shftListhistory[7].IP_CandidateApproved__c = true;
        shftListhistory[7].sirenum__Cancelled__c  = false;
        shftListhistory[7].sirenum__site__c = sites.Id;
        shftListhistory[7].sirenum__Team__c = tm.id;
        shftListhistory[7].sirenum__Published__c = true;
        shftListhistory[8].sirenum__Contact__c =  conId1[0].id;
        shftListhistory[8].sirenum__Scheduled_Start_Time__c = System.now()-2;
        shftListhistory[8].sirenum__Scheduled_End_Time__c = System.now()-1;
        shftListhistory[8].sirenum__Actual_Start_Time__c = System.now()-2;
        shftListhistory[8].sirenum__Actual_End_Time__c = System.now()-1;
        shftListhistory[8].sirenum__Placement__c = splacement.id;
        shftListhistory[8].IP_CandidateApproved__c = true;
        shftListhistory[8].sirenum__Cancelled__c  = false;
        shftListhistory[8].sirenum__site__c = sites.Id;
        shftListhistory[8].sirenum__Team__c = tm.id;
        shftListhistory[8].sirenum__Published__c = true;
        insert shftListhistory;

        sirenum__shift__c shftrec = TestDataFactory.createShift(splacement.id, sites.id,1)[0];
        shftrec.sirenum__Placement__c = splacement.id;
        shftrec.sirenum__Contact__c =  conId1[1].id;
        insert shftrec;
        System.debug('Check shift list'+shftrec);

        test.startTest();
        System.runAs(ccUser){
            Shifthistorydetails.getShiftshistory(sites.id, tm.id, 'Mon, 6 May 15 - Thu, 6 Jun 19');
            Shifthistorydetails.getShiftshistory(sites.id, tm.id, 'Mon, 6 May 15');
            Shifthistorydetails.getShiftshistory(sites.id, tm.id, null);
            Shifthistorydetails.getShiftshistory(sites.id, null, null);
            Shifthistorydetails.getShiftshistory(null, null, null);
            Shifthistorydetails.getSites();
            Shifthistorydetails.getJobRoles();
            Shifthistorydetails.fetchUser();
            Shifthistorydetails.getUserInformation();
        }
        test.stopTest();
    }

    @istest
    static void shifthistory2() {
        User u = [select id , contactId from user where Email = 'mm.sf@outlook123.com' limit 1];

        Account acct1 = [SELECT Id, Name, (SELECT Id FROM Contacts) FROM Account WHERE RecordType.Name != 'Candidate'];
        User ccUser = [SELECT Id, ContactId FROM User WHERE Contact.Account.Id =: acct1.Id LIMIT 1];

        Account acct = [SELECT Id, Name, (SELECT Id FROM Contacts) FROM Account WHERE RecordType.Name = 'Candidate'];
        List<Contact> conId1 = acct.Contacts;
        Contact cond = conId1[0];

        IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0];
        Insert tgci;

        sirenum__Site__c sites =  TestDataFactory.createSites(acct.id, tgci.id, 1)[0];
        sites.ownerId = u.id;
        sites.sirenum__Operating_Company__c = acct1.id;
        sites.IP_MainContact__c = ccUser.ContactId;
        sites.IP_InvoiceContact__c = ccUser.ContactId;
        sites.IP_PassClientToTempest__c = false;
        Insert sites;

        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(acct.id, cond.id,1)[0];
        pac.sirenum__Client__c = acct1.id;
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

        List<sirenum__Shift__c> shftListhistory = TestDataFactory.createShift(splacement.id, sites.id,9);
        //List<contact> conId1 = [select id, name from contact where lastname like 'McTesty%' limit 5];
        shftListhistory[0].sirenum__Contact__c =  conId1[0].id;
        shftListhistory[0].sirenum__Scheduled_Start_Time__c = System.now()-28;
        shftListhistory[0].sirenum__Scheduled_End_Time__c = System.now()-24;
        shftListhistory[0].sirenum__Placement__c = splacement.id;
        shftListhistory[0].IP_CandidateApproved__c = true;
        shftListhistory[0].StartTime__c = '10:30';
        shftListhistory[0].EndTime__c = '18:30';
        shftListhistory[0].sirenum__site__c = sites.Id;
        shftListhistory[0].sirenum__Team__c = tm.id;
        shftListhistory[1].sirenum__Contact__c =  conId1[1].id;
        shftListhistory[1].sirenum__Scheduled_Start_Time__c = System.now()-34;
        shftListhistory[1].sirenum__Scheduled_End_Time__c = System.now()-30;
        shftListhistory[1].sirenum__Actual_Start_Time__c = System.now()-34;
        shftListhistory[1].sirenum__Actual_End_Time__c = System.now()-30;
        shftListhistory[1].sirenum__Placement__c = splacement.id;
        shftListhistory[1].IP_CandidateApproved__c = true;
        shftListhistory[1].StartTime__c = '10:30';
        shftListhistory[1].EndTime__c = '18:30';
        shftListhistory[1].sirenum__site__c = sites.Id;
        shftListhistory[1].sirenum__Team__c = tm.id;
        shftListhistory[2].sirenum__Contact__c =  conId1[0].id;
        shftListhistory[2].sirenum__Scheduled_Start_Time__c = System.now()-2;
        shftListhistory[2].sirenum__Scheduled_End_Time__c = System.now()-1;
        shftListhistory[2].sirenum__Actual_Start_Time__c = System.now()-2;
        shftListhistory[2].sirenum__Actual_End_Time__c = System.now()-1;
        shftListhistory[2].sirenum__Placement__c = splacement.id;
        shftListhistory[2].IP_CandidateApproved__c = true;
        shftListhistory[2].sirenum__Cancelled__c  = false;
        shftListhistory[2].sirenum__site__c = sites.Id;
        shftListhistory[2].sirenum__Team__c = tm.id;
        shftListhistory[3].sirenum__Contact__c =  conId1[0].id;
        shftListhistory[3].sirenum__Scheduled_Start_Time__c = System.now()-4;
        shftListhistory[3].sirenum__Scheduled_End_Time__c = System.now()-3;
        shftListhistory[3].sirenum__Actual_Start_Time__c = System.now()-4;
        shftListhistory[3].sirenum__Actual_End_Time__c = System.now()-3;
        shftListhistory[3].sirenum__Placement__c = splacement.id;
        shftListhistory[3].IP_CandidateApproved__c = true;
        shftListhistory[3].sirenum__Cancelled__c  = false;
        shftListhistory[3].sirenum__site__c = sites.Id;
        shftListhistory[3].sirenum__Team__c = tm.id;
        shftListhistory[4].sirenum__Contact__c =  conId1[0].id;
        shftListhistory[4].sirenum__Scheduled_Start_Time__c = System.now()-21;
        shftListhistory[4].sirenum__Scheduled_End_Time__c = System.now()-20;
        shftListhistory[4].sirenum__Actual_Start_Time__c = System.now()-21;
        shftListhistory[4].sirenum__Actual_End_Time__c = System.now()-20;
        shftListhistory[4].sirenum__Placement__c = splacement.id;
        shftListhistory[4].IP_CandidateApproved__c = true;
        shftListhistory[4].sirenum__Cancelled__c  = false;
        shftListhistory[4].sirenum__site__c = sites.Id;
        shftListhistory[4].sirenum__Team__c = tm.id;
        shftListhistory[5].sirenum__Contact__c =  null;
        shftListhistory[5].sirenum__Scheduled_Start_Time__c = System.now()-21;
        shftListhistory[5].sirenum__Scheduled_End_Time__c = System.now()-20;
        shftListhistory[5].sirenum__Actual_Start_Time__c = System.now()-21;
        shftListhistory[5].sirenum__Actual_End_Time__c = System.now()-20;
        shftListhistory[5].sirenum__Placement__c = splacement.id;
        shftListhistory[5].IP_CandidateApproved__c = true;
        shftListhistory[5].sirenum__Cancelled__c  = false;
        shftListhistory[5].sirenum__Broadcasts__c = 2;
        shftListhistory[5].sirenum__site__c = sites.Id;
        shftListhistory[5].sirenum__Team__c = tm.id;
        shftListhistory[6].sirenum__Contact__c =  null;
        shftListhistory[6].sirenum__Scheduled_Start_Time__c = System.now()-21;
        shftListhistory[6].sirenum__Scheduled_End_Time__c = System.now()-20;
        shftListhistory[6].sirenum__Actual_Start_Time__c = System.now()-21;
        shftListhistory[6].sirenum__Actual_End_Time__c = System.now()-20;
        shftListhistory[6].sirenum__Placement__c = splacement.id;
        shftListhistory[6].IP_CandidateApproved__c = true;
        shftListhistory[6].sirenum__Cancelled__c  = false;
        shftListhistory[6].sirenum__site__c = sites.Id;
        shftListhistory[6].sirenum__Team__c = tm.id;
        shftListhistory[7].sirenum__Contact__c =  conId1[0].id;
        shftListhistory[7].sirenum__Scheduled_Start_Time__c = System.now()-2;
        shftListhistory[7].sirenum__Scheduled_End_Time__c = System.now()-1;
        shftListhistory[7].sirenum__Actual_Start_Time__c = System.now()-2;
        shftListhistory[7].sirenum__Actual_End_Time__c = System.now()-1;
        shftListhistory[7].sirenum__Placement__c = splacement.id;
        shftListhistory[7].IP_CandidateApproved__c = true;
        shftListhistory[7].sirenum__Cancelled__c  = false;
        shftListhistory[7].sirenum__site__c = sites.Id;
        shftListhistory[7].sirenum__Team__c = tm.id;
        shftListhistory[8].sirenum__Contact__c =  conId1[0].id;
        shftListhistory[8].sirenum__Scheduled_Start_Time__c = System.now()-2;
        shftListhistory[8].sirenum__Scheduled_End_Time__c = System.now()-1;
        shftListhistory[8].sirenum__Actual_Start_Time__c = System.now()-2;
        shftListhistory[8].sirenum__Actual_End_Time__c = System.now()-1;
        shftListhistory[8].sirenum__Placement__c = splacement.id;
        shftListhistory[8].IP_CandidateApproved__c = true;
        shftListhistory[8].sirenum__Cancelled__c  = false;
        shftListhistory[8].sirenum__site__c = sites.Id;
        shftListhistory[8].sirenum__Team__c = tm.id;
        insert shftListhistory;

        sirenum__shift__c shftrec = TestDataFactory.createShift(splacement.id, sites.id,1)[0];
        shftrec.sirenum__Placement__c = splacement.id;
        shftrec.sirenum__Contact__c =  conId1[1].id;
        insert shftrec;
        System.debug('Check shift list'+shftrec);
        test.startTest();
        System.runAs(ccUser) {
            Shifthistorydetails.submitRatings(shftrec.id, '1', sites.id, tm.id, cond.id, 'Mon, 6 May 15 - Thu, 6 Jun 19');
            Shifthistorydetails.submitRatings(shftrec.id, '2', sites.id, tm.id, cond.id, 'Mon, 6 May 15 - Thu, 6 Jun 19');
            Shifthistorydetails.submitRatings(shftrec.id, '3', sites.id, tm.id, cond.id, 'Mon, 6 May 15 - Thu, 6 Jun 19');
            Shifthistorydetails.submitRatings(shftrec.id, '4', sites.id, tm.id, cond.id, 'Mon, 6 May 15 - Thu, 6 Jun 19');
            Shifthistorydetails.submitRatings(shftrec.id, '5', sites.id, tm.id, cond.id, 'Mon, 6 May 15 - Thu, 6 Jun 19');
        }
        test.stopTest();

    }
}