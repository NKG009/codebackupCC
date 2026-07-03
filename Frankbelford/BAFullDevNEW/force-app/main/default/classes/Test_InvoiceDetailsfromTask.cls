@isTest
public class Test_InvoiceDetailsfromTask {

    static testMethod void creditcheck1(){
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
        
           Task tsk = new Task();
                    tsk.recordtypeid = recID;
                    tsk.Subject = ' - Invoice Query';
                    tsk.WhatID = inv.id;
                    tsk.IP_TaskType__c = 'Invoice Query';
        insert tsk;
      //  Task tsk = [Select id from Task where Whatid =: inv.id];
      
      IP_InvoiceQuery__c inv1 = new IP_InvoiceQuery__c();
        inv1.IP_Account__c = acc1.id;
        inv1.IP_QueryValue__c = 100;
        inv1.IP_AccountNumber__c = '1417261';
        inv1.IP_BranchCode__c = '1062';
        inv1.IP_InvoiceNumber__c = '62332812';
        inv1.IP_QueryDescription__c = 'gwke';
        insert inv1;
        
           Task tsk1 = new Task();
                    tsk1.recordtypeid = recID;
                    tsk1.Subject = '723298 - Invoice Query';
                    tsk1.WhatID = inv1.id;
                    tsk1.IP_TaskType__c = 'Invoice Query';
        insert tsk1;
        
        Test.StartTest();
        InvoiceDetailsfromTask.Taskdetails(tsk.id);
        InvoiceDetailsfromTask.getTaskrecdetails(tsk.id);
        InvoiceDetailsfromTask.Updaterecordandemail('6374283','tesaqywd',tsk.id);
        InvoiceDetailsfromTask.Updateinvoicewithfile('6374283','tesaqywd',tsk1.id,'wetyw','26378hs','text/plain');
        Test.stopTest();
      }
}