@isTest
public class PlacementSyncHandler_Test {
    @TestSetup
    static void setup() {
        insert new AVTRRT__Config_Settings__c(Name='Default');
    }

    @isTest static void testFullSyncPlacement() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Business_Entity__c = 'Wavelength International';
        insert acc;
        
        Contact con = new Contact(FirstName = 'Client', LastName = 'McClient', Email = 'test@test.com',
                                  RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(Constants.RECORD_TYPE_CONTACT).getRecordTypeId());
        insert con;
        
        Contact candidate = new Contact(FirstName = 'Candidate', LastName = 'McTesterson', Email = 'test2@test.com',
                                        RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(Constants.RECORD_TYPE_CANDIDATE).getRecordTypeId());
        insert candidate;
        
        AVTRRT__Job__c job = new AVTRRT__Job__c();
        job.AVTRRT__Account_Job__c = acc.Id;
        job.AVTRRT__Job_Title__c = 'Test Job';
        job.AVTRRT__Start_Date__c = System.today();
        job.AVTRRT__Hiring_Manager__c = con.Id;
        job.AVTRRT__Stage__c = 'Open';
        insert job;
        
        //Create a placement
        AVTRRT__Placement__c pl = new AVTRRT__Placement__c();
        pl.AVTRRT__Employer__c = acc.Id;
        pl.AVTRRT__Hiring_Manager__c = con.Id;
        pl.AVTRRT__Contact_Candidate__c = candidate.Id;
        pl.AVTRRT__Job__c = job.Id;
        pl.AVTRRT__Contract__c = 'Project';
        pl.AVTRRT__Job_Title__c = 'Test Job';
        pl.AVTRRT__Start_Date__c = System.now().Date();
        pl.AVTRRT__Date_Accepted__c = System.now().Date();
        pl.AVTRRT__End_Date__c = System.now().Date() + 10;
        pl.AVTRRT__Bill_Rate__c = '100';
        pl.Reason__c = 'Test';

        Test.startTest();
        insert pl;
        Test.stopTest();

        //Verify that Isimio records were created
        List<kruvi_staff__Open_Placement__c> iPlacements = [SELECT Id, TR_Placement__c, kruvi_staff__End_Date__c FROM kruvi_staff__Open_Placement__c];
        Assert.areEqual(1, iPlacements.size(), 'The wrong number of Isimio placements were created after creating a TR placement');
        Assert.areEqual(pl.Id, iPlacements[0].TR_Placement__c, 'End date field was not synchronised correctly after an insert');
        Assert.areEqual(pl.AVTRRT__End_Date__c, iPlacements[0].kruvi_staff__End_Date__c, 'End date field was not synchronised correctly after an insert');

        //Change the placement's end date
        pl.AVTRRT__End_Date__c = pl.AVTRRT__End_Date__c.addDays(7);
        update pl;

        //Verify the Isimio placement record was changed as well
        iPlacements = [SELECT Id, kruvi_staff__End_Date__c FROM kruvi_staff__Open_Placement__c];
        Assert.areEqual(pl.AVTRRT__End_Date__c, iPlacements[0].kruvi_staff__End_Date__c, 'End date field was not synchronised correctly after an update');

        //Delete the Isimio placement and update the record to see if it's recreated
        delete iPlacements;
        update pl;
        Assert.areEqual(1, iPlacements.size(), 'The wrong number of Isimio placements were created after creating a TR placement');

        //Delete placement
        delete pl;

        //Verify the Isimio placement was deleted
        iPlacements = [SELECT Id, kruvi_staff__End_Date__c FROM kruvi_staff__Open_Placement__c];
        Assert.areEqual(0, iPlacements.size(), 'Isimio placement record was not deleted when the TR placement was');
    }
}