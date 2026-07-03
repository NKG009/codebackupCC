@IsTest
public class PortalV2MyJobOrdersControllerTest {
    
    @TestSetup
    static void setupTestData() {
        // Setup User Role
        UserRole role = new UserRole(Name = 'Test Role');
        insert role;
        
        // Setup Portal User (declared here, inserted inside runAs)
        User portalOwner = new User(
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'tuser',
            Email = 'testuser@example.com',
            Username = 'testuser' + DateTime.now().getTime() + '@example.com',
            ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            UserRoleId = role.Id
        );
        insert portalOwner;
        
        // Insert all data that uses this user as owner inside runAs
        System.runAs(portalOwner) {
            Test.startTest();
            
            
            Account client = TestDataFactory.createAccounts(1)[0];
            client.OwnerId = portalOwner.Id;
            insert client;
            
            Account supplier = TestDataFactory.create2ndTierSupplierAccount(1)[0];
            supplier.OwnerId = portalOwner.Id;
            insert supplier;
            
            Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
            
            insert new List<Account>{ candidateAcc };
                
                TestDataFactory.setupCustomSettings(candidateAcc.Id);
            TestDataFactory.setupUserProfileCustomSettings();
            
            
            Contact clientContact = TestDataFactory.createContact(client.Id, 1)[0];
            clientContact.LastName = 'Client';
            insert clientContact;
            
            Contact supplierContact = TestDataFactory.createContact(supplier.Id, 1)[0];
            supplierContact.LastName = 'supplier';
            supplierContact.VMS_Contact__c=true;
            insert supplierContact;
            
            Contact worker = TestDataFactory.createCandidate2ndTier(supplier.Id, 1)[0];
            worker.lastname='worker';
            worker.smagicinteract__SMSOptOut__c=true;
            worker.HasOptedOutOfEmail=true;
            insert worker;
            
            
            sirenum__ProActiveContract__c contract = TestDataFactory.sirenumProActiveContract(client.Id, clientContact.Id, 1)[0];
            insert contract;
            
            sirenum__Rota__c jobSector = TestDataFactory.createSector(1)[0];
            insert jobSector;
            
            sirenum__Job_Type__c jobType = TestDataFactory.createJobType(jobSector.Id, 1)[0];
            insert jobType;
            
            IP_TopazGlobalClientInformation__c topazClientInfo = TestDataFactory.createTopaz(1)[0];
            insert topazClientInfo;
            
            sirenum__Site__c site = TestDataFactory.createSites(client.Id, topazClientInfo.Id, 1)[0];
            insert site;
            
            sirenum__Job_Type__c jobCatagory = TestDataFactory.createJobType(jobSector.Id, 1)[0];
            insert jobCatagory;
            
            sirenum__Team__c jobRole = TestDataFactory.createJobRole(contract.Id, jobCatagory.Id, 1)[0];
            insert jobRole;
            
            sirenum__WorkSchedule__c workSchedule = TestDataFactory.createWorkSchedules(client.Id, 1)[0];
            insert workSchedule;
            
            sirenum__JobOrder__c jobOrder = TestDataFactory.createJobOrders(client.Id, contract.Id, jobType.Id, site.Id, jobRole.Id, workSchedule.Id, 1)[0];
            insert jobOrder;
            
            sirenum__TicketType__c ticketType = new sirenum__TicketType__c(
                Name = 'Background Check',
                sirenum__Requires_Proof__c = true,
                sirenum__Expires__c = false
            );
            insert ticketType;
            
            // Create matching Condition Membership
            sirenum__Sirenum_Condition_Membership__c condition = new sirenum__Sirenum_Condition_Membership__c(
                sirenum__Team__c = jobRole.Id,
                sirenum__Site__c = site.Id,
                sirenum__Job_Type__c = jobType.Id,
                sirenum__Severity__c = 'High',
                sirenum__TicketType__c = ticketType.Id
            );
            insert condition;
            
            
            ContentVersion cv = new ContentVersion(
                Title = 'Test File',
                PathOnClient = 'TestFile.pdf',
                VersionData = Blob.valueOf('Test file content')
            );
            insert cv;
            
            // Retrieve the ContentDocumentId
            ContentVersion insertedCV = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
            ContentDocumentLink link = new ContentDocumentLink(
                ContentDocumentId = insertedCV.ContentDocumentId,
                LinkedEntityId = jobOrder.Id,
                ShareType = 'V',
                Visibility = 'InternalUsers'
            );
            insert link;
            
            
            
            Suppliers__c  ssc =  new Suppliers__c(Account__c =client.id,Supplier__c =supplier.id );
            insert ssc;
            
            Site_Supplier_Link__c ssl = new Site_Supplier_Link__c(Site__c =site.id,Suppliers__c=ssc.id,Active__c=true,Instant_Vend_Date_Time__c=system.now());
            insert ssl;
            
            
            Profile clientPortalUserProfile = [SELECT Id FROM Profile WHERE Name = 'Client Portal User'];
            User clientPortalUser = new User(
                LastName = 'Test',
                FirstName = 'Client',
                Alias = 'tuser',
                Email = 'Test.Client@testuser.com',
                Username = 'Test.Client@testuser.com',
                ProfileId = clientPortalUserProfile.Id,
                TimeZoneSidKey = 'GMT',
                LanguageLocaleKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LocaleSidKey = 'en_US',
                IP_TempestDepartment__c = '1107',
                IP_TempestDivision__c = 'NTS',
                Brand__c = 'Blue Arrow',
                Department = '1107',
                ContactId = supplierContact.Id
            );
            insert clientPortalUser;
            //  System.Label.Tier_2_Candidate_Owner_Id = portalOwner.Id;
            Test.stopTest();
        }
    }
    
