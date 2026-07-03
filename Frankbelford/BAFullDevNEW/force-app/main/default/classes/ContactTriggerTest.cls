@istest
public with sharing class ContactTriggerTest {
    @TestSetup
    static void prepareTest(){
        Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
        insert candidateAcc;
        TestDataFactory.setupCustomSettings(candidateAcc.Id);
        Id urId = [SELECT Id FROM UserRole WHERE Name='Impellam IT'].Id;
        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = new User(LastName = 'l4848',FirstName='JASON',Alias = 'jliv',Email = 'mm.sf@outlook123.com',
                Username = 'dummydcwecweEmail6786367@email.com', ProfileId = p.id, TimeZoneSidKey = 'GMT',
                LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',IP_TempestDepartment__c='1010',
                IP_TempestDivision__c='NTS',Department='1010',IP_PassToTempest__c=true, Brand__c='Blue Arrow',
                UserRoleId = urId);
        TestDataFactory.insertUser(new List<String> {JSON.serialize(u)});
        TestDataFactory.setupUserProfileCustomSettings();
    }
    
    @isTest
    public static void upsertTest(){
        
        Account client = TestDataFactory.createClients(1)[0];
        Account supplierA = TestDataFactory.create2ndTierSupplierAccount(1)[0];
        Account supplierB = TestDataFactory.create2ndTierSupplierAccount(1)[0];
        Account candidateAcc = [SELECT Id, Name FROM Account WHERE RecordType.Name = 'Candidate' LIMIT 1];
        insert new List<Account>{client, supplierA, supplierB};

        User consultant = [SELECT Id, Username FROM User WHERE Username = 'dummydcwecweEmail6786367@email.com' Limit 1];
        //List<Contact> workers = TestDataFactory.createContact(client.Id, 100); // THIS IS FOR BULK TEST
        Contact clientContact = TestDataFactory.createContact(client.Id, 1)[0];
        Contact candidate = TestDataFactory.createCandidate(candidateAcc.Id, 1)[0];
        List<Contact> w2nds = TestDataFactory.createCandidate2ndTier(supplierA.Id, 3);
        Contact candidate2ndTier = w2nds[0];
        Contact worker2ndTier = w2nds[1];
        worker2ndTier.IP_Pass2ndTierToTempest__c = false;
        worker2ndTier.IP_FirstPassExternalWorker__c = false;
        worker2ndTier.IP_LastPassedToTempest2ndTier__c = null;
        worker2ndTier.OwnerId = consultant.Id;
        insert new List<Contact>{clientContact, candidate, candidate2ndTier, worker2ndTier};

        Test.startTest();
        candidate2ndTier.IP_2nd_Tier_Supplier__c = supplierB.Id;
        worker2ndTier.IP_Pass2ndTierToTempest__c = true;
        update new List<Contact>{candidate2ndTier, worker2ndTier};
        System.assertEquals(supplierB.Id, [SELECT Id, IP_2nd_Tier_Supplier__c FROM Contact WHERE Id=:candidate2ndTier.Id].IP_2nd_Tier_Supplier__c);
        System.assertEquals(true, [SELECT Id, IP_Pass2ndTierToTempest__c FROM Contact WHERE Id=:worker2ndTier.Id].IP_Pass2ndTierToTempest__c);
        Test.stopTest();
    }

    @isTest
    public static void createPortalUserInsertTest(){
        Account client = TestDataFactory.createClients(1)[0];
        Account supplierA = TestDataFactory.create2ndTierSupplierAccount(1)[0];
        supplierA.Portal_Username__c = 'test';
        Account candidateAcc = [SELECT Id, Name FROM Account WHERE RecordType.Name = 'Candidate' LIMIT 1];
        insert new List<Account>{client, supplierA};

        Contact clientContact = TestDataFactory.createContact(client.Id, 1)[0];
        insert new List<Contact>{clientContact};
        List<Contact> candidates = TestDataFactory.createCandidate(candidateAcc.Id, 2);
        candidates[0].MailingStreet = null;
        candidates[0].TOE_Completed__c = true;
        candidates[1].MailingStreet = '1123 Long long long Mailing Street, This is actually longer then sixty characters. Can you believe that?';
        candidates[1].TOE_Completed__c = false;
        candidates[1].MailingCountry='india';

        List<Contact> candidates2ndTier = TestDataFactory.createCandidate2ndTier(supplierA.Id, 2);
        candidates2ndTier[0].MailingStreet = '9990 This Mailing Street is more then 30 characters';
        candidates2ndTier[0].IP_ComplianceConfirmedBy2ndTier__c = true;
        candidates2ndTier[1].IP_ComplianceConfirmedBy2ndTier__c = false;
        candidates2ndTier[1].MailingCountry='india';
        System.debug('candidates2ndTier:: ' + candidates2ndTier);


        Test.startTest();
        insert candidates;
        insert candidates2ndTier;
        //System.assertEquals(supplierB.Id, candidate2ndTier.IP_2nd_Tier_Supplier__c);
        Test.stopTest();

        List<User> puList0 = [SELECT Id, username, email FROM User WHERE Contact.Id IN : candidates];
        System.assertEquals(0,puList0.size(),'In correct number of user records were created. ' + puList0);

        List<User> puList1 = [SELECT Id, username, email FROM User WHERE Contact.Id IN: candidates2ndTier]; //, candidates2ndTier[1].Id)];
        System.assertEquals(1,puList1.size(),'In correct number of 2nd tier candidate user records were created. ' + puList1);
        System.assert(((String)puList1[0].username).contains('.test'), '2nd Tier worker username does not have the suffix:: ' + (String)puList1[0].username);

    }

    @isTest
    public static void createPortalUserUpdateTest(){
        Account client = TestDataFactory.createClients(1)[0];
        Account supplierA = TestDataFactory.create2ndTierSupplierAccount(1)[0];
        supplierA.Portal_Username__c = 'test';
        Account candidateAcc = [SELECT Id, Name FROM Account WHERE RecordType.Name = 'Candidate' LIMIT 1];
        insert new List<Account>{client, supplierA};

        /*insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candidateAcc.Id);
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        insert new User_Profile_Id__c (name = 'User Portal', Profile_Id__c = '00e0Y000000QNyxQAG');*/

        Contact clientContact = TestDataFactory.createContact(client.Id, 1)[0];
        insert new List<Contact>{clientContact};
        List<Contact> candidates = TestDataFactory.createCandidate(candidateAcc.Id, 2);
        candidates[0].TOE_Completed__c = true;
        candidates[1].TOE_Completed__c = false;

        List<Contact> candidates2ndTier = TestDataFactory.createCandidate2ndTier(supplierA.Id, 2);
        candidates2ndTier[0].IP_ComplianceConfirmedBy2ndTier__c = true;
        candidates2ndTier[1].IP_ComplianceConfirmedBy2ndTier__c = false;
        System.debug('candidates2ndTier:: ' + candidates2ndTier);
        insert candidates;
        insert candidates2ndTier;

        Test.startTest();
        candidates[1].TOE_Completed__c = true;
        update candidates[1];
        candidates2ndTier[1].IP_ComplianceConfirmedBy2ndTier__c = true;
        update candidates2ndTier[1]; //new List<Contact>{candidates[1], candidates2ndTier[1]};
        //System.assertEquals(supplierB.Id, candidate2ndTier.IP_2nd_Tier_Supplier__c);
        Test.stopTest();

        List<User> puList0 = [SELECT Id, username, email FROM User WHERE Contact.Id IN : candidates];
        System.assertEquals(1,puList0.size(),'In correct number of user records were created. ' + puList0);
        System.assert(!((String)puList0[0].username).contains('.test'), 'Worker username have suffix:: ' + (String)puList0[0].username);

        List<User> puList1 = [SELECT Id, username, email FROM User WHERE Contact.Id IN: candidates2ndTier]; //, candidates2ndTier[1].Id)];
        System.assertEquals(2,puList1.size(),'In correct number of 2nd tier candidate user records were created. ' + puList1);
        System.assert(((String)puList1[1].username).contains('.test'), '2nd Tier worker username does not have the suffix:: ' + (String)puList1[0].username);

    }
}