@isTest
public class JobContractSyncHandler_Test {
    @TestSetup
    static void setup() {
        insert new AVTRRT__Config_Settings__c(Name = 'Default');
    }
    
    @isTest
    static void testSyncJobContract() {
        //Create client
        Account client = new Account(Name = 'Client', Business_Entity__c = 'Wavelength International');
        insert client;

        Contact approver = new Contact(FirstName = 'Approver', LastName = 'Approvingson', Email='test@test.com',
                                       RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(Constants.RECORD_TYPE_CONTACT).getRecordTypeId());
        insert approver;

        //Create a job
        AVTRRT__Job__c job = new AVTRRT__Job__c();
        job.AVTRRT__Account_Job__c = client.Id;
        job.AVTRRT__Job_Title__c = 'Test Job';
        job.AVTRRT__Start_Date__c = System.today();
        job.AVTRRT__Hiring_Manager__c = approver.Id;
        job.AVTRRT__Stage__c = 'Open';

        //Execute sync trigger
        Test.startTest();
        insert job;
        Test.stopTest();

        //Verify that an Isimio contract was created
        List<kruvi_staff__Contract__c> contracts = [SELECT Id, Name, kruvi_staff__Account__c, kruvi_staff__Approver__c, kruvi_staff__Client_Contact__c, TR_Job__c
                                                    FROM kruvi_staff__Contract__c];

        Assert.areEqual(1, contracts.size(), 'Contract not created when job was created');
        Assert.areEqual(client.Id, contracts[0].kruvi_staff__Account__c);
        Assert.areEqual(approver.Id, contracts[0].kruvi_staff__Client_Contact__c);
        Assert.areEqual(job.AVTRRT__Job_Title__c, contracts[0].Name);

        //Verify the contract was set on the job
        job = [SELECT Id, Isimio_Contract__c FROM AVTRRT__Job__c WHERE Id =: job.Id];
        Assert.areEqual(contracts[0].Id, job.Isimio_Contract__c);
    }
}