    @isTest
    static void fetchAdjustableColumnsTest() {
        Test.startTest();
        List<Portal_V2_JobOrder_Adjust_Columns__mdt> theCustomMetadata = PortalV2MyJobOrdersController.fetchAdjustableColumns();
        Test.stopTest();
        
        System.assert(
            theCustomMetadata.size() > 0,
            'Portal V2 Job Order - No custom metadata configurations found.'
        );
    }
    
    @isTest
    static void getAlljoborderRecordsTest() {
        User runningUser = [SELECT Id, ContactId FROM User WHERE Email='Test.Client@testuser.com' LIMIT 1];
        System.runAs(runningUser) {
            list<sirenum__JobOrder__c> AllfilteredJoborders = PortalV2MyJobOrdersController.getAllJobOrders();
            PortalV2MyJobOrdersController.getVmsContactInfo();
        }
    }
    
    @isTest
    static void testGetFilesRelatedToJobOrder() {
        sirenum__JobOrder__c jobOrder = [SELECT Id FROM sirenum__JobOrder__c LIMIT 1];
        
        Test.startTest();
        List<ContentDocument> files = PortalV2MyJobOrdersController.getFilesRelatedToJobOrder(jobOrder.Id);
        Test.stopTest();
        
        
    }
    
    @isTest
    static void testGetCommunityBaseUrl() {
        // Create mock Domain and Network
        
        
        Test.startTest();
        String url = PortalV2MyJobOrdersController.getCommunityBaseUrl();
        Test.stopTest();
        
    }
    
    @isTest
    static void testGetJobOrderCompConditions() {
        sirenum__JobOrder__c jobOrder = [SELECT Id FROM sirenum__JobOrder__c LIMIT 1];
        Test.startTest();
        List<sirenum__Sirenum_Condition_Membership__c> results = PortalV2MyJobOrdersController.getJobOrderCompConditions(jobOrder.Id);
        Test.stopTest();
        
    }
    
