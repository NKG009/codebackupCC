@isTest
public class Test_InvoiceQueryCalloutBatch{
    @isTest static  void testGetCallout1() {

        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account'];

        Account acc1 = new Account(Name='Account name 1',RecordTypeId=accountRec1.id);
        insert acc1;
        Account candiAcc = TestDataFactory.createCandidateAccount(1)[0];
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candiAcc.Id);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact c = new Contact();
        c.AccountID = acc1.id;
        c.FirstName = 'abc';
        c.LastName = 'xyz';
        insert c;

        /*Group testGroup = new Group(Name='1062 - BAL Newbury', Type='Queue');
        insert testGroup;
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
        QueueSObject testQueue = new QueueSObject(QueueID = testGroup.id, SobjectType = 'Task');
        insert testQueue;
        }
        */
        IP_BranchStatus__c b  = new IP_BranchStatus__c ();
        b.IP_BranchID__c = '1062';
        b.Name = 'Test';
        insert b;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new InvoicequerymockGenerator());

        InvoiceQueryCalloutBatch ib = new InvoiceQueryCalloutBatch();
        database.executebatch(ib);
        Test.stopTest();
    }
    @isTest static  void testGetCallout2() {

        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account'];

        Account acc1 = new Account(Name='Account name 1',RecordTypeId=accountRec1.id);
        insert acc1;
        Account candiAcc = TestDataFactory.createCandidateAccount(1)[0];
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candiAcc.Id);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact c = new Contact();
        c.AccountID = acc1.id;
        c.FirstName = 'abc1';
        c.LastName = 'xyz1';
        insert c;

        /*  Group testGroup = new Group(Name='1062 - BAL Newbury', Type='Queue');
        insert testGroup;
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
        QueueSObject testQueue = new QueueSObject(QueueID = testGroup.id, SobjectType = 'Task');
        insert testQueue;
        }*/

        IP_BranchStatus__c b  = new IP_BranchStatus__c ();
        b.IP_BranchID__c = '1062';
        b.Name = 'Test';
        insert b;

        IP_InvoiceQuery__c inv = new IP_InvoiceQuery__c();
        inv.IP_Account__c = acc1.id;
        inv.IP_QueryValue__c = 100;
        inv.IP_AccountNumber__c = '1417261';
        inv.IP_BranchCode__c = '1062';
        inv.IP_InvoiceNumber__c = '62332812';
        inv.IP_QueryDescription__c = 'agjw';
        insert inv;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new InvoicequerymockGenerator());

        InvoiceQueryCalloutBatch ib = new InvoiceQueryCalloutBatch();
        database.executebatch(ib,1);
        Test.stopTest();
    }
    @isTest static  void testGetCallout5() {

        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account'];

        Account acc1 = new Account(Name='Account name 1',RecordTypeId=accountRec1.id);
        insert acc1;
        Account candiAcc = TestDataFactory.createCandidateAccount(1)[0];
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candiAcc.Id);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact c = new Contact();
        c.AccountID = acc1.id;
        c.FirstName = 'abc';
        c.LastName = 'xyz';
        insert c;

        /*  Group testGroup = new Group(Name='1062 - BAL Newbury', Type='Queue');
        insert testGroup;
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
        QueueSObject testQueue = new QueueSObject(QueueID = testGroup.id, SobjectType = 'Task');
        insert testQueue;
        }
        */
        IP_BranchStatus__c b  = new IP_BranchStatus__c ();
        b.IP_BranchID__c = '1062';
        b.Name = 'Test';
        insert b;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new InvoicequerymockGenerator());
        ScheduleInvoiceQueryCalloutBatch sh1 = new ScheduleInvoiceQueryCalloutBatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test capita', sch, sh1);
        Test.stopTest();
    }
}