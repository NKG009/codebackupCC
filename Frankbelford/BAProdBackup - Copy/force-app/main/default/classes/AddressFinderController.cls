/**
 * Created by mrahman on 2020-11-26.
 */

public with sharing class AddressFinderController {

    /**
     * @return - the map contains 4 items
     * BaseURL - Postcode anywhere base service URL
     * FindAddress - URL sub string to complete the URL
     * RetrieveAddress - URL sub string to complete the URL
     * ServiceKey - Service key which is usually stored in PCA custom settings
     */
    @AuraEnabled
    public static Map<String, String> getServiceDetails(){
        Map<String, String> serviceDetails = new Map<String, String>();
        String key = pca__PostcodeAnywhereSettings__c.getInstance().pca__Key__c;

        for(AddressFinderMdt__mdt af : [SELECT DeveloperName, Value__c FROM AddressFinderMdt__mdt WHERE IsActive__c = true]){
            serviceDetails.put(af.DeveloperName, af.Value__c);
        }
        serviceDetails.put('ServiceKey', key);
        return serviceDetails;
    }

    @AuraEnabled
    public static Map<String, Object> getAddressDetails(Id recordId){
        SObjectType st = Id.valueOf(recordId).getSobjectType();
        String address;
        switch on String.valueOf(st) {
            when 'Account' {
                System.debug('account ' + st);
                Account a = [SELECT BillingAddress, BillingCity, BillingState,  BillingPostalCode,  BillingCountry, BillingStreet, BillingLatitude, BillingLongitude
                FROM Account WHERE Id =: recordId];
                address = JSON.serializePretty(a.BillingAddress);
            }
            when 'Contact' {
                Contact c = [SELECT Id ,MailingAddress ,MailingCountry ,MailingStreet ,MailingCity ,MailingState ,MailingPostalCode ,MailingLongitude ,MailingLatitude
                FROM Contact WHERE Id =: recordId];
                address = JSON.serializePretty(c.MailingAddress);
            }
            when 'IP_PayProfile__c' {
                System.debug('Update Pay Profile');
                IP_PayProfile__c p = [SELECT IP_BusinessAddressPostcode__c
                                            ,IP_BusinessAddressTown__c
                                            ,IP_BusinessAddressLine1__c
                                            ,IP_BusinessAddressLine2__c
                                            ,IP_BusinessAddressCounty__c
                                        FROM IP_PayProfile__c WHERE Id=: recordId];
                address = JSON.serialize(p);
                address = address.replace('IP_BusinessAddressPostcode__c','postalCode');
                address = address.replace('IP_BusinessAddressTown__c','city');
                address = address.replace('IP_BusinessAddressLine1__c','company');
                address = address.replace('IP_BusinessAddressLine2__c','street');
                address = address.replace('IP_BusinessAddressCounty__c','state');
            }
            when 'sirenum__Site__c' {
                System.debug('Update Pay Profile');
                sirenum__Site__c s = [SELECT IP_InvoiceAddressCity__c
                                            ,IP_InvoiceAddressStreet__c
                                            ,IP_InvoiceAddressPostcode__c
                                            ,IP_InvoiceAddressCountry__c
                                            ,IP_InvoiceAddressCounty__c
                                        FROM sirenum__Site__c WHERE Id =: recordId];
                address = JSON.serializePretty(s);
                address = address.replace('IP_InvoiceAddressPostcode__c','postalCode');
                address = address.replace('IP_InvoiceAddressCity__c','city');
                address = address.replace('IP_InvoiceAddressCountry__c','country');
                address = address.replace('IP_InvoiceAddressStreet__c','street');
                address = address.replace('IP_InvoiceAddressCounty__c','state');
            }
            when null {
                System.debug('null - did not update the address');
                //throw new Exception();
            }
            when else {
                System.debug('Default - did not update the address');
                //updateRecord(recordId, pcaAddressName, '', addressMap);
            }
        }
        return (Map<String, Object>)JSON.deserializeUntyped(address);
    }

    @AuraEnabled
    public static void updateAddress(Id recordId, String addressJSON){
        System.debug('recordId: ' + recordId + ' addressJSON:\n' + addressJSON);
        //IDENTIFY SOBJECT TYPE
        Map<String, Object> addressMap = (Map<String, Object>)JSON.deserializeUntyped(addressJSON);
        SObjectType st = Id.valueOf(recordId).getSobjectType();

        switch on String.valueOf(st) {
            when 'Account' {
                System.debug('account ' + st);
                Account a = [SELECT BillingCity, BillingState,  BillingPostalCode,  BillingCountry, BillingStreet, BillingLatitude, BillingLongitude
                                FROM Account WHERE Id =: recordId];
                a.BillingStreet = getStreet(addressMap);
                a.BillingCity = String.valueOf(addressMap.get('City'));
                a.BillingPostalCode = String.valueOf(addressMap.get('PostalCode'));
                a.BillingState = String.valueOf(addressMap.get('ProvinceName'));
                a.BillingCountry = String.valueOf(addressMap.get('CountryName'));
                a.BillingLongitude = null;
                a.BillingLatitude = null;
                update a;
                a = [SELECT BillingCity, BillingState,  BillingPostalCode,  BillingCountry, BillingStreet, BillingLatitude, BillingLongitude
                        FROM Account WHERE Id =: recordId];
                a.BillingLongitude = null;
                a.BillingLatitude = null;
                update a;
            }
            when 'Contact' {
                Contact c = [SELECT Id ,MailingCountry ,MailingStreet ,MailingCity ,MailingState ,MailingPostalCode ,MailingLongitude ,MailingLatitude
                                FROM Contact WHERE Id =: recordId];
                c.MailingStreet = getStreet(addressMap);
                c.MailingCity = String.valueOf(addressMap.get('City'));
                c.MailingPostalCode = String.valueOf(addressMap.get('PostalCode'));
                c.MailingState = String.valueOf(addressMap.get('ProvinceName'));
                c.MailingCountry = String.valueOf(addressMap.get('CountryName'));
                c.MailingLongitude = null;
                c.MailingLatitude = null;
                update c;
                c = [SELECT Id ,MailingCountry ,MailingStreet ,MailingCity ,MailingState ,MailingPostalCode ,MailingLongitude ,MailingLatitude
                        FROM Contact WHERE Id =: recordId];
                c.MailingLongitude = null;
                c.MailingLatitude = null;
                update c;
            }
            when 'IP_PayProfile__c' {
                System.debug('Update Pay Profile');
                IP_PayProfile__c p = [SELECT Id, Name ,IP_BusinessAddressPostcode__c
                                            ,IP_BusinessAddressTown__c
                                            ,IP_BusinessAddressLine1__c
                                            ,IP_BusinessAddressLine2__c
                                            ,IP_BusinessAddressCounty__c

                                        FROM IP_PayProfile__c WHERE Id=: recordId];
                p.IP_BusinessAddressPostcode__c = String.valueOf(addressMap.get('PostalCode'));
                p.IP_BusinessAddressTown__c = String.valueOf(addressMap.get('City'));
                p.IP_BusinessAddressLine1__c = String.isNotBlank(getValue(addressMap, 'Company'))?getValue(addressMap, 'Company').removeStart(', '):String.valueOf(addressMap.get('Line1'));
                p.IP_BusinessAddressLine2__c = String.isNotBlank(getValue(addressMap, 'Company'))?String.valueOf(addressMap.get('Line1'))+getValue(addressMap,'Line2'):String.valueOf(addressMap.get('Line2'));
                p.IP_BusinessAddressCounty__c = String.valueOf(addressMap.get('Province'));
                update p;
            }
            when 'sirenum__Site__c' {
                System.debug('Update Pay Profile');
                sirenum__Site__c s = [SELECT Id, Name ,IP_InvoiceAddressCity__c
                                            ,IP_InvoiceAddressStreet__c
                                            ,IP_InvoiceAddressPostcode__c
                                            ,IP_InvoiceAddressCountry__c
                                            ,IP_InvoiceAddressCounty__c
                                        FROM sirenum__Site__c WHERE Id =: recordId];
                s.IP_InvoiceAddressCity__c = String.valueOf(addressMap.get('City'));
                s.IP_InvoiceAddressStreet__c = getStreet(addressMap);
                s.IP_InvoiceAddressPostcode__c = String.valueOf(addressMap.get('PostalCode'));
                s.IP_InvoiceAddressCountry__c = String.valueOf(addressMap.get('CountryName'));
                s.IP_InvoiceAddressCounty__c = String.valueOf(addressMap.get('Province'));
                update s;
            }
            when null {
                System.debug('null - did not update the address');
                //throw new Exception();
            }
            when else {
                System.debug('Default - did not update the address');
                //updateRecord(recordId, pcaAddressName, '', addressMap);
            }
        }
    }

    /**
     * Use to get single line of string if all 5 line of address needs to be populated in one field
     */
    private static String getStreet(Map<String, Object> addressMap){
        String street = String.valueOf(addressMap.get('Line1')) +
                                getValue(addressMap, 'Line2') +
                                getValue(addressMap, 'Line3') +
                                getValue(addressMap, 'Line4') +
                                getValue(addressMap, 'Line5');
        return street;
    }

    /**
     * Use this method for address line
     */
    private static String getValue(Map<String, Object> addressMap, String key){
        String strValue = String.isNotBlank(String.valueOf(addressMap.get(key)))?', '+String.valueOf(addressMap.get(key)):'';
        return strValue;
    }
}