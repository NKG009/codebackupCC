@isTest
public class Test_InvoiceDetailsfromdetailsbutton {

    static testMethod void details12(){
     RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
    id recID = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Invoice Query').getRecordTypeId();     
        Account acc1 = new Account(Name='Account name 1',RecordTypeId=accountRec1.id);
        insert acc1;
        
   /*    Group testGroup = new Group(Name='1062 - BAL Newbury', Type='Queue');
        insert testGroup;
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueueSObject testQueue = new QueueSObject(QueueID = testGroup.id, SobjectType = 'Task');
            insert testQueue;
        } */
        
        IP_InvoiceQuery__c inv = new IP_InvoiceQuery__c();
        inv.IP_Account__c = acc1.id;
        inv.IP_QueryValue__c = 100;
        inv.IP_AccountNumber__c = '1417261';
        inv.IP_BranchCode__c = '1062';
        inv.IP_InvoiceNumber__c = '62332812';
        inv.IP_QueryDescription__c = 'gwke';
        insert inv;
        
         IP_InvoiceQuery__c inv1 = new IP_InvoiceQuery__c();
        inv1.IP_Account__c = acc1.id;
        inv1.IP_QueryValue__c = 100;
        inv1.IP_AccountNumber__c = '1417261';
        inv1.IP_BranchCode__c = '1062';
        inv1.IP_InvoiceNumber__c = '263273';
        inv1.IP_QueryDescription__c = 'gwke';
        insert inv1;
        
        
        Test.StartTest();
        InvoiceDetailsfromdetailsbutton.querydetails(inv.id);
        InvoiceDetailsfromdetailsbutton.getinvoicerecdetails(inv.id);
        InvoiceDetailsfromdetailsbutton.Updateinvoicerecordandemail('6374283','tesaqywd',inv.id);
        InvoiceDetailsfromdetailsbutton.Updateinvoicewithfile('6374283','tesaqywd',inv1.id,'abc','26323','text/plain');
        Test.stopTest();
      }
}