@isTest
public class TaskCompletionTestClass {

    // Helper method to create a French user
    private static User createFrenchUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Mobility Leasing' LIMIT 1];
        User usr = new User(
            FirstName = 'Jean',
            LastName = 'Dupont',
            Alias = 'jfdup',
            Email = 'jean.dupont@example.com',
            Username = 'jean.dupont.' + DateTime.now().getTime() + '@example.com',
            LanguageLocaleKey = 'fr',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            TimeZoneSidKey = 'America/New_York',
            ProfileId = p.Id
        );
        insert usr;
        return usr;
    }

    @isTest
    static void testOpportunityEmail_en_US() {
        User user = [SELECT Id, FirstName, LastName, Email, LanguageLocaleKey FROM User WHERE Id = :UserInfo.getUserId()];

        Account acc = new Account(Name = 'Test Account EN');
        insert acc;

        Opportunity opp = new Opportunity(
            Name = 'Opportunity EN',
            StageName = 'Qualification',
            CloseDate = Date.today().addDays(10),
            AccountId = acc.Id,
            OwnerId = user.Id,
            Installation_Date__c = Date.today()
            //Account_Name_Desc__c = 'EN Account Desc'
        );
        insert opp;

        Task task = new Task(
            Subject = 'EN Subject',
            Status = 'Open',
            WhatId = opp.Id,
            OwnerId = user.Id,
            Description = 'EN Task Description',
            ActivityDate = Date.today().addDays(3)
        );
        insert task;

        Opportunity oppQuery = [SELECT Id, Name, StageName, Account_Name_Desc__c, Installation_Date__c,
                                Owner.Email, Owner.FirstName, Owner.LastName, Owner.LanguageLocaleKey
                                FROM Opportunity WHERE Id = :opp.Id];
        Task taskQuery = [SELECT Id, Subject, Status, Description, ActivityDate FROM Task WHERE Id = :task.Id];

        Test.startTest();
        TaskCompletionSendEmail.sendOpportunityEmail(oppQuery, taskQuery);
        Test.stopTest();
    }

    @isTest
    static void testOpportunityEmail_fr() {
        User frenchUser = createFrenchUser();
        System.runAs(frenchUser) {
            Account acc = new Account(Name = 'Test Account FR');
            insert acc;

            Opportunity opp = new Opportunity(
                Name = 'Opportunity FR',
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(5),
                AccountId = acc.Id,
                OwnerId = frenchUser.Id,
                Installation_Date__c = Date.today()
               // Account_Name_Desc__c = 'FR Account Desc'
            );
            insert opp;

            Task task = new Task(
                Subject = 'FR Subject',
                Status = 'Open',
                WhatId = opp.Id,
                OwnerId = frenchUser.Id,
                Description = 'FR Task Description',
                ActivityDate = Date.today().addDays(2)
            );
            insert task;

            Opportunity oppQuery = [SELECT Id, Name, StageName, Account_Name_Desc__c, Installation_Date__c,
                                    Owner.Email, Owner.FirstName, Owner.LastName, Owner.LanguageLocaleKey
                                    FROM Opportunity WHERE Id = :opp.Id];
            Task taskQuery = [SELECT Id, Subject, Status, Description, ActivityDate FROM Task WHERE Id = :task.Id];

            Test.startTest();
            TaskCompletionSendEmail.sendOpportunityEmail(oppQuery, taskQuery);
            Test.stopTest();
        }
    }

    @isTest
    static void testAccountEmail_en_US() {
        User user = [SELECT Id, FirstName, LastName, Email, LanguageLocaleKey FROM User WHERE Id = :UserInfo.getUserId()];

        Account acc = new Account(Name = 'EN Account');
        insert acc;
        acc.OwnerId = user.Id;
        update acc;

        Task task = new Task(
            Subject = 'EN Account Task',
            Status = 'Open',
            WhatId = acc.Id,
            OwnerId = user.Id,
            Description = 'EN Acc Task Desc',
            ActivityDate = Date.today().addDays(4)
        );
        insert task;

        Account accQuery = [SELECT Id, Name, Owner.Email, Owner.FirstName, Owner.LastName, Owner.LanguageLocaleKey
                            FROM Account WHERE Id = :acc.Id];
        Task taskQuery = [SELECT Id, Subject, Status, Description, ActivityDate FROM Task WHERE Id = :task.Id];

        Test.startTest();
        TaskCompletionSendEmail.sendAccountEmail(accQuery, taskQuery);
        Test.stopTest();
    }

    @isTest
    static void testAccountEmail_fr() {
        User frenchUser = createFrenchUser();
        System.runAs(frenchUser) {
            Account acc = new Account(Name = 'FR Account');
            insert acc;
            acc.OwnerId = frenchUser.Id;
            update acc;

            Task task = new Task(
                Subject = 'FR Account Task',
                Status = 'Open',
                WhatId = acc.Id,
                OwnerId = frenchUser.Id,
                Description = 'FR Acc Task Desc',
                ActivityDate = Date.today().addDays(4)
            );
            insert task;

            Account accQuery = [SELECT Id, Name, Owner.Email, Owner.FirstName, Owner.LastName, Owner.LanguageLocaleKey
                                FROM Account WHERE Id = :acc.Id];
            Task taskQuery = [SELECT Id, Subject, Status, Description, ActivityDate FROM Task WHERE Id = :task.Id];

            Test.startTest();
            TaskCompletionSendEmail.sendAccountEmail(accQuery, taskQuery);
            Test.stopTest();
        }
    }

    @isTest
    static void testTriggerWithOpportunity() {
        User user = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        Account acc = new Account(Name = 'Trigger Account');
        insert acc;

        Opportunity opp = new Opportunity(
            Name = 'Trigger Opportunity',
            StageName = 'Needs Analysis',
            CloseDate = Date.today().addDays(10),
            AccountId = acc.Id,
            OwnerId = user.Id,
            Installation_Date__c = Date.today()
        );
        insert opp;

        Task task = new Task(
            Subject = 'Trigger Task Opp',
            Status = 'Open',
            WhatId = opp.Id,
            OwnerId = user.Id,
            Description = 'Trigger Opp Task',
            ActivityDate = Date.today().addDays(1)
        );
        insert task;

        task.Status = 'Completed';
        Test.startTest();
        update task;
        Test.stopTest();
    }

    @isTest
    static void testTriggerWithAccount() {
        User user = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        Account acc = new Account(Name = 'Trigger Account');
        insert acc;
        acc.OwnerId = user.Id;
        update acc;

        Task task = new Task(
            Subject = 'Trigger Task Acc',
            Status = 'Open',
            WhatId = acc.Id,
            OwnerId = user.Id,
            Description = 'Trigger Acc Task',
            ActivityDate = Date.today().addDays(1)
        );
        insert task;

        task.Status = 'Completed';
        Test.startTest();
        update task;
        Test.stopTest();
    }
}