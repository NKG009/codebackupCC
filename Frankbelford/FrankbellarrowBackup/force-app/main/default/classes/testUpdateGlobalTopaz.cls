@istest
public class testUpdateGlobalTopaz
{
    public static testmethod void test1()
    {
    
        IP_TopazGlobalClientInformation__c topaz = new IP_TopazGlobalClientInformation__c();
        topaz.Name='Test Topaz';
        topaz.IP_SalesLedgerNumber__c='12345';
        insert topaz;
        
        
        sirenum__Site__c site = new sirenum__Site__c();
        site.name='Test Site';
        site.IP_ClientIDLegacy__c = 'XX1234Z';
       site.IP_SLNUpdateValue__c='12345';
        
        test.startTest();
        insert site;
        List<Id> siteId = new List<Id>();
        siteId.add(site.id);
        UpdateGlobalTopaz.getTopazId(siteId);
        test.stopTest();
        

    }

}