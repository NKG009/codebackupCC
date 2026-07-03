@isTest
private class CompanyUpsertSchedulerTest {

    @testSetup
    static void testPTCustomMetaData() {
        CustomMetadataService cms = new  CustomMetadataService('DiJONES_Real_Estate','DiJONES_Real_Estate','DiJONES Real Estate','Property Tree');
        Manage_Triggers__c cs1 = new Manage_Triggers__c();
        cs1.Name = 'AccountTrigger';
        cs1.isActive__c = true;
        insert cs1;
        insert new Account(Name = 'Test', API_Ownership_External_ID__c = 'b8bfa088-80fb-e911-b5e9-281878b47bfb');
    }
    
    @isTest
    static void testCompanyUpsertSuccess() {	
        
        String apiKeyServiceJson=		'[{'+
            '"key": "4191e0dd-e77f-44a1-86ba-dfb808abfd4b:2ad6fe8a-29d6-48c9-860a-d8699d1f8610",'+
            '"company_name": "Raine & Horne Newtown",'+
            '"activation_date": "2021-10-21T01:05:05.791859+00:00"'+
            '}, {'+
            '"key": "4191e0dd-e77f-44a1-86ba-dfb808abfd4b:76958256-3742-47b4-9c78-10a99f5a4801",'+
            '"company_name": "Raine & Horne City Living",'+
            '"activation_date": "2022-07-04T04:55:44.6610641+00:00"'+
            '}, {'+
            '"key": "4191e0dd-e77f-44a1-86ba-dfb808abfd4b:8f0aaf95-13cc-4b1a-85d9-a2ab39fb8d09",'+
            '"company_name": "Mint360property",'+
            '"activation_date": "2022-06-30T06:46:02.027235+00:00"'+
            '}]';
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Tree',apiKeyServiceJson,true));
        system.schedule('CompanyUpsertSchedulerTest', '0 0 22 ? * * *', new CompanyUpsertScheduler());   
        Test.stopTest();
    }
    
    @isTest
    static void testCompanyUpsertFailure() {	
        String apiKeyServiceJson=		'[{'+
            '"key": "4191e0dd-e77f-44a1-86ba-dfb808abfd4b:2ad6fe8a-29d6-48c9-860a-d8699d1f8610",'+
            '"company_name": "Raine & Horne Newtown",'+
            '"activation_date": "2021-10-21T01:05:05.791859+00:00"'+
            '}, {'+
            '"key": "4191e0dd-e77f-44a1-86ba-dfb808abfd4b:76958256-3742-47b4-9c78-10a99f5a4801",'+
            '"company_name": "Raine & Horne City Living",'+
            '"activation_date": "2022-07-04T04:55:44.6610641+00:00"'+
            '}, {'+
            '"key": "4191e0dd-e77f-44a1-86ba-dfb808abfd4b:8f0aaf95-13cc-4b1a-85d9-a2ab39fb8d09",'+
            '"company_name": "Mint360property",'+
            '"activation_date": "2022-06-30T06:46:02.027235+00:00"'+
            '}]';
        
        Test.startTest();   		
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PTPropsMockHttpResponseGenerator('Property Tree',apiKeyServiceJson,false));
        system.schedule('CompanyUpsertSchedulerTest', '0 0 22 ? * * *', new CompanyUpsertScheduler());   
        Test.stopTest();
    }
}