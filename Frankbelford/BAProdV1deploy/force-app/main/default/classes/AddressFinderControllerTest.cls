/**
 * Created by mrahman on 2020-12-03.
 */

@IsTest
private class AddressFinderControllerTest {
    @IsTest
    static void getServiceDetailsTest(){
        Map<String, String> sdMap = AddressFinderController.getServiceDetails();
        System.assert(sdMap.keySet().size()>0, 'No service details returned');
    }

    @IsTest
    static void updateAddressTest(){
        String addressJSON = '{\n' +
                ' "Company":"Blue Arrow",\n' +
                ' "Street":"Capability Green",\n' +
                ' "City":"Luton",\n' +
                ' "Line1":"800 Capability Green",\n' +
                ' "Line2":"",\n' +
                ' "Line3":"",\n' +
                ' "Line4":"",\n' +
                ' "Line5":"",\n' +
                ' "Province":"Bedfordshire",\n' +
                ' "ProvinceName":"Bedfordshire",\n' +
                ' "PostalCode":"LU1 3BA",\n' +
                ' "CountryName":"United Kingdom",\n' +
                ' "modelNumber" : "123"\n' +
                '}';
        //ACCOUNT CHECKS
        Account client = [SELECT Id FROM Account WHERE RecordType.Name='Account' LIMIT 1];
        AddressFinderController.updateAddress(client.Id, addressJSON);

        Account clientAfter = [SELECT Id, BillingCity, BillingPostalCode FROM Account WHERE RecordType.Name='Account' LIMIT 1];
        Map<String, Object> adrsMap = (Map<String, Object>)JSON.deserializeUntyped(addressJSON);
        String city = String.valueOf(adrsMap.get('City'));
        System.assertEquals(city,clientAfter.BillingCity,'City did not match');
        System.assertEquals(String.valueOf(adrsMap.get('PostalCode')),clientAfter.BillingPostalCode,'Postcode did not match');

        //CANDIDATE CHECKS
        Contact worker = [SELECT Id FROM Contact WHERE RecordType.Name='Candidate' LIMIT 1];
        AddressFinderController.updateAddress(worker.Id, addressJSON);

        Contact workerAfter = [SELECT Id, MailingStreet, MailingCity, MailingPostalCode FROM Contact WHERE RecordType.Name='Candidate' LIMIT 1];
        System.assertEquals(city,workerAfter.MailingCity,'City did not match');
        System.assertEquals(String.valueOf(adrsMap.get('PostalCode')),workerAfter.MailingPostalCode,'Postcode did not match');

        //PAY PROFILE CHECKS
        IP_PayProfile__c pp = [SELECT Id FROM IP_PayProfile__c LIMIT 1];
        AddressFinderController.updateAddress(pp.Id, addressJSON);

        IP_PayProfile__c ppAfter = [SELECT Id, IP_BusinessAddressPostcode__c
                                        ,IP_BusinessAddressTown__c
                                        ,IP_BusinessAddressLine1__c
                                        ,IP_BusinessAddressLine2__c
                                        ,IP_BusinessAddressCounty__c
                                    FROM IP_PayProfile__c WHERE Id =: pp.Id];
        System.assertEquals(city,workerAfter.MailingCity,'City did not match');
        System.assertEquals(String.valueOf(adrsMap.get('PostalCode')),ppAfter.IP_BusinessAddressPostcode__c,'Postcode did not match');

        //SITE CHECKS
        sirenum__Site__c site = [SELECT Id FROM sirenum__Site__c LIMIT 1];
        AddressFinderController.updateAddress(site.Id, addressJSON);

        sirenum__Site__c siteAfter = [SELECT Id, IP_InvoiceAddressCity__c
                                            ,IP_InvoiceAddressStreet__c
                                            ,IP_InvoiceAddressPostcode__c
                                            ,IP_InvoiceAddressCountry__c
                                            ,IP_InvoiceAddressCounty__c
                                    FROM sirenum__Site__c WHERE Id =: site.Id];
        System.assertEquals(city,siteAfter.IP_InvoiceAddressCity__c,'City did not match');
        System.assertEquals(String.valueOf(adrsMap.get('PostalCode')),siteAfter.IP_InvoiceAddressPostcode__c,'Postcode did not match');
    }

