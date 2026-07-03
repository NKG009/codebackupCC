@isTest
public class Test_Invoicequeryupdatecontrller {

    static testMethod void creditcheck1(){
     RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        
        Account acc1 = new Account(Name='Account name 1',RecordTypeId=accountRec1.id);
        insert acc1;
        
       Group testGroup = new Group(Name='1062 - BAL Newbury', Type='Queue');
        insert testGroup;
      /*  System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueueSObject testQueue = new QueueSObject(QueueID = testGroup.id, SobjectType = 'Case');
            insert testQueue;
        }*/
      //  List<IP_InvoiceQuery__c> invlist = new List<IP_InvoiceQuery__c>();
        IP_InvoiceQuery__c inv = new IP_InvoiceQuery__c();
        inv.IP_Account__c = acc1.id;
        inv.IP_QueryValue__c = 100;
        inv.IP_AccountNumber__c = '1417261';
        inv.IP_BranchCode__c = '1062';
        inv.IP_InvoiceNumber__c = '62332812';
        inv.IP_QueryDescription__c = 'test';
        //invlist.add(inv);
        insert inv;
        
       // insert invlist;
        
        
        Test.StartTest();
        Invoicequeryupdatecontrller.getInvoicedetails(inv.id);
        Invoicequeryupdatecontrller.getInvoicerecorddetails(inv.id);
        Invoicequeryupdatecontrller.Updaterecordandsendemail('6374283','tesaqywd',inv.id);
        Test.stopTest();
      }
}