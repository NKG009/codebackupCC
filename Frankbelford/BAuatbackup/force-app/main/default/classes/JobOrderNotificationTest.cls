/**
 * Created by mrahman on 2020-10-07.
 */

@IsTest
private class JobOrderNotificationTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @TestSetup
    static void setupTestData() {
        Account client = TestDataFactory.createAccounts(1)[0];
        Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
        Account supplier = TestDataFactory.create2ndTierSupplierAccount(1)[0];
        insert new List<Account>{client, candidateAcc, supplier};

        TestDataFactory.setupCustomSettings(candidateAcc.Id);
        TestDataFactory.setupUserProfileCustomSettings();

        Contact clientContact = TestDataFactory.createContact(client.Id,1)[0];
        Contact supplierContact = TestDataFactory.createContact(supplier.Id,1)[0];
        Contact worker = TestDataFactory.createCandidate(candidateAcc.Id, 1)[0];
        insert new List<Contact>{clientContact, worker, supplierContact};

        sirenum__ProActiveContract__c contract = TestDataFactory.sirenumProActiveContract(client.Id, clientContact.Id, 1)[0];
        insert contract;

        sirenum__Rota__c jobSector = TestDataFactory.createSector(1)[0];
        insert jobSector;

        sirenum__Job_Type__c jobType = TestDataFactory.createJobType(jobSector.Id, 1)[0];
        insert jobType;

        //Topaz Client Id
        IP_TopazGlobalClientInformation__c topazClientInfo = TestDataFactory.createTopaz(1)[0];
        //topazClientInfo.IP_TopazUniquenumber__c=1069;
        insert topazClientInfo;

        //Site
        sirenum__Site__c site = TestDataFactory.createSites(client.Id, topazClientInfo.Id, 1)[0];
        insert site;

        //Job Category
        sirenum__Job_Type__c jobCatagory = TestDataFactory.createJobType(jobSector.Id, 1)[0];
        insert jobCatagory;

        //jobRole
        sirenum__Team__c jobRole = TestDataFactory.createJobRole(contract.Id, jobCatagory.Id, 1)[0];
        insert jobRole;

        //Work Schedule
        sirenum__WorkSchedule__c workSchedule = TestDataFactory.createWorkSchedules(client.Id, 1)[0];
        insert workSchedule;

        //Job Order
        sirenum__JobOrder__c jobOrder = TestDataFactory.createJobOrders(client.Id, contract.Id, jobType.Id, site.Id, jobRole.Id, workSchedule.Id, 1)[0];
        insert jobOrder;

        String profileId = User_Profile_Id__c.getValues(Label.VMS_Portal_2nd_Tier_Supplier_Profile).Profile_Id__c;
        User supplierUser = TestDataFactory.createUsers(profileId, 1)[0];
        //supplierUser.Email = supplierContact.Email;
        supplierUser.FirstName = supplierContact.FirstName;
        supplierUser.LastName = supplierContact.LastName;
        supplierUser.ContactId = supplierContact.Id;
        supplierUser.IP_TempestDepartment__c = '1062';
        supplierUser.IP_TempestDivision__c = 'SYS';
        supplierUser.IP_TempestId__c='1287awfdqg';
        TestDataFactory.insertUser(new List<String>{JSON.serialize(supplierUser)});

    }

    @IsTest
    static void testSend2ndTierJobOrderNotification() {
        System.debug('Staring Test....');
        Map<String, Account> accountMap = new Map<String, Account>();
        for(Account a : [SELECT Id, Name, RecordType.Name, (SELECT Id, FirstName, Email FROM Contacts) FROM Account]) {
            accountMap.put(a.RecordType.Name, a);
        }
        User u = [SELECT Id, FirstName, LastName, Username, ContactId FROM User WHERE ContactId =: accountMap.get('2nd Tier Supplier').Contacts[0].Id];
        sirenum__JobOrder__c jobOrder = [SELECT Id, Name, sirenum__Account__c, sirenum__Contract__c FROM sirenum__JobOrder__c];
        //Subscriptions
        Subscriptions__c subscription = TestDataFactory.createJobOrderSubscription(accountMap.get('Account').Id, jobOrder.Id, new List<Id>{u.Id})[0];
        insert subscription;
        Test.startTest();
        List<Subscriptions__c> subscriptions = [SELECT Id, Name
                                                        ,User__c
                                                        ,User__r.ContactId
                                                        ,Account__r.Id
                                                        ,Supplier_Email_Sent__c
                                                        ,Supplier_SLA_Email_Date__c
                                                        ,Job_Order__r.Name
                                                        ,Job_Order__r.sirenum__StartDate__c
                                                        ,Job_Order__r.sirenum__EndDate__c
                                                FROM Subscriptions__c
                                                WHERE Supplier_Email_Sent__c = false];
        System.assert(subscriptions.size()>0, 'No Subscriptions were found');
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new Send2ndTierJobOrderNotification());
        Test.stopTest();
        subscriptions = [SELECT Id, Name
                                ,User__c
                                ,User__r.ContactId
                                ,Account__r.Id
                                ,Supplier_Email_Sent__c
                                ,Supplier_SLA_Email_Date__c
                                ,Job_Order__r.Name
                                ,Job_Order__r.sirenum__StartDate__c
                                ,Job_Order__r.sirenum__EndDate__c
                        FROM Subscriptions__c
                        WHERE Supplier_Email_Sent__c = true];
        System.assert(subscriptions.size()>0, 'Subscription email may not have sent');
    }
}