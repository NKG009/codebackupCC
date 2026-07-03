/**
 * Created by mrahman on 2020-09-09.
 */

@IsTest
private class BlueBarCompControllerTest {
    @TestSetup
    static void setupSiteContact(){
        Account client = TestDataFactory.createClients(1)[0];
        client.VMS_Client__c = true;
        Account candidateAccount = TestDataFactory.createCandidateAccount(1)[0];
        insert new List<Account> {candidateAccount, client};
        TestDataFactory.setupCustomSettings(candidateAccount.Id);
        TestDataFactory.setupUserProfileCustomSettings();

        Contact clientContact = TestDataFactory.createContact(client.Id, 1)[0];
        Contact worker = TestDataFactory.createCandidate(candidateAccount.Id, 1)[0];
        insert new List<Contact>{worker, clientContact};
        IP_PayProfile__c ppPAYE = TestDataFactory.createPayProfilePaye(worker.Id, 1)[0];
        insert ppPAYE;

        //TestDataFactory.setupShifts();
        StagingJobOrder__c sjobOrder = TestDataFactory.createStagingJobOrders(1)[0];
        insert sjobOrder;
        StagingShift__c sShift = TestDataFactory.createStagingShifts(sjobOrder, 1)[0];
        insert sShift;
        insert new StagingJobApplication__c(stgFrontOfficeIntegrationSystem__c = sjobOrder.StgFrontOfficeIntegrationSystem__c
                ,stgVmsClientId__c = sjobOrder.StgClient_Id__c
                ,stgVmsRoleId__c = sjobOrder.StgRoleId__c
                ,stgPayProfile__c = ppPAYE.Id
                ,stgAtsCandidateIntegrationRef__c = worker.Id
                ,stgApplicationStatus__c = 'New'
                ,stgSubmissionDatetime__c = Datetime.now().addDays(-3));

        //CONTSULTANT
        User consultantUser = [SELECT Id, Name, Username
        FROM User
        WHERE IsActive = true
        AND Profile.Id=: User_Profile_Id__c.getValues('JS Recruiter - Hybrid').Profile_Id__c LIMIT 1];

        //TOPAZ - IP_TopazGlobalClientInformation__c
        IP_TopazGlobalClientInformation__c topzClientInfo = TestDataFactory.createTopaz(1)[0];
        topzClientInfo.Name = client.Name;
        topzClientInfo.IP_SalesLedgerNumber__c='345432';
        insert topzClientInfo;

        sirenum__Site__c site = TestDataFactory.createSites(client.Id, topzClientInfo.Id, 1)[0];
        insert site;


        sirenum__ProActiveContract__c contract = TestDataFactory.sirenumProActiveContract(client.Id, clientContact.Id, 1)[0];
        insert  contract;

        Contact_Site_link__c csl = TestDataFactory.createSiteLinks(client.Id, site.Id, new List<Id>{clientContact.Id})[0];
        csl.IP_PortalType__c = 'VMS User';
        insert csl;

        Integer randomInt = (Math.random()*10000).intValue();
        Id cuProfileId = User_Profile_Id__c.getValues('Customer Portal Manager Custom').Profile_Id__c;
        User clientConUser = TestDataFactory.createUsers(cuProfileId,1)[0];
        clientConUser.ContactId = clientContact.Id;
        clientConUser.Username = 'test_'+randomInt+'_ccu@test.com';
        System.debug(clientContact.Id + ' <<< clientConUser >>> ' + clientConUser);
        TestDataFactory.insertUser(new List<String> {JSON.serialize(clientConUser)});

        //SECTOR - sirenum__Rota__c
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0];
        insert sector;

        //JOB TYPE - sirenum__Job_Type__c
        sirenum__Job_Type__c jobType = TestDataFactory.createJobType(sector.Id, 1)[0];
        insert jobType;

        //JOB ROLL - sirenum__Team__c
        sirenum__Team__c jobrole = TestDataFactory.createJobRole(contract.Id, jobType.Id, 1)[0];
        insert jobrole;

        sirenum__Placement__c sPlacement = new sirenum__Placement__c(
                Name = 'Sunday to Saturday Placement',
                IP_Consultant1LookupSplitShare__c= consultantUser.Id,
                sirenum__Contact__c = worker.Id,
                sirenum__Site__c= site.Id,
                sirenum__Job_Role__c = jobrole.Id,
                sirenum__Contract__c = contract.Id,
                sirenum__Status__c = 'Active',
                sirenum__Start_Date__c = Datetime.now().addDays(-60).date().toStartOfWeek(),
                IP_Consultant1PercentageSplit__c=100);
        insert sPlacement;
    }

    @IsTest
    static void doVMSUserTest() {
        //@TODO
        Account client = [SELECT Id, Name, (SELECT Id, Email FROM Contacts) FROM Account WHERE RecordType.Name='Account' LIMIT 1];
        //Contact clientContact = [SELECT Id, Email FROM Contact WHERE AccountId =:]
        User clientUser = [SELECT Id, Username FROM User WHERE ContactId =: client.Contacts[0].Id];
        Test.startTest();
        Boolean isVMSUser = BlueBarCompController.getVMSSubscriptoinFlag(clientUser.Id);
        Test.stopTest();
        System.assert(isVMSUser,'User expected to be VMS Site users and account is VMS enabled account');
    }

    @IsTest
    static void doGetUserSitesTest() {
        //@TODO
        Account client = [SELECT Id, Name, (SELECT Id, Email FROM Contacts) FROM Account WHERE RecordType.Name='Account' LIMIT 1];
        //Contact clientContact = [SELECT Id, Email FROM Contact WHERE AccountId =:]
        User clientUser = [SELECT Id, Username FROM User WHERE ContactId =: client.Contacts[0].Id];
        Test.startTest();
        List<sirenum__Site__c> sites = BlueBarCompController.getUserSites(clientUser.Id);
        Test.stopTest();
        System.assert(sites.size()>0,'No site found');
    }
}