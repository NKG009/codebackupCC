@isTest public class Rater_WL_Test {
    @TestSetup
    static void setup() {
        insert new AVTRRT__Config_Settings__c(Name = 'Default');

        Kruvi_staff.TestDataFactory.installDataConfig();
        kruvi__Schedule_Object__c obj = [SELECT Id, kruvi__Filter__c FROM kruvi__Schedule_Object__c WHERE Name LIKE 'Contact'];
        obj.kruvi__Filter__c = 'id != null';
        update obj;
    }

    @isTest static void testRateShift() {
        //Create candidates
        Contact[] candidates = new Contact[] {
            new Contact(FirstName = 'Test', LastName = 'McTester', MailingLatitude = 1, MailingLongitude = 0, Speciality__c = 'Dentistry', RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(Constants.RECORD_TYPE_CANDIDATE).getRecordTypeId())
        };
        insert candidates;

        Account client = new Account(Name = 'Client', Business_Entity__c = 'Wavelength International');
        insert client;

        Contact approver = new Contact(FirstName = 'Approver', LastName = 'Approvingson', Email='test@test.com',
                                       RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(Constants.RECORD_TYPE_CONTACT).getRecordTypeId());
        insert approver;

        //Create a job
        AVTRRT__Job__c job = new AVTRRT__Job__c(
            AVTRRT__Account_Job__c = client.Id,
            AVTRRT__Job_Title__c = 'Test Job',
            AVTRRT__Start_Date__c = System.today(),
            AVTRRT__Hiring_Manager__c = approver.Id,
            AVTRRT__Stage__c = 'Open',
            Specialty_NEW__c = 'Dentistry',
            Category__c = 'Doctor',
            Seniority_NEW__c = 'Clinical Director'
        );
        insert job;

        Skill_Set__c attr = new Skill_Set__c(
            Job__c = job.Id,
            Category__c = 'Doctor',
            Specialty__c = 'Dentistry',
            Seniority__c = 'Clinical Director'
        );
        insert attr;

        update job;
        update candidates;

        //Get Isimio contract
        kruvi_staff__Contract__c contr = [SELECT Id FROM kruvi_staff__Contract__c WHERE TR_Job__c = :job.Id];

        //Add a shift to the list of shifts to rate
        List<Map<String, Object>> shifts = new List<Map<String, Object>>();
        DateTime dt = System.now();

        kruvi_staff__Shift__c shift = new kruvi_staff__Shift__c(
            kruvi_staff__Candidate__c = candidates[0].Id, 
            kruvi_staff__iContract__c = contr.Id,
            kruvi_staff__Planned_Start_Time__c = dt, 
            kruvi_staff__Planned_End_Time__c = dt.addHours(5)
        );
        insert shift;

        shifts.add(new Map<String, Object> {
            'id' => shift.Id,
            'kruvi_staff__candidate__c' => candidates[0].Id,
            'kruvi_staff__planned_start_time__c' => dt.formatGMT('yyyy-MM-dd\' \'HH:mm'),
            'kruvi_staff__icontract__c' => contr.id
        });

        //Execute rater
        Test.startTest();
        List<Kruvi.Rater.Result> results = (new Rater_WL()).rate('kruvi_staff__shift__c', shifts);
        Test.stopTest();

        //Check results
        Assert.areEqual(1, results.size());
        Assert.areEqual(3, results[0].factors.keySet().size());
        Assert.areEqual(candidates[0].Id, results[0].matchId);
    }
}