    @IsTest
    static void getAddressDetailsTest(){
        Account client = [SELECT Id, BillingCity, BillingPostalCode FROM Account WHERE RecordType.Name='Account' LIMIT 1];
        System.debug('client >>> ' + client);

        //String returned = AddressFinderController.getAddressDetails(client.Id);

        Map<String, Object> adrsMap = AddressFinderController.getAddressDetails(client.Id); //(Map<String, Object>)JSON.deserializeUntyped(returned);
        System.debug('adrsMap >>> ' + adrsMap);

        String city = String.valueOf(adrsMap.get('city'));
        System.assertEquals(city,client.BillingCity,'City did not match');
        System.assertEquals(String.valueOf(adrsMap.get('postalCode')),client.BillingPostalCode,'Postcode did not match');

        //CANDIDATE
        Contact worker = [SELECT Id, MailingCity, MailingPostalCode FROM Contact WHERE RecordType.Name='Candidate' LIMIT 1];
        //returned = AddressFinderController.getAddressDetails(worker.Id);
        adrsMap = AddressFinderController.getAddressDetails(worker.Id); //(Map<String, Object>)JSON.deserializeUntyped(returned);

        city = String.valueOf(adrsMap.get('city'));
        System.assertEquals(city,worker.MailingCity,'City did not match');
        System.assertEquals(String.valueOf(adrsMap.get('postalCode')),worker.MailingPostalCode,'Postcode did not match');

        //PAY PROFILE
        IP_PayProfile__c pp = [SELECT IP_BusinessAddressPostcode__c ,IP_BusinessAddressTown__c ,IP_BusinessAddressLine1__c ,IP_BusinessAddressLine2__c ,IP_BusinessAddressCounty__c
                                FROM IP_PayProfile__c];
        //returned = AddressFinderController.getAddressDetails(pp.Id);
        adrsMap = AddressFinderController.getAddressDetails(pp.Id); //(Map<String, Object>)JSON.deserializeUntyped(returned);

        city = String.valueOf(adrsMap.get('city'));
        System.assertEquals(city,pp.IP_BusinessAddressTown__c,'City did not match');
        System.assertEquals(String.valueOf(adrsMap.get('postalCode')),pp.IP_BusinessAddressPostcode__c,'Postcode did not match');

        sirenum__Site__c site = [SELECT Id, IP_InvoiceAddressCity__c ,IP_InvoiceAddressStreet__c ,IP_InvoiceAddressPostcode__c ,IP_InvoiceAddressCountry__c ,IP_InvoiceAddressCounty__c
                                   FROM sirenum__Site__c LIMIT 1];
        adrsMap = AddressFinderController.getAddressDetails(site.Id);
        city = String.valueOf(adrsMap.get('city'));
        System.assertEquals(city,site.IP_InvoiceAddressCity__c,'Site - City did not match');
        System.assertEquals(String.valueOf(adrsMap.get('postalCode')),site.IP_InvoiceAddressPostcode__c,'Site - Postcode did not match');
    }

    @TestSetup
    static void setupTestData(){
        Account client = TestDataFactory.createClients(1)[0];
        client.BillingPostalCode = 'LU1 3BA';
        client.BillingCity = 'Luton';
        client.BillingStreet = '800 Capability Green';
        client.BillingCountry = 'United Kingdom';
        Account candidateAccount = TestDataFactory.createCandidateAccount(1)[0];
        insert new List<Account> {candidateAccount, client};
        TestDataFactory.setupCustomSettings(candidateAccount.Id);
        TestDataFactory.setupUserProfileCustomSettings();

        Contact clientContact = TestDataFactory.createContact(client.Id, 1)[0];
        Contact worker = TestDataFactory.createCandidate(candidateAccount.Id, 1)[0];
        worker.MailingPostalCode = 'LU1 3BA';
        worker.MailingCity = 'Luton';
        worker.MailingStreet = '800 Capability Green';
        worker.MailingCountry = 'United Kingdom';
        insert new List<Contact>{worker, clientContact};
        IP_PayProfile__c ppLTD = TestDataFactory.createPayProfileLtd(worker.Id,1)[0];
        ppLTD.IP_BusinessAddressPostcode__c = 'LU1 3BA';
        ppLTD.IP_BusinessAddressTown__c = 'Luton';
        ppLTD.IP_BusinessAddressLine1__c = '800 Capability Green';
        ppLTD.IP_BusinessAddressLine2__c = '';
        ppLTD.IP_BusinessAddressCounty__c = 'United Kingdom';
        insert ppLTD;

        IP_TopazGlobalClientInformation__c topzClientInfo = TestDataFactory.createTopaz(1)[0];
        topzClientInfo.Name = client.Name;
        topzClientInfo.IP_SalesLedgerNumber__c='345432';
        insert topzClientInfo;

        sirenum__Site__c site = TestDataFactory.createSites(client.Id, topzClientInfo.Id, 1)[0];
        insert site;
    }
}