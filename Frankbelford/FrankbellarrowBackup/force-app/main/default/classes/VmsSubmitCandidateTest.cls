@isTest
private class VmsSubmitCandidateTest {
    @testSetup
    static void setupVmsJobApplication() {
        Account client = TestDataFactory.createClients(1)[0];
        Account candidateAccount = TestDataFactory.createCandidateAccount(1)[0];
        insert new List<Account> {
            candidateAccount,
            client
        };

        TestDataFactory.setupCustomSettings(candidateAccount.Id);
        TestDataFactory.setupUserProfileCustomSettings();

        Contact clientContact = TestDataFactory.createContact(client.Id, 1)[0];
        system.debug('clientContact@@@---->'+clientContact);
        Contact worker = TestDataFactory.createCandidate(candidateAccount.Id, 1)[0];
        insert new List<Contact> {
            worker,
            clientContact
        };
        system.debug('clientContact@@@---12345->'+clientContact);
        IP_PayProfile__c ppPAYE = TestDataFactory.createPayProfilePaye(worker.Id, 1)[0];
        insert ppPAYE;

        StagingJobOrder__c sjobOrder = TestDataFactory.createStagingJobOrders(1)[0];
        //jyothi.start
        //sjobOrder.StgSourceSystem__c = Label.VMS_Lunar_Production_Database_Name;
        Boolean isSandbox = [SELECT IsSandbox FROM Organization].IsSandbox;
        sjobOrder.StgSourceSystem__c = isSandbox ? Label.VMS_Lunar_Sandbox_Database_Name : Label.VMS_Lunar_Production_Database_Name;
        //jyothi.stop
        sjobOrder.StgMoveOrCopy__c = 'Copy';
        insert sjobOrder;

        StagingShift__c sShift = TestDataFactory.createStagingShifts(sjobOrder, 1)[0];
        insert sShift;

        User consultantUser = [SELECT Name, Username FROM User WHERE IsActive = true AND
                               Profile.Id = :User_Profile_Id__c.getValues('JS Recruiter - Hybrid').Profile_Id__c LIMIT 1];

        IP_TopazGlobalClientInformation__c topzClientInfo = TestDataFactory.createTopaz(1)[0];
        topzClientInfo.Name = client.Name;
        topzClientInfo.IP_SalesLedgerNumber__c = '345432';
        insert topzClientInfo;

        sirenum__Site__c site = TestDataFactory.createSites(client.Id, topzClientInfo.Id, 1)[0];
        insert site;

        sirenum__ProActiveContract__c contract = TestDataFactory.sirenumProActiveContract(client.Id, clientContact.Id, 1)[0];
        insert contract;

        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0];
        insert sector;

        sirenum__Job_Type__c jobType = TestDataFactory.createJobType(sector.Id, 1)[0];
        insert jobType;

        sirenum__Team__c jobrole = TestDataFactory.createJobRole(contract.Id, jobType.Id, 1)[0];
        insert jobrole;

        sirenum__WorkSchedule__c workSchedule = TestDataFactory.createWorkSchedules(client.Id, 1)[0];
        insert workSchedule;

        String stgJOId = sjobOrder.StgRoleId__c + '-' + sjobOrder.StgFrontOfficeIntegrationSystem__c + '-' + String.valueOf(DateTime.now().getTime());
        sirenum__JobOrder__c sjo = TestDataFactory.createJobOrders(client.Id, contract.Id, jobType.Id, site.Id, jobrole.Id, workSchedule.Id, 1)[0];
        sjo.External_ID__c = stgJOId;
        insert sjo;

        StagingJobApplication__c sja = new StagingJobApplication__c(
            stgFrontOfficeIntegrationSystem__c = sjobOrder.StgFrontOfficeIntegrationSystem__c,
            stgVmsClientId__c = sjobOrder.StgClient_Id__c,
            stgVmsRoleId__c = sjobOrder.StgRoleId__c,
            stgPayProfile__c = ppPAYE.Id,
            stgAtsCandidateIntegrationRef__c = worker.Id,
            stgApplicationStatus__c = 'New',
            Job_Order_Lookup__c = sjo.Id,
            stgSubmissionDatetime__c = Datetime.now().addDays(-3),
            PORTW_Type__c = 'British Passport',
            References_Checked__c = true,
            Proof_of_ID__c = true,
            StagingJobOrder__c = sjobOrder.Id
        );
        insert sja;

