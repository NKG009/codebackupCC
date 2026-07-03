/**
 * Copyright Sirenum Ltd 2022
 */

@IsTest
private class WorkerRatings_Test {
    @TestSetup
    static void makeData(){
        Account account = new Account(
            Name='Test Account',
            IP_Business_Type__c = 'Driving'
        );
        insert account;

        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c(
                Name='Test Contract',
                sirenum__Client__c = account.Id
        );
        insert contract;

        sirenum__Shift__c shift1 = new sirenum__Shift__c(
            sirenum__Scheduled_Start_Time__c = Datetime.now().addHours(1),
            sirenum__Scheduled_End_Time__c = Datetime.now().addHours(3),
            sirenum__Contract__c = contract.Id
        );
        sirenum__Shift__c shift2 = new sirenum__Shift__c(
            sirenum__Scheduled_Start_Time__c = Datetime.now().addHours(4),
            sirenum__Scheduled_End_Time__c = Datetime.now().addHours(6),
                sirenum__Contract__c = contract.Id
        );
        sirenum__Shift__c shift3 = new sirenum__Shift__c(
            sirenum__Scheduled_Start_Time__c = Datetime.now().addHours(24),
            sirenum__Scheduled_End_Time__c = Datetime.now().addHours(26),
                sirenum__Contract__c = contract.Id
        );
        insert new List<sirenum__Shift__c>{shift1, shift2, shift3};
    }

/*
Note: the flow which creates ratings must be deactivated for this to work.
*/
    @IsTest
    static void testPositive(){
        Worker_Rating__c rating1 = new Worker_Rating__c(
            Shift__c = [SELECT Id FROM sirenum__Shift__c LIMIT 3][0].Id,
            Account__c = [SELECT Id FROM Account LIMIT 1][0].Id
        );
        Worker_Rating__c rating2 = new Worker_Rating__c(
            Shift__c = [SELECT Id FROM sirenum__Shift__c LIMIT 3][1].Id,
            Account__c = [SELECT Id FROM Account LIMIT 1][0].Id
        );
        Worker_Rating__c rating3 = new Worker_Rating__c(
            Shift__c = [SELECT Id FROM sirenum__Shift__c LIMIT 3][2].Id,
            Account__c = [SELECT Id FROM Account LIMIT 1][0].Id
        );
        insert new List<Worker_Rating__c>{rating1, rating2, rating3};
        system.debug(rating1);
        system.debug(rating2);
        system.debug(rating3);

        //Set scores on shifts
        List<sirenum__Shift__c> shifts = [
            SELECT Id, Worker_Rating__c
            FROM sirenum__Shift__c
            ORDER BY sirenum__Scheduled_Start_Time__c ASC
            LIMIT 3
        ];
        shifts[0].Worker_Rating__c = '1';
        shifts[1].Worker_Rating__c = '2';
        shifts[2].Worker_Rating__c = '3';

        Update shifts;

        //Edge test - should be counted
        Test.setCreatedDate(rating2.Id, Datetime.now().addDays(-30));
        
        //Edge test - should not be counted
        Test.setCreatedDate(rating3.Id, Datetime.now().addDays(-31));
        system.debug(rating2.CreatedDate);
        system.debug(rating3.CreatedDate);

        //TEMPORARY
        List<Worker_Rating__c> ratings = [
                SELECT Id, Rating__c, CreatedDate
                FROM Worker_Rating__c
        ];

        for (Worker_Rating__c rating : ratings){
            system.debug('Rating: ' + rating.Rating__c + ' Created: ' + rating.CreatedDate);
        }
        
        WorkerRatingsScheduler scheduler = new WorkerRatingsScheduler();
        Test.startTest();
        scheduler.execute();
        Test.stopTest();

        //This passing means average was calculated correctly for the 2x ratings...
        //... within the lookback period
        System.assertEquals(
            1.5, 
            [SELECT Average_Worker_Rating__c FROM Account LIMIT 1][0].Average_Worker_Rating__c
        );
    }

    @IsTest
    static void testNull(){
        WorkerRatingsScheduler scheduler = new WorkerRatingsScheduler();
        Test.startTest();
        scheduler.execute();
        Test.stopTest();

        System.assertEquals(
            null, 
            [SELECT Average_Worker_Rating__c FROM Account LIMIT 1][0].Average_Worker_Rating__c
        );
    }

    @IsTest
    static void testBackToNull(){
        Account account = [SELECT Id, Average_Worker_Rating__c FROM Account LIMIT 1];
        account.Average_Worker_Rating__c = 1.5;
        update account;
        
        WorkerRatingsScheduler scheduler = new WorkerRatingsScheduler();
        Test.startTest();
        scheduler.execute();
        Test.stopTest();

        System.assertEquals(
            null, 
            [SELECT Average_Worker_Rating__c FROM Account LIMIT 1][0].Average_Worker_Rating__c
        );
    }
}