@isTest
public class EmailSiteMainContactsCtrlTest {
    
    @testSetup
    static void setup(){
        List<Account> accList = TestDataFactory.createClients(2);
        List<IP_TopazGlobalClientInformation__c> topazClientLst = TestDataFactory.createTopaz(2);
        List<sirenum__Site__c> siteLst = TestDataFactory.createSites(accList[0].Id,topazClientLst[0].Id,2);
        
 }
    @isTest
    static void testController(){
        //Create a list view for testing purpose
        ListView siteListView = [SELECT Id,DeveloperName FROM ListView WHERE SObjectType='sirenum__Site__c' LIMIT 1];
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController([SELECT Id FROM sirenum__Site__c]);
        ApexPages.currentPage().getParameters().put('filterId',siteListView.Id);
        EmailSiteMainContactsCtrl objIns = new EmailSiteMainContactsCtrl(sc);
    }

}