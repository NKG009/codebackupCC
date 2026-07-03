@isTest
public class Test_PassClient {
    @testSetup static void generateTestData() {
        insert new User_Profile_Id__c(
            Name = 'User Portal',
            Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal'].Id
        );

        IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
        setting.IP_LastTransmissionDate__c = Date.newInstance(2019,07,01);
        setting.IP_OutboundErrorEmailAddress__c = 'test@test.com';
        insert setting;

        insert new Payroll_Swtich__c(Name = 'Stoppayroll', Batch_check__c = false);
        insert new IP_CompanyCode__c(Name = 'CompanyCode', IP_CompanyCodeValue__c = 'BAL');

        Profile p1 = [SELECT Name FROM Profile WHERE Name = 'Back Office'];
        User usr1 = new User(
            LastName = 'himanshu',
            FirstName = 'JASON',
            Alias = 'jliv1',
            Email = 'mm1.sf@outlook.com',
            Username = 'dummyEmail989@email.com',
            ProfileId = p1.Id,
            TimeZoneSidKey = 'GMT',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LocaleSidKey = 'en_US',
            IP_TempestDepartment__c = '1062',
            Brand__c = 'Blue Arrow',
            IP_TempestDivision__c = 'NTS',
            Department = '1062',
            IP_PassToTempest__c = true
        );
        insert usr1;
        
        IP_BranchStatus__c b = new IP_BranchStatus__c();
        b.IP_BranchID__c = '1062';
        b.Name = 'Test';
        insert b;
        
        RecordType accountRec1 = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' And DeveloperName = 'Account'];

        Account acc1 = new Account(Name = 'Capita', RecordTypeId = accountRec1.Id);
        insert acc1;

        RecordType maincondRec = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' And DeveloperName = 'Contact'];
        Contact maincon = new Contact(RecordTypeId = maincondRec.Id, FirstName = 'Test', LastName = 'Main Contact', PPE_Type__c = 'Polo shirt', AccountId = acc1.id);
        insert maincon;

        IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
        topaz.IP_PaymentTerms__c = 123456789123456.0;
        insert topaz;

        sirenum__Site__c site = new sirenum__Site__c();
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c = acc1.id;
        site.IP_ClientIDLegacy__c = '123';
        site.IP_ClientInvoiceName__c = 'test abc';
        site.IP_PublicSector__c = 'No';
        site.IP_InvoiceContactText__c = 'Contact 1';
        site.IP_MainContact__c = maincon.id;
        site.sirenum__Street_Address__c = 'Street1';
        site.sirenum__City__c = 'City 1';
        site.IP_InvoiceAddressCountry__c = 'UK';
        site.sirenum__Postal_Code__c = 'ABC1234';
        site.IP_InvoiceContactEmail__c = 'test@abc.com';
        site.IP_InvoiceAddressStreet__c = 'Street2';
        site.IP_InvoiceAddressCity__c = 'City2';
        site.IP_InvoiceAddressPostcode__c = 'XYZ';
        site.IP_PassClientToTempest__c = false;
        site.OwnerId = usr1.Id;
        insert site;
    }

    static testmethod void validateFunctionality_Test_Case_One() {
        sirenum__Site__c theSite = [SELECT Id FROM sirenum__Site__c LIMIT 1];
        
        Test.startTest();

        theSite.IP_EmergencyPullClient__c = false;
        theSite.IP_PassClientToTempest__c = true;
        theSite.IP_PassClientAddressToTempest__c = true;
        theSite.IP_EmergencyPullClientAddress__c = false;
        update theSite;
        
        Test.stopTest();
    }


    static testmethod void validateFunctionality_Test_Case_Two() {
        sirenum__Site__c theSite = [SELECT Id FROM sirenum__Site__c LIMIT 1];
        
        Test.startTest();

        theSite.IP_EmergencyPullClient__c = true;
        theSite.IP_PassClientToTempest__c = false;
        theSite.IP_PassClientAddressToTempest__c = false;
        theSite.IP_EmergencyPullClientAddress__c = true;
        update theSite;
        
        Test.stopTest();
    }
}