        ContentVersion cv = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert cv;
        system.debug('CVVVCVVC@@@---->'+cv );
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = New ContentDocumentLink(
            LinkedEntityId = sja.Id,
            ContentDocumentId = documents[0].Id,
            shareType = 'V'
        );
        insert cdl;

        sirenum__Placement__c sPlacement = new sirenum__Placement__c(
            Name = 'Sunday to Saturday Placement',
            IP_Consultant1LookupSplitShare__c = consultantUser.Id,
            sirenum__Contact__c = worker.Id,
            sirenum__Site__c = site.Id,
            sirenum__Job_Role__c = jobrole.Id,
            sirenum__Contract__c = contract.Id,
            sirenum__Status__c = 'Active',
            sirenum__Start_Date__c = Datetime.now().addDays(-60).date().toStartOfWeek(),
            IP_Consultant1PercentageSplit__c = 100
        );
        insert sPlacement;
    }

    private static StagingJobApplication__c getPreSubmitStagingJobApplication() {
        return [SELECT
                    Name,
                    stgFrontOfficeIntegrationSystem__c,
                    stgVmsClientId__c,
                    stgVmsRoleId__c,
                    stgVmsShiftId__c,
                    stgAtsShiftIntegrationRef__c,
                    stgApplicationStatus__c,
                    stgSPlacementId__c,
                    stgSPlacementId__r.IP_AssignmentRef__c,
                    stgPayProfile__r.IP_PayrollID__c,
                    stgSubmissionDatetime__c,
                    stgSubmittedJSON__c,
                    PORTW_Type__c,
                    References_Checked__c,
                    Proof_of_ID__c,
                    Visa_Expiry_Date__c,
                    Visa_Type__c,
                    stgAtsCandidateIntegrationRef__r.Birthdate,
                    stgAtsCandidateIntegrationRef__r.ts2__EEO_Gender__c,
                    stgAtsCandidateIntegrationRef__r.Salutation,
                    stgAtsCandidateIntegrationRef__r.Title,
                    stgAtsCandidateIntegrationRef__r.Phone,
                    stgAtsCandidateIntegrationRef__r.MobilePhone,
                    stgAtsCandidateIntegrationRef__r.MailingState,
                    stgAtsCandidateIntegrationRef__r.MailingCountry,
                    stgAtsCandidateIntegrationRef__r.FirstName,
                    stgAtsCandidateIntegrationRef__r.LastName,
                    stgAtsCandidateIntegrationRef__r.Email,
                    stgAtsCandidateIntegrationRef__r.sirenum__National_Insurance__c,
                    stgAtsCandidateIntegrationRef__r.MailingStreet,
                    stgAtsCandidateIntegrationRef__r.MailingCity,
                    stgAtsCandidateIntegrationRef__r.MailingPostalCode,
                    StagingJobOrder__r.StgSourceSystem__c,
                    StagingJobOrder__r.StgMoveOrCopy__c,
                    StagingJobOrder__r.stgCandidateRoleId__c
                FROM StagingJobApplication__c LIMIT 1];
    }

    private static StagingJobApplication__c getPostSubmitStagingJobApplication(Id stgJAId) {
        return [SELECT
                    Name,
                    stgFrontOfficeIntegrationSystem__c,
                    stgVmsClientId__c,
                    stgVmsRoleId__c,
                    stgVmsShiftId__c,
                    stgAtsShiftIntegrationRef__c,
                    stgApplicationStatus__c,
                    stgSPlacementId__c,
                    stgSPlacementId__r.IP_AssignmentRef__c,
                    stgPayProfile__r.IP_PayrollID__c,
                    stgSubmissionDatetime__c,
                    stgSubmittedJSON__c,
                    PORTW_Type__c,
                    References_Checked__c,
                    Proof_of_ID__c,
                    Visa_Expiry_Date__c,
                    Visa_Type__c,
                    stgAtsCandidateIntegrationRef__r.FirstName,
                    stgAtsCandidateIntegrationRef__r.LastName,
                    stgAtsCandidateIntegrationRef__r.Email,
                    stgAtsCandidateIntegrationRef__r.sirenum__National_Insurance__c,
                    stgAtsCandidateIntegrationRef__r.MailingStreet,
                    stgAtsCandidateIntegrationRef__r.MailingCity,
                    stgAtsCandidateIntegrationRef__r.MailingPostalCode,
                    stgAtsCandidateIntegrationRef__r.Birthdate,
                    stgAtsCandidateIntegrationRef__r.ts2__EEO_Gender__c,
                    stgAtsCandidateIntegrationRef__r.Title,
                    stgAtsCandidateIntegrationRef__r.Phone,
                    stgAtsCandidateIntegrationRef__r.MailingState,
                    stgAtsCandidateIntegrationRef__r.MailingCountry,
                    StagingJobOrder__r.StgSourceSystem__c,
                    StagingJobOrder__r.StgMoveOrCopy__c,
                    StagingJobOrder__r.stgCandidateRoleId__c
                    FROM StagingJobApplication__c
                WHERE Id = :stgJAId];
    }

    @isTest
    static void testDoSubmitApplication_ConditionOne_TestCaseLunar() {
        Test.setMock(HttpCalloutMock.class, new VmsSubmitCandidateCalloutMock());

        StagingJobApplication__c stgJA = getPreSubmitStagingJobApplication();

        Test.startTest();
        VmsSubmitCandidate.doSubmitApplication(new List<String> { JSON.serializePretty(stgJA) });
        Test.stopTest();

        StagingJobApplication__c postStgJA = getPostSubmitStagingJobApplication(stgJA.Id);

        String expectedValue = JSON.serializePretty(new VmsCopyMoveCandidateMapping(stgJA));
        System.assertEquals(expectedValue, postStgJA.stgSubmittedJSON__c, 'Expected a response');
        System.assert(String.isNotBlank(String.valueOf(postStgJA.stgSubmissionDatetime__c)), 'Submission date time expected');
    }

    @isTest
    static void testDoSubmitApplication_ConditionOne_TestCaseCapita() {
        Test.setMock(HttpCalloutMock.class, new VmsSubmitCandidateCalloutMock());

        StagingJobOrder__c sjobOrder = [SELECT StgSourceSystem__c FROM StagingJobOrder__c];
        //jyothi.start
        //sjobOrder.StgSourceSystem__c = Label.VMS_Capita_Production_Database_Name;
        Boolean isSandbox = [SELECT IsSandbox FROM Organization].IsSandbox;
        sjobOrder.StgSourceSystem__c = isSandbox ? Label.VMS_Capita_Sandbox_Database_Name : Label.VMS_Capita_Production_Database_Name;
        //jyothi.stop
        
        update sjobOrder;

        StagingJobApplication__c stgJA = getPreSubmitStagingJobApplication();

        Test.startTest();
        VmsSubmitCandidate.doSubmitApplication(new List<String> { JSON.serializePretty(stgJA) });
        Test.stopTest();

        StagingJobApplication__c postStgJA = getPostSubmitStagingJobApplication(stgJA.Id);
        system.debug('postStgJA@@@---->'+postStgJA);

        String expectedValue = JSON.serializePretty(new VmsCopyMoveCandidateMappingCapita(stgJA));
        System.assertEquals(expectedValue, postStgJA.stgSubmittedJSON__c, 'Expected a response');
        System.assert(String.isNotBlank(String.valueOf(postStgJA.stgSubmissionDatetime__c)), 'Submission date time expected');
    }

    @isTest
    static void testDoSubmitApplication_ConditionTwo_TestCaseLunar() {
        Test.setMock(HttpCalloutMock.class, new VmsSubmitCandidateCalloutMock());

        StagingJobOrder__c sjobOrder = [SELECT StgSourceSystem__c, StgMoveOrCopy__c FROM StagingJobOrder__c];        
        //jyothi.start
        //sjobOrder.StgSourceSystem__c = Label.VMS_Lunar_Production_Database_Name;
        Boolean isSandbox = [SELECT IsSandbox FROM Organization].IsSandbox;
        sjobOrder.StgSourceSystem__c = isSandbox ? Label.VMS_Lunar_Sandbox_Database_Name : Label.VMS_Lunar_Production_Database_Name;
        //jyothi.stop
        sjobOrder.StgMoveOrCopy__c = null;
        update sjobOrder;

        StagingJobApplication__c stgJA = getPreSubmitStagingJobApplication();

        Test.startTest();
        VmsSubmitCandidate.doSubmitApplication(new List<String> { JSON.serializePretty(stgJA) });
        Test.stopTest();

        StagingJobApplication__c postStgJA = getPostSubmitStagingJobApplication(stgJA.Id);

        String expectedValue = JSON.serializePretty(new VmsCandidateMapping(stgJA));
        System.assertEquals(expectedValue, postStgJA.stgSubmittedJSON__c, 'Expected a response');
        System.assert(String.isNotBlank(String.valueOf(postStgJA.stgSubmissionDatetime__c)), 'Submission date time expected');
    }

    @isTest
    static void testDoSubmitApplication_ConditionTwo_TestCaseCapita() {
        Test.setMock(HttpCalloutMock.class, new VmsSubmitCandidateCalloutMock());

        StagingJobOrder__c sjobOrder = [SELECT StgSourceSystem__c, StgMoveOrCopy__c FROM StagingJobOrder__c];
        //jyothi.start
        //sjobOrder.StgSourceSystem__c = Label.VMS_Capita_Production_Database_Name;
        Boolean isSandbox = [SELECT IsSandbox FROM Organization].IsSandbox;
        sjobOrder.StgSourceSystem__c = isSandbox ? Label.VMS_Capita_Sandbox_Database_Name : Label.VMS_Capita_Production_Database_Name;
        //jyothi.stop
        sjobOrder.StgMoveOrCopy__c = null;
        update sjobOrder;

        StagingJobApplication__c stgJA = getPreSubmitStagingJobApplication();

        Test.startTest();
        VmsSubmitCandidate.doSubmitApplication(new List<String> { JSON.serializePretty(stgJA) });
        Test.stopTest();

        StagingJobApplication__c postStgJA = getPostSubmitStagingJobApplication(stgJA.Id);

        String expectedValue = JSON.serializePretty(new VmsCandidateMappingCapita(stgJA));
        System.assertEquals(expectedValue, postStgJA.stgSubmittedJSON__c, 'Expected a response');
        System.assert(String.isNotBlank(String.valueOf(postStgJA.stgSubmissionDatetime__c)), 'Submission date time expected');
    }

    @isTest
    static void testDoSubmitApplication_ConditionThree_TestCaseLunar() {
        Test.setMock(HttpCalloutMock.class, new VmsSubmitCandidateCalloutMock());

        sirenum__Placement__c sPlacement = [SELECT Id, Name FROM sirenum__Placement__c LIMIT 1];

        StagingJobApplication__c stgJA = [SELECT
                                            Name,
                                            stgFrontOfficeIntegrationSystem__c,
                                            stgVmsClientId__c,
                                            stgVmsRoleId__c,
                                            stgVmsShiftId__c,
                                            stgAtsShiftIntegrationRef__c,
                                            stgPayProfile__r.IP_PayrollID__c,
                                            stgAtsCandidateIntegrationRef__r.FirstName,
                                            stgAtsCandidateIntegrationRef__r.LastName,
                                            stgAtsCandidateIntegrationRef__r.Email,
                                            stgAtsCandidateIntegrationRef__r.sirenum__National_Insurance__c,
                                            stgSubmissionDatetime__c,
                                            stgSubmittedJSON__c,
                                            stgSubmissionStatus__c,
                                            StagingJobOrder__r.StgSourceSystem__c
                                          FROM StagingJobApplication__c LIMIT 1];
        stgJA.stgApplicationStatus__c = 'Accepted';
        stgJA.stgSPlacementId__c = sPlacement.Id;
        update stgJA;

        Test.startTest();
        VmsSubmitCandidate.doSubmitApplication(new List<String> {JSON.serializePretty(stgJA)});
        Test.stopTest();

        StagingJobApplication__c postStgJA = [SELECT
                                                Name,
                                                stgFrontOfficeIntegrationSystem__c,
                                                stgVmsClientId__c,
                                                stgVmsRoleId__c,
                                                stgVmsShiftId__c,
                                                stgAtsShiftIntegrationRef__c,
                                                stgPayProfile__r.IP_PayrollID__c,
                                                stgAtsCandidateIntegrationRef__r.FirstName,
                                                stgAtsCandidateIntegrationRef__r.LastName,
                                                stgAtsCandidateIntegrationRef__r.Email,
                                                stgAtsCandidateIntegrationRef__r.sirenum__National_Insurance__c,
                                                stgSubmissionDatetime__c,
                                                stgSubmittedJSON__c,
                                                stgSubmissionStatus__c,
                                                stgSPlacementId__c,
                                                StagingJobOrder__r.StgSourceSystem__c
                                             FROM StagingJobApplication__c LIMIT 1];

        System.assert(String.isBlank(stgJA.stgSubmissionStatus__c), 'Expected to be null or blank');
        System.assertEquals('S-Placement Submitted', postStgJA.stgSubmissionStatus__c, 'Expected to match submission status');
        System.assert(stgJA.stgSubmissionDatetime__c < postStgJA.stgSubmissionDatetime__c, 'Submission date time expected');
    }

    @isTest
    static void testDoSubmitApplication_ConditionThree_TestCaseCapita() {
        Test.setMock(HttpCalloutMock.class, new VmsSubmitCandidateCalloutMock());

        StagingJobOrder__c sjobOrder = [SELECT StgSourceSystem__c, StgMoveOrCopy__c FROM StagingJobOrder__c];
        //jyothi.start
        //sjobOrder.StgSourceSystem__c = Label.VMS_Capita_Production_Database_Name;
        Boolean isSandbox = [SELECT IsSandbox FROM Organization].IsSandbox;
        sjobOrder.StgSourceSystem__c = isSandbox ? Label.VMS_Capita_Sandbox_Database_Name : Label.VMS_Capita_Production_Database_Name;
        //jyothi.stop
        sjobOrder.StgMoveOrCopy__c = null;
        update sjobOrder;

        sirenum__Placement__c sPlacement = [SELECT Id, Name FROM sirenum__Placement__c LIMIT 1];

        StagingJobApplication__c stgJA = [SELECT
                                            Name,
                                            stgFrontOfficeIntegrationSystem__c,
                                            stgVmsClientId__c,
                                            stgVmsRoleId__c,
                                            stgVmsShiftId__c,
                                            stgAtsShiftIntegrationRef__c,
                                            stgPayProfile__r.IP_PayrollID__c,
                                            stgAtsCandidateIntegrationRef__r.FirstName,
                                            stgAtsCandidateIntegrationRef__r.LastName,
                                            stgAtsCandidateIntegrationRef__r.Email,
                                            stgAtsCandidateIntegrationRef__r.sirenum__National_Insurance__c,
                                            stgSubmissionDatetime__c,
                                            stgSubmittedJSON__c,
                                            stgSubmissionStatus__c,
                                            StagingJobOrder__r.StgSourceSystem__c
                                          FROM StagingJobApplication__c LIMIT 1];
        stgJA.stgApplicationStatus__c = 'Accepted';
        stgJA.stgSPlacementId__c = sPlacement.Id;
        update stgJA;

        Test.startTest();
        VmsSubmitCandidate.doSubmitApplication(new List<String> {JSON.serializePretty(stgJA)});
        Test.stopTest();

        StagingJobApplication__c postStgJA = [SELECT
                                                Name,
                                                stgFrontOfficeIntegrationSystem__c,
                                                stgVmsClientId__c,
                                                stgVmsRoleId__c,
                                                stgVmsShiftId__c,
                                                stgAtsShiftIntegrationRef__c,
                                                stgPayProfile__r.IP_PayrollID__c,
                                                stgAtsCandidateIntegrationRef__r.FirstName,
                                                stgAtsCandidateIntegrationRef__r.LastName,
                                                stgAtsCandidateIntegrationRef__r.Email,
                                                stgAtsCandidateIntegrationRef__r.sirenum__National_Insurance__c,
                                                stgSubmissionDatetime__c,
                                                stgSubmittedJSON__c,
                                                stgSubmissionStatus__c,
                                                stgSPlacementId__c,
                                                StagingJobOrder__r.StgSourceSystem__c
                                             FROM StagingJobApplication__c LIMIT 1];

        System.assert(String.isBlank(stgJA.stgSubmissionStatus__c), 'Expected to be null or blank');
        System.assertEquals('S-Placement Submitted', postStgJA.stgSubmissionStatus__c, 'Expected to match submission status');
        System.assert(stgJA.stgSubmissionDatetime__c < postStgJA.stgSubmissionDatetime__c, 'Submission date time expected');
    }
    
    @isTest
    static void validateTriggerFunctionality() {
        Test.setMock(HttpCalloutMock.class, new VmsSubmitCandidateCalloutMock());

        StagingJobApplication__c stgJA = getPreSubmitStagingJobApplication();
        
        VMS_API_Integration_Outbound__e thePlatformEvent = new VMS_API_Integration_Outbound__e(
            Staging_Object_Name__c = 'StagingJobApplication__c',
            SF_Record_Id__c = stgJA.Id
        );

        Test.startTest();
        EventBus.publish(thePlatformEvent);
        Test.stopTest();

        StagingJobApplication__c postStgJA = getPostSubmitStagingJobApplication(stgJA.Id);
        System.assert(String.isNotBlank(String.valueOf(postStgJA.stgSubmissionDatetime__c)), 'Submission date time expected');
    }
}