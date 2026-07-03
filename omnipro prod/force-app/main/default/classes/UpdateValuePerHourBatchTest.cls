@isTest
private class UpdateValuePerHourBatchTest {
    
    static testMethod void testBatchJob() {
        
        // Create test data
        Account acc = new Account(Name='Test Account',Phone='9876543212',BillingCountry='Ireland',ShippingCountry='Ireland',BillingPostalCode='D01 R3K6');
        insert acc;
        
        List<Timesheet__c> timesheets = new List<Timesheet__c>();
        
        Timesheet__c ts1 = new Timesheet__c();
        ts1.Billing_Account__c = acc.Id;
        ts1.Chargeability__c = 'Billable';
        ts1.Date_Work_Delivered__c = Date.today();
        ts1.Actual_Time_Duration_Hours__c = 5;
        ts1.Value_per_Hour__c = null;
        timesheets.add(ts1);
        
        Timesheet__c ts2 = new Timesheet__c();
        ts2.Billing_Account__c = acc.Id;
        ts2.Chargeability__c = 'Non Billable';
        ts2.Date_Work_Delivered__c = Date.today();
        ts2.Actual_Time_Duration_Hours__c = 10;
        ts2.Value_per_Hour__c = null;
        timesheets.add(ts2);
        
        insert timesheets;
        
        // Execute the batch job
        Test.startTest();
        String query = null;
        UpdateValuePerHourBatch batch = new UpdateValuePerHourBatch(query);
        Database.executeBatch(batch);
        Test.stopTest();
        
         List<Timesheet__c> updatedTimesheets = [SELECT Id, Owner.Name, Value_per_Hour__c FROM Timesheet__c WHERE Id IN :timesheets];
        Map<String, Decimal> hourlyRatesByOwnerName = new Map<String, Decimal>{
            'Sinead Gortland' => 100,
            'Lauren Doyle' => 70,
            'Ciara Ellix' => 60,
            'Sharon Larkin' => 80,
            'Laura Kelly' => 100,
            'Emma Bardon' => 60,
            'Colm Owens' => 200,
            'Lindsay Webber' => 200,
            'Elaine Jackson' => 200,
            'John Murphy' => 250,
            'Lisa Cosgrave' => 150,
            'Sarah Murphy' => 60
        };
        for (Timesheet__c timesheet : updatedTimesheets) {
            System.assertEquals(hourlyRatesByOwnerName.get(timesheet.Owner.Name), timesheet.Value_per_Hour__c);
        }
    }
}