/**
 * Created by mrahman on 2021-02-23.
 */

@IsTest
private class VmsCopyMoveCandidateMappingTest {
    @TestSetup
    static void setupVmsJobApplication(){
        Account client = TestDataFactory.createClients(1)[0];
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

        //SECTOR - sirenum__Rota__c
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0];
        insert sector;

        //JOB TYPE - sirenum__Job_Type__c
        sirenum__Job_Type__c jobType = TestDataFactory.createJobType(sector.Id, 1)[0];
        insert jobType;

        //JOB ROLL - sirenum__Team__c
        sirenum__Team__c jobrole = TestDataFactory.createJobRole(contract.Id, jobType.Id, 1)[0];
        insert jobrole;

        sirenum__WorkSchedule__c workSchedule = TestDataFactory.createWorkSchedules(client.Id, 1)[0];
        insert workSchedule;

        String stgJOId = sjobOrder.StgRoleId__c + '-' + sjobOrder.StgFrontOfficeIntegrationSystem__c;
        sirenum__JobOrder__c sjo = TestDataFactory.createJobOrders (client.Id, contract.Id, jobType.Id, site.Id, jobrole.Id, workSchedule.Id, 1)[0]; //[SELECT Id, Name FROM sirenum__JobOrder__c LIMIT 1]; //WHERE External_ID__c =: stgJOId];
        sjo.External_ID__c = stgJOId;
        insert sjo;

        StagingJobApplication__c sja = new StagingJobApplication__c(stgFrontOfficeIntegrationSystem__c = sjobOrder.StgFrontOfficeIntegrationSystem__c
                ,stgVmsClientId__c = sjobOrder.StgClient_Id__c
                ,stgVmsRoleId__c = sjobOrder.StgRoleId__c
                ,stgPayProfile__c = ppPAYE.Id
                ,stgAtsCandidateIntegrationRef__c = worker.Id
                ,stgApplicationStatus__c = 'New'
                ,Job_Order_Lookup__c = sjo.Id
                ,stgSubmissionDatetime__c = Datetime.now().addDays(-3)
                ,PORTW_Type__c = '(A1) UK / EEA Passport'
                ,References_Checked__c=true
                ,Proof_of_ID__c=true);
        insert sja;
        ContentVersion cv = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
        );
        insert cv;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = sja.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;

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
    static void testVmsCopyMoveCandidateMapping() {
        StagingJobApplication__c sja = [SELECT stgVmsClientId__c, stgVmsRoleId__c, stgVmsShiftId__c, StagingJobOrder__r.stgCandidateRoleId__c, StgFrontOfficeIntegrationSystem__c
                                        FROM StagingJobApplication__c LIMIT 1];
        Test.startTest();
            VmsCopyMoveCandidateMapping mappingDef = new VmsCopyMoveCandidateMapping(sja);
            VmsCopyMoveCandidateMapping mapping = new VmsCopyMoveCandidateMapping(sja);
        Test.stopTest();
        System.assert(sja.stgVmsClientId__c == mapping.stgVmsClientId);
    }
}