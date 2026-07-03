public class CustomSiteCreationController {
    
    @AuraEnabled
    public static List<Account> fetchAccountRecord(String recordId){
        return [SELECT Id, Name FROM Account WHERE Id =: recordId LIMIT 1];
    }
    
    @AuraEnabled
    public static List<RecordType> fetchAllRecordType(String objName){
        return [SELECT Id, Name, SobjectType FROM RecordType WHERE SobjectType=:objName AND IsActive=true];
    }

    @AuraEnabled
    public static List<sirenum__Site__c> fetchExistingAddress(String recordId){
        return [SELECT Id, sirenum__Street_Address__c, sirenum__City__c, sirenum__County__c, sirenum__Postal_Code__c, sirenum__Country__c, IP_InvoiceAddressStreet__c, IP_InvoiceAddressCity__c, IP_InvoiceAddressCounty__c,IP_InvoiceAddressPostcode__c, IP_InvoiceAddressCountry__c FROM sirenum__Site__c WHERE Id =: recordId LIMIT 1];
    }

    @AuraEnabled
    public static Boolean updateLocationAddress(String recordId, String addressType, String street, String city, 
                                        String county, String postalCode, String country) {

                                            Boolean updated = false;
                                            
        System.debug('=======Address Update Parameters - ' + 
             'RecordId: ' + recordId + ', ' +
             'Street: ' + street + ', ' +
             'City: ' + city + ', ' +
             'County: ' + county + ', ' +
             'PostalCode: ' + postalCode + ', ' +
             'Country: ' + country);
        try {
            if (String.isBlank(recordId)) {
                throw new AuraHandledException('Record ID cannot be blank');
            }

            sirenum__Site__c site = [
                SELECT Id, sirenum__Street_Address__c, sirenum__City__c, sirenum__County__c, sirenum__Postal_Code__c, sirenum__Country__c, IP_InvoiceAddressStreet__c, IP_InvoiceAddressCity__c, IP_InvoiceAddressCounty__c,IP_InvoiceAddressPostcode__c, IP_InvoiceAddressCountry__c  FROM sirenum__Site__c WHERE Id = :recordId LIMIT 1];

            if (site != null) {
                if(addressType == 'Location'){
                    if (street != null) site.sirenum__Street_Address__c = street;
                    if (city != null) site.sirenum__City__c = city;
                    if (county != null) site.sirenum__County__c = county;
                    if (postalCode != null) site.sirenum__Postal_Code__c = postalCode;
                    if (country != null) site.sirenum__Country__c = country;
                    update site;
                    updated = true;
                }else if(addressType == 'Invoice'){
                    if (street != null) site.IP_InvoiceAddressStreet__c = street;
                    if (city != null) site.IP_InvoiceAddressCity__c = city;
                    if (county != null) site.IP_InvoiceAddressCounty__c = county;
                    if (postalCode != null) site.IP_InvoiceAddressPostcode__c = postalCode;
                    if (country != null) site.IP_InvoiceAddressCountry__c = country;
                    update site;
                    updated = true;
                }
                return updated;
            } else {
                throw new AuraHandledException('Site record not found with ID: ' + recordId);
            }
        } catch (Exception e) {
            System.debug('Error updating site address: ' + e.getMessage() + '\n' + e.getStackTraceString());
            throw new AuraHandledException('Error updating address: ' + e.getMessage());
        }
    }

}