    @isTest
    static void testGetJobOrderWorkSchedule() {
        // Create related Work Schedule and WorkScheduleDay
        sirenum__JobOrder__c jobOrder = [SELECT Id,sirenum__WorkSchedule__c FROM sirenum__JobOrder__c LIMIT 1];
        Test.startTest();
        PortalV2MyJobOrdersController.getJobOrderWorkschedule(jobOrder.sirenum__WorkSchedule__c);
        Test.stopTest();
        
        //System.assertEquals(1, result.size());
    }
    
    @isTest
    static void testGetJobOrderCandidates() {
        User runningUser = [SELECT Id, ContactId FROM User WHERE Email='Test.Client@testuser.com' LIMIT 1];
        sirenum__JobOrder__c jobOrder = [SELECT Id FROM sirenum__JobOrder__c LIMIT 1];
        System.runAs(runningUser) {
            contact con = [select id from contact where lastname='worker' limit 1];
            
            Candidate__c candidate = new Candidate__c(
                Contact__c = con.Id,
                Job_Order__c = jobOrder.id, 
                Submitted_By__c = runningUser.Id,
                Status__c = 'Submitted'
            );
            insert candidate;
            
            Test.startTest();
            List<Candidate__c> result = PortalV2MyJobOrdersController.getJobOrderCandidates(jobOrder.Id);
            Test.stopTest();
            
            //System.assertEquals(1, result.size());
        }
    }
    
    @isTest
    static void testGetAllCandidatesUnderAccount() {
        User testUser = [SELECT Id, ContactId,Contact.AccountId FROM User WHERE Email='Test.Client@testuser.com' LIMIT 1];
        System.runAs(testUser) {
            
            Test.startTest();
            List<Contact> results = PortalV2MyJobOrdersController.getallcandidatesunderaccount();
            Test.stopTest();
            
            //System.assertEquals(1, results.size());
        }
    }
    
    @isTest
    static void testGenerateCompliancePDF() {
        User testUser = [SELECT Id, ContactId,Contact.AccountId FROM User WHERE Email='Test.Client@testuser.com' LIMIT 1];
        System.runAs(testUser) {
            contact con = [select id from contact where lastname='worker' limit 1];
            Test.setCurrentPage(Page.CompliancePDF);
            
            Test.startTest();
            PortalV2MyJobOrdersController.generateCompliancePDF(con.Id);
            Test.stopTest();
            
            //[{"Id":"a3Y0Y000000TWiZUAW","sirenum__Severity__c":"High","sirenum__TicketType__c":"a3k0Y000000GucDQAS","sirenum__TicketType__r":{"Name":"Chef De Partie","sirenum__Requires_Proof__c":false,"sirenum__Expires__c":false,"Id":"a3k0Y000000GucDQAS"},"skill":"Chef De Partie","severity":"High","selectedValue":"Yes","showFileUpload":false,"showValidtill":false,"isContainsFile":false},{"Id":"a3YQz000000OMYrMAO","sirenum__Severity__c":"Medium","sirenum__TicketType__c":"a3k0Y000000ICMJQA4","sirenum__TicketType__r":{"Name":"Chef Manager","sirenum__Requires_Proof__c":false,"sirenum__Expires__c":false,"Id":"a3k0Y000000ICMJQA4"},"skill":"Chef Manager","severity":"Medium","selectedValue":"Yes","showFileUpload":false,"showValidtill":false,"isContainsFile":false},{"Id":"a3YQz000000OMU1MAO","sirenum__Severity__c":"Medium","sirenum__TicketType__c":"a3k0Y0000002mBuQAI","sirenum__TicketType__r":{"Name":"Supervisor","sirenum__Requires_Proof__c":false,"sirenum__Expires__c":false,"Id":"a3k0Y0000002mBuQAI"},"skill":"Supervisor","severity":"Medium","selectedValue":"Yes","showFileUpload":false,"showValidtill":false,"isContainsFile":false},{"Id":"a3YQz000000OMXFMA4","sirenum__Severity__c":"High","sirenum__TicketType__c":"a3k0Y000000Gud1QAC","sirenum__TicketType__r":{"Name":"Warehouse Operative","sirenum__Requires_Proof__c":false,"sirenum__Expires__c":false,"Id":"a3k0Y000000Gud1QAC"},"skill":"Warehouse Operative","severity":"High","selectedValue":"Yes","showFileUpload":false,"showValidtill":false,"isContainsFile":false}]     
        }
    }
    
