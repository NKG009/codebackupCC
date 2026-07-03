/**
 * Created by mrahman on 2020-09-09.
 */

@IsTest
private class JobOrderListControllerTest {
    @IsTest
    static void getJobOrderList() {
        System.debug('Staring Test....');
        Account client = TestDataFactory.createAccounts(1)[0];
        Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
        insert new List<Account>{client, candidateAcc};

        TestDataFactory.setupCustomSettings(candidateAcc.Id);
        TestDataFactory.setupUserProfileCustomSettings();

        Contact clientContact = TestDataFactory.createContact(client.Id,1)[0];
        Contact worker = TestDataFactory.createCandidate(candidateAcc.Id, 1)[0];
        insert new List<Contact>{clientContact, worker};

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

        String profileId = User_Profile_Id__c.getValues(Label.Client_Portal_User_Profile).Profile_Id__c;

        Test.startTest();
        User clientUser = TestDataFactory.createUsers(profileId, 1)[0];
        clientUser.Email = clientUser.Email;
        clientUser.FirstName = clientUser.FirstName;
        clientUser.LastName = clientUser.LastName;
        clientUser.ContactId = clientContact.Id;
        clientUser.IP_TempestDepartment__c = '1062';
        clientUser.IP_TempestDivision__c = 'SYS';
        clientUser.IP_TempestId__c='1287awfdqg';
        TestDataFactory.insertUser(new List<String>{JSON.serialize(clientUser)});
        //insert clientUser;
        //String userId = CreatePortalUserController.insertPortalUser(clientUser, profileId);
        Test.stopTest();
        User u = [SELECT Id, FirstName, LastName, Username, ContactId FROM User WHERE ContactId =: clientContact.Id];
        List<sirenum__JobOrder__c> jobOrderList;

        System.runAs(u){
            jobOrderList = JobOrderListController.getJobOrders(u.Id, jobOrder.sirenum__Status__c);
        }
        System.assert(jobOrderList.size()>0, 'At least a job order should have been created');
    }
}