@isTest
public class InvokeSitePersonaActionTest {
    
   @isTest
    public static void getJobRoleTest(){
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
        List<Account> clientLst = TestDataFactory.createClients(1);
        insert clientLst;
        List<Contact> candidateLst = TestDataFactory.createContact(clientLst[0].Id,1);
        insert candidateLst;
        List<IP_TopazGlobalClientInformation__c> topazClientLst = TestDataFactory.createTopaz(1);
        insert topazClientLst;
        List<sirenum__Site__c> siteLst = TestDataFactory.createSites(clientLst[0].Id,topazClientLst[0].Id,1);
        insert siteLst;
        List<sirenum__Timesheet__c> timesheetLst = TestDataFactory.createTimeSheet(clientLst[0].Id,candidateLst[0].Id,1);
        timesheetLst[0].sirenum__Site__c = siteLst[0].Id;
        insert timesheetLst;
        sirenum__Timesheet__c testTimesheet = [SELECT Id,sirenum__Site__c,sirenum__Site__r.sirenum__Operating_Company__c FROM sirenum__Timesheet__c limit 1];
        System.debug('Id::'+timesheetLst[0].sirenum__Site__c+'??'+testTimesheet.sirenum__Site__c);
        update new sirenum__Site__c(Id=timesheetLst[0].sirenum__Site__c,Estimated_Temp_Requirements__c=10,Estimated_Perm_Vacancies__c=20);
       
        
        InvokeSitePersonaAction.getJobRoles(new List<Id>{testTimesheet.sirenum__Site__c});
        SiteTriggerHelper.populateVacancies(new Set<Id>{clientLst[0].Id});
    }

    @isTest
    public static void getSPlacementRolesTest(){
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
        List<Account> clientLst = TestDataFactory.createClients(1);
        insert clientLst;
        List<Contact> candidateLst = TestDataFactory.createContact(clientLst[0].Id,1);
        insert candidateLst;
         List<sirenum__ProActiveContract__c> contract = TestDataFactory.sirenumProActiveContract(clientLst[0].Id,candidateLst[0].Id,1);
        insert contract;
        List<sirenum__Rota__c> sectorLst = TestDataFactory.createSector(1);
        insert sectorLst;
        List<sirenum__Job_Type__c> jobTypeLst = TestDataFactory.createJobType(sectorLst[0].Id,1);
        insert jobTypeLst;
       /* List<sirenum__Job_Type__c> jobTypeLst = TestDataFactory.createJobType(sectorLst[0].Id,1);
        insert jobTypeLst;*/
        List<sirenum__Team__c> jobRoleLst = TestDataFactory.createJobRole(contract[0].Id,jobTypeLst[0].Id,1);
        insert jobRoleLst;
        //User usrId = [SELECT Id FROM User WHERE Id=:]
        List<sirenum__Placement__c> placementLst = TestDataFactory.createSPlacement(candidateLst[0].Id,contract[0].Id,jobRoleLst[0].Id,UserInfo.getUserId(),1);
        insert placementLst;
         
        InvokeClientPersonaAction.getSplacementRoles(new List<Id>{clientLst[0].Id});
    }
}