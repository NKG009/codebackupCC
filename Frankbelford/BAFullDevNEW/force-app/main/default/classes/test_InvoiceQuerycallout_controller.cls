@isTest

public class test_InvoiceQuerycallout_controller {
    
    public static testmethod void invoicegenerate1(){
        
        Account acccon = TestDataFactory.createAccounts(1)[0];
        insert acccon;
        
        Group testGroup = new Group(Name='1062 - BAL Newbury', Type='Queue');
        insert testGroup;
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueueSObject testQueue = new QueueSObject(QueueID = testGroup.id, SobjectType = 'Case');
            insert testQueue;
        }
        List<IP_InvoiceQuery__c> invlist = new List<IP_InvoiceQuery__c>();
        IP_InvoiceQuery__c inv = new IP_InvoiceQuery__c();
        inv.IP_Account__c = acccon.id;
        inv.IP_QueryValue__c = 100;
        inv.IP_AccountNumber__c = '1417261';
        inv.IP_BranchCode__c = '1062';
        inv.IP_InvoiceNumber__c = '62332812';
        invlist.add(inv);
        
        insert invlist;
        
        
        test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.InvoiceQuerycalloutpage')); 
        System.currentPageReference().getParameters().put('id', acccon.id);
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(invlist);               
        InvoiceQuerycallout_controller invcallout = new InvoiceQuerycallout_controller(sc);
        invcallout.redirectToLC();
        test.stopTest();
        
    }
}