    @isTest
    static void testcreateCompetencyRecords(){
        
        sirenum__JobOrder__c jobOrder = [SELECT Id FROM sirenum__JobOrder__c LIMIT 1];
        contact contact = [select id from contact where lastname='worker' limit 1];
        sirenum__TicketType__c ttype = [select Id from sirenum__TicketType__c limit 1];
        ContentVersion cv = new ContentVersion(
            Title = 'Test File',
            PathOnClient = 'TestFile.pdf',
            VersionData = Blob.valueOf('Test file content')
        );
        insert cv;
        
        // Retrieve the ContentDocumentId
        ContentVersion insertedCV = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        system.debug('insertedCV:'+insertedCV.ContentDocumentId);
        List<Map<String, Object>> competencyConditions = new List<Map<String, Object>>();
        
        // Mock 4 ticket conditions
        List<Map<String, Object>> mockConditions = new List<Map<String, Object>>{
            new Map<String, Object>{
                'sirenum__TicketType__c' => ttype.id,
                    'selectedValue' => 'Yes',
                    'showFileUpload' => false,
                    'showValidtill' => false,
                    'isContainsFile' => false
                    },
                        new Map<String, Object>{
                            'sirenum__TicketType__c' => ttype.id,
                                'selectedValue' => 'Yes',
                                'showFileUpload' => true,
                                'showValidtill' => true,
                                'isContainsFile' => true,
                                'validDateValue'   =>'2025-03-31T08:34:03.000Z',
                                'fileId' => insertedCV.ContentDocumentId
                                }
        };
            competencyConditions.addAll(mockConditions);
        Test.startTest();
        PortalV2MyJobOrdersController.createCompetencyRecords(contact.Id,jobOrder.id,competencyConditions,'Both');
        Test.stopTest();
        
        
    }
    
    @isTest
    static void testSendJobOrderDeclineEmail() {
        User testUser = [SELECT Id, ContactId,Contact.AccountId FROM User WHERE Email='Test.Client@testuser.com' LIMIT 1];
        sirenum__JobOrder__c jobOrder = [SELECT Id FROM sirenum__JobOrder__c LIMIT 1];
        System.runAs(testUser) {
            
            
            Test.startTest();
            PortalV2MyJobOrdersController.sendJobOrderDeclineEmail(jobOrder.Id);
            Test.stopTest();
        }
    }
    
    @isTest
    static void testDeleteCreatedCandidate() {
        
        contact contactToDelete = [select id from contact where lastname='worker' limit 1];
        Test.startTest();
        PortalV2MyJobOrdersController.deletecreatedcandidate(contactToDelete.Id);
        Test.stopTest();
        
        
    }
    @isTest
    static void testGetJobOrderComments() {
        
        sirenum__JobOrder__c jobOrder = [SELECT Id FROM sirenum__JobOrder__c LIMIT 1];

        // Create related Job Order Comments
        List<Job_Order_Comments__c> commentsToInsert = new List<Job_Order_Comments__c>();
        commentsToInsert.add(new Job_Order_Comments__c(
            Comment_Text__c = 'First Comment',
            Comment_Type__c = 'Internal',
            Job_Order__c = jobOrder.Id
        ));
        commentsToInsert.add(new Job_Order_Comments__c(
            Comment_Text__c = 'Second Comment',
            Comment_Type__c = 'Internal',
            Job_Order__c = jobOrder.Id
        ));
        insert commentsToInsert;

        Test.startTest();
        List<Job_Order_Comments__c> returnedComments = PortalV2MyJobOrdersController.getJobOrderComments(jobOrder.Id);
        Test.stopTest();

    }
    
}