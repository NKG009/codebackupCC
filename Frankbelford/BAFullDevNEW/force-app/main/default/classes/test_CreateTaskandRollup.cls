@isTest

public class test_CreateTaskandRollup {

    @IsTest
    public static void createinvoice1() {
        Account acccon = TestDataFactory.createAccounts(1)[0];
        insert acccon;
     /*   Group testGroup = new Group(Name='1062 - BAL Newbury', Type='Queue');
        insert testGroup;
        System.runAs(new User(Id=UserInfo.getUserId()))
       {
            QueueSObject testQueue = new QueueSObject(QueueID = testGroup.id, SobjectType = 'Case');
            insert testQueue;
      }*/
        IP_InvoiceQuery__c inv = new IP_InvoiceQuery__c();
        inv.IP_Account__c = acccon.id;
        inv.IP_QueryValue__c = 100;
        inv.IP_AccountNumber__c = '1417261';
        inv.IP_BranchCode__c = '1062';
        inv.IP_InvoiceNumber__c = '62332812';
        inv.IP_QueryDescription__c = 'abcgsd';
        insert inv;
    }
     @IsTest
    public static void createinvoice2() {
        Account acccon = TestDataFactory.createAccounts(1)[0];
        insert acccon;
     /*   Group testGroup1 = new Group(Name='1181 - BAL Aberdeen', Type='Queue');
        insert testGroup1;
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueueSObject testQueue1 = new QueueSObject(QueueID = testGroup1.id, SobjectType = 'Task');
            insert testQueue1;
        }*/
        IP_InvoiceQuery__c inv = new IP_InvoiceQuery__c();
        inv.IP_Account__c = acccon.id;
        inv.IP_QueryValue__c = 100;
        inv.IP_AccountNumber__c = '1417261';
         inv.IP_BranchCode__c = '1062';
        inv.IP_InvoiceNumber__c = '62332812';
        inv.IP_QueryDescription__c = 'abcgsd';
        insert inv;
      id recID = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Invoice Query').getRecordTypeId();     
      
     //   Task t = [Select id from task where Whatid =: inv.id];
      
       Task tsk = new Task();
                    tsk.recordtypeid = recID;
                    tsk.Subject = ' - Invoice Query';
                    tsk.WhatID = inv.id;
                    tsk.IP_TaskType__c = 'Invoice Query';
        insert tsk;
        delete tsk;
        
        inv.IP_AccountNumber__c = 'ashga';
        update inv;
        